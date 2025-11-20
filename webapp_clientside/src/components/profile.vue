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
      users: usersData,
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
      currentUser: null
    }
  },
  computed: {
    nextUserId() {
      if (this.users.length === 0) return 1;
      return Math.max(...this.users.map(u => u.user_id)) + 1;
    }
  },
  methods: {
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
      this.successMessage = `Welcome back, ${user.username}!`;
      setTimeout(() => {
        this.$router.push('/');
      }, 1500);
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
        password_hash: `hash${this.nextUserId}`, // Simulé
        role: 'USER'
      };

      this.users.push(newUser);
      this.successMessage = `Account created successfully! User ID: ${newUser.user_id}`;

      console.log('New user created:', newUser);
      console.log('Updated users list:', this.users);

      setTimeout(() => {
        this.isLoginMode = true;
        this.resetForms();
        this.successMessage = 'You can now log in';
      }, 2000);
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
}
</style>