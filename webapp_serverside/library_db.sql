-- Drop existing tables if they exist
-- Créer et sélectionner la base de données

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS book_genres;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS users;



-- ==============================================
-- Create Tables
-- ==============================================


-- Authors Table
CREATE TABLE authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    bio TEXT,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(100),
    website VARCHAR(255),
    portrait_url VARCHAR(255)
);

-- Publishers Table
CREATE TABLE publishers (
    publisher_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    country VARCHAR(100),
    founded_year INT,
    headquarters_city VARCHAR(100),
    website VARCHAR(255),
    contact_email VARCHAR(255),
    phone VARCHAR(50)
);

-- Genres Table
CREATE TABLE genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

-- Books Table
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(200),
    subtitle VARCHAR(255),
    isbn13 VARCHAR(13) UNIQUE,
    author_id INT,
    publisher_id INT,
    publication_date DATE,
    language VARCHAR(10),
    page_count INT,
    description TEXT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id)
);

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(50),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Book_Genres Table (Many-to-Many relationship)
CREATE TABLE book_genres (
    book_id INT,
    genre_id INT,
    PRIMARY KEY (book_id, genre_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE
);

-- Reviews Table
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    book_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(200),
    body TEXT,
    created_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- ==============================================
-- Insert Data
-- ==============================================

-- Insert Authors
INSERT INTO authors (author_id, first_name, last_name, bio, birth_date, death_date, nationality, website, portrait_url) VALUES
(1, 'J.K.', 'Rowling', 'British author of the Harry Potter series.', '1965-07-31', NULL, 'British', 'https://www.jkrowling.com', 'https://example.com/portraits/rowling.jpg'),
(2, 'George', 'Orwell', 'English novelist, essayist, journalist and critic.', '1903-06-25', '1950-01-21', 'British', NULL, NULL),
(3, 'Victor', 'Hugo', 'French poet, novelist, and dramatist of the Romantic movement.', '1802-02-26', '1885-05-22', 'French', NULL, NULL),
(4, 'Jane', 'Austen', 'English novelist known primarily for her six major novels.', '1775-12-16', '1817-07-18', 'British', NULL, NULL),
(5, 'Mark', 'Twain', 'American writer, humorist, entrepreneur, publisher, and lecturer.', '1835-11-30', '1910-04-21', 'American', NULL, NULL),
(6, 'Agatha', 'Christie', 'English writer known for her sixty-six detective novels.', '1890-09-15', '1976-01-12', 'British', NULL, NULL),
(7, 'Ernest', 'Hemingway', 'American novelist, short-story writer, and journalist.', '1899-07-21', '1961-07-02', 'American', NULL, NULL),
(8, 'Gabriel García', 'Márquez', 'Colombian novelist, short-story writer, and journalist.', '1927-03-06', '2014-04-17', 'Colombian', NULL, NULL),
(9, 'Haruki', 'Murakami', 'Japanese writer known for his surrealistic fiction.', '1949-01-12', NULL, 'Japanese', NULL, NULL),
(10, 'Stephen', 'King', 'American author of horror, supernatural fiction, suspense, crime, and fantasy novels.', '1947-09-21', NULL, 'American', NULL, NULL);

-- Insert Publishers
INSERT INTO publishers (publisher_id, name, country, founded_year, headquarters_city, website, contact_email, phone) VALUES
(1, 'Bloomsbury', 'United Kingdom', 1986, 'London', 'https://www.bloomsbury.com', 'info@bloomsbury.com', '+44 20 7000 0000'),
(2, 'Secker & Warburg', 'United Kingdom', 1935, 'London', NULL, NULL, NULL),
(3, 'Gallimard', 'France', 1911, 'Paris', 'https://www.gallimard.fr', 'contact@gallimard.fr', '+33 1 0000 0000'),
(4, 'Penguin Books', 'United Kingdom', 1935, 'London', 'https://www.penguin.co.uk', 'hello@penguin.co.uk', '+44 20 0000 0000'),
(5, 'HarperCollins', 'United States', 1989, 'New York', 'https://www.harpercollins.com', 'info@harpercollins.com', '+1 212 000 0000'),
(6, 'Random House', 'United States', 1927, 'New York', 'https://www.randomhousebooks.com', NULL, NULL),
(7, 'Hachette', 'France', 1826, 'Paris', 'https://www.hachette.com', NULL, NULL),
(8, 'Simon & Schuster', 'United States', 1924, 'New York', 'https://www.simonandschuster.com', NULL, NULL),
(9, 'Macmillan', 'United Kingdom', 1843, 'London', 'https://www.macmillan.com', NULL, NULL),
(10, 'Faber & Faber', 'United Kingdom', 1929, 'London', 'https://www.faber.co.uk', NULL, NULL);

-- Insert Genres
INSERT INTO genres (genre_id, name) VALUES
(1, 'Fantasy'),
(2, 'Science Fiction'),
(3, 'Classic'),
(4, 'Mystery'),
(5, 'Horror'),
(6, 'Fiction');

-- Insert Books
INSERT INTO books (book_id, title, author, subtitle, isbn13, author_id, publisher_id, publication_date, language, page_count, description) VALUES
(1, 'Harry Potter and the Chamber of Secrets', 'J.K. Rowling', NULL, '9780439064873', 1, 1, '1998-07-02', 'en', 341, 'Second book in the Harry Potter series.'),
(2, '1984', 'George Orwell', NULL, '9780451524935', 2, 2, '1949-06-08', 'en', 328, 'Dystopian social science fiction novel.'),
(3, 'Les Misérables', 'Victor Hugo', NULL, '9782070409189', 3, 3, '1862-01-01', 'fr', 1463, 'Classic French novel by Victor Hugo.'),
(4, 'Pride and Prejudice', 'Jane Austen', NULL, '9780141439518', 4, 4, '1813-01-28', 'en', 432, 'A romantic novel by Jane Austen.'),
(5, 'Adventures of Huckleberry Finn', 'Mark Twain', NULL, '9780486280615', 5, 5, '1884-12-10', 'en', 366, 'A classic novel by Mark Twain.'),
(6, 'Murder on the Orient Express', 'Agatha Christie', NULL, '9780062693662', 6, 5, '1934-01-01', 'en', 288, 'Detective novel by Agatha Christie.'),
(7, 'The Old Man and the Sea', 'Ernest Hemingway', NULL, '9780684801223', 7, 8, '1952-09-01', 'en', 127, 'Short novel by Ernest Hemingway.'),
(8, 'One Hundred Years of Solitude', 'Garcia Marquez', NULL, '9780060883287', 8, 5, '1967-05-30', 'es', 417, 'Novel by Gabriel García Márquez.'),
(9, 'Kafka on the Shore', 'Haruki Murakami', NULL, '9781400079278', 9, 6, '2002-09-12', 'jp', 505, 'Novel by Haruki Murakami.'),
(10, 'The Shining', 'Stephen King', NULL, '9780307743657', 10, 6, '1977-01-28', 'en', 447, 'Horror novel by Stephen King.');

-- Insert Users
-- password for admin: admin123
-- password for  user2: password123
-- password for  user3: password123
INSERT INTO users (user_id, username, email, password_hash, role) VALUES
(1, 'admin', 'admin@gmail.com', '$2b$10$nMaF4tE3dAq1MhMg6zJGOeWFCSd3fVfgsdSED1Tp3MQG5pkO1eaMy', 'ADMIN'),
(2, 'user2', 'user2@example.com', '$2b$10$nMaF4tE3dAq1MhMg6zJGOeWFCSd3fVfgsdSED1Tp3MQG5pkO1eaMy', 'USER'),
(3, 'user3', 'user3@example.com', '$2b$10$nMaF4tE3dAq1MhMg6zJGOeWFCSd3fVfgsdSED1Tp3MQG5pkO1eaMy', 'USER');

-- Insert Book_Genres (Many-to-Many relationships)
INSERT INTO book_genres (book_id, genre_id) VALUES
(1, 1),  -- Harry Potter - Fantasy
(2, 2),  -- 1984 - Science Fiction
(2, 3),  -- 1984 - Classic
(3, 3),  -- Les Misérables - Classic
(3, 6),  -- Les Misérables - Fiction
(4, 3),  -- Pride and Prejudice - Classic
(4, 6),  -- Pride and Prejudice - Fiction
(5, 3),  -- Huckleberry Finn - Classic
(5, 6),  -- Huckleberry Finn - Fiction
(6, 4),  -- Murder on the Orient Express - Mystery
(6, 6),  -- Murder on the Orient Express - Fiction
(7, 3),  -- The Old Man and the Sea - Classic
(7, 6),  -- The Old Man and the Sea - Fiction
(8, 1),  -- One Hundred Years of Solitude - Fantasy
(8, 6),  -- One Hundred Years of Solitude - Fiction
(9, 1),  -- Kafka on the Shore - Fantasy
(9, 6),  -- Kafka on the Shore - Fiction
(10, 5), -- The Shining - Horror
(10, 6); -- The Shining - Fiction

-- Insert Reviews
INSERT INTO reviews (review_id, user_id, book_id, rating, title, body, created_at) VALUES
(1, 1, 2, 5, 'Great!', 'Loved it.', '2025-10-30 23:10:00'),
(2, 2, 3, 4, 'Classic', 'A must-read.', '2025-10-30 23:10:00'),
(3, 3, 10, 5, 'Brilliant', 'Could not put it down.', '2025-10-30 23:10:00');

-- ==============================================
-- Create Indexes for Performance
-- ==============================================

CREATE INDEX idx_books_author ON books(author_id);
CREATE INDEX idx_books_publisher ON books(publisher_id);
CREATE INDEX idx_books_isbn ON books(isbn13);
CREATE INDEX idx_reviews_book ON reviews(book_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_book_genres_book ON book_genres(book_id);
CREATE INDEX idx_book_genres_genre ON book_genres(genre_id);

-- ==============================================
-- Useful Views
-- ==============================================

-- View: Books with full author and publisher information
CREATE OR REPLACE VIEW v_books_full AS
SELECT
    b.book_id,
    b.title,
    b.subtitle,
    b.isbn13,
    b.publication_date,
    b.language,
    b.page_count,
    b.description,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    a.nationality AS author_nationality,
    p.name AS publisher_name,
    p.country AS publisher_country
FROM books b
LEFT JOIN authors a ON b.author_id = a.author_id
LEFT JOIN publishers p ON b.publisher_id = p.publisher_id;

-- View: Books with genres
CREATE OR REPLACE VIEW v_books_with_genres AS
SELECT
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    GROUP_CONCAT(g.name SEPARATOR ', ') AS genres
FROM books b
LEFT JOIN authors a ON b.author_id = a.author_id
LEFT JOIN book_genres bg ON b.book_id = bg.book_id
LEFT JOIN genres g ON bg.genre_id = g.genre_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name;

-- View: Books with average ratings
CREATE OR REPLACE VIEW v_books_with_ratings AS
SELECT
    b.book_id,
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) AS author_name,
    COUNT(r.review_id) AS review_count,
    COALESCE(ROUND(AVG(r.rating), 1), 0) AS average_rating
FROM books b
LEFT JOIN authors a ON b.author_id = a.author_id
LEFT JOIN reviews r ON b.book_id = r.book_id
GROUP BY b.book_id, b.title, a.first_name, a.last_name;

-- ==============================================
-- Useful Queries (Examples)
-- ==============================================

-- Get all books by genre
-- SELECT * FROM v_books_with_genres WHERE genres LIKE '%Fantasy%';

-- Get all books with their ratings
-- SELECT * FROM v_books_with_ratings ORDER BY average_rating DESC;

-- Get books by a specific author
-- SELECT b.* FROM books b
-- JOIN authors a ON b.author_id = a.author_id
-- WHERE CONCAT(a.first_name, ' ', a.last_name) = 'J.K. Rowling';

-- Get all reviews for a specific book
-- SELECT r.*, u.username, b.title
-- FROM reviews r
-- JOIN users u ON r.user_id = u.user_id
-- JOIN books b ON r.book_id = b.book_id
-- WHERE b.book_id = 2;

-- ==============================================
-- End of Script
-- ==============================================

