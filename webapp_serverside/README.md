# Library Server - Backend API

## Installation

1. Installer les dépendances :
```bash
npm install
```

2. Configurer la base de données :
   - Créer une base de données MySQL nommée `library_db`
   - Importer le fichier SQL : `library_database.sql`

3. Configurer les variables d'environnement :
   - Modifier le fichier `.env` avec vos paramètres de base de données

4. Démarrer le serveur :
```bash
npm start
```

Le serveur démarre sur le port 3000 par défaut.

## API Endpoints

### Books
- `GET /api/books` - Récupérer tous les livres
- `GET /api/books/:id` - Récupérer un livre spécifique
- `POST /api/books` - Ajouter un livre
- `PUT /api/books/:id` - Modifier un livre
- `DELETE /api/books/:id` - Supprimer un livre

### Authors
- `GET /api/authors` - Récupérer tous les auteurs

### Publishers
- `GET /api/publishers` - Récupérer tous les éditeurs

### Genres
- `GET /api/genres` - Récupérer tous les genres

### Reviews
- `GET /api/reviews` - Récupérer tous les avis

### Users
- `POST /api/register` - Créer un compte
- `POST /api/login` - Se connecter
- `POST /api/logout` - Se déconnecter
- `GET /api/session` - Obtenir la session actuelle

## Configuration

Les variables d'environnement sont dans le fichier `.env` :
- `WEB_PORT` - Port du serveur (défaut: 3000)
- `DB_HOST` - Hôte de la base de données
- `DB_USER` - Utilisateur de la base de données
- `DB_PASSWORD` - Mot de passe de la base de données
- `DB_NAME` - Nom de la base de données
- `CLIENT_URL` - URL du client pour CORS

