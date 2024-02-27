-- SQL: INSERT
--------------
-- The INSERT statement inserts a row into a table
INSERT INTO users (name, email) VALUES ('Somesh', 'somesh@umich.edu');

-- SQL: DELETE
--------------
-- Deletes a row in a table based on selection criteria
DELETE FROM users WHERE email='ted@umich.edu';

-- Delete all row from table
DELETE FROM users;

-- DROP table
DROP TABLE users;

-- SQL: UPDATE
--------------
-- Allows the updating of a field with a WHERE clause
UPDATE users SET name='Charles' WHERE email='csev@umich.edu';

-- SQL: SELECT
--------------
-- Retrieves a group of records - you can either retrieve all
-- the records or subset of the records with the WHERE clause
SELECT * FROM users;

SELECT * FROM users WHERE email='csev@umich.edu'; 

-- SQL: ORDER BY
----------------
-- We can add an ORDER BY clause to SELECT statements
-- to get the results sorted in ascending and descending order. 
SELECT * FROM users ORDER BY email;

-- SQL: LIKE
------------
-- We can do wildcard matching in a WHERE clause
-- using LIKE operator
SELECT * FROM users WHERE name LIKE '%e%';

-- SQL: OFFSET/LIMIT
--------------------
-- We can request the first 'n' rows, or the first 'n' rows
-- after skipping some rows.
-- Ther WHERE and ORDER BY clauses happen before the LIMIT/OFFSET
-- are applied.
-- The OFFSET starts from 0;
SELECT * FROM users ORDER BY email DESC LIMIT 2;

SELECT * FROM users ORDER BY email OFFSET 1 LIMIT 2;

-- SQL: SELECT
--------------
-- Couting rows with SELECT
-- We can request to recieve the count of the rows
-- that would be retrieved instead of the rows
SELECT COUNT(*) FROM users;

SELECT COUNT(*) FROM users WHERE email='csev@umich.edu';

-- Data Types
-------------

--> Text Fields
-- Have a character set - paragraph or HTML pages
-- Generally not used with indexing or sorting - and only then
-- limited to a prefix.

-- TEXT - barying length


--> String Fields
-- Understand character sets and are indexable for searching

-- CHAR(n)
-- VARCHAR(n)


--> Binary Fields
-- Character = 8 - 32 bits of information depending on character set
-- Byte = 8 bits of information
-- small Images - data
-- Not indexed or sorted

-- BYTEA(n) up to 255 bytes



--> Numeric Fields 
--> Integer Numbers
-- Integer nubers are very efficient, take little storage, and are east to proccess
-- because CPUs can often compare them with a single instruction.

-- SMALLINT 
-- INTEGER
-- BIGINT

--> Floating Point Numbers
-- Floating point numbers can represent a wide range of values, but accuracy
-- is limited

-- REAL(32-bit) with seven digits of accuracy
-- DOUBLE PRECISION(64-bit) with 14 digits of accuracy
-- NUMERIC(accuracy, decimal) specified digits of accuracy and digits after the decimal point

-- Dates
--------

-- TIMESTAMP - 'YYYY-MM-DD HH:MM:SS'
-- DATE - 'YYYY-MM-DD'
-- TIME - 'HH:MM:SS'

-- Build-in PostgresSQL function NOW()


-- Database Keys and Indexes
----------------------------

-- AUTO_INCREMENT
-- Often as we make multiple tables and need to JOIN them
-- together we need an integer primary key for each row
-- so we can efficiently add a reference to a row in some
-- other table as a foreign key


-- Delete table from database
DROP TABLE users;

-- Create users table with primary key
CREATE TABLE users (
    id SERIAL,
    name VARCHAR(25),
    email VARCHAR(25) UNIQUE,
    PRIMARY KEY(id)
);

-- PostgreSQL Functions
-----------------------

-- Many operations in PostgreSQL need to use the build-in function
-- (like NOW() for dates)


-- Indexes
----------
-- As a table gets large (they always do), scanning all the data to find
-- a single row becomes very costly.
-- There are techniques to greatly shorten the scan as long as you create
-- data structures and maintain those structures - like shortcuts
-- Hashes or Trees (b-tree) are the most common

-- Copy data from csv file to table
\copy track(title, artist, album, count, rating, len) FROM 'library.csv' WITH DELIMITER ',' CSV;

-- select 4 tracks from table ordered by title
select title, album from track order by title limit 4;



------
-- single table sql
-- serial field / auto_increment
-- dealing with csv files