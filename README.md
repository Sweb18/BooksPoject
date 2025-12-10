# 📚 Library Management System

A full-stack web application for managing a modern online bookstore with user authentication, admin panel, and shopping cart functionality.

## 🌟 Features

### For Customers
- **Browse Books**: View a comprehensive catalog with detailed information
- **Quick View**: Modal window displaying book details, reviews, and author information
- **Shopping Cart**: Add books to cart with quantity management
- **User Authentication**: Secure login and registration system with password encryption (bcrypt)
- **User Profile**: Manage personal information and shipping addresses
- **Genre Filtering**: Browse books by categories (Fiction, Mystery, Horror, Fantasy, etc.)
- **Book Reviews**: Read customer reviews and ratings

### For Administrators
- **Admin Dashboard**: Accessible only to users with admin privileges
- **Book Management**: Add, edit, and delete books with cover image upload
- **Author Management**: View and manage author information
- **Publisher Management**: Track publisher details
- **Genre Management**: Organize books by genres with visual categories
- **User Management**: View registered users and their roles

## 🛠️ Technology Stack

### Frontend (Client-side)
- **Vue.js 3**: Progressive JavaScript framework
- **Vue Router 4**: Official router for Vue.js
- **FontAwesome**: Icon library
- **Custom CSS**: Modern, responsive design with Tan Mon Cheri font

### Backend (Server-side)
- **Node.js**: JavaScript runtime
- **Express.js 5**: Web application framework
- **MySQL**: Relational database
- **Passport.js**: Authentication middleware
- **bcrypt**: Password hashing
- **express-session**: Session management
- **CORS**: Cross-Origin Resource Sharing support

## 📁 Project Structure

```
BooksPoject/
├── webapp_clientside/          # Vue.js frontend
│   ├── public/
│   │   └── index.html
│   ├── src/
│   │   ├── assets/
│   │   │   ├── font/          # Custom fonts
│   │   │   └── img/           # Images (books, categories, icons)
│   │   ├── components/
│   │   │   ├── libraryhome.vue    # Main homepage
│   │   │   ├── Login.vue          # Login/Register page
│   │   │   ├── profile.vue        # User profile
│   │   │   ├── admin.vue          # Admin dashboard
│   │   │   └── contact.vue        # Contact page
│   │   ├── router/
│   │   │   └── index.js           # Route definitions
│   │   ├── App.vue
│   │   └── main.js
│   └── package.json
│
├── webapp_serverside/          # Express.js backend
│   ├── controllers/
│   │   └── library.route.js       # API routes
│   ├── routes/
│   │   └── auth.js                # Authentication routes
│   ├── utils/
│   │   └── db.include.js          # Database configuration
│   ├── library_db.sql             # Database schema
│   ├── server.js                  # Main server file
│   └── package.json
│
└── README.md
```

## 🚀 Installation & Setup

### Prerequisites
- Node.js (v14 or higher)
- MySQL Server (v8.0 or higher)
- npm or yarn package manager

### Database Setup

1. **Create the database**:
   ```bash
   mysql -u root -p
   ```

2. **Import the SQL schema**:
   ```sql
   CREATE DATABASE library_db;
   USE library_db;
   SOURCE webapp_serverside/library_db.sql;
   ```

3. **Configure environment variables**:
   Create a `.env` file in `webapp_serverside/`:
   ```env
   # Server Configuration
   WEB_PORT=3000
   CLIENT_URL=http://localhost:8080
   
   # Database Configuration
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=library_db
   
   # Session Secret
   SESSION_SECRET=your_random_secret_key_here
   ```

### Backend Setup

1. **Navigate to server directory**:
   ```bash
   cd webapp_serverside
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Start the server**:
   ```bash
   npm start
   ```
   Server will run on `http://localhost:3000`

### Frontend Setup

1. **Navigate to client directory**:
   ```bash
   cd webapp_clientside
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Start the development server**:
   ```bash
   npm run serve
   ```
   Application will run on `http://localhost:8080`

## 🗄️ Database Schema

The application uses the following main tables:

- **users**: User accounts with bcrypt-hashed passwords
- **books**: Book catalog with ISBN, pricing, and metadata
- **authors**: Author information (first name, last name, biography)
- **publishers**: Publisher details
- **genres**: Book categories
- **book_genres**: Many-to-many relationship between books and genres
- **reviews**: Customer reviews and ratings
- **addresses**: User shipping and billing addresses

## 🔐 Authentication & Authorization

- **Registration**: Users can create accounts with username, email, and password
- **Password Security**: Passwords are hashed using bcrypt before storage
- **Session Management**: Express-session maintains user login state
- **Role-Based Access**: 
  - `USER`: Standard customer access
  - `ADMIN`: Full administrative privileges

### Default Admin Account
```
Email: admin@gmail.com
Password: admin
```

## 🎨 Design Features

- **Custom Typography**: Tan Mon Cheri font for elegant headers
- **Responsive Layout**: Works on desktop and mobile devices
- **Animated Modals**: Smooth transitions for book details and cart
- **Category Cards**: Visual genre browsing with cover images
- **Star Rating System**: Dynamic 5-star display for book reviews
- **Sidebar Cart**: Slide-in shopping basket

## 📡 API Endpoints

### Books
- `GET /api/books` - Get all books
- `POST /api/books` - Add new book (admin)
- `PUT /api/books/:id` - Update book (admin)
- `DELETE /api/books/:id` - Delete book (admin)

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user
- `GET /api/auth/current` - Get current user

### Authors, Publishers, Genres
- `GET /api/authors` - Get all authors
- `GET /api/publishers` - Get all publishers
- `GET /api/genres` - Get all genres
- `GET /api/book-genres` - Get book-genre associations

### Reviews
- `GET /api/reviews` - Get all reviews

## 🧪 Testing

Access the application:
1. Open browser to `http://localhost:8080`
2. Browse books as guest
3. Register a new account or login with admin credentials
4. Test shopping cart functionality
5. Admin: Access admin panel to manage inventory

## 📝 Future Enhancements

- [ ] Payment gateway integration
- [ ] Order history tracking
- [ ] Email notifications
- [ ] Advanced search and filtering
- [ ] Wishlist functionality
- [ ] Book recommendations
- [ ] Inventory management
- [ ] Sales analytics dashboard

## 👥 User Roles

### Customer Features
- Browse and search books
- View detailed book information
- Add items to cart
- Manage profile and addresses
- Read and write reviews

### Admin Features
- All customer features
- Add/edit/delete books
- Upload book cover images
- Manage authors and publishers
- Assign genres to books
- View all users

## 🤝 Contributing

This is a school project. For educational purposes only.

## 📄 License

This project is created for academic purposes.

## 📞 Support

For questions or issues, please use the Contact page in the application.

---

**Built with ❤️ using Vue.js and Node.js**

