# MariaDB Backup & Restore

This set of scripts can be used to backup and restore MariaDB. 

## Backup

The `backupmanager` script expects the `.secrets` file to contain the following important variables. 

```
USER_NAME=backup
USER_PASSWD=secretpassword
BASE_DIR=/mariadb/backup
DATA_DIRECTORY=/mariadb/data
```

- `USER_NAME` is the name of the MariaDB user which is created with dataabse BACKUP privileges.
- `USER_PASSWD` is the password for the `USER_NAME` user.
- `BASE_DIR` is the path of the base folder where the backup sub-folders will be created.
- `DATA_DIRECTORY` is the path of the MariaDB `datadir` where the database files exists.

### Arguments

The `backupmanager` script takes the following parameters

```
Usage:
    -m, --mode "backup"
 or
    -m, --mode "restore"
    -s, --source "source folder to restore"
    --help
```

### Output

Once executed, the script in `backup` mode, it will create the `BASE_DIR` and a target directory based on the current timestamp as `YYYYMMDD-HH24MM` format.

The backup will also generate a detailed log file under the `BASE_DIR` folder by the name `backup_YYYYMMDD-HH24MM.out`. This will contain the following stages

- MariaDB Backup
- MariaDB Prepare

During the execution if there is any problem, the script will terminate with appropriate log details.

### Sample Execution

To take a backup, simply pass in the `--mode backup` or `-m backup` for short.

```
shell> ./backupmanager --mode backup
Created /mariadb/backup/20231020-1814 as desination folder
====================================
Started Backup: 2023-10-20 18:14:56
------------------------------------
Preparing backup at /mariadb/backup/20231020-1814
--------------------------------------
Backup Completed: 2023-10-20 18:14:57
--------------------------------------
```

## Restore

The `backupmanager` script expects the `.secrets` file in the same directory. This script takes a parameter as the backup folder name. This is used to identify which backup will be restored. 

### Outout

```
bash> ./backupmanager --mode restore --source 20231020-1750
```

This will restore the backup contained in the `20231020-1750` folder. The script automatically cleans up the exiting `datadir`, User must ensure the DATA_DIRECTORY is set properly in the `.secrets` file, if the folder is not set or the folder is invalid, the script will fail with appropriate error message.

### Sample execution

```
shell> ./backupmanager --mode restore
Usage:
    --mode "backup"
 or
    --mode "restore"
    --source "source folder to restore"
    --help
```

Execute with proper parameters. `--mode restore` must be acomnied by `--source <folder>`.

```
shell> ls -lrt
total 144
drwxr-x---. 7 root root  4096 Oct 20 12:20 20231020-1220
-rw-r--r--. 1 root root 43249 Oct 20 12:20 backup_20231020-1220.out
drwxr-x---. 7 root root  4096 Oct 20 12:35 20231020-1235
-rw-r--r--. 1 root root 43028 Oct 20 12:35 backup_20231020-1235.out
drwxr-x---. 7 root root  4096 Oct 20 13:06 20231020-1750
-rw-r--r--. 1 root root 43028 Oct 20 13:06 backup_20231020-1750.out
```

Let's restore the recent backup `20231020-1750`

```
shell> ./backupmanager --mode restore --source 20231020-1750
Stopping MariaDB service
Cleaning up /mariadb/data before restoring...
====================================
Started Restore: 2023-10-20 18:12:45
------------------------------------
Changing ownership of the restored /mariadb/data
Starging MariaDB Service
--------------------------------------
Restore Completed: 2023-10-20 18:12:45
--------------------------------------
```

#### Thank you!

