# 🏗️ Architecture et Choix Techniques du Lab

## Vue d'ensemble

Ce lab a été conçu pour simuler une infrastructure d'entreprise réaliste tout en restant simple à déployer et à utiliser. Voici les choix techniques et pédagogiques qui ont guidé sa conception.

---

## 🎯 Objectifs Pédagogiques

### 1. Progression Naturelle
Le lab est structuré en 3 niveaux de difficulté :
- **Niveau 1 (DMZ)** : Vulnérabilités web classiques accessibles publiquement
- **Niveau 2 (Services Internes)** : Services backend avec credentials faibles
- **Niveau 3 (Pivot)** : Mouvement latéral et compromission complète

### 2. Réalisme
- Simule une vraie petite entreprise avec :
  - Applications web publiques (DMZ)
  - Bases de données backend
  - Services d'infrastructure (FTP, SSH)
  - Fichiers de backup et configuration
- Les vulnérabilités sont contextuelles et réalistes
- Les erreurs de configuration sont celles qu'on trouve vraiment en production

### 3. Reproductibilité
- Un seul fichier `docker-compose.yml` à lancer
- Pas de configuration manuelle complexe
- Reset complet en une commande
- Fonctionne identiquement sur toutes les plateformes

---

## 🏛️ Architecture Réseau

### Segmentation en 2 Zones

```
┌─────────────────────────────────────┐
│         ZONE DMZ (172.20.0.0/24)    │
│  Services exposés "à Internet"       │
│  - Applications web                  │
│  - Serveurs web                      │
└──────────────┬──────────────────────┘
               │
               │ Bridge
               │
┌──────────────┴──────────────────────┐
│    ZONE INTERNE (172.21.0.0/24)     │
│  Services backend                    │
│  - Bases de données                  │
│  - Services d'infrastructure         │
└─────────────────────────────────────┘
```

### Justification

**Pourquoi 2 réseaux ?**
- Simule une vraie architecture avec DMZ
- Permet de pratiquer le pivot réseau
- Plus réaliste qu'un seul réseau plat
- Enseigne les concepts de segmentation

**Pourquoi des IP statiques ?**
- Facilite la documentation et les TPs
- Permet des références constantes dans les exercices
- Plus simple pour les débutants
- Simule une infrastructure gérée

---

## 🎭 Choix des Services

### DMZ - Applications Web

#### BrokenCrystals (Node.js)
**Pourquoi ?**
- Application moderne avec API REST
- Technologies actuelles (GraphQL, JWT)
- Vulnérabilités OWASP Top 10 2024
- Bien maintenue et documentée

**Vulnérabilités incluses :**
- SQL Injection (via API)
- XSS (Stored et Reflected)
- JWT sans vérification de signature
- GraphQL Introspection activée
- SSRF via file upload
- XXE via XML parsing

#### DVWA (PHP)
**Pourquoi ?**
- Référence classique dans l'apprentissage
- Vulnérabilités progressives (low/medium/high)
- Interface claire pour les débutants
- Excellente documentation

**Vulnérabilités incluses :**
- SQL Injection classique
- XSS Reflected et Stored
- CSRF
- File Upload sans validation
- Command Injection
- File Inclusion (LFI/RFI)

#### Nginx (Serveur Web)
**Pourquoi ?**
- Simule un serveur d'entreprise mal configuré
- Vulnérabilités de configuration (pas de code)
- Très commun en production
- Idéal pour l'apprentissage de la reconnaissance

**Vulnérabilités incluses :**
- Directory Listing activé
- Fichiers sensibles exposés
- Fichiers de backup accessibles (.bak)
- Headers de sécurité manquants
- Information disclosure dans les erreurs

### Zone Interne - Services Backend

#### PostgreSQL & MySQL
**Pourquoi les deux ?**
- PostgreSQL : Moderne, très utilisé
- MySQL : Classique, legacy systems
- Permet de pratiquer sur les 2 principales SGBD
- Credentials différents pour varier les exercices

**Vulnérabilités :**
- Mots de passe faibles
- Ports exposés sans firewall
- Données sensibles non chiffrées
- Commentaires de dev dans le SQL

#### FTP (vsftpd)
**Pourquoi inclure FTP en 2024 ?**
- Encore très présent dans les anciennes infras
- Excellent pour apprendre la reconnaissance de services
- Simule les backups non sécurisés
- Facile à exploiter pour les débutants

**Vulnérabilités :**
- Credentials faibles
- Anonymous login activé
- Scripts avec credentials exposés
- Pas de chiffrement (pas de FTPS)

#### SSH (OpenSSH)
**Pourquoi ?**
- Service critique dans toute infrastructure
- Permet de pratiquer le brute force
- Point d'entrée pour la post-exploitation
- Réaliste : souvent mal configuré

**Vulnérabilités :**
- Password authentication activée
- Mot de passe faible
- Pas de rate limiting
- Pas de 2FA

#### Redis
**Pourquoi ?**
- Cache très utilisé en production
- Souvent mal sécurisé
- Permet des exploits intéressants
- Vulnérabilités moins connues des débutants

**Vulnérabilités :**
- Authentification faible
- Port exposé sans firewall
- Possibilité de module loading (selon version)
- Données de session exposées

---

## 📦 Choix Docker

### Pourquoi Docker Compose ?

**Avantages :**
✅ Installation en 1 commande  
✅ Isolation complète du système hôte  
✅ Reproductibilité parfaite  
✅ Reset facile et rapide  
✅ Pas besoin de ressources importantes (vs VMs)  
✅ Portabilité (Linux, Mac, Windows)  

**Vs. Machines Virtuelles :**
- Docker : 6-8 GB RAM suffisants
- VMs : 16-32 GB RAM nécessaires
- Docker : Démarrage en 30 secondes
- VMs : Démarrage en 3-5 minutes
- Docker : 10 GB d'espace disque
- VMs : 100+ GB d'espace disque

### Images Choisies

Toutes les images sont :
- ✅ Officielles ou largement utilisées
- ✅ Bien maintenues
- ✅ Documentées
- ✅ Légères (Alpine quand possible)
- ✅ Sécurisées (pas de backdoors cachées)

---

## 🎓 Choix Pédagogiques

### 1. Vulnérabilités Intentionnelles

**Principe :** Chaque vulnérabilité a un objectif pédagogique

| Vulnérabilité | Objectif d'apprentissage |
|---------------|--------------------------|
| Directory Listing | Reconnaissance de base |
| Fichiers .bak | Importance de la gestion des backups |
| Credentials en dur | Gestion des secrets |
| SQL Injection | Vulnérabilité web #1 |
| Weak passwords | Politique de mots de passe |
| Services exposés | Principe du moindre privilège |
| Pas de segmentation | Architecture réseau |

### 2. Progression Pédagogique

**Niveau 1 → Niveau 2 → Niveau 3**

```
Débutant (1-2h)          Intermédiaire (3-5h)      Avancé (5-8h)
    │                            │                       │
    ├─ Reconnaissance            ├─ Exploitation         ├─ Post-Exploitation
    ├─ Info Disclosure           ├─ SQL Injection        ├─ Pivot réseau
    ├─ Fichiers exposés          ├─ Accès services       ├─ Mouvement latéral
    └─ Scan de base              └─ Brute force          └─ Persistance
```

### 3. Réalisme vs. Simplicité

**Compromis choisis :**

✅ **Réaliste :**
- Architecture multi-tiers
- Services réels
- Vulnérabilités courantes
- Données sensibles réalistes

⚖️ **Simplifié :**
- Pas de pare-feu (pour faciliter l'apprentissage)
- Tous les services accessibles (pas de DMZ stricte)
- Credentials documentés
- Pas d'IDS/IPS

**Justification :** Le but est d'apprendre les techniques, pas de simuler exactement la production. Les défenses seront ajoutées dans les modules de contre-mesures.

---

## 🔧 Maintenance et Évolution

### Version Actuelle : 1.0

**Inclus :**
- ✅ 9 services vulnérables
- ✅ 2 réseaux isolés
- ✅ 30+ vulnérabilités uniques
- ✅ Documentation complète
- ✅ Scénarios d'attaque détaillés

### Évolutions Possibles (V2)

**Ajouts potentiels :**
- [ ] API GraphQL plus complexe
- [ ] Service Active Directory
- [ ] Container Docker supplémentaire pour attaques sur conteneurs
- [ ] Service VPN vulnérable
- [ ] Application avec JWT mal implémenté
- [ ] Service avec LDAP Injection

**Améliorations possibles :**
- [ ] Monitoring avec logs centralisés (ELK)
- [ ] IDS/IPS désactivable pour apprendre le bypass
- [ ] Génération automatique de trafic "normal"
- [ ] Dashboard de progression

---

## ⚠️ Limitations Connues

### Techniques

1. **Pas de défenses actives**
   - Pas de WAF par défaut
   - Pas d'IDS/IPS
   - Pas de rate limiting
   - **Justification :** Facilite l'apprentissage des bases

2. **Réseau simplifié**
   - Pas de vrai firewall entre DMZ et Interne
   - Tous les services accessibles depuis l'hôte
   - **Justification :** Évite la complexité réseau pour les débutants

3. **Pas de persistence des données sensibles**
   - Reset complet efface tout
   - **Justification :** Environnement d'apprentissage jetable

### Pédagogiques

1. **Credentials fournis**
   - Fichier credentials.txt trop évident
   - **Justification :** Point de départ pour les débutants complets

2. **Pas de faux positifs**
   - Toutes les vulnérabilités sont réelles et exploitables
   - **Justification :** Éviter la frustration des débutants

---

## 🎯 Utilisation Recommandée

### Pour les Formateurs

**Module 1-5 :** Utiliser pour les TPs de base
- Reconnaissance (Niveau 1)
- Exploitation web (Niveau 1)
- Post-exploitation (Niveau 2)

**Module 6-10 :** Utiliser pour les contre-mesures
- Ajouter un WAF sur les services web
- Implémenter un IDS sur le réseau
- Configurer les défenses
- Mesurer l'efficacité

### Pour les Apprenants

**Débutant :**
1. Commencer par QUICKSTART.md
2. Suivre les scénarios 1 et 2
3. Documenter chaque découverte
4. Temps estimé : 4-6 heures

**Intermédiaire :**
1. Faire tous les scénarios
2. Tenter de trouver des vulnérabilités non documentées
3. Rédiger un rapport complet
4. Temps estimé : 8-12 heures

**Avancé :**
1. Exploiter sans regarder les scénarios
2. Créer ses propres payloads
3. Établir la persistance
4. Créer ses propres scénarios d'attaque
5. Temps estimé : 12-16 heures

---

## 📈 Métriques de Succès

### Pour l'Apprenant

✅ Vous avez réussi si vous pouvez :
- Découvrir tous les services sans aide
- Exploiter au moins 5 vulnérabilités différentes
- Compromettre au moins 1 service par niveau
- Documenter la chaîne d'attaque complète
- Proposer des contre-mesures appropriées

### Pour le Formateur

✅ Le lab est efficace si :
- 90%+ des apprenants réussissent le Niveau 1
- 70%+ des apprenants réussissent le Niveau 2
- 50%+ des apprenants réussissent le Niveau 3
- Les apprenants peuvent expliquer chaque vulnérabilité
- Les apprenants savent proposer des corrections

---

## 🔐 Considérations de Sécurité

### ⚠️ IMPORTANT

**Ce lab contient des vulnérabilités intentionnelles !**

**À FAIRE :**
✅ Utiliser sur une machine isolée ou VM  
✅ Désactiver les connexions réseau externes si possible  
✅ Détruire le lab après utilisation  
✅ Ne JAMAIS déployer en production  

**À NE PAS FAIRE :**
❌ Déployer sur un serveur cloud public  
❌ Exposer les ports sur Internet  
❌ Utiliser les mêmes mots de passe ailleurs  
❌ Conserver les données après formation  

### Isolation Recommandée

**Option 1 : VM isolée (Recommandé)**
```
[Machine Physique]
    └── [VM Kali Linux]
        └── [Lab Docker]
```

**Option 2 : Réseau Host-Only**
```
[Machine Physique] (pas d'accès Internet pour le lab)
    └── [Lab Docker] (network: host-only)
```

**Option 3 : Cloud privé**
```
[VPC Privé sans route Internet]
    └── [Lab Docker]
```

---

## 📚 Références et Inspiration

Ce lab s'inspire de :
- **OWASP** : Top 10 et méthodologies
- **PTES** : Penetration Testing Execution Standard
- **HackTheBox** : Approche progressive
- **TryHackMe** : Pédagogie structurée
- **VulnHub** : Machines d'entraînement

**Différences clés :**
- Plus simple à installer (1 commande)
- Plus progressif (3 niveaux clairs)
- Plus documenté (scénarios détaillés)
- Plus intégré (tout dans un lab)

---

## 🎓 Conclusion

Ce lab représente un compromis équilibré entre :
- **Réalisme** : Architecture et vulnérabilités crédibles
- **Simplicité** : Installation et utilisation faciles
- **Pédagogie** : Progression claire et documentée
- **Reproductibilité** : Fonctionne partout identiquement

Il est conçu pour être :
- Un **outil d'apprentissage** pour les débutants
- Un **bac à sable** pour les intermédiaires
- Un **terrain de jeu** pour les avancés
- Une **base de TP** pour les formateurs

**Version :** 1.0  
**Date :** Novembre 2024  
**Équipe :** Ascent Formation
