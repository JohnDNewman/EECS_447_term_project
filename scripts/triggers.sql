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