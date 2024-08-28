-- Digital Music Store Analysis

-- 11 Tables 
SELECT * FROM album; -- 347 rows
SELECT * FROM artist; -- 247 rows
SELECT * FROM customer; -- 59 rows
SELECT * FROM employee; -- 9 rows
SELECT * FROM genre; -- 25 rows
SELECT * FROM invoice; -- 614 rows
SELECT * FROM invoice_line; -- 4757 rows
SELECT * FROM media_type; -- 5 rows
SELECT * FROM playlist; -- 18 rows
SELECT * FROM playlist_track; -- 8715
SELECT * FROM track; -- 3503 rows

-------------------------------------------------------------------------------------------------

-- Part - 1 

-- Who is the senior most employee based on job title? 
SELECT first_name, last_name, title
FROM employee
	ORDER BY levels DESC
	LIMIT 1; 


-- Which countries have the most Invoices?
SELECT billing_country, COUNT(invoice_id) AS no_of_invoices
FROM invoice
	GROUP BY billing_country
	ORDER BY no_of_invoices DESC
	LIMIT 5;


-- What are top 3 values of total invoice? 
SELECT total AS total
FROM invoice
	ORDER BY total DESC
	LIMIT 3; 


/*
Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice 
totals 
*/
SELECT billing_city, SUM(total) AS sum_invoice_totals
FROM invoice
	GROUP BY billing_city
	ORDER BY sum_invoice_totals DESC
	LIMIT 5; 


/*
Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money 
*/
SELECT cus.customer_id, first_name, last_name, ROUND(CAST(SUM(total) AS INT),2) AS total_spending
FROM invoice inv
	JOIN customer cus
		ON inv.customer_id = cus.customer_id
	GROUP BY cus.customer_id
	ORDER BY total_spending DESC
	LIMIT 5; 


----------------------------------------------------------------------------------------------

-- PART - 2 

/*
Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A
*/
SELECT DISTINCT c.email, c.first_name, c.last_name
FROM customer c
	JOIN invoice i
		ON c.customer_id = i.customer_id
	JOIN invoice_line il
		ON i.invoice_id = il.invoice_id
WHERE il.track_id IN ( SELECT t.track_id
					   FROM track t
							JOIN genre g
								ON t.genre_id = g.genre_id
					   WHERE g.name LIKE 'Rock' )
ORDER BY email ASC;



/*
Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands 
*/
SELECT ar.artist_id, ar.name, COUNT(t.track_id) AS total_track_count
FROM artist ar
	JOIN album al
		ON ar.artist_id = al.artist_id
	JOIN track t
		ON al.album_id = t.album_id
	JOIN genre g 
		ON t.genre_id = g.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY ar.artist_id
ORDER BY total_track_count DESC
LIMIT 5;



/*
Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first
*/
SELECT name, milliseconds
FROM track 
WHERE milliseconds > (	SELECT AVG(milliseconds) AS avg_length
						FROM track  )
ORDER BY milliseconds DESC 
LIMIT 5;


----------------------------------------------------------------------------------------------------------------------

-- PART - 3

/*
Find how much amount spent by each customer on artists? Write a query to return 
customer name, artist name and total spent 
*/
WITH cte_artist AS (
	SELECT ar.artist_id, ar.name, 
		SUM(CAST(il.quantity AS INT) * CAST(il.unit_price AS DECIMAL)) AS total_sales
	FROM artist ar 
		JOIN album al 
			ON ar.artist_id = al.artist_id
		JOIN track tr
			ON al.album_id = tr.album_id
		JOIN invoice_line il
			ON tr.track_id = il.track_id
	GROUP BY ar.artist_id
) 
SELECT cu.customer_id, cu.first_name, cu.last_name, ca.name, 
	SUM(CAST(il.quantity AS INT) * CAST(il.unit_price AS DECIMAL)) AS amount_spent 
FROM customer cu
	JOIN invoice iv
		ON cu.customer_id = iv.customer_id
	JOIN invoice_line il
		ON iv.invoice_id = il.invoice_id
	JOIN track tr
		ON il.track_id = tr.track_id
	JOIN album al 
		ON tr.album_id = al.album_id
	JOIN cte_artist ca
		ON al.artist_id = al.album_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name, ca.name
ORDER BY amount_spent DESC;


/*
We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres 
*/
WITH cte_genre AS (
	SELECT cu.country, gr.name, gr.genre_id,
		COUNT(il.quantity) AS no_of_purchased,
		ROW_NUMBER() OVER(PARTITION BY cu.country ORDER BY COUNT(il.quantity) DESC) AS row_num
	FROM invoice_line il 
		JOIN invoice iv 
			ON il.invoice_id = iv.invoice_id
		JOIN customer cu 
			ON iv.customer_id = cu.customer_id
		JOIN track tr
			ON il.track_id = tr.track_id
		JOIN genre gr
			ON tr.genre_id = gr.genre_id
	GROUP BY cu.country, gr.genre_id, gr.name
	ORDER BY cu.country ASC, no_of_purchased DESC
)
SELECT country, name, no_of_purchased
FROM cte_genre
WHERE row_num < 2;


/*
Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how 
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount 
*/
WITH cte_country AS (
	SELECT cu.customer_id, cu.first_name, cu.last_name, iv.billing_country,
		ROUND(CAST(SUM(total) AS DECIMAL), 2) AS total_spending,
		ROW_NUMBER() OVER(PARTITION BY iv.billing_country ORDER BY SUM(total) DESC) AS row_num
	FROM invoice iv
		JOIN customer cu
			ON iv.customer_id = cu.customer_id 
	GROUP BY cu.customer_id, cu.first_name, cu.last_name, iv.billing_country
	ORDER BY total_spending ASC, row_num DESC
)
SELECT * 
FROM cte_country 
WHERE row_num < 2;  





























