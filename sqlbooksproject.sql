
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
  bio         TEXT,
  birth_date DATE,
  death_date DATE NULL,
  nationality VARCHAR(100),
  website VARCHAR(255),
  portrait_url VARCHAR(255)
);

-- Éditeurs
CREATE TABLE publishers (
  publisher_id  INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(150) NOT NULL UNIQUE,
  country       VARCHAR(100),
  founded_year YEAR,
  headquarters_city VARCHAR(100),
  website VARCHAR(255),
  contact_email VARCHAR(255),
  phone VARCHAR(30)
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
INSERT INTO languages (code, name) VALUES
 ('en', 'English'),
 ('fr', 'Français'),
 ('es', 'Español');

INSERT INTO genres (name) VALUES
 ('Fantasy'),
 ('Science Fiction'),
 ('Classic');

INSERT INTO users (username, email, password_hash, role) VALUES
 ('user1', 'user1@example.com', 'hash1', 'USER'),
 ('user2', 'user2@example.com', 'hash2', 'USER'),
 ('user3', 'user3@example.com', 'hash3', 'USER');

INSERT INTO authors (first_name, last_name, bio, birth_date, death_date, nationality, website, portrait_url) VALUES
 ('J.K.', 'Rowling', 'British author of the Harry Potter series.', '1965-07-31', NULL, 'British', 'https://www.jkrowling.com', 'https://example.com/portraits/rowling.jpg'),
 ('George', 'Orwell', 'English novelist, essayist, journalist and critic.', '1903-06-25', '1950-01-21', 'British', NULL, NULL),
 ('Victor', 'Hugo', 'French poet, novelist, and dramatist of the Romantic movement.', '1802-02-26', '1885-05-22', 'French', NULL, NULL),
 ('Jane', 'Austen', 'English novelist known primarily for her six major novels.', '1775-12-16', '1817-07-18', 'British', NULL, NULL),
 ('Mark', 'Twain', 'American writer, humorist, entrepreneur, publisher, and lecturer.', '1835-11-30', '1910-04-21', 'American', NULL, NULL),
 ('Agatha', 'Christie', 'English writer known for her sixty-six detective novels.', '1890-09-15', '1976-01-12', 'British', NULL, NULL),
 ('Ernest', 'Hemingway', 'American novelist, short-story writer, and journalist.', '1899-07-21', '1961-07-02', 'American', NULL, NULL),
 ('Gabriel García', 'Márquez', 'Colombian novelist, short-story writer, and journalist.', '1927-03-06', '2014-04-17', 'Colombian', NULL, NULL),
 ('Haruki', 'Murakami', 'Japanese writer known for his surrealistic fiction.', '1949-01-12', NULL, 'Japanese', NULL, NULL),
 ('Stephen', 'King', 'American author of horror, supernatural fiction, suspense, crime, and fantasy novels.', '1947-09-21', NULL, 'American', NULL, NULL);

INSERT INTO publishers (name, country, founded_year, headquarters_city, website, contact_email, phone) VALUES
 ('Bloomsbury', 'United Kingdom', 1986, 'London', 'https://www.bloomsbury.com', 'info@bloomsbury.com', '+44 20 7000 0000'),
 ('Secker & Warburg', 'United Kingdom', 1935, 'London', NULL, NULL, NULL),
 ('Gallimard', 'France', 1911, 'Paris', 'https://www.gallimard.fr', 'contact@gallimard.fr', '+33 1 0000 0000'),
 ('Penguin Books', 'United Kingdom', 1935, 'London', 'https://www.penguin.co.uk', 'hello@penguin.co.uk', '+44 20 0000 0000'),
 ('HarperCollins', 'United States', 1989, 'New York', 'https://www.harpercollins.com', 'info@harpercollins.com', '+1 212 000 0000'),
 ('Random House', 'United States', 1927, 'New York', 'https://www.randomhousebooks.com', NULL, NULL),
 ('Hachette', 'France', 1826, 'Paris', 'https://www.hachette.com', NULL, NULL),
 ('Simon & Schuster', 'United States', 1924, 'New York', 'https://www.simonandschuster.com', NULL, NULL),
 ('Macmillan', 'United Kingdom', 1843, 'London', 'https://www.macmillan.com', NULL, NULL),
 ('Faber & Faber', 'United Kingdom', 1929, 'London', 'https://www.faber.co.uk', NULL, NULL);


-- 1
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'Harry Potter and the Chamber of Secrets', NULL, '9780439064873',
       a.author_id, p.publisher_id, '1998-07-02', 'en', 341,
       'Second book in the Harry Potter series.'
FROM authors a, publishers p
WHERE a.last_name='Rowling' AND p.name='Bloomsbury'
LIMIT 1;

-- 2
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT '1984', NULL, '9780451524935',
       a.author_id, p.publisher_id, '1949-06-08', 'en', 328,
       'Dystopian social science fiction novel.'
FROM authors a, publishers p
WHERE a.last_name='Orwell' AND p.name='Secker & Warburg'
LIMIT 1;

-- 3
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'Les Misérables', NULL, '9782070409189',
       a.author_id, p.publisher_id, '1862-01-01', 'fr', 1463,
       'Roman classique de Victor Hugo.'
FROM authors a, publishers p
WHERE a.last_name='Hugo' AND p.name='Gallimard'
LIMIT 1;

-- 4
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'Pride and Prejudice', NULL, '9780141439518',
       a.author_id, p.publisher_id, '1813-01-28', 'en', 432,
       'A romantic novel of manners by Jane Austen.'
FROM authors a, publishers p
WHERE a.last_name='Austen' AND p.name='Penguin Books'
LIMIT 1;

-- 5
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'Adventures of Huckleberry Finn', NULL, '9780486280615',
       a.author_id, p.publisher_id, '1884-12-10', 'en', 366,
       'Novel by Mark Twain.'
FROM authors a, publishers p
WHERE a.last_name='Twain' AND p.name='HarperCollins'
LIMIT 1;

-- 6
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'Murder on the Orient Express', NULL, '9780062693662',
       a.author_id, p.publisher_id, '1934-01-01', 'en', 288,
       'Detective novel by Agatha Christie.'
FROM authors a, publishers p
WHERE a.last_name='Christie' AND p.name='HarperCollins'
LIMIT 1;

-- 7
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'The Old Man and the Sea', NULL, '9780684801223',
       a.author_id, p.publisher_id, '1952-09-01', 'en', 127,
       'Short novel by Ernest Hemingway.'
FROM authors a, publishers p
WHERE a.last_name='Hemingway' AND p.name='Simon & Schuster'
LIMIT 1;

-- 8
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'One Hundred Years of Solitude', NULL, '9780060883287',
       a.author_id, p.publisher_id, '1967-05-30', 'es', 417,
       'Novel by Gabriel García Márquez.'
FROM authors a, publishers p
WHERE a.last_name='Márquez' AND p.name='HarperCollins'
LIMIT 1;

-- 9
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'Kafka on the Shore', NULL, '9781400079278',
       a.author_id, p.publisher_id, '2002-09-12', 'en', 505,
       'Novel by Haruki Murakami.'
FROM authors a, publishers p
WHERE a.last_name='Murakami' AND p.name='Random House'
LIMIT 1;

-- 10
INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language_code, page_count, description)
SELECT 'The Shining', NULL, '9780307743657',
       a.author_id, p.publisher_id, '1977-01-28', 'en', 447,
       'Horror novel by Stephen King.'
FROM authors a, publishers p
WHERE a.last_name='King' AND p.name='Random House'
LIMIT 1;

INSERT INTO book_genres (book_id, genre_id)
SELECT b.book_id, g.genre_id
FROM books b JOIN genres g ON g.name='Fantasy'
WHERE b.title IN ('Harry Potter and the Chamber of Secrets');

INSERT INTO book_genres (book_id, genre_id)
SELECT b.book_id, g.genre_id
FROM books b JOIN genres g ON g.name='Classic'
WHERE b.title IN ('1984','Les Misérables','Pride and Prejudice');

INSERT INTO book_genres (book_id, genre_id)
SELECT b.book_id, g.genre_id
FROM books b JOIN genres g ON g.name='Science Fiction'
WHERE b.title IN ('1984');

INSERT INTO reviews (user_id, book_id, rating, title, body)
SELECT u.user_id, b.book_id, 5, 'Great!', 'Loved it.'
FROM users u, books b
WHERE u.username='user1' AND b.title='1984'
LIMIT 1;

INSERT INTO reviews (user_id, book_id, rating, title, body)
SELECT u.user_id, b.book_id, 4, 'Classic', 'A must-read.'
FROM users u, books b
WHERE u.username='user2' AND b.title='Les Misérables'
LIMIT 1;

INSERT INTO reviews (user_id, book_id, rating, title, body)
SELECT u.user_id, b.book_id, 5, 'Brilliant', 'Could not put it down.'
FROM users u, books b
WHERE u.username='user3' AND b.title='The Shining'
LIMIT 1;

