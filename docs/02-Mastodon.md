# Mastodon

## Create account

1. Create on Web
2. Run the below:

```bash
sudo -u mastodon tootctl accounts modify --role Owner --confirm USERNAME
```

## Upgrade instance

```bash
sudo systemctl start postgres-backup
sudo systemctl stop mastodon-web
sudo systemctl stop mastodon-sidekiq
sudo systemctl stop mastodon-streaming
cd /var/lib/mastodon/live
sudo -u mastodon git fetch
sudo -u mastodon git checkout vX.Y.Z
sudo -u mastodon bundle install
sudo -u mastodon yarn install --pure-lockfile
sudo -u mastodon env \
        RAILS_ENV=production \
        NODE_OPTIONS=--openssl-legacy-provider \
        bundle exec rake assets:precompile
sudo -u mastodon env \
        RAILS_ENV=production \
        bundle exec rake db:migrate
sudo systemctl start mastodon-web
sudo systemctl start mastodon-sidekiq
sudo systemctl start mastodon-streaming
```

## Refresh remote user

```bash
sudo -u mastodon tootctl accounts refresh 'username@example.com'
```
