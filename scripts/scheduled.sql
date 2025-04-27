--DO NOT RUN, already running no more runs neccessary
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS add_daily_overdue_fees;

CREATE EVENT add_daily_overdue_fees
ON SCHEDULE 
    EVERY 1 DAY
    STARTS TIMESTAMP(CURRENT_DATE, '18:00:00')
DO
    UPDATE customer c
    SET fees = fees + (
        SELECT 
            COALESCE(SUM(0.25), 0)
        FROM borrows b
        WHERE b.userID = c.userID
          AND b.returnDate IS NULL
          AND b.dueDate < CURDATE()
    );