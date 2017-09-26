PosgreSQL 

This homework assignment is built based on the pagila database. To start this homework, first follow the steps below to create postgreSQL database on your loca file. 

Steps to create pabila database: 
1. Download pagila-0.10.1 folder in this github 
2. in your terminal (mac) run the following commands
3. export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"
4. psql
5. \i pagila-schema.sql
6. \i pagila-data.sql
7. \i pagila-insert-data.sql



Homework questions and answers: 

Below section describes the questions and SQL querries used for the answer.


1a. You need a list of all the actors’ first name and last name

SELECT first_name, last_name
FROM actor;


1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name

SELECT UPPER (CONCAT(first_name, last_name ) )AS actor_name
FROM actor;

2a. You need to find the id, first name, and last name of an actor, of whom you know only the first name of "Joe." What is one query would you use to obtain this information?

SELECT actor_id , first_name, last_name
FROM actor
WHERE first_name = 'JOE';

2b. Find all actors whose last name contain the letters GEN. Make this case insensitive

SELECT actor_id , first_name, last_name
FROM actor
WHERE UPPER (last_name) similar to '%GEN%';


2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order. Make this case insensitive.


SELECT actor_id , first_name, last_name
FROM actor
WHERE UPPER (last_name) similar to '%LI%'
ORDER BY last_name ASC, first_name ASC;

2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China.

SELECT country_id, country
FROM country
WHERE country IN  ('Afghanistan', 'Bangladesh','China' );

3a. Add a middle_name column to the table actor. Specify the appropriate column type

ALTER TABLE actor ADD COLUMN middle_name VARCHAR(255);

3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to something that can hold more than varchar.

ALTER TABLE actor ADD COLUMN middle_name text;

Now we didn’t explicitly cover this in class so exercise your googling skills. 
3c. Now write a query that would remove the middle_name column.

ALTER TABLE actor DROP COLUMN middle_name ;


4a. List the last names of actors, as well as how many actors have that last name.


SELECT last_name, COUNT(*) AS count_last_name
FROM actor
GROUP BY last_name;

4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

SELECT last_name, COUNT(*) AS count_last_name
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >1;

4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE
 first_name = 'GROUCHO' AND last_name = 'WILLIAMS';


4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! 
In a single query, 
if the first name of the actor is currently HARPO, change it to GROUCHO. 
Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. 

UPDATE actor
SET first_name = 'MUCHO GROUCHO'
WHERE
 actor_id = 172;

BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO
(Hint: update the record using a unique identifier.)
5a. 
What’s the difference between a left join and a right join. 
>left join will take all values from left table and join the table that is also in right table together.


https://www.codeproject.com/Articles/33052/Visual-Representation-of-SQL-Joins
ELECT <select_list>
FROM Table_A A
LEFT JOIN Table_B B
ON A.Key = B.Key

What about an inner join and an outer join? 
> Inner join will give the value that is in both left table and right table, where as outer join can also be referred to as a FULL OUTER JOIN or a FULL JOIN. This query will return all of the records from both tables, joining records from the left table (table A) that match records from the right table (table B).




When would you use rank? 
>Rank is used when you want to compare the value of a row with in an order, and assigns the same rank for the same value. Much like in a sports ranking, we have gaps between the different ranks when there is a rank assigned for the same value.


https://blog.jooq.org/2014/08/12/the-difference-between-row_number-rank-and-dense_rank/


What about dense_rank? 
dense_rank is used when there are values that are the same rank, but want to show the true order of the place the column is. When rank can assign the same rank to the same value and assigns gap for those duplicated ranks, dense rank eleminates those gaps.




When would you use a subquery in a select? 
Subquery is used when the value you are selecting is a subset of a query that is written. 



When would you use a right join?
Right join is used when you want to join tables together with all values in right table and any common values that you have and left table together.


When would you use an inner join over an outer join?
Inner join is used when you are querrying a value that is common in both right and left table. outer join is used when you are querrying values that are values of all right and left table.



What’s the difference between a left outer and a left join
LEFT JOIN and LEFT OUTER JOIN are the same.



When would you use a group by?
Group by is used when you want to query results on a specific column values that are grouped by the column specitied.



Describe how you would do data reformatting
Data type can be reformatted using ALTER TABLE function and specify the data type of your choice.



When would you use a with clause?
WITH lets you define "temporary tables" for use in a SELECT query. For example, to calculate changes between two sets:

> example:

WITH x AS (
   SELECT  psp_id
   FROM    global.prospect
   WHERE   status IN ('new', 'reset')
   ORDER   BY request_ts
   LIMIT   1
   ), y AS (
   UPDATE global.prospect psp
   SET    status = status || '*'
   FROM   x
   WHERE  psp.psp_id = x.psp_id
   RETURNING psp.*
   )
INSERT INTO z
SELECT *
FROM   y

bonus: When would you use a self join?

A self-join is a query in which a table is joined (compared) to itself. Self-joins are used to compare values in a column with other values in the same column in the same table. One practical use for self-joins: obtaining running counts and running totals in an SQL query.



6a. Use a JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address
FROM staff s
LEFT JOIN address a
ON s.address_id  = a.address_id ;



6b. Use a JOIN to display the total amount rung up by each staff member in January of 2007. Use tables staff and payment.

SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS total_cost
FROM staff s
LEFT JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;



You’ll have to google for this one, we didn’t cover it explicitly in class. 
6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.


SELECT f.film_id, COUNT(fa.actor_id) AS num_actors
FROM film_actor fa
INNER JOIN film f
ON fa.film_id = f.film_id
GROUP BY f.film_id
ORDER BY f.film_id ASC;

6d. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.film_id, f.title, COUNT(i.film_id)
FROM film f
LEFT JOIN inventory i
ON f.film_id = i.film_id
WHERE UPPER(f.title)='HUNCHBACK IMPOSSIBLE'
GROUP BY f.film_id;


6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. display the titles of movies starting with the letters K and Q whose language is English.
7b. Use subqueries to display all actors who appear in the film Alone Trip.
7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as a family film.
Now we mentioned family film, but there is no family film category. There’s a category that resembles that. In the real world nothing will be exact.
7e. Display the most frequently rented movies in descending order.
7f. Write a query to display how much business, in dollars, each store brought in.
7g. Write a query to display for each store its store ID, city, and country.
7h. List the top five genres in gross revenue in descending order. 
8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
8b. How would you display the view that you created in 8a?
8c. You find that you no longer need the view top_five_genres. Write a query to delete it.