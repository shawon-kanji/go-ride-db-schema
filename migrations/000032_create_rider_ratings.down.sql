ALTER TABLE users
    DROP CONSTRAINT IF EXISTS chk_users_rating_count,
    DROP CONSTRAINT IF EXISTS chk_users_rating_average;

ALTER TABLE users
    DROP COLUMN IF EXISTS rating_count,
    DROP COLUMN IF EXISTS rating_average;

DROP TABLE IF EXISTS rider_ratings;
