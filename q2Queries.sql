select 0;
select 0;
select 0;
select 0;
select 0;
select 0;
select sr.degreeid, s.birthyearstudent, sr.gender, avg(gpa.gpa) from activestudents a, studentregistrationstodegrees sr, students s, courseRegistrations cr, gpa where sr.studentregistrationid = a.studentregistrationid and sr.studentid = s.studentid and cr.studentregistrationid = sr.studentregistrationid and sr.studentregistrationid = gpa.studentregistrationid group by cube (sr.degreeid, s.birthyearstudent, sr.gender);
select  coursename, year, quartile from no where total is null union select co.courseofferid, co.coursename, co.year, co.quartile from courseoffers co, assists a, studs s where co.courseofferid = s.courseofferid and co.courseofferid = a.courseofferid and s.total > 50*a.total;