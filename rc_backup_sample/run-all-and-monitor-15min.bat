@echo OFF
@REM Sample batch file to automate pushing local changes to a directory
@REM for each 'src_path' and 'dest_path' use the following commands. It leverages
@REM the utility jobs in the home directory of the robocopy-jobs folder.
@REM
@REM The /MOT:15 option is added to each robocopy execution to check for updates
@REM every 15 minutes

set maxerror=0
FOR %%j IN (*.rcj) DO (
    call :run_rc_job %%~nj
    if %maxerror% LSS %ERRORLEVEL% set maxerror=%ERRORLEVEL%
)
EXIT /B %maxerror%

@REM wrap robocopy call in a function so than any error level logic
@REM can be contained within the function
:run_rc_job
@REM run the robocopy job
robocopy /JOB:%~1 /MOT:15
@REM If you want do change the error code reported by robocopy, do so
@REM here with something like this.
@REM robocopy /JOB:%~1 /L ^& IF %ERRORLEVEL% LEQ 1 EXIT /B 0
EXIT /B %ERRORLEVEL%
