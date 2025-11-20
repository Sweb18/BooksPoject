<script>
import booksData from '../data/books.json';
import authorsData from '../data/authors.json';
import publishersData from '../data/publishers.json';
import genresData from '../data/genres.json';

export default {
  data() {
    return {
      logo: require('../assets/img/icons/logo.png'),
      shop: require('../assets/img/icons/store.png'),
      basket: require('../assets/img/icons/basket.png'),
      searchQuery: '',
      currentUser: null,
      activeTab: 'books', // books, authors, publishers
      books: this.loadBooks(),
      authors: this.loadAuthors(),
      publishers: this.loadPublishers(),
      genres: genresData,

      // Modals
      showBookModal: false,
      showAuthorModal: false,
      showPublisherModal: false,
      isEditing: false,

      // Forms
      bookForm: this.getEmptyBookForm(),
      authorForm: this.getEmptyAuthorForm(),
      publisherForm: this.getEmptyPublisherForm(),

      // Messages
      errorMessage: '',
      successMessage: ''
    }
  },
  computed: {
    isAdmin() {
      return this.currentUser && this.currentUser.role === 'ADMIN';
    },
    nextBookId() {
      return this.books.length > 0 ? Math.max(...this.books.map(b => b.book_id)) + 1 : 1;
    },
    nextAuthorId() {
      return this.authors.length > 0 ? Math.max(...this.authors.map(a => a.author_id)) + 1 : 1;
    },
    nextPublisherId() {
      return this.publishers.length > 0 ? Math.max(...this.publishers.map(p => p.publisher_id)) + 1 : 1;
    },
    filteredBooks() {
      if (!this.searchQuery) return this.books;
      const query = this.searchQuery.toLowerCase();
      return this.books.filter(book =>
        book.title.toLowerCase().includes(query) ||
        book.author.toLowerCase().includes(query) ||
        book.isbn13.includes(query)
      );
    }
  },
  mounted() {
    const savedUser = localStorage.getItem('currentUser');
    if (savedUser) {
      this.currentUser = JSON.parse(savedUser);
      if (!this.isAdmin) {
        this.$router.push('/');
      }
    } else {
      this.$router.push('/profile');
    }
  },
  methods: {
    loadBooks() {
      const savedBooks = localStorage.getItem('books');
      return savedBooks ? JSON.parse(savedBooks) : [...booksData];
    },
    loadAuthors() {
      const savedAuthors = localStorage.getItem('authors');
      return savedAuthors ? JSON.parse(savedAuthors) : [...authorsData];
    },
    loadPublishers() {
      const savedPublishers = localStorage.getItem('publishers');
      return savedPublishers ? JSON.parse(savedPublishers) : [...publishersData];
    },
    saveBooks() {
      localStorage.setItem('books', JSON.stringify(this.books));
    },
    saveAuthors() {
      localStorage.setItem('authors', JSON.stringify(this.authors));
    },
    savePublishers() {
      localStorage.setItem('publishers', JSON.stringify(this.publishers));
    },
    getEmptyBookForm() {
      return {
        book_id: null,
        title: '',
        author: '',
        subtitle: '',
        isbn13: '',
        author_id: null,
        publisher_id: null,
        publication_date: '',
        language: 'en',
        page_count: 0,
        description: ''
      };
    },
    getEmptyAuthorForm() {
      return {
        author_id: null,
        first_name: '',
        last_name: '',
        bio: '',
        birth_date: '',
        death_date: '',
        nationality: '',
        website: '',
        portrait_url: ''
      };
    },
    getEmptyPublisherForm() {
      return {
        publisher_id: null,
        name: '',
        country: '',
        founded_year: null,
        headquarters_city: '',
        website: '',
        contact_email: '',
        phone: ''
      };
    },

    // Book Actions
    openAddBookModal() {
      this.isEditing = false;
      this.bookForm = this.getEmptyBookForm();
      this.showBookModal = true;
      this.errorMessage = '';
    },
    openEditBookModal(book) {
      this.isEditing = true;
      this.bookForm = { ...book };
      this.showBookModal = true;
      this.errorMessage = '';
    },
    closeBookModal() {
      this.showBookModal = false;
      this.bookForm = this.getEmptyBookForm();
      this.errorMessage = '';
    },
    saveBook() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.bookForm.title || !this.bookForm.isbn13) {
        this.errorMessage = 'Title and ISBN are required';
        return;
      }

      if (this.isEditing) {
        const index = this.books.findIndex(b => b.book_id === this.bookForm.book_id);
        if (index !== -1) {
          this.books[index] = { ...this.bookForm };
          this.successMessage = 'Book updated successfully!';
        }
      } else {
        const newBook = {
          ...this.bookForm,
          book_id: this.nextBookId
        };
        this.books.push(newBook);
        this.successMessage = 'Book added successfully!';
      }

      this.saveBooks();
      this.closeBookModal();
      setTimeout(() => { this.successMessage = ''; }, 3000);
    },
    deleteBook(bookId) {
      if (confirm('Are you sure you want to delete this book?')) {
        this.books = this.books.filter(b => b.book_id !== bookId);
        this.saveBooks();
        this.successMessage = 'Book deleted successfully!';
        setTimeout(() => { this.successMessage = ''; }, 3000);
      }
    },

    // Author Actions
    openAddAuthorModal() {
      this.isEditing = false;
      this.authorForm = this.getEmptyAuthorForm();
      this.showAuthorModal = true;
      this.errorMessage = '';
    },
    openEditAuthorModal(author) {
      this.isEditing = true;
      this.authorForm = { ...author };
      this.showAuthorModal = true;
      this.errorMessage = '';
    },
    closeAuthorModal() {
      this.showAuthorModal = false;
      this.authorForm = this.getEmptyAuthorForm();
      this.errorMessage = '';
    },
    saveAuthor() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.authorForm.first_name || !this.authorForm.last_name) {
        this.errorMessage = 'First name and last name are required';
        return;
      }

      if (this.isEditing) {
        const index = this.authors.findIndex(a => a.author_id === this.authorForm.author_id);
        if (index !== -1) {
          this.authors[index] = { ...this.authorForm };
          this.successMessage = 'Author updated successfully!';
        }
      } else {
        const newAuthor = {
          ...this.authorForm,
          author_id: this.nextAuthorId
        };
        this.authors.push(newAuthor);
        this.successMessage = 'Author added successfully!';
      }

      this.saveAuthors();
      this.closeAuthorModal();
      setTimeout(() => { this.successMessage = ''; }, 3000);
    },
    deleteAuthor(authorId) {
      if (confirm('Are you sure you want to delete this author?')) {
        this.authors = this.authors.filter(a => a.author_id !== authorId);
        this.saveAuthors();
        this.successMessage = 'Author deleted successfully!';
        setTimeout(() => { this.successMessage = ''; }, 3000);
      }
    },

    // Publisher Actions
    openAddPublisherModal() {
      this.isEditing = false;
      this.publisherForm = this.getEmptyPublisherForm();
      this.showPublisherModal = true;
      this.errorMessage = '';
    },
    openEditPublisherModal(publisher) {
      this.isEditing = true;
      this.publisherForm = { ...publisher };
      this.showPublisherModal = true;
      this.errorMessage = '';
    },
    closePublisherModal() {
      this.showPublisherModal = false;
      this.publisherForm = this.getEmptyPublisherForm();
      this.errorMessage = '';
    },
    savePublisher() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.publisherForm.name) {
        this.errorMessage = 'Publisher name is required';
        return;
      }

      if (this.isEditing) {
        const index = this.publishers.findIndex(p => p.publisher_id === this.publisherForm.publisher_id);
        if (index !== -1) {
          this.publishers[index] = { ...this.publisherForm };
          this.successMessage = 'Publisher updated successfully!';
        }
      } else {
        const newPublisher = {
          ...this.publisherForm,
          publisher_id: this.nextPublisherId
        };
        this.publishers.push(newPublisher);
        this.successMessage = 'Publisher added successfully!';
      }

      this.savePublishers();
      this.closePublisherModal();
      setTimeout(() => { this.successMessage = ''; }, 3000);
    },
    deletePublisher(publisherId) {
      if (confirm('Are you sure you want to delete this publisher?')) {
        this.publishers = this.publishers.filter(p => p.publisher_id !== publisherId);
        this.savePublishers();
        this.successMessage = 'Publisher deleted successfully!';
        setTimeout(() => { this.successMessage = ''; }, 3000);
      }
    },

    getAuthorName(authorId) {
      const author = this.authors.find(a => a.author_id === authorId);
      return author ? `${author.first_name} ${author.last_name}` : 'Unknown';
    },
    getPublisherName(publisherId) {
      const publisher = this.publishers.find(p => p.publisher_id === publisherId);
      return publisher ? publisher.name : 'Unknown';
    },

    handleLogout() {
      localStorage.removeItem('currentUser');
      this.$router.push('/profile');
    }
  }
}
</script>

<template>
  <div class="admin-page" v-if="isAdmin">
    <header class="header">
      <div class="header-content">
        <img class="logo" :src="logo" alt="Library Logo" />
        <div class="search-bar">
          <input type="text" placeholder="Search in admin panel..." v-model="searchQuery" />
          <button class="search-button"><i class="fas fa-search"></i></button>
        </div>

        <div class="header-links">
          <router-link to="/" class="admin-link">
            <i class="fas fa-home"></i>
            <p>Home</p>
          </router-link>
          <div class="admin-user">
            <i class="fas fa-user-shield"></i>
            <p>{{ currentUser.username }}</p>
          </div>
        </div>
      </div>
    </header>

    <div class="admin-container">
      <div class="admin-sidebar">
        <h2><i class="fas fa-cog"></i> Admin Panel</h2>
        <nav class="sidebar-nav">
          <button
            :class="{ active: activeTab === 'books' }"
            @click="activeTab = 'books'">
            <i class="fas fa-book"></i> Manage Books
          </button>
          <button
            :class="{ active: activeTab === 'authors' }"
            @click="activeTab = 'authors'">
            <i class="fas fa-pen-fancy"></i> Manage Authors
          </button>
          <button
            :class="{ active: activeTab === 'publishers' }"
            @click="activeTab = 'publishers'">
            <i class="fas fa-building"></i> Manage Publishers
          </button>
          <button class="logout-btn" @click="handleLogout">
            <i class="fas fa-sign-out-alt"></i> Logout
          </button>
        </nav>
      </div>

      <div class="admin-content">
        <!-- Messages -->
        <div v-if="errorMessage" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <p>{{ errorMessage }}</p>
        </div>

        <div v-if="successMessage" class="success-message">
          <i class="fas fa-check-circle"></i>
          <p>{{ successMessage }}</p>
        </div>

        <!-- Books Tab -->
        <div v-if="activeTab === 'books'" class="tab-content">
          <div class="content-header">
            <h2><i class="fas fa-book"></i> Books Management</h2>
            <button class="add-button" @click="openAddBookModal">
              <i class="fas fa-plus"></i> Add New Book
            </button>
          </div>

          <div class="stats-cards">
            <div class="stat-card">
              <i class="fas fa-book"></i>
              <div>
                <h3>{{ books.length }}</h3>
                <p>Total Books</p>
              </div>
            </div>
            <div class="stat-card">
              <i class="fas fa-search"></i>
              <div>
                <h3>{{ filteredBooks.length }}</h3>
                <p>Filtered Results</p>
              </div>
            </div>
          </div>

          <div class="data-table">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Title</th>
                  <th>Author</th>
                  <th>ISBN</th>
                  <th>Publisher</th>
                  <th>Pages</th>
                  <th>Publication Date</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="book in filteredBooks" :key="book.book_id">
                  <td>{{ book.book_id }}</td>
                  <td class="book-title">{{ book.title }}</td>
                  <td>{{ getAuthorName(book.author_id) }}</td>
                  <td>{{ book.isbn13 }}</td>
                  <td>{{ getPublisherName(book.publisher_id) }}</td>
                  <td>{{ book.page_count }}</td>
                  <td>{{ new Date(book.publication_date).toLocaleDateString() }}</td>
                  <td class="actions">
                    <button class="edit-btn" @click="openEditBookModal(book)">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="delete-btn" @click="deleteBook(book.book_id)">
                      <i class="fas fa-trash"></i>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Authors Tab -->
        <div v-if="activeTab === 'authors'" class="tab-content">
          <div class="content-header">
            <h2><i class="fas fa-pen-fancy"></i> Authors Management</h2>
            <button class="add-button" @click="openAddAuthorModal">
              <i class="fas fa-plus"></i> Add New Author
            </button>
          </div>

          <div class="stats-cards">
            <div class="stat-card">
              <i class="fas fa-pen-fancy"></i>
              <div>
                <h3>{{ authors.length }}</h3>
                <p>Total Authors</p>
              </div>
            </div>
          </div>

          <div class="data-table">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Nationality</th>
                  <th>Birth Date</th>
                  <th>Website</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="author in authors" :key="author.author_id">
                  <td>{{ author.author_id }}</td>
                  <td class="author-name">{{ author.first_name }} {{ author.last_name }}</td>
                  <td>{{ author.nationality }}</td>
                  <td>{{ author.birth_date ? new Date(author.birth_date).toLocaleDateString() : 'N/A' }}</td>
                  <td>
                    <a v-if="author.website" :href="author.website" target="_blank" class="website-link">
                      <i class="fas fa-external-link-alt"></i>
                    </a>
                    <span v-else>-</span>
                  </td>
                  <td class="actions">
                    <button class="edit-btn" @click="openEditAuthorModal(author)">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="delete-btn" @click="deleteAuthor(author.author_id)">
                      <i class="fas fa-trash"></i>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Publishers Tab -->
        <div v-if="activeTab === 'publishers'" class="tab-content">
          <div class="content-header">
            <h2><i class="fas fa-building"></i> Publishers Management</h2>
            <button class="add-button" @click="openAddPublisherModal">
              <i class="fas fa-plus"></i> Add New Publisher
            </button>
          </div>

          <div class="stats-cards">
            <div class="stat-card">
              <i class="fas fa-building"></i>
              <div>
                <h3>{{ publishers.length }}</h3>
                <p>Total Publishers</p>
              </div>
            </div>
          </div>

          <div class="data-table">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Country</th>
                  <th>City</th>
                  <th>Founded</th>
                  <th>Contact</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="publisher in publishers" :key="publisher.publisher_id">
                  <td>{{ publisher.publisher_id }}</td>
                  <td class="publisher-name">{{ publisher.name }}</td>
                  <td>{{ publisher.country }}</td>
                  <td>{{ publisher.headquarters_city }}</td>
                  <td>{{ publisher.founded_year }}</td>
                  <td>{{ publisher.contact_email || '-' }}</td>
                  <td class="actions">
                    <button class="edit-btn" @click="openEditPublisherModal(publisher)">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="delete-btn" @click="deletePublisher(publisher.publisher_id)">
                      <i class="fas fa-trash"></i>
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <!-- Book Modal -->
    <div class="modal-overlay" v-if="showBookModal" @click="closeBookModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ isEditing ? 'Edit Book' : 'Add New Book' }}</h3>
          <button class="close-modal" @click="closeBookModal">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <div v-if="errorMessage" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <p>{{ errorMessage }}</p>
        </div>

        <form @submit.prevent="saveBook" class="modal-form">
          <div class="form-row">
            <div class="form-group">
              <label>Title *</label>
              <input type="text" v-model="bookForm.title" required />
            </div>
            <div class="form-group">
              <label>ISBN13 *</label>
              <input type="text" v-model="bookForm.isbn13" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Author</label>
              <select v-model="bookForm.author_id">
                <option :value="null">Select Author</option>
                <option v-for="author in authors" :key="author.author_id" :value="author.author_id">
                  {{ author.first_name }} {{ author.last_name }}
                </option>
              </select>
            </div>
            <div class="form-group">
              <label>Publisher</label>
              <select v-model="bookForm.publisher_id">
                <option :value="null">Select Publisher</option>
                <option v-for="publisher in publishers" :key="publisher.publisher_id" :value="publisher.publisher_id">
                  {{ publisher.name }}
                </option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label>Subtitle</label>
            <input type="text" v-model="bookForm.subtitle" />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Publication Date</label>
              <input type="date" v-model="bookForm.publication_date" />
            </div>
            <div class="form-group">
              <label>Language</label>
              <input type="text" v-model="bookForm.language" />
            </div>
            <div class="form-group">
              <label>Page Count</label>
              <input type="number" v-model="bookForm.page_count" />
            </div>
          </div>

          <div class="form-group">
            <label>Description</label>
            <textarea v-model="bookForm.description" rows="4"></textarea>
          </div>

          <div class="modal-actions">
            <button type="submit" class="save-btn">
              <i class="fas fa-save"></i> {{ isEditing ? 'Update' : 'Create' }}
            </button>
            <button type="button" @click="closeBookModal" class="cancel-btn">
              <i class="fas fa-times"></i> Cancel
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Author Modal -->
    <div class="modal-overlay" v-if="showAuthorModal" @click="closeAuthorModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ isEditing ? 'Edit Author' : 'Add New Author' }}</h3>
          <button class="close-modal" @click="closeAuthorModal">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <div v-if="errorMessage" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <p>{{ errorMessage }}</p>
        </div>

        <form @submit.prevent="saveAuthor" class="modal-form">
          <div class="form-row">
            <div class="form-group">
              <label>First Name *</label>
              <input type="text" v-model="authorForm.first_name" required />
            </div>
            <div class="form-group">
              <label>Last Name *</label>
              <input type="text" v-model="authorForm.last_name" required />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Nationality</label>
              <input type="text" v-model="authorForm.nationality" />
            </div>
            <div class="form-group">
              <label>Birth Date</label>
              <input type="date" v-model="authorForm.birth_date" />
            </div>
            <div class="form-group">
              <label>Death Date</label>
              <input type="date" v-model="authorForm.death_date" />
            </div>
          </div>

          <div class="form-group">
            <label>Biography</label>
            <textarea v-model="authorForm.bio" rows="3"></textarea>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Website</label>
              <input type="url" v-model="authorForm.website" />
            </div>
            <div class="form-group">
              <label>Portrait URL</label>
              <input type="url" v-model="authorForm.portrait_url" />
            </div>
          </div>

          <div class="modal-actions">
            <button type="submit" class="save-btn">
              <i class="fas fa-save"></i> {{ isEditing ? 'Update' : 'Create' }}
            </button>
            <button type="button" @click="closeAuthorModal" class="cancel-btn">
              <i class="fas fa-times"></i> Cancel
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Publisher Modal -->
    <div class="modal-overlay" v-if="showPublisherModal" @click="closePublisherModal">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>{{ isEditing ? 'Edit Publisher' : 'Add New Publisher' }}</h3>
          <button class="close-modal" @click="closePublisherModal">
            <i class="fas fa-times"></i>
          </button>
        </div>

        <div v-if="errorMessage" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <p>{{ errorMessage }}</p>
        </div>

        <form @submit.prevent="savePublisher" class="modal-form">
          <div class="form-group">
            <label>Name *</label>
            <input type="text" v-model="publisherForm.name" required />
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Country</label>
              <input type="text" v-model="publisherForm.country" />
            </div>
            <div class="form-group">
              <label>City</label>
              <input type="text" v-model="publisherForm.headquarters_city" />
            </div>
            <div class="form-group">
              <label>Founded Year</label>
              <input type="number" v-model="publisherForm.founded_year" />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label>Website</label>
              <input type="url" v-model="publisherForm.website" />
            </div>
            <div class="form-group">
              <label>Email</label>
              <input type="email" v-model="publisherForm.contact_email" />
            </div>
            <div class="form-group">
              <label>Phone</label>
              <input type="tel" v-model="publisherForm.phone" />
            </div>
          </div>

          <div class="modal-actions">
            <button type="submit" class="save-btn">
              <i class="fas fa-save"></i> {{ isEditing ? 'Update' : 'Create' }}
            </button>
            <button type="button" @click="closePublisherModal" class="cancel-btn">
              <i class="fas fa-times"></i> Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Access Denied -->
  <div v-else class="access-denied">
    <i class="fas fa-lock"></i>
    <h2>Access Denied</h2>
    <p>You need administrator privileges to access this page.</p>
    <router-link to="/" class="home-btn">Go to Home</router-link>
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

.admin-page {
  min-height: 100vh;
  background-color: #f8f9fa;
}

.header {
  background: #016B61;
  padding: 0.5rem 2rem;
  color: white;
  font-family: 'Tan Mon Cheri', sans-serif;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  padding: 0.5rem;
}

.logo {
  width: 80px;
  height: 80px;
}

.search-bar {
  display: flex;
  flex: 1;
  max-width: 500px;
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

.header-links {
  display: flex;
  gap: 2rem;
  align-items: center;
}

.admin-link, .admin-user {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.3rem;
  color: white;
  text-decoration: none;
  cursor: pointer;
}

.admin-link i, .admin-user i {
  font-size: 1.5rem;
}

.admin-link p, .admin-user p {
  margin: 0;
  font-size: 0.9rem;
}

.admin-container {
  display: flex;
  min-height: calc(100vh - 120px);
}

.admin-sidebar {
  width: 280px;
  background: white;
  padding: 2rem 1rem;
  box-shadow: 2px 0 4px rgba(0,0,0,0.1);
}

.admin-sidebar h2 {
  color: #016B61;
  margin-bottom: 2rem;
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.sidebar-nav button {
  padding: 1rem;
  border: none;
  background: transparent;
  text-align: left;
  cursor: pointer;
  border-radius: 8px;
  transition: all 0.3s ease;
  font-size: 1rem;
  color: #666;
  display: flex;
  align-items: center;
  gap: 0.8rem;
}

.sidebar-nav button:hover {
  background: rgba(1, 107, 97, 0.1);
  color: #016B61;
}

.sidebar-nav button.active {
  background: #016B61;
  color: white;
}

.sidebar-nav button i {
  font-size: 1.2rem;
}

.logout-btn {
  background: #e74c3c !important;
  color: white !important;
  margin-top: 2rem;
}

.logout-btn:hover {
  background: #c0392b !important;
}

.admin-content {
  flex: 1;
  padding: 2rem;
}

.content-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.content-header h2 {
  color: #2c3e50;
  font-size: 1.8rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.add-button {
  padding: 0.8rem 1.5rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.add-button:hover {
  background: #015550;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(1, 107, 97, 0.3);
}

.stats-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: white;
  padding: 1.5rem;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  display: flex;
  align-items: center;
  gap: 1rem;
}

.stat-card i {
  font-size: 2.5rem;
  color: #016B61;
}

.stat-card h3 {
  font-size: 2rem;
  margin: 0;
  color: #2c3e50;
}

.stat-card p {
  margin: 0;
  color: #666;
  font-size: 0.9rem;
}

.data-table {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background: #f8f9fa;
}

th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: #2c3e50;
  border-bottom: 2px solid #e0e0e0;
}

td {
  padding: 1rem;
  border-bottom: 1px solid #f0f0f0;
  color: #666;
}

tbody tr:hover {
  background: rgba(1, 107, 97, 0.05);
}

.book-title, .author-name, .publisher-name {
  font-weight: 500;
  color: #2c3e50;
}

.website-link {
  color: #016B61;
  transition: color 0.3s ease;
}

.website-link:hover {
  color: #015550;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.edit-btn, .delete-btn {
  padding: 0.5rem 0.8rem;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.edit-btn {
  background: #3498db;
  color: white;
}

.edit-btn:hover {
  background: #2980b9;
}

.delete-btn {
  background: #e74c3c;
  color: white;
}

.delete-btn:hover {
  background: #c0392b;
}

.error-message,
.success-message {
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
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

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.3s ease;
}

.modal-content {
  background: white;
  border-radius: 12px;
  width: 90%;
  max-width: 700px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 10px 40px rgba(0,0,0,0.2);
}

.modal-header {
  padding: 1.5rem 2rem;
  border-bottom: 2px solid #f0f0f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #f8f9fa;
}

.modal-header h3 {
  margin: 0;
  color: #2c3e50;
  font-size: 1.5rem;
}

.close-modal {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #666;
  transition: color 0.3s ease;
}

.close-modal:hover {
  color: #e74c3c;
}

.modal-form {
  padding: 2rem;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  margin-bottom: 1rem;
}

.form-group label {
  margin-bottom: 0.5rem;
  color: #2c3e50;
  font-weight: 500;
  font-size: 0.95rem;
}

.form-group input,
.form-group select,
.form-group textarea {
  padding: 0.8rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 1rem;
  font-family: inherit;
  transition: all 0.3s ease;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #016B61;
  box-shadow: 0 0 0 3px rgba(1, 107, 97, 0.1);
}

.form-group textarea {
  resize: vertical;
}

.modal-actions {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 1rem;
  border-top: 2px solid #f0f0f0;
}

.save-btn {
  flex: 1;
  padding: 0.9rem;
  background: #016B61;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.save-btn:hover {
  background: #015550;
}

.cancel-btn {
  flex: 1;
  padding: 0.9rem;
  background: #6c757d;
  color: white;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
}

.cancel-btn:hover {
  background: #5a6268;
}

/* Access Denied */
.access-denied {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  text-align: center;
  background: #f8f9fa;
}

.access-denied i {
  font-size: 5rem;
  color: #e74c3c;
  margin-bottom: 2rem;
}

.access-denied h2 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 1rem;
}

.access-denied p {
  font-size: 1.2rem;
  color: #666;
  margin-bottom: 2rem;
}

.home-btn {
  padding: 1rem 2rem;
  background: #016B61;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.home-btn:hover {
  background: #015550;
  transform: translateY(-2px);
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@media (max-width: 968px) {
  .admin-container {
    flex-direction: column;
  }

  .admin-sidebar {
    width: 100%;
  }

  .sidebar-nav {
    flex-direction: row;
    flex-wrap: wrap;
  }
}
</style>

