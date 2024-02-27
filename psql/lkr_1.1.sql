-- docker-compose up
-- docker-compose down

-- docker exec -it container_name bash

-- psql -U postgres
-- sudo -u postgres psql postgres

--Create a User and Database
--------------------------
CREATE USER douak WITH PASSWORD '6772AlA@';
CREATE DATABASE people WITH OWNER 'douak';

CREATE DATABASE music WITH OWNER 'douak' ENCODING 'UTF8';

--Connecting to a Database
------------------------
-- psql -h localhost -p 5432 -U douak people
-- psql people douak


-- Create Table
------------
CREATE TABLE users ( 
    name VARCHAR(128), 
    email VARCHAR(128) 
);

-- \dt => show tables in db
-- \d+ db_name => show table schemas


----------
-- making first tables
-- inserting some data into a table
