from __future__ import annotations
import math
from attrs import define


def n_lattice_points(length: float, lattice_distance: float) -> int:
    # Highest amount of lattice points in given length for given lattice
    # distance
    return math.floor(length / lattice_distance)


def possible_length(length: float, lattice_distance: float) -> float:
    # Highest possible length realisable with given lattice distance, not
    # exceeding the given length
    return n_lattice_points(length, lattice_distance) * lattice_distance


def lambda_by_geometry(
    d_ch: float, d_ox: float, eps_ch: float, eps_ox: float, geometry: str
):
    if geometry == "single gate":
        return lambda_single_gate(d_ch, d_ox, eps_ch, eps_ox)
    if geometry == "double gate":
        return lambda_double_gate(d_ch, d_ox, eps_ch, eps_ox)
    if geometry in ["triple gate", "tri-gate"]:
        return lambda_triple_gate(d_ch, d_ox, eps_ch, eps_ox)
    if geometry in ["nano-wire", "nanowire"]:
        return lambda_nanowire(d_ch, d_ox, eps_ch, eps_ox)
    raise ValueError("invalid geometry")


def lambda_double_gate(d_ch: float, d_ox: float, eps_ch: float, eps_ox: float) -> float:
    return math.sqrt(d_ox * d_ch * eps_ch / eps_ox / 2)


def lambda_nanowire(d_ch: float, d_ox: float, eps_ch: float, eps_ox: float) -> float:
    return math.sqrt(eps_ch * d_ch * d_ch / 8 / eps_ox * math.log(1 + 2 * d_ox / d_ch))


def lambda_single_gate(d_ch: float, d_ox: float, eps_ch: float, eps_ox: float) -> float:
    return math.sqrt(d_ox * d_ch * eps_ch / eps_ox)


def lambda_triple_gate(d_ch: float, d_ox: float, eps_ch: float, eps_ox: float) -> float:
    return math.sqrt(d_ox * d_ch * eps_ch / eps_ox / 3)


def lambda_arg_value(arg: Lambda | float, lambda_val: float) -> float:
    if isinstance(arg, Lambda):
        return arg.value * lambda_val
    else:
        return arg


def nm_to_m(length: float) -> float:
    return length / 1e9


def J_to_eV(energy: float) -> float:
    return energy / 1.602176565e-19


@define
class Lambda:
    value: float
