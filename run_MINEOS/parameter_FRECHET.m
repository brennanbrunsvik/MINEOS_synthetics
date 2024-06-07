%% Setup Parameters for running MINEOS to calculate senstivity kernels, dispersion, and synthetics
% brb20240607 This "script" is only going to READ the pertinent values. 
% Those values are all defined in parameter_FRECHET_save.m 
% This allows flexibility, so we can change the values in this .mat file
% and have all ~60 instances of calling "parameter_FRECHET" give consistent
% variable values. 

save_path = './parameter_FRECHET_vals.mat'; 
load(save_path); 

