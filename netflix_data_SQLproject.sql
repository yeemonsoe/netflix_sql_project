--Netflix Project
Drop Table if exists netflix;
Create Table netflix(
	show_id  Varchar(6),
	type 	 Varchar(10),
	title 	 Varchar(150),
	director Varchar(208),
	casts	 Varchar(1000),
	country  Varchar(150),
	date_added Varchar(50),
	release_year int,
	rating Varchar(10),
	duration Varchar(15),
	listed_in Varchar(100),
	description Varchar(250)
	
);

Select *
From netflix


15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows

Select type, count(*) 
From netflix
Group by type

2. Find the most common rating for movies and TV shows

SELECT
	TYPE,
	RATING
FROM
	(
		SELECT
			TYPE,
			RATING,
			COUNT(*),
			RANK() OVER (
				PARTITION BY
					TYPE
				ORDER BY
					COUNT(*) DESC
			) AS RANKING
		FROM
			NETFLIX
		GROUP BY
			TYPE,
			RATING
	) AS T1
WHERE
	RANKING = 1


3. List all movies released in a specific year (e.g., 2020)

Select type,title 
from netflix
where type = 'Movie' AND release_year = 2020

4. Find the top 5 countries with the most content on Netflix


SELECT
	UNNEST(STRING_TO_ARRAY(COUNTRY, ',')) AS COUNTRY_EDITED,
	COUNT(SHOW_ID) AS TOTAL_CONTENT
FROM
	NETFLIX
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

SELECT
	UNNEST(STRING_TO_ARRAY(COUNTRY, ',')) AS COUNTRY_EDITED
FROM
	NETFLIX

5. Identify the longest movie or TV show duration

Select title, type, duration
From netflix
where type = 'Movie' and duration = (select Max(duration) from netflix)


6. Find content added in the last 5 years


Select *
From netflix
where TO_Date(date_added, 'Month DD, YY')  >=  Current_date - interval '5 years'



7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

Select *
From netflix
Where director ILIKE '%Rajiv Chilaka%'

8. List all TV shows with more than 5 seasons
SELECT
	*
FROM
	NETFLIX
WHERE
	TYPE = 'TV Show'
	AND SPLIT_PART(DURATION, ' ', 1)::NUMERIC > 5

9. Count the number of content items in each genre

SELECT  UNNest(String_To_Array(listed_in, ',')) as genre ,count(show_id) as total_content
FROM
	NETFLIX
Group by 1
order by 2 desc


10. Find the average release year for content produced in a specific country

SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year, country,
count(*)  as yearly_content,
round(
count(*):: numeric /(select  count(*) from netflix where country = 'India'):: numeric*100 
,2
)as average_content
FROM
	NETFLIX
where country = 'India'
group by 1,2

11. List all movies that are documentaries

Select *
FROM
	NETFLIX
where listed_in ILIKE '%documentaries%'

12. Find all content without a director


Select *
FROM
	NETFLIX
where director is Null

13. Find how many movies actor 'Salman Khan' appeared in the last 10 years!


SELECT
	*
FROM
	NETFLIX
WHERE
	CASTS ILIKE '%Salman Khan%'
	AND RELEASE_YEAR > EXTRACT(
		YEAR FROM CURRENT_DATE) - 10;

14. Find the top 10 actors who have appeared in the highest number of movies produced in 'India'

SELECT
	Unnest(String_to_array(casts,','))  as actors, count(*)
FROM
	NETFLIX
where country = 'India'
group by 1
order by 2 desc

15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in
the description field. Label content containing these keywords as 'Bad' and all other
content as 'Good'. Count how many items fall into each category.


With new_table as 
(SELECT
	*,
	CASE
	when 
		description ILIKE '%kill%' 
		OR description ILIKE '%violence%' 
		then 'BAD_Content'
		ELSE 'Good_Content'
	END category
from netflix
)
	
Select  category, count (*) as total_content

FROM new_table
group by 1
