CREATE DATABASE `eecs` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;

CREATE TABLE `books` (
  `itemID` int(11) NOT NULL,
  `ISBN` bigint(20) unsigned NOT NULL,
  `deweyDecimal` varchar(100) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `author` varchar(100) DEFAULT NULL,
  `genre` varchar(100) DEFAULT NULL,
  `year` date DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `shelved` tinyint(1) NOT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `Books_Rentable_Item_FK` FOREIGN KEY (`itemID`) REFERENCES `rentableItem` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `borrows` (
  `loanID` int(11) NOT NULL,
  `itemID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `loanDate` date NOT NULL,
  `dueDate` date DEFAULT NULL,
  `returnDate` date DEFAULT NULL,
  PRIMARY KEY (`loanID`),
  KEY `Borrows_Rentable_Item_FK` (`itemID`),
  KEY `Borrows_Member_FK` (`userID`),
  CONSTRAINT `Borrows_Member_FK` FOREIGN KEY (`userID`) REFERENCES `member` (`userID`),
  CONSTRAINT `Borrows_Rentable_Item_FK` FOREIGN KEY (`itemID`) REFERENCES `rentableItem` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `CDs` (
  `itemID` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `performingArtists` varchar(100) DEFAULT NULL,
  `distributor` varchar(100) DEFAULT NULL,
  `year` date DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `shelved` tinyint(1) NOT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `CDs_Rentable_Item_FK` FOREIGN KEY (`itemID`) REFERENCES `rentableItem` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `computer` (
  `computerID` int(11) NOT NULL,
  PRIMARY KEY (`computerID`),
  CONSTRAINT `Computer_Rentable_Device_FK` FOREIGN KEY (`computerID`) REFERENCES `rentableDevice` (`deviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `contains` (
  `ID` int(11) NOT NULL,
  `ISSN` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`,`ISSN`),
  KEY `Contains_Newspaper_FK` (`ISSN`),
  CONSTRAINT `Contains_Microfiche_FK` FOREIGN KEY (`ID`) REFERENCES `microfiche` (`deviceID`),
  CONSTRAINT `Contains_Newspaper_FK` FOREIGN KEY (`ISSN`) REFERENCES `newspaper` (`ISSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `customer` (
  `userID` int(11) NOT NULL,
  `fees` float DEFAULT NULL,
  `status` varchar(100) NOT NULL,
  `membershipType` varchar(100) DEFAULT NULL,
  `libraryCardNumber` bigint(20) NOT NULL,
  PRIMARY KEY (`userID`),
  CONSTRAINT `Customer_Member_FK` FOREIGN KEY (`userID`) REFERENCES `member` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `DVDs` (
  `itemID` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `director` varchar(100) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `year` date DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `shelved` tinyint(1) NOT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `DVDs_Rentable_Item_FK` FOREIGN KEY (`itemID`) REFERENCES `rentableItem` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `magazines` (
  `itemID` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `issueNumber` int(11) DEFAULT NULL,
  `publicationDate` date DEFAULT NULL,
  `stock` int(11) NOT NULL,
  `shelved` tinyint(1) NOT NULL,
  PRIMARY KEY (`itemID`),
  CONSTRAINT `Magazines_Rentable_Item_FK` FOREIGN KEY (`itemID`) REFERENCES `rentableItem` (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `member` (
  `userID` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `contactInfo` varchar(100) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `microfiche` (
  `deviceID` int(11) NOT NULL,
  PRIMARY KEY (`deviceID`),
  CONSTRAINT `Microfiche_Rentable_Device_FK` FOREIGN KEY (`deviceID`) REFERENCES `rentableDevice` (`deviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `newspaper` (
  `ISSN` varchar(100) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`ISSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `rentableDevice` (
  `deviceID` int(11) NOT NULL,
  `available` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`deviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `rentableItem` (
  `itemID` int(11) NOT NULL,
  `loanable` tinyint(1) DEFAULT NULL,
  `ageRating` int(11) DEFAULT NULL,
  PRIMARY KEY (`itemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `staffMember` (
  `userID` int(11) NOT NULL,
  `position` varchar(100) NOT NULL,
  `staffID` int(11) NOT NULL,
  PRIMARY KEY (`userID`),
  CONSTRAINT `Staff_member_Member_FK` FOREIGN KEY (`userID`) REFERENCES `member` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE `uses` (
  `userID` int(11) NOT NULL,
  `deviceID` int(11) NOT NULL,
  PRIMARY KEY (`userID`,`deviceID`),
  KEY `Uses_Rentable_Device_FK` (`deviceID`),
  CONSTRAINT `Uses_Member_FK` FOREIGN KEY (`userID`) REFERENCES `member` (`userID`),
  CONSTRAINT `Uses_Rentable_Device_FK` FOREIGN KEY (`deviceID`) REFERENCES `rentableDevice` (`deviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE payment (
    fineID INT AUTO_INCREMENT PRIMARY KEY,
    userID INT NOT NULL,
    paymentValue DECIMAL(10,2) NOT NULL,
    datePayed DATE NOT NULL DEFAULT (CURDATE()),
    FOREIGN KEY (userID) REFERENCES customer(userID)
);
