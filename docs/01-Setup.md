# Setup

## Initial provision

```
$ mkdir -p /home/workuser/.ssh
$ echo 'ssh-pubkey' >> /home/workuser/.ssh/authorized_keys
$ su
# apt update -y
# apt install -y sudo
# gpasswd -a workuser sudo
# echo 'Port PORT' | tee /etc/ssh/sshd_config.d/server.conf
# systemctl reboot
```

## Upgrade packages

```
sudo apt install --only-upgrade PACKAGE
```
