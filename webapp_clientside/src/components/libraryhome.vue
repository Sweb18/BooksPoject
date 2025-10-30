<template>
  <div class="library">
    <header class="header">

      <div class="header-content">
        <img class="logo" :src="logo" alt="Library Logo" />
        <!--<h1 >La librairie du Doro</h1>-->
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
            <img class="save-logo" src="../assets/img/save.png" alt="Save for later" />
            <p>Save for later</p>
          </div>
          <div class="basket">
            <img class="basket-logo" :src="basket" alt="Shopping Basket" />
            <p>Basket</p>
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
      <h2 class="section-title">Discover New Releases</h2>
      <div class="books-grid">
        <div class="book-card" v-for="book in formattedBooks" :key="book.id">
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
        <div v-for="category in featuredCategories" :key="category.name" class="category-card">
          <div class="category-image" :style="{ backgroundImage: `url('${category.image}')` }"></div>
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
        <p>&copy; 2025 Doro Party - All rights reserved</p>
      </div>
    </footer>
  </div>
</template>



<script>
import logoImg from '../assets/img/logo.png';
import shopImg from '../assets/img/store.png';
import basket from '../assets/img/basket.png';
import books from '../data/books.json';
// Import des images de catégories
import fictionImg from '../assets/img/categories/fiction.jpeg';
import mysteryImg from '../assets/img/categories/mystery.jpeg';
import horrorImg from '../assets/img/categories/horror.jpeg';
import classicImg from '../assets/img/categories/classic.jpeg';

const bookCovers = {
  // Harry Potter
  '9780439064873': 'https://m.media-amazon.com/images/I/51OihdkhSBL._SY445_SX342_.jpg',
  // 1984
  '9780451524935': '../assets/img/books/1984.jpg',
  // Les Misérables
  '9782070409189': 'https://m.media-amazon.com/images/I/81s3toEGQgL._SY522_.jpg',
  // Pride and Prejudice
  '9780141439518': 'https://m.media-amazon.com/images/I/71Q1tPupKjL._SY522_.jpg',

  // Fallback image pour les livres sans couverture spécifique
  'default': 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=500&q=80'
};

export default {
  name: "LibraryHome",
  data() {
    return {
      logo: logoImg,
      shop: shopImg,
      basket: basket,
      searchQuery: '',
      categories: ['Fiction', 'Mystery', 'Horror', 'Classic', 'Romance', 'Adventure'],
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
      featuredCategories: [
        {
          name: "Fiction",
          count: 1250,
          image: fictionImg
        },
        {
          name: "Mystery",
          count: 850,
          image: mysteryImg
        },
        {
          name: "Horror",
          count: 720,
          image: horrorImg
        },
        {
          name: "Classic",
          count: 530,
          image: classicImg
        }
      ]
    };
  },
  computed: {
    formattedBooks() {
      return books.map(book => ({
        id: book.book_id,
        title: book.title,
        author: book.author,
        price: `$${(Math.random() * 20 + 15).toFixed(2)}`,
        rating: (Math.random() * 2 + 3).toFixed(1),
        img: bookCovers[book.isbn13] || bookCovers.default,
        description: book.description
      }));
    }
  }
};
</script>

<style scoped>
/* Reset des marges par défaut */
:root {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

@font-face {
  font-family: 'Tan Mon Cheri';
  src: url('../assets/font/tan-mon-cheri.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}

.library {
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
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  padding: 1rem;
}

.basket-logo{
  width: 32px;
  height: 32px;
}

.basket{
  font-size: 10px;
}

.save-logo{
  width: 32px;
  height: 32px;
}

.save{
  font-size: 10px;
  margin-right: 20px ;
}

.shop-logo{
  width: 32px;
  height: 32px;
}

.search-shop{
  font-size: 10px;

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
  border : none;
  background : none;

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

.dropdown-content {
  display: none;
  position: absolute;
  background: white;
  min-width: 200px;
  box-shadow: 0 8px 20px rgba(0,0,0,0.1);
  border-radius: 8px;
  padding: 0.5rem 0;
  z-index: 1000;
  transform: translateY(10px);
  transition: all 0.3s ease;
}

.dropdown:hover .dropdown-content {
  display: block;
  animation: fadeIn 0.3s ease;
}

.dropdown-content a {
  color: #2c3e50;
  padding: 12px 20px;
  text-decoration: none;
  display: block;
  transition: all 0.2s ease;
}

.dropdown-content a:hover {
  background: rgba(1, 107, 97, 0.1);
  color: #016B61;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.hero {
  background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)),
    url('../assets/img/library_home.jpeg') center/cover;
  color: white;
  padding: 8rem 2rem;
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
  margin-bottom: 2rem;
  opacity: 0.9;
}

.primary-button, .secondary-button {
  padding: 1rem 2.5rem;
  border-radius: 30px;
  font-size: 1rem;
  font-weight: 500;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
}

.primary-button {
  background: #016B61;
  color: white;
  border: none;
}

.secondary-button {
  background: transparent;
  border: 2px solid white;
  color: white;
  margin-left: 1rem;
}

.primary-button:hover {
  background: #015045;
  transform: translateY(-2px);
}

.section-title {
  text-align: center;
  font-size: 2.2rem;
  margin: 4rem 0 3rem;
  color: #2c3e50;
  font-weight: 300;
  letter-spacing: 0.5px;
}

.books-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2.5rem;
  padding: 0 2rem;
  margin-bottom: 6rem;
}

.book-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 5px 15px rgba(0,0,0,0.08);
  transition: all 0.3s ease;
  border: 1px solid rgba(0,0,0,0.05);
}

.book-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}

.book-image {
  position: relative;
  height: 380px;
  overflow: hidden;
}

.book-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.book-card:hover .book-image img {
  transform: scale(1.05);
}

.book-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(1, 107, 97, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s ease;
}

.quick-view {
  background: white;
  color: #016B61;
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 25px;
  font-weight: 500;
  transform: translateY(20px);
  transition: all 0.3s ease;
}

.book-card:hover .book-overlay {
  opacity: 1;
}

.book-card:hover .quick-view {
  transform: translateY(0);
}

.book-info {
  padding: 1.8rem;
}

.book-info h3 {
  font-size: 1.2rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.author {
  color: #666;
  font-size: 0.95rem;
  margin-bottom: 1rem;
}

.book-details {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid rgba(0,0,0,0.08);
}

.price {
  font-size: 1.3rem;
  font-weight: 600;
  color: #016B61;
}

.rating {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #f1c40f;
}

.add-to-cart {
  width: 100%;
  padding: 0.9rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 500;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
}

.add-to-cart:hover {
  background: #015045;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  margin: 4rem 0 6rem;
  padding: 0 2rem;
}

.category-card {
  position: relative;
  height: 250px;
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

.category-image {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  transition: transform 0.3s ease;
}

.category-card:hover .category-image {
  transform: scale(1.05);
}

.category-content {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 2rem;
  background: linear-gradient(transparent, rgba(0,0,0,0.8));
  color: white;
  z-index: 2;
}

.category-content h3 {
  font-size: 1.5rem;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.category-content p {
  font-size: 1rem;
  opacity: 0.9;
  margin: 0;
}

.featured {
  background: #f8f9fa;
  padding: 6rem 0;
  margin: 4rem 0;
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 3rem;
  text-align: center;
  padding: 0 2rem;
}

.featured-item {
  padding: 2rem;
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  transition: all 0.3s ease;
}

.featured-item:hover {
  transform: translateY(-5px);
}

.featured-item i {
  font-size: 2.5rem;
  color: #016B61;
  margin-bottom: 1.5rem;
}

.featured-item h3 {
  font-size: 1.2rem;
  color: #2c3e50;
  margin-bottom: 1rem;
  font-weight: 500;
}

.featured-item p {
  color: #666;
  line-height: 1.6;
}

.footer {
  background: #016B61;
  color: white;
  padding: 6rem 0 0;
  margin-top: 4rem;
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

.header-links {
  display: flex;
  align-items: center;
  gap: 2rem;
  margin-left: auto;
}

.header-links > div {
  display: flex;
  align-items: center;
}

.search-shop, .save, .basket {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  text-align: center;
  cursor: pointer;
  transition: transform 0.2s ease;
}

.search-shop:hover, .save:hover, .basket:hover {
  transform: translateY(-2px);
}

.search-shop p, .save p, .basket p {
  margin: 0;
  font-size: 12px;
  white-space: nowrap;
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
