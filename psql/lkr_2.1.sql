-- Alter Table schema
---------------------

-- Create tables

create table account (
    id serial,
    email varchar(128) unique,
    created_at date not null default now(),
    updated_at date not null default now(),
    primary key(id)
);

create table post (
    id serial,
    title varchar(128) unique not null,
    content varchar(1024), -- maybe we'll need to alter it later
    account_id integer references account(id) on delete cascade,
    created_at timestamp not null default now(),
    updated_at timestamp not null default now(),
    primary key(id)
);

create table comment (
    id serial,
    content text not null,
    account_id integer references account(id) on delete cascade,
    post_id integer references post(id) on delete cascade,
    created_at timestamp not null default now(), -- setting default value 
    updated_at timestamp not null default now(), -- setting default value
    primary key(id)
);

create table fav (
    id serial,
    oops text,
    post_id integer references post(id) on delete cascade,
    account_id integer references account(id) on delete cascade,
    created_at timestamp not null default now(), -- setting default value
    updated_at timestamp not null default now(), -- setting default value
    unique(post_id, account_id),
    primary key(id)
);


-- we can adjust our schema
-- sometimes you make mistake or our application envolves
-- add, drop, alter columns
-- can also alter indexes, uniqueness, constraints, foreign keys
-- can run on a live database

alter table fav drop column oops;
alter table post alter column content type text;
alter table fav add column howmuch integer;

-- reading commands from a file
-- \i to execute commands in the file
-- file example alter_account.sql
delete from account;
alter sequence account_id_seq restart with 1;
alter sequence post_id_seq restart with 1;
alter sequence comment_id_seq restart with 1;
alter sequence fav_id_seq restart with 1;


-- Dates
--------

-- Date types
date -- 'yyyy-mm-dd'
time -- 'hh:mm:ss'
timestamp -- 'yyyy-mm-dd hh:mm:ss'
timestamptz -- timestamp with timezone

now() -- built-in postgreSQL function -- return timestamptz data type with UTC timezone

-- setting default values
-- creating new schema, and give it default value each time 
-- a new record is inserted to the table

-- updated_at timestamp default now()

-- execute now() with timezone
select now(), now() at time zone 'utc', now() at time zone 'hst';

-- TIMESTAMPTZ - best practice
-- store time stamps with timezone
-- prefer UTC for stored time stamps
-- convert to local time zone when retrieving


-- PostgreSQL time zone
select * from pg_timezone_names;
select * from pg_timezone_names where name like '%Hawaii%';


-- Casting to different types
-- we can use the phrase 'casting' to mean convert from one 
-- type to another.
-- PostgreSQL has several forms of casting

select now()::date, cast(now() as date), cast(now() as time);

-- intervals
-- we can do date interval arithmetic

select now(), now() - interval '2 days', (now() - interval '2 days')::date;

-- using date_trunc()
-- sometimes we want to discard some of the accuracy that is in a timestamp

select id, content, created_at 
from comment
where created_at >= date_trunc('day', now())
and created_at < date_trunc('day', now() + interval '1 day'); -- better (faster than the second below)

-- Performance: table scans
-- Not all equivalant queries have the same performance

select id, content, created_at 
from comment
where created_at::date = now()::date; -- slow query

-- SQL: DISTINCT/GROUP BY
-------------------------
-- reducing the result set
-- DISTINCT only returns unique rows in a result set - and row will
-- only appear once.
select distinct model 
from racing 

-- DISTINCT ON limits duplicate removal to a set of columns
select distinct on (model) make, model 
from racing;

-- GROUP BY is combined with aggregate function like COUNT(),
-- MAX(), SUM(), AVE()...
select count(abbrev), abbrev 
from pg_timezone_names 
group by abbrev;

-- SQL: HAVING clause
select count(abbrev) as ct, abbrev 
from pg_timezone_names
where is_dst = 't' 
group by abbrev 
having count(abbrev) > 5;


-- DISTINCT & DISTINCT ON

drop table if exists racing;

create table racing (
    model varchar,
    make varchar,
    year integer,
    price integer
);

insert into racing (make, model, year, price)
values
('Nissan', 'Stanza', 1990, 2000),
('Dodge', 'Neon', 1995, 800),
('Dodge', 'Neon', 1998, 2500),
('Dodge', 'Neon', 1999, 3000),
('Ford', 'Mustang', 2001, 1000),
('Ford', 'Mustang', 2005, 2000),
('Subaru', 'Impreza', 1997, 1000),
('Mazda', 'Miata', 2001, 5000),
('Mazda', 'Miata', 2001, 3000),
('Mazda', 'Miata', 2001, 2500),
('Mazda', 'Miata', 2002, 5500),
('Opel', 'GT', 1972, 1500),
('Opel', 'GT', 1969, 7500),
('Opel', 'Cadet', 1973, 500);


select make from racing;

select distinct make from racing;
select distinct make, model from racing; -- distinct make nad model
select distinct on (model) make, model, year from racing; -- distinct only model


select make, model, year 
from racing order by year desc; -- order by year

select make, model, year
from racing order by model, year desc; -- order by model first than by year

select distinct on (model) make, model, year
from racing order by model, year desc;

select distinct on (model) make, model, year
from racing order by model, year desc;

-- group by

select * from pg_timezone_names limit 20;
select count(*) from pg_timezone_names;
select distinct is_dst from pg_timezone_names;

select count(is_dst), is_dst 
from racing
group by is_dst; 


select count(abbrev) as ct, abbrev
from pg_timezone_names
where is_dst = 't'
group by abbrev
having count(abbrev) > 10;


select count(abbrev), abbrev 
from pg_timezone_names
group by abbrev
having count(abbrev) > 10;


select count(abbrev) as ct, abbrev
from pg_timezone_names
group by abbrev
having count(abbrev) > 10
order by count(abbrev) desc;


-- subquery
-- a query within a query
-- can use a value or set of values in query
-- that are computed bu another query

select * from account
where email = 'ed@umich.edu';

select content from comment
where account_id = 7;

select content from comment
where account_id = (select id from account where email = 'ed@emich.edu'); -- subquery works first

-- HAVING clause is kind of second WHERE clause that
-- happens after the GROUP BY
-- So the WHERE clause happens before the GROUP BY, 
-- then you have the GROUP BY, and then you have the HAVING clause which is a WHERE clause. 

select count(abbrev), abbrev
from pg_timezone_names
where is_dst = 't'
group by abbrev
having count(abbrev) > 10;

-- using subquery (example)

select ct, abbrev 
from 
(
    select count(abbrev) as ct, abbrev 
    from pg_timezone_names
    where is_dst = 't'
    group by abbrev
) as zap
where ct > 10;


-- concurrency and transactions
-------------------------------
-- Database are designed to accept SQL
-- commands from a variety of sources 
-- simultaneously and make them atomically

-- transactions and atomicity
-- to implement atomicity, postgreSQL 'locks'
-- area before it starts and SQL command that might 
-- change an area of the database.

-- all other access to that area must wait until the area is 
-- unlock

update tracks 
set count = count+1
where id = 42;

LOCK ROW 42 OF tracks
READ count FROM tracks ROW 42
count = count + 1
WRITE count TO tracks ROW 42
UNLOCK ROW 42 OF tracks


-- Single SQL statement are atomic
-- All the inserts will work and get a unique primary key
-- Which account gets which key is not predictable.

insert into account (email) values ('ed@umich.edu');
insert into account (email) values ('sue@umich.edu');
insert into account (email) values ('sally@umich.edu');

-- Compound Statements
-- There are statemets which do more than one things in 
-- one statement for efficiency and concurrency

insert into fav (post_id, account_id, howmuch) 
values (1, 1, 1)
returning *;

update fav set howmuch=howmuch+1
where post_id = 1 and account_id = 1
returning *; 


-- ON CONFLICT
-- sometimes you 'bump into' a contraint on     
-- purpose

-- this will fail - because will already had inserted it 
insert into fav (post_id, account_id, howmuch) 
values (1, 1, 1)
returning *;

insert into fav (post_id, account_id, howmuch)
values (1, 1, 1)
on conflict (post_id, account_id)
do update set howmuch = fav.howmuch + 1;


-- returning statemets
----------------------
insert into fav (post_id, account_id, howmuch)
values (1, 1, 1)
on conflict (post_id, account_id)
do update set howmuch = fav.howmuch + 1;
returning *;


begin;
rollback;

-- stored procedures
--------------------
-- A stored procedure is a bit of reusable code
-- that runs inside of the database server.
-- Generally quite non-portable
-- Usually the goal is to have fewer SQL statements.
-- Technically there are multiple language choices
-- but just use 'plpgsql'.

-- We should have a strong reason to use a stored procedures
--* Major performance problem
--* Harder to test/modify
--* No database protability
--* Some rule that :must: be enforced  

update fav set howmuch=howmuch+1
where post_id=1 and account_id=1;

update fav set howmuch=howmuch+1, updated_at=now()
where post_id=1 and account_id=1;

-- using a trigger for update_at

create or replace function trigger_set_timestamp()
returns trigger as $$
begin
    new.update_at=now();
    return new;
end;
$$ language plpgsql;


create trigger set_timestamp
before update on fav
for each row
execute procedure trigger_set_timestamp();

update fav set howmuch=howmuch+1
where post_id=1 and account_id=1


















