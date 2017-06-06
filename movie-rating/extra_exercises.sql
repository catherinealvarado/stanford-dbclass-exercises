/* These exercises are from the Stanford SQL course.
The same movie rating tables are being used, but the queries
are extra SQL queries from the course.

You've started a new movie-rating website, and you've been collecting data
on reviewers' ratings of various movies.
Here's the schema for each table:

Movie (mID,     (Movie's unique ID)
	     title,   (Title of the movie)
	     year,    (Movie release year)
	     director (Movie director))

Reviewer (rID,  (Movie reviewer ID)
		      name  (Reviewer name))

Rating (rID,    (Reviewer rID)
        mID,    (Movie's unique ID)
	      stars,  (Number of stars rating (1-5) for movie)
	      ratingDate (Date movie was rated))
*/

--Q1: Find the names of all reviewers who rated Gone with the Wind.
SELECT DISTINCT(rev.name)
FROM Movie AS m
JOIN Rating AS R ON m.mID = r.mID
AND m.title = 'Gone with the Wind'
JOIN Reviewer AS rev ON r.rID = rev.rID

/*Q2: For any rating where the reviewer is the same as the director of
the movie, return the reviewer name, movie title, and number of stars. */
SELECT DISTINCT(rev.name),
       m.title,
       r.stars
FROM Movie as m
JOIN Rating AS r ON m.mID = r.mID
JOIN Reviewer AS rev ON r.rID = rev.rID
WHERE m.director = rev.name

/*Q3: Return all reviewer names and movie names together in a single list,
alphabetized. (Sorting by the first name of the reviewer and first word in
the title is fine.)*/
SELECT title
FROM Movie
UNION
SELECT rev.name
FROM Reviewer AS rev
ORDER BY title,rev.name

--Q4: Find the titles of all movies not reviewed by Chris Jackson.
SELECT m.title
FROM Movie as m
WHERE m.mID NOT IN
    (SELECT r.mID
     FROM Rating AS r
     JOIN Reviewer AS rev ON rev.rID = r.rID
     WHERE rev.name = 'Chris Jackson')

/*Q5: For all pairs of reviewers such that both reviewers gave a rating to the
same movie, return the names of both reviewers. Eliminate duplicates, don't
pair reviewers with themselves, and include each pair only once. For each
pair, return the names in the pair in alphabetical order.*/
--First way:
SELECT DISTINCT n1.name,
                n2.name
FROM
  (SELECT rev.rID AS rID,
          rev.name AS name,
          r.mID AS mID
   FROM Rating AS r
   JOIN Reviewer AS rev ON r.rID = rev.rID) AS n1
JOIN
  (SELECT rev.rID AS rID,
          rev.name AS name,
          r.mID AS mID
   FROM Rating AS r
   JOIN Reviewer AS rev ON r.rID = rev.rID) AS n2 ON n1.mID = n2.mID
AND n1.name < n2.name
ORDER BY n1.name,n2.name

--Second way:
SELECT DISTINCT rev1.name,
                rev2.name
FROM Rating AS r1,
     Reviewer AS rev1,
     Rating AS r2,
     Reviewer AS rev2
WHERE r1.mID = r2.mID
  AND r1.rID = rev1.rID
  AND r2.rID = rev2.rID
  AND rev1.name < rev2.name
ORDER BY rev1.name,rev2.name

/*Q6: For each rating that is the lowest (fewest stars) currently in the
database, return the reviewer name, movie title, and number of stars.*/
SELECT rev.name,
       m.title,
       r.stars
FROM
  (SELECT MIN(stars) AS min_s
   FROM Rating) as min
JOIN Rating AS r ON min.min_s = r.stars
JOIN Reviewer AS rev ON r.rID = rev.rID
JOIN Movie AS m ON r.mID = m.mID

/*Q7: List movie titles and average ratings, from highest-rated to
lowest-rated. If two or more movies have the same average rating, list
them in alphabetical order. */
SELECT m.title,
       rat.avg_stars
FROM
  (SELECT mID, AVG(stars) AS avg_stars
   FROM Rating
   GROUP BY mID) as rat
JOIN Movie AS m ON rat.mID = m.mID
ORDER BY rat.avg_stars DESC,m.title

/*Q8: Find the names of all reviewers who have contributed three or more
ratings.*/
SELECT rev.name
FROM Rating AS r
JOIN Reviewer AS rev ON r.rID = rev.rID
GROUP BY r.rID
HAVING COUNT(*) >= 3

/*Q9: Some directors directed more than one movie. For all such directors,
return the titles of all movies directed by them, along with the director
name. Sort by director name, then movie title.*/
SELECT m.title,m.director
FROM
  (SELECT director
   FROM Movie
   GROUP BY director
   HAVING COUNT(mID) > 1) AS extra
JOIN Movie AS m ON extra.director = m.director
ORDER BY m.director, m.title

/*
Find the movie(s) with the highest average rating. Return the movie
title(s) and average rating. (Hint: This query is more difficult to write
in SQLite than other systems; you might think of it as finding the highest
average rating and then choosing the movie(s) with that average rating.)
*/
-- First try:
SELECT m.title,
       max_avg
FROM
  (SELECT MAX(avg) AS max_avg
   FROM (SELECT AVG(stars) AS avg
         FROM Rating
         GROUP BY mID) AS tmp1) AS tmp2
JOIN
  (SELECT mID,AVG(stars) AS avg
   FROM Rating
   GROUP BY mID) AS tmp3 ON tmp3.avg = tmp2.max_avg
JOIN Movie AS m ON tmp3.mID = m.mID

-- Second try:
SELECT m.title,
       AVG(r.stars) AS avg
FROM Movie AS m
JOIN Rating AS r ON m.mID = r.mID
GROUP BY r.mID
HAVING avg =
  (SELECT AVG(stars) AS avg_stars
   FROM Rating
   GROUP BY mID
   ORDER BY avg_stars DESC
   LIMIT 1)

/*
Find the movie(s) with the lowest average rating. Return the movie title(s)
and average rating. (Hint: This query may be more difficult to write in
SQLite than other systems; you might think of it as finding the lowest
average rating and then choosing the movie(s) with that average rating.)
*/
SELECT m.title, AVG(r.stars) AS avg
FROM Movie AS m
JOIN Rating AS r ON m.mID = r.mID
GROUP BY r.mID
HAVING avg =
  (SELECT AVG(stars) AS st
   FROM Rating
   GROUP BY mID
   ORDER BY st ASC
   LIMIT 1)
