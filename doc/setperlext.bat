REM Sets up the file association of *.pl files with perl.exe which is 
REM   provided with Matlab distribution. Assumes that %MATLABROOT% system 
REM   variable is defined. If not defined, replace %MATLABROOT% below with 
REM   your matlab root directory. Must be run in command prompt with 
REM   administrator privliges.
assoc .pl=PerlScript
ftype PerlScript=%MATLABROOT%\sys\perl\win32\bin\perl.exe %1 %*
pause