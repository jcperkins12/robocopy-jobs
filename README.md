# robocopy-jobs
Basic repo of robocopy jobs that I want to remember and use when transferring files on a windows system.

I've found the following resources helpful in understanding robocopy:
* [Microsoft Docs - robocopy](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)
* [The Ultimate Guide to Robocopy](https://adamtheautomator.com/robocopy-the-ultimate/)

The jobs in the root directory (*.rcj files) are utility jobs containing settings that can be added to any robocopy command. The `sample-backup-with-util-jobs.bat` file is an example of how to use them.

## robocopy Error Codes
| Exit Code | Explanation                                                                             |
|-----------|-----------------------------------------------------------------------------------------|
| 0         | No action performed. Source and destination are synchronized.                           |
| 1         | At least one file was copied successfully.                                              |
| 2         | Extra files or directories were detected. Examine log.                                  |
| 3         | Exit codes 2 and 1 combined.                                                            |
| 4         | Mismatched files or directories found. Examine log.                                     |
| 5         | Exit codes 4 and 1 combined.                                                            |
| 6         | Exit codes 4 and 2 combined.                                                            |
| 7         | Exit codes 4, 1 and 2 combined.                                                         |
| 8         | At least one file or directory could not be copied. Retry limit exceeeded. Examine log. |
| 16        | Copy failed catastrophically.                                                           |


## Using Jobs
Jobs are implemented by calling robocopy with the /JOB:jobname option. Some jobs are templates that only add options to an existing command set and other
can contain all relevant information (i.e. src and dest directories)

## Editing Jobs
These jobs can be edited with a text editor or by overwriting the job by saving a new job with the same name. Commands or parameters can be added to an existing job by calling `robocopy` with the original job, any additional options and ending with `/SAVE:jobname /QUIT` to save the job with out executing it.

For example, the following command adds the option to exclude all executable files from the backupfiles job

```shell script
> robocopy /JOB:backupfiles /XF *.EXE /SAVE:backupfiles /QUIT
```
