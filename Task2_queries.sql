-- BEREALTY DATABASE

USE berealty_db;


-- 1. PROPERTIES INFORMATION RETRIEVAL

SELECT property_id, property_type, street_address, city, bedrooms, bathrooms, listing_price, 
status FROM PROPERTIES WHERE status = 'Available'
ORDER BY listing_price ASC;


-- 2. TRANSACTIONS HANDLED BY AGENTS

SELECT t.transaction_id, CONCAT(a.first_name, ' ', a.last_name) AS agent_name, 
t.property_id, t.transaction_type, t.transaction_date, t.amount, t.status
FROM TRANSACTIONS t INNER JOIN AGENTS a ON t.agent_id = a.agent_id ORDER BY t.transaction_date;


-- 3. TRANSACTIONS FOR CLIENTS

SELECT c.client_id, CONCAT(c.first_name, ' ', c.last_name) AS client_name,
tp.party_role, t.transaction_id, t.property_id, t.transaction_date, t.amount, 
t.status FROM CLIENTS c INNER JOIN TRANSACTION_PARTIES tp ON c.client_id = tp.client_id
INNER JOIN TRANSACTIONS t ON tp.transaction_id = t.transaction_id 
ORDER BY c.client_id, t.transaction_date;


-- 4. TRANSACTION HISTORY

SELECT t.transaction_id, p.property_id, p.street_address, t.transaction_type,
t.transaction_date, t.amount, t.status FROM TRANSACTIONS t
INNER JOIN PROPERTIES p ON t.property_id = p.property_id
ORDER BY t.transaction_date DESC;


-- 5. INNER JOIN

SELECT p.property_id, p.street_address, p.property_type, t.transaction_id,
t.transaction_date, t.amount, t.status FROM PROPERTIES p
INNER JOIN TRANSACTIONS t ON p.property_id = t.property_id;


-- 6. LEFT JOIN

SELECT p.property_id, p.street_address, p.property_type, 
t.transaction_id, t.amount, t.status FROM PROPERTIES p
LEFT JOIN TRANSACTIONS t ON p.property_id = t.property_id ORDER BY p.property_id;


-- 7. RIGHT JOIN

SELECT t.transaction_id, t.transaction_date, t.amount, t.status,
p.property_id, p.street_address FROM PROPERTIES p
RIGHT JOIN TRANSACTIONS t ON p.property_id = t.property_id
ORDER BY t.transaction_id;


-- 8. CROSS JOIN

SELECT a.agent_id, CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
pt.property_type FROM AGENTS a
CROSS JOIN (SELECT DISTINCT property_type FROM PROPERTIES) pt
ORDER BY a.agent_id, pt.property_type;


-- 9. COMPLEX JOIN + SUBQUERY

SELECT t.transaction_id, p.street_address,
CONCAT(a.first_name, ' ', a.last_name) AS agent_name, t.amount, t.transaction_date 
FROM TRANSACTIONS t INNER JOIN PROPERTIES p ON t.property_id = p.property_id 
INNER JOIN AGENTS a ON t.agent_id = a.agent_id
WHERE t.status = 'Completed' AND t.amount > (SELECT AVG(amount) FROM TRANSACTIONS)
ORDER BY t.amount DESC;


-- 10. HIGHEST-VALUE TRANSACTION

SELECT t.transaction_id, p.street_address, t.amount, t.transaction_date, t.status
FROM TRANSACTIONS t INNER JOIN PROPERTIES p ON t.property_id = p.property_id
WHERE t.amount = (SELECT MAX(amount) FROM TRANSACTIONS);


-- 11. MONTHLY TRANSACTION REPORT

SELECT YEAR(transaction_date) AS year, MONTH(transaction_date) AS month,
COUNT(transaction_id) AS total_transactions, SUM(amount) AS total_value
FROM TRANSACTIONS GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY year, month;


-- 12. QUARTERLY TRANSACTION REPORT

SELECT YEAR(transaction_date) AS year, QUARTER(transaction_date) AS quarter,
COUNT(transaction_id) AS total_transactions, SUM(amount) AS total_value
FROM TRANSACTIONS GROUP BY YEAR(transaction_date), QUARTER(transaction_date)
ORDER BY year, quarter;


-- 13. YEARLY TRANSACTION REPORT

SELECT YEAR(transaction_date) AS year, 
COUNT(transaction_id) AS total_transactions,
SUM(amount) AS total_value, AVG(amount) AS average_transaction_value
FROM TRANSACTIONS GROUP BY YEAR(transaction_date) ORDER BY year;


-- 14. AGENT PERFORMANCE REPORT

SELECT a.agent_id, CONCAT(a.first_name, ' ', a.last_name) AS agent_name,
COUNT(t.transaction_id) AS total_transactions, 
COALESCE(SUM(t.amount), 0) AS total_transaction_value FROM AGENTS a 
LEFT JOIN TRANSACTIONS t ON a.agent_id = t.agent_id
GROUP BY a.agent_id, a.first_name, a.last_name 
ORDER BY total_transaction_value DESC;


-- 15. PROPERTY OWNERSHIP

SELECT p.property_id, p.street_address,
CONCAT(c.first_name, ' ', c.last_name) AS owner_name, po.ownership_percentage
FROM PROPERTY_OWNERSHIP po
INNER JOIN PROPERTIES p ON po.property_id = p.property_id
INNER JOIN CLIENTS c ON po.client_id = c.client_id
ORDER BY p.property_id;


-- 16. TRIGGER

DROP TRIGGER IF EXISTS update_property_status; 
DELIMITER //

CREATE TRIGGER update_property_status
AFTER UPDATE ON TRANSACTIONS
FOR EACH ROW
BEGIN
  IF NEW.status = 'Completed'
  AND OLD.status <> 'Completed' THEN
  UPDATE PROPERTIES SET status = 'Sold'
  WHERE property_id = NEW.property_id;
  END IF;
END //

DELIMITER ;
SHOW TRIGGERS;

--