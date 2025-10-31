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
            <img class="save-logo" src="../assets/img/icons/save.png" alt="Save for later" />
            <p>Save for later</p>
          </div>
          <div
            class="basket"
            @click="showBasket = !showBasket;"
            tabindex="0"
            role="button"
            data-test="basket-button"
            aria-label="Open shopping basket">
            <div class="basket-icon-wrapper">
              <img class="basket-logo" :src="basket" alt="Shopping Basket" />
              <span v-if="cartItemCount > 0" class="basket-count">{{ cartItemCount }}</span>
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
        <div class="dropdown-content">
          <a v-for="genre in featuredCategories" :key="genre.name" :href="'#' + genre.name">{{ genre.name }}</a>
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
          <div class="featured-item">
            <i class="fas fa-truck"></i>
            <h3>Free Shipping</h3>
            <p>On orders over $35</p>
          </div>
          <div class="featured-item">
            <i class="fas fa-undo"></i>
            <h3>Free Returns</h3>
            <p>30-day money back guarantee</p>
          </div>
          <div class="featured-item">
            <i class="fas fa-headset"></i>
            <h3>24/7 Support</h3>
            <p>Dedicated customer service</p>
          </div>
          <div class="featured-item">
            <i class="fas fa-lock"></i>
            <h3>Secure Payment</h3>
            <p>Your information is protected</p>
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
              <button class="quick-view" @click="openQuickView(book.id)">Quick View</button>
            </div>
          </div>
          <div class="book-info">
            <h3>{{ book.title }}</h3>
            <p class="author">{{ book.author }}</p>
            <div class="book-details">
              <div class="price">{{ book.price }}</div>
              <div class="rating">
                <i class="fas fa-star"></i>
                <span>{{ book.rating }}</span>
              </div>
            </div>
            <button class="add-to-cart" @click="addToCartFromMainPage(book)"><i class="fas fa-shopping-cart"></i> Add to Cart</button>
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
          </div>
        </div>
      </div>
    </section>

    <!-- Modal pour les détails du livre -->
    <div class="modal-wrapper" :class="{ active: showWindow }">
      <div class="window-overlay" @click="closeWindow"></div>
      <div class="window" @click.stop>
        <div v-if="selectedBook" class="window-content">
        <button class="close-window" @click="closeWindow">
          <i class="fas fa-times"></i>
        </button>

        <div class="window-header">
          <img :src="selectedBook.img" :alt="selectedBook.title" class="window-book-img" />
        </div>

        <div class="window-body">
          <h2 class="window-title">{{ selectedBook.title }}</h2>
          <p class="window-author">by {{ selectedBook.authorName }}</p>

          <div class="window-rating">
            <div class="stars">
              <i v-for="n in 5" :key="n" class="fas fa-star" :class="{ filled: n <= Math.round(selectedBook.avgRating) }"></i>
            </div>
            <span class="rating-value">{{ selectedBook.avgRating }}/5</span>
          </div>

          <div class="window-price">
            <span class="price-label">Price:</span>
            <span class="price-value">{{ selectedBook.price }}</span>
          </div>

          <button class="window-add-cart" @click="addToCart">
            <i class="fas fa-shopping-cart"></i> Add to Cart
          </button>

          <div class="window-section">
            <h3>Description</h3>
            <p>{{ selectedBook.description || 'No description available.' }}</p>
          </div>

          <div class="window-section" v-if="selectedBook.genres && selectedBook.genres.length > 0">
            <h3>Genres</h3>
            <div class="genre-tags">
              <span v-for="genre in selectedBook.genres" :key="genre" class="genre-tag">{{ genre }}</span>
            </div>
          </div>

          <div class="window-section">
            <h3>Details</h3>
            <div class="book-details-list">
              <div class="detail-item">
                <span class="detail-label">ISBN:</span>
                <span class="detail-value">{{ selectedBook.isbn13 }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Publisher:</span>
                <span class="detail-value">{{ selectedBook.publisherName }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Publication Date:</span>
                <span class="detail-value">{{ new Date(selectedBook.publication_date).toLocaleDateString() }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Pages:</span>
                <span class="detail-value">{{ selectedBook.page_count }}</span>
              </div>
              <div class="detail-item">
                <span class="detail-label">Language:</span>
                <span class="detail-value">{{ selectedBook.language.toUpperCase() }}</span>
              </div>
            </div>
          </div>

          <div class="window-section" v-if="selectedBook.authorBio">
            <h3>About the Author</h3>
            <p>{{ selectedBook.authorBio }}</p>
          </div>

          <div class="window-section" v-if="selectedBook.reviews && selectedBook.reviews.length > 0">
            <h3>Reviews ({{ selectedBook.reviews.length }})</h3>
            <div class="reviews-list">
              <div v-for="review in selectedBook.reviews" :key="review.review_id" class="review-item">
                <div class="review-header">
                  <div class="review-rating">
                    <i v-for="n in 5" :key="n" class="fas fa-star" :class="{ filled: n <= review.rating }"></i>
                  </div>
                  <span class="review-date">{{ new Date(review.created_at).toLocaleDateString() }}</span>
                </div>
                <h4 class="review-title">{{ review.title }}</h4>
                <p class="review-body">{{ review.body }}</p>
              </div>
            </div>
          </div>
          <div class="window-section" v-else>
            <h3>Reviews</h3>
            <p class="no-reviews">No reviews yet. Be the first to review this book!</p>
          </div>
        </div>
      </div>
      </div>
    </div>

    <!-- Basket Sidebar -->
    <div class="basket-overlay" :class="{ active: showBasket }" @click="closeBasket"></div>
    <div class="basket-sidebar" :class="{ active: showBasket }">
      <div class="basket-header">
        <h2>Shopping Basket</h2>
        <button class="close-basket" @click="closeBasket">
          <i class="fas fa-times"></i>
        </button>
      </div>

      <div class="basket-content">
        <div v-if="cartItems.length === 0" class="empty-basket">
          <i class="fas fa-shopping-basket"></i>
          <p>Your basket is empty</p>
          <button class="continue-shopping" @click="closeBasket">Continue Shopping</button>
        </div>

        <div v-else class="basket-items">
          <div v-for="item in cartItems" :key="item.id" class="basket-item">
            <img :src="item.img" :alt="item.title" class="basket-item-img" />
            <div class="basket-item-details">
              <h4>{{ item.title }}</h4>
              <p class="basket-item-author">{{ item.author }}</p>
              <p class="basket-item-price">{{ item.price }}</p>
              <div class="quantity-controls">
                <button @click="updateQuantity(item.id, -1)" class="qty-btn">
                  <i class="fas fa-minus"></i>
                </button>
                <span class="quantity">{{ item.quantity }}</span>
                <button @click="updateQuantity(item.id, 1)" class="qty-btn">
                  <i class="fas fa-plus"></i>
                </button>
              </div>
            </div>
            <button @click="removeFromCart(item.id)" class="remove-item">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>

      <div v-if="cartItems.length > 0" class="basket-footer">
        <div class="basket-total">
          <span>Total:</span>
          <span class="total-amount">${{ cartTotal }}</span>
        </div>
        <button class="checkout-btn">
          <i class="fas fa-lock"></i> Proceed to Checkout
        </button>
      </div>
    </div>

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
import logoImg from '../assets/img/icons/logo.png';
import shopImg from '../assets/img/icons/store.png';
import basket from '../assets/img/icons/basket.png';
import books from '../data/books.json';
import fictionImg from '../assets/img/categories/fiction.png';
import scienceFictionImg from '../assets/img/categories/scicence-fiction.jpeg';
import mysteryImg from '../assets/img/categories/mystery.jpeg';
import horrorImg from '../assets/img/categories/horror.jpeg';
import fantasyImg from '../assets/img/categories/fantasy.jpeg';
import classicImg from '../assets/img/categories/classic.jpeg';
import chamberOfSecrets from '../assets/img/books/chamber_of_secrets.jpg';
import book1984 from '../assets/img/books/1984.jpg';
import authors from '../data/authors.json';
import reviews from '../data/reviews.json';
import publishers from '../data/publishers.json';
import genres from '../data/genres.json';
import bookGenres from '../data/book_genres.json';
import lesMiserablesCover from '../assets/img/books/les_miserables.jpg';


const bookCovers = {
  // Harry Potter
  '9780439064873': chamberOfSecrets,
  // 1984
  '9780451524935': book1984,
  // Les Misérables
  '9782070409189': lesMiserablesCover,
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
      showWindow: false,
      selectedBook: null,
      showBasket: false,
      cartItems: [],
      genreImages: {
        'Fiction': fictionImg,
        'Mystery': mysteryImg,
        'Horror': horrorImg,
        'Classic': classicImg,
        'Fantasy': fantasyImg,
        'Science Fiction': scienceFictionImg
      }
    };
  },
  computed: {
    formattedBooks() {
      return books.map(book => {
        const author = authors.find(a => a.author_id === book.author_id);
        const authorName = author ? `${author.first_name} ${author.last_name}` : book.author;

        // Vérifier si le livre a des avis
        const bookReviews = reviews.filter(r => r.book_id === book.book_id);

        // Utiliser la moyenne des avis si disponible, sinon la note générée
        const rating = bookReviews.length > 0
          ? (bookReviews.reduce((sum, r) => sum + r.rating, 0) / bookReviews.length).toFixed(1)
          : this.getBookRating(book.book_id);

        const price = this.getBookPrice(book.book_id);

        return {
          id: book.book_id,
          title: book.title,
          author: authorName,
          price: price,
          rating: rating,
          img: bookCovers[book.isbn13] || bookCovers.default,
          description: book.description
        };
      });
    },
    featuredCategories() {
      return genres.map(genre => {
        // Compter le nombre de livres pour ce genre
        const bookCount = bookGenres.filter(bg => bg.genre_id === genre.genre_id).length;

        return {
          name: genre.name,
          count: bookCount,
          image: this.genreImages[genre.name] || fictionImg
        };
      });
    },
    cartTotal() {
      return this.cartItems.reduce((total, item) => {
        const price = parseFloat(item.price.replace('$', ''));
        return total + (price * item.quantity);
      }, 0).toFixed(2);
    },
    cartItemCount() {
      return this.cartItems.reduce((total, item) => total + item.quantity, 0);
    }
  },
  methods: {
    // Générer un prix cohérent basé sur l'ID du livre
    getBookPrice(bookId) {
      const seed = bookId * 123.456;
      const pseudoRandom = (seed * 9301 + 49297) % 233280;
      const price = 15 + (pseudoRandom / 233280) * 20;
      return `$${price.toFixed(2)}`;
    },
    // Générer une note cohérente basée sur l'ID du livre
    getBookRating(bookId) {
      const seed = bookId * 789.012;
      const pseudoRandom = (seed * 9301 + 49297) % 233280;
      const rating = 3 + (pseudoRandom / 233280) * 2;
      return rating.toFixed(1);
    },
    openQuickView(bookId) {
      const book = books.find(b => b.book_id === bookId);
      if (!book) return;

      const author = authors.find(a => a.author_id === book.author_id);
      const publisher = publishers.find(p => p.publisher_id === book.publisher_id);

      const bookGenreIds = bookGenres
        .filter(bg => bg.book_id === book.book_id)
        .map(bg => bg.genre_id);
      const bookGenresList = genres
        .filter(g => bookGenreIds.includes(g.genre_id))
        .map(g => g.name);

      const bookReviews = reviews.filter(r => r.book_id === book.book_id);

      const avgRating = bookReviews.length > 0
        ? (bookReviews.reduce((sum, r) => sum + r.rating, 0) / bookReviews.length).toFixed(1)
        : this.getBookRating(book.book_id);

      this.selectedBook = {
        ...book,
        authorName: author ? `${author.first_name} ${author.last_name}` : book.author,
        authorBio: author?.bio || '',
        publisherName: publisher?.name || 'Unknown Publisher',
        genres: bookGenresList,
        reviews: bookReviews,
        avgRating: avgRating,
        price: this.getBookPrice(book.book_id),
        img: bookCovers[book.isbn13] || bookCovers.default
      };

      this.showWindow = true;
    },
    closeWindow() {
      this.showWindow = false;
      setTimeout(() => {
        this.selectedBook = null;
      }, 300);
    },
    addToCart() {
      const existingItem = this.cartItems.find(item => item.id === this.selectedBook.book_id);

      if (existingItem) {
        existingItem.quantity++;
      } else {
        this.cartItems.push({
          id: this.selectedBook.book_id,
          title: this.selectedBook.title,
          author: this.selectedBook.authorName,
          price: this.selectedBook.price,
          img: this.selectedBook.img,
          quantity: 1
        });
      }

      // Afficher le panier
      this.showBasket = true;
    },
    addToCartFromMainPage(book) {
      const existingItem = this.cartItems.find(item => item.id === book.id);

      if (existingItem) {
        existingItem.quantity++;
      } else {
        this.cartItems.push({
          id: book.id,
          title: book.title,
          author: book.author,
          price: book.price,
          img: book.img,
          quantity: 1
        });
      }

      // Afficher le panier
      this.showBasket = true;
    },
    closeBasket() {
      this.showBasket = false;
    },
    removeFromCart(itemId) {
      const index = this.cartItems.findIndex(item => item.id === itemId);
      if (index > -1) {
        this.cartItems.splice(index, 1);
      }
    },
    updateQuantity(itemId, change) {
      const item = this.cartItems.find(item => item.id === itemId);
      if (item) {
        item.quantity += change;
        if (item.quantity <= 0) {
          this.removeFromCart(itemId);
        }
      }
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
    url('../assets/img/icons/library_home.jpeg') center/cover;
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

.basket {
  outline: none;
}

.basket:focus {
  outline: 2px solid rgba(255, 255, 255, 0.5);
  outline-offset: 2px;
}

.basket * {
  pointer-events: none;
  user-select: none;
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
  background: none;
  border: none;
  padding: 0;
  color: inherit;
  font-family: inherit;
}

.search-shop:hover, .save:hover, .basket:hover {
  transform: translateY(-2px);
}

.search-shop p, .save p, .basket-text {
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

/* Modal Window Styles */
.modal-wrapper {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 9998;
  display: none;
  align-items: center;
  justify-content: center;
}

.modal-wrapper.active {
  display: flex;
}

.window-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(3px);
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.window {
  position: relative;
  width: 90%;
  max-width: 900px;
  max-height: 90vh;
  background: white;
  z-index: 9999;
  overflow-y: auto;
  border-radius: 16px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3),
              0 0 100px rgba(1, 107, 97, 0.1);
  animation: modalSlideIn 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

@keyframes modalSlideIn {
  from {
    transform: scale(0.8) translateY(-50px);
    opacity: 0;
  }
  to {
    transform: scale(1) translateY(0);
    opacity: 1;
  }
}

.window-content {
  padding-bottom: 2rem;
}

.close-window {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
  background: rgba(255, 255, 255, 0.95);
  border: none;
  width: 45px;
  height: 45px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 1.5rem;
  color: #2c3e50;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 10;
  transition: all 0.3s ease;
}

.close-window:hover {
  background: #016B61;
  color: white;
  transform: rotate(90deg) scale(1.1);
  box-shadow: 0 6px 20px rgba(1, 107, 97, 0.3);
}

.window-header {
  width: 100%;
  height: 450px;
  overflow: hidden;
  background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.window-header::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 80px;
  background: linear-gradient(to top, rgba(255,255,255,1), rgba(255,255,255,0));
}

.window-book-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.window-body {
  padding: 2rem;
}

.window-title {
  font-size: 2rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-weight: 600;
  line-height: 1.3;
}

.window-author {
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 1.5rem;
  font-style: italic;
}

.window-rating {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}

.stars {
  display: flex;
  gap: 0.3rem;
}

.stars i {
  color: #ddd;
  font-size: 1.2rem;
}

.stars i.filled {
  color: #f1c40f;
}

.rating-value {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2c3e50;
}

.window-price {
  display: flex;
  align-items: center;
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.price-label {
  font-size: 1.1rem;
  color: #666;
}

.price-value {
  font-size: 2rem;
  font-weight: 700;
  color: #016B61;
}

.window-add-cart {
  width: 100%;
  padding: 1.2rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 2rem;
}

.window-add-cart:hover {
  background: #015045;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(1, 107, 97, 0.3);
}

.window-add-cart i {
  margin-right: 0.5rem;
}

.window-section {
  margin-bottom: 2rem;
  padding-top: 2rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}

.window-section:first-of-type {
  border-top: none;
  padding-top: 0;
}

.window-section h3 {
  font-size: 1.3rem;
  color: #2c3e50;
  margin-bottom: 1rem;
  font-weight: 600;
}

.window-section p {
  color: #666;
  line-height: 1.8;
  font-size: 1rem;
}

.genre-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.genre-tag {
  background: rgba(1, 107, 97, 0.1);
  color: #016B61;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  font-size: 0.9rem;
  font-weight: 500;
}

.book-details-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.8rem 0;
  border-bottom: 1px solid rgba(0, 0, 0, 0.05);
}

.detail-label {
  font-weight: 600;
  color: #2c3e50;
}

.detail-value {
  color: #666;
}

.reviews-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.review-item {
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 8px;
  border-left: 4px solid #016B61;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.8rem;
}

.review-rating {
  display: flex;
  gap: 0.2rem;
}

.review-rating i {
  color: #ddd;
  font-size: 0.9rem;
}

.review-rating i.filled {
  color: #f1c40f;
}

.review-date {
  font-size: 0.85rem;
  color: #999;
}

.review-title {
  font-size: 1.1rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
  font-weight: 600;
}

.review-body {
  color: #666;
  line-height: 1.6;
  margin: 0;
}

.no-reviews {
  color: #999;
  font-style: italic;
  text-align: center;
  padding: 2rem;
}

/* Scrollbar personnalisée pour la window */
.window::-webkit-scrollbar {
  width: 8px;
}

.window::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.window::-webkit-scrollbar-thumb {
  background: #016B61;
  border-radius: 4px;
}

.window::-webkit-scrollbar-thumb:hover {
  background: #015045;
}

/* Basket Sidebar Styles */
.basket-icon-wrapper {
  position: relative;
  display: inline-block;
}

.basket-count {
  position: absolute;
  top: -8px;
  right: -8px;
  background: #e74c3c;
  color: white;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 11px;
  font-weight: 600;
  font-family: sans-serif;
}

.basket-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  z-index: 9998;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
}

.basket-overlay.active {
  opacity: 1;
  visibility: visible;
}

.basket-sidebar {
  position: fixed;
  top: 0;
  right: -450px;
  width: 450px;
  max-width: 90vw;
  height: 100vh;
  background: white;
  z-index: 9999;
  box-shadow: -5px 0 20px rgba(0, 0, 0, 0.2);
  transition: right 0.3s ease;
  display: flex;
  flex-direction: column;
}

.basket-sidebar.active {
  right: 0;
}

.basket-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 2rem;
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  background: #016B61;
  color: white;
}

.basket-header h2 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
}

.close-basket {
  background: transparent;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.close-basket:hover {
  background: rgba(255, 255, 255, 0.2);
  transform: rotate(90deg);
}

.basket-content {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
}

.empty-basket {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  text-align: center;
  color: #999;
}

.empty-basket i {
  font-size: 4rem;
  margin-bottom: 1rem;
  color: #ddd;
}

.empty-basket p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
}

.continue-shopping {
  padding: 1rem 2rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.continue-shopping:hover {
  background: #015045;
  transform: translateY(-2px);
}

.basket-items {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.basket-item {
  display: flex;
  gap: 1rem;
  padding: 1rem;
  background: #f8f9fa;
  border-radius: 8px;
  position: relative;
}

.basket-item-img {
  width: 80px;
  height: 120px;
  object-fit: cover;
  border-radius: 4px;
}

.basket-item-details {
  flex: 1;
}

.basket-item-details h4 {
  margin: 0 0 0.5rem 0;
  font-size: 1rem;
  color: #2c3e50;
  font-weight: 600;
}

.basket-item-author {
  margin: 0 0 0.5rem 0;
  font-size: 0.85rem;
  color: #666;
}

.basket-item-price {
  margin: 0 0 0.8rem 0;
  font-size: 1.1rem;
  font-weight: 700;
  color: #016B61;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.qty-btn {
  background: white;
  border: 1px solid #ddd;
  width: 28px;
  height: 28px;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 0.8rem;
  color: #666;
}

.qty-btn:hover {
  background: #016B61;
  color: white;
  border-color: #016B61;
}

.quantity {
  min-width: 30px;
  text-align: center;
  font-weight: 600;
  color: #2c3e50;
}

.remove-item {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: transparent;
  border: none;
  color: #e74c3c;
  font-size: 1rem;
  cursor: pointer;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.remove-item:hover {
  background: rgba(231, 76, 60, 0.1);
  transform: scale(1.1);
}

.basket-footer {
  padding: 1.5rem 2rem;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
  background: #f8f9fa;
}

.basket-total {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
  font-size: 1.2rem;
}

.basket-total span:first-child {
  font-weight: 600;
  color: #2c3e50;
}

.total-amount {
  font-size: 1.8rem;
  font-weight: 700;
  color: #016B61;
}

.checkout-btn {
  width: 100%;
  padding: 1.2rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.checkout-btn:hover {
  background: #015045;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(1, 107, 97, 0.3);
}

/* Scrollbar pour la basket sidebar */
.basket-content::-webkit-scrollbar {
  width: 6px;
}

.basket-content::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.basket-content::-webkit-scrollbar-thumb {
  background: #016B61;
  border-radius: 3px;
}

.basket-content::-webkit-scrollbar-thumb:hover {
  background: #015045;
}
</style>
