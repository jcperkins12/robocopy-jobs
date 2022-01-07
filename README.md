# robocopy-jobs

Basic repo of robocopy jobs that I want to remember and use when transferring
files on a windows system.

I've found the following resources helpful in understanding robocopy:

- [Microsoft Docs - robocopy](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy)
- [The Ultimate Guide to Robocopy](https://adamtheautomator.com/robocopy-the-ultimate/)

## Quickstart

This project is intended to be used to create self contained instructions that
reside within a directory and are activated with a batch file saved to the same
directory. Once finished the directory containing the instructions and
executable can be moved anywhere the user wants.

The jobs in the root directory (.\*.rcj files) are utility jobs containing
settings that can be added to any robocopy command. The
`sample-backup-with-util-jobs.bat` file is an example of how to use them if you
want to keep all instructions in a single file.

See the section below for setting up a multi-directory job where the
instructions for each directory are in separate files so that additions or edits
can be easily made.

### Setting up a multi-directory sync job with job queues

Each directory that needs to be synced gets it's own robocopy job file so that
new files can be easily added or removed without changing a master file.

1. Clone the project to a (windows) directory and change into the directory

   ```batch
   > git clone https://github.com/jcperkins12/robocopy-jobs.git
   > cd robocopy-jobs
   ```

2. Create a new folder that will contain all of the instuctions for the new job

   ```batch
   > mkdir My-BackUp-Job
   ```

3. Copy the batch files from `.\rc_backup_sample` to your new folder.

   ```batch
   > robocopy .\rc_backup_sample .\My-Backup-Job *.bat
   ```

4. Create a job for each file transfer that you want included by executing the
   robocopy function from the root directory of the project with the following
   format to save the job instead of running it.

   ```batch script
   > rococopy C:\src\direcory1 C:\dest\directory1 [/JOB:<UTILITY-JOB> [...]] [<additional options>] /SAVE:My-Backup-Job\DIR1 /QUIT
   ```

   - `robocopy` - executes the robocopy executable
   - `C:\src\direcory1` - specify the source directory
     - Unless specified with an `/IF` (include files), `/XD` (exclude
       directories) or `/XF` (exclude files) option, the default behavior will
       be to copy all files in the source directory.
   - `C:\dest\directory1` - specify the destination directory
   - `/JOB:<UTILITY-JOB>` - apply any of the utility jobs in the current
     directory such as 'PUSHLOCAL', 'PUSHNETWORK', 'SYNCLOCAL', 'SYNCNETWORK',
     'EXCLUDE-GEN' or 'EXCLUDE-CODE-ENV'. Apply as many as you want and create
     your own if desired.
   - `/SAVE:My-Backup-Job\DIR1` - save the job as DIR1.rcj in the
     ./My-Backup-Job directory.
   - `/QUIT` - prevent the job from running so that it is only saved

   For Example
   `> rococopy C:\configs F:\BackupFiles\configs /JOB:PUSHLOCAL /JOB:EXCLUDE-GEN /SAVE:My-Backup-Job\CONFIGS /QUIT`
   will create a robocopy job named 'CONFIGS.RJC' that pushes all config file
   changes from my C:\ drive to a backup folder on my F:\ drive and while making
   sure to never delete or change anything on my C:\ drive. In the future this
   job can be run any time on it's own from a command prompt with
   `robocopy \JOB:PATH\TO\CONFIGS`.

5. Create a new job for each directory that you want to back up or sync when the
   backup task is run.

6. Execute either the 'run-all-once.bat' or the 'run-all-and-monitor-15min.bat'
   batch files to run all of the jobs in the folder that you made.

   - run-all-once.bat will run each job once and exit
   - run-all-once-and-monitor-15min.bat adds the `/MOT:15` option to each job
     execution so that the job is re-evaluated every 15 minutes. You can update
     the batch file to change the frequency.

7. Optional - I like to create a shortcut to the 'run-all-once.bat' file and
   save it to my desktop with a more descriptive name so that I can run it
   whenever I need a file to sync. The shortcut will work from anywhere as long
   as the batch file is still in the same directory as all of your custom
   robocopy jobs.

## Using Jobs

Jobs are implemented by calling robocopy with the /JOB:jobname option. Some jobs
are templates that only add options to an existing command set and others can
contain all relevant information (i.e. src and dest directories).

The premade jobs (no source or directory info provided) are:

- **Action Jobs**

  - PUSHLOCAL.RCJ - Push all new/updated files to a location on a local drive
    but does not delete anything. Any reporting to the console includes
    timestamps with the `/TS` flag.

    - Shortcut for adding the `/TS /E /XO` options
    - `/TS` - include source file Time Stamps in the output.
    - `/E` - copy subdirectories, including Empty ones.
    - `/XO` - exclude Older files.

  - PUSHNETWORK.RCJ - Push all new/updated files to a network location. It only
    pushes changes, it doens't delete anything.

    - Shortcut for adding the `/Z /JOB:PUSHLOCAL` options
    - `/Z` - copy files in restartable mode. Operation is slower but is able to
      continue if the host temporarily loses connection with the network.
    - `/JOB:PUSHLOCAL` - add all of the options from the PUSHLOCAL.RCJ
      instrcutions defined above.

  - SYNCLOCAL.RCJ - Preset options for syncing all new/updated files to a
    location on a local drive. It pushes changes and also deletes local files
    that have been deleted in the src dircetory.

    - Shortcut for adding the `/MIR /JOB:PUSHLOCAL` options
    - `/MIR` - mirror a directory tree (equivalent to /E plus /PURGE)..
    - `/JOB:PUSHLOCAL` - add all of the options from the PUSHLOCAL.RCJ
      instrcutions defined above.

  - SYNCNETWORK.RCJ - Sync all new/updated files to a network location. It
    pushes changes in restartable mode and deletes local files that have been
    deleted in the src dircetory.
    - Shortcut for adding the `/MIR /JOB:PUSHNETWORK` options
    - `/MIR` - mirror a directory tree (equivalent to /E plus /PURGE)..
    - `/JOB:PUSHNETWORK` - add all of the options from the PUSHNETWORK.RCJ
      instrcutions defined above.

- **Filter Jobs**
  - EXCLUDE-GEN.RCJ - Exclude general cache and temporary files.
    - Shortcut for adding the
      `/XD ".pytest_cache" "ipynb_checkpoints" "__pycache__" ".mypy_cache" "plugged" /XF "~*" "*~"`
      options to the robocopy execution.
    - Excluded directories are '.pytest_cache', 'ipynb_checkpoints',
      '\_\_pycache\_\_', '.mypy_cache' and 'plugged'
    - Excludes vim temporary files
  - EXCLUDE-CODE-ENV.RCJ - Exclude files associated with a coding environment
    that can be downloaded or re-installed through existing scripts or package
    managers like npm, yarn, conda and pip.
    - Shortcut for adding the
      `/XD "node_modules" "venv" ".venv" "coverage" /XF "*.pyc"` options to the
      robocopy job
    - Excluded directories are 'node_modules', 'venv', '.venv' and 'coverage'
    - Excludes compiled python files (i.e. '\*.pyc')

## Editing Jobs

These jobs can be edited with a text editor or by overwriting the job by saving
a new job with the same name. Commands or parameters can be added to an existing
job by calling `robocopy` with the original job, any additional options and
ending with `/SAVE:jobname /QUIT` to save the job with out executing it.

For example, the following command adds the option to exclude all executable
files from the backupfiles job

```shell script
> robocopy /JOB:backupfiles /XF *.EXE /SAVE:backupfiles /QUIT
```

## robocopy Error Codes

| Exit Code | Explanation                                                                             |
| --------- | --------------------------------------------------------------------------------------- |
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
