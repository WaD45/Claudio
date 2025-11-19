-- Script d'initialisation MySQL pour le lab
-- Base de données: dvwa

-- Création de la base pour DVWA (se fait automatiquement via variables d'env)
-- CREATE DATABASE IF NOT EXISTS dvwa;
USE dvwa;

-- Base admin_db pour le panel admin
CREATE DATABASE IF NOT EXISTS admin_db;
USE admin_db;

-- Table des administrateurs
CREATE TABLE IF NOT EXISTS administrators (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    role ENUM('super_admin', 'admin', 'moderator') DEFAULT 'admin',
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des clients
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table des documents sensibles
CREATE TABLE IF NOT EXISTS confidential_documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    classification ENUM('public', 'internal', 'confidential', 'secret') DEFAULT 'internal',
    owner_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES administrators(id)
);

-- Table des cartes de crédit (à ne JAMAIS faire en vrai!)
CREATE TABLE IF NOT EXISTS payment_cards (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    card_number VARCHAR(16) NOT NULL,
    cardholder_name VARCHAR(100) NOT NULL,
    expiry_month TINYINT NOT NULL,
    expiry_year SMALLINT NOT NULL,
    cvv VARCHAR(4) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insertion de données de test
INSERT INTO administrators (username, password, email, role) VALUES
    ('administrator', '5f4dcc3b5aa765d61d8327deb882cf99', 'admin@acmecorp.local', 'super_admin'),
    ('support', 'e10adc3949ba59abbe56e057f20f883e', 'support@acmecorp.local', 'admin'),
    ('moderator', '5f4dcc3b5aa765d61d8327deb882cf99', 'moderator@acmecorp.local', 'moderator');
-- Mots de passe MD5 (très faibles!): administrator/Admin@2023, support/Support123, moderator/password

INSERT INTO customers (first_name, last_name, email, phone, address, city, postal_code, country) VALUES
    ('Jean', 'Dupont', 'jean.dupont@example.com', '+33612345678', '123 rue de la Paix', 'Paris', '75001', 'France'),
    ('Marie', 'Martin', 'marie.martin@example.com', '+33623456789', '456 avenue Victor Hugo', 'Lyon', '69001', 'France'),
    ('Pierre', 'Durand', 'pierre.durand@example.com', '+33634567890', '789 boulevard Haussmann', 'Marseille', '13001', 'France'),
    ('Sophie', 'Bernard', 'sophie.bernard@example.com', '+33645678901', '321 rue du Commerce', 'Toulouse', '31000', 'France');

INSERT INTO confidential_documents (title, content, classification, owner_id) VALUES
    ('Plan Stratégique 2024', 'Contenu confidentiel du plan stratégique...', 'confidential', 1),
    ('Résultats Financiers Q3', 'Chiffre d''affaires: 2.5M€, Bénéfices: 450K€', 'confidential', 1),
    ('Liste des Salaires', 'PDG: 150K€/an, Directeur: 80K€/an, Employés: 35-45K€/an', 'secret', 1),
    ('Code Source Application', 'Repository: git@internal.acmecorp.local:app/backend.git', 'internal', 2),
    ('Credentials Infrastructure', 'AWS Access Key: AKIAIOSFODNN7EXAMPLE', 'secret', 1);

INSERT INTO payment_cards (customer_id, card_number, cardholder_name, expiry_month, expiry_year, cvv) VALUES
    (1, '4532015112830366', 'JEAN DUPONT', 12, 2025, '123'),
    (2, '5425233430109903', 'MARIE MARTIN', 06, 2026, '456'),
    (3, '374245455400126', 'PIERRE DURAND', 09, 2024, '789'),
    (4, '6011000991300009', 'SOPHIE BERNARD', 03, 2027, '234');

-- Commentaires de développeur (information disclosure)
-- TODO: Migrer vers un système de tokenization pour les cartes de crédit
-- FIXME: Les mots de passe admin sont stockés en MD5 (très faible!)
-- WARNING: La table payment_cards ne devrait JAMAIS exister en production
-- NOTE: Implémenter le chiffrement AES-256 pour les données sensibles
-- SECURITY: Ajouter des contrôles d'accès basés sur les rôles (RBAC)

-- Création d'un utilisateur avec privilèges limités (mais toujours trop de droits)
GRANT SELECT, INSERT, UPDATE ON admin_db.* TO 'dvwa'@'%';
FLUSH PRIVILEGES;
