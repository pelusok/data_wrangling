/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */
SELECT 
f.name, 
f.membercost
FROM country_club.Facilities f
LIMIT 0 , 30

Facilities that charge a fee: Tennis Court 1, Tennis Court 2, Massage Room 1, Massage Room 2, Squash Court

/* Q2: How many facilities do not charge a fee to members? */
SELECT 
f.name, 
f.membercost
FROM country_club.Facilities f
LIMIT 0 , 30

Facilities that do not charge a fee: 4 total (badminton court, table tennis, snooker table, pool table)

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT f.facid, f.name, f.membercost, f.monthlymaintenance
FROM Facilities f
WHERE f.membercost < f.monthlymaintenance * .20
LIMIT 0 , 30

** this produces a list of all facility member fees being less than 20% of the monthly maintenance
fee per facility


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */
SELECT *
FROM Facilities
WHERE facid
IN ('1', '5')
LIMIT 0 , 30

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance >100
THEN "expensive"
ELSE "cheap"
END
FROM Facilities
LIMIT 0 , 30

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */
SELECT firstname, surname, joindate
FROM Members
WHERE joindate = (
SELECT MAX( joindate )
FROM Members )


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT m.firstname, 
m.surname, 
m.memid, 
f.name, 
m.surname + ' ' + m.firstname + ', ' AS FullName
FROM Members m
JOIN Bookings b ON b.memid = m.memid
JOIN Facilities f ON f.facid = b.facid
WHERE f.name = 'Tennis Court 1'
OR 'Tennis Court 2'
ORDER BY FullName
LIMIT 0 , 30

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT
b.starttime,
m.surname + ', ' + m.firstname AS FullName,
f.name,
f.guestcost + f.membercost * b.slots AS total_cost
FROM Members m
JOIN Bookings b ON m.memid = b.memid
JOIN Facilities f ON f.facid = b.facid
WHERE (starttime BETWEEN '2012-09-14 00:00:00' AND '2012-09-14 23:59:59')
AND (f.guestcost + f.membercost * b.slots) > 30
ORDER BY total_cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */
select 
	name, concat(m.firstname, ' ', m.surname) as member_name 
case when 
	b.memid = 0 then f.guestcost * b.slots
else 
	f.membercost * b.slots 
end as cost
from (select b.memid as bmemid, b.facid, m.firstname, m.surname, b.slots, f.membercost, f.guestcost, b.starttime, member_name from Bookings b 
      join 	facilities f on b.facid = f.facid
      join members m on m.memid = b.memid) as T
WHERE 
	(starttime BETWEEN '2012-09-14 00:00:00' AND '2012-09-14 23:59:59')

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT
f.name,
COUNT(f.membercost + f.guestcost) as total
FROM Facilities f
JOIN Bookings b ON b.facid = f.facid
GROUP BY f.name
