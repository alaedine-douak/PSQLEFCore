-- Many-to-many relationships
-----------------------------

-- sometimes we need to model a relationship that is 
-- many to many.

-- we need to add a 'connection' table with two foreign keys.

-- there is usually no separate primary key.

-- start with a fresh database

create database ilearn with owner 'douak' encoding 'utf8';

CREATE TABLE student (
    id serial,
    name varchar(128),
    email varchar(128) unique,
    primary key(id)
);

insert into student (name,email) values ('Jane', 'jane@tsugi.org');
insert into student (name,email) values ('Ed', 'ed@tsugi.org');
insert into student (name,email) values ('Sue', 'sue@tsugi.org');


CREATE TABLE course (
    id serial,
    title varchar(128) unique,
    primary key(id)
);

insert into course (title) values ('Python');
insert into course (title) values ('SQL');
insert into course (title) values ('PHP');

CREATE TABLE member(
    student_id integer references student(id) on delete cascade,
    course_id integer references course(id) on delete cascade,
    role integer,
    primary key(student_id, course_id)
);

-- roles
-- 0 - student
-- 1 - teacher

insert into member (student_id, course_id, role) values (1, 1, 1);
insert into member (student_id, course_id, role) values (2, 1, 0);
insert into member (student_id, course_id, role) values (3, 1, 0);
insert into member (student_id, course_id, role) values (1, 2, 0);
insert into member (student_id, course_id, role) values (2, 2, 1);
insert into member (student_id, course_id, role) values (2, 3, 1);
insert into member (student_id, course_id, role) values (3, 3, 1);


-- select

select student.name, member.role, course.title
from student
join member on member.student_id = student.id
join course on member.course_id = course.id
order by course.title, member.role desc, student.name;