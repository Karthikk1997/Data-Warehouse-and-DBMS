-- BEREALTY DATABASE

CREATE DATABASE if not exists berealty_db;

USE berealty_db;


-- 1. PROPERTIES

CREATE TABLE PROPERTIES (
    property_id INT PRIMARY KEY,
    property_type VARCHAR(50) NOT NULL,
    street_address VARCHAR(150) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    size_sqft INT,
    bedrooms INT,
    bathrooms INT,
    listing_price DECIMAL(15,2),
    status VARCHAR(30),
    description TEXT
);

INSERT INTO PROPERTIES
(property_id, property_type, street_address, city, postal_code,
 size_sqft, bedrooms, bathrooms, listing_price, status, description)
VALUES
(101, 'Apartment', '12 Alexanderplatz', 'Berlin', '10178',
 850, 2, 1, 425000.00, 'Available',
 'Modern two-bedroom apartment in central Berlin.'),
(102, 'House', '45 Lindenstrasse', 'Berlin', '10969',
 1650, 4, 2, 780000.00, 'Available',
 'Spacious family house with garden.'),
(103, 'Apartment', '8 Kurfurstenstrasse', 'Berlin', '10785',
 720, 2, 1, 390000.00, 'Sold',
 'Renovated apartment close to public transport.'),
(104, 'Commercial', '21 Friedrichstrasse', 'Berlin', '10117',
 2200, 0, 2, 1250000.00, 'Available',
 'Commercial property in a high-demand business district.'),
(105, 'Apartment', '33 Schonhauser Allee', 'Berlin', '10435',
 950, 3, 2, 560000.00, 'Reserved',
 'Large three-bedroom apartment in Prenzlauer Berg.'),
(106, 'House', '17 Gartenstrasse', 'Berlin', '10115',
 1900, 4, 3, 895000.00, 'Available',
 'Detached family home with private garden.'),
(107, 'Apartment', '6 Invalidenstrasse', 'Berlin', '10115',
 680, 1, 1, 315000.00, 'Sold',
 'One-bedroom apartment near Berlin Hauptbahnhof.'),
(108, 'Commercial', '50 Kantstrasse', 'Berlin', '10627',
 3100, 0, 3, 1750000.00, 'Available',
 'Large commercial unit suitable for offices or retail.');


-- 2. AGENTS

CREATE TABLE AGENTS (
    agent_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    hire_date DATE
);

INSERT INTO AGENTS
(agent_id, first_name, last_name, email, phone, hire_date)
VALUES
(201, 'Anna', 'Schmidt', 'anna.schmidt@berealty.de',
 '+49-30-5551001', '2021-03-15'),
(202, 'Markus', 'Weber', 'markus.weber@berealty.de',
 '+49-30-5551002', '2022-06-01'),
(203, 'Sophie', 'Muller', 'sophie.muller@berealty.de',
 '+49-30-5551003', '2020-09-20'),
(204, 'Daniel', 'Fischer', 'daniel.fischer@berealty.de',
 '+49-30-5551004', '2023-01-10'),
(205, 'Laura', 'Becker', 'laura.becker@berealty.de',
 '+49-30-5551005', '2022-11-05');


-- 3. CLIENTS

CREATE TABLE CLIENTS (
    client_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    address VARCHAR(150),
    client_type VARCHAR(30)
);

INSERT INTO CLIENTS
(client_id, first_name, last_name, email, phone, address, client_type)
VALUES
(301, 'Thomas', 'Klein', 'thomas.klein@example.com',
 '+49-170-1110001', 'Berlin, Germany', 'Buyer'),
(302, 'Emma', 'Wagner', 'emma.wagner@example.com',
 '+49-170-1110002', 'Berlin, Germany', 'Buyer'),
(303, 'Lukas', 'Hoffmann', 'lukas.hoffmann@example.com',
 '+49-170-1110003', 'Hamburg, Germany', 'Seller'),
(304, 'Maria', 'Schulz', 'maria.schulz@example.com',
 '+49-170-1110004', 'Berlin, Germany', 'Seller'),
(305, 'Jonas', 'Koch', 'jonas.koch@example.com',
 '+49-170-1110005', 'Potsdam, Germany', 'Buyer'),
(306, 'Clara', 'Richter', 'clara.richter@example.com',
 '+49-170-1110006', 'Berlin, Germany', 'Investor'),
(307, 'Felix', 'Wolf', 'felix.wolf@example.com',
 '+49-170-1110007', 'Berlin, Germany', 'Buyer'),
(308, 'Nina', 'Neumann', 'nina.neumann@example.com',
 '+49-170-1110008', 'Berlin, Germany', 'Investor');


-- 4. TRANSACTIONS

CREATE TABLE TRANSACTIONS (
    transaction_id INT PRIMARY KEY,
    property_id INT NOT NULL,
    agent_id INT NOT NULL,
    transaction_type VARCHAR(30),
    transaction_date DATE,
    amount DECIMAL(15,2),
    status VARCHAR(30),

    CONSTRAINT fk_transaction_property
	FOREIGN KEY (property_id)
	REFERENCES PROPERTIES(property_id),

    CONSTRAINT fk_transaction_agent
	FOREIGN KEY (agent_id)
	REFERENCES AGENTS(agent_id)
);

INSERT INTO TRANSACTIONS
(transaction_id, property_id, agent_id, transaction_type,
 transaction_date, amount, status)
VALUES
(401, 103, 201, 'Sale', '2025-01-15',
 385000.00, 'Completed'),
(402, 107, 202, 'Sale', '2025-02-20',
 310000.00, 'Completed'),
(403, 102, 203, 'Sale', '2025-03-10',
 765000.00, 'Completed'),
(404, 105, 204, 'Sale', '2025-04-05',
 545000.00, 'Pending'),
(405, 101, 201, 'Sale', '2025-05-18',
 420000.00, 'Completed'),
(406, 104, 205, 'Sale', '2025-06-25',
 1200000.00, 'Pending'),
(407, 106, 203, 'Sale', '2025-07-12',
 875000.00, 'Completed'),
(408, 108, 204, 'Sale', '2025-08-30',
 1680000.00, 'Completed');


-- 5. TRANSACTION_PARTIES

CREATE TABLE TRANSACTION_PARTIES (
    transaction_id INT NOT NULL,
    client_id INT NOT NULL,
    party_role VARCHAR(30),

    PRIMARY KEY (transaction_id, client_id),

    CONSTRAINT fk_party_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES TRANSACTIONS(transaction_id),

    CONSTRAINT fk_party_client
        FOREIGN KEY (client_id)
        REFERENCES CLIENTS(client_id)
);

INSERT INTO TRANSACTION_PARTIES
(transaction_id, client_id, party_role)
VALUES
(401, 301, 'Buyer'),
(401, 303, 'Seller'),
(402, 302, 'Buyer'),
(402, 304, 'Seller'),
(403, 305, 'Buyer'),
(403, 303, 'Seller'),
(404, 307, 'Buyer'),
(404, 304, 'Seller'),
(405, 301, 'Buyer'),
(405, 306, 'Seller'),
(406, 308, 'Buyer'),
(406, 304, 'Seller'),
(407, 305, 'Buyer'),
(407, 303, 'Seller'),
(408, 306, 'Buyer'),
(408, 304, 'Seller');


-- 6. PROPERTY_OWNERSHIP

CREATE TABLE PROPERTY_OWNERSHIP (
    property_id INT NOT NULL,
    client_id INT NOT NULL,
    ownership_percentage DECIMAL(5,2),

    PRIMARY KEY (property_id, client_id),

    CONSTRAINT fk_ownership_property
        FOREIGN KEY (property_id)
        REFERENCES PROPERTIES(property_id),

    CONSTRAINT fk_ownership_client
        FOREIGN KEY (client_id)
        REFERENCES CLIENTS(client_id)
);

INSERT INTO PROPERTY_OWNERSHIP
(property_id, client_id, ownership_percentage)
VALUES
(101, 306, 100.00),
(102, 303, 60.00),
(102, 304, 40.00),
(103, 303, 100.00),
(104, 304, 100.00),
(105, 304, 100.00),
(106, 303, 100.00),
(107, 304, 100.00),
(108, 304, 50.00),
(108, 308, 50.00);


SHOW TABLES;

SELECT * FROM AGENTS;

SELECT * FROM CLIENTS;

SELECT * FROM PROPERTIES;

SELECT * FROM PROPERTY_OWNERSHIP;

SELECT * FROM TRANSACTION_PARTIES;

SELECT * FROM TRANSACTIONS;
