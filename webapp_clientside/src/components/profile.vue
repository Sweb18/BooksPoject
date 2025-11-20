<script>
import usersData from '../data/users.json';

export default {
  data() {
    return {
      logo: require('../assets/img/icons/logo.png'),
      shop: require('../assets/img/icons/store.png'),
      basket: require('../assets/img/icons/basket.png'),
      searchQuery: '',
      isLoginMode: true,
      users: this.loadUsers(),
      loginForm: {
        email: '',
        password: ''
      },
      registerForm: {
        username: '',
        email: '',
        password: '',
        confirmPassword: ''
      },
      errorMessage: '',
      successMessage: '',
      currentUser: null,
      isEditing: false,
      editForm: {
        username: '',
        email: '',
        firstName: '',
        lastName: '',
        phone: '',
        shippingAddress: {
          street: '',
          city: '',
          postalCode: '',
          country: ''
        },
        billingAddress: {
          street: '',
          city: '',
          postalCode: '',
          country: ''
        }
      },
      activeTab: 'account' // account, shipping, billing, orders
    }
  },
  computed: {
    nextUserId() {
      if (this.users.length === 0) return 1;
      return Math.max(...this.users.map(u => u.user_id)) + 1;
    },
    isLoggedIn() {
      return this.currentUser !== null;
    },
    isAdmin() {
      return this.currentUser && this.currentUser.role === 'ADMIN';
    }
  },
  mounted() {
    // Charger l'utilisateur connecté depuis localStorage
    const savedUser = localStorage.getItem('currentUser');
    if (savedUser) {
      this.currentUser = JSON.parse(savedUser);
      this.loadEditForm();
    }
  },
  methods: {
    loadUsers() {
      // Charger les utilisateurs depuis localStorage ou depuis le JSON
      const savedUsers = localStorage.getItem('users');
      if (savedUsers) {
        return JSON.parse(savedUsers);
      }
      // Enrichir les utilisateurs avec des données supplémentaires
      return usersData.map(user => ({
        ...user,
        firstName: user.firstName || '',
        lastName: user.lastName || '',
        phone: user.phone || '',
        shippingAddress: user.shippingAddress || {
          street: '',
          city: '',
          postalCode: '',
          country: ''
        },
        billingAddress: user.billingAddress || {
          street: '',
          city: '',
          postalCode: '',
          country: ''
        },
        joinDate: user.joinDate || new Date().toISOString(),
        orders: user.orders || []
      }));
    },
    saveUsers() {
      localStorage.setItem('users', JSON.stringify(this.users));
    },
    toggleMode() {
      this.isLoginMode = !this.isLoginMode;
      this.errorMessage = '';
      this.successMessage = '';
      this.resetForms();
    },
    resetForms() {
      this.loginForm = {
        email: '',
        password: ''
      };
      this.registerForm = {
        username: '',
        email: '',
        password: '',
        confirmPassword: ''
      };
    },
    handleLogin() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.loginForm.email || !this.loginForm.password) {
        this.errorMessage = 'Please fill in all fields';
        return;
      }

      const user = this.users.find(u => u.email === this.loginForm.email);

      if (!user) {
        this.errorMessage = 'User not found';
        return;
      }

      // Pour la démo, on accepte n'importe quel mot de passe
      // Dans un vrai système, il faudrait vérifier le hash
      this.currentUser = user;
      localStorage.setItem('currentUser', JSON.stringify(user));
      this.successMessage = `Welcome back, ${user.username}!`;
      this.loadEditForm();
      setTimeout(() => {
        this.successMessage = '';
      }, 2000);
    },
    handleRegister() {
      this.errorMessage = '';
      this.successMessage = '';

      // Validation
      if (!this.registerForm.username || !this.registerForm.email ||
          !this.registerForm.password || !this.registerForm.confirmPassword) {
        this.errorMessage = 'Please fill in all fields';
        return;
      }

      if (this.registerForm.password !== this.registerForm.confirmPassword) {
        this.errorMessage = 'Passwords do not match';
        return;
      }

      if (this.registerForm.password.length < 6) {
        this.errorMessage = 'Password must be at least 6 characters';
        return;
      }

      // Vérifier si l'email existe déjà
      if (this.users.find(u => u.email === this.registerForm.email)) {
        this.errorMessage = 'Email already exists';
        return;
      }

      // Vérifier si le username existe déjà
      if (this.users.find(u => u.username === this.registerForm.username)) {
        this.errorMessage = 'Username already exists';
        return;
      }

      // Créer le nouvel utilisateur
      const newUser = {
        user_id: this.nextUserId,
        username: this.registerForm.username,
        email: this.registerForm.email,
        password_hash: `hash${this.nextUserId}`,
        role: 'USER',
        firstName: '',
        lastName: '',
        phone: '',
        shippingAddress: {
          street: '',
          city: '',
          postalCode: '',
          country: ''
        },
        billingAddress: {
          street: '',
          city: '',
          postalCode: '',
          country: ''
        },
        joinDate: new Date().toISOString(),
        orders: []
      };

      this.users.push(newUser);
      this.saveUsers();
      this.successMessage = `Account created successfully! User ID: ${newUser.user_id}`;

      console.log('New user created:', newUser);
      console.log('Updated users list:', this.users);

      setTimeout(() => {
        this.isLoginMode = true;
        this.resetForms();
        this.successMessage = 'You can now log in';
      }, 2000);
    },
    handleLogout() {
      this.currentUser = null;
      localStorage.removeItem('currentUser');
      this.isEditing = false;
      this.activeTab = 'account';
      this.successMessage = 'Logged out successfully';
      setTimeout(() => {
        this.successMessage = '';
      }, 2000);
    },
    loadEditForm() {
      if (this.currentUser) {
        this.editForm = {
          username: this.currentUser.username || '',
          email: this.currentUser.email || '',
          firstName: this.currentUser.firstName || '',
          lastName: this.currentUser.lastName || '',
          phone: this.currentUser.phone || '',
          shippingAddress: { ...this.currentUser.shippingAddress },
          billingAddress: { ...this.currentUser.billingAddress }
        };
      }
    },
    startEditing() {
      this.isEditing = true;
      this.loadEditForm();
    },
    cancelEditing() {
      this.isEditing = false;
      this.loadEditForm();
      this.errorMessage = '';
    },
    saveProfile() {
      this.errorMessage = '';
      this.successMessage = '';

      // Validation
      if (!this.editForm.email) {
        this.errorMessage = 'Email is required';
        return;
      }

      // Vérifier si l'email est déjà utilisé par un autre utilisateur
      const emailExists = this.users.find(u =>
        u.email === this.editForm.email && u.user_id !== this.currentUser.user_id
      );
      if (emailExists) {
        this.errorMessage = 'Email already used by another account';
        return;
      }

      // Mettre à jour l'utilisateur
      const userIndex = this.users.findIndex(u => u.user_id === this.currentUser.user_id);
      if (userIndex !== -1) {
        this.users[userIndex] = {
          ...this.users[userIndex],
          username: this.editForm.username,
          email: this.editForm.email,
          firstName: this.editForm.firstName,
          lastName: this.editForm.lastName,
          phone: this.editForm.phone,
          shippingAddress: { ...this.editForm.shippingAddress },
          billingAddress: { ...this.editForm.billingAddress }
        };

        this.currentUser = this.users[userIndex];
        this.saveUsers();
        localStorage.setItem('currentUser', JSON.stringify(this.currentUser));

        this.isEditing = false;
        this.successMessage = 'Profile updated successfully!';
        setTimeout(() => {
          this.successMessage = '';
        }, 3000);
      }
    },
    copyShippingToBilling() {
      this.editForm.billingAddress = { ...this.editForm.shippingAddress };
    }
  }
}
</script>

<template>
  <div class="profile-page">
    <header class="header">
      <div class="header-content">
        <img class="logo" :src="logo" alt="Library Logo" />
        <div class="search-bar">
          <input type="text" placeholder="Search for your product..." v-model="searchQuery" />
          <button class="search-button"><i class="fas fa-search"></i></button>
        </div>

        <div class="header-links">
          <div class="search-shop">
            <img class="shop-logo" :src="shop" alt="Shop Location" />
            <p>Shop near you !</p>
          </div>
          <div class="save">
            <img class="save-logo" src="../assets/img/icons/save.png" alt="Save for later" />
            <p>Save for later</p>
          </div>
          <div class="basket">
            <div class="basket-icon-wrapper">
              <img class="basket-logo" :src="basket" alt="Shopping Basket" />
            </div>
            <span class="basket-text">Basket</span>
          </div>
        </div>
      </div>
    </header>

    <nav class="nav">
      <router-link to="/" class="nav-link">Home</router-link>
      <router-link to="/new" class="nav-link">New Releases</router-link>
      <router-link to="/best-sellers" class="nav-link">Best Sellers</router-link>
      <div class="dropdown">
        <button class="nav-link">Categories <i class="fas fa-chevron-down"></i></button>
      </div>
      <router-link to="/contact" class="nav-link">Contact</router-link>
    </nav>

    <!-- LOGGED IN VIEW - Profile Management -->
    <div v-if="isLoggedIn">
      <section class="hero">
        <div class="hero-content">
          <h2>My Profile</h2>
          <p>Manage your account information and preferences</p>
        </div>
      </section>

      <section class="profile-section container">
        <div class="profile-header">
          <div class="profile-info">
            <div class="profile-avatar">
              <i class="fas fa-user-circle"></i>
            </div>
            <div class="profile-details">
              <h2>{{ currentUser.firstName && currentUser.lastName ?
                `${currentUser.firstName} ${currentUser.lastName}` : currentUser.username }}</h2>
              <p>{{ currentUser.email }}</p>
              <span class="user-badge">{{ currentUser.role }}</span>
              <p class="join-date">Member since {{ new Date(currentUser.joinDate).toLocaleDateString() }}</p>
            </div>
          </div>
          <div class="profile-actions">
            <router-link v-if="isAdmin" to="/admin" class="admin-button">
              <i class="fas fa-cog"></i> Admin Panel
            </router-link>
            <button @click="handleLogout" class="logout-button">
              <i class="fas fa-sign-out-alt"></i> Logout
            </button>
          </div>
        </div>

        <!-- Messages -->
        <div v-if="errorMessage" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <p>{{ errorMessage }}</p>
        </div>

        <div v-if="successMessage" class="success-message">
          <i class="fas fa-check-circle"></i>
          <p>{{ successMessage }}</p>
        </div>

        <div class="profile-content">
          <!-- Tabs Navigation -->
          <div class="profile-tabs">
            <button
              class="profile-tab"
              :class="{ active: activeTab === 'account' }"
              @click="activeTab = 'account'">
              <i class="fas fa-user"></i> Account Information
            </button>
            <button
              class="profile-tab"
              :class="{ active: activeTab === 'shipping' }"
              @click="activeTab = 'shipping'">
              <i class="fas fa-shipping-fast"></i> Shipping Address
            </button>
            <button
              class="profile-tab"
              :class="{ active: activeTab === 'billing' }"
              @click="activeTab = 'billing'">
              <i class="fas fa-credit-card"></i> Billing Address
            </button>
            <button
              class="profile-tab"
              :class="{ active: activeTab === 'orders' }"
              @click="activeTab = 'orders'">
              <i class="fas fa-box"></i> Order History
            </button>
          </div>

          <!-- Account Information Tab -->
          <div v-if="activeTab === 'account'" class="tab-content">
            <div class="tab-header">
              <h3>Account Information</h3>
              <button v-if="!isEditing" @click="startEditing" class="edit-button">
                <i class="fas fa-edit"></i> Edit
              </button>
            </div>

            <div v-if="!isEditing" class="info-display">
              <div class="info-row">
                <div class="info-item">
                  <label>Username</label>
                  <p>{{ currentUser.username }}</p>
                </div>
                <div class="info-item">
                  <label>Email</label>
                  <p>{{ currentUser.email }}</p>
                </div>
              </div>
              <div class="info-row">
                <div class="info-item">
                  <label>First Name</label>
                  <p>{{ currentUser.firstName || 'Not provided' }}</p>
                </div>
                <div class="info-item">
                  <label>Last Name</label>
                  <p>{{ currentUser.lastName || 'Not provided' }}</p>
                </div>
              </div>
              <div class="info-row">
                <div class="info-item">
                  <label>Phone</label>
                  <p>{{ currentUser.phone || 'Not provided' }}</p>
                </div>
                <div class="info-item">
                  <label>User ID</label>
                  <p>#{{ currentUser.user_id }}</p>
                </div>
              </div>
            </div>

            <form v-else @submit.prevent="saveProfile" class="edit-form">
              <div class="form-row">
                <div class="form-group">
                  <label>Username</label>
                  <input type="text" v-model="editForm.username" required />
                </div>
                <div class="form-group">
                  <label>Email</label>
                  <input type="email" v-model="editForm.email" required />
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>First Name</label>
                  <input type="text" v-model="editForm.firstName" />
                </div>
                <div class="form-group">
                  <label>Last Name</label>
                  <input type="text" v-model="editForm.lastName" />
                </div>
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>Phone</label>
                  <input type="tel" v-model="editForm.phone" placeholder="+33 1 23 45 67 89" />
                </div>
              </div>
              <div class="form-actions">
                <button type="submit" class="save-button">
                  <i class="fas fa-save"></i> Save Changes
                </button>
                <button type="button" @click="cancelEditing" class="cancel-button">
                  <i class="fas fa-times"></i> Cancel
                </button>
              </div>
            </form>
          </div>

          <!-- Shipping Address Tab -->
          <div v-if="activeTab === 'shipping'" class="tab-content">
            <div class="tab-header">
              <h3>Shipping Address</h3>
              <button v-if="!isEditing" @click="startEditing" class="edit-button">
                <i class="fas fa-edit"></i> Edit
              </button>
            </div>

            <div v-if="!isEditing" class="info-display">
              <div class="address-card">
                <i class="fas fa-map-marker-alt"></i>
                <div v-if="currentUser.shippingAddress.street">
                  <p>{{ currentUser.shippingAddress.street }}</p>
                  <p>{{ currentUser.shippingAddress.postalCode }} {{ currentUser.shippingAddress.city }}</p>
                  <p>{{ currentUser.shippingAddress.country }}</p>
                </div>
                <p v-else class="no-data">No shipping address provided</p>
              </div>
            </div>

            <form v-else @submit.prevent="saveProfile" class="edit-form">
              <div class="form-group">
                <label>Street Address</label>
                <input type="text" v-model="editForm.shippingAddress.street" placeholder="123 Main Street" />
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>City</label>
                  <input type="text" v-model="editForm.shippingAddress.city" placeholder="Paris" />
                </div>
                <div class="form-group">
                  <label>Postal Code</label>
                  <input type="text" v-model="editForm.shippingAddress.postalCode" placeholder="75001" />
                </div>
              </div>
              <div class="form-group">
                <label>Country</label>
                <input type="text" v-model="editForm.shippingAddress.country" placeholder="France" />
              </div>
              <div class="form-actions">
                <button type="submit" class="save-button">
                  <i class="fas fa-save"></i> Save Changes
                </button>
                <button type="button" @click="cancelEditing" class="cancel-button">
                  <i class="fas fa-times"></i> Cancel
                </button>
              </div>
            </form>
          </div>

          <!-- Billing Address Tab -->
          <div v-if="activeTab === 'billing'" class="tab-content">
            <div class="tab-header">
              <h3>Billing Address</h3>
              <button v-if="!isEditing" @click="startEditing" class="edit-button">
                <i class="fas fa-edit"></i> Edit
              </button>
            </div>

            <div v-if="!isEditing" class="info-display">
              <div class="address-card">
                <i class="fas fa-credit-card"></i>
                <div v-if="currentUser.billingAddress.street">
                  <p>{{ currentUser.billingAddress.street }}</p>
                  <p>{{ currentUser.billingAddress.postalCode }} {{ currentUser.billingAddress.city }}</p>
                  <p>{{ currentUser.billingAddress.country }}</p>
                </div>
                <p v-else class="no-data">No billing address provided</p>
              </div>
            </div>

            <form v-else @submit.prevent="saveProfile" class="edit-form">
              <button type="button" @click="copyShippingToBilling" class="copy-button">
                <i class="fas fa-copy"></i> Copy from Shipping Address
              </button>
              <div class="form-group">
                <label>Street Address</label>
                <input type="text" v-model="editForm.billingAddress.street" placeholder="123 Main Street" />
              </div>
              <div class="form-row">
                <div class="form-group">
                  <label>City</label>
                  <input type="text" v-model="editForm.billingAddress.city" placeholder="Paris" />
                </div>
                <div class="form-group">
                  <label>Postal Code</label>
                  <input type="text" v-model="editForm.billingAddress.postalCode" placeholder="75001" />
                </div>
              </div>
              <div class="form-group">
                <label>Country</label>
                <input type="text" v-model="editForm.billingAddress.country" placeholder="France" />
              </div>
              <div class="form-actions">
                <button type="submit" class="save-button">
                  <i class="fas fa-save"></i> Save Changes
                </button>
                <button type="button" @click="cancelEditing" class="cancel-button">
                  <i class="fas fa-times"></i> Cancel
                </button>
              </div>
            </form>
          </div>

          <!-- Order History Tab -->
          <div v-if="activeTab === 'orders'" class="tab-content">
            <div class="tab-header">
              <h3>Order History</h3>
            </div>

            <div v-if="currentUser.orders && currentUser.orders.length > 0" class="orders-list">
              <div v-for="order in currentUser.orders" :key="order.id" class="order-card">
                <div class="order-header">
                  <span class="order-number">Order #{{ order.id }}</span>
                  <span class="order-date">{{ new Date(order.date).toLocaleDateString() }}</span>
                </div>
                <div class="order-total">Total: {{ order.total }}</div>
                <div class="order-status">Status: {{ order.status }}</div>
              </div>
            </div>
            <div v-else class="empty-state">
              <i class="fas fa-box-open"></i>
              <p>No orders yet</p>
              <router-link to="/" class="start-shopping-button">Start Shopping</router-link>
            </div>
          </div>
        </div>
      </section>
    </div>

    <!-- NOT LOGGED IN VIEW - Login/Register -->
    <div v-else>
      <section class="hero">
        <div class="hero-content">
          <h2>{{ isLoginMode ? 'Welcome Back' : 'Join Us' }}</h2>
          <p>{{ isLoginMode ? 'Sign in to your account' : 'Create your account to start your reading journey' }}</p>
        </div>
      </section>

      <section class="auth-section container">
        <div class="auth-wrapper">
          <div class="auth-tabs">
            <button
              class="auth-tab"
              :class="{ active: isLoginMode }"
              @click="isLoginMode = true; errorMessage = ''; successMessage = ''">
              <i class="fas fa-sign-in-alt"></i> Login
            </button>
            <button
              class="auth-tab"
              :class="{ active: !isLoginMode }"
              @click="isLoginMode = false; errorMessage = ''; successMessage = ''">
              <i class="fas fa-user-plus"></i> Register
            </button>
          </div>

          <!-- Messages -->
          <div v-if="errorMessage" class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <p>{{ errorMessage }}</p>
          </div>

          <div v-if="successMessage" class="success-message">
            <i class="fas fa-check-circle"></i>
            <p>{{ successMessage }}</p>
          </div>

          <!-- Login Form -->
          <form v-if="isLoginMode" @submit.prevent="handleLogin" class="auth-form">
            <div class="form-header">
              <h2>Sign In</h2>
              <p>Enter your credentials to access your account</p>
            </div>

            <div class="form-group">
              <label for="login-email">
                <i class="fas fa-envelope"></i> Email
              </label>
              <input
                type="email"
                id="login-email"
                v-model="loginForm.email"
                required
                placeholder="your.email@example.com"
              />
            </div>

            <div class="form-group">
              <label for="login-password">
                <i class="fas fa-lock"></i> Password
              </label>
              <input
                type="password"
                id="login-password"
                v-model="loginForm.password"
                required
                placeholder="Enter your password"
              />
            </div>

            <div class="form-footer">
              <label class="checkbox-label">
                <input type="checkbox" />
                <span>Remember me</span>
              </label>
              <a href="#" class="forgot-password">Forgot password?</a>
            </div>

            <button type="submit" class="submit-button">
              <i class="fas fa-sign-in-alt"></i> Sign In
            </button>

            <p class="switch-mode">
              Don't have an account?
              <a @click.prevent="toggleMode" href="#">Create one</a>
            </p>
          </form>

          <!-- Register Form -->
          <form v-else @submit.prevent="handleRegister" class="auth-form">
            <div class="form-header">
              <h2>Create Account</h2>
              <p>Fill in the information below to create your account</p>
            </div>

            <div class="form-group">
              <label for="register-username">
                <i class="fas fa-user"></i> Username
              </label>
              <input
                type="text"
                id="register-username"
                v-model="registerForm.username"
                required
                placeholder="Choose a username"
              />
            </div>

            <div class="form-group">
              <label for="register-email">
                <i class="fas fa-envelope"></i> Email
              </label>
              <input
                type="email"
                id="register-email"
                v-model="registerForm.email"
                required
                placeholder="your.email@example.com"
              />
            </div>

            <div class="form-group">
              <label for="register-password">
                <i class="fas fa-lock"></i> Password
              </label>
              <input
                type="password"
                id="register-password"
                v-model="registerForm.password"
                required
                placeholder="Choose a strong password"
              />
            </div>

            <div class="form-group">
              <label for="register-confirm-password">
                <i class="fas fa-lock"></i> Confirm Password
              </label>
              <input
                type="password"
                id="register-confirm-password"
                v-model="registerForm.confirmPassword"
                required
                placeholder="Confirm your password"
              />
            </div>

            <div class="form-footer">
              <label class="checkbox-label">
                <input type="checkbox" required />
                <span>I agree to the Terms and Conditions</span>
              </label>
            </div>

            <button type="submit" class="submit-button">
              <i class="fas fa-user-plus"></i> Create Account
            </button>

            <p class="switch-mode">
              Already have an account?
              <a @click.prevent="toggleMode" href="#">Sign in</a>
            </p>
          </form>
        </div>
      </section>

      <section class="benefits container">
        <h2 class="section-title">Why Create an Account?</h2>
        <div class="benefits-grid">
          <div class="benefit-card">
            <i class="fas fa-bookmark"></i>
            <h3>Save Favorites</h3>
            <p>Keep track of books you want to read</p>
          </div>
          <div class="benefit-card">
            <i class="fas fa-shopping-cart"></i>
            <h3>Quick Checkout</h3>
            <p>Faster purchasing with saved information</p>
          </div>
          <div class="benefit-card">
            <i class="fas fa-history"></i>
            <h3>Order History</h3>
            <p>View all your past orders and reviews</p>
          </div>
          <div class="benefit-card">
            <i class="fas fa-bell"></i>
            <h3>Notifications</h3>
            <p>Get alerts for new releases and deals</p>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
@font-face {
  font-family: 'Tan Mon Cheri';
  src: url('../assets/font/tan-mon-cheri.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}

.profile-page {
  min-height: 100vh;
  background-color: #f8f9fa;
  margin: 0;
  padding: 0;
  overflow-x: hidden;
  width: 100%;
}

.header {
  background: #016B61;
  padding: 0.5rem 5rem;
  color: white;
  font-family: 'Tan Mon Cheri', sans-serif;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  position: relative;
  z-index: 100;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  padding: 1rem;
}

.logo {
  width: 128px;
  height: 128px;
}

.search-bar {
  display: flex;
  width: 500px;
  min-width: 300px;
  max-width: 600px;
}

.search-bar input {
  flex: 1;
  padding: 0.8rem;
  border: none;
  border-radius: 4px 0 0 4px;
  font-size: 1rem;
}

.search-button {
  padding: 0 1.5rem;
  background: #e74c3c;
  border: none;
  border-radius: 0 4px 4px 0;
  color: white;
  cursor: pointer;
  transition: background 0.3s ease;
}

.search-button:hover {
  background: #c0392b;
}

.header-links {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.search-shop, .save, .basket {
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.search-shop:hover, .save:hover, .basket:hover {
  transform: translateY(-2px);
}

.shop-logo, .save-logo, .basket-logo {
  width: 32px;
  height: 32px;
}

.search-shop p, .save p, .basket-text {
  font-size: 10px;
  margin: 0;
  margin-top: 4px;
}

.nav {
  background: white;
  padding: 1rem 5rem;
  display: flex;
  justify-content: center;
  gap: 3rem;
  border-bottom: 1px solid rgba(0,0,0,0.1);
}

.nav-link {
  color: #2c3e50;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 0;
  position: relative;
  transition: color 0.3s ease;
  border: none;
  background: none;
  cursor: pointer;
}

.nav-link:after {
  content: '';
  position: absolute;
  width: 100%;
  transform: scaleX(0);
  height: 2px;
  bottom: 0;
  left: 0;
  background-color: #016B61;
  transform-origin: bottom right;
  transition: transform 0.3s ease-out;
}

.nav-link:hover {
  color: #016B61;
}

.nav-link:hover:after {
  transform: scaleX(1);
  transform-origin: bottom left;
}

.dropdown {
  position: relative;
  display: inline-block;
}

.hero {
  background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)),
    url('../assets/img/icons/library_home.jpeg') center/cover;
  color: white;
  padding: 6rem 2rem;
  text-align: center;
  margin-bottom: 4rem;
}

.hero-content h2 {
  font-size: 3.5rem;
  margin-bottom: 1.5rem;
  font-weight: 300;
  letter-spacing: 1px;
}

.hero-content p {
  font-size: 1.2rem;
  opacity: 0.9;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.auth-section {
  margin-bottom: 4rem;
}

.auth-wrapper {
  max-width: 500px;
  margin: 0 auto;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  overflow: hidden;
}

.auth-tabs {
  display: flex;
  background: #f8f9fa;
}

.auth-tab {
  flex: 1;
  padding: 1.2rem;
  border: none;
  background: transparent;
  color: #666;
  font-size: 1.1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  border-bottom: 3px solid transparent;
}

.auth-tab:hover {
  background: rgba(1, 107, 97, 0.05);
}

.auth-tab.active {
  background: white;
  color: #016B61;
  border-bottom-color: #016B61;
}

.auth-tab i {
  margin-right: 0.5rem;
}

.error-message,
.success-message {
  margin: 1.5rem;
  padding: 1rem;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 0.8rem;
}

.error-message {
  background: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.success-message {
  background: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.error-message i,
.success-message i {
  font-size: 1.3rem;
}

.error-message p,
.success-message p {
  margin: 0;
}

.auth-form {
  padding: 2rem;
}

.form-header {
  text-align: center;
  margin-bottom: 2rem;
}

.form-header h2 {
  font-size: 1.8rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.form-header p {
  color: #666;
  font-size: 0.95rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-weight: 500;
  font-size: 0.95rem;
}

.form-group label i {
  margin-right: 0.5rem;
  color: #016B61;
}

.form-group input {
  width: 100%;
  padding: 0.9rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.form-group input:focus {
  outline: none;
  border-color: #016B61;
  box-shadow: 0 0 0 3px rgba(1, 107, 97, 0.1);
}

.form-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
  color: #666;
}

.checkbox-label input {
  cursor: pointer;
}

.forgot-password {
  color: #016B61;
  text-decoration: none;
  font-size: 0.9rem;
  transition: color 0.3s ease;
}

.forgot-password:hover {
  color: #015550;
  text-decoration: underline;
}

.submit-button {
  width: 100%;
  padding: 1rem 2rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.submit-button:hover {
  background: #015550;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(1, 107, 97, 0.3);
}

.submit-button i {
  font-size: 1.2rem;
}

.switch-mode {
  text-align: center;
  margin-top: 1.5rem;
  color: #666;
  font-size: 0.95rem;
}

.switch-mode a {
  color: #016B61;
  text-decoration: none;
  font-weight: 500;
  cursor: pointer;
  transition: color 0.3s ease;
}

.switch-mode a:hover {
  color: #015550;
  text-decoration: underline;
}

.benefits {
  margin-bottom: 4rem;
}

.section-title {
  text-align: center;
  font-size: 2rem;
  color: #2c3e50;
  margin-bottom: 3rem;
}

.benefits-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.benefit-card {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
}

.benefit-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.12);
}

.benefit-card i {
  font-size: 2.5rem;
  color: #016B61;
  margin-bottom: 1rem;
}

.benefit-card h3 {
  font-size: 1.3rem;
  margin-bottom: 0.8rem;
  color: #2c3e50;
}

.benefit-card p {
  color: #666;
  font-size: 0.95rem;
  margin: 0;
}

/* Profile Section Styles */
.profile-section {
  margin-bottom: 4rem;
}

.profile-header {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  margin-bottom: 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1.5rem;
}

.profile-info {
  display: flex;
  align-items: center;
  gap: 2rem;
}

.profile-avatar {
  font-size: 5rem;
  color: #016B61;
}

.profile-details h2 {
  margin: 0 0 0.5rem 0;
  color: #2c3e50;
  font-size: 1.8rem;
}

.profile-details p {
  margin: 0.3rem 0;
  color: #666;
}

.user-badge {
  display: inline-block;
  background: #016B61;
  color: white;
  padding: 0.3rem 0.8rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
  margin-top: 0.5rem;
}

.join-date {
  font-size: 0.85rem !important;
  color: #999 !important;
  margin-top: 0.5rem !important;
}

.profile-actions {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.admin-button {
  padding: 0.8rem 1.5rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
}

.admin-button:hover {
  background: #015550;
  transform: translateY(-2px);
}

.logout-button {
  padding: 0.8rem 1.5rem;
  background: #e74c3c;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.logout-button:hover {
  background: #c0392b;
  transform: translateY(-2px);
}

.profile-content {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  overflow: hidden;
}

.profile-tabs {
  display: flex;
  background: #f8f9fa;
  border-bottom: 2px solid #e0e0e0;
  overflow-x: auto;
}

.profile-tab {
  flex: 1;
  min-width: 150px;
  padding: 1.2rem 1rem;
  border: none;
  background: transparent;
  color: #666;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  border-bottom: 3px solid transparent;
  white-space: nowrap;
}

.profile-tab:hover {
  background: rgba(1, 107, 97, 0.05);
}

.profile-tab.active {
  background: white;
  color: #016B61;
  border-bottom-color: #016B61;
}

.profile-tab i {
  margin-right: 0.5rem;
}

.tab-content {
  padding: 2rem;
}

.tab-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid #f0f0f0;
}

.tab-header h3 {
  margin: 0;
  color: #2c3e50;
  font-size: 1.5rem;
}

.edit-button {
  padding: 0.6rem 1.2rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 0.95rem;
}

.edit-button:hover {
  background: #015550;
  transform: translateY(-2px);
}

.info-display {
  max-width: 800px;
}

.info-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin-bottom: 1.5rem;
}

.info-item label {
  display: block;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
}

.info-item p {
  color: #666;
  font-size: 1rem;
  margin: 0;
}

.address-card {
  background: #f8f9fa;
  padding: 2rem;
  border-radius: 8px;
  display: flex;
  gap: 1.5rem;
  max-width: 600px;
}

.address-card i {
  font-size: 2rem;
  color: #016B61;
}

.address-card p {
  margin: 0.3rem 0;
  color: #666;
}

.no-data {
  color: #999 !important;
  font-style: italic;
}

.edit-form {
  max-width: 800px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-weight: 500;
  font-size: 0.95rem;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 0.9rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.3s ease;
  box-sizing: border-box;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #016B61;
  box-shadow: 0 0 0 3px rgba(1, 107, 97, 0.1);
}

.form-actions {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
}

.save-button {
  padding: 0.9rem 2rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.save-button:hover {
  background: #015550;
  transform: translateY(-2px);
}

.cancel-button {
  padding: 0.9rem 2rem;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.cancel-button:hover {
  background: #5a6268;
  transform: translateY(-2px);
}

.copy-button {
  width: 100%;
  padding: 0.8rem;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  margin-bottom: 1.5rem;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.copy-button:hover {
  background: #5a6268;
}

.orders-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.order-card {
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 8px;
  border-left: 4px solid #016B61;
}

.order-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1rem;
  font-weight: 600;
}

.order-number {
  color: #2c3e50;
}

.order-date {
  color: #666;
  font-size: 0.9rem;
}

.order-total,
.order-status {
  margin: 0.5rem 0;
  color: #666;
}

.empty-state {
  text-align: center;
  padding: 4rem 2rem;
}

.empty-state i {
  font-size: 4rem;
  color: #ccc;
  margin-bottom: 1rem;
}

.empty-state p {
  color: #999;
  font-size: 1.2rem;
  margin-bottom: 2rem;
}

.start-shopping-button {
  display: inline-block;
  padding: 1rem 2rem;
  background: #016B61;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.start-shopping-button:hover {
  background: #015550;
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .header {
    padding: 0.5rem 1rem;
  }

  .header-content {
    flex-direction: column;
    gap: 1rem;
  }

  .nav {
    padding: 1rem;
    gap: 1rem;
    flex-wrap: wrap;
  }

  .hero-content h2 {
    font-size: 2rem;
  }

  .auth-wrapper {
    margin: 0 1rem;
  }

  .benefits-grid {
    grid-template-columns: 1fr;
  }

  .profile-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .profile-info {
    flex-direction: column;
    align-items: flex-start;
  }

  .info-row {
    grid-template-columns: 1fr;
  }

  .form-row {
    grid-template-columns: 1fr;
  }

  .profile-tabs {
    flex-wrap: wrap;
  }

  .profile-tab {
    min-width: 120px;
    font-size: 0.9rem;
    padding: 1rem 0.5rem;
  }

  .tab-content {
    padding: 1rem;
  }

  .form-actions {
    flex-direction: column;
  }

  .save-button,
  .cancel-button {
    width: 100%;
  }
}
</style>