-- 1. Finding 5 oldest users
SELECT * FROM users
ORDER BY created_at
LIMIT 5;

-- 2. Most Popular Registration Date
SELECT DAYNAME(created_at) AS reg_day, COUNT(*) AS count
FROM users
GROUP BY reg_day
ORDER BY count DESC;

-- 3. Finding Inactive Users (0 photos)
SELECT users.id, users.username 
FROM users LEFT JOIN photos 
ON users.id = photos.user_id 
WHERE photos.id IS NULL;

-- 4. Finding most liked photo

CREATE OR REPLACE VIEW likes_sorted AS
    SELECT 
        photo_id, COUNT(*) AS total_likes
    FROM
        likes
    GROUP BY photo_id
    ORDER BY total_likes DESC;

CREATE OR REPLACE VIEW photo_by_user AS
	SELECT 
		photos.id AS photo_no, photos.image_url as photo_url, users.id AS user_no, users.username AS username
	FROM
		photos
			JOIN
		users ON photos.user_id = users.id
	ORDER BY photo_no;

SELECT 
    photo_id, photo_url, total_likes, username
FROM
    likes_sorted
        JOIN
    photo_by_user ON photo_no = photo_id
ORDER BY total_likes DESC
LIMIT 1;

-- 5. Average posts per user
SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg_posts_per_user;

-- 6. Find top 5 most commonly used hashtags
SELECT 
    tag_name, tag_id, COUNT(*) AS times_tagged
FROM
    photo_tags
        JOIN
    tags ON photo_tags.tag_id = tags.id
GROUP BY tag_id
ORDER BY times_tagged DESC LIMIT 5;

-- 7. Find bots (have liked every single photo)
SELECT 
    user_id, username, COUNT(*) AS photos_liked
FROM
    users
        JOIN
    likes ON users.id = likes.user_id
GROUP BY user_id
HAVING photos_liked = (SELECT COUNT(*) FROM photos)
ORDER BY user_id;