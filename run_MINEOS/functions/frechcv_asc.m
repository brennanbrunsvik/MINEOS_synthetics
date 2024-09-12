% frechcv_asc.
% Program converts binary frechet kernels in phase velocity to ascii
% versions and saves the output in a mat file
% Involves writing run files for draw_frechet_gv and running the fortran
% program
%
% NJA, 2014
% make TYPEID as a parameter in parameter_FRECHET
% pylin.patty 2015/01

function [FRECH] = frechcv_asc(TYPE,CARD,BRANCH)
% Basically the same as frechgv_asc. They should be combined. 

% TYPE = 'T';
% CARD = param.CARDID;
% BRANCH = 0;

fid_log = fopen('draw_frechet_gv.LOG','w'); %JBR -- write log file

% Get useful info from parameter file
parameter_FRECHET;
CARDPATH = param.CARDPATH;
% FRECHETPATH = param.frechetpath;
FRECHETPATH = [param.frechet,CARD,'/'];
TABLEPATH = param.TABLEPATH;
periods = param.periods;

if strcmp(TYPE,'T') == 1
    disp('Toroidal!');
    
    RUNFILE = 'run_frechcv_asc.t';
    TYPEID = param.TTYPEID;
    
elseif strcmp(TYPE,'S') == 1
    disp('Spheroidal!');
    
    RUNFILE = 'run_frechcv_asc.s';
    TYPEID = param.STYPEID;
    
else
    disp('No TYPE recognized!');
    
end

BRID = [num2str(BRANCH)];
% if BRANCH == 0
%     BRID = '0st';
% elseif BRANCH == 1
%     BRID = '1st';
% elseif BRANCH == 2
%     BRID = '2nd';
% elseif BRANCH == 3
%     BRID = '3rd';
% else
%     disp('Branch has no name! Change it in the script')
% end

FRECHCV = [FRECHETPATH,CARD,'.',TYPEID,'.fcv.',BRID];

%% Run draw_frech_gv to get ascii files. 
% brb2024/09/12 Modified to call draw_frechet_gv once, so that the binaries are loaded only once. Speeds code up. 
runall = 'execute_draw_frechet_cv.sh'; 
if exist(runall, 'file'); 
    delete(runall); 
end 
fid = fopen(runall, 'w'); 
fprintf(fid, 'draw_frechet_gv <<EOF\n'); 
fprintf(fid,'%s\n',FRECHCV); %input binary file
for ip = 1:length(periods)
    FRECHASC = [FRECHETPATH,CARD,'.',TYPEID,'.',BRID,'.',num2str(periods(ip))];
    fprintf(fid,'%s\n',FRECHASC); % output ascii file
    fprintf(fid,'%i\n',periods(ip));
end
fprintf(fid, 'end\nEOF\n\n'); 
fclose(fid); 
system(sprintf('chmod +x %s', runall)); 

% Now actually execute the draw_frechet_gv script. Time it. It can get slow. 
t1 = tic; 
system(sprintf('./%s', runall))
t2 = toc; 
fprintf('Total time for executing draw_frechet_gv: %s', t2); 

%% Read ascii files into Matlab
for ip = 1:length(periods); 
    FRECHASC = [FRECHETPATH,CARD,'.',TYPEID,'.',BRID,'.',num2str(periods(ip))];

    fid = fopen(FRECHASC,'r');
    C = textscan(fid,'%f%f%f%f%f%f%f');
    fclose(fid);
    
    if strcmp(TYPE,'S') == 1
        FRECH(ip).per = periods(ip);
        FRECH(ip).rad = C{1};
        FRECH(ip).vsv = C{2};
        FRECH(ip).vpv = C{3};
        FRECH(ip).vsh = C{4};
        FRECH(ip).vph = C{5};
        FRECH(ip).eta = C{6};
        FRECH(ip).rho = C{7};
    elseif strcmp(TYPE,'T') == 1
        FRECH(ip).per = periods(ip);
        FRECH(ip).rad = C{1};
        FRECH(ip).vsv = C{2};
        FRECH(ip).vsh = C{3};
        FRECH(ip).rho = C{4};
    end
end




% % % Below is code to run kernels, called draw_frech_cv one time for every single period. Can be slow on some machines. brb2024/09/12 
% % % 
% % % for ip = 1:length(periods)
% % %     FRECHASC = [FRECHETPATH,CARD,'.',TYPEID,'.',BRID,'.',num2str(periods(ip))];
% % % 
% % %     % Write runfile for draw_frechet_gv
% % %     fid = fopen(RUNFILE,'w');
% % %     fprintf(fid,'%s\n',FRECHCV); %input binary file
% % %     fprintf(fid,'%s\n',FRECHASC); %output ascii file
% % %     fprintf(fid,'%i\n',periods(ip));
% % %     fclose(fid);
% % % 
% % %     % Run draw_frechet_gv
% % %     % disp(sprintf('--- Period : %s',num2str(periods(ip))));
% % % 
% % %     if exist(FRECHASC,'file') == 2
% % %     %disp('File exists! Removing it now')
% % %     com = ['rm -f ',FRECHASC];
% % %     [status,log] = system(com);
% % %     end
% % % 
% % %     com = sprintf('cat %s | draw_frechet_gv',RUNFILE);
% % %     [status,log] = system(com);
% % % 
% % %     fprintf('Temporary. Log for draw_frechet_gv: \n %s', log)
% % % 
% % %     fprintf(fid_log,log); % JBR
% % % %    log
% % %     dT = abs(periods(ip)-str2num(log(end-10:end)));
% % %     % if ( dT < 1.5)
% % %     %     disp(sprintf('Find closest period: %s',log(end-10:end)));
% % %     % else
% % %     %     disp('the closest period is FAR AWAY from period of interest')
% % %     %     disp(sprintf('Find closest period: %s',log(end-10:end)));
% % %     % end
% % % 
% % %     % Load in frechet files for each period
% % % 
% % %     % spheroidal, no aniso: 1=Vs,2=Vp,3=rho
% % %     % spheroidal, aniso: 1=Vsv,2=Vpv,3=Vsh,4=Vph,5=eta,6=rho
% % %     % toroidal, no aniso: 1=Vs,2=rho
% % %     % toroidal, aniso: 1=Vsv,2=Vsh,3=rho
% % %     % disp(FRECHASC)
% % %     fid = fopen(FRECHASC,'r');
% % %     C = textscan(fid,'%f%f%f%f%f%f%f');
% % %     fclose(fid);
% % % 
% % %     if strcmp(TYPE,'S') == 1
% % %         FRECH(ip).per = periods(ip);
% % %         FRECH(ip).rad = C{1};
% % %         FRECH(ip).vsv = C{2};
% % %         FRECH(ip).vpv = C{3};
% % %         FRECH(ip).vsh = C{4};
% % %         FRECH(ip).vph = C{5};
% % %         FRECH(ip).eta = C{6};
% % %         FRECH(ip).rho = C{7};
% % %     elseif strcmp(TYPE,'T') == 1
% % %         FRECH(ip).per = periods(ip);
% % %         FRECH(ip).rad = C{1};
% % %         FRECH(ip).vsv = C{2};
% % %         FRECH(ip).vsh = C{3};
% % %         FRECH(ip).rho = C{4};
% % %     end
% % % end
% % % 
% % % fclose(fid_log); % JBR
