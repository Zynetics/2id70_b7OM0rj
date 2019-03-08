create materialized view activestudents as (select sr.studentregistrationid from studentregistrationstodegrees sr except select st.studentregistrationid from studentregistrationstodegrees sr, (SELECT  courseRegistrations.studentregistrationid, SUM(case when courseRegistrations.grade >= 5 then courseoffers.ects else 0 end) as total FROM courseregistrations, courseoffers WHERE courseregistrations.courseofferid = courseoffers.courseofferid GROUP BY courseRegistrations.studentregistrationid) as st where st.studentregistrationid = sr.studentregistrationid and st.total >= sr.totalects);

create materialized view studs (courseofferid, total) as (select courseofferid, count(studentregistrationid) from courseregistrations group by courseofferid);

create view assists (courseofferid, total) as (select courseofferid, count(studentregistrationid) from studentassistants group by courseofferid);

create view no as (select co.courseofferid, co.coursename, co.year, co.quartile, total from courseoffers co left join assists on co.courseofferid = assists.courseofferid);

create materialized view GPA as (select a.studentregistrationid, SUM(Case When cr.grade >= 5 Then cr.grade * co.ECTS Else 0 End) :: float/Sum( co.ECTS) as gpa from courseRegistrations cr, activestudents a, courseoffers co where cr.courseofferid = co.courseofferid and a.studentregistrationid = cr.studentregistrationid and cr.grade >= 5 group by a.studentregistrationid);
-- takes about 2 minutes