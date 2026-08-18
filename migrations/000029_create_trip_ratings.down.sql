ALTER TABLE drivers
    DROP CONSTRAINT IF EXISTS chk_drivers_rating_count,
    DROP CONSTRAINT IF EXISTS chk_drivers_rating_average;

ALTER TABLE drivers
    DROP COLUMN IF EXISTS rating_count,
    DROP COLUMN IF EXISTS rating_average;

DROP TABLE IF EXISTS trip_ratings;
