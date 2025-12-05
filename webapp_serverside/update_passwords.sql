-- Mise à jour de la table users pour utiliser bcrypt
-- Utiliser ce script APRÈS avoir créé la base de données

-- Mot de passe pour tous : admin123 (hash bcrypt)
UPDATE users SET password_hash = '$2b$10$nMaF4tE3dAq1MhMg6zJGOeWFCSd3fVfgsdSED1Tp3MQG5pkO1eaMy' WHERE user_id = 1;
UPDATE users SET password_hash = '$2b$10$nMaF4tE3dAq1MhMg6zJGOeWFCSd3fVfgsdSED1Tp3MQG5pkO1eaMy' WHERE user_id = 2;
UPDATE users SET password_hash = '$2b$10$nMaF4tE3dAq1MhMg6zJGOeWFCSd3fVfgsdSED1Tp3MQG5pkO1eaMy' WHERE user_id = 3;

-- Vérifier les utilisateurs
SELECT user_id, username, email, role FROM users;

