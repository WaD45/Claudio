# 📚 Lab de Pentesting Progressif - Index des Documents

Bienvenue dans le lab de pentesting Ascent Formation ! Cette page liste tous les documents disponibles.

---

## 🚀 Pour Commencer

### 1. [QUICKSTART.md](QUICKSTART.md) ⭐ **COMMENCER ICI**
Guide de démarrage rapide pour installer et tester le lab en 5 minutes.
- Installation en 3 étapes
- Premiers tests
- Vérification que tout fonctionne
- **Temps : 10-15 minutes**

### 2. [README.md](README.md)
Documentation complète du lab avec architecture détaillée.
- Vue d'ensemble de l'architecture
- Liste de tous les services
- Parcours pédagogique complet (4 niveaux)
- Credentials par défaut
- Dépannage

---

## 📖 Documentation Détaillée

### 3. [SCENARIOS.md](SCENARIOS.md) ⭐ **POUR LES TPs**
Scénarios d'attaque progressifs avec instructions pas-à-pas.
- **Scénario 1** : Information Disclosure (30 min - Débutant)
- **Scénario 2** : SQL Injection (45 min - Intermédiaire)
- **Scénario 3** : Credential Stuffing (30 min - Intermédiaire)
- **Scénario 4** : Post-Exploitation (60 min - Avancé)
- Questions de validation
- Recommandations de correction

### 4. [ARCHITECTURE.md](ARCHITECTURE.md)
Choix techniques et pédagogiques du lab.
- Objectifs pédagogiques
- Architecture réseau détaillée
- Justification des choix
- Limitations et évolutions futures
- Métriques de succès

### 5. [CHEATSHEET.md](CHEATSHEET.md) ⭐ **RÉFÉRENCE RAPIDE**
Aide-mémoire avec toutes les commandes essentielles.
- Gestion du lab
- Commandes de reconnaissance
- Exploitation web
- Accès aux services
- Post-exploitation
- Cracking de mots de passe

---

## 🗂️ Fichiers Techniques

### 6. docker-compose.yml
Fichier principal pour lancer tout le lab.
```bash
docker-compose up -d
```

### 7. Dossiers de Configuration
- `nginx-data/` - Configuration du serveur web
- `database/` - Scripts d'initialisation des DB
- `ftp-data/` - Fichiers du serveur FTP
- `ssh-data/` - Configuration SSH

---

## 🎯 Parcours Recommandés

### Pour les Débutants (4-6 heures)

```
1. Lire QUICKSTART.md (15 min)
2. Installer le lab (10 min)
3. Suivre le Scénario 1 dans SCENARIOS.md (30 min)
4. Suivre le Scénario 2 dans SCENARIOS.md (45 min)
5. Pratiquer avec CHEATSHEET.md (2-3 heures)
6. Documenter ses découvertes (1 heure)
```

### Pour les Intermédiaires (8-12 heures)

```
1. Lire README.md complet (30 min)
2. Installer le lab (10 min)
3. Tous les scénarios de SCENARIOS.md (3 heures)
4. Explorer sans guide (3-4 heures)
5. Lire ARCHITECTURE.md (30 min)
6. Rédiger un rapport complet (2-3 heures)
```

### Pour les Avancés (12-16 heures)

```
1. Installation rapide (10 min)
2. Exploitation complète sans guide (6-8 heures)
3. Créer ses propres scénarios (2-3 heures)
4. Lire ARCHITECTURE.md pour comprendre les choix (30 min)
5. Proposer des améliorations (1-2 heures)
6. Rapport professionnel détaillé (2-3 heures)
```

### Pour les Formateurs

```
1. Lire TOUS les documents (2-3 heures)
2. Tester le lab complètement (4-6 heures)
3. Adapter les scénarios à vos besoins (2-3 heures)
4. Préparer les supports de cours (variable)
```

---

## 📊 Utilisation des Documents

### Avant le Lab

**Obligatoire :**
- ✅ [QUICKSTART.md](QUICKSTART.md) - Installation et premiers pas

**Recommandé :**
- ✅ [README.md](README.md) - Comprendre l'architecture
- ✅ Parcourir [CHEATSHEET.md](CHEATSHEET.md) - Se familiariser avec les commandes

### Pendant le Lab

**Garder Ouverts :**
- 📖 [SCENARIOS.md](SCENARIOS.md) - Guide pas-à-pas
- 📝 [CHEATSHEET.md](CHEATSHEET.md) - Référence rapide des commandes

**Consulter si Besoin :**
- 🔍 [README.md](README.md) - Credentials et architecture
- 🛠️ [QUICKSTART.md](QUICKSTART.md) - Dépannage

### Après le Lab

**Pour Comprendre :**
- 🏗️ [ARCHITECTURE.md](ARCHITECTURE.md) - Choix techniques et pédagogiques

**Pour Approfondir :**
- Relire [SCENARIOS.md](SCENARIOS.md) - Comprendre les exploits
- Créer ses propres scénarios

---

## 🎓 Ressources par Niveau

### Niveau Débutant

**Documents essentiels :**
1. [QUICKSTART.md](QUICKSTART.md)
2. [SCENARIOS.md](SCENARIOS.md) - Scénarios 1 et 2
3. [CHEATSHEET.md](CHEATSHEET.md) - Sections "Reconnaissance" et "Exploitation Web"

**Temps estimé :** 4-6 heures

### Niveau Intermédiaire

**Documents essentiels :**
1. [README.md](README.md) - Parcours complet
2. [SCENARIOS.md](SCENARIOS.md) - Tous les scénarios
3. [CHEATSHEET.md](CHEATSHEET.md) - Toutes les sections

**Temps estimé :** 8-12 heures

### Niveau Avancé

**Documents recommandés :**
1. [ARCHITECTURE.md](ARCHITECTURE.md) - Comprendre les choix
2. [SCENARIOS.md](SCENARIOS.md) - Pour référence uniquement
3. Tous les autres documents en référence

**Temps estimé :** 12-16 heures

---

## 🔍 Trouver l'Information

### Par Type d'Information

| Information | Document |
|-------------|----------|
| Comment installer ? | [QUICKSTART.md](QUICKSTART.md) |
| Quels sont les credentials ? | [README.md](README.md) ou [CHEATSHEET.md](CHEATSHEET.md) |
| Comment exploiter X ? | [SCENARIOS.md](SCENARIOS.md) |
| Quelle commande utiliser ? | [CHEATSHEET.md](CHEATSHEET.md) |
| Pourquoi ce choix technique ? | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Problème technique ? | [QUICKSTART.md](QUICKSTART.md) ou [README.md](README.md) |
| Architecture réseau ? | [README.md](README.md) ou [ARCHITECTURE.md](ARCHITECTURE.md) |

### Par Objectif

| Objectif | Documents à Consulter |
|----------|----------------------|
| **Démarrer rapidement** | QUICKSTART.md → SCENARIOS.md |
| **Comprendre l'architecture** | README.md → ARCHITECTURE.md |
| **Faire les TPs** | SCENARIOS.md + CHEATSHEET.md |
| **Référence de commandes** | CHEATSHEET.md |
| **Approfondir** | ARCHITECTURE.md |

---

## ⚙️ Fichiers de Configuration

```
pentest-lab/
├── docker-compose.yml          # Configuration Docker (PRINCIPAL)
├── nginx-data/
│   ├── html/
│   │   ├── index.html          # Page d'accueil
│   │   └── config.php.bak      # Fichier de backup exposé
│   ├── conf/
│   │   └── nginx.conf          # Config Nginx vulnérable
│   └── secrets/
│       └── credentials.txt     # Credentials exposés
├── database/
│   ├── init-postgres.sql       # Init PostgreSQL
│   └── init-mysql.sql          # Init MySQL
├── ftp-data/
│   ├── README.txt              # Info FTP
│   └── backups/
│       └── backup_script.sh    # Script avec credentials
└── ssh-data/                   # Config SSH
```

---

## 📝 Liste de Vérification

### Installation
- [ ] Docker installé et fonctionnel
- [ ] Docker Compose installé
- [ ] Fichiers du lab téléchargés
- [ ] `docker-compose up -d` exécuté avec succès
- [ ] Tous les services "Up" dans `docker-compose ps`

### Premier Test
- [ ] http://localhost:8080 accessible (BrokenCrystals)
- [ ] http://localhost:8081 accessible (DVWA)
- [ ] http://localhost:8082 accessible (Nginx)
- [ ] Fichier credentials.txt trouvé
- [ ] FTP accessible (port 21)
- [ ] SSH accessible (port 2222)

### Exploitation
- [ ] Au moins 1 vulnérabilité web exploitée
- [ ] Accès à au moins 1 service interne
- [ ] Au moins 1 base de données compromise
- [ ] Mouvement latéral réalisé
- [ ] Rapport de test documenté

---

## 🆘 Aide et Support

### En cas de problème

1. **Consulter** [QUICKSTART.md](QUICKSTART.md) - Section dépannage
2. **Consulter** [README.md](README.md) - Section dépannage
3. **Vérifier** les logs : `docker-compose logs -f`
4. **Reset complet** : `docker-compose down -v && docker-compose up -d`

### Questions Fréquentes

**Q : Un conteneur ne démarre pas**
→ Voir les logs : `docker-compose logs [service]`

**Q : Un port est déjà utilisé**
→ Modifier dans docker-compose.yml ou arrêter le service qui utilise le port

**Q : Je ne trouve pas un fichier**
→ Vérifier le parcours complet : `/mnt/user-data/outputs/pentest-lab/`

**Q : Comment reset complètement ?**
→ `docker-compose down -v && docker-compose up -d`

---

## 📚 Ressources Externes

### Outils Recommandés
- **Kali Linux** : https://www.kali.org/
- **Burp Suite** : https://portswigger.net/burp
- **OWASP ZAP** : https://www.zaproxy.org/
- **Nuclei** : https://github.com/projectdiscovery/nuclei

### Documentation
- **OWASP Top 10** : https://owasp.org/www-project-top-ten/
- **PTES** : http://www.pentest-standard.org/
- **PortSwigger Academy** : https://portswigger.net/web-security

---

## ✅ Prochaines Étapes

1. **Si vous débutez :**
   - Commencez par [QUICKSTART.md](QUICKSTART.md)
   - Puis [SCENARIOS.md](SCENARIOS.md) Scénario 1

2. **Si vous êtes intermédiaire :**
   - Parcourez [README.md](README.md)
   - Faites tous les [SCENARIOS.md](SCENARIOS.md)

3. **Si vous êtes avancé :**
   - Exploitez le lab sans guide
   - Consultez [ARCHITECTURE.md](ARCHITECTURE.md)

4. **Si vous êtes formateur :**
   - Lisez tout
   - Testez complètement
   - Adaptez à vos besoins

---

## 📞 Contact

Pour toute question sur ce lab :
- **Email** : formation@ascent.com
- **Documentation** : docs.ascent-formation.com

---

**Version :** 1.0  
**Dernière mise à jour :** Novembre 2024  
**Équipe :** Ascent Formation

**Bon apprentissage ! 🚀**
