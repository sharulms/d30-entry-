#Display the first and last name of each actor in a single column in upper case letters in alphabetic order. Name the column Actor Name.
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS "Actor Name"
FROM actor
ORDER BY "Actor Name";

#2 Find all actors whose last name contain the letters GEN:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';



#3 Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#4  List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS actor_count
FROM actor
GROUP BY last_name
ORDER BY actor_count DESC;

#5List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) AS actor_count
FROM actor
GROUP BY last_name
HAVING COUNT(*) >= 2
ORDER BY actor_count DESC;


#6 The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

#7 Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address

SELECT s.first_name, s.last_name, a.address
FROM staff 
JOIN address a ON s.address_id = a.address_id;

#8 List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT f.title, COUNT(fa.actor_id) AS actor_count
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id
ORDER BY actor_count DESC;

#9  How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(*) AS copy_count
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Hunchback Impossible';


#10 Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_paid
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name, c.first_name;


#11 The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title 
FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%' 
AND film_id IN (
    SELECT film_id 
    FROM language 
    WHERE name = 'English'
);

#12 Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name 
FROM actor 
WHERE actor_id IN (
    SELECT fa.actor_id 
    FROM film_actor fa 
    JOIN film f ON fa.film_id = f.film_id 
    WHERE f.title = 'Alone Trip'
);

#13 You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';


#14 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.
SELECT f.title 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family';

#15 Create a Stored procedure to get the count of films in the input category (IN category_name, OUT count)

DELIMITER //

CREATE PROCEDURE GetFilmCountByCategory(
    IN category_name VARCHAR(255),
    OUT film_count INT
)
BEGIN
    SELECT COUNT(f.film_id) INTO film_count
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = category_name;
END //

DELIMITER ;

#16 Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN rental r ON f.film_id = r.film_id
GROUP BY f.film_id
ORDER BY rental_count DESC;

#17 Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

#18  List the genres and its gross revenue. 

SELECT c.name AS genre, SUM(r.amount) AS gross_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN rental r ON f.film_id = r.film_id
GROUP BY c.name
ORDER BY gross_revenue DESC;


#19 Create a View for the above query(18)

CREATE VIEW GenreGrossRevenue AS
SELECT c.name AS genre, SUM(r.amount) AS gross_revenue
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN rental r ON f.film_id = r.film_id
GROUP BY c.name
ORDER BY gross_revenue DESC;

#20Select top 5  genres in gross revenue view.
SELECT *
FROM GenreGrossRevenue
ORDER BY gross_revenue DESC
LIMIT 5;





