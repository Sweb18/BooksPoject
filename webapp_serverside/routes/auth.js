const express = require('express');
const bcrypt = require('bcrypt');
const router = express.Router();

// Middleware pour vérifier si l'utilisateur est connecté
const requireAuth = (req, res, next) => {
  if (!req.session.userId) {
    return res.status(401).json({ error: 'Authentication required' });
  }
  next();
};

// Middleware pour vérifier si l'utilisateur est ADMIN
const requireAdmin = (req, res, next) => {
  if (!req.session.userId || req.session.userRole !== 'ADMIN') {
    return res.status(403).json({ error: 'Admin privileges required' });
  }
  next();
};

// POST /api/auth/register - Inscription
router.post('/register', async (req, res) => {
  const { username, email, password, firstName, lastName, phone, address } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ error: 'Username, email and password are required' });
  }

  try {
    const db = req.app.locals.db;

    // Vérifier si l'utilisateur existe déjà
    const [existing] = await db.execute(
      'SELECT user_id FROM users WHERE email = ? OR username = ?',
      [email, username]
    );

    if (existing.length > 0) {
      return res.status(409).json({ error: 'User already exists' });
    }

    // Hasher le mot de passe avec bcrypt
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insérer l'utilisateur
    const [result] = await db.execute(
      `INSERT INTO users (username, email, password_hash, first_name, last_name, phone, address, role, created_at) 
       VALUES (?, ?, ?, ?, ?, ?, ?, 'USER', NOW())`,
      [username, email, hashedPassword, firstName || null, lastName || null, phone || null, address || null]
    );

    res.status(201).json({
      message: 'User created successfully',
      userId: result.insertId
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Failed to create user' });
  }
});

// POST /api/auth/login - Connexion
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  try {
    const db = req.app.locals.db;

    // Récupérer l'utilisateur
    const [users] = await db.execute(
      'SELECT user_id, username, email, password_hash, role, first_name, last_name, phone, address FROM users WHERE email = ?',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = users[0];

    // Vérifier le mot de passe
    const validPassword = await bcrypt.compare(password, user.password_hash);

    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Mettre à jour last_login
    await db.execute('UPDATE users SET last_login = NOW() WHERE user_id = ?', [user.user_id]);

    // Créer la session
    req.session.userId = user.user_id;
    req.session.userRole = user.role;

    res.json({
      userId: user.user_id,
      username: user.username,
      email: user.email,
      role: user.role,
      firstName: user.first_name,
      lastName: user.last_name,
      phone: user.phone,
      address: user.address
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
});

// GET /api/auth/me - Obtenir l'utilisateur connecté
router.get('/me', requireAuth, async (req, res) => {
  try {
    const db = req.app.locals.db;
    const [users] = await db.execute(
      'SELECT user_id, username, email, role, first_name, last_name, phone, address FROM users WHERE user_id = ?',
      [req.session.userId]
    );

    if (users.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(users[0]);
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ error: 'Failed to get user' });
  }
});

// PUT /api/auth/profile - Mettre à jour le profil
router.put('/profile', requireAuth, async (req, res) => {
  const { username, email, firstName, lastName, phone, address } = req.body;

  try {
    const db = req.app.locals.db;

    // Vérifier si le nouveau email/username existe déjà (sauf pour l'utilisateur actuel)
    if (email || username) {
      const [existing] = await db.execute(
        'SELECT user_id FROM users WHERE (email = ? OR username = ?) AND user_id != ?',
        [email || '', username || '', req.session.userId]
      );

      if (existing.length > 0) {
        return res.status(409).json({ error: 'Email or username already taken' });
      }
    }

    // Construire la requête dynamiquement
    const updates = [];
    const values = [];

    if (username) { updates.push('username = ?'); values.push(username); }
    if (email) { updates.push('email = ?'); values.push(email); }
    if (firstName !== undefined) { updates.push('first_name = ?'); values.push(firstName); }
    if (lastName !== undefined) { updates.push('last_name = ?'); values.push(lastName); }
    if (phone !== undefined) { updates.push('phone = ?'); values.push(phone); }
    if (address !== undefined) { updates.push('address = ?'); values.push(address); }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    values.push(req.session.userId);

    await db.execute(
      `UPDATE users SET ${updates.join(', ')} WHERE user_id = ?`,
      values
    );

    // Récupérer l'utilisateur mis à jour
    const [users] = await db.execute(
      'SELECT user_id, username, email, role, first_name, last_name, phone, address FROM users WHERE user_id = ?',
      [req.session.userId]
    );

    res.json(users[0]);
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// POST /api/auth/logout - Déconnexion
router.post('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ error: 'Logout failed' });
    }
    res.json({ message: 'Logged out successfully' });
  });
});

module.exports = { router, requireAuth, requireAdmin };

