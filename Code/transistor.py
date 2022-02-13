from __future__ import annotations
import math
from typing import Iterable, Optional
import scipy.sparse as sp
import scipy.sparse.linalg
import numpy as np
import numpy.typing

# from attrs import define, field
from region import Region
import helper
import constants

from helper import Lambda


class Transistor:
    # #
    #     source: Region = (field(init=False),)
    #     gate: Region = (field(init=False),)
    #     drain: Region = (field(init=False),)

    # _is_self_consistent: bool = (field(init=False),)
    # _phi_changed_since_DOS_calculation: bool = (field(init=False),)
    # _current_is_up_to_date: bool = (field(init=False),)

    # Default material properties for silicon
    def __init__(
        self,
        /,
        V_ds: float,  # drain-source voltage
        V_g: float,  # gate voltage
        d_ch: float,
        d_ox: float,
        a: float,
        *,
        geometry: str = "single gate",
        T: float = 300,  # K
        m=0.2 * constants.m_e,
        l_ch: Lambda | float = Lambda(5),
        l_ds: Lambda | float = Lambda(5),  # in lambda_ds
        E_min=None,
        E_max=None,
        n_energy_steps=None,
        dE=5e-4,  # eV, mutually exclusive with n_energy_steps, checks are done in constructor
        E_f=0.1,  # == 0.1eV above conduction band in source
        E_g=1.14,
        transmission_probability=None,
        eps_ch=11.2,
        eps_ox=3.9,
        lambda_ds: Lambda | float = Lambda(1),  # in lambda_ch
        # carrier_charge_in_e: int = field(init=False),
        current=None,
        newton_step_size=0.3,  # part of delta phi that is taken in one newton-step
        self_consistency_limit=1e-3,  # eV, self-consistency reached when max(abs(delta_phi)) <= self_consistency_limit
        coupling_left=1,
        coupling_right=1,
        eta=1e-8,
        dopant_type: str = "n",
    ) -> None:
        ## private flags to not unnecessarily recalculate data
        self._is_self_consistent = False
        self._phi_changed_since_DOS_calculation = True
        self._current_is_up_to_date = False

        if dE is not None and n_energy_steps is not None:
            raise ValueError("n_energy_steps and dE are mutually exclusive parameters")

        # ## pre-initialisation work
        # lambda inside channel
        lambda_ = helper.lambda_by_geometry(d_ch, d_ox, eps_ch, eps_ox, geometry)
        # Parse inputs that are either numeric or a string like '3.2 lambda'
        lambda_ds = helper.lambda_arg_value(lambda_ds, lambda_)

        # ## determine ranges
        l_ch = helper.lambda_arg_value(l_ch, lambda_)
        l_ch = helper.possible_length(l_ch, a)
        # l_ds is dependent upon lambda_ds
        l_ds = helper.lambda_arg_value(l_ds, lambda_ds)
        l_ds = helper.lambda_arg_value(l_ds, lambda_ds)

        l_ds = helper.possible_length(l_ds, a)

        n_ds = helper.n_lattice_points(l_ds, a)
        n_ch = helper.n_lattice_points(l_ch, a)

        # p or n-type
        assert dopant_type in ["n", "p"]
        carrier_charge_in_e = -1 if dopant_type == "n" else 1

        self.source = Region(0, n_ds)
        self.gate = Region(n_ds, n_ds + n_ch)
        self.drain = Region(n_ds + n_ch, 2 * n_ds + n_ch)

        self.V_ds = V_ds
        self.V_g = V_g
        self.d_ch = d_ch
        self.d_ox = d_ox
        self.a = a
        self.geometry = geometry
        self.T = T
        self.m = m
        self.l_ch = l_ch
        self.l_ds = l_ds
        self._E_min = E_min
        self._E_max = E_max
        self._n_energy_steps = n_energy_steps
        self._dE = dE
        self.E_f = E_f
        self.E_g = E_g
        self.transmission_probability = transmission_probability
        self.eps_ch = eps_ch
        self.eps_ox = eps_ox
        self.lambda_ = lambda_
        self.lambda_ds = lambda_ds
        self.carrier_charge_in_e = carrier_charge_in_e
        self.current = current
        self.newton_step_size = newton_step_size
        self.self_consistency_limit = self_consistency_limit
        self.coupling_left = coupling_left
        self.coupling_right = coupling_right
        self.eta = eta
        self.dopant_type = dopant_type

        ## Calculate some data from the above

        self.set_phi(self.poisson())
        self.compute_DOS_and_related()

    # dependencies:
    # E_f
    # V_ds
    # phi
    # carrier_charge_in_e
    # T

    # function E_max_ = get.E_max(obj)
    #     if ~isempty(obj.E_max)
    #         E_max_ = obj.E_max
    #     else
    #         # in eV already!!
    #         k_B = 8.6173324e-5
    #         E_max_ = max([obj.E_f_source, obj.source.phi(1), max(obj.gate.phi), obj.E_f_drain, obj.drain.phi(end)])
    #         if sign(obj.carrier_charge_in_e) == -1
    #             E_max_ = E_max_ + 5*k_B*obj.T
    #         end
    #     end
    # end

    # function E_min_ = get.E_min(obj)
    #     if ~isempty(obj.E_min)
    #         E_min_ = obj.E_min
    #     else
    #         k_B = 8.6173324e-5
    #         E_min_ = min([obj.E_f_source, obj.source.phi(1), min(obj.gate.phi), obj.E_f_drain, obj.drain.phi(end)])
    #         if sign(obj.carrier_charge_in_e) == 1
    #             E_min_ = E_min_ - 5*k_B*obj.T
    #         end
    #     end
    # end

    # function dE_ = get.dE(obj)
    #     if ~isempty(obj.dE)
    #         dE_ = obj.dE
    #     else
    #         if isempty(obj.n_energy_steps)
    #             error('You need to specify either dE or n_energy_steps before accessing .dE')
    #         end
    #         dE_ = (obj.E_max - obj.E_min)/obj.n_energy_steps
    #     end
    # end

    # function n_steps = get.n_energy_steps(obj)
    #     if ~isempty(obj.n_energy_steps)
    #         n_steps = obj.n_energy_steps
    #     else
    #         n_steps = length(obj.energy_range) - 1 # inefficient, but robust. Should be changed regardless.
    #     end
    # end

    # function current_ = get.current(obj)
    #     if ~obj.current_is_up_to_date
    #         obj.compute_DOS_and_related
    #     end
    #     current_ = obj.current
    # end

    def poisson(self):
        # calculates conduction band
        # assuming no carrier concentration
        # output in eV (energy for an electron)
        a = self.a
        n_ges = self.n_ges
        ##

        side_diag = np.ones(n_ges) / a**2
        middle_diag = (
            self.regioned_vector(
                -1 / self.lambda_ds**2,
                -1 / self.lambda_**2,
                -1 / self.lambda_ds**2,
            )
            - 2 / a**2
        )

        top_diag = side_diag.reshape(1, -1).copy()
        top_diag[0, 1] = 2 / a**2
        bottom_diag = side_diag.reshape(1, -1)
        bottom_diag[0, -2] = 2 / a**2
        # TODO: are the diagonal indices right?
        #       Are the matrices all of the same size?
        M = sp.spdiags(
            np.concatenate(
                [
                    top_diag,
                    middle_diag.reshape(1, -1),
                    bottom_diag,
                ]
            ),
            [1, 0, -1],
            n_ges,
            n_ges,
        )
        # M = spdiags([side_diag, middle_diag, side_diag], [1,0,-1], n_ges, n_ges)
        # can't modify sparse matrix afterwards, at least not the
        # default type of sparse matrix.
        # Modifying the diagonals before construction instead.
        # M[0, 1] = 2 / a**2
        # M[-1, -2] = 2 / a**2
        # M(1,2)            = 2/a^2
        # M(n_ges, n_ges-1) = 2/a^2

        # vec = e/eps * rho + phi_offsets, assuming rho = 0 everywhere
        # signs inverted compared to transparencies, lecture 1, pg 35
        # seems to me like they are wrong, one minus gets lost from previous
        # slide
        vec = self.regioned_vector(
            0,
            -(self.phi_g + self.phi_bi) / self.lambda_**2,
            -self.phi_ds / self.lambda_ds**2,
        )

        result = sp.linalg.spsolve(M, vec)
        return result

    def regioned_vector(
        self, source_val: float, gate_val: float, drain_val: float
    ) -> np.typing.NDArray[np.float64]:
        vector = np.zeros(self.n_ges)
        vector[self.source.slice()] = source_val
        vector[self.gate.slice()] = gate_val
        vector[self.drain.slice()] = drain_val
        return vector

    def set_phi(self, phi: np.ndarray) -> None:
        ## dent correction
        # TODO: make dent correction limit adjustable
        LIMIT = 0.03
        # [min_phi_source, min_idx_source] = min(phi(self.source.start))
        # [min_phi_drain,  min_idx_drain]  = min(phi(obj.drain.range))
        min_idx_source = int(np.argmin(phi[self.source.slice()]))
        min_phi_source = phi[min_idx_source]
        min_idx_drain = int(np.argmin(phi[self.drain.slice()]))
        min_phi_drain = phi[min_idx_drain]

        max_phi_gate = np.max(phi[self.gate.slice()])

        # max_phi_gate = max(phi(obj.gate.range))

        if phi[0] - min_phi_source > LIMIT and max_phi_gate > phi[0]:
            # else this always applies
            phi[:min_idx_source] = min_phi_source

        if (
            phi[-1] - min_phi_drain > LIMIT and max_phi_gate > phi[-1]
        ):  # else this always applies
            phi[min_idx_drain:] = min_phi_drain

        ## save phi
        self.source.phi = phi[self.source.slice()]
        self.gate.phi = phi[self.gate.slice()]
        self.drain.phi = phi[self.drain.slice()]

        self.phi_changed_since_DOS_calculation = True
        self.current_is_up_to_date = False

    def set_carrier_density_and_DOS(self, carrier_density, DOS) -> None:
        self.source.carrier_density = carrier_density[self.source.slice()]
        self.gate.carrier_density = carrier_density[self.gate.slice()]
        self.drain.carrier_density = carrier_density[self.drain.slice()]

        self.source.DOS = DOS[:, self.source.slice()]
        self.gate.DOS = DOS[:, self.gate.slice()]
        self.drain.DOS = DOS[:, self.drain.slice()]

        self.phi_changed_since_DOS_calculation = False

    ## Compute and save DOS, carrier density, transmission probability and current
    def compute_DOS_and_related(self) -> None:
        ## natural constant for fermi function inlining
        k_B_eV = 8.6173324e-5

        ## Extract some relevant data
        n_ges = self.n_ges
        T = self.T
        a = self.a
        phi = self.phi()  # because obj.phi()(1) is impossible in matlab
        n_energy_steps = self.n_energy_steps

        eta = self.eta  # 1e-8 #0.001*dE # kann beliebig klein

        E_f_source = self.E_f_source
        E_f_drain = self.E_f_drain

        coupling_left = self.coupling_left
        coupling_right = self.coupling_right

        fermi_function = lambda E, E_f: 1 / (np.exp((E - E_f) / k_B_eV / T) + 1)
        ##

        # integration limits
        dE = self.dE
        energies = self.energy_range()

        t = self.t()

        ## preallocate
        density = np.zeros(n_ges)

        DOS = np.zeros((n_energy_steps, n_ges))
        transmission_probability = np.zeros((n_energy_steps + 1, 1))

        # sigma_source = sparse(1,1,          1, n_ges, n_ges)
        # sigma_drain  = sparse(n_ges, n_ges, 1, n_ges, n_ges)

        if True:
            sigma_source = sp.csc_array((n_ges, n_ges), dtype=np.complex64)
            sigma_source[0, 0] = 1
            sigma_drain = sp.csc_array((n_ges, n_ges), dtype=np.complex64)
            sigma_drain[-1, -1] = 1
        else:
            sigma_source = np.zeros((n_ges, n_ges), dtype=np.complex64)
            sigma_source[0, 0] = 1
            sigma_drain = np.zeros((n_ges, n_ges), dtype=np.complex64)
            sigma_drain[-1, -1] = 1

        ## precalculate
        side_diag = -t * np.ones(n_ges)

        diags = np.concatenate(
            [
                side_diag.reshape(1, -1),
                (phi + 2 * t).reshape(1, -1),
                side_diag.reshape(1, -1),
            ],
        )

        minus_H = -(
            sp.spdiags(
                diags,
                np.array([1, 0, -1]),
                n_ges,
                n_ges,
            )
        )
        # minus_H = - spdiags([ -t*ones(n_ges,1), ... # upper diag
        #                     phi + 2*t,        ... # middle diag
        #                     -t*ones(n_ges,1), ... # lower diag
        #             ], ...
        #             [1,0,-1], n_ges, n_ges)
        ##
        current = 0

        # first and last vec of unit matrix
        unit_vec_1n = np.zeros((n_ges, 2))
        unit_vec_1n[0, 0] = 1
        unit_vec_1n[-1, -1] = 1

        for jj, E in enumerate(energies):
            # for Ej=[energies 1:length(energies)]
            #   E = Ej(1)
            #  jj = Ej(2)
            ka_source = np.arccos(0j + 1 + (-E + phi[0]) / 2 / t).real
            ka_drain = np.arccos(0j + 1 + (-E + phi[-1]) / 2 / t).real

            E_i_eta = (E + 1j * eta) * sp.identity(n_ges, dtype=np.complex64)

            # sparse matrices of size n_ges x n_ges, one element
            sigma_source[0, 0] = (
                coupling_left * -t * np.exp(1j * ka_source)
            )  ##ok<SPRIX>
            sigma_drain[-1, -1] = (
                coupling_right * -t * np.exp(1j * ka_drain)
            )  ##ok<SPRIX>

            # invert
            # G = [G_1, G_2, ..., G_n]
            # compute vectors G_1 and G_n only. Both in one go for efficiency.
            # G_1n = (
            #     sp.linalg.inv(minus_H + E_i_eta - sigma_source - sigma_drain)
            #     @ unit_vec_1n
            # )
            G_1n = sp.linalg.spsolve(
                minus_H + E_i_eta - sigma_source - sigma_drain, unit_vec_1n
            )
            ##
            # DOS == A/2pi
            # 2 for spin degeneracy
            DOS_source = 2 * t * np.sin(ka_source) / np.pi * np.abs(G_1n[:, 1] ** 2) / a
            DOS_drain = 2 * t * np.sin(ka_drain) / np.pi * np.abs(G_1n[:, -1] ** 2) / a

            ## Save DOS
            DOS[jj, :] = DOS_source + DOS_drain

            fermi_source = fermi_function(E, E_f_source)
            fermi_drain = fermi_function(E, E_f_drain)

            ## integrate carrier density
            # spin degeneracy in DOS_source and _drain
            density = density + dE * (
                DOS_source * fermi_source + DOS_drain * fermi_drain
            )

            ## Save transmission probability
            # G_1n(1, end) = G(1,n_ges)
            transmission_probability[jj] = (
                4
                * t**2
                * np.sin(ka_source)
                * np.sin(ka_drain)
                * np.abs(G_1n[0, -1]) ** 2
            )
            ## compute current
            #  dE*e = dE in J
            #  2 for spin degeneracy
            current = (
                current
                + dE
                * constants.e
                * 2
                * constants.e
                / constants.h
                * transmission_probability[jj]
                * (fermi_source - fermi_drain)
            )

        ## Note: multiply with a to counteract the squaring, divide by area for 3D
        # TODO: factor out 1D and 3D density
        density = density / self.area_ch
        ##
        self.transmission_probability = transmission_probability

        self.current = current
        self.current_is_up_to_date = True
        self.set_carrier_density_and_DOS(density, DOS)

    @property
    def n_ges(self) -> int:
        return self.drain.range_end

    @property
    def phi_g(self) -> float:
        return -self.V_g

    @property
    def phi_bi(self) -> float:
        return self.E_f + self.E_g / 2

    @property
    def phi_ds(self) -> float:
        return -self.V_ds

    # Note: square cross section assumed.
    # could be improved
    @property
    def area_ch(self) -> float:
        return self.d_ch**2

    @property
    def E_f_source(self) -> float:
        return self.E_f

    @property
    def E_f_drain(self) -> float:
        return self.E_f + self.phi_ds

    def energy_range(self) -> numpy.typing.NDArray[np.float64]:
        return np.arange(self.E_min, self.E_max, self.dE)

    def t(self) -> float:
        a_SI = helper.nm_to_m(self.a)
        t_SI = constants.h_bar**2 / (2 * self.m * a_SI**2)
        return helper.J_to_eV(t_SI)

    def phi(self) -> np.ndarray:
        return np.concatenate([self.source.phi, self.gate.phi, self.drain.phi])

    @property
    def E_min(self) -> float:
        if self._E_min is not None:
            return self._E_min
        else:
            k_B = 8.6173324e-5
            E_min = min(
                self.E_f_source,
                self.source.phi[0],
                np.min(self.gate.phi),
                self.E_f_drain,
                self.drain.phi[-1],
            )
            if self.carrier_charge_in_e > 0:
                E_min = E_min - 5 * k_B * self.T
            return E_min

    @property
    def E_max(self) -> float:
        if self._E_max is not None:
            return self._E_max
        else:
            # in eV already!!
            k_B = 8.6173324e-5
            E_max_ = max(
                self.E_f_source,
                self.source.phi[0],
                np.max(self.gate.phi),
                self.E_f_drain,
                self.drain.phi[-1],
            )
            if self.carrier_charge_in_e < 0:
                E_max_ = E_max_ + 5 * k_B * self.T
            return E_max_

    @property
    def dE(self) -> float:
        if self._dE is not None:
            return self._dE
        else:
            if self.n_energy_steps is None:
                raise Exception(
                    "You need to specify either dE or n_energy_steps before accessing .dE"
                )

            return (self.E_max - self.E_min) / self.n_energy_steps

    @property
    def n_energy_steps(self) -> int:
        if self._n_energy_steps is not None:
            return self._n_energy_steps
        else:
            # inefficient, but robust. Should be changed regardless.
            return len(self.energy_range())

    def position_range(self):
        return np.arange(0, self.n_ges) * self.a  # - 0.5 * obj.a <-- actual position

    @property
    def DOS(self) -> np.ndarray:
        ## Access DOS.
        # Note: Arbitrary units, not correct dimensions
        if self.phi_changed_since_DOS_calculation:
            # phi and DOS inconsistent, recalculate DOS
            self.compute_DOS_and_related()

        return np.concatenate([region.DOS for region in self.regions()], 1)

    def regions(self):
        return [self.source, self.gate, self.drain]
