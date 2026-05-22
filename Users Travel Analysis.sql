


CREATE TABLE Users (
    users_id INT PRIMARY KEY,
    banned  VARCHAR(3),
    "role"    VARCHAR(10)
);

CREATE TABLE Trips (
    id        SERIAL PRIMARY KEY,
    client_id INT REFERENCES Users(users_id),
    driver_id INT REFERENCES Users(users_id),
    city_id   INT,
    status    VARCHAR(25),
    request_at DATE
);

-- Insert values in users
INSERT INTO Users (users_id, banned, "role") VALUES
(1,  'No',  'client'),
(2,  'Yes', 'client'),
(3,  'No',  'client'),
(4,  'No',  'client'),
(10, 'No',  'driver'),
(11, 'No',  'driver'),
(12, 'No',  'driver'),
(13, 'No',  'driver');

-- Insert Trips
INSERT INTO Trips (id, client_id, driver_id, city_id, status, request_at) VALUES
(1,  1, 10, 1,  'completed',            '2023-07-12'),
(2,  2, 11, 1,  'cancelled_by_driver',  '2023-07-12'),
(3,  3, 12, 6,  'completed',            '2023-07-12'),
(4,  4, 13, 6,  'cancelled_by_client',  '2023-07-12'),
(5,  1, 10, 1,  'completed',            '2023-07-13'),
(6,  2, 11, 6,  'completed',            '2023-07-13'),
(7,  3, 12, 6,  'completed',            '2023-07-13'),
(8,  2, 12, 12, 'completed',            '2023-07-14'),
(9,  3, 10, 12, 'completed',            '2023-07-14'),
(10, 4, 13, 12, 'cancelled_by_driver',  '2023-07-14');


-- cancellation rate

SELECT
    t.request_at AS "day",
    COUNT(*) AS total_requests,
    COUNT(*) FILTER (WHERE t.status != 'completed')AS cancelled_requests,
    ROUND(
    COUNT(*) FILTER (WHERE t.status != 'completed')::DECIMAL
    / COUNT(*), 2
    ) AS cancellation_rate
FROM Trips t
JOIN Users c ON t.client_id = c.users_id AND c.banned = 'No'
JOIN Users d ON t.driver_id = d.users_id AND d.banned = 'No'
GROUP BY t.request_at
ORDER BY t.request_at;

