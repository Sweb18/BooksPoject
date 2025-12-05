<script>
const API_URL = 'http://localhost:3000/api';

export default {
  data() {
    return {
      logo: require('../assets/img/icons/logo.png'),
      shop: require('../assets/img/icons/store.png'),
      basket: require('../assets/img/icons/basket.png'),
      searchQuery: '',
      currentUser: null,
      activeTab: 'books',
      books: [],
      authors: [],
      publishers: [],
      genres: [],
      showBookModal: false,
      showAuthorModal: false,
      showPublisherModal: false,
      isEditing: false,
      bookForm: this.getEmptyBookForm(),
      authorForm: this.getEmptyAuthorForm(),
      publisherForm: this.getEmptyPublisherForm(),
      errorMessage: '',
      successMessage: '',
      isLoading: false,
      usingAPI: false
    }
  },
  computed: {
    isAdmin() {
      return this.currentUser && this.currentUser.role === 'ADMIN';
    },
    filteredBooks() {
      if (!this.searchQuery) return this.books;
      const query = this.searchQuery.toLowerCase();
      return this.books.filter(book =>
        book.title.toLowerCase().includes(query) ||
        (book.author_name && book.author_name.toLowerCase().includes(query)) ||
        (book.author && book.author.toLowerCase().includes(query)) ||
        book.isbn13.includes(query)
      );
    }
  },
  async mounted() {
    // Vérifier l'authentification via l'API
    const savedUser = localStorage.getItem('currentUser');
    if (!savedUser) {
      this.$router.push('/login');
      return;
    }

    try {
      // Vérifier que la session est toujours valide et que l'utilisateur est ADMIN
      const response = await fetch(`${API_URL}/auth/me`, {
        credentials: 'include'
      });

      if (!response.ok) {
        localStorage.removeItem('currentUser');
        this.$router.push('/login');
        return;
      }

      const userData = await response.json();

      if (userData.role !== 'ADMIN') {
        this.$router.push('/');
        return;
      }

      this.currentUser = userData;
      localStorage.setItem('currentUser', JSON.stringify(userData));
      await this.loadAllData();
    } catch (error) {
      console.error('Error verifying session:', error);
      this.$router.push('/login');
    }
  },
  methods: {
    async loadAllData() {
      this.isLoading = true;
      this.errorMessage = '';
      try {
        await Promise.all([
          this.loadBooks(),
          this.loadAuthors(),
          this.loadPublishers(),
          this.loadGenres()
        ]);

        if (this.usingAPI) {
          console.log('✓ All data loaded from API successfully');
          console.log(`Books: ${this.books.length}, Authors: ${this.authors.length}, Publishers: ${this.publishers.length}, Genres: ${this.genres.length}`);
        }
      } catch (error) {
        console.error('✗ Error loading data from API:', error);
        this.errorMessage = 'Cannot connect to API server. Please ensure:\n1. The server is running (npm start in webapp_serverside)\n2. MySQL is running\n3. Database is configured in .env';
        this.usingAPI = false;
      } finally {
        this.isLoading = false;
      }
    },

    async loadBooks() {
      const response = await fetch(`${API_URL}/books`, {
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' }
      });
      if (!response.ok) throw new Error(`Failed to load books: ${response.status}`);
      this.books = await response.json();
      this.usingAPI = true;
    },

    async loadAuthors() {
      const response = await fetch(`${API_URL}/authors`, {
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' }
      });
      if (!response.ok) throw new Error(`Failed to load authors: ${response.status}`);
      this.authors = await response.json();
    },

    async loadPublishers() {
      const response = await fetch(`${API_URL}/publishers`, {
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' }
      });
      if (!response.ok) throw new Error(`Failed to load publishers: ${response.status}`);
      this.publishers = await response.json();
    },

    async loadGenres() {
      const response = await fetch(`${API_URL}/genres`, {
        credentials: 'include',
        headers: { 'Content-Type': 'application/json' }
      });
      if (!response.ok) throw new Error(`Failed to load genres: ${response.status}`);
      this.genres = await response.json();
    },

    getEmptyBookForm() {
      return {
        book_id: null,
        title: '',
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

    openAddBookModal() {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot add books.';
        return;
      }
      this.isEditing = false;
      this.bookForm = this.getEmptyBookForm();
      this.showBookModal = true;
      this.errorMessage = '';
    },

    openEditBookModal(book) {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot edit books.';
        return;
      }
      this.isEditing = true;

      // Copier seulement les champs nécessaires et s'assurer du bon type
      this.bookForm = {
        book_id: book.book_id,
        title: book.title || '',
        subtitle: book.subtitle || '',
        isbn13: book.isbn13 || '',
        author_id: book.author_id || null,
        publisher_id: book.publisher_id || null,
        publication_date: book.publication_date ? book.publication_date.split('T')[0] : '',
        language: book.language || 'en',
        page_count: book.page_count || 0,
        description: book.description || ''
      };

      this.showBookModal = true;
      this.errorMessage = '';
    },

    closeBookModal() {
      this.showBookModal = false;
      this.bookForm = this.getEmptyBookForm();
      this.errorMessage = '';
    },

    async saveBook() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.bookForm.title || !this.bookForm.isbn13) {
        this.errorMessage = 'Title and ISBN are required';
        return;
      }

      try {
        const url = this.isEditing
          ? `${API_URL}/books/${this.bookForm.book_id}`
          : `${API_URL}/books`;

        const method = this.isEditing ? 'PUT' : 'POST';

        console.log('Saving book:', method, url);
        console.log('Book form data:', this.bookForm);

        const response = await fetch(url, {
          method: method,
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
          body: JSON.stringify(this.bookForm)
        });

        console.log('Response status:', response.status);

        if (!response.ok) {
          const error = await response.json();
          console.error('Server error:', error);
          throw new Error(error.error || 'Failed to save book');
        }

        const result = await response.json();
        console.log('Server response:', result);

        this.successMessage = this.isEditing ? 'Book updated successfully!' : 'Book added successfully!';
        await this.loadBooks();
        this.closeBookModal();
        setTimeout(() => { this.successMessage = ''; }, 10000);
      } catch (error) {
        console.error('Error saving book:', error);
        this.errorMessage = error.message;
      }
    },

    async deleteBook(bookId) {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot delete books.';
        return;
      }

      if (!confirm('Are you sure you want to delete this book?')) return;

      try {
        const response = await fetch(`${API_URL}/books/${bookId}`, {
          method: 'DELETE',
          credentials: 'include'
        });

        if (!response.ok) {
          const error = await response.json();
          throw new Error(error.error || 'Failed to delete book');
        }

        this.successMessage = 'Book deleted successfully!';
        await this.loadBooks();
        setTimeout(() => { this.successMessage = ''; }, 3000);
      } catch (error) {
        this.errorMessage = error.message;
      }
    },

    openAddAuthorModal() {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot add authors.';
        return;
      }
      this.isEditing = false;
      this.authorForm = this.getEmptyAuthorForm();
      this.showAuthorModal = true;
      this.errorMessage = '';
    },

    openEditAuthorModal(author) {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot edit authors.';
        return;
      }
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

    async saveAuthor() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.authorForm.first_name || !this.authorForm.last_name) {
        this.errorMessage = 'First name and last name are required';
        return;
      }

      try {
        const url = this.isEditing
          ? `${API_URL}/authors/${this.authorForm.author_id}`
          : `${API_URL}/authors`;

        const method = this.isEditing ? 'PUT' : 'POST';

        const response = await fetch(url, {
          method: method,
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
          body: JSON.stringify(this.authorForm)
        });

        if (!response.ok) {
          const error = await response.json();
          throw new Error(error.error || 'Failed to save author');
        }

        this.successMessage = this.isEditing ? 'Author updated successfully!' : 'Author added successfully!';
        await this.loadAuthors();
        this.closeAuthorModal();
        setTimeout(() => { this.successMessage = ''; }, 10000);
      } catch (error) {
        this.errorMessage = error.message;
      }
    },

    async deleteAuthor(authorId) {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot delete authors.';
        return;
      }

      if (!confirm('Are you sure you want to delete this author?')) return;

      try {
        const response = await fetch(`${API_URL}/authors/${authorId}`, {
          method: 'DELETE',
          credentials: 'include'
        });

        if (!response.ok) {
          const error = await response.json();
          throw new Error(error.error || 'Failed to delete author');
        }

        this.successMessage = 'Author deleted successfully!';
        await this.loadAuthors();
        setTimeout(() => { this.successMessage = ''; }, 3000);
      } catch (error) {
        this.errorMessage = error.message;
      }
    },

    openAddPublisherModal() {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot add publishers.';
        return;
      }
      this.isEditing = false;
      this.publisherForm = this.getEmptyPublisherForm();
      this.showPublisherModal = true;
      this.errorMessage = '';
    },

    openEditPublisherModal(publisher) {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot edit publishers.';
        return;
      }
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

    async savePublisher() {
      this.errorMessage = '';
      this.successMessage = '';

      if (!this.publisherForm.name) {
        this.errorMessage = 'Publisher name is required';
        return;
      }

      try {
        const url = this.isEditing
          ? `${API_URL}/publishers/${this.publisherForm.publisher_id}`
          : `${API_URL}/publishers`;

        const method = this.isEditing ? 'PUT' : 'POST';

        const response = await fetch(url, {
          method: method,
          headers: { 'Content-Type': 'application/json' },
          credentials: 'include',
          body: JSON.stringify(this.publisherForm)
        });

        if (!response.ok) {
          const error = await response.json();
          throw new Error(error.error || 'Failed to save publisher');
        }

        this.successMessage = this.isEditing ? 'Publisher updated successfully!' : 'Publisher added successfully!';
        await this.loadPublishers();
        this.closePublisherModal();
        setTimeout(() => { this.successMessage = ''; }, 10000);
      } catch (error) {
        this.errorMessage = error.message;
      }
    },

    async deletePublisher(publisherId) {
      if (!this.usingAPI) {
        this.errorMessage = 'API not connected. Cannot delete publishers.';
        return;
      }

      if (!confirm('Are you sure you want to delete this publisher?')) return;

      try {
        const response = await fetch(`${API_URL}/publishers/${publisherId}`, {
          method: 'DELETE',
          credentials: 'include'
        });

        if (!response.ok) {
          const error = await response.json();
          throw new Error(error.error || 'Failed to delete publisher');
        }

        this.successMessage = 'Publisher deleted successfully!';
        await this.loadPublishers();
        setTimeout(() => { this.successMessage = ''; }, 3000);
      } catch (error) {
        this.errorMessage = error.message;
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
            <p>{{ currentUser ? currentUser.username : 'Admin' }}</p>
          </div>
        </div>
      </div>
    </header>

    <div class="admin-container">
      <div class="admin-sidebar">
        <h2><i class="fas fa-cog"></i> Admin Panel</h2>
        <div v-if="!usingAPI" class="api-status warning">
          <i class="fas fa-exclamation-triangle"></i>
          <p>API Disconnected</p>
        </div>
        <div v-else class="api-status success">
          <i class="fas fa-check-circle"></i>
          <p>API Connected</p>
        </div>
        <nav class="sidebar-nav">
          <button :class="{ active: activeTab === 'books' }" @click="activeTab = 'books'">
            <i class="fas fa-book"></i> Manage Books
          </button>
          <button :class="{ active: activeTab === 'authors' }" @click="activeTab = 'authors'">
            <i class="fas fa-pen-fancy"></i> Manage Authors
          </button>
          <button :class="{ active: activeTab === 'publishers' }" @click="activeTab = 'publishers'">
            <i class="fas fa-building"></i> Manage Publishers
          </button>
          <button class="logout-btn" @click="handleLogout">
            <i class="fas fa-sign-out-alt"></i> Logout
          </button>
        </nav>
      </div>

      <div class="admin-content">
        <div v-if="isLoading" class="loading-indicator">
          <i class="fas fa-spinner fa-spin"></i>
          <p>Loading data from server...</p>
        </div>

        <div v-if="errorMessage" class="error-message">
          <i class="fas fa-exclamation-circle"></i>
          <div>
            <p style="white-space: pre-line;">{{ errorMessage }}</p>
          </div>
        </div>

        <div v-if="successMessage" class="success-message">
          <i class="fas fa-check-circle"></i>
          <p>{{ successMessage }}</p>
        </div>

        <!-- Books Tab -->
        <div v-if="activeTab === 'books'" class="tab-content">
          <div class="content-header">
            <h2><i class="fas fa-book"></i> Books Management</h2>
            <button class="add-button" @click="openAddBookModal" :disabled="!usingAPI">
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
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="book in filteredBooks" :key="book.book_id">
                  <td>{{ book.book_id }}</td>
                  <td class="book-title">{{ book.title }}</td>
                  <td>{{ book.author_name || book.author || getAuthorName(book.author_id) }}</td>
                  <td>{{ book.isbn13 }}</td>
                  <td>{{ book.publisher_name || getPublisherName(book.publisher_id) }}</td>
                  <td>{{ book.page_count }}</td>
                  <td class="actions">
                    <button class="edit-btn" @click="openEditBookModal(book)" title="Edit" :disabled="!usingAPI">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="delete-btn" @click="deleteBook(book.book_id)" title="Delete" :disabled="!usingAPI">
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
            <button class="add-button" @click="openAddAuthorModal" :disabled="!usingAPI">
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
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="author in authors" :key="author.author_id">
                  <td>{{ author.author_id }}</td>
                  <td class="author-name">{{ author.first_name }} {{ author.last_name }}</td>
                  <td>{{ author.nationality || 'N/A' }}</td>
                  <td>{{ author.birth_date ? new Date(author.birth_date).toLocaleDateString() : 'N/A' }}</td>
                  <td class="actions">
                    <button class="edit-btn" @click="openEditAuthorModal(author)" title="Edit" :disabled="!usingAPI">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="delete-btn" @click="deleteAuthor(author.author_id)" title="Delete" :disabled="!usingAPI">
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
            <button class="add-button" @click="openAddPublisherModal" :disabled="!usingAPI">
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
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="publisher in publishers" :key="publisher.publisher_id">
                  <td>{{ publisher.publisher_id }}</td>
                  <td class="publisher-name">{{ publisher.name }}</td>
                  <td>{{ publisher.country || 'N/A' }}</td>
                  <td>{{ publisher.headquarters_city || 'N/A' }}</td>
                  <td>{{ publisher.founded_year || 'N/A' }}</td>
                  <td class="actions">
                    <button class="edit-btn" @click="openEditPublisherModal(publisher)" title="Edit" :disabled="!usingAPI">
                      <i class="fas fa-edit"></i>
                    </button>
                    <button class="delete-btn" @click="deletePublisher(publisher.publisher_id)" title="Delete" :disabled="!usingAPI">
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
              <select v-model.number="bookForm.author_id">
                <option :value="null">Select Author</option>
                <option v-for="author in authors" :key="author.author_id" :value="author.author_id">
                  {{ author.first_name }} {{ author.last_name }}
                </option>
              </select>
            </div>
            <div class="form-group">
              <label>Publisher</label>
              <select v-model.number="bookForm.publisher_id">
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
              <input type="number" v-model.number="bookForm.page_count" />
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
          </div>

          <div class="form-group">
            <label>Biography</label>
            <textarea v-model="authorForm.bio" rows="3"></textarea>
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
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
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
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
  padding: 0.5rem;
  max-width: 1400px;
  margin: 0 auto;
}

.logo {
  width: 80px;
  height: 80px;
  object-fit: contain;
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
  outline: none;
}

.search-button {
  padding: 0 1.5rem;
  background: #e74c3c;
  border: none;
  border-radius: 0 4px 4px 0;
  color: white;
  cursor: pointer;
  transition: background 0.3s;
}

.search-button:hover {
  background: #c0392b;
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
  transition: opacity 0.3s;
}

.admin-link:hover {
  opacity: 0.8;
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
  max-width: 1400px;
  margin: 0 auto;
}

.admin-sidebar {
  width: 280px;
  background: white;
  padding: 2rem 1rem;
  box-shadow: 2px 0 4px rgba(0,0,0,0.1);
}

.admin-sidebar h2 {
  color: #016B61;
  margin-bottom: 1rem;
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.api-status {
  padding: 0.5rem;
  border-radius: 6px;
  margin-bottom: 1rem;
  font-size: 0.85rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
}

.api-status.success {
  background: #d4edda;
  color: #155724;
}

.api-status.warning {
  background: #fff3cd;
  color: #856404;
}

.sidebar-nav {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.sidebar-nav button {
  padding: 1rem;
  border: none;
  background: #f8f9fa;
  text-align: left;
  cursor: pointer;
  border-radius: 8px;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.3s;
}

.sidebar-nav button:hover {
  background: #e9ecef;
  transform: translateX(5px);
}

.sidebar-nav button.active {
  background: #016B61;
  color: white;
}

.sidebar-nav button i {
  width: 20px;
}

.logout-btn {
  margin-top: auto;
  background: #e74c3c !important;
  color: white !important;
}

.logout-btn:hover {
  background: #c0392b !important;
}

.admin-content {
  flex: 1;
  padding: 2rem;
  overflow-x: auto;
}

.loading-indicator {
  text-align: center;
  padding: 3rem;
  color: #016B61;
}

.loading-indicator i {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.error-message, .success-message {
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 1.5rem;
  display: flex;
  align-items: flex-start;
  gap: 0.5rem;
  animation: slideIn 0.3s;
}

.error-message {
  background: #fee;
  color: #c00;
  border: 1px solid #fcc;
}

.success-message {
  background: #efe;
  color: #060;
  border: 1px solid #cfc;
}

@keyframes slideIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.tab-content {
  animation: fadeIn 0.3s;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.content-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.content-header h2 {
  color: #016B61;
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
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  transition: all 0.3s;
}

.add-button:hover:not(:disabled) {
  background: #015550;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.2);
}

.add-button:disabled {
  background: #ccc;
  cursor: not-allowed;
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
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  display: flex;
  align-items: center;
  gap: 1rem;
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.stat-card i {
  font-size: 2.5rem;
  color: #016B61;
}

.stat-card h3 {
  font-size: 2rem;
  color: #333;
  margin: 0;
}

.stat-card p {
  color: #666;
  margin: 0;
}

.data-table {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  overflow: hidden;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background: #016B61;
  color: white;
}

th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  white-space: nowrap;
}

td {
  padding: 1rem;
  border-bottom: 1px solid #eee;
}

tbody tr:hover {
  background: #f8f9fa;
}

.book-title, .author-name, .publisher-name {
  font-weight: 600;
  color: #016B61;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.edit-btn, .delete-btn {
  padding: 0.5rem;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s;
  width: 35px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.edit-btn {
  background: #3498db;
  color: white;
}

.edit-btn:hover:not(:disabled) {
  background: #2980b9;
  transform: scale(1.1);
}

.delete-btn {
  background: #e74c3c;
  color: white;
}

.delete-btn:hover:not(:disabled) {
  background: #c0392b;
  transform: scale(1.1);
}

.edit-btn:disabled, .delete-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: fadeIn 0.3s;
}

.modal-content {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  max-width: 600px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
  animation: slideUp 0.3s;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(50px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.modal-header h3 {
  color: #016B61;
  margin: 0;
}

.close-modal {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #666;
  width: 35px;
  height: 35px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: all 0.3s;
}

.close-modal:hover {
  background: #f8f9fa;
  color: #333;
}

.modal-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 600;
  color: #333;
  font-size: 0.9rem;
}

.form-group input,
.form-group select,
.form-group textarea {
  padding: 0.8rem;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 1rem;
  font-family: inherit;
  transition: border-color 0.3s;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #016B61;
}

.modal-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1rem;
}

.save-btn, .cancel-btn {
  padding: 0.8rem 1.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 1rem;
  transition: all 0.3s;
}

.save-btn {
  background: #016B61;
  color: white;
}

.save-btn:hover {
  background: #015550;
  transform: translateY(-2px);
}

.cancel-btn {
  background: #e74c3c;
  color: white;
}

.cancel-btn:hover {
  background: #c0392b;
  transform: translateY(-2px);
}

.access-denied {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #016B61, #015550);
  color: white;
  text-align: center;
  padding: 2rem;
}

.access-denied i {
  font-size: 5rem;
  margin-bottom: 1rem;
}

.access-denied h2 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
}

.access-denied p {
  font-size: 1.2rem;
  margin-bottom: 2rem;
}

.home-btn {
  padding: 1rem 2rem;
  background: white;
  color: #016B61;
  text-decoration: none;
  border-radius: 8px;
  font-weight: 600;
  transition: all 0.3s;
}

.home-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.3);
}

@media (max-width: 768px) {
  .admin-container {
    flex-direction: column;
  }

  .admin-sidebar {
    width: 100%;
  }

  .header-content {
    flex-direction: column;
    gap: 1rem;
  }

  .search-bar {
    max-width: 100%;
  }

  .data-table {
    overflow-x: auto;
  }

  table {
    min-width: 800px;
  }
}
</style>

