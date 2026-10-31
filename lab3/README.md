2.1

2.1.1
mkdir -p ~/test
cd ~/test
touch file
ls -ld .
ls -l file
stat -c '%A %a %U:%G %n' file

2.1.2
chmod 000 file
ls -l file
echo 'Тестовая строка' > file
cat file

2.1.3
chmod 200 file
ls -l file
echo 'Строка для проверки' > file
cat file

2.1.4
chmod 240 file
ls -l file
cat file

2.1.5
chmod 640 file
ls -l file
cat file

2.1.6
mkdir dir
echo 'Содержимое нового файла' > dir/new_file
ls -la dir
cat dir/new_file

2.1.7
chmod a-x dir
ls -ld dir
cat dir/new_file
rm dir/new_file
chmod u+rwx dir

2.1.8
chown root file
ls -l file

2.1.9
OLD_UMASK=$(umask)
umask 077
touch private_file
stat -c '%a %A %n' private_file

2.1.10
umask 000
touch public_file
stat -c '%a %A %n' public_file
umask "$OLD_UMASK"

2.1.11
ls -l file
# -r-------- 1 root maxy ... file

2.1.12
cat file
ls -l file
cat file

2.2

2.2.1
whoami
id
id -u
id -g
id -Gn

2.2.2
getent passwd "$(whoami)"
getent group "$(id -g)"

2.2.3
sudo groupadd labgroup
getent group labgroup

2.2.4
sudo useradd -m -s /bin/bash labuser
getent passwd labuser
id labuser
ls -ld /home/labuser

2.2.5
sudo passwd labuser
su - labuser
whoami
id
pwd
exit

2.2.6
su - labuser
printf 'Тест\n' > "$HOME/user_file.txt"
ls -l "$HOME/user_file.txt"
id -g
id -gn
exit

2.2.7
sudo usermod -aG labgroup labuser
id labuser
su - labuser
id
exit

2.2.8
sudo useradd -m -s /bin/bash labuser2
sudo usermod -aG labgroup labuser2
id labuser
id labuser2
getent group labgroup

2.2.9
sudo mkdir -p /tmp/lab_shared
sudo chown root:labgroup /tmp/lab_shared
sudo chmod 0770 /tmp/lab_shared
stat -c '%a %U:%G %n' /tmp/lab_shared
sudo -u labuser touch /tmp/lab_shared/from_labuser
sudo -u labuser2 touch /tmp/lab_shared/from_labuser2
ls -l /tmp/lab_shared

2.2.10
sudo -u labuser sh -c 'umask 022; printf "original\n" > /tmp/lab_shared/shared_note'
sudo -u labuser2 cat /tmp/lab_shared/shared_note
sudo -u labuser2 sh -c 'echo changed >> /tmp/lab_shared/shared_note'
sudo -u labuser2 rm /tmp/lab_shared/shared_note
ls -l /tmp/lab_shared

2.2.11
sudo chmod g+s /tmp/lab_shared
stat -c '%a %A %U:%G' /tmp/lab_shared
sudo -u labuser touch /tmp/lab_shared/sgid_one
sudo -u labuser2 touch /tmp/lab_shared/sgid_two
ls -l /tmp/lab_shared/sgid_*

2.2.12
sudo mkdir -p /tmp/lab_public
sudo chmod 1777 /tmp/lab_public
ls -ld /tmp/lab_public
sudo -u labuser touch /tmp/lab_public/owned_by_labuser
sudo -u labuser2 touch /tmp/lab_public/owned_by_labuser2
sudo -u labuser2 rm /tmp/lab_public/owned_by_labuser
sudo -u labuser rm /tmp/lab_public/owned_by_labuser

2.2.13
sudo passwd -l labuser
sudo passwd -S labuser
su - labuser
sudo passwd -u labuser
sudo passwd -S labuser
su - labuser
exit

2.2.14
sudo chage -l labuser
sudo chage -d 0 labuser
sudo chage -l labuser
sudo chage -d "$(date +%F)" labuser

2.2.15
getent passwd labuser
sudo usermod -s /bin/sh labuser
getent passwd labuser
sudo usermod -s /bin/bash labuser
getent passwd labuser

2.2.16
sudo -u labuser2 touch /home/labuser2/leftover.txt
id labuser2
sudo userdel labuser2
getent passwd labuser2
ls -ld /home/labuser2
ls -ln /home/labuser2/leftover.txt
ls -l /home/labuser2/leftover.txt

2.2.17
cat /etc/passwd
getent passwd root
getent passwd daemon
getent passwd nobody
getent passwd "$(whoami)"

2.2.18
grep -E '^[[:space:]]*(UID_MIN|UID_MAX|SYS_UID_MIN|SYS_UID_MAX)[[:space:]]' /etc/login.defs
getent passwd | awk -F: '{print $1, $3}' | sort -k2,2n

2.2.19
sudo useradd -m -s /bin/bash testuser
sudo useradd -r -s "$(command -v nologin)" testsystem
getent passwd testuser
getent passwd testsystem
id testuser
id testsystem
ls -ld /home/testuser

2.2.20
sudo userdel testsystem
sudo useradd -r -m -s "$(command -v nologin)" testsystem
getent passwd testsystem
ls -ld /home/testsystem

2.2.21
getent passwd | awk -F: '$7 ~ /\/(nologin|false)$/ {print $1, "UID=" $3, "GID=" $4, "HOME=" $6, "SHELL=" $7}'
command -v nologin
command -v false

2.2.22
sudo passwd testuser
sudo usermod -s "$(command -v nologin)" testuser
getent passwd testuser
su - testuser
sudo -u testuser /usr/bin/id

2.2.23
sudo usermod -s /bin/false testuser
getent passwd testuser
su - testuser

2.2.24
sudo usermod -s /bin/bash testuser
getent passwd testuser
su - testuser
whoami
exit

2.2.25
ls -l /usr/bin/id
sudo usermod -s /usr/bin/id testuser
getent passwd testuser
su - testuser
sudo usermod -s /bin/bash testuser
getent passwd testuser

2.2.26
sudo groupadd -r testsystemgroup
sudo groupadd testgroup
getent group testsystemgroup
getent group testgroup

2.2.27
grep -E '^[[:space:]]*(GID_MIN|GID_MAX|SYS_GID_MIN|SYS_GID_MAX)[[:space:]]' /etc/login.defs
getent group testsystemgroup
getent group testgroup

2.2.28
sudo useradd -r -g testsystemgroup -M -s "$(command -v nologin)" serviceuser
getent passwd serviceuser
id serviceuser

2.2.29
su - testuser
sudo -l
sudo /usr/bin/id
exit

2.2.30
sudo visudo -f /etc/sudoers.d/lab3-testuser
sudo visudo -c
sudo -l -U testuser
su - testuser
sudo -n /usr/bin/id
sudo -n /usr/bin/whoami
exit

2.2.31
sudo visudo -f /etc/sudoers.d/lab3-testuser
sudo visudo -c
su - testuser
sudo -n /usr/bin/id
sudo -n /usr/bin/whoami
sudo -n /usr/bin/ls /root
exit
sudo rm /etc/sudoers.d/lab3-testuser

2.2.32
sudo groupadd testadmins
sudo visudo -f /etc/sudoers.d/lab3-testadmins
sudo visudo -c
sudo usermod -aG testadmins testuser
id testuser
su - testuser
id
sudo -n /usr/bin/id
exit
sudo gpasswd -d testuser testadmins
su - testuser
id
sudo -n /usr/bin/id
exit
sudo rm /etc/sudoers.d/lab3-testadmins
sudo visudo -c

2.2.33
sudo cp -a /etc/login.defs /etc/login.defs.lab3.backup
sudo cp -a /etc/default/useradd /etc/default/useradd.lab3.backup
ls -l /etc/login.defs.lab3.backup /etc/default/useradd.lab3.backup
sudo nano /etc/login.defs
grep -E '^[[:space:]]*(UID_MIN|UID_MAX|SYS_UID_MIN|SYS_UID_MAX|GID_MIN|GID_MAX|SYS_GID_MIN|SYS_GID_MAX|CREATE_HOME|UMASK|HOME_MODE|USERGROUPS_ENAB)[[:space:]]' /etc/login.defs
sudo useradd -D

2.2.34
grep -E '^UID_(MIN|MAX)[[:space:]]' /etc/login.defs
getent passwd | cut -d: -f1,3 | sort -t: -k2,2n
sudo useradd -m configuser1
id configuser1
sudo userdel -r configuser1

2.2.35
grep -E '^SYS_UID_(MIN|MAX)[[:space:]]' /etc/login.defs
getent passwd | awk -F: '$3>=700 && $3<=720 {print $1, $3}'
sudo useradd -r -M sysconfig1
sudo useradd -r -M sysconfig2
sudo useradd -r -M sysconfig3
id sysconfig1
id sysconfig2
id sysconfig3
sudo userdel sysconfig1
sudo userdel sysconfig2
sudo userdel sysconfig3

2.2.36
grep -E '^GID_(MIN|MAX)[[:space:]]' /etc/login.defs
getent group | awk -F: '$3>=30000 && $3<=30099 {print $1, $3}'
sudo groupadd configgroup1
getent group configgroup1
sudo groupdel configgroup1

2.2.37
grep -E '^SYS_GID_(MIN|MAX)[[:space:]]' /etc/login.defs
getent group | awk -F: '$3>=700 && $3<=720 {print $1, $3}'
sudo groupadd -r sysgroup1
sudo groupadd -r sysgroup2
sudo groupadd -r sysgroup3
getent group sysgroup1
getent group sysgroup2
getent group sysgroup3
sudo groupdel sysgroup1
sudo groupdel sysgroup2
sudo groupdel sysgroup3

2.2.38
grep -E '^CREATE_HOME[[:space:]]' /etc/login.defs
sudo useradd homeuser1
getent passwd homeuser1
ls -ld /home/homeuser1
sudo useradd homeuser2
getent passwd homeuser2
ls -ld /home/homeuser2
sudo userdel -r homeuser1
sudo userdel homeuser2

2.2.39
sudo useradd -r syshome1
getent passwd syshome1
ls -ld /home/syshome1
sudo useradd -r -m syshome2
getent passwd syshome2
ls -ld /home/syshome2
sudo userdel syshome1
sudo userdel -r syshome2

2.2.40
grep -E '^[[:space:]]*(UMASK|HOME_MODE)[[:space:]]' /etc/login.defs
sudo useradd -m modeuser1
stat -c '%a %U:%G %n' /home/modeuser1
sudo useradd -m modeuser2
stat -c '%a %U:%G %n' /home/modeuser2
sudo userdel -r modeuser1
sudo userdel -r modeuser2

2.2.41
grep -E '^USERGROUPS_ENAB[[:space:]]' /etc/login.defs
sudo useradd -D
sudo useradd ugrouptest1
id ugrouptest1
getent group ugrouptest1
sudo useradd ugrouptest2
id ugrouptest2
getent group ugrouptest2
sudo userdel ugrouptest1
sudo userdel ugrouptest2

2.2.42
sudo useradd -D
ORIGINAL_DEFAULT_SHELL=$(sudo useradd -D | sed -n 's/^SHELL=//p')
sudo useradd -D -s /bin/sh
sudo useradd defaultuser1
getent passwd defaultuser1
sudo userdel defaultuser1
sudo useradd -D -s "$ORIGINAL_DEFAULT_SHELL"
sudo useradd -D

2.2.43
ORIGINAL_BASE=$(sudo useradd -D | sed -n 's/^HOME=//p')
sudo mkdir -p /srv/lab3homes
sudo useradd -D -b /srv/lab3homes
sudo useradd -m defaultuser2
getent passwd defaultuser2
ls -ld /srv/lab3homes/defaultuser2
sudo userdel -r defaultuser2
sudo useradd -D -b "$ORIGINAL_BASE"
sudo useradd -D
sudo diff -u /etc/login.defs.lab3.backup /etc/login.defs
sudo diff -u /etc/default/useradd.lab3.backup /etc/default/useradd
sudo visudo -c
