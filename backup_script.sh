#!/bin/bash
# Script de backup automatique
# Date: 2023-10-15
# Auteur: admin@acmecorp.local

# Configuration des bases de données
POSTGRES_HOST="172.21.0.20"
POSTGRES_USER="dbuser"
POSTGRES_PASS="weak_password"
POSTGRES_DB="webapp"

MYSQL_HOST="172.21.0.21"
MYSQL_USER="root"
MYSQL_PASS="root"
MYSQL_DB="admin_db"

# Dossier de destination
BACKUP_DIR="/backup/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Backup PostgreSQL
echo "Backup PostgreSQL..."
PGPASSWORD=$POSTGRES_PASS pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER $POSTGRES_DB > $BACKUP_DIR/postgres_backup.sql

# Backup MySQL
echo "Backup MySQL..."
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASS $MYSQL_DB > $BACKUP_DIR/mysql_backup.sql

# Backup fichiers de configuration
echo "Backup configs..."
tar -czf $BACKUP_DIR/config_backup.tar.gz /etc/nginx/ /etc/php/ /var/www/

# Upload vers FTP
echo "Upload vers FTP..."
ftp -n 172.21.0.30 << EOF
user ftpuser ftp123
binary
cd backups
lcd $BACKUP_DIR
mput *
bye
EOF

# Notification
echo "Backup terminé: $(date)" | mail -s "Backup Daily OK" admin@acmecorp.local

# Nettoyage des backups de plus de 30 jours
find /backup/* -mtime +30 -delete

echo "Backup process completed successfully!"
