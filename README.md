# Lab de Pentesting Progressif -  Formation

## 🎯 Objectif

Ce lab Docker Compose simule une infrastructure d'entreprise réaliste avec de multiples vulnérabilités intentionnelles. Il est conçu pour l'apprentissage progressif du pentesting, de la reconnaissance initiale à la compromission complète de l'infrastructure.

## 📋 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     ZONE DMZ (172.20.0.0/24)                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌────────────┐ │
│  │ BrokenCrystals  │  │      DVWA       │  │   Nginx    │ │
│  │   (Node.js)     │  │     (PHP)       │  │  Webserver │ │
│  │   :8080         │  │     :8081       │  │   :8082    │ │
│  │ 172.20.0.10     │  │ 172.20.0.11     │  │ 172.20.0.12│ │
│  └─────────────────┘  └─────────────────┘  └────────────┘ │
│          │                     │                   │        │
└──────────┼─────────────────────┼───────────────────┼────────┘
           │                     │                   │
           │                     │                   │
┌──────────┼─────────────────────┼───────────────────┼────────┐
│          │        RÉSEAU INTERNE (172.21.0.0/24)   │        │
├──────────┼─────────────────────┼───────────────────┼────────┤
│          ▼                     ▼                   ▼        │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐     │
│  │ PostgreSQL  │  │    MySQL     │  │   FTP Server   │     │
│  │  :5432      │  │    :3306     │  │     :21        │     │
│  │172.21.0.20  │  │ 172.21.0.21  │  │  172.21.0.30   │     │
│  └─────────────┘  └──────────────┘  └────────────────┘     │
│                                                             │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐     │
│  │ SSH Server  │  │    Redis     │  │  Admin Panel   │     │
│  │  :2222      │  │    :6379     │  │     :8083      │     │
│  │172.21.0.31  │  │ 172.21.0.40  │  │  172.21.0.50   │     │
│  └─────────────┘  └──────────────┘  └────────────────┘     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 🚀 Installation

### Prérequis

- Docker Engine 20.10+ 
- Docker Compose 2.0+
- 8GB RAM minimum
- 20GB espace disque disponible

### Installation rapide

```bash
# Cloner ou créer le dossier
mkdir pentest-lab && cd pentest-lab

# Télécharger le docker-compose.yml
# (fichier fourni dans cette distribution)

# Lancer tout le lab
docker-compose up -d

# Vérifier que tous les services sont démarrés
docker-compose ps

# Consulter les logs en temps réel
docker-compose logs -f
```

### Arrêt et nettoyage

```bash
# Arrêter le lab (conserve les données)
docker-compose stop

# Redémarrer le lab
docker-compose start

# Arrêter et supprimer (nettoie tout)
docker-compose down

# Arrêter et supprimer avec les volumes (reset complet)
docker-compose down -v
```

## 🎮 Services Disponibles

### Zone DMZ (Niveau 1 - Débutant)

| Service | Port Local | IP Interne | Credentials | Vulnérabilités |
|---------|-----------|------------|-------------|----------------|
| **BrokenCrystals** | 8080 | 172.20.0.10 | admin / Admin123! | SQLi, XSS, JWT, GraphQL, SSRF, XXE |
| **DVWA** | 8081 | 172.20.0.11 | admin / password | SQLi, XSS, CSRF, File Upload, Command Injection |
| **Nginx** | 8082 | 172.20.0.12 | N/A | Directory Listing, Sensitive Files, Info Disclosure |

### Réseau Interne (Niveau 2 - Intermédiaire)

| Service | Port Local | IP Interne | Credentials | Vulnérabilités |
|---------|-----------|------------|-------------|----------------|
| **PostgreSQL** | 5432 | 172.21.0.20 | dbuser / weak_password | Weak Credentials, Default Config |
| **MySQL** | 3306 | 172.21.0.21 | root / root | Weak Credentials, Default Config |
| **FTP** | 21 | 172.21.0.30 | ftpuser / ftp123 | Weak Credentials, Anonymous Access |
| **SSH** | 2222 | 172.21.0.31 | admin / admin123 | Weak Credentials, Brute Force |
| **Redis** | 6379 | 172.21.0.40 | redis123 | Weak Auth, Cache Exploitation |
| **Admin Panel** | 8083 | 172.21.0.50 | administrator / Admin@2023 | IDOR, Privilege Escalation, SSRF |

## 📚 Parcours Pédagogique Recommandé

### 🟢 Niveau 1 : Reconnaissance et Découverte (2-3 heures)

**Objectifs :**
- Découvrir les services exposés
- Identifier les technologies utilisées
- Trouver des informations sensibles publiquement accessibles

**Exercices :**

1. **Scan réseau complet**
   ```bash
   # Depuis Kali VM
   nmap -sV -sC -p- localhost
   ```

2. **Exploration des applications web**
   - Visiter http://localhost:8080 (BrokenCrystals)
   - Visiter http://localhost:8081 (DVWA)
   - Visiter http://localhost:8082 (Nginx)

3. **Énumération web**
   ```bash
   # Scanner les répertoires
   dirb http://localhost:8082 /usr/share/dirb/wordlists/common.txt
   
   # Ou avec Nuclei (moderne)
   nuclei -u http://localhost:8082
   ```

4. **Découverte de fichiers sensibles**
   - Chercher les fichiers .bak, .backup, .old
   - Explorer /secrets, /config, /backup

**Résultats attendus :**
- Liste complète des services et versions
- Fichiers de configuration exposés
- Credentials découverts dans les fichiers

---

### 🟡 Niveau 2 : Exploitation Web (3-4 heures)

**Objectifs :**
- Exploiter des vulnérabilités web classiques
- Obtenir un accès initial aux applications
- Exfiltrer des données sensibles

**Exercices :**

1. **SQL Injection sur DVWA**
   ```bash
   # Test manuel
   ' OR '1'='1' --
   
   # Avec SQLMap
   sqlmap -u "http://localhost:8081/vulnerabilities/sqli/?id=1&Submit=Submit#" \
     --cookie="PHPSESSID=xxx; security=low" \
     --dbs
   ```

2. **XSS sur BrokenCrystals**
   ```javascript
   <script>alert(document.cookie)</script>
   ```

3. **Analyse GraphQL**
   ```bash
   curl -X POST http://localhost:8080/graphql \
     -H "Content-Type: application/json" \
     -d '{"query":"{ __schema { types { name } } }"}'
   ```

4. **JWT Token Analysis**
   - Intercepter les tokens JWT avec Burp Suite
   - Analyser sur jwt.io
   - Tenter de forger un token admin

**Résultats attendus :**
- Dump de bases de données
- Sessions hijackées
- Accès admin aux applications

---

### 🟠 Niveau 3 : Pivot et Mouvement Latéral (4-5 heures)

**Objectifs :**
- Utiliser les credentials trouvés
- Accéder aux services internes
- Établir la persistance

**Exercices :**

1. **Accès aux bases de données**
   ```bash
   # PostgreSQL
   psql -h localhost -p 5432 -U dbuser -d webapp
   # Password: weak_password
   
   # MySQL
   mysql -h localhost -P 3306 -u root -p
   # Password: root
   ```

2. **Connexion SSH**
   ```bash
   ssh admin@localhost -p 2222
   # Password: admin123
   ```

3. **Accès FTP**
   ```bash
   ftp localhost 21
   # Username: ftpuser
   # Password: ftp123
   
   # Explorer les backups
   cd backups
   ls
   get backup_script.sh
   ```

4. **Exploitation Redis**
   ```bash
   redis-cli -h localhost -p 6379 -a redis123
   
   # Lister les clés
   KEYS *
   
   # Dump les sessions
   GET session:*
   ```

**Résultats attendus :**
- Accès à tous les services internes
- Données exfiltrées depuis les bases
- Scripts et credentials récupérés depuis FTP
- Shell sur le serveur SSH

---

### 🔴 Niveau 4 : Compromission Complète (3-4 heures)

**Objectifs :**
- Élever les privilèges
- Compromettre l'infrastructure complète
- Établir la persistance
- Documenter la chaîne d'attaque

**Exercices :**

1. **Privilege Escalation**
   ```bash
   # Depuis le SSH
   sudo -l
   find / -perm -4000 -type f 2>/dev/null
   ```

2. **Mouvement inter-conteneurs**
   ```bash
   # Scanner depuis un conteneur compromis
   nmap -sn 172.21.0.0/24
   ```

3. **Extraction complète des données**
   - Dump de toutes les bases
   - Récupération de tous les fichiers sensibles
   - Cartographie complète du réseau

4. **Rédaction du rapport**
   - Chaîne d'attaque complète
   - Impact métier
   - Recommandations de correction

**Résultats attendus :**
- Root/Admin sur tous les systèmes
- Cartographie complète
- Rapport professionnel de pentesting

---

## 🔍 Credentials par Défaut

### Applications Web
```
BrokenCrystals:
  - admin@acmecorp.local / Admin123!

DVWA:
  - admin / password
  - user / user

Admin Panel:
  - administrator / Admin@2023
  - support / Support123
```

### Services Infrastructure
```
PostgreSQL:
  - dbuser / weak_password
  - postgres / postgres

MySQL:
  - root / root
  - dvwa / dvwa123

FTP:
  - ftpuser / ftp123
  - anonymous / (vide)

SSH:
  - admin / admin123

Redis:
  - redis123
```

## 📖 Ressources et Outils Recommandés

### Scanner et Reconnaissance
- **Nmap** : Scan de ports et services
- **Nuclei** : Scanner moderne de vulnérabilités (remplace Nikto)
- **OWASP ZAP** : Proxy et scanner web
- **Burp Suite Community** : Interception HTTP

### Exploitation
- **SQLMap** : Exploitation SQL Injection
- **Metasploit** : Framework d'exploitation
- **John the Ripper** : Cracking de passwords
- **Hydra** : Brute force d'authentification

### Post-Exploitation
- **LinPEAS** : Énumération Linux
- **pspy** : Monitoring de processus
- **CrackMapExec** : Mouvement latéral

## ⚠️ Avertissements

1. **UNIQUEMENT POUR L'APPRENTISSAGE** : Ce lab contient des vulnérabilités intentionnelles
2. **NE JAMAIS utiliser en production**
3. **Isoler le lab du réseau externe** si possible
4. **Credentials fictifs** : Ne jamais réutiliser ces mots de passe

## 🛠️ Dépannage

### Les conteneurs ne démarrent pas
```bash
# Vérifier les logs
docker-compose logs <service_name>

# Relancer un service spécifique
docker-compose restart <service_name>
```

### Problème de ports déjà utilisés
```bash
# Vérifier les ports utilisés
sudo netstat -tulpn | grep LISTEN

# Modifier les ports dans docker-compose.yml si nécessaire
```

### Reset complet du lab
```bash
# Tout supprimer et repartir de zéro
docker-compose down -v --remove-orphans
docker-compose up -d
```

## 📝 Notes Pédagogiques

Ce lab est conçu pour :
- Progresser du facile au difficile
- Simuler une infrastructure réaliste
- Couvrir les vulnérabilités OWASP Top 10
- Pratiquer les techniques de mouvement latéral
- Apprendre la documentation professionnelle

Chaque service a des vulnérabilités de différents niveaux, permettant un apprentissage progressif et la répétition des techniques.

## 🤝 Support

Pour toute question sur ce lab de formation :
- contactez-moi!

---

**Version :** 1.0  
**Dernière mise à jour :** Novembre 2024  
**Auteur :** Barry & Claude
