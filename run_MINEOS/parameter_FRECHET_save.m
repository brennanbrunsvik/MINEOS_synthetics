%% Setup Parameters for running MINEOS to calculate senstivity kernels, dispersion, and synthetics
function parameter_FRECHET_save(paramin); 
    % Define the parameters that will be used while operating the Matlab
    % Mineos wrapper. These will be saved to a .mat file, which gets read
    % any time parameter_FRECHET is executed. 

    % clear all;
    addpath('/Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/run_MINEOS/functions'); % Path to matlab unctions
    addpath('/Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/run_MINEOS/functions_additional'); % More functions. These replace export_fig and save2pdf. If you have those functions elsewhere on your computer, then you should not need functions_additional in your path. brb2024/05/22. 
    path2runMINEOS = './'; % Path to this folder
    path2BIN = '/Users/brennanbrunsvik/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin'; % Path to fortran binaries
    
    save_path = './parameter_FRECHET_vals.mat'; 
    
    % Mineos table parameters
    maxN = 400000; % Estimate of max number of modes 
    minF = 0;
    maxF = 200.05; % max frequency in mHz; %10.1; %250.05; %333.4; %500.05; %200.05; %%150.05; %50.05;
    minL = 0;
    maxL = 50000;
    N_modes = 2; % <0 uses all mode branches, 1=fundamental only -------- JOSH 8/22/15
    param.CARDID = 'synthmod'; % 'synthmod'; % 'prem_35'; %'fail_H01221_90L'; %'prem_35'; %'Nomelt_taper_aniso_constxicrman_etaPREM_constxilays'; %'pa5_5km';
    
    % (1 => yes, 0 => no)
    SONLY = 1; %Spheroidal modes? (RAYLEIGH)
    TONLY = 0; %Toroidal modes? (LOVE)
    
    % for plotting kernels
    param.periods = round(logspace(log10(5),log10(200),15));
    
    ch_mode = 0; % (DO NOT CHANGE) mode branch to check for missed eigenfrequencies 0 => T0 ------- JOSH 10/7/15
    
    %% brb20240605 Trying to convert to function
    % param.maxN = maxN; 
    % param.minF = minF; 
    % param.maxF = maxF; 
    % param.minL = minL; 
    % param.maxL = maxL; 
    % param.N_modes = N_modes; 
    % param.SONLY = SONLY; 
    % param.TONLY = TONLY; 
    % param.ch_mode = ch_mode; 
    
    %% Parameters for idagrn synthetics
    param.COMP = 'Z'; % 'Z:vertical'; 'R:radial'; 'T:tangential'; Component
    param.LENGTH_HR = 1.0; %1.0; % length of seismogram in hours
    param.DT = 1.0; % 1/samplerate
    param.eventfile = 'evt_201404131236';
    param.stationfile = 'stations.stn';
    
    
    %%
    % Setup idagrn paths
    param.IDAGRN = [path2runMINEOS,'/IDAGRN/'];
    param.EVTPATH = [param.IDAGRN,'EVT_FILES/',param.eventfile];
    param.STAPATH = [param.IDAGRN,'STATION/',param.stationfile];
    param.SYNTH_OUT = [param.IDAGRN,'SYNTH/',param.CARDID,'_b',num2str(N_modes),'/',param.eventfile,'/'];
    if ~exist(param.SYNTH_OUT)
        mkdir(param.SYNTH_OUT);
    end
    
    %%
    if SONLY == 1 && TONLY == 0
        param.TYPE = 'S';
    elseif SONLY == 0 && TONLY == 1
        param.TYPE = 'T';
    else
        error('Choose SONLY or TONLY, not both');
        
    end
    
    % Setup Parameters for Initial Model
    param.CARD = [param.CARDID,'.card'];
    param.CARDPATH  = [path2runMINEOS,'/CARDS/'];
    param.TABLEPATH = [path2runMINEOS,'/MODE/TABLES/'];
    param.MODEPATH  = [path2runMINEOS,'/MODE/TABLES/MODE.in/'];
    if ~exist(param.MODEPATH)
        mkdir(param.MODEPATH);
    end
    param.RUNPATH = pwd;
    
    %% create dir for output MINEOS automatically, doesn't need to be changed.
    CARDTABLE = [param.TABLEPATH,param.CARDID,'/tables/'];
    param.CARDTABLE = CARDTABLE
    if ~exist(CARDTABLE)
        mkdir([param.TABLEPATH,param.CARDID])
        mkdir(CARDTABLE)
    end
    
    %% setup Parameters for kernals
    param.frechet = [path2runMINEOS,'/MODE/FRECHET/'];
    param.frechetpath = [path2runMINEOS,'/MODE/FRECHET/',param.CARDID,'/'];
    
    if ~exist(param.frechetpath) 
        mkdir(param.frechetpath)
    end
    
    %% setup Parameters for eigenfunctions
    param.eigpath = [path2runMINEOS,'/MODE/EIGEN/',param.CARDID,'/'];
    
    if ~exist(param.eigpath) 
        mkdir(param.eigpath)
    end
    
    %% setup Parameters for Dispersion
    param.disperspath = [path2runMINEOS,'/MODE/DISPERSION/',param.CARDID,'/'];
    
    if ~exist(param.disperspath) 
        mkdir(param.disperspath)
    end
    
    %% Turn on if only want to calculate S or T or both for mineous
    param.SMODEIN = ['s.mode',num2str(floor(minF)),'_',num2str(floor(maxF)),'_b',num2str(N_modes)];
    param.STYPEID = ['s',num2str(floor(minF)),'to',num2str(floor(maxF))];
    param.TMODEIN = ['t.mode',num2str(floor(minF)),'_',num2str(floor(maxF)),'_b',num2str(N_modes)];
    param.TTYPEID = ['t',num2str(floor(minF)),'to',num2str(floor(maxF))];%'t0to150';
    
    %% Setup paths to FORTRAN binaries
    PATH = getenv('PATH');
    if isempty(strfind(PATH,path2BIN))
    %     setenv('PATH', [PATH,':',path2BIN]);
        setenv('PATH', [path2BIN,':',PATH]);
    end
    
    save(save_path); % brb20240607 Save, so we can reload these variables each time parameter_FRECHET is executed. 

end
