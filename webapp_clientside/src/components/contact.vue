<script>
export default {
  data() {
    return {
      logo: require('../assets/img/icons/logo.png'),
      shop: require('../assets/img/icons/store.png'),
      basket: require('../assets/img/icons/basket.png'),
      searchQuery: '',
      formData: {
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        subject: '',
        message: ''
      },
      submitted: false
    }
  },
  methods: {
    submitForm() {
      // Validation simple
      if (this.formData.firstName && this.formData.lastName && this.formData.email && this.formData.message) {
        console.log('Form submitted:', this.formData);
        this.submitted = true;
        setTimeout(() => {
          this.submitted = false;
          this.resetForm();
        }, 3000);
      } else {
        alert('Please fill in all required fields');
      }
    },
    resetForm() {
      this.formData = {
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        subject: '',
        message: ''
      };
    }
  }
}
</script>

<template>
  <div class="contact-page">
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
        <h2>Contact Us</h2>
        <p>We're here to help and answer any question you might have</p>
      </div>
    </section>

    <section class="contact-info container">
      <div class="info-grid">
        <div class="info-card">
          <i class="fas fa-map-marker-alt"></i>
          <h3>Visit Us</h3>
          <p>123 Library Street</p>
          <p>Paris, France 75001</p>
        </div>
        <div class="info-card">
          <i class="fas fa-phone"></i>
          <h3>Call Us</h3>
          <p>+33 1 23 45 67 89</p>
          <p>Mon-Fri 9am-6pm</p>
        </div>
        <div class="info-card">
          <i class="fas fa-envelope"></i>
          <h3>Email Us</h3>
          <p>contact@librairiedudoro.com</p>
          <p>support@librairiedudoro.com</p>
        </div>
        <div class="info-card">
          <i class="fas fa-clock"></i>
          <h3>Opening Hours</h3>
          <p>Monday - Saturday: 9am - 8pm</p>
          <p>Sunday: 10am - 6pm</p>
        </div>
      </div>
    </section>

    <section class="contact-form-section container">
      <div class="form-wrapper">
        <div class="form-header">
          <h2>Send us a Message</h2>
          <p>Fill out the form below and we'll get back to you as soon as possible</p>
        </div>

        <div v-if="submitted" class="success-message">
          <i class="fas fa-check-circle"></i>
          <p>Thank you for your message! We'll get back to you soon.</p>
        </div>

        <form @submit.prevent="submitForm" class="contact-form">
          <div class="form-row">
            <div class="form-group">
              <label for="firstName">First Name *</label>
              <input
                type="text"
                id="firstName"
                v-model="formData.firstName"
                required
                placeholder="John"
              />
            </div>
            <div class="form-group">
              <label for="lastName">Last Name *</label>
              <input
                type="text"
                id="lastName"
                v-model="formData.lastName"
                required
                placeholder="Doe"
              />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="email">Email *</label>
              <input
                type="email"
                id="email"
                v-model="formData.email"
                required
                placeholder="john.doe@example.com"
              />
            </div>
            <div class="form-group">
              <label for="phone">Phone</label>
              <input
                type="tel"
                id="phone"
                v-model="formData.phone"
                placeholder="+33 1 23 45 67 89"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="subject">Subject *</label>
            <input
              type="text"
              id="subject"
              v-model="formData.subject"
              required
              placeholder="How can we help you?"
            />
          </div>

          <div class="form-group">
            <label for="message">Message *</label>
            <textarea
              id="message"
              v-model="formData.message"
              required
              rows="6"
              placeholder="Write your message here..."
            ></textarea>
          </div>

          <button type="submit" class="submit-button">
            <i class="fas fa-paper-plane"></i> Send Message
          </button>
        </form>
      </div>
    </section>

    <section class="map-section">
      <div class="map-placeholder">
        <i class="fas fa-map-marked-alt"></i>
        <p>Map Location</p>
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

.contact-page {
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

.contact-info {
  margin-bottom: 4rem;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-top: 3rem;
}

.info-card {
  background: white;
  padding: 2rem;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
}

.info-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 16px rgba(0,0,0,0.12);
}

.info-card i {
  font-size: 2.5rem;
  color: #016B61;
  margin-bottom: 1rem;
}

.info-card h3 {
  font-size: 1.3rem;
  margin-bottom: 1rem;
  color: #2c3e50;
}

.info-card p {
  margin: 0.5rem 0;
  color: #666;
  font-size: 0.95rem;
}

.contact-form-section {
  margin-bottom: 4rem;
}

.form-wrapper {
  background: white;
  padding: 3rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

.form-header {
  text-align: center;
  margin-bottom: 2rem;
}

.form-header h2 {
  font-size: 2rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.form-header p {
  color: #666;
  font-size: 1rem;
}

.success-message {
  background: #d4edda;
  color: #155724;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.success-message i {
  font-size: 1.5rem;
}

.contact-form {
  max-width: 800px;
  margin: 0 auto;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group label {
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-weight: 500;
  font-size: 0.95rem;
}

.form-group input,
.form-group textarea {
  padding: 0.8rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #016B61;
  box-shadow: 0 0 0 3px rgba(1, 107, 97, 0.1);
}

.form-group textarea {
  resize: vertical;
  min-height: 120px;
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
  margin-top: 1rem;
}

.submit-button:hover {
  background: #015550;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(1, 107, 97, 0.3);
}

.map-section {
  width: 100%;
  height: 400px;
  background: #e9ecef;
  margin-top: 4rem;
}

.map-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #6c757d;
}

.map-placeholder i {
  font-size: 4rem;
  margin-bottom: 1rem;
}

.map-placeholder p {
  font-size: 1.2rem;
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

  .form-row {
    grid-template-columns: 1fr;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>