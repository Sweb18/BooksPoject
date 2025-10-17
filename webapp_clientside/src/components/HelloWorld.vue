<template>
  <div>
    <header class="header">
      <img class="logo" :src="logo" alt="Logo Librairie" />
      <h1>📚 Ma Librairie en Ligne</h1>
    </header>
    <nav class="nav">
      <a href="#">Accueil</a>
      <a href="#">Nouveautés</a>
      <a href="#">Best-sellers</a>
      <a href="#">Catégories</a>
      <a href="#">Contact</a>
    </nav>
    <section class="hero">
      <h2>Bienvenue dans notre univers littéraire</h2>
      <p>Découvrez des milliers de livres pour tous les goûts</p>
      <button>Parcourir le catalogue</button>
    </section>
    <section class="container">
      <h2 class="section-title">📖 Nos Nouveautés</h2>
      <div class="books-grid">
        <div class="book-card" v-for="book in books" :key="book.title">
          <img :src="book.img" :alt="book.title" />
          <h3>{{ book.title }}</h3>
          <p>{{ book.author }}</p>
          <div class="price">{{ book.price }}</div>
          <button>Ajouter au panier</button>
        </div>
      </div>
    </section>
    <footer class="footer">
      <p>&copy; 2025 Ma Librairie en Ligne - Tous droits réservés</p>
    </footer>
  </div>
</template>

<script>
import logoImg from '../assets/book.png';
import bookImg from '../assets/book.png';
import bookImg2 from '../assets/book.png';

export default {
  name: "AccueilLibrairie",
  data() {
    return {
      logo: logoImg,
      books: [
        {
          title: "Le Mystère du Nord",
          author: "Jean Dupont",
          price: "24,99 €",
          img: bookImg
        },
        {
          title: "Histoires du Soir",
          author: "Marie Martin",
          price: "19,99 €",
          img: bookImg2
        },
        {
          title: "Code et Programmation",
          author: "Paul Leroux",
          price: "29,99 €",
          img: bookImg
        },
        {
          title: "Voyages Extraordinaires",
          author: "Sophie Bernard",
          price: "22,99 €",
          img: bookImg2
        }
      ]
    };
  }
};
</script>

<style scoped>
/* ... CSS identique à ta version précédente ... */
.header {
  background: #2c3e50;
  color: white;
  text-align: center;
  padding: 20px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
}
.logo {
  width: 48px;
  height: 48px;
}
.nav {
  background: #34495e;
  padding: 10px 0;
  text-align: center;
}
.nav a {
  color: white;
  text-decoration: none;
  margin: 0 15px;
  font-weight: bold;
}
.nav a:hover {
  color: #3498db;
}
.hero {
  background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)),
  url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?w=1200') center/cover;
  color: white;
  padding: 100px 20px;
  text-align: center;
}
.hero h2 {
  font-size: 3em;
  margin-bottom: 20px;
}
.hero p {
  font-size: 1.3em;
  margin-bottom: 30px;
}
.hero button {
  background: #e74c3c;
  color: white;
  padding: 15px 30px;
  border: none;
  border-radius: 5px;
  font-size: 1.1em;
  cursor: pointer;
  transition: background 0.3s;
}
.hero button:hover {
  background: #c0392b;
}
.container {
  max-width: 1200px;
  margin: 40px auto;
  padding: 0 20px;
}
.section-title {
  text-align: center;
  font-size: 2em;
  margin-bottom: 30px;
  color: #2c3e50;
}
.books-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 30px;
  margin-bottom: 50px;
}
.book-card {
  background: white;
  border-radius: 10px;
  padding: 20px;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}
.book-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 6px 12px rgba(0,0,0,0.2);
}
.book-card img {
  width: 100%;
  height: 300px;
  object-fit: cover;
  border-radius: 5px;
  margin-bottom: 15px;
}
.book-card h3 {
  font-size: 1.3em;
  margin-bottom: 10px;
  color: #2c3e50;
}
.book-card p {
  color: #7f8c8d;
  margin-bottom: 10px;
}
.book-card .price {
  font-size: 1.5em;
  color: #e74c3c;
  font-weight: bold;
  margin-bottom: 15px;
}
.book-card button {
  background: #3498db;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background 0.3s;
}
.book-card button:hover {
  background: #2980b9;
}
.footer {
  background: #2c3e50;
  color: white;
  text-align: center;
  padding: 20px 0;
  margin-top: 50px;
}
</style>
