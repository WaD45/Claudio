# 🚀 Guide de Démarrage Rapide

## Installation en 5 minutes

### 1. Vérifier les prérequis
```bash
# Docker installé ?
docker --version
# Doit afficher : Docker version 20.10.x ou supérieur

# Docker Compose installé ?
docker-compose --version
# Doit afficher : Docker Compose version 2.x ou supérieur
```

### 2. Lancer le lab
```bash
# Se placer dans le dossier
cd pentest-lab

# Démarrer tous les services
docker-compose up -d

# Attendre 1-2 minutes que tout démarre
docker-compose ps
```

### 3. Vérifier que tout fonctionne
```bash
# Tous les services doivent être "Up"
docker-compose ps

# Tester les URLs
curl -I http://localhost:8080  # BrokenCrystals
curl -I http://localhost:8081  # DVWA
curl -I http://localhost:8082  # Nginx
```

## Premier Test

### Test 1 : Découverte de fichiers sensibles

1. Ouvrir un navigateur : http://localhost:8082
2. Cliquer sur `/secrets/`
3. Télécharger `credentials.txt`
4. **Résultat attendu** : Vous avez les credentials de toute l'infrastructure !

### Test 2 : SQL Injection basique

1. Aller sur http://localhost:8081
2. Login: `admin` / Password: `password`
3. Dans le menu, choisir "SQL Injection"
4. Security level : `low`
5. Tester : `1' OR '1'='1`
6. **Résultat attendu** : Toutes les données s'affichent

### Test 3 : Accès FTP

```bash
ftp localhost 21
# Username: ftpuser
# Password: ftp123

ls
cd backups
ls
get backup_script.sh
bye
```

**Résultat attendu** : Vous récupérez un script avec des credentials

## Commandes Utiles

### Gestion du lab
```bash
# Voir les logs en temps réel
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f brokencrystals

# Redémarrer un service
docker-compose restart dvwa

# Entrer dans un conteneur
docker-compose exec brokencrystals sh
```

### Reset rapide
```bash
# Redémarrer proprement
docker-compose restart

# Reset complet (efface les données)
docker-compose down -v
docker-compose up -d
```

### En cas de problème
```bash
# Voir l'état détaillé
docker-compose ps -a

# Arrêter tout
docker-compose down

# Nettoyer complètement
docker-compose down -v --remove-orphans
docker system prune -f

# Relancer
docker-compose up -d
```

## Checklist de Premiers Tests

- [ ] Page web principale accessible (http://localhost:8082)
- [ ] BrokenCrystals fonctionne (http://localhost:8080)
- [ ] DVWA fonctionne (http://localhost:8081)
- [ ] Fichiers secrets trouvés (/secrets/credentials.txt)
- [ ] Fichier backup trouvé (config.php.bak)
- [ ] FTP accessible (port 21)
- [ ] SSH accessible (port 2222)
- [ ] Bases de données accessibles (ports 5432 et 3306)

## Prochaines Étapes

Une fois que tout fonctionne :

1. **Lire le README.md complet** pour comprendre l'architecture
2. **Suivre le parcours pédagogique** niveau par niveau
3. **Pratiquer avec les scénarios** fournis
4. **Documenter vos découvertes** comme dans un vrai pentest

## URLs Principales

| Service | URL | Credentials |
|---------|-----|-------------|
| Page d'accueil | http://localhost:8082 | N/A |
| BrokenCrystals | http://localhost:8080 | admin@acmecorp.local / Admin123! |
| DVWA | http://localhost:8081 | admin / password |
| Admin Panel | http://localhost:8083 | administrator / Admin@2023 |
| PostgreSQL | localhost:5432 | dbuser / weak_password |
| MySQL | localhost:3306 | root / root |
| FTP | localhost:21 | ftpuser / ftp123 |
| SSH | localhost:2222 | admin / admin123 |

## Bon Apprentissage ! 🎓

N'oubliez pas :
- C'est un environnement d'apprentissage **sûr**
- Vous **pouvez** tout casser, c'est fait pour !
- Si vous cassez quelque chose : `docker-compose down -v && docker-compose up -d`
- Amusez-vous et apprenez ! 🚀
