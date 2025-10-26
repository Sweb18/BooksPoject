<template>
  <div class="library">
    <header class="header">
      <div class="header-content">
        <img class="logo" :src="logo" alt="Library Logo" />
        <h1>📚 Book & Culture</h1>
      </div>
      <div class="search-bar">
        <input type="text" placeholder="Search for a book, author..." v-model="searchQuery" />
        <button class="search-button"><i class="fas fa-search"></i></button>
      </div>
    </header>

    <nav class="nav">
      <router-link to="/" class="nav-link">Home</router-link>
      <router-link to="/new" class="nav-link">New Releases</router-link>
      <router-link to="/best-sellers" class="nav-link">Best Sellers</router-link>
      <div class="dropdown">
        <button class="nav-link">Categories <i class="fas fa-chevron-down"></i></button>
        <div class="dropdown-content">
          <a v-for="category in categories" :key="category" :href="'#' + category">{{ category }}</a>
        </div>
      </div>
      <router-link to="/contact" class="nav-link">Contact</router-link>
    </nav>

    <section class="hero">
      <div class="hero-content">
        <h2>Discover our Selection</h2>
        <p>Thousands of books for all tastes and interests</p>
        <div class="hero-buttons">
          <button class="primary-button">Explore Catalog</button>
          <button class="secondary-button">Staff Picks</button>
        </div>
      </div>
    </section>

    <section class="featured">
      <div class="container">
        <div class="featured-grid">
          <div class="featured-item" v-for="item in featuredItems" :key="item.title">
            <i :class="item.icon"></i>
            <h3>{{ item.title }}</h3>
            <p>{{ item.description }}</p>
          </div>
        </div>
      </div>
    </section>

    <section class="new-releases container">
      <h2 class="section-title">📖 Discover New Releases</h2>
      <div class="books-grid">
        <div class="book-card" v-for="book in books" :key="book.id">
          <div class="book-image">
            <img :src="book.img" :alt="book.title" />
            <div class="book-overlay">
              <button class="quick-view">Quick View</button>
            </div>
          </div>
          <div class="book-info">
            <h3>{{ book.title }}</h3>
            <p class="author">{{ book.author }}</p>
            <div class="book-details">
              <div class="price">{{ book.price }}</div>
              <div class="rating">
                <i class="fas fa-star"></i>
                <span>{{ book.rating }}/5</span>
              </div>
            </div>
            <button class="add-to-cart"><i class="fas fa-shopping-cart"></i> Add to Cart</button>
          </div>
        </div>
      </div>
    </section>

    <section class="categories container">
      <h2 class="section-title">Browse our Sections</h2>
      <div class="categories-grid">
        <div v-for="category in featuredCategories" :key="category.name" class="category-card" :style="{ backgroundImage: `url(${category.image})` }">
          <div class="category-content">
            <h3>{{ category.name }}</h3>
            <p>{{ category.count }} books</p>
          </div>
        </div>
      </div>
    </section>

    <footer class="footer">
      <div class="footer-content container">
        <div class="footer-section">
          <h4>About</h4>
          <ul>
            <li><a href="#">Our Story</a></li>
            <li><a href="#">Our Stores</a></li>
            <li><a href="#">Careers</a></li>
          </ul>
        </div>
        <div class="footer-section">
          <h4>Customer Service</h4>
          <ul>
            <li><a href="#">Help</a></li>
            <li><a href="#">Shipping</a></li>
            <li><a href="#">Returns</a></li>
          </ul>
        </div>
        <div class="footer-section">
          <h4>Follow Us</h4>
          <div class="social-links">
            <a href="#"><i class="fab fa-facebook"></i></a>
            <a href="#"><i class="fab fa-instagram"></i></a>
            <a href="#"><i class="fab fa-twitter"></i></a>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; 2025 Book & Culture - All rights reserved</p>
      </div>
    </footer>
  </div>
</template>

<script>
import logoImg from '../assets/book.png';

export default {
  name: "LibraryHome",
  data() {
    return {
      logo: logoImg,
      searchQuery: '',
      categories: ['Novels', 'Science Fiction', 'Mystery', 'Children', 'Science', 'History'],
      featuredItems: [
        {
          icon: 'fas fa-truck',
          title: 'Free Shipping',
          description: 'On orders over $35'
        },
        {
          icon: 'fas fa-undo',
          title: 'Free Returns',
          description: '30-day money back guarantee'
        },
        {
          icon: 'fas fa-shield-alt',
          title: 'Secure Payment',
          description: 'Your data is protected'
        },
        {
          icon: 'fas fa-headset',
          title: '24/7 Support',
          description: 'Have a question? Contact us'
        }
      ],
      books: [
        {
          id: 1,
          title: "The Starlight Mystery",
          author: "Mary Davis",
          price: "$22.90",
          rating: 4.5,
          img: 'https://picsum.photos/200/300'
        },
        {
          id: 2,
          title: "The Shadow's Secret",
          author: "Thomas Lawrence",
          price: "$19.90",
          rating: 4.8,
          img: 'https://picsum.photos/200/300'
        },
        {
          id: 3,
          title: "Beyond Words",
          author: "Claire Martin",
          price: "$24.90",
          rating: 4.3,
          img: 'https://picsum.photos/200/300'
        },
        {
          id: 4,
          title: "Paths of Wisdom",
          author: "Peter Durant",
          price: "$21.90",
          rating: 4.7,
          img: 'https://picsum.photos/200/300'
        }
      ],
      featuredCategories: [
        { name: "Novels", count: 1250, image: 'https://picsum.photos/400/200' },
        { name: "Science Fiction", count: 850, image: 'https://picsum.photos/400/200' },
        { name: "Children", count: 720, image: 'https://picsum.photos/400/200' },
        { name: "History", count: 530, image: 'https://picsum.photos/400/200' }
      ]
    };
  }
};
</script>

<style scoped>
.library {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.header {
  background: #2c3e50;
  padding: 1rem 2rem;
  color: white;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1rem;
}

.logo {
  width: 48px;
  height: 48px;
}

.search-bar {
  display: flex;
  max-width: 600px;
  margin: 0 auto;
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
}

.nav {
  background: #34495e;
  padding: 1rem;
  display: flex;
  justify-content: center;
  gap: 2rem;
}

.nav-link {
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background 0.3s;
}

.nav-link:hover {
  background: rgba(255, 255, 255, 0.1);
}

.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-content {
  display: none;
  position: absolute;
  background: white;
  min-width: 160px;
  box-shadow: 0 8px 16px rgba(0,0,0,0.1);
  z-index: 1;
  border-radius: 4px;
}

.dropdown:hover .dropdown-content {
  display: block;
}

.dropdown-content a {
  color: #2c3e50;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

.hero {
  background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
    url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=1200') center/cover;
  color: white;
  padding: 6rem 2rem;
  text-align: center;
}

.hero-content {
  max-width: 800px;
  margin: 0 auto;
}

.hero h2 {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.hero-buttons {
  margin-top: 2rem;
  display: flex;
  gap: 1rem;
  justify-content: center;
}

.primary-button, .secondary-button {
  padding: 1rem 2rem;
  border-radius: 4px;
  border: none;
  font-size: 1.1rem;
  cursor: pointer;
  transition: transform 0.3s;
}

.primary-button {
  background: #e74c3c;
  color: white;
}

.secondary-button {
  background: transparent;
  border: 2px solid white;
  color: white;
}

.primary-button:hover, .secondary-button:hover {
  transform: translateY(-2px);
}

.featured {
  background: white;
  padding: 4rem 0;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  text-align: center;
}

.featured-item i {
  font-size: 2.5rem;
  color: #e74c3c;
  margin-bottom: 1rem;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  margin: 3rem 0;
  color: #2c3e50;
}

.books-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  margin-bottom: 4rem;
}

.book-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  transition: transform 0.3s;
}

.book-card:hover {
  transform: translateY(-5px);
}

.book-image {
  position: relative;
  height: 400px;
}

.book-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.book-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.book-image:hover .book-overlay {
  opacity: 1;
}

.book-info {
  padding: 1.5rem;
}

.author {
  color: #666;
  margin: 0.5rem 0;
}

.book-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 1rem 0;
}

.price {
  font-size: 1.25rem;
  font-weight: bold;
  color: #e74c3c;
}

.rating {
  color: #f1c40f;
}

.add-to-cart {
  width: 100%;
  padding: 0.8rem;
  background: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background 0.3s;
}

.add-to-cart:hover {
  background: #2980b9;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 4rem;
}

.category-card {
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
  position: relative;
  background-size: cover;
  background-position: center;
}

.category-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 1.5rem;
  background: linear-gradient(transparent, rgba(0,0,0,0.8));
  color: white;
}

.footer {
  background: #2c3e50;
  color: white;
  padding: 4rem 0 0;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 2rem;
}

.footer-section h4 {
  margin-bottom: 1.5rem;
  font-size: 1.2rem;
}

.footer-section ul {
  list-style: none;
  padding: 0;
}

.footer-section ul li {
  margin-bottom: 0.8rem;
}

.footer-section a {
  color: #ecf0f1;
  text-decoration: none;
}

.social-links {
  display: flex;
  gap: 1rem;
}

.social-links a {
  font-size: 1.5rem;
}

.footer-bottom {
  text-align: center;
  padding: 2rem 0;
  margin-top: 4rem;
  border-top: 1px solid rgba(255,255,255,0.1);
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    text-align: center;
  }

  .nav {
    flex-direction: column;
    align-items: center;
    gap: 1rem;
  }

  .hero h2 {
    font-size: 2rem;
  }

  .hero-buttons {
    flex-direction: column;
  }
}
</style>
