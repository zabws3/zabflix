/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  alumne
 * Created: 27 nov 2025
 */


-- 1. Tabla de usuarios
CREATE TABLE users (
    user_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Índices para users (En Derby se crean fuera)
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- 2. Tabla de categorías
CREATE TABLE categories (
    category_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR(100) NOT NULL,
    description LONG VARCHAR
);

CREATE INDEX idx_categories_name ON categories(name);

-- 3. Tabla de videos
CREATE TABLE videos (
    video_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    title VARCHAR(200) NOT NULL,
    description LONG VARCHAR,
    duration_seconds INT NOT NULL,
    thumbnail_url VARCHAR(500),
    mpd_path VARCHAR(500) NOT NULL,
    category_id INT,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    views_count INT DEFAULT 0,
    CONSTRAINT fk_video_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE INDEX idx_videos_category ON videos(category_id);
CREATE INDEX idx_videos_title ON videos(title);
CREATE INDEX idx_videos_upload_date ON videos(upload_date);

-- 4. Tabla de historial de visualización
CREATE TABLE view_history (
    history_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    user_id INT NOT NULL,
    video_id INT NOT NULL,
    watch_position_seconds INT DEFAULT 0,
    last_watched TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_history_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_history_video FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    CONSTRAINT unique_user_video UNIQUE (user_id, video_id)
);

CREATE INDEX idx_history_user ON view_history(user_id);
CREATE INDEX idx_history_video ON view_history(video_id);
CREATE INDEX idx_history_last_watched ON view_history(last_watched);
