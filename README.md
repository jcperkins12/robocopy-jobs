# robocopy-jobs
Basic repo of robocopy jobs that I want to remember and use when transferring files on a windows system.

I've found the following resources helpful in understanding robocopy:
* [Microsoft Docs - robocopy](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)
* [The Ultimate Guide to Robocopy](https://adamtheautomator.com/robocopy-the-ultimate/)

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

## Using the robocopy utility jobs
The jobs in the root directory (*.rcj files) are utility jobs containing settings that can be added to any robocopy command. The `sample-backup-with-util-jobs.bat` file is an example of how to use them.

## Using the robocopy job queues
Multiple directories can by synced by createing jobs for specific direcotries.
1. make a new folder in the project with the name of your routines i.e. `sample-work`
2. copy the .bat files from the `rc_backup_sample` folder to the new folder
3. Create a job for each file transfer that you want included in the total
    ```batch script
    > rococopy C:\src\direcory1 C:\dest\directory1 /JOB:EXCLUDE-GEN /JOB:PUSHLOCAL /SAVE:sample-work\dir1 /QUIT
    ```
    * C:\src\direcory1 - specify the source directory
    * C:\dest\directory1 - specify the source directory
    * /JOB:EXCLUDE-GEN - use the EXLUDE-GEN utility job to apply generalized exclusions
    * /JOB:PUSHLOCAL - use the PUSHLOCAL utility job to apply the copy options
    * /SAVE:sample-work\dir1 - save the job to dir1.rcj in the sample-work directory that you just made
    * /QUIT - prevent the job from running so that it is only saved
4. You can then move that folder to any other location on your computer and the .bat file will run successfully as long as they are still in the same direcotry as the robocopy jobs.

## Using Jobs
Jobs are implemented by calling robocopy with the /JOB:jobname option. Some jobs are templates that only add options to an existing command set and other
can contain all relevant information (i.e. src and dest directories)

## Editing Jobs
These jobs can be edited with a text editor or by overwriting the job by saving a new job with the same name. Commands or parameters can be added to an existing job by calling `robocopy` with the original job, any additional options and ending with `/SAVE:jobname /QUIT` to save the job with out executing it.

For example, the following command adds the option to exclude all executable files from the backupfiles job

```shell script
> robocopy /JOB:backupfiles /XF *.EXE /SAVE:backupfiles /QUIT
```
