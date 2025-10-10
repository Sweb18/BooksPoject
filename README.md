Book Review Database Project
Description
This project is a relational database designed to manage books, their authors, publishers, languages, genres, users, and reviews. 
It provides a normalized schema to efficiently store, search, and connect data points for use in digital library platforms or literary social networks.

Main Entities : 
* Book: Information about books (title, subtitle, ISBN, author, publisher, language, genre, etc.)
* Author: Details about authors (name, bio, birth/death date, nationality)
* Publisher: Details about publishers (name, country, founded year, website, contact info)
* User: Users of the system (usernames, emails, roles)
* Review: User-written book reviews and ratings
* Genre: Literary genres for categorization
* Language: Book language metadata
* Book_Genre: Association table for books and genres

Relational Schema
The relationships include:

*An author can write multiple books
*A book is published by a publisher and associated with a language
*A book can belong to several genres
*A user can write multiple reviews about different books
*Reference diagrams are available in the /assets folder to help understand the schema.

Features :

*Add, remove, update books, authors, publishers, genres, users, and reviews
*Multi-genre association for books
*Search by author, genre, language, publisher, user, or title
*User reviews and star ratings (1-5)
*Authentication and user roles (admin, reader)

This project was created as part of the Advanced Web Programming course.
Authors: Souhaib, Max, and Renaud
