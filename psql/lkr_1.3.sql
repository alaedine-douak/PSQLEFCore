-- Relational Database Design
-----------------------------

-- Database design is an art form of ots own with
-- particular skills and experience.

-- Database design starts with a picture of the shape of data.

--> Building a Data Model
-- Drawing a picture of the data objects for our application
-- and then figuring out how to represent the objects and their relationships.

-- Key Terminology
------------------

-- Three kinds of keys
-- Primary key - generally am integer auto-increment field
    -- Never use your logical key as the primary key.
    -- Logical key can and do change, albeit slowly.
    -- Relationships that are based on matching string fields are less efficient than integers.
-- Logical key - what the outside world uses for lookup (in search input)
-- foreign key - generally an integer key pointing to a row in another table.


-- Normalization and foreign keys
---------------------------------

--> Database Normalization (3NF)
-- Do not replicate data. Instead, reference data. Point at data.
-- Use integers for keys and for references. (use integer columns in one table to 
--    reference [or look up] rows in another table).
-- Add a special 'key' column to each table, which you will make references to.


-- Building tables
------------------

create table artist (
    id serial,
    name varchar(128) unique,
    primary key(id)
);

insert into artist (name) values ('Led Zeppelin');
insert into artist (name) values ('AC/DC');

create table album (
    id serial,
    title varchar(128) unique,
    artist_id integer references artist(id) on delete cascade,
    primary key(id)
);

insert into album (title, artist_id) values ('Who Made Who', 2);
insert into album (title, artist_id) values ('IV', 1);

create table genre (
    id serial,
    name varchar(128) unique,
    primary key(id)
);

insert into genre (name) values ('Rock');
insert into genre (name) values ('Metal');

create table track (
    id serial,
    title varchar(128),
    len integer,
    rating integer,
    count integer,
    album_id integer references album(id) on delete cascade,
    genre_id integer references genre(id) on delete cascade,
    unique(title, album_id),
    primary key(id)
);

insert into track (title, rating, len, count, album_id, genre_id) values ('Black Dog', 5, 297, 0, 2, 1);
insert into track (title, rating, len, count, album_id, genre_id) values ('Stairway', 5, 482, 0, 2, 1);
insert into track (title, rating, len, count, album_id, genre_id) values ('About To Rock', 5, 313, 0, 1, 2);
insert into track (title, rating, len, count, album_id, genre_id) values ('Who Made Who', 5, 207, 0, 1, 2);

-- \d track

-- Using JOIN Across Tables
---------------------------

-- The JOIN operation links across several tables as part of a SELECT operation.
-- You must tell the JOIN how to use th keys that maje the connection
-- between the tables using ON clause.

-- get only those are match

SELECT album.title, artist.name
FROM album 
JOIN artist
ON album.artist_id = artist.id;

SELECT album.title, album.artist_id, artist.id, artist.name
FROM album
INNER JOIN artist
ON album.artist_id = artist.id;


SELECT track.title, artist.name, album.title, genre.name
FROM track
JOIN genre ON track.genre_id = genre.id
JOIN album ON track.album_id = album.id
JOIN artist ON album.artist_id = artist.id;

-- get all combinations

SELECT track.title, track.genre_id, genre.id, genre.name
FROM track 
CROSS JOIN genre;


-- ON DELETE Choices
--------------------
--> Default/RESTRICT - Don't allow changes that break the constraint
--> CASCADE - Adjust child rows by removing or updating to maintain consistency
--> SET NULL - set the foreign key columns in the child rows to null