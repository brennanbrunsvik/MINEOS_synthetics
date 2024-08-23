
%%% brb2024.08.21 Paths might already be set. 
% I am removing this to attempt to remove the following error: 
% >>>> Error
%  Error using setenv
% The 'value' argument to SETENV must not be more than 32766 characters long.
% 
% Error in setpath_plotwk (line 7)
% setenv('PATH',[PATH ':~/bin:/Users/patty/PGS/MINEOS_JIMversion/bin/:~/Documents/repositories/Peoples_codes/MINEOS_synthetics/FORTRAN/bin/']); %brb2024/05/22 Does this path need to be changed? 
% <<<< Error


% >>>> Original code
% % Set path for MINEOS executables
% % 
% % NJA, 2014
% % pylin.patty, 2014/12
% 
% PATH = getenv('PATH');
% %setenv('PATH', [PATH ':/Users/russell/Lamont/MINEOS/MINEOS_JIMversion/bin/'])
% setenv('PATH', [PATH ':/Users/russell/bin/'])
% %setenv('DYLD_LIBRARY_PATH', '/usr/local/bin/');
% setenv('DYLD_LIBRARY_PATH', '/opt/local/bin/');
% <<<< Original code