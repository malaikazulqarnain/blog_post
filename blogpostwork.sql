CREATE DATABASE BloggingDB;
GO
USE BloggingDB;
GO
CREATE TABLE Roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT GETDATE()
);
CREATE TABLE Blogs (
    blog_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('draft', 'published')) DEFAULT 'draft',
    views INT DEFAULT 0,
    is_deleted BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Blogs_Users
        FOREIGN KEY (user_id) REFERENCES Users(user_id),

    CONSTRAINT FK_Blogs_Categories
        FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Tags (
    tag_id INT IDENTITY(1,1) PRIMARY KEY,
    tag_name VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE Blog_Tags (
    blog_id INT NOT NULL,
    tag_id INT NOT NULL,

    CONSTRAINT PK_Blog_Tags PRIMARY KEY (blog_id, tag_id),

    CONSTRAINT FK_BlogTags_Blogs
        FOREIGN KEY (blog_id) REFERENCES Blogs(blog_id) ON DELETE CASCADE,

    CONSTRAINT FK_BlogTags_Tags
        FOREIGN KEY (tag_id) REFERENCES Tags(tag_id) ON DELETE CASCADE
);
CREATE TABLE Comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    blog_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text NVARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Comments_Blogs
        FOREIGN KEY (blog_id) REFERENCES Blogs(blog_id) ON DELETE CASCADE,

    CONSTRAINT FK_Comments_Users
        FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Likes (
    user_id INT NOT NULL,
    blog_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_Likes PRIMARY KEY (user_id, blog_id),

    CONSTRAINT FK_Likes_Users
        FOREIGN KEY (user_id) REFERENCES Users(user_id),

    CONSTRAINT FK_Likes_Blogs
        FOREIGN KEY (blog_id) REFERENCES Blogs(blog_id) ON DELETE CASCADE
);
CREATE TABLE Bookmarks (
    user_id INT NOT NULL,
    blog_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_Bookmarks PRIMARY KEY (user_id, blog_id),

    CONSTRAINT FK_Bookmarks_Users
        FOREIGN KEY (user_id) REFERENCES Users(user_id),

    CONSTRAINT FK_Bookmarks_Blogs
        FOREIGN KEY (blog_id) REFERENCES Blogs(blog_id) ON DELETE CASCADE
);
CREATE INDEX IDX_Blogs_User ON Blogs(user_id);
CREATE INDEX IDX_Blogs_Category ON Blogs(category_id);
CREATE INDEX IDX_Blogs_Status ON Blogs(status);
