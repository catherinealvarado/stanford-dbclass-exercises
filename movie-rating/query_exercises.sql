/* These exercises are from the Stanford SQL course.

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

--Q1: Find the titles of all movies directed by Steven Spielberg.
SELECT m.title
FROM Movie AS m
WHERE m.director = 'Steven Spielberg';

/*Q2: Find all years that have a movie that received a rating of 4 or 5,
and sort them in increasing order.*/
SELECT DISTINCT(m.year)
FROM Movie as m JOIN Rating as r ON m.mID = r.mID
WHERE r.stars = 4 OR r.stars = 5
ORDER BY m.year ASC

--Q3: Find the titles of all movies that have no ratings.
SELECT m.title
FROM Movie as m LEFT JOIN Rating as r ON m.mID = r.mID
WHERE r.stars IS NULL

/*Q4: Some reviewers didn't provide a date with their rating. Find the
names of all reviewers who have ratings with a NULL value for the date.*/
SELECT re.name
FROM Reviewer as re JOIN Rating as r ON re.rID = r.rID
WHERE r.ratingDate IS NULL

/*Q5: Write a query to return the ratings data in a more readable format:
reviewer name, movie title, stars, and ratingDate. Also, sort the data,
first by reviewer name, then by movie title, and lastly by number of stars.*/
SELECT rev.name,m.title,r.stars,r.ratingDate
FROM Reviewer AS rev JOIN Rating AS r ON rev.rID = r.rID
JOIN Movie as m ON r.mID = m.mID
ORDER BY rev.name,m.title,r.stars

/*Q6: For all cases where the same reviewer rated the same movie twice and
gave it a higher rating the second time, return the reviewer's name and
the title of the movie.*/
SELECT rev.name,m.title
FROM (SELECT r1.rID,r1.mID
      FROM Rating AS r1 JOIN Rating AS r2 ON r1.mID = r2.mID
      AND r1.rID = r2.rID AND r1.ratingDate < r2.ratingDate
      WHERE r1.stars < r2.stars) AS reps
      JOIN Reviewer AS rev ON reps.rID = rev.rID
      JOIN Movie AS m ON reps.mID = m.mID

/*Q7: For each movie that has at least one rating, find the highest number
of stars that movie received. Return the movie title and number of stars.
Sort by movie title.*/
SELECT m.title,MAX(r.stars)
FROM Movie AS m JOIN Rating AS r ON m.mID = r.mID
WHERE r.stars > 0
GROUP BY m.mID
ORDER BY m.title

/*Q8: For each movie, return the title and the 'rating spread', that is,
the difference between highest and lowest ratings given to that movie.
Sort by rating spread from highest to lowest, then by movie title.*/
SELECT m.title, MAX(r.stars) - MIN(r.stars) AS diff
FROM Movie AS m JOIN Rating AS r ON m.mID = r.mID
GROUP BY m.mID
ORDER BY diff DESC,m.title

/*Q9: Find the difference between the average rating of movies released
before 1980 and the average rating of movies released after 1980.
(Make sure to calculate the average rating for each movie, then the average
of those averages for movies before 1980 and movies after. Don't just
calculate the overall average rating before and after 1980.)*/
SELECT ABS(AVG(CASE WHEN movie_avgs.year > 1980 THEN movie_avgs.avg_s END)-
           AVG(CASE WHEN movie_avgs.year < 1980 THEN movie_avgs.avg_s END))
FROM (SELECT m.mID, AVG(r.stars) AS avg_s,m.year AS year
      FROM Movie AS m JOIN Rating AS r ON m.mId = r.mID
      GROUP BY m.mID) as movie_avgs
