@echo OFF
@REM Sample batch file to automate pushing local changes to a directory
@REM for each 'src_path' and 'dest_path' use the following commands. It leverages
@REM the utility jobs in the home directory of the robocopy-jobs folder.
@REM
@REM Each command is wrapped in boilerplate to catch nuisance error codes

set maxerror=0
FOR %%j IN (*.rcj) DO (
    call :run_rc_job %%~nj
    if %maxerror% LSS %ERRORLEVEL% set maxerror=%ERRORLEVEL%
)
echo pre-EXITERROR %maxerror%
EXIT /B %maxerror%

:run_rc_job
set /a "cnt+=1"
@REM run the robocopy job
robocopy /JOB:%~1
@REM If you want do change the error code reported by robocopy, do so here with
@REM robocopy /JOB:%~1 /L ^& IF %ERRORLEVEL% LEQ 1 exit 0
EXIT /B %ERRORLEVEL%
