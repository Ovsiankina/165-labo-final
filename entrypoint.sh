#!/usr/bin/env bash
# 1. Launch mongod in the background so we can restore into it
mongod --dbpath /data/db --bind_ip_all --fork --logpath /var/log/mongod-init.log
# 2. Restore all databases from /dump, dropping existing data
if [ -d /dump ]; then
  echo "==> Restoring MongoDB from /dump"
  mongorestore --drop /dump
else
  echo "==> No /dump directory found; skipping restore"
fi
# 3. Shut down the init mongod
mongod --dbpath /data/db --shutdown
echo "==> Initial restore complete."
# 4. Exec the real mongod (so Docker receives signals correctly)
exec mongod --auth --bind_ip_all
