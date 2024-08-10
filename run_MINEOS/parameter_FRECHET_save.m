%% Setup Parameters for running MINEOS to calculate senstivity kernels, dispersion, and synthetics
function parameter_FRECHET_save(paramin, swperiods, many_plots)
    arguments 
        paramin = [] 
        swperiods = round(logspace(log10(5),log10(200),15)); 
        many_plots=false;
        % options.phv_or_grv = 'phV'; 
    end
    % Define the parameters that will be used while operating the Matlab
    % Mineos wrapper. These will be saved to a .mat file, which gets read
    % any time parameter_FRECHET is executed. 

    % User manually specifies locations of these paths. 
    paths_add = {'~/Documents/repositories/Peoples_codes/MINEOS_synthetics/run_MINEOS/functions', ... % Path to matlab unctions
                 '~/Documents/repositories/Peoples_codes/MINEOS_synthetics/run_MINEOS/functions_additional'}; % More functions. These replace export_fig and save2pdf2. If you have those functions elsewhere on your computer, then you should not need functions_additional in your path. brb2024/05/22. 
    
    % Add the paths, only if they are not already present. 
    for ipath = 1:length(paths_add) 
        pth = paths_add{ipath}; 
        onPath = contains(lower(path), lower(pth)); % pathsep
        if ~onPath 
            addpath(pth); 
        end 
    end
    
    path2BIN = '~/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin'; % Path to fortran binaries
    
    path2runMINEOS = './'; % Path to this folder
    save_path_mineos_mat = [path2runMINEOS '/parameter_FRECHET_vals.mat']; 

    % Mineos table parameters
    maxN = 400000; % Estimate of max number of modes 
    N_modes = 1; 
    if isstruct(paramin) && all(isfield(paramin, {'R_or_L', 'fmin', 'fmax', 'lmin', 'lmax', 'ID', 'R_or_L'})); % If the MCMC input parameters were provided, then use those. 
        minF = paramin.fmin; 
        maxF = paramin.fmax; 
        minL = paramin.lmin; 
        maxL = paramin.lmax; 
        param.CARDID = paramin.ID; 
        SONLY = strcmp(paramin.R_or_L, 'Ray') || strcmp(paramin.R_or_L, 'R'); 
        TONLY = strcmp(paramin.R_or_L, 'Lov') || strcmp(paramin.R_or_L, 'L'); % brb20240607 TODO double check that we use the string 'Lov'
    else % else use default values. 
        minF = 0;
        maxF = 200.05; % max frequency in mHz; %10.1; %250.05; %333.4; %500.05; %200.05; %%150.05; %50.05;
        minL = 0;
        maxL = 50000;
        N_modes = 2; % <0 uses all mode branches, 1=fundamental only -------- JOSH 8/22/15
        param.CARDID = 'synthmod'; % 'synthmod'; % 'prem_35'; %'fail_H01221_90L'; %'prem_35'; %'Nomelt_taper_aniso_constxicrman_etaPREM_constxilays'; %'pa5_5km';
        SONLY = 1; %Spheroidal modes? (RAYLEIGH) % (1 => yes, 0 => no)
        TONLY = 0; %Toroidal modes? (LOVE) % (1 => yes, 0 => no)
    end
    
    if isfield(paramin, 'phV_or_grV'); 
        param.phV_or_grV = paramin.phV_or_grV; 
    else
        param.phV_or_grV = 'phV'; 
    end 

    param.periods = swperiods; % for plotting kernels
    ch_mode = 0; % (DO NOT CHANGE) mode branch to check for missed eigenfrequencies 0 => T0 ------- JOSH 10/7/15
    
    %% brb extra options
    param.many_plots = many_plots; 

    %% Parameters for idagrn synthetics
    %brb20240607 Not yet set up for use with Love waves. 
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
    % disp('SONLY and TONLY: ')
    % disp(SONLY)
    % disp(TONLY)
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
    param.CARDTABLE = CARDTABLE; 
    if ~exist(CARDTABLE)
        mkdir([param.TABLEPATH,param.CARDID]);
        mkdir(CARDTABLE);
    end
    
    %% setup Parameters for kernals
    param.frechet = [path2runMINEOS,'/MODE/FRECHET/'];
    param.frechetpath = [path2runMINEOS,'/MODE/FRECHET/',param.CARDID,'/'];
    
    if ~exist(param.frechetpath) 
        mkdir(param.frechetpath); 
    end
    
    %% setup Parameters for eigenfunctions
    param.eigpath = [path2runMINEOS,'/MODE/EIGEN/',param.CARDID,'/'];
    
    if ~exist(param.eigpath) 
        mkdir(param.eigpath); 
    end
    
    %% setup Parameters for Dispersion
    param.disperspath = [path2runMINEOS,'/MODE/DISPERSION/',param.CARDID,'/'];
    
    if ~exist(param.disperspath) 
        mkdir(param.disperspath); 
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
    
    save(save_path_mineos_mat); % brb20240607 Save, so we can reload these variables each time parameter_FRECHET is executed. 

end
