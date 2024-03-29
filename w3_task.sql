-- Tour(TourName, Description)
--     PRIMARY KEY (TourName)

-- Client(ClientID, Surname, GivenName, Gender)
--     PRIMARY KEY (ClientID)

-- Event(EventYear, EventMonth, EventDay, Fee, TourName)
--     PRIMARY KEY (EventYear, EventMonth, EventDay)
--     FOREIGN KEY (TourName) REFERENCES Tour

-- Booking(DateBooked, Payment, EventYear, EventMonth, EventDay, TourName, ClientID)
--     FOREIGN KEY (EventYear, EventMonth, EventDay, TourName) REFERENCES Event
--     FOREIGN KEY (ClientID) REFERENCES Client

DROP TABLE IF EXISTS dbo.Booking;
DROP TABLE IF EXISTS dbo.Event;
DROP TABLE IF EXISTS dbo.Client;
DROP TABLE IF EXISTS dbo.Tour;


CREATE TABLE Tour(
TourName        NVARCHAR(100) PRIMARY KEY
,Description    NVARCHAR(500)
);

CREATE TABLE Client(
ClientID        INT PRIMARY KEY
,Surname        NVARCHAR(100) NOT NULL
,GivenName      NVARCHAR(100) NOT NULL
,Gender         NVARCHAR(1) CHECK (Gender IN ('M', 'F', 'I')) NULL
);

CREATE TABLE Event(
TourName        NVARCHAR(100) 
,EventMonth     NVARCHAR(3) CHECK (EventMonth IN ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
,EventDay       INT CHECK (EventDay >=1 AND EventDay <=31)
,EventYear      INT CHECK (LEN(EventYear) = 4)
,EventFee       MONEY CHECK (EventFee > 0) NOT NULL
,PRIMARY KEY (TourName, EventMonth, EventDay, EventYear)
,FOREIGN KEY (TourName) REFERENCES Tour
)

CREATE TABLE Booking(
ClientID        INT
,TourName       NVARCHAR(100)
,EventMonth     NVARCHAR(3) CHECK (EventMonth IN ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'))
,EventDay       INT CHECK (EventDay >=1 AND EventDay <=31)
,EventYear      INT CHECK (LEN(EventYear) = 4)
,Payment        MONEY CHECK (Payment > 0) NOT NULL
,DateBooked     DATE NOT NULL
,PRIMARY KEY (ClientID, TourName, EventMonth, EventDay, EventYear)
,FOREIGN KEY (TourName, EventMonth, EventDay, EventYear) REFERENCES Event
,FOREIGN KEY (ClientID) REFERENCES Client
);


INSERT INTO Tour(TourName, Description)
VALUES ('North', 'Tour of wineries and outlets of the Bendigo and Castlemaine region')
,('South', 'Not as extensive of a description')
,('East', 'East side Vagos')
,('West', 'West side Ballas');

INSERT INTO Client(ClientID, Surname, GivenName, Gender)
VALUES (1, 'Price', 'Taylor', 'M')
,(2, 'Carrel', 'Steve', 'M')
,(3, 'Watson', 'Emma', 'F')
,(102145149, 'Docking', 'Hunter', 'M');


INSERT INTO Event(TourName, EventMonth, EventDay, EventYear, EventFee)
VALUES ('North', 'Jan', 9, 2016, 200)
,('North', 'Dec', 23, 2017, 350)
,('West', 'Feb', 1, 2016, 80)
,('South', 'Jul', 30, 2016, 100);

INSERT INTO Booking(ClientID, TourName, EventMonth, EventDay, EventYear, Payment, DateBooked)
VALUES (1, 'North', 'Jan', 9, 2016, 200, '2015-10-12')
,(102145149, 'North', 'Jan', 9, 2016, 200, '2015-06-03')
,(1, 'South', 'Jul', 30, 2016, 100, '2016-05-18')
,(2, 'South', 'Jul', 30, 2016, 200, '2015-12-01')
,(2, 'West', 'Feb', 1, 2016, 80, '2015-12-01');



SELECT * FROM Client



-- QUERY 1
SELECT c.GivenName, c.Surname, t.TourName, t.Description, b.EventYear, b.EventMonth, b.EventDay, e.EventFee, b.DateBooked, b.Payment
FROM Event e

INNER JOIN Tour t
ON t.TourName = e.TourName

INNER JOIN Booking b
ON b.EventYear = e.EventYear
AND b.EventMonth = e.EventMonth
AND b.EventDay = e.EventDay

INNER JOIN Client c
ON c.ClientID = b.ClientID



-- QUERY 2
SELECT EventMonth, TourName, COUNT(ClientID) AS 'Num Bookings'
FROM Booking

GROUP BY EventMonth, TourName



-- QUERY 3
SELECT * FROM Booking
WHERE Payment > (SELECT AVG(Payment) FROM Booking);





-- View for Query 1
SELECT * FROM Q1;





-- Test Queries
-- Q1
SELECT COUNT(*) AS 'Column Count' FROM Booking;
-- As the job of query 1 is to show a lot of information (and at least one piece from each table) 
-- this query checks the table that used the most information (Booking) and checks how many rows it has.
-- If the number is larger than the amount shown in query 1, then query 1 isnt showing enough rows and needs to be modified
-- If the number is smaller than the amount shown in query 1, then query 1 is showing too many rows and duplicates are probabaly being created


-- Q2
SELECT * FROM Booking
ORDER BY EventMonth DESC, TourName ASC;
-- Since query 2 is seeing how many bookings there are for certain events, looking at all of the bookings
-- and manually counting how many of each there are with the same tour name/month and seeing if the count in query 2 has counted them all

-- Q3
SELECT (SUM(Payment) / (Select COUNT(*) From Booking)) as averagePaid FROM Booking
-- By viewing the actual average as a number and not just a condition
-- We can check that the number is below the threshold for our query check