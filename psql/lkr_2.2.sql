-- Reading and Parsing files
-- create tables
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
    content varchar(1024), -- alter to text type
    account_id integer references account(id) on delete cascade,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    primary key(id)
);

create table comment (
    id serial,
    content text not null,
    account_id integer references account(id) on delete cascade,
    post_id integer references post(id) on delete cascade,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    primary key(id)
);

create table fav (
    id serial, 
    oops text, -- drop column
    post_id integer references post(id) on delete cascade,
    account_id integer references account(id) on delete cascade,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    unique(post_id, account_id),
    primary key(id)
);

=> \d+ fav
=> \i file_name.sql -- run commands from file

-- alter tables
alter table post alter column content type text;
alter table fav drop column oops;
alter table fav add column howmuch integer;

-- start fresh cascade deletes it all
delete from account;

alter sequence account_id_seq restart with 1;
alter sequence post_id_seq restart with 1;
alter sequence comment_id_seq restart with 1;
alter sequence fav_id_seq restart with 1;

insert into account (email) values
('ed@umich.edu'), ('sue@umich.edu'), ('sally@umich.edu');

insert into post (title, content, account_id) values 
('Dictionaries', 'Are fun', 3),
('BeautifulSoup', 'Has a complex API', 1),
('Many to many', 'Is elegant', (select id from account where email = 'sue@umich.edu'));

insert into comment (content, post_id, account_id) values
('I agree', 1, 1),
('Especially  for counting', 1, 2),
("And I don't understand why", 2, 2),
('Someone should make "EasySoup" or something like that',
    (select id from post where title = 'BeautifulSoup'),
    (select id from account where email = 'ed@umich.edu')),
('Good idea - I might just do that',
    (select id from post where title = 'BeautifulSoup'),
    (select id from account where email = 'sally@umich.edu'));

-- load a csv file and automatically normalize into one-to-many
-- Download wget https://www.pg4e.com/lectures/03-Techniques.csv

-- x, y
-- Zap,A
-- Zip,A
-- One,B
-- Two,B

drop table if exists xy_raw;
drop table if exists x;
drop table if exists xy;

create table xy_raw (
    x text,
    y text,
    y_id integer
);

create table y (
    id serial,
    primary key(id),
    y text
);

create table xy (
    id serial,
    primary key(id),
    x text,
    y_id integer,
    unique(x, y_id)
);

=> \d+ xy_raw
=> \d+ y

\copy xy_raw(x, y) from '03-Techniques.csv' with delimiter ',' csv;

select distinct y from xy_raw;

insert into y (y) select distinct y from xy_raw order by y;

update xy_raw set y_id = (select y.id from y where y.y = xy_raw.y);

insert into xy (x, y_id) select x, y_id from xy_raw;

select * from xy join y on xy.y_id = y.id;
