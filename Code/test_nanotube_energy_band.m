close all;
clear all;

CNT = Nanotube(2,7);
CNT.plot_energy_bands;
CNT.plot_valence_and_conduction_bands;
CNT.band_gap
CNT.effective_mass % in units of m_e