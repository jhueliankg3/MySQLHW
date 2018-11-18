-- Use Database
USE sakila;

-- Display first and last name of all actors
SELECT first_name, last_name
FROM actor;

-- Display first and last name of each actor in a single column
SELECT UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name'
FROM actor;

-- Find ID number, first name, and last name of whom you only know the first name "Joe"
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='Joe';

-- Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- Find all actors who last names contain the letters LI
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country IN('Afghanistan', ' Bangladesh', 'China');

-- Create a column in the table actor named description and use data type BLOB
ALTER TABLE actor
ADD COLUMN description BLOB AFTER last_update;

-- Delete description column
ALTER TABLE actor
DROP COLUMN description;

-- List the name of actors, as well as how many actors have that last name
SELECT last_name, COUNT(*) as 'Last Name Count'
FROM actor
GROUP BY last_name;

-- List last names of actors and the number of actors who have that last, but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) as 'Last Name Count'
FROM actor
GROUP BY last_name
HAVING COUNT(*) >=2;

-- The actor HARP WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Fix it
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name= 'GROUCHO' AND last_name='WILLIAMS';

-- Perhaps we were too hasty in changing GROUCHO to HARPO. In a single query change it back
UPDATE actor
SET first_name= 'GROUCHO'
WHERE first_name= 'GROUCHO' AND last_name= 'WILLIAMS';

-- You cannot locate the schema of the address table. How would you recreate it?
SHOW CREATE TABLE address;

-- Use JOIN to display the first and last names, as well as the address of each staff member. 
SELECT first_name, last_name, address
FROM staff INNER JOIN address
ON staff.address_id = address.address_id;

-- Use JOIN to display the total amount rung up by each staff member in August 2005
SELECT first_name, last_name, SUM(amount) as 'Total Amount'
FROM staff INNER JOIN payment
ON staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%'
GROUP BY first_name, last_name;

-- List each film and the number of actors who are listed for that film
SELECT title, COUNT(actor_id) as 'Actor Count'
FROM film_actor INNER JOIN film
on film_actor.film_id = film.film_id
GROUP BY title;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT title, COUNT(title) as 'Copies Available'
FROM film INNER JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';

-- Using the tables payment customer and the JOIN command. List the totals paid by each customer.alter
SELECT first_name, last_name, SUM(amount) as 'Total Paid by Each Customer' 
FROM payment INNER JOIN customer
ON payment.customer_id = customer.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

-- The music of Queen and Kris Kristofferson have seen a recent resurgance. Use subqueries to display the title of movies starties with letters Q and K that are in English
SELECT title
FROM film
WHERE title
LIKE 'K%' OR title LIKE 'Q%'
AND title IN
	(
    SELECT title
    FROM film
    WHERE language_id IN
				(
                SELECT language_id
                FROM language
                WHERE name='English'
                )
		
        );
-- Use subqueries to display all actors who appear in the film Alone Trip
SELECT first_name, last_name
FROM actor
WHERE actor_id IN 
			(
            SELECT actor_id
            FROM film_actor
            WHERE film_id IN 
						(SELECT film_id
                        FROM film
                        WHERE title= 'Alone Trip'
                        )
		);
-- Use JOIN to retrieve names and email address of all Canadian customers
SELECT first_name, last_name, email
FROM customer
JOIN address
ON (customer.address_id = address.address_id)
JOIN city
on (city.city_id = city.country_id)
WHERE country.country= 'Canada';

-- Sales have been lagging among young families and you want start a promotion for family films. Identify all family films
SELECT title
FROM film
WHERE film_id IN
			(
            SELECT film_id
            FROM film_category
            WHERE category_id IN 
						(
                        SELECT category_id
                        FROM category
                        WHERE name = 'Family'
                        )
		);

-- Display the most frequently rented movies in descending order 
SELECT title, COUNT(rental_id) as 'Rental Count'
FROM rental
JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
JOIN film
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;

-- Write a query to display how much business, in dollars, each store brought in
SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment
ON payment.staff_id = staf.staff_id
GROUP BY store.store_id;

-- Write a query to display for each store its ID, city, and country
SELECT store_id, city, country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON city.city_id = address.city_id
INNER JOIN country
ON country.country_id = city.country_id;

-- List the top five genres in gross revenue in descending order
SELECT name, SUM(amount)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;

-- As an executive, you would like to view the top five grossing genres
CREATE VIEW top_revenue_by_genre AS
SELECT name, SUM(amount)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY SUM(amount) DESC LIMIT 5;

-- Display the View
SELECT * FROM top_revenue_by_genre;

-- Write a query to delete the view
DROP VIEW top_revenue_by_genre;


