/*summary SQL answer file*/

/* 1a. You need a list of all the actors’ first name and last name*/


SELECT first_name, last_name
FROM actor;

/* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name*/


SELECT UPPER (CONCAT(first_name, last_name ) )AS actor_name
FROM actor;

/* 2a. You need to find the id, first name, and last name of an actor, of whom you know only the first name of "Joe." What is one query would you use to obtain this information?*/


SELECT actor_id , first_name, last_name
FROM actor
WHERE first_name = 'JOE';


/*2b. Find all actors whose last name contain the letters GEN. Make this case insensitive*/

SELECT actor_id , first_name, last_name
FROM actor
WHERE UPPER (last_name) similar to '%GEN%';

/*2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order. Make this case insensitive.*/

SELECT actor_id , first_name, last_name
FROM actor
WHERE UPPER (last_name) similar to '%LI%'
ORDER BY last_name ASC, first_name ASC;

/*2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China.*/

SELECT country_id, country
FROM country
WHERE country IN  ('Afghanistan', 'Bangladesh','China' );

/*3a. Add a middle_name column to the table actor. Specify the appropriate column type*/

ALTER TABLE actor ADD COLUMN middle_name VARCHAR(255);

/* 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to something that can hold more than varchar.*/
ALTER TABLE actor ADD COLUMN middle_name text;

/* 3c. Now write a query that would remove the middle_name column.*/

ALTER TABLE actor DROP COLUMN middle_name ;

/* 4a. List the last names of actors, as well as how many actors have that last name.*/


SELECT last_name, COUNT(*) AS count_last_name
FROM actor
GROUP BY last_name;


/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors*/

SELECT last_name, COUNT(*) AS count_last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1;


/*4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.*/


UPDATE actor
SET first_name = 'HARPO'
WHERE
 first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

 /*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, 
if the first name of the actor is currently HARPO, change it to GROUCHO. 
Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. */


UPDATE actor
SET first_name = 'MUCHO GROUCHO'
WHERE
 actor_id = 172;

/*6a. Use a JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address: */


SELECT s.first_name, s.last_name, a.address
FROM staff s
LEFT JOIN address a
ON s.address_id  = a.address_id ;

/*6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. Use tables staff and payment.*/

SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_cost
FROM staff s
LEFT JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;

/*6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.*/

SELECT f.film_id, COUNT(fa.actor_id) AS num_actors
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY f.film_id
ORDER BY f.film_id ASC;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

SELECT f.film_id, f.title, COUNT(i.film_id)
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
WHERE UPPER(f.title)='HUNCHBACK IMPOSSIBLE'
GROUP BY f.film_id;

/*6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:*/

SELECT c.customer_id , c.last_name, SUM(p.amount)
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id 
GROUP BY c.customer_id 
ORDER BY c.last_name ASC;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. display the titles of movies starting with the letters K and Q whose language is English.*/


SELECT f.title, f.language_id, l.name
FROM film f
LEFT JOIN language l
ON f.language_id = l.language_id  
WHERE UPPER (f.title) LIKE 'K%'OR  UPPER (f.title) LIKE 'Q%';

/*7b. Use subqueries to display all actors who appear in the film Alone Trip.*/


SELECT alone_trip.title, a.first_name, a.last_name
FROM ( SELECT f.film_id, f.title,fa.actor_id
		FROM film f
		LEFT JOIN film_actor fa
		ON f.film_id = fa.film_id
		WHERE UPPER(f.title)= 'ALONE TRIP' ) AS alone_trip 
LEFT JOIN actor a
ON alone_trip.actor_id = a.actor_id
ORDER BY a.first_name;


/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.*/

WITH cust_address AS 
	( SELECT c.customer_id, c.first_name, c.last_name, c.email, a.address_id, a.city_id
	FROM customer c
	LEFT JOIN address a
	ON c.address_id= a.address_id ),
	city_canada AS (
    SELECT c.city_id, co.country, co.country_id
	FROM city c
	LEFT JOIN country co
	ON c.country_id = co.country_id
	WHERE UPPER(co.country) = 'CANADA')


SELECT ca.first_name, ca.last_name, ca.email, c.country
FROM city_canada c
INNER JOIN cust_address ca
ON ca.city_id = c.city_id;

/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as a family film.
Now we mentioned family film, but there is no family film category. There’s a category that resembles that. In the real world nothing will be exact.*/

WITH film_fam AS 
	( SELECT fc.film_id, c.name
	FROM film_category fc
	LEFT JOIN category c
	ON fc.category_id= c.category_id 
	WHERE UPPER(c.name)= 'FAMILY')


SELECT f.title, fc.name AS category
FROM film_fam fc
INNER JOIN film f
ON fc.film_id = f.film_id;


/* 7e. Display the most frequently rented movies in descending order.*/

WITH rented AS 
	( SELECT r.rental_id, r.inventory_id, i.film_id
	FROM rental r
	LEFT JOIN inventory i
	ON r.inventory_id= i.inventory_id 
	)


SELECT f.title, COUNT(r.rental_id) AS number_rent
FROM rented r
INNER JOIN film f
ON r.film_id = f.film_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;

