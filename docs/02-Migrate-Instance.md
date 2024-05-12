# Migrate Instance

## Backup

### Firefish DB

```bash
sudo systemctl start postgres-backup
```

TODO

### Archivedon Resource

TODO

## Restore

### Firefish DB

```bash
sudo systemctl stop firefish
sudo -u postgres psql -c 'DROP DATABASE firefish;'
sudo -u postgres psql -c "CREATE DATABASE firefish WITH OWNER firefish_user ENCODING 'UTF-8';"
sudo -u postgres pg_restore -d firefish db_firefish.dump
sudo systemctl restart firefish
```

### Archivedon Resource

TODO
