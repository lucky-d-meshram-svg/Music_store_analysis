/*	Question Set 1 - Easy */

/* Q1: Who is the senior most employee based on job title? */

SELECT* from employee order by levels desc limit 1;

/* Q2: Which countries have the most Invoices? */

select  billing_country ,count(billing_country) as highest_invoice_C from invoice 
group by billing_country order by highest_invoice_C  desc; 


/* Q3: What are top 3 values of total invoice? */
Select * from invoice order by total desc limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,sum(total) as highest_profitable_city from invoice group by billing_city order by 
highest_profitable_city desc limit 1 ;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select c.Customer_id,c.first_name, c.last_name, i.customer_id, SUM(i.total) as total from invoice i inner join customer c 
on i.Customer_id=c.Customer_id group by c.Customer_id,c.first_name, c.last_name  order by total desc limit 1;

/* Question Set 2 - Moderate */

/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

/*Method 1 */

alter table genre change column name name_ varchar(255);

select distinct cu.email, cu.first_name, cu.last_name, G.name_ from customer Cu inner join invoice iin on iin.Customer_id=cu.customer_id
inner join invoice_line inl on iin.invoice_id=inl.invoice_id inner join track trk on inl.track_id=trk.track_id
inner join genre G on G.genre_id=trk.genre_id where g.name_ like "rock" order by cu.email asc ;

/* Q2: Let's invite the artists who has written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select art.artist_id,art.name_artist,Count(art.artist_id) as highest_producer
 from album_1 al inner join artist art on al.artist_id=art.artist_id 
inner join track tt on tt.album_id=al.album_id inner join genre G on G.genre_id=tt.genre_id 
where g.name_ like "rock"  group by art.artist_id,art.name_artist order by highest_producer desc;

alter table artist change column name name_artist varchar(255);

/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

select name,milliseconds from track where milliseconds > (Select Avg(milliseconds) as longer_than_avg  from track) 
order by milliseconds desc ;

/* Question Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, 
artist name and total spent */

with best_selling_singer as(select art.artist_id as artist_id ,art.name_artist as artist_name,
sum(inl.unit_price*inl.quantity) as total_sales from customer c inner join 
invoice iin on c.Customer_id=iin.Customer_id inner join invoice_line inl on iin.invoice_id=inl.invoice_id
inner join track trk on inl.track_id=trk.track_id inner join album2 al on trk.album_id=al.album_id
inner join artist art on art.artist_id=al.artist_id group by art.artist_id, art.name_artist order by total_sales
 desc limit 5)
select cc.first_name, cc.last_name, bss.artist_name,sum(inll.unit_price*inll.quantity) as best_selling from customer cc inner join 
invoice ii on cc.Customer_id=ii.Customer_id inner join invoice_line inll on inll.invoice_id=ii.invoice_id
inner join track trr on trr.track_id=inll.track_id inner join album2 al2 on trr.album_id=al2.album_id
inner join best_selling_singer bss on bss.artist_id=al2.artist_id
group by cc.first_name, cc.last_name, bss.artist_name
order by best_selling desc limit 10;


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

with popular_genre as(

Select G.name_, c.Country, Count(inl.Quantity)as purchases, g.genre_id, row_number() Over(partition by c.country order by count(inl.Quantity)) 
 as row_no 
from customer c inner join 
invoice iin on c.Customer_id=iin.Customer_id inner join invoice_line inl on iin.invoice_id=inl.invoice_id
inner join track trk on inl.track_id = trk.track_id inner join genre G on g.genre_id = trk.genre_id
group by 1,2,4 order by 2 asc , 3 desc)
 
 select * from popular_genre where row_no = 1;
 
 /* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with recursive Customer_with_country as(
 select c.customer_id, c.first_name, c.last_name,iin.billing_country,sum(iin.total) as toltal_spent
 from customer c inner join invoice iin on 
c.customer_id=iin.customer_id group by 1,2,3,4 order by 1,5 desc),

Contry_spent as( select billing_country, max(toltal_spent) as max_spent from 
Customer_with_country group by billing_country)

select cwc.customer_id, cwc.first_name, cwc.last_name, cs.billing_country, cwc.toltal_spent from
 Customer_with_country cwc inner join
Contry_spent cs on cs.billing_country=cwc.billing_country where cwc.toltal_spent = cs.max_spent order by 4 asc,5 desc ;








use music_database;
select*from album_1;
select*from album2;
select*from artist;
select*from customer;
select*from employee;
select*from genre;
select*from invoice;
select*from invoice_line;
select*from media_type;
select*from playlist;
select*from playlist_track;
select*from track;