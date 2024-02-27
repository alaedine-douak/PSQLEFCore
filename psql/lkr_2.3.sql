-- Generating test data
-----------------------

-- exploring performance
-- We can't really explore performance of we only have 5 records
-- So before we play a bit with performance, we need to make up 
-- some data.

-- Generating losts of Random Data
-- We use repeat() to generate long strings (horizontal)
-- we user generate_series() to generate lots of rows (vertical) - like Python's range
-- we use random() to make rows unique - floating point 0 <= random() <= 1.0


select random(), random(), trunc(random()*100); 
--  0.4979150262473271 | 0.9756553567146251 |    93

select repeat('douak ', 6); -- repeat term douak 6 times

select generate_series(1, 5); -- 1, 2, 3, 4, 5

-- example
select 'https://sql4e.com/douak/' || trunc(random()*1000000) || repeat('ala', 5) || generate_series(1, 5)

-- text funtions
----------------

-- Many text fucntions -> https://www.postgresql.org/docs/11/functions-string.html
-- Where clause operators
--* LIKE / ILIKE / NOT LIKE / NOT ILIKE
--* SIMILAR TO / NOT SIMILAR TO  (regular expressions)
--* = > < >= <= BETWEEN IN
-- Manipulate SELECT Results / WHERE clause 
--* lower(), upper()

create table textfun (
    content text
);

create index textfun_b on textfun (content);

select pg_relation_size('textfun'), pg_indexes_size('textfun');
-- 0 |            8192

insert into textfun (content)
select (case when (random() < 0.5)
then 'https://www.pg4e.com/neon/'
else 'https://www.pg4e.com/LEMONS'
end) || generate_series(100000,200000);


select content from textfun limit 3;

--  content
------------------------------------
--  https://www.pg4e.com/neon/100000
--  https://www.pg4e.com/LEMONS/100001
--  https://www.pg4e.com/neon/100002

select content from textfun where content like '%15000%';
-- content
------------------------------------
-- https://www.pg4e.com/LEMONS/150000


select upper(content) from textfun where content like '%150000%';
--  upper
------------------------------------
--  HTTPS://WWW.PG4E.COM/LEMONS/150000


select right(content, 4) from textfun where content like '%150000%';
-- right
-------
-- 0000

select left(content, 4) from textfun where content like '%150000%';
-- left
-------
-- http

-- there are more function in postgresql docs


-- B-Tree index performance
---------------------------

explain analyze select content from textfun where content like 'racing%'; -- fast 
explain analyze select content from textfun where content like '%racing%'; -- slow than first
explain analyze select content from textfun where content ilike 'racing%'; -- most than second

explain analyze select content from textfun where content like '%150000%' limit 1; -- enhance performance by selecting items