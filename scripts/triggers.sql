CREATE DEFINER=`eecs447_user`@`%` TRIGGER feesStatus
BEFORE UPDATE ON `customer` FOR EACH ROW
BEGIN
    IF NEW.fees > 20 THEN
        SET NEW.status = 'Inactive';
    ELSEIF NEW.fees <= 20 THEN
        SET NEW.status = 'Active';
    END IF;
END;

CREATE DEFINER=`eecs447_user`@`%` TRIGGER `Availability_Check`
AFTER INSERT ON `uses` FOR EACH ROW
BEGIN
    UPDATE `rentableDevice`
    SET available = 0
    WHERE `deviceID` = NEW.deviceID;
END;

CREATE DEFINER=`eecs447_user`@`%` TRIGGER `Availability_Check_Delete`
AFTER DELETE ON `uses` FOR EACH ROW
BEGIN
    -- Only set to available if the device is not in use anywhere else
    IF NOT EXISTS (
        SELECT 1 FROM `uses`
        WHERE deviceID = OLD.deviceID
    ) THEN
        UPDATE `rentableDevice`
        SET available = 1
        WHERE deviceID = OLD.deviceID;
    END IF;
END;

CREATE DEFINER=`eecs447_user`@`%` TRIGGER `Availability_Check_Update`
AFTER UPDATE ON `uses` FOR EACH ROW
BEGIN
    -- Case 1: If the device is no longer in use (OLD.deviceID != NEW.deviceID)
    IF OLD.deviceID != NEW.deviceID THEN
        -- Set availability to 1 for the old deviceID if it's not in use anymore
        IF NOT EXISTS (
            SELECT 1 FROM `uses`
            WHERE deviceID = OLD.deviceID
        ) THEN
            UPDATE `rentableDevice`
            SET available = 1
            WHERE deviceID = OLD.deviceID;
        END IF;
        
        -- Set availability to 0 for the new deviceID if it's now in use
        UPDATE `rentableDevice`
        SET available = 0
        WHERE deviceID = NEW.deviceID;
    END IF;
END;

CREATE DEFINER=`eecs447_user`@`%` TRIGGER CHECK_AVAILABILITY_ON_RETURN
AFTER UPDATE
ON borrows
FOR EACH ROW
BEGIN
    IF NEW.returnDate IS NOT NULL AND OLD.returnDate IS NULL THEN
 
        UPDATE books
        SET stock = stock + 1,
            shelved = 1
        WHERE itemID = NEW.itemID;
        
        UPDATE magazines
        SET stock = stock + 1,
            shelved = 1
        WHERE itemID = NEW.itemID;
        
        UPDATE DVDs
        SET stock = stock + 1,
            shelved = 1
        WHERE itemID = NEW.itemID;
    
    END IF;
END;

CREATE DEFINER=`eecs447_user`@`%` TRIGGER Check_Item_Availability_On_Insert
AFTER INSERT
ON borrows FOR EACH ROW
BEGIN
    -- Decrease stock first
    UPDATE books
    SET stock = stock - 1
    WHERE itemID = NEW.itemID;
    
    -- Now set shelved based on the updated stock
    UPDATE books
    SET shelved = CASE WHEN stock = 0 THEN 0 ELSE 1 END
    WHERE itemID = NEW.itemID;

    -- Decrease stock first
    UPDATE magazines
    SET stock = stock - 1
    WHERE itemID = NEW.itemID;
    
    -- Now set shelved based on updated stock
    UPDATE magazines
    SET shelved = CASE WHEN stock = 0 THEN 0 ELSE 1 END
    WHERE itemID = NEW.itemID;

    -- Decrease stock first
    UPDATE DVDs
    SET stock = stock - 1
    WHERE itemID = NEW.itemID;
    
    -- Now set shelved based on updated stock
    UPDATE DVDs
    SET shelved = CASE WHEN stock = 0 THEN 0 ELSE 1 END
    WHERE itemID = NEW.itemID;
END;

CREATE DEFINER=`eecs447_user`@`%` TRIGGER update_customer_fees_after_insert
AFTER INSERT
ON payments
FOR EACH ROW
BEGIN
    UPDATE customer
    SET fees = CASE
                  WHEN fees - NEW.paymentValue < 0 THEN 0
                  ELSE fees - NEW.paymentValue
               END
    WHERE userID = NEW.userID;
END;