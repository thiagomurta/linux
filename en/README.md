# 🐧 Linux Commands for Beginners

Notes from the **Linux Commands for Beginners** course by Learn Linux TV.

🇧🇷 [Leia em português](../pt/README.md) · ⬅️ [Back to home](../README.md)

## Table of Contents

1. [Navigation and files](#1-navigation-and-files)
2. [Permissions](#2-permissions)
3. [System monitoring](#3-system-monitoring)
4. [Package management (apt)](#4-package-management-apt)
5. [Managing services (systemd)](#5-managing-services-systemd)
6. [Logs](#6-logs)
7. [Managing users and groups](#7-managing-users-and-groups)
8. [Command history](#8-command-history)
9. [Output redirection and pipes](#9-output-redirection-and-pipes)
10. [Finding files (find)](#10-finding-files-find)
11. [Remote management with OpenSSH](#11-remote-management-with-openssh)
12. [Transferring files (scp and rsync)](#12-transferring-files-scp-and-rsync)
13. [Disabling root login over SSH](#13-disabling-root-login-over-ssh)
14. [Variables](#14-variables)
15. [Important notes](#15-important-notes)
16. [Important folders and files](#16-important-folders-and-files)

---

## 1. Navigation and files

| Command | Description |
|---|---|
| `ls` | Lists the contents of the current folder |
| `ls /` | Lists the folders at the root (`/`) of the filesystem |
| `ls -l` | Long listing, with more details |
| `ls -a` | Also lists hidden files |
| `pwd` | *(print working directory)* Shows the path of the current directory |
| `cd <directory>` | *(change directory)* Enters the given directory |
| `touch <file>` | Creates a file |
| `which <app>` | Checks whether the app is installed on the machine |
| `cp <file1> <newfile>` | Copies `file1` to `newfile` |
| `diff <file1> <file2>` | Compares two files; if they are identical, it prints nothing |
| `rm <file>` | Removes a file |
| `rm -r <directory>` | Removes a directory **and everything inside it** (recursive) |
| `rm -rf <directory>` | Same as above, but with `-f` (*force*): no confirmation prompts and ignores nonexistent files |
| `mv <file> <directory>` | Moves the file into the directory |
| `mv <file> <newfile>` | Renames the file |
| `alias <shortcut>=<command>` | Defines a shortcut for a command (only lasts for the current session; to make it permanent, put it in `~/.bashrc`) |

> ⚠️ **Be careful with `rm -rf`:** since it doesn't ask for confirmation, a typo can delete important data.

---

## 2. Permissions

### Reading the output of `ls -l`

`ls -l` shows a permission string split into 4 sections, for example `drwxrwxrwx`:

| Position | Meaning |
|---|---|
| 1st (`d` or `-`) | Directory (`d`) or file (`-`) |
| 2nd (`rwx`) | **User**: owner of the file or directory |
| 3rd (`rwx`) | **Group** |
| 4th (`rwx`) | **Other**: everyone else |

Letters: `r` = read, `w` = write, `x` = execute.

### `chmod` (change mode)

```bash
chmod +x myscript.sh      # add execute (for everyone)
chmod u+x myscript.sh     # add execute just to the user
chmod g+x myscript.sh     # add execute just to the group
chmod o+x myscript.sh     # add execute just to others
chmod a+rwx myscript.sh   # add rwx for all
```

### Directory permissions

| Permission | Effect |
|---|---|
| `r` | Able to see the contents |
| `w` | Able to change the contents |
| `x` | Able to enter the directory |

### Numeric permissions

| Letter | Value |
|---|---|
| `r` | 4 |
| `w` | 2 |
| `x` | 1 |

Add up the values for each section (user, group, other):

```bash
chmod 400 textfile   # -r--------  only the user can read; group and other = 0
```

---

## 3. System monitoring

### Memory: `free`

```bash
free      # shows available RAM and Swap
free -m   # shows memory in megabytes
```

**Difference between `free` and `available`:**
- `free`: memory that is free for the system, not being used by anything at all.
- `available`: memory that could be reclaimed and used if needed.

### Disk: `df`

```bash
df        # (disk free) disk space
df -h     # -h = human readable
df -i     # number of inodes
```

### System load: `uptime`

Shows how long the system has been up and the load average. The three numbers are averages over:

1. The last **1 minute**
2. The last **5 minutes**
3. The last **15 minutes**

This lets you see the performance trend of the system. The value represents, on average, how many tasks are running or waiting for the CPU (on Linux, it also includes tasks blocked on I/O).

> 💡 Whether the system is overloaded **depends on the number of cores**: a load of 4 is high on a 2-core machine, but normal on an 8-core one.

---

## 4. Package management (apt)

```bash
apt search <package>                    # search for a package
apt search firefox

sudo apt install <package>              # install a package
sudo apt install vim-nox
sudo apt install <package1> <package2>  # install several packages

sudo apt remove <package>               # remove a package
sudo apt autoremove                     # remove dependencies left over from removed packages

sudo apt update                         # refresh the package lists
sudo apt upgrade                        # upgrade installed packages
sudo apt dist-upgrade                   # handles both newly installed packages and those that need to be removed

sudo reboot                             # restart the machine
```

---

## 5. Managing services (systemd)

**systemd** is the process/service manager on Linux systems.

```bash
systemctl status <unit>          # check the status of the unit
systemctl status apache2

sudo systemctl start <unit>      # start the unit
sudo systemctl stop <unit>       # stop the unit
sudo systemctl restart <unit>    # restart the unit
sudo systemctl enable <unit>     # start automatically at boot
sudo systemctl disable <unit>    # don't start automatically at boot
```

Example with `apache2`:

```bash
sudo systemctl start apache2
sudo systemctl stop apache2
sudo systemctl restart apache2
sudo systemctl enable apache2
sudo systemctl disable apache2
```

### Understanding the output of `systemctl status`

```
Loaded: loaded (/usr/lib/systemd/system/apache2.service; enabled; preset: enabled)
Active: active (running)
```

- First `enabled`: current state, apache2 will start as soon as the machine boots.
- `preset: enabled`: the distribution's default configuration (preset) says this service should be enabled.
- `active (running)`: it is running correctly.

---

## 6. Logs

```bash
head <log_file>             # shows the first 10 lines
tail <log_file>             # shows the last 10 lines
tail -n 50 <log_file>       # shows the last 50 lines (the number can be changed)
tail -f <log_file>          # follows the file in real time
```

### journalctl

`journalctl` is part of systemd, just like `systemctl`.

```bash
journalctl -u <unit>        # only messages from the specified service/unit
journalctl -u ssh           # -u = use a unit name
journalctl -fu ssh          # -f = follow new messages in real time
```

---

## 7. Managing users and groups

### Users

```bash
sudo adduser <user>              # create a user
sudo adduser batman

su - <user>                      # open a new login shell as the user (asks for their password)
logout                           # close that shell and go back to the previous user

sudo su - <user>                 # same, but without asking for the user's password (sudo asks for YOUR password)
sudo su -                        # open a shell as root; the next commands run as root
exit                             # leave the current shell (logout or Ctrl+d also work)

passwd                           # change the CURRENT user's password
sudo passwd <user>               # change another user's password without logging in as them
passwd <user>                    # when already root, this is enough

sudo userdel -r <user>           # remove the user and (-r) their home directory
```

### Groups

```bash
sudo groupadd <group>            # create a group
sudo groupadd heroes

sudo usermod -aG <group> <user>  # add the user to the group
sudo gpasswd -d <user> <group>   # remove the user from the group
sudo groupdel <group>            # delete the group
```

---

## 8. Command history

```bash
history      # shows the command history
```

- `Ctrl+r`: search/autocomplete previously used commands.

---

## 9. Output redirection and pipes

```bash
ls -l > file.txt               # send output to file.txt, overwriting the file
ls -l >> file.txt              # send output to file.txt, without overwriting (appends)
ls -l | grep file              # send the output of ls to grep to search through
cat file.txt | sort | uniq     # read the lines | sort them | remove duplicates
```

### Useful commands in pipelines

| Command | Description |
|---|---|
| `sort` | Sorts lines alphabetically |
| `uniq` | Removes **adjacent** duplicate lines (that's why it's used after `sort`) |
| `grep -v <string>` | Shows the lines that do **not** contain the string |
| `wc` | *(word count)* Counts lines, words and bytes (or characters) |

### File descriptors

| No. | Name | Description |
|---|---|---|
| 0 | `stdin` | Standard input |
| 1 | `stdout` | Standard output |
| 2 | `stderr` | Standard error |

Examples:

```bash
find / -name "*.log" 2> /dev/null     # discard errors by sending them to /dev/null
find / -name "*.log" 2> errors.txt    # write errors to errors.txt
find / -name "*.log" 1> success.txt   # write the results (successes) to success.txt
```

---

## 10. Finding files (find)

```bash
find -name log                              # find files AND directories named "log"
find -type d -name log                      # find only directories named "log"
find -type f -name log                      # find only files named "log"
find /var -type f -name "*log"              # files in /var whose name ends with "log"
find /var -type f -name "*log*"             # files in /var with "log" anywhere in the name
find /var -type f -name "*log*" 2> /dev/null   # same, discarding errors
```

### Filtering by modification time

`-mtime` = *modify time* (in days).

```bash
find /var/log -type f -name "*.log" -mtime -7
# .log files modified in the last 7 days
```

### Running a command on the results (`-exec`)

```bash
find /var/log -type f -name "*.log" -mtime +30 -exec rm {} \;
# removes (rm) the .log files modified more than 30 days ago
```

> ⚠️ **Careful:** test first with `-exec ls {} \;` before using `rm`.
> `-mtime -30` = modified **within the last** 30 days; `-mtime +30` = modified **more than** 30 days ago.

---

## 11. Remote management with OpenSSH

```bash
sudo ss -tulpn              # check whether the SSH server is running/listening
sudo netstat -tulpn         # older equivalent (deprecated, may not be installed)
ip a                        # shows the IP of the machine you want to connect to

ssh <username>@<ip_server>  # connect as username to ip_server
ssh root@<ip_server>        # connect as root to ip_server
exit                        # leave the server (Ctrl+d also works)
```

---

## 12. Transferring files (scp and rsync)

### SCP (Secure Copy Protocol)

```bash
# Send the file to /home/<username>/ on the other machine
scp <file_to_transfer> <username>@<ip_server>:/home/<username>/

# If you omit the username, it uses your LOCAL username;
# with no path after the ":", the destination is the remote user's home directory
scp <file_to_transfer> <ip_server>:

# -r = recursive, sends the whole directory
scp -r <folder>/ <ip_server>:

# Works for receiving too (same process, reversed)
scp <ip_server>:<file_to_transfer> <path_to_receive>
```

### rsync

```bash
rsync -r <folder> <username>@<ip_server>:/home/<username>    # send the whole directory (-r = recursive)
rsync -rv <folder> <username>@<ip_server>:/home/<username>   # same, but verbose (-v) and reports what was copied
rsync -rv <folder> <ip_server>:                              # same shortcut as scp
rsync -avz <folder> <ip_server>:
```

The `-avz` options:

| Option | Description |
|---|---|
| `-a` | *Archive* mode: a set of options that already includes recursion and keeps permissions and timestamps |
| `-v` | Verbose mode, shows more detail about the transfer |
| `-z` | Compresses files during transfer (helps on slow connections) |

`rsync` can resend **only the missing files** if something was deleted or changed on the receiving machine.

```bash
# Send files to the other machine and delete the original FILES on the source
# (empty directories stay behind)
rsync -avz --remove-source-files <folder> <ip_server>:

# Dry run: executes nothing, but shows what would happen
rsync -avz --remove-source-files --dry-run <folder> <ip_server>:
```

---

## 13. Disabling root login over SSH

```bash
sudo nvim /etc/ssh/sshd_config
```

Change/set:

```
PermitRootLogin no            # most secure option (was prohibit-password)
PasswordAuthentication no     # connection is refused without even asking for a password (was yes)
```

> ⚠️ `PasswordAuthentication no` disables passwords for **all** users, not just root: you will only be able to log in with an SSH key. Make sure your key works first, or you'll lock yourself out.
>
> After editing, restart the service: `sudo systemctl restart ssh`

---

## 14. Variables

```bash
HELLOMSG="Hello World"        # set the variable's value
echo $HELLOMSG                # use the variable

MY_NAME="Thiago"
echo "My name is $MY_NAME"

env                           # shows the session's environment variables
export myvar="linux"          # export the variable: it shows up in env and is inherited by child processes
```

> `export` can be used after defining the variable (`myvar="linux"` and then `export myvar`).

---

## 15. Important notes

- `~` is the user's home directory, the same as `cd /home/username`.
- **Inodes:** when they run out, you can't **create new files**, even with free disk space, which can cause services to fail.
- Commands starting with a blank space are not saved to `history`, if `HISTCONTROL` includes `ignorespace` or `ignoreboth` (the default on Ubuntu/Debian, but not on every distro).

---

## 16. Important folders and files

| Path | Description |
|---|---|
| `/home` | Main directory, holds the users' personal folders |
| `/etc/passwd` | Lists users: name, UID, GID (primary group), home and shell (does **not** contain the password hash) |
| `/etc/shadow` | Holds the password hashes |
| `/etc/group` | List of groups |

```bash
cat /etc/passwd
sudo cat /etc/shadow    # requires root privileges
cat /etc/group
```
