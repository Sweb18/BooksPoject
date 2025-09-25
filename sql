
-- Drop tables
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS book_genres;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS users;

-- Utilisateurs
CREATE TABLE users (
  user_id        INT AUTO_INCREMENT PRIMARY KEY,
  username       VARCHAR(100) NOT NULL UNIQUE,
  email          VARCHAR(255) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  role           VARCHAR(50) NOT NULL DEFAULT 'USER'
);

-- Auteurs
CREATE TABLE authors (
  author_id   INT AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(100),
  last_name   VARCHAR(100) NOT NULL,
  bio         TEXT
);

-- Éditeurs
CREATE TABLE publishers (
  publisher_id  INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(150) NOT NULL UNIQUE,
  country       VARCHAR(100)
);

-- Langues
CREATE TABLE languages (
  code  VARCHAR(8) PRIMARY KEY,  -- ex: 'en', 'fr'
  name  VARCHAR(100) NOT NULL
);

-- Genres
CREATE TABLE genres (
  genre_id  INT AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(100) NOT NULL UNIQUE
);

-- Livres
CREATE TABLE books (
  book_id          INT AUTO_INCREMENT PRIMARY KEY,
  title            VARCHAR(255) NOT NULL,
  subtitle         VARCHAR(255),
  isbn13           VARCHAR(13) UNIQUE,
  author_id        INT,
  publisher_id     INT,
  publication_date DATE,
  language_code    VARCHAR(8),
  page_count       INT,
  description      TEXT,
  FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE SET NULL,
  FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
  FOREIGN KEY (language_code) REFERENCES languages(code) ON DELETE SET NULL
);

-- Relation M:N : livres <-> genres
CREATE TABLE book_genres (
  book_id   INT NOT NULL,
  genre_id  INT NOT NULL,
  PRIMARY KEY (book_id, genre_id),
  FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE RESTRICT
);

-- Avis sur les livres
CREATE TABLE reviews (
  review_id   INT AUTO_INCREMENT PRIMARY KEY,
  user_id     INT NOT NULL,
  book_id     INT NOT NULL,
  rating      INT CHECK (rating BETWEEN 1 AND 5),
  title       VARCHAR(255),
  body        TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

INSERT INTO genres (name) VALUES ('Fantasy');
INSERT INTO genres (name) VALUES ('Science Fiction');
INSERT INTO genres (name) VALUES ('Thriller');
INSERT INTO genres (name) VALUES ('Dystopia');
INSERT INTO authors (first_name, last_name) VALUES ('J.K.', 'Rowling'), ('George', 'Orwell'), ('Victor', 'Hugo');
INSERT INTO users (username, email, password_hash, role) VALUES ('MaxLaMenace', 'maxou@exemple.com', 'mdp123', 'USER');
INSERT INTO books (title, author_id) VALUES ('Harry Potter and the Secret Room', 1), ('1984', 2), ('Les Contemplations', 3);
INSERT INTO book_genres (book_id, genre_id) SELECT b.book_id, g.genre_id FROM books b, genres g WHERE b.title = 'Harry Potter and the Secret Room' AND g.name = 'Fantasy';
