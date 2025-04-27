-- This file contains SQL queries for the library database.

-- OPERATIONAL QUERIES --
-- Adding new staff to the database
INSERT INTO member (userID, name, contactInfo, age)
VALUES (21, 'Srihari', 'smmeyoor@gmail.com', 21);
INSERT INTO staffMember (userID, position, staffID)
VALUES(21, 'Librarian', 2044);

-- Adding new users to the database
INSERT INTO member (userID, name, contactInfo, age)
VALUES (21, 'Srihari', 'smmeyoor@gmail.com', 21);
INSERT INTO customer (userID, fees, status, membershipType, libraryCardNumber)
VALUES (21, 0.0, 'Inactive', 'Bronze', 7764839205);

-- Removing staff
DELETE FROM staffMember WHERE userID = 21;
    -- Optional: Check before saving
SELECT * FROM member WHERE userID = 21;

-- Removing users
DELETE FROM customer WHERE userID = 21;
    -- Optional: Check before saving
SELECT * FROM member WHERE userID = 21;

-- Removing member from the database
    --Will cascade delete from customer and staffMember tables
DELETE FROM member WHERE userid = 21;

-- Adding loanable item entries to support the process of adding new books/movies/etc to the library.
    -- Adding new books to the database
INSERT INTO rentableItem (itemID, loanable, ageRating)
VALUES(9, 1, 10);
INSERT INTO books (itemID, ISBN, deweyDecimal, title, author, genre, `year`, publisher, stock, shelved)
VALUES(9, 9780062316097, '158', 'The Subtle Art of Not Giving a F*ck', 'Mark Manson', 'Self-help', '2016-09-13', 'HarperOne', 2, 1);

    -- Adding new CDs to the database
INSERT INTO rentableItem (itemID, loanable, ageRating)
VALUES(62, 1, 10);
INSERT INTO CDs (itemID, title, performingArtists, distributor, `year`, stock, shelved)
VALUES(62, '21', 'Adele', 'XL Recordings', '2011-01-24', 1, 1);

    -- Adding new DVDs to the database
INSERT INTO rentableItem (itemID, loanable, ageRating)
VALUES(53, 1, 17);
INSERT INTO DVDs (itemID, title, director, publisher, `year`, stock, shelved)
VALUES(53, 'Fight Club', 'David Fincher', '20th Century Fox', '1999-10-15', 2, 1);

    -- Adding new magazines to the database
INSERT INTO rentableItem (itemID, loanable, ageRating)
VALUES(77, 1, 13);
INSERT INTO magazines (itemID, title, issueNumber, publicationDate, stock, shelved)
VALUES(77, 'PC Gamer', 345, '2024-02-01', 3, 1);

    -- Adding new computers to the database
INSERT INTO rentableDevice (deviceID, available)
VALUES(111, 1);
INSERT INTO computer (computerID)
VALUES(111);

    -- Adding new microfiche to the database
INSERT INTO rentableDevice (deviceID, available)
VALUES(101, 1);
INSERT INTO microfiche (deviceID)
VALUES(101);

    -- Adding new newspapers to the database
INSERT INTO newspaper (ISSN, publisher, `date`)
VALUES('2345-6789', 'The Guardian', '2024-01-02');
INSERT INTO `contains` (ID, ISSN)
VALUES(102, '2345-6789');

-- Deleting rentable items from the database
    -- Will cascade delete from other tables
DELETE FROM rentableItem WHERE itemID = 9;

-- Deleting rentable device from the database
    -- Will cascade delete from other tables
DELETE FROM rentableDevice WHERE deviceID = 111;

-- Deleting newspapers from the database
    -- Will cascade delete from other tables
DELETE FROM newspaper WHERE ISSN = '2345-6789';


-- Conventient view to see all items in the library
CREATE VIEW allItems AS
SELECT ri.itemID,
CASE 
	WHEN ri.itemID = ANY(SELECT b.itemID FROM books b) THEN b.title
	WHEN ri.itemID = ANY(SELECT c.itemID FROM CDs c) THEN c.title
	WHEN ri.itemID = ANY(SELECT d.itemID FROM DVDs d) THEN d.title
	WHEN ri.itemID = ANY(SELECT m.itemID FROM magazines m) THEN m.title
END AS title,
CASE 
	WHEN ri.itemID = ANY(SELECT b.itemID FROM books b) THEN "Book"
	WHEN ri.itemID = ANY(SELECT c.itemID FROM CDs c) THEN "CD"
	WHEN ri.itemID = ANY(SELECT d.itemID FROM DVDs d) THEN "DVD"
	WHEN ri.itemID = ANY(SELECT m.itemID FROM magazines m) THEN "Magazine"
END AS 'type'
FROM (rentableItem ri NATURAL LEFT JOIN books b) LEFT JOIN CDs c ON c.itemID = ri.itemID LEFT JOIN DVDs d  ON d.itemID = ri.itemID LEFT JOIN magazines m ON m.itemID = ri.itemID

-- Loan items to customers --Assuming all items are loanable for 2 weeks.
-- check if item is available before loaning through some other query
    -- Determine if the item has stock available in a dbms
INSERT INTO borrows (loanID, itemID, userID, loanDate, dueDate, returnDate)
VALUES(1, 1, 1, CURDATE(), CURDATE() + INTERVAL 2 WEEK, NULL);

-- Return items from customers
UPDATE borrows SET returnDate = CURDATE() WHERE loanID = 1;
UPDATE rentableITEM SET loanable = 1 WHERE itemID = 1;

-- Updating user attributes (fees, loaned items)
-- Updating user fees
INSERT INTO payments (userID, paymentValue) VALUES (8, 137.00);

--Updating user fees with specific date
INSERT INTO payments (userID, paymentValue, datePayed) VALUES (8, 137.00, '2024-04-27');

-- Updating user loaned items is the borrows table

-- Updating item statuses (Loanable / Stock values)
    -- Updating item stock values
UPDATE books SET stock = stock + 1 WHERE itemID = 9;
UPDATE CDs SET stock = stock + 1 WHERE itemID = 62;
UPDATE DVDs SET stock = stock + 1 WHERE itemID = 53;
UPDATE magazines SET stock = stock + 1 WHERE itemID = 77;
    -- Updating item loanable status (1 is available, 0 is not available)
UPDATE rentableItem SET available = 0 WHERE itemID = 9;

-- Updating missing items (check if item has not been returned in x number of days)
SELECT * FROM borrows WHERE returnDate IS NULL AND DATEDIFF(CURDATE(), loanDate) > 30;

-- Update availability of rentable devices
    --For Available
--For Available
DELETE FROM uses WHERE userID = 16 AND deviceID = 110;

--For Unavailable
INSERT INTO uses(userID, deviceID)
VALUES (16, 110);


-- Book availability: Display a list of all available books (not currently borrowed) within a specific genre.
--All available books
SELECT * FROM books WHERE shelved = 1;

--Available books by genre
SELECT * FROM books WHERE shelved = 1 and genre = "Fantasy";


-- Search Book by Phrase
SELECT * FROM books WHERE title LIKE '%Harry%Secrets%';








-- Example Queries:
-- List all currently loaned books
SELECT * FROM borrows

-- List all accounts with an outstanding fine
SELECT * FROM customer WHERE fees > 0;

-- Filter loanable items based on type (book, DVDs, newspaper)
SELECT * FROM books;
SELECT * FROM CDs;
SELECT * FROM DVDs;
SELECT * FROM magazines;

-- Filter books based on year, genre, publisher
SELECT * FROM books WHERE year BETWEEN '1998-01-01' AND '2000-01-01';
SELECT * FROM books WHERE Year(year) BETWEEN 1998 AND 2000;
SELECT * FROM books WHERE genre = 'Fiction';
SELECT * FROM books WHERE publisher = 'HarperCollins';

-- Search for specific item name
SELECT * FROM allItems WHERE title LIKE '%Harry Potter%';

-- Analyze the full list of loans (both active and prior) and identify the most popular items. Include different search filters such as the past week, month, or year.
-- EX for the past 2 years, can change the interval to 1 YEAR, 1 MONTH, 1 WEEK
    -- Most borrows happened in 2024 for some reason so 2 years actually shows all items.
SELECT COUNT(*), ri.itemID,
CASE 
	WHEN ri.itemID = ANY(SELECT b.itemID FROM books b) THEN b.title
	WHEN ri.itemID = ANY(SELECT c.itemID FROM CDs c) THEN c.title
	WHEN ri.itemID = ANY(SELECT d.itemID FROM DVDs d) THEN d.title
	WHEN ri.itemID = ANY(SELECT m.itemID FROM magazines m) THEN m.title
END,
CASE 
	WHEN ri.itemID = ANY(SELECT b.itemID FROM books b) THEN "Book"
	WHEN ri.itemID = ANY(SELECT c.itemID FROM CDs c) THEN "CD"
	WHEN ri.itemID = ANY(SELECT d.itemID FROM DVDs d) THEN "DVD"
	WHEN ri.itemID = ANY(SELECT m.itemID FROM magazines m) THEN "Magazine"
END
FROM (rentableItem ri NATURAL LEFT JOIN books b) LEFT JOIN CDs c ON c.itemID = ri.itemID LEFT JOIN DVDs d  ON d.itemID = ri.itemID LEFT JOIN magazines m ON m.itemID = ri.itemID JOIN borrows b2 on b2.itemID = ri.itemID
WHERE b2.loanDate > NOW()- INTERVAL 2 YEAR GROUP BY itemID ORDER BY COUNT(*) DESC

-- Analyze the database for unpopular items
-- Same as above, but remove descending order.

-- Determine which items are popular by user age
-- This joins the member table and then filters by age.
    -- This is for ages 20-25, can change the age range to any other range.
SELECT COUNT(*), ri.itemID,
CASE 
	WHEN ri.itemID = ANY(SELECT b.itemID FROM books b) THEN b.title
	WHEN ri.itemID = ANY(SELECT c.itemID FROM CDs c) THEN c.title
	WHEN ri.itemID = ANY(SELECT d.itemID FROM DVDs d) THEN d.title
	WHEN ri.itemID = ANY(SELECT m.itemID FROM magazines m) THEN m.title
END,
CASE 
	WHEN ri.itemID = ANY(SELECT b.itemID FROM books b) THEN "Book"
	WHEN ri.itemID = ANY(SELECT c.itemID FROM CDs c) THEN "CD"
	WHEN ri.itemID = ANY(SELECT d.itemID FROM DVDs d) THEN "DVD"
	WHEN ri.itemID = ANY(SELECT m.itemID FROM magazines m) THEN "Magazine"
END
FROM (rentableItem ri NATURAL LEFT JOIN books b) LEFT JOIN CDs c ON c.itemID = ri.itemID LEFT JOIN DVDs d  ON d.itemID = ri.itemID LEFT JOIN magazines m ON m.itemID = ri.itemID JOIN borrows b2 on b2.itemID = ri.itemID JOIN `member` m2 ON m2.userID = b2.userID
WHERE m2.age > 20 AND m2.age < 25 GROUP BY itemID ORDER BY COUNT(*) DESC;

-- Frequent borrowers of a specific genre: Identify the members who have borrowed the most books in a particular genre (e.g., "Mystery") in the last year
SELECT b.userID, m.name, genre, COUNT(*) as borrowCount
FROM borrows b JOIN books bk ON b.itemID = bk.itemID JOIN member m ON b.userID = m.userID
WHERE bk.genre = 'Fiction' GROUP BY userID, genre ORDER BY borrowCount DESC;

-- Books due soon: Generate a report of all items due within the next week, sorted by due date.
SELECT b.userID, m.name, bk.title, b.dueDate
FROM borrows b JOIN books bk ON b.itemID = bk.itemID JOIN member m ON b.userID = m.userID
WHERE b.dueDate BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY ORDER BY b.dueDate;

-- Average borrowing time: Calculate the average number of days members borrow books for a specific genre.
SELECT b.userID, m.name, bk.genre, AVG(DATEDIFF(b.returnDate, b.loanDate)) as avgBorrowTime
FROM borrows b JOIN books bk ON b.itemID = bk.itemID JOIN member m ON b.userID = m.userID
WHERE b.returnDate IS NOT NULL
GROUP BY b.userID, bk.genre ORDER BY b.userID, avgBorrowTime DESC;

-- List all books by a specific author: Display all books in the library collection written by a particular author.
--without author column
SELECT itemID, title, genre, publisher, year, shelved, stock, ISBN, deweyDecimal FROM books WHERE author = "J.K. Rowling";

--with author
SELECT * FROM books WHERE author = "J.K. Rowling";

-- Most popular author in the last month: Determine the author whose books have been borrowed the most in the last month.
SELECT bk.author, COUNT(bk.author) AS authCount
FROM borrows b JOIN books bk ON b.itemID = bk.itemID
WHERE b.loanDate >= CURDATE() - INTERVAL 1 MONTH
GROUP BY bk.author ORDER BY authCount DESC; 

--Find books by publication year: Retrieve a list of books published in a specific year.
--specific year
SELECT * FROM books WHERE year = '1999-06-02'

--books published between year date interval
SELECT * FROM books WHERE year BETWEEN '1998-01-01' AND '2000-01-01';

--between years
SELECT * FROM books WHERE Year(year) BETWEEN 1998 AND 2000;

-- Check membership status: Display the current status and account information for a specific client based on their unique ID
--Membership Type
SELECT membershipType FROM customer WHERE userID = 1;

--Membership Type from Name
SELECT membershipType FROM customer 
WHERE userID = 
(SELECT userID FROM member WHERE name = "Alice Smith");

--All info
SELECT * FROM customer WHERE userID = 1;

--All info
SELECT * FROM customer 
WHERE userID = 
(SELECT userID FROM member WHERE name = "Alice Smith");

-- Fine calculation: Calculate the total fines owed by each member, considering overdue books and a daily fine rate (e.g., $0.25 per day).
    -- calculated by triggers and preset to be accurate
    -- adjusted based on payments as well and its just the fees column for customer table
select userID, fees from customer;


-- Exceeded borrowing limits: Produce a list of clients who have exceeded their borrowing limits.
SELECT 
    m.userID, 
    m.name, 
    c.membershipType, 
    COUNT(b.loanID) AS cb
FROM 
    customer c
JOIN 
    borrows b ON c.userID = b.userID
JOIN 
    member m ON m.userID = c.userID
WHERE 
    b.returnDate IS NULL
GROUP BY 
    m.userID, m.name, c.membershipType
HAVING 
    (c.membershipType = 'Bronze' AND COUNT(b.loanID) > 1)
 OR (c.membershipType = 'Silver' AND COUNT(b.loanID) > 5)
 OR (c.membershipType = 'Gold' AND COUNT(b.loanID) > 10)
ORDER BY 
    cb DESC;

-- Monthly fees report: Generate a report of total fees collected within the last month, broken down by membership type.
-- Pick month and Year
SELECT 
    c.membershipType,
    SUM(p.paymentValue) AS total_collected
FROM 
    payments p
JOIN 
    customer c ON p.userID = c.userID
WHERE 
    YEAR(p.datePayed) = 2025
    AND MONTH(p.datePayed) = 4
GROUP BY 
    c.membershipType
ORDER BY 
    total_collected DESC;
    
    
 -- Generates every payment for the month and orders by membership Type
SELECT 
    c.membershipType,
    p.userID,
    p.paymentValue,
    p.datePayed
FROM 
    payments p
JOIN 
    customer c ON p.userID = c.userID
WHERE 
    YEAR(p.datePayed) = 2025
    AND MONTH(p.datePayed) = 4
ORDER BY 
    c.membershipType ASC, p.datePayed ASC;

-- Frequent borrowed items by client type: Determine the most frequently borrowed items by each client type.
SELECT c.membershipType, ri.itemID, COUNT(ri.itemID) AS borrowCount
FROM borrows b JOIN customer c ON b.userID = c.userID JOIN rentableItem ri ON b.itemID = ri.itemID
GROUP BY c.membershipType, ri.itemID ORDER BY c.membershipType, borrowCount DESC;

-- Never late returns: Find out which clients have never returned an item late.
SELECT c.userID, m.name
FROM customer c JOIN member m ON c.userID = m.userID
WHERE NOT EXISTS (
    SELECT 1 FROM borrows b WHERE b.userID = c.userID AND DATEDIFF(b.returnDate, b.dueDate) > 0
);

-- Average loan duration: Calculate the average time an item stays on loan before being returned.
SELECT ri.itemID, (SELECT ai.title FROM allItems ai WHERE ai.itemID = ri.itemID), AVG(DATEDIFF(b.returnDate, b.loanDate)) AS avgLoanDuration
FROM borrows b JOIN rentableItem ri ON b.itemID = ri.itemID
WHERE b.returnDate IS NOT NULL
GROUP BY ri.itemID ORDER BY avgLoanDuration DESC;

-- Monthly summary report: Generate a report summarizing the total number of items loaned, total fees collected, and the most popular items for the month.
    -- This has total number of loans and total fees for the last month
SELECT COUNT(*) as items_loaned FROM borrows
WHERE YEAR(loanDate) = 2024 AND MONTH(loanDate) = 1
AND
itemID in
(SELECT itemID FROM books
        UNION ALL
        SELECT itemID FROM magazines
        UNION ALL
        SELECT itemID FROM DVDs);

SELECT 
    SUM(p.paymentValue) AS total_fees_paid
FROM 
    payments p
WHERE 
    YEAR(p.datePayed) = 2025
    AND MONTH(p.datePayed) = 4;

SELECT 
    ai.title,
    ai.itemType,
    ai.itemID,
    COUNT(b.itemID) AS borrow_count
FROM 
    borrows b
JOIN 
    (
        SELECT itemID, title, 'Book' AS itemType FROM books
        UNION ALL
        SELECT itemID, title, 'Magazine' AS itemType FROM magazines
        UNION ALL
        SELECT itemID, title, 'DVD' AS itemType FROM DVDs
    ) AS ai ON b.itemID = ai.itemID
WHERE
	YEAR(loanDate) = 2024 AND MONTH(loanDate) = 1
GROUP BY 
   	ai.title, ai.itemType;

-- Statistics breakdown: Break down the statistics by client type and item category (books, digital media, magazines).
--
SELECT 
    c.membershipType,
    ai.itemType,
    COUNT(b.loanID) AS borrow_count
FROM 
    customer c
JOIN 
    borrows b ON c.userID = b.userID
JOIN 
    (
        SELECT itemID, 'Book' AS itemType FROM books
        UNION ALL
        SELECT itemID, 'Magazine' AS itemType FROM magazines
        UNION ALL
        SELECT itemID, 'DVD' AS itemType FROM DVDs
    ) ai ON b.itemID = ai.itemID
GROUP BY 
    c.membershipType,
    ai.itemType
ORDER BY 
    c.membershipType ASC,
    ai.itemType ASC;


-- Client borrowing report: Produce an individual report for each client showing their borrowing history and outstanding fees.
    -- This shows the fees and the membership type of the user
SELECT c.userID, m.name,c.membershipType, c.fees
FROM customer c JOIN member m ON c.userID = m.userID
WHERE c.userID = 1;
    -- This shows the items borrowed by the user and the dates of the loans
SELECT b.itemID, (SELECT ai.title FROM allItems ai WHERE ai.itemID = b.itemID), b.loanDate, b.dueDate, b.returnDate
FROM borrows b JOIN customer c ON b.userID = c.userID JOIN member m ON c.userID = m.userID JOIN rentableItem ri ON b.itemID = ri.itemID
WHERE c.userID = 1;

-- Item availability and history: List all items, their current availability status, and their last borrowed date. Highlight items that have not been borrowed in the past six months.
SELECT ri.itemID, (SELECT ai.title FROM allItems ai WHERE ai.itemID = ri.itemID), ri.loanable, (SELECT (CASE WHEN b.loanDate IS NULL THEN NULL ELSE MAX(b.loanDate) END)) AS last_loaned
FROM rentableItem ri LEFT JOIN borrows b ON ri.itemID = b.itemID
WHERE b.loanDate IS NULL OR b.loanDate < CURDATE() - INTERVAL 6 MONTH -- Change this to whatever time period you want to check for
GROUP BY ri.itemID ORDER BY ri.itemID;

-- Overdue items report: Generate a report listing all overdue items, the client responsible, and the calculated late fees.
    -- Late fees aren't calculated in the database, so this is just the fees we put on the customer table.
SELECT b.itemID, (SELECT ai.title FROM allItems ai WHERE ai.itemID = b.itemID), b.userID, m.name, b.dueDate, DATEDIFF(CURDATE(), b.dueDate) AS overdueDays, c.fees
FROM borrows b JOIN customer c ON b.userID = c.userID JOIN member m ON c.userID = m.userID
WHERE b.returnDate IS NULL AND b.dueDate < CURDATE()
ORDER BY b.itemID;

-- Members with overdue books: List all members who currently have at least one overdue book, along with the titles of the overdue books.(NOT returned yet)
SELECT m.name, b.dueDate, b.returnDate FROM borrows b
JOIN books bk ON b.itemID = bk.itemID
JOIN member m ON m.userID = b.userID
WHERE 
(CURDATE() > dueDate AND returnDate is NULL);

-- Revenue summary: Summarize the library’s revenue from fees, showing the breakdown by membership type and item category
SELECT 
    c.membershipType,
    SUM(p.paymentValue) AS total_revenue
FROM 
    payments p
JOIN 
    customer c ON p.userID = c.userID
WHERE 
    YEAR(p.datePayed) = 2025
    AND MONTH(p.datePayed) = 4
GROUP BY 
    c.membershipType
ORDER BY 
    total_revenue DESC;

SELECT 
    itemDetails.itemType,
    SUM(p.paymentValue) AS total_revenue
FROM 
    payments p
JOIN 
    borrows b ON p.userID = b.userID
JOIN 
    (
        SELECT itemID, 'Book' AS itemType FROM books
        UNION ALL
        SELECT itemID, 'Magazine' AS itemType FROM magazines
        UNION ALL
        SELECT itemID, 'DVD' AS itemType FROM DVDs
    ) AS itemDetails ON b.itemID = itemDetails.itemID
WHERE 
    YEAR(p.datePayed) = 2025
    AND MONTH(p.datePayed) = 4
GROUP BY 
    itemDetails.itemType
ORDER BY 
    total_revenue DESC;

