-- Script d'initialisation PostgreSQL pour le lab
-- Base de données: webapp

-- Table des utilisateurs
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table des produits
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des commandes
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des logs
CREATE TABLE IF NOT EXISTS activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table des sessions
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id INT REFERENCES users(id),
    token TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertion de données de test
INSERT INTO users (username, email, password, role) VALUES
    ('admin', 'admin@acmecorp.local', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'admin'),
    ('john.doe', 'john.doe@acmecorp.local', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'user'),
    ('jane.smith', 'jane.smith@acmecorp.local', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'user'),
    ('bob.martin', 'bob.martin@acmecorp.local', 'password123', 'user'),
    ('alice.wonder', 'alice.wonder@acmecorp.local', 'alice2023', 'user');

-- Mot de passe hashé: 'password' pour admin et premiers users
-- bob.martin et alice.wonder ont des mots de passe en clair (vulnérabilité)

INSERT INTO products (name, description, price, stock, category) VALUES
    ('Laptop Pro 15"', 'Ordinateur portable haute performance', 1299.99, 25, 'Informatique'),
    ('Smartphone X', 'Smartphone dernière génération', 899.99, 50, 'Mobile'),
    ('Tablette Plus', 'Tablette 10 pouces', 399.99, 30, 'Mobile'),
    ('Casque Audio Premium', 'Casque à réduction de bruit', 249.99, 100, 'Audio'),
    ('Souris Gaming', 'Souris RGB programmable', 79.99, 150, 'Accessoires'),
    ('Clavier Mécanique', 'Clavier avec switches Cherry MX', 129.99, 75, 'Accessoires'),
    ('Webcam HD', 'Webcam 1080p pour visioconférence', 89.99, 60, 'Accessoires'),
    ('Moniteur 27"', 'Écran 4K IPS', 449.99, 20, 'Informatique');

INSERT INTO orders (user_id, total, status) VALUES
    (2, 1299.99, 'completed'),
    (3, 899.99, 'completed'),
    (4, 399.99, 'pending'),
    (5, 329.98, 'processing');

INSERT INTO activity_logs (user_id, action, details, ip_address) VALUES
    (1, 'login', 'Admin login successful', '192.168.1.100'),
    (2, 'order_placed', 'Order #1 placed', '192.168.1.101'),
    (3, 'product_view', 'Viewed product: Smartphone X', '192.168.1.102'),
    (1, 'user_created', 'Created user: bob.martin', '192.168.1.100');

-- Commentaire de développeur (information disclosure)
-- TODO: Implémenter l'authentification 2FA
-- TODO: Chiffrer les mots de passe en clair dans la base
-- TODO: Ajouter des contrôles d'accès sur les endpoints API
-- FIXME: Le endpoint /api/users est accessible sans authentification
-- NOTE: Le compte admin utilise toujours le mot de passe par défaut 'password'
