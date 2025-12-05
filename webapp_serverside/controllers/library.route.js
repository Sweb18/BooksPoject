const express = require('express');
const router = express.Router();
const db = require('../utils/db.include');
const { requireAuth, requireAdmin } = require('../routes/auth');

// ==================== BOOKS ROUTES ====================

// Get all books
router.get('/books', async (req, res) => {
    try {
        const [books] = await db.query(`
            SELECT b.*, 
                   CONCAT(a.first_name, ' ', a.last_name) as author_name,
                   p.name as publisher_name
            FROM books b
            LEFT JOIN authors a ON b.author_id = a.author_id
            LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
        `);
        res.json(books);
    } catch (error) {
        console.error('Error fetching books:', error);
        res.status(500).json({ error: 'Error fetching books' });
    }
});

// Get book by ID
router.get('/books/:id', async (req, res) => {
    try {
        const [books] = await db.query(`
            SELECT b.*, 
                   CONCAT(a.first_name, ' ', a.last_name) as author_name,
                   p.name as publisher_name
            FROM books b
            LEFT JOIN authors a ON b.author_id = a.author_id
            LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
            WHERE b.book_id = ?
        `, [req.params.id]);

        if (books.length === 0) {
            return res.status(404).json({ error: 'Book not found' });
        }

        const [genres] = await db.query(`
            SELECT g.* FROM genres g
            JOIN book_genres bg ON g.genre_id = bg.genre_id
            WHERE bg.book_id = ?
        `, [req.params.id]);

        const [reviews] = await db.query(`
            SELECT r.*, u.username 
            FROM reviews r
            LEFT JOIN users u ON r.user_id = u.user_id
            WHERE r.book_id = ?
        `, [req.params.id]);

        const book = {
            ...books[0],
            genres,
            reviews
        };

        res.json(book);
    } catch (error) {
        console.error('Error fetching book:', error);
        res.status(500).json({ error: 'Error fetching book' });
    }
});

// Add new book
router.post('/books', requireAdmin, async (req, res) => {
    try {
        const { title, subtitle, isbn13, author_id, publisher_id, publication_date, language, page_count, description } = req.body;

        const [result] = await db.query(`
            INSERT INTO books (title, subtitle, isbn13, author_id, publisher_id, publication_date, language, page_count, description)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [title, subtitle, isbn13, author_id, publisher_id, publication_date, language, page_count, description]);

        res.json({ message: 'Book added successfully', book_id: result.insertId });
    } catch (error) {
        console.error('Error adding book:', error);
        res.status(500).json({ error: 'Error adding book' });
    }
});

// Update book
router.put('/books/:id', requireAdmin, async (req, res) => {
    try {
        const { title, subtitle, isbn13, author_id, publisher_id, publication_date, language, page_count, description } = req.body;

        console.log('Updating book:', req.params.id);
        console.log('Data:', { title, subtitle, isbn13, author_id, publisher_id, publication_date, language, page_count, description });

        // Convertir les valeurs vides en NULL
        const authorIdValue = author_id === null || author_id === '' || author_id === 'null' ? null : parseInt(author_id);
        const publisherIdValue = publisher_id === null || publisher_id === '' || publisher_id === 'null' ? null : parseInt(publisher_id);
        const publicationDateValue = publication_date === null || publication_date === '' ? null : publication_date;
        const pageCountValue = page_count === null || page_count === '' ? 0 : parseInt(page_count);

        const [result] = await db.query(`
            UPDATE books 
            SET title=?, subtitle=?, isbn13=?, author_id=?, publisher_id=?, 
                publication_date=?, language=?, page_count=?, description=?
            WHERE book_id=?
        `, [title, subtitle || '', isbn13, authorIdValue, publisherIdValue, publicationDateValue, language || 'en', pageCountValue, description || '', req.params.id]);

        console.log('Update result:', result);

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Book not found' });
        }

        res.json({ message: 'Book updated successfully' });
    } catch (error) {
        console.error('Error updating book:', error);
        res.status(500).json({ error: 'Error updating book: ' + error.message });
    }
});

// Delete book
router.delete('/books/:id', requireAdmin, async (req, res) => {
    try {
        await db.query('DELETE FROM books WHERE book_id = ?', [req.params.id]);
        res.json({ message: 'Book deleted successfully' });
    } catch (error) {
        console.error('Error deleting book:', error);
        res.status(500).json({ error: 'Error deleting book' });
    }
});

// ==================== AUTHORS ROUTES ====================

// Get all authors
router.get('/authors', async (req, res) => {
    try {
        const [authors] = await db.query('SELECT * FROM authors ORDER BY last_name, first_name');
        res.json(authors);
    } catch (error) {
        console.error('Error fetching authors:', error);
        res.status(500).json({ error: 'Error fetching authors' });
    }
});

// Add new author
router.post('/authors', requireAdmin, async (req, res) => {
    try {
        const { first_name, last_name, bio, birth_date, death_date, nationality, website, portrait_url } = req.body;

        const [result] = await db.query(`
            INSERT INTO authors (first_name, last_name, bio, birth_date, death_date, nationality, website, portrait_url)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        `, [first_name, last_name, bio, birth_date || null, death_date || null, nationality, website, portrait_url]);

        res.json({ message: 'Author added successfully', author_id: result.insertId });
    } catch (error) {
        console.error('Error adding author:', error);
        res.status(500).json({ error: 'Error adding author' });
    }
});

// Update author
router.put('/authors/:id', requireAdmin, async (req, res) => {
    try {
        const { first_name, last_name, bio, birth_date, death_date, nationality, website, portrait_url } = req.body;

        await db.query(`
            UPDATE authors 
            SET first_name=?, last_name=?, bio=?, birth_date=?, death_date=?, nationality=?, website=?, portrait_url=?
            WHERE author_id=?
        `, [first_name, last_name, bio, birth_date || null, death_date || null, nationality, website, portrait_url, req.params.id]);

        res.json({ message: 'Author updated successfully' });
    } catch (error) {
        console.error('Error updating author:', error);
        res.status(500).json({ error: 'Error updating author' });
    }
});

// Delete author
router.delete('/authors/:id', requireAdmin, async (req, res) => {
    try {
        await db.query('DELETE FROM authors WHERE author_id = ?', [req.params.id]);
        res.json({ message: 'Author deleted successfully' });
    } catch (error) {
        console.error('Error deleting author:', error);
        res.status(500).json({ error: 'Error deleting author' });
    }
});

// ==================== PUBLISHERS ROUTES ====================

// Get all publishers
router.get('/publishers', async (req, res) => {
    try {
        const [publishers] = await db.query('SELECT * FROM publishers ORDER BY name');
        res.json(publishers);
    } catch (error) {
        console.error('Error fetching publishers:', error);
        res.status(500).json({ error: 'Error fetching publishers' });
    }
});

// Add new publisher
router.post('/publishers', requireAdmin, async (req, res) => {
    try {
        const { name, country, founded_year, headquarters_city, website, contact_email, phone } = req.body;

        const [result] = await db.query(`
            INSERT INTO publishers (name, country, founded_year, headquarters_city, website, contact_email, phone)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `, [name, country, founded_year, headquarters_city, website, contact_email, phone]);

        res.json({ message: 'Publisher added successfully', publisher_id: result.insertId });
    } catch (error) {
        console.error('Error adding publisher:', error);
        res.status(500).json({ error: 'Error adding publisher' });
    }
});

// Update publisher
router.put('/publishers/:id', requireAdmin, async (req, res) => {
    try {
        const { name, country, founded_year, headquarters_city, website, contact_email, phone } = req.body;

        await db.query(`
            UPDATE publishers 
            SET name=?, country=?, founded_year=?, headquarters_city=?, website=?, contact_email=?, phone=?
            WHERE publisher_id=?
        `, [name, country, founded_year, headquarters_city, website, contact_email, phone, req.params.id]);

        res.json({ message: 'Publisher updated successfully' });
    } catch (error) {
        console.error('Error updating publisher:', error);
        res.status(500).json({ error: 'Error updating publisher' });
    }
});

// Delete publisher
router.delete('/publishers/:id', requireAdmin, async (req, res) => {
    try {
        await db.query('DELETE FROM publishers WHERE publisher_id = ?', [req.params.id]);
        res.json({ message: 'Publisher deleted successfully' });
    } catch (error) {
        console.error('Error deleting publisher:', error);
        res.status(500).json({ error: 'Error deleting publisher' });
    }
});

// ==================== GENRES ROUTES ====================

// Get all genres
router.get('/genres', async (req, res) => {
    try {
        const [genres] = await db.query('SELECT * FROM genres ORDER BY name');
        res.json(genres);
    } catch (error) {
        console.error('Error fetching genres:', error);
        res.status(500).json({ error: 'Error fetching genres' });
    }
});

// ==================== REVIEWS ROUTES ====================

// Get all reviews
router.get('/reviews', async (req, res) => {
    try {
        const [reviews] = await db.query(`
            SELECT r.*, u.username, b.title as book_title
            FROM reviews r
            LEFT JOIN users u ON r.user_id = u.user_id
            LEFT JOIN books b ON r.book_id = b.book_id
        `);
        res.json(reviews);
    } catch (error) {
        console.error('Error fetching reviews:', error);
        res.status(500).json({ error: 'Error fetching reviews' });
    }
});

// ==================== BOOK-GENRES ROUTES ====================

// Get book genres
router.get('/book-genres', async (req, res) => {
    try {
        const [bookGenres] = await db.query('SELECT * FROM book_genres');
        res.json(bookGenres);
    } catch (error) {
        console.error('Error fetching book genres:', error);
        res.status(500).json({ error: 'Error fetching book genres' });
    }
});

// ==================== USER ROUTES ====================

// Get all users (pour l'admin) - protected route
router.get('/users', async (req, res) => {
    try {
        const [users] = await db.query('SELECT user_id, username, email, role, created_at FROM users');
        res.json(users);
    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Error fetching users' });
    }
});

// Note: Auth routes (login, register, logout) are now in /api/auth (routes/auth.js)
// This uses bcrypt for password hashing and proper session management

module.exports = router;

