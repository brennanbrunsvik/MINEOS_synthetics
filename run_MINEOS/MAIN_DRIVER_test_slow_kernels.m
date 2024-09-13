% profile on; 

swperiods = round(logspace(log10(5),log10(200),15)); 
many_plots=false;
paramin = struct('phV_or_grV', 'phV'); 
parameter_FRECHET_save(paramin, swperiods, many_plots); 

parameter_FRECHET

a1_run_mineos_check
% 
% a3_pull_dispersion

paramin = struct('phV_or_grV', 'phV'); 
parameter_FRECHET_save(paramin, swperiods, many_plots); 
a2_mk_kernels

% profile off; 
% profile viewerc