SELECT * FROM imdb.movie;

# 1 Count the total number of records in each table of the database


SELECT 'movie' AS table_name, COUNT(*) AS total_records FROM movie
UNION ALL
SELECT 'genre', COUNT(*) FROM genre
UNION ALL
SELECT 'director_mapping', COUNT(*) FROM director_mapping
UNION ALL
SELECT 'role_mapping', COUNT(*) FROM role_mapping
UNION ALL
SELECT 'names', COUNT(*) FROM names
UNION ALL
SELECT 'ratings', COUNT(*) FROM ratings;

# 2 Identify which columns in the movie table contain null values

SELECT 
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_titles,
  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS null_years,
  SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS null_date_published,
  SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_duration,
  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
  SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS null_worlwide_gross_income,
  SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS null_languages,
  SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS null_production_company
FROM movie;

#3 Determine the total number of movies released each year, and analyze how the trend changes
 # month-wise

SELECT 
  year AS release_year, 
  COUNT(*) AS total_movies
FROM movie
GROUP BY year
ORDER BY release_year; 

#3 (2 ) Monthwise releaed

SELECT 
  YEAR(date_published) AS release_year,
  MONTH(date_published) AS release_month,
  COUNT(*) AS total_movies
FROM movie
WHERE date_published IS NOT NULL
GROUP BY release_year, release_month
ORDER BY release_year, release_month;

#4 movie where produced in 2019 in USA OR INDIA

SELECT COUNT(*) AS total_movies_usa_india_2019
FROM movie
WHERE year = 2019
  AND (
    country LIKE '%USA%' 
    OR country LIKE '%India%'
  );
  
  #5 Listing all unique genere uing DISTInCT
  
  SELECT DISTINCT genre 
FROM genre
ORDER BY genre;

#5 (2) COunting the movie that belons to only one genere using movie ID

SELECT COUNT(*) AS movies_with_one_genre
FROM (
  SELECT movie_id
  FROM genre
  GROUP BY movie_id
  HAVING COUNT(*) = 1
) AS single_genre_movies;

# 6 Which genre has the highest total number of movies produced 

SELECT genre, COUNT(*) AS total_movies
FROM genre
GROUP BY genre
ORDER BY total_movies DESC
LIMIT 1;


# 7 Average movie duration for all genre

SELECT 
  g.genre, 
  ROUND(AVG(m.duration), 2) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
WHERE m.duration IS NOT NULL
GROUP BY g.genre
ORDER BY avg_duration DESC;

# 8 

SELECT 
  n.name,
  COUNT(*) AS low_rated_movie_count
FROM role_mapping rm
JOIN ratings r ON rm.movie_id = r.movie_id
JOIN names n ON rm.name_id = n.id
WHERE r.avg_rating < 5
GROUP BY n.name
HAVING COUNT(*) > 3
ORDER BY low_rated_movie_count DESC;

# 9 Finding the Mximum and Minimum vlue of each coloumn

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;

#10 Top 10 movies bassed on rating 

SELECT 
    m.title,
    r.avg_rating
FROM 
    ratings r
JOIN 
    movie m ON r.movie_id = m.id
ORDER BY 
    r.avg_rating DESC
LIMIT 10;

#11 Grouping the movie bassed on their median rating

SELECT 
    median_rating,
    COUNT(*) AS movie_count,
    AVG(avg_rating) AS average_of_avg_rating,
    SUM(total_votes) AS total_votes
FROM 
    ratings
GROUP BY 
    median_rating
ORDER BY 
    median_rating;
    
#12 How mny movies released in 2017 In the USA had more than 1000 votes

SELECT 
    COUNT(*) AS movie_count
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    MONTH(m.date_published) = 3
    AND YEAR(m.date_published) = 2017
    AND m.country LIKE '%USA%'
    AND g.genre = 'SPECIFIC_GENRE'
    AND r.total_votes > 1000;
    
    
   #13  Find movies from each genre that begin with the word “The” and have an average rating
#   greater than 8
   SELECT 
    g.genre,
    m.title,
    r.avg_rating
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
JOIN 
    genre g ON m.id = g.movie_id
WHERE 
    m.title LIKE 'The %'
    AND r.avg_rating > 8
ORDER BY 
    g.genre, r.avg_rating DESC;
    
    
#14 Movies released between 1 aprl 2018 to 1 aprl 2019

SELECT COUNT(*) AS movie_count
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE 
    m.date_published >= '2018-04-01'
    AND m.date_published < '2019-04-02'
    AND r.median_rating = 8;
    
#15 Do German movies receive more votes on average than Italian movies

SELECT 
    country,
    AVG(r.total_votes) AS average_votes
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    country LIKE '%Germany%' OR country LIKE '%Italy%'
GROUP BY 
    country;

#16 Identify the columns in the names table that contain null values

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM 
    names;
#17 Who are the top two actors whose movies have a median rating of 8 or higher
SELECT 
    n.name,
    COUNT(*) AS high_rated_movies
FROM 
    role_mapping rm
JOIN 
    ratings r ON rm.movie_id = r.movie_id
JOIN 
    names n ON rm.name_id = n.id
WHERE 
    rm.category = 'actor'
    AND r.median_rating >= 8
GROUP BY 
    n.name
ORDER BY 
    high_rated_movies DESC
LIMIT 2;

#18 Which are the top three production companies based on the total number of votes their movies received

SELECT 
    m.production_company,
    SUM(r.total_votes) AS total_votes
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.production_company IS NOT NULL
GROUP BY 
    m.production_company
ORDER BY 
    total_votes DESC
LIMIT 3;

#19 How many directors have worked on more than three movies

SELECT COUNT(*) AS director_count
FROM (
    SELECT name_id
    FROM director_mapping
    GROUP BY name_id
    HAVING COUNT(movie_id) > 3
) AS prolific_directors;

#20 Calculate the average height of actors and actresses separately

SELECT 
    category,
    AVG(height) AS average_height
FROM 
    role_mapping rm
JOIN 
    names n ON rm.name_id = n.id
WHERE 
    category IN ('actor', 'actress') AND height IS NOT NULL
GROUP BY 
    category;
    
# 21 List the 10 oldest movies in the dataset along with their title, country, and director
SELECT 
    m.title,
    m.country,
    n.name AS director_name,
    m.year
FROM 
    movie m
JOIN 
    director_mapping dm ON m.id = dm.movie_id
JOIN 
    names n ON dm.name_id = n.id
ORDER BY 
    m.year ASC
LIMIT 10;

#22 List the top 5 movies with the highest total votes, along with their genres

SELECT 
    m.title,
    r.total_votes,
    GROUP_CONCAT(g.genre ORDER BY g.genre SEPARATOR ', ') AS genres
FROM 
    ratings r
JOIN 
    movie m ON r.movie_id = m.id
JOIN 
    genre g ON m.id = g.movie_id
GROUP BY 
    m.id, m.title, r.total_votes
ORDER BY 
    r.total_votes DESC
LIMIT 5;

#23 Identify the movie with the longest duration, along with its genre and production company

SELECT 
    m.title,
    m.duration,
    GROUP_CONCAT(g.genre ORDER BY g.genre SEPARATOR ', ') AS genres,
    m.production_company
FROM 
    movie m
JOIN 
    genre g ON m.id = g.movie_id
WHERE 
    m.duration = (SELECT MAX(duration) FROM movie)
GROUP BY 
    m.id, m.title, m.duration, m.production_company;

# 24 Determine the total number of votes for each movie released in 2018

SELECT 
    m.title,
    r.total_votes
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.year = 2018;
    
# 25 What is the most common language in which movies were produced

SELECT 
    TRIM(SUBSTRING_INDEX(languages, ',', 1)) AS primary_language,
    COUNT(*) AS movie_count
FROM 
    movie
WHERE 
    languages IS NOT NULL
GROUP BY 
    primary_language
ORDER BY 
    movie_count DESC
LIMIT 01;





