<template>
  <div class="login-page">
    <div class="login-container">
      <div class="login-card">
        <div class="login-header">
          <h2>{{ isLoginMode ? 'Login' : 'Sign Up' }}</h2>
        </div>

        <div v-if="errorMessage" class="error-message">
          {{ errorMessage }}
        </div>

        <div v-if="successMessage" class="success-message">
          {{ successMessage }}
        </div>

        <form @submit.prevent="handleSubmit">
          <div v-if="!isLoginMode" class="form-group">
            <label>Username</label>
            <input
              type="text"
              v-model="registerForm.username"
              required
              placeholder="Enter your username"
            />
          </div>

          <div class="form-group">
            <label>Email</label>
            <input
              v-if="isLoginMode"
              type="email"
              v-model="loginForm.email"
              required
              placeholder="Enter your email"
            />
            <input
              v-else
              type="email"
              v-model="registerForm.email"
              required
              placeholder="Enter your email"
            />
          </div>

          <div class="form-group">
            <label>Password</label>
            <input
              v-if="isLoginMode"
              type="password"
              v-model="loginForm.password"
              required
              placeholder="Enter your password"
            />
            <input
              v-else
              type="password"
              v-model="registerForm.password"
              required
              placeholder="Enter your password"
            />
          </div>

          <div v-if="!isLoginMode" class="form-group">
            <label>Confirm Password</label>
            <input
              type="password"
              v-model="registerForm.confirmPassword"
              required
              placeholder="Confirm your password"
            />
          </div>

          <button type="submit" class="submit-btn">
            {{ isLoginMode ? 'Login' : 'Sign Up' }}
          </button>
        </form>

        <p class="toggle-mode">
          {{ isLoginMode ? "Don't have an account?" : "Already have an account?" }}
          <a @click="toggleMode">{{ isLoginMode ? 'Sign Up' : 'Login' }}</a>
        </p>

        <p class="back-home">
          <router-link to="/">← Back to Home</router-link>
        </p>
      </div>
    </div>
  </div>
</template>

<script>
const API_URL = 'http://localhost:3000/api';

export default {
  data() {
    return {
      isLoginMode: true,
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
      successMessage: ''
    };
  },
  methods: {
    toggleMode() {
      this.isLoginMode = !this.isLoginMode;
      this.errorMessage = '';
      this.successMessage = '';
      this.loginForm = { email: '', password: '' };
      this.registerForm = { username: '', email: '', password: '', confirmPassword: '' };
    },

    async handleSubmit() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.isLoginMode) {
        // password confirmation check for registration
        if (this.registerForm.password !== this.registerForm.confirmPassword) {
          this.errorMessage = 'Passwords do not match';
          return;
        }
      }

      try {
        // determine endpoint and body for the request
        const endpoint = this.isLoginMode ? '/auth/login' : '/auth/register';
        const body = this.isLoginMode ? this.loginForm : {
          username: this.registerForm.username,
          email: this.registerForm.email,
          password: this.registerForm.password
        };

        const response = await fetch(`${API_URL}${endpoint}`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
          body: JSON.stringify(body)
        });

        const data = await response.json();

        if (!response.ok) {
          throw new Error(data.error || 'Operation failed');
        }

        if (this.isLoginMode) {
          // connexion with success
          localStorage.setItem('currentUser', JSON.stringify(data));

          // redirect based on role
          if (data.role === 'ADMIN') {
            this.$router.push('/admin');
          } else {
            this.$router.push('/profile');
          }
        } else {
          // insciption with success
          this.successMessage = 'Account created successfully! Please login.';
          setTimeout(() => {
            this.isLoginMode = true;
            this.loginForm.email = this.registerForm.email;
            this.successMessage = '';
          }, 2000);
        }
      } catch (error) {
        this.errorMessage = error.message;
      }
    }
  },
  mounted() {
    // verify if the user is already logged in
    const currentUser = localStorage.getItem('currentUser');
    if (currentUser) {
      const user = JSON.parse(currentUser);
      if (user.role === 'ADMIN') {
        this.$router.push('/admin');
      } else {
        this.$router.push('/profile');
      }
    }
  }
};
</script>

<style scoped>
@font-face {
  font-family: 'TanMonCheri';
  src: url('../assets/font/tan-mon-cheri.ttf') format('truetype');
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #016B61 0%, #015550 100%);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.login-container {
  width: 100%;
  max-width: 450px;
  padding: 20px;
}

.login-card {
  background: white;
  padding: 2.5rem;
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
}

.login-header h2 {
  font-family: 'TanMonCheri', cursive;
  color: #016B61;
  margin-bottom: 1.5rem;
  text-align: center;
  font-size: 2.5rem;
}

.form-group {
  margin-bottom: 1.2rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #333;
  font-weight: 600;
  font-size: 0.95rem;
}

.form-group input {
  width: 100%;
  padding: 0.9rem;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.3s;
}

.form-group input:focus {
  outline: none;
  border-color: #016B61;
  box-shadow: 0 0 0 3px rgba(1, 107, 97, 0.1);
}

.submit-btn {
  width: 100%;
  padding: 1rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  margin-top: 1rem;
}

.submit-btn:hover {
  background: #015550;
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(1, 107, 97, 0.3);
}

.error-message {
  background: #fee;
  color: #c00;
  padding: 0.9rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  border-left: 4px solid #c00;
}

.success-message {
  background: #efe;
  color: #0a0;
  padding: 0.9rem;
  border-radius: 8px;
  margin-bottom: 1rem;
  border-left: 4px solid #0a0;
}

.toggle-mode {
  text-align: center;
  margin-top: 1.5rem;
  color: #666;
  font-size: 0.95rem;
}

.toggle-mode a {
  color: #016B61;
  cursor: pointer;
  text-decoration: none;
  font-weight: 600;
  margin-left: 0.3rem;
}

.toggle-mode a:hover {
  text-decoration: underline;
}

.back-home {
  text-align: center;
  margin-top: 1rem;
  font-size: 0.9rem;
}

.back-home a {
  color: #016B61;
  text-decoration: none;
}

.back-home a:hover {
  text-decoration: underline;
}
</style>

