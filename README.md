# MariaDB Backup & Restore

This set of scripts can be used to backup and restore MariaDB. 

## Backup

The `backup.sh` expects the `.secrets` file to contain the following important variables. 

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

### Output

Once executed, the script will create the `BASE_DIR` and a target directory based on the current timestamp as `YYYYMMDD-HH24MM` format.

The backup will also generate a detailed log file under the `BASE_DIR` folder by the name `backup_YYYYMMDD-HH24MM.out`. This will contain the following stages

- MariaDB Backup
- MariaDB Prepare

During the execution if there is any problem, the script will terminate with appropriate log details.

### Sample Execution

```
[root@ip-172-31-16-196 ~]# ./backup
Created /mariadb/backup/20231020-1306 as desination folder
====================================
Started Backup: 2023-10-20 13:06:09
------------------------------------
Preparing backup at /mariadb/backup/20231020-1306
--------------------------------------
Backup Completed: 2023-10-20 13:06:19
--------------------------------------
```

## Restore

The `restore.sh` expects the `.secrets` file in the same directory as with the `backup.sh`. This script takes a parameter as the backuo folder name. This is used to identify which backup will be restored. 

### Outout

```
bash> ./restore.sh 20231020-1235
```

This will restore the backup contained in the `20231020-1235` folder. The script expects that the MariaDB data directory is empty, if the folder is not empty the script will fail with appropriate error message.

### Sample execution

```
[root@ip-172-31-16-196 ~]# ./restore
Incorrect arguments...
Please specify the backup directory to restore from
Usage:
shell> backup_restore.sh 20231020-1107
```

Execute with proper parameters. The backup contains the following three backup directories and logs.

```
[root@ip-172-31-16-196 backup]# ls -lrt
total 144
drwxr-x---. 7 root root  4096 Oct 20 12:20 20231020-1220
-rw-r--r--. 1 root root 43249 Oct 20 12:20 backup_20231020-1220.out
drwxr-x---. 7 root root  4096 Oct 20 12:35 20231020-1235
-rw-r--r--. 1 root root 43028 Oct 20 12:35 backup_20231020-1235.out
drwxr-x---. 7 root root  4096 Oct 20 13:06 20231020-1306
-rw-r--r--. 1 root root 43028 Oct 20 13:06 backup_20231020-1306.out
```

Let's restore the recent backup `20231020-1306`

```
[root@ip-172-31-16-196 ~]# ./restore 20231020-1306
/mariadb/data is not empty, please clean it up before restoring...
```

We will have to cleanup the existing datadir before proceeding.

```
[root@ip-172-31-16-196 ~]# systemctl stop mariadb
[root@ip-172-31-16-196 ~]# rm -rf /mariadb/data/*
[root@ip-172-31-16-196 ~]# ./restore 20231020-1306
/mariadb/data is empty, safe to restore...
Stopping MariaDB service
====================================
Started Restore: 2023-10-20 13:11:17
------------------------------------
Changing ownership of the restored /mariadb/data
Starging MariaDB Service
--------------------------------------
Restore Completed: 2023-10-20 13:11:26
--------------------------------------
```

#### Thank you!

