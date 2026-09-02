
# Blog App API - Laravel Backend

A RESTful API for a Blog Mobile Application built with Laravel 13.x and MySQL.

## 📋 Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [API Endpoints](#api-endpoints)
- [Testing](#testing)
- [Postman Collection](#postman-collection)
- [License](#license)

## ✨ Features

- 🔐 **Authentication** - Register, Login, Logout with Sanctum
- 👤 **User Management** - Get current user profile
- 📝 **Post Management** - CRUD operations for posts
- 🖼️ **Image Upload** - Upload images with posts
- 💬 **Comments** - Add and view comments on posts
- 🛡️ **API Protection** - Token-based authentication
- 📦 **Pagination** - Paginated responses for posts
- 🔍 **Search** - Search posts by title, content, or author

## 📋 Requirements

- PHP >= 8.3
- Composer
- MySQL >= 8.0
- Laravel 13.x
- Node.js & NPM (for frontend assets)

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/blog-api.git
cd blog-api
```

### 2. Install PHP Dependencies

```bash
composer install
```

### 3. Environment Configuration

Copy the `.env.example` file and configure your environment:

```bash
cp .env.example .env
```

### 4. Generate Application Key

```bash
php artisan key:generate
```

### 5. Configure Database

Open `.env` and update your database credentials:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=blog_app
DB_USERNAME=root
DB_PASSWORD=your_password
```

### 6. Run Migrations

```bash
php artisan migrate
```

### 7. Seed Database (Optional)

```bash
php artisan db:seed
```

This will create test users, posts, and comments.

### 8. Create Storage Link

```bash
php artisan storage:link
```

### 9. Start Development Server

```bash
php artisan serve
```

The API will be available at: `http://localhost:8000`

## 🔧 Configuration

### CORS Configuration

If you're connecting from a Flutter mobile app, make sure CORS is properly configured in `config/cors.php`:

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'allowed_origins_patterns' => [],
'allowed_headers' => ['*'],
'exposed_headers' => [],
'max_age' => 0,
'supports_credentials' => false,
```

### Sanctum Configuration

Configure Sanctum in `config/sanctum.php`:

```php
'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', sprintf(
    '%s%s',
    'localhost,localhost:3000,127.0.0.1,127.0.0.1:8000,::1',
    Sanctum::currentApplicationUrlWithPort()
))),
```

## 📊 Database Schema

### Users Table
| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| name | string | User's full name |
| email | string | Unique email address |
| password | string | Hashed password |
| profile_image | string | Path to profile image |
| timestamps | timestamp | Created/Updated at |

### Posts Table
| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| user_id | bigint | Foreign key to users |
| title | string | Post title |
| content | text | Post content |
| image | string | Path to post image |
| timestamps | timestamp | Created/Updated at |

### Comments Table
| Column | Type | Description |
|--------|------|-------------|
| id | bigint | Primary key |
| post_id | bigint | Foreign key to posts |
| user_id | bigint | Foreign key to users |
| content | text | Comment content |
| timestamps | timestamp | Created/Updated at |

## 📡 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/register` | Register new user | ✅ |
| POST | `/api/login` | Login user | ✅ |
| POST | `/api/logout` | Logout user | ✅ |
| GET | `/api/current-user` | Get current user | ✅ |

### Posts

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/posts` | Get all posts | ✅ |
| GET | `/api/posts/{id}` | Get single post | ✅ |
| POST | `/api/posts` | Create new post | ✅ |
| PUT | `/api/posts/{id}` | Update post | ✅ |
| DELETE | `/api/posts/{id}` | Delete post | ✅ |

### Comments

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/posts/{postId}/comments` | Get post comments | ✅ |
| POST | `/api/posts/{postId}/comments` | Add comment | ✅ |
| DELETE | `/api/comments/{id}` | Delete comment | ✅ |

## 📦 Request Examples

### Register

```http
POST /api/register
Content-Type: application/json

{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "password_confirmation": "password123"
}
```

### Login

```http
POST /api/login
Content-Type: application/json

{
    "email": "john@example.com",
    "password": "password123"
}
```

### Create Post (with image)

```http
POST /api/posts
Authorization: Bearer {token}
Content-Type: multipart/form-data

title: My First Blog Post
content: This is the content of my post...
image: (file upload)
```

### Update Post

```http
PUT /api/posts/1
Authorization: Bearer {token}
Content-Type: application/json

{
    "title": "Updated Title",
    "content": "Updated content..."
}
```

## 🧪 Testing

### Run Tests

```bash
php artisan test
```

### Test API with cURL

```bash
# Login
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get Posts (with token)
curl -X GET http://localhost:8000/api/posts \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 📁 Project Structure

```
blog-api/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── AuthController.php
│   │   │   ├── PostController.php
│   │   │   └── CommentController.php
│   │   └── Middleware/
│   └── Models/
│       ├── User.php
│       ├── Post.php
│       └── Comment.php
├── config/
│   ├── cors.php
│   ├── sanctum.php
│   └── database.php
├── database/
│   ├── migrations/
│   └── seeders/
├── routes/
│   └── api.php
├── storage/
├── tests/
├── .env
├── composer.json
└── README.md
```

## 🔑 Test Accounts

| Email | Password |
|-------|----------|
| test@example.com | password123 |
| john@example.com | password123 |

## 📦 Postman Collection

Import the Postman collection from the root directory:

1. Open Postman
2. Click **Import** → **Upload Files**
3. Select `Blog_API_Collection.json`
4. Set environment variables:
   - `base_url`: `http://localhost:8000/api`
   - `token`: (will be set automatically on login)

## 🐛 Troubleshooting

### Storage Link Not Working

```bash
php artisan storage:link
```

### Migration Issues

```bash
php artisan migrate:fresh
```

### Clear Cache

```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
```

### Permission Issues (Linux/Mac)

```bash
chmod -R 775 storage
chmod -R 775 bootstrap/cache
```

## 📝 License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
```

## Quick Commands Reference

```bash
# Start server
php artisan serve

# Run migrations
php artisan migrate

# Run seeders
php artisan db:seed

# Clear cache
php artisan optimize:clear

# Create controller
php artisan make:controller PostController

# Create model with migration
php artisan make:model Post -m

# List all routes
php artisan route:list

# Enter tinker
php artisan tinker
```

This README provides a complete overview of your Laravel backend API! 🚀