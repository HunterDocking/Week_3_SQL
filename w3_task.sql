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
);

