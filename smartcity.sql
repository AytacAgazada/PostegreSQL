CREATE TABLE districts (
    district_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE citizens (
    citizen_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    phone_number VARCHAR(15),
    district_id INT REFERENCES districts(district_id)
);

CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    provider_name VARCHAR(100) NOT NULL
);

CREATE TABLE citizen_services (
    citizen_id INT REFERENCES citizens(citizen_id),
    service_id INT REFERENCES services(service_id),
    subscription_date DATE,
    PRIMARY KEY (citizen_id, service_id)
);

CREATE TABLE complaints (
    complaint_id SERIAL PRIMARY KEY,
    citizen_id INT REFERENCES citizens(citizen_id),
    complaint_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN DEFAULT FALSE
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    citizen_id INT REFERENCES citizens(citizen_id),
    service_id INT REFERENCES services(service_id),
    amount DECIMAL(10, 2),
    payment_date DATE
);

-- Districts
INSERT INTO districts (name)
VALUES ('Central'), ('West Side'), ('Green Hills');

-- Citizens
INSERT INTO citizens (full_name, birth_date, phone_number, district_id)
VALUES
('Ali Ahmadov', '1990-05-10', '0501234567', 1),
('Leyla Huseynova', '1985-07-20', '0519876543', 2),
('John Smith', '2000-03-15', '0550001122', 3);

-- Services
INSERT INTO services (service_name, provider_name)
VALUES
('Electricity', 'BakuEnergy'),
('Water', 'AquaNet'),
('Internet', 'FastNet');

-- Citizen Services
INSERT INTO citizen_services (citizen_id, service_id, subscription_date)
VALUES
(1, 1, '2024-01-15'),
(2, 2, '2024-02-10'),
(3, 3, '2024-03-01');

-- Complaints
INSERT INTO complaints (citizen_id, complaint_text, resolved)
VALUES
(1, 'Electricity outage last night', TRUE),
(2, 'Water pressure too low', FALSE);

-- Payments
INSERT INTO payments (citizen_id, service_id, amount, payment_date)
VALUES
(1, 1, 50.00, '2024-04-01'),
(2, 2, 30.00, '2024-04-05'),
(3, 3, 25.00, '2024-04-10');

-- All citizens' full names and phone numbers
SELECT full_name, phone_number FROM citizens;

-- Citizens in a specific district (e.g., West Side)
SELECT full_name FROM citizens WHERE district_id = 2;

-- Citizens in a district born after a date
SELECT full_name FROM citizens WHERE district_id = 1 AND birth_date > '1989-01-01';

-- Citizens in either of two districts
SELECT full_name FROM citizens WHERE district_id = 1 OR district_id = 3;

-- Citizens with no complaints
SELECT * FROM citizens WHERE citizen_id NOT IN (
    SELECT DISTINCT citizen_id FROM complaints
);

-- Retrieve all complaints
SELECT * FROM complaints;

-- Citizens whose names start with 'A' or contain 'ohn'
SELECT * FROM citizens WHERE full_name ILIKE 'A%' OR full_name ILIKE '%ohn%';

-- Exact name match
SELECT * FROM citizens WHERE full_name = 'John Smith';

-- Sort ascending
SELECT * FROM citizens ORDER BY full_name ASC;

-- Sort descending
SELECT * FROM citizens ORDER BY full_name DESC;

-- Distinct service provider names
SELECT DISTINCT provider_name FROM services;

-- Change a citizen's name by ID
UPDATE citizens SET full_name = 'Ali Veli' WHERE citizen_id = 1;

-- Update multiple names with CASE
UPDATE citizens
SET full_name = CASE
    WHEN citizen_id = 2 THEN 'Leyla Aliyeva'
    WHEN citizen_id = 3 THEN 'Jonathan Smith'
    ELSE full_name
END;

-- Add 'email' column
ALTER TABLE citizens ADD COLUMN email VARCHAR(100);

-- Update email with CASE
UPDATE citizens
SET email = CASE
    WHEN citizen_id = 1 THEN 'ali@example.com'
    WHEN citizen_id = 2 THEN 'leyla@example.com'
    WHEN citizen_id = 3 THEN 'john@example.com'
    ELSE NULL
END;

-- Insert new citizen with email
INSERT INTO citizens (full_name, birth_date, phone_number, district_id, email)
VALUES ('Sara Karim', '1995-09-05', '0509998888', 1, 'sara@example.com');

-- Insert an extra complaint
INSERT INTO complaints (citizen_id, complaint_text)
VALUES (1, 'Second complaint about voltage');

-- Complaint count per citizen
SELECT c.full_name, COUNT(cm.complaint_id) AS total_complaints
FROM citizens c
JOIN complaints cm ON c.citizen_id = cm.citizen_id
GROUP BY c.full_name;

-- Citizens with more than 1 complaint
SELECT c.full_name, COUNT(cm.complaint_id) AS total_complaints
FROM citizens c
JOIN complaints cm ON c.citizen_id = cm.citizen_id
GROUP BY c.full_name
HAVING COUNT(cm.complaint_id) > 1;

-- Citizens and their complaints
SELECT c.full_name, cm.complaint_text
FROM citizens c
JOIN complaints cm ON c.citizen_id = cm.citizen_id;

-- DROP TABLE IF EXISTS payments, complaints, citizen_services, services, citizens, districts CASCADE;
