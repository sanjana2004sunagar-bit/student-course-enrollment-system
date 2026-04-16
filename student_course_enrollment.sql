-- 1. create database
create database student_project;
use student_project;

-- 2. create tables
create table students (
    student_id int auto_increment primary key,
    name varchar(100),
    age int,
    gender varchar(10)
);

create table courses (
    course_id int auto_increment primary key,
    course_name varchar(100),
    credits int
);

create table enrollment (
    enroll_id int auto_increment primary key,
    student_id int,
    course_id int,
    enroll_date date,
    unique(student_id, course_id),
    foreign key(student_id) references students(student_id),
    foreign key(course_id) references courses(course_id)
);

create table exams (
    exam_id int auto_increment primary key,
    student_id int,
    course_id int,
    exam_date date,
    foreign key(student_id) references students(student_id),
    foreign key(course_id) references courses(course_id)
);

create table results (
    result_id int auto_increment primary key,
    exam_id int unique,
    marks int,
    grade char(2),
    foreign key(exam_id) references exams(exam_id)
);

-- 3. insert sample data

insert into students(name, age, gender) values
('Arjun', 20, 'Male'),
('Nayana', 21, 'Female'),
('Ravi', 22, 'Male'),
('Divya', 20, 'Female');

insert into courses(course_name, credits) values
('Database Systems', 4),
('Python Programming', 3),
('Statistics', 4),
('Machine Learning', 5);

insert into enrollment(student_id, course_id, enroll_date) values
(1, 1, '2024-01-15'),
(1, 2, '2024-01-16'),
(2, 1, '2024-01-15'),
(3, 3, '2024-01-20'),
(4, 4, '2024-01-22');

insert into exams(student_id, course_id, exam_date) values
(1, 1, '2024-02-20'),
(1, 2, '2024-02-21'),
(2, 1, '2024-02-20'),
(4, 4, '2024-02-25');

insert into results(exam_id, marks, grade) values
(1, 85, 'A'),
(2, 78, 'B'),
(3, 92, 'A'),
(4, 65, 'C');

-- 4. queries

-- 1. list all students
select * from students;

-- 2. show all courses
select * from courses;

-- 3. students enrolled in "database systems"
select s.name
from students s
join enrollment e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where c.course_name = 'Database Systems';

-- 4. count total students enrolled in each course
select c.course_name, count(e.student_id) as total_students
from courses c
left join enrollment e on c.course_id = e.course_id
group by c.course_name;

-- 5. display exam marks with student & course
select s.name, c.course_name, r.marks
from results r
join exams e on r.exam_id = e.exam_id
join students s on e.student_id = s.student_id
join courses c on e.course_id = c.course_id;

-- 6. highest scoring student
select s.name, r.marks
from results r
join exams e on r.exam_id = e.exam_id
join students s on e.student_id = s.student_id
order by r.marks desc
limit 1;

-- 7. students not enrolled in any course
select s.name
from students s
left join enrollment e on s.student_id = e.student_id
where e.student_id is null;

-- 8. courses with no exams
select c.course_name
from courses c
left join exams e on c.course_id = e.course_id
where e.exam_id is null;

-- 9. average marks per course
select c.course_name, avg(r.marks) as avg_marks
from results r
join exams e on r.exam_id = e.exam_id
join courses c on e.course_id = c.course_id
group by c.course_name;

-- 10. students with grade 'a'
select s.name
from results r
join exams e on r.exam_id = e.exam_id
join students s on e.student_id = s.student_id
where r.grade = 'A';

-- 11. exams in february
select * from exams
where month(exam_date) = 2;

-- 12. convert marks → auto grade
select marks,
case
    when marks >= 85 then 'A'
    when marks >= 70 then 'B'
    when marks >= 50 then 'C'
    else 'D'
end as grade
from results;

-- 13. student with most enrollments
select s.name, count(e.course_id) as total_courses
from students s
join enrollment e on s.student_id = e.student_id
group by s.name
order by total_courses desc
limit 1;
