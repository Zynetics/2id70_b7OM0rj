CREATE UNLOGGED TABLE Students(StudentId int, StudentName varchar(50), Address varchar(200), BirthyearStudent smallint, Gender char, primary key(StudentId));

CREATE UNLOGGED TABLE degrees(degreeId int, dept varchar(50), degreedescription varchar(200), totalects smallint, primary key(degreeId));

CREATE UNLOGGED TABLE StudentRegistrationsToDegrees(StudentRegistrationId int, Studentid int, degreeId int, registrationyear smallint);

CREATE UNLOGGED TABLE teachers(teacherid int, teachername varchar(50), address varchar(200), birthyearteacher smallint, gender char, primary key(teacherid));

CREATE UNLOGGED TABLE courses(courseid int, coursename varchar(50), coursedescription varchar(200), degreeid int, ects int, primary key(courseid));

CREATE UNLOGGED TABLE courseoffers(courseofferid int, courseid int, year smallint, quartile smallint);

CREATE UNLOGGED TABLE TeacherAssignmentsToCourses(courseofferid int, teacherid int);

CREATE UNLOGGED TABLE studentassistants(courseofferid int , StudentRegistrationId int);

CREATE UNLOGGED TABLE courseregistrations(courseofferid int, studentregistrationid int, grade smallint);

COPY Students(studentId, StudentName, Address, BirthyearStudent, Gender) FROM '/Users/abdullahsaeed/Downloads/tables/Students.table' DELIMITER ',' CSV HEADER;

COPY courseregistrations(courseofferid, studentregistrationid, grade) FROM '/Users/abdullahsaeed/Downloads/tables/CourseRegistrations.table' DELIMITER ',' CSV HEADER NULL as 'null';

COPY degrees(degreeId, dept, degreedescription, totalects) FROM '/Users/abdullahsaeed/Downloads/tables/Degrees.table' DELIMITER ',' CSV HEADER;

COPY StudentRegistrationsToDegrees(StudentRegistrationId, Studentid, degreeId, registrationyear) FROM '/Users/abdullahsaeed/Downloads/tables/StudentRegistrationsToDegrees.table' DELIMITER ',' CSV HEADER;

COPY teachers(teacherid, teachername, address, birthyearteacher, gender) FROM '/Users/abdullahsaeed/Downloads/tables/Teachers.table' DELIMITER ',' CSV HEADER;

COPY courses(courseid, coursename, coursedescription, degreeid, ects) FROM '/Users/abdullahsaeed/Downloads/tables/Courses.table' DELIMITER ',' CSV HEADER;

COPY TeacherAssignmentsToCourses(courseofferid, teacherid) FROM '/Users/abdullahsaeed/Downloads/tables/TeacherAssignmentsToCourses.table' DELIMITER ',' CSV HEADER;

COPY studentassistants(courseofferid, studentregistrationid) FROM '/Users/abdullahsaeed/Downloads/tables/StudentAssistants.table' DELIMITER ',' CSV HEADER;

COPY courseoffers(courseofferid, courseid, year, quartile) FROM '/Users/abdullahsaeed/Downloads/tables/CourseOffers.table' DELIMITER ',' CSV HEADER;

alter table studentassistants add primary key(courseofferid, studentregistrationid);

alter table courseregistrations add primary key (courseofferid, studentregistrationid);

alter table courseoffers add column coursename varchar(50);

alter table courseoffers add column ects smallint;

alter table courseoffers add column degreeid int;

update courseoffers set coursename = courses.coursename from courses where courseoffers.courseid = courses.courseid;

update courseoffers set ects = courses.ects from courses where courseoffers.courseid = courses.courseid;

update courseoffers set degreeid = courses.degreeid from courses where courseoffers.courseid = courses.courseid;

alter table courseoffers add primary key (courseofferid);

ALTER TABLE studentregistrationstodegrees ADD COLUMN gender char;

alter table studentregistrationstodegrees add column totalects smallint;


update studentregistrationstodegrees set totalects = degrees.totalects from degrees where studentregistrationstodegrees.degreeid = degrees.degreeid;

alter table studentregistrationstodegrees add primary key(studentregistrationid);

UPDATE studentregistrationstodegrees SET gender = (SELECT gender FROM students WHERE studentregistrationstodegrees.studentid = students.studentid);

CREATE TABLE greaterFive AS SELECT  courseregistrations.studentregistrationid, studentid, studentregistrationstodegrees.degreeid, courseName, grade, year, quartile, ects FROM courseregistrations, studentregistrationstodegrees, courseoffers WHERE studentregistrationstodegrees.studentregistrationid = courseregistrations.studentregistrationid AND  grade >= 5 AND courseregistrations.courseofferid = courseoffers.courseofferid;


CREATE TABLE failedcourses AS  SELECT distinct studentregistrationid FROM courseregistrations WHERE grade < 5;

CREATE TABLE studetEcts  AS  SELECT studentregistrationid, SUM(grade) AS totalgrade, SUM(ects) AS totalEcts, SUM(grade * ects) AS gradeects  FROM greaterfive GROUP BY studentregistrationid;
