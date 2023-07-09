# Setup

## Initial provision

Copy `./scripts/provision/init.sh`, and

```
$ su
# env SSH_PORT=port SSH_AUTHORIZED_KEY='public key' WORKUSER="workuser" bash init.sh
# systemctl reboot
```

## Upgrade packages

```
sudo apt install --only-upgrade PACKAGE
```
