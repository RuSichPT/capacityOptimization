clear;clc;close all;
%% dipole
dipole = qd_arrayant.generate('dipole');
[dipBWaz, dipBWel] = dipole.calc_beamwidth();
dipole.visualize();

[~, par] = qd_arrayant.generate('custom', dipBWaz, dipBWel, 0);
parDipole.A = 1;
parDipole.B = par.B;
parDipole.C = par.C;
parDipole.D = 0;

parametric = qd_arrayant.generate('parametric', parDipole.A, parDipole.B, parDipole.C, parDipole.D);
parametric.visualize;
%% path
BWaz = 40;
BWel = 40;
[patch, ~] = qd_arrayant.generate('custom', BWaz, BWel, 0);
[patchBWaz, patchBWel] = patch.calc_beamwidth();
patch.visualize();

[custom, par] = qd_arrayant.generate('custom', patchBWaz, patchBWel, 0);
parPatch.A = 1;
parPatch.B = par.B;
parPatch.C = par.C;
parPatch.D = par.D;
parametric = qd_arrayant.generate('parametric', parPatch.A, parPatch.B, parPatch.C, parPatch.D);
parametric.visualize;
%% out
parDipole
parPatch