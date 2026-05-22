


CREATE TABLE emails (
    id    INT PRIMARY KEY,
    NAME  VARCHAR(25)  NOT NULL,
    email VARCHAR(50)  NOT NULL,
    phone VARCHAR(15)   NOT NULL
);

INSERT INTO emails (id, NAME, email, phone) VALUES
    (1, 'Rahul',  'rahul@example.com',  '9876543210'),
    (2, 'Rohit',  'rohit@example.com',  '8765432109'),
    (3, 'Suresh', 'rahul@example.com',  '7654321098'),
    (4, 'Manish', 'manish@example.com', '6543210987'),
    (5, 'Amit',   'amit@example.com',   '5432109876'),
    (6, 'Rahul',  'rahul@example.com',  '4321098765');

 --Identify duplicate emails 
SELECT email, COUNT(*) AS occurrences, 
       ARRAY_AGG(id ORDER BY id) AS duplicate_ids
FROM emails
GROUP BY email
HAVING COUNT(*) > 1;

--  Remove duplicates 
DELETE FROM emails
WHERE id NOT IN (
    SELECT MIN(id)
    FROM emails
    GROUP BY email
);

-- final output
SELECT * FROM emails ORDER BY id;