/*
These exercises are from the Stanford SQL course.
Students at your hometown high school have decided to organize their
social network using databases. So far, they have collected information
about sixteen students in four grades, 9-12. Here's the schema:

Highschooler:
(ID,    (High school student with unique ID)
 name,  (First name of student)
 grade  (Student grade level))

Friend:
(ID1,  (Student with ID1 is friends with the student with ID2)
 ID2)  
Note: Friendship is mutual, so if (123, 456) is in the Friend table,
so is (456, 123)

Likes
(ID1, (The student with ID1 likes the student with ID2)
 ID2) 
Note: Liking someone is not necessarily mutual, so if (123, 456) is in the
Likes table, there is no guarantee that (456, 123) is also present. 
*/

/*Q1: Find the names of all students who are friends with someone named
Gabriel.*/
SELECT name
FROM
  (SELECT ID
   FROM Highschooler
   WHERE name = 'Gabriel') gab
JOIN Friend f ON f.ID2 = gab.ID
JOIN Highschooler ON f.ID1 = Highschooler.ID

/*Q3: For every student who likes someone 2 or more grades younger than
themselves, return that student's name and grade, and the name and grade of
the student they like.*/
SELECT h1.name,h1.grade,h2.name,h2.grade
FROM Likes l
JOIN Highschooler h1 ON l.ID1 = h1.ID
JOIN Highschooler h2 ON l.ID2 = h2.ID AND h1.grade - h2.grade >= 2
