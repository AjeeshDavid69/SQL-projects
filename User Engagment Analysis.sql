


CREATE TABLE Posts (
    post_id SERIAL PRIMARY KEY,
    post_content TEXT,
    post_date TIMESTAMP
);

CREATE TABLE UserReactions (
    reaction_id SERIAL PRIMARY KEY,
    user_id INT,
    post_id INT REFERENCES Posts(post_id),
    reaction_type VARCHAR(20),
    reaction_date TIMESTAMP
);

-- insert values in post
INSERT INTO Posts (post_id, post_content, post_date) VALUES
(1, 'Lorem ipsum dolor sit amet...', '2023-08-25 10:00:00'),
(2, 'Exploring the beauty of nature...', '2023-08-26 15:30:00'),
(3, 'Unveiling the latest tech trends...', '2023-08-27 12:00:00'),
(4, 'Journey into the world of literature...', '2023-08-28 09:45:00'),
(5, 'Capturing the essence of city life...', '2023-08-29 16:20:00');

-- Insert  values in UserReactions
INSERT INTO UserReactions (reaction_id, user_id, post_id, reaction_type, reaction_date) VALUES
(1,  101, 1, 'like',    '2023-08-25 10:15:00'),
(2,  102, 1, 'comment', '2023-08-25 11:30:00'),
(3,  103, 1, 'share',   '2023-08-26 12:45:00'),
(4,  101, 2, 'like',    '2023-08-26 15:45:00'),
(5,  102, 2, 'comment', '2023-08-27 09:20:00'),
(6,  104, 2, 'like',    '2023-08-27 10:00:00'),
(7,  105, 3, 'comment', '2023-08-27 14:30:00'),
(8,  101, 3, 'like',    '2023-08-28 08:15:00'),
(9,  103, 4, 'like',    '2023-08-28 10:30:00'),
(10, 105, 4, 'share',   '2023-08-29 11:15:00'),
(11, 104, 5, 'like',    '2023-08-29 16:30:00'),
(12, 101, 5, 'comment', '2023-08-30 09:45:00');


-- user id counts for like,share,comment
SELECT
    post_id,
    COUNT(*) FILTER (WHERE reaction_type = 'like')    AS total_likes,
    COUNT(*) FILTER (WHERE reaction_type = 'comment') AS total_comments,
    COUNT(*) FILTER (WHERE reaction_type = 'share')   AS total_shares,
    COUNT(*)                                           AS total_reactions
FROM UserReactions
GROUP BY post_id
ORDER BY post_id;


-- AVG no of reactions per user

SELECT
    post_id,
    ROUND(AVG(reaction_count), 2) AS avg_reactions_per_user
FROM (
    SELECT post_id, user_id, COUNT(*) AS reaction_count
    FROM UserReactions
    GROUP BY post_id, user_id
) AS per_user_post_reactions
GROUP BY post_id
ORDER BY post_id;


-- top 3 performing posts

SELECT
  p.post_id,
  p.post_content,
  COUNT(*) FILTER (WHERE ur.reaction_type = 'like') 
     AS total_likes,
  COUNT(*) FILTER (WHERE ur.reaction_type = 'comment') 
  AS total_comments,
    COUNT(*) FILTER (WHERE ur.reaction_type = 'share') 
  AS total_shares,
    COUNT(ur.reaction_id) AS                                   total_reactions
FROM Posts p
JOIN UserReactions ur ON p.post_id = ur.post_id
WHERE ur.reaction_date BETWEEN '2023-08-24' AND '2023-08-31'
GROUP BY p.post_id, p.post_content
ORDER BY total_reactions DESC
LIMIT 3;

