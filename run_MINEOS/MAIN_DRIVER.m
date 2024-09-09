% parameter_FRECHET_save([]); 
addpath('~/MATLAB/DrosteEffect-BrewerMap-3.2.5.0/'); % NEED TO CHANGE THIS PATH WHEN GETTING THIS GOING ON YOUR MACHINE


swperiods = round(logspace(log10(5),log10(200),15)); 
many_plots=false;
paramin = struct('phV_or_grV', 'phV'); 
parameter_FRECHET_save(paramin, swperiods, many_plots); 

parameter_FRECHET

a1_run_mineos_check

a3_pull_dispersion

paramin = struct('phV_or_grV', 'phV'); 
parameter_FRECHET_save(paramin, swperiods, many_plots); 
a2_mk_kernels

paramin = struct('phV_or_grV', 'grV'); 
parameter_FRECHET_save(paramin, swperiods, many_plots); 
a2_mk_kernels

a4_pull_eigenfuncs

disp('Done with Matlab test. ')

% Don't need the below functions if you don't need waveforms. 
% b1_run_idagrn
% 
% % a5_run_idagrn_branch % brb2024/05/22 I don't see this script in the Github repository. Maybe it is no longer needed. 
% 
% b2_run_idagrn_excitation