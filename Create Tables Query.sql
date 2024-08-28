CREATE TABLE employee(
employee_id VARCHAR(50) PRIMARY KEY,
last_name CHAR(50),
first_name CHAR(50),
title VARCHAR(50),
reports_to VARCHAR(30),
levels VARCHAR(10),
birthdate TIMESTAMP,
hire_date TIMESTAMP,
address VARCHAR(120),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(30),
postal_code VARCHAR(30),
phone VARCHAR(30),
fax VARCHAR(30),
email VARCHAR(30));

CREATE TABLE customer(
customer_id VARCHAR(30) PRIMARY KEY,
first_name TEXT,
last_name TEXT,
company TEXT,
address TEXT,
city TEXT,
state TEXT,
country TEXT,
postal_code VARCHAR(20),
phone VARCHAR(50),
fax VARCHAR(50),
email VARCHAR(70),
support_rep_id INTEGER);

CREATE TABLE invoice(
invoice_id VARCHAR(30) PRIMARY KEY,
customer_id VARCHAR(30),
invoice_date TIMESTAMP,
billing_address VARCHAR(120),
billing_city VARCHAR(30),
billing_state VARCHAR(30),
billing_country VARCHAR(30),
billing_postal VARCHAR(30),
total FLOAT8);

CREATE TABLE invoice_line(
invoice_line_id VARCHAR(50) PRIMARY KEY,
invoice_id VARCHAR(30),
track_id VARCHAR(30),
unit_price VARCHAR(30),
quantity VARCHAR(30));

CREATE TABLE track(
track_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(150),
album_id VARCHAR(30),
media_type_id VARCHAR(30),
genre_id VARCHAR(30),
composer VARCHAR(150),
milliseconds INTEGER,
bytes BIGINT,
unit_price INTEGER
);

CREATE TABLE playlist(
playlist_id VARCHAR(50) PRIMARY KEY,
name  VARCHAR(30));

CREATE TABLE playlist_track(
    playlist_id VARCHAR(50),
    track_id VARCHAR(50),
    PRIMARY KEY (playlist_id, track_id)
);

CREATE TABLE artist(
artist_id VARCHAR(50) PRIMARY KEY,
name  VARCHAR(30)); 

CREATE TABLE album(
album_id VARCHAR(50) PRIMARY KEY,
title  VARCHAR(30),
artist_id  VARCHAR(30));

CREATE TABLE media_type(
media_type_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(30));

CREATE TABLE genre(
genre_id VARCHAR(50) PRIMARY KEY,
name VARCHAR(30));