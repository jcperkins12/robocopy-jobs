@REM Sample batch file to automate pushing local changes to a directory
@REM for each 'src_path' and 'dest_path' use the following commands. It leverages
@REM the utility jobs in the home directory of the robocopy-jobs folder.
@REM
@REM Each command is wrapped in boilerplate to catch nuisance error codes


REM Backup Directory 1
SET SRC="C:\src\directory\1"
SET DEST="C:\dest\directory\1"
(robocopy /JOB:pushnew %SRC% %DEST% /JOB:exclude-gen /JOB:exclude-code-env) ^& IF %ERRORLEVEL% LSS 8 SET ERRORLEVEL = 0

REM Backup Directory 2
SET SRC="C:\src\directory\2"
SET DEST="C:\dest\directory\2"
(robocopy /JOB:pushnew %SRC% %DEST% /JOB:exclude-gen /JOB:exclude-code-env) ^& IF %ERRORLEVEL% LSS 8 SET ERRORLEVEL = 0

PAUSE
EXIT /B %ERRORLEVEL%
