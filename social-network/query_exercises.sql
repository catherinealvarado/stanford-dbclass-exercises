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
