CREATE VIEW Q1 AS

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