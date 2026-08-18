CREATE TABLE IF NOT EXISTS trip_ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ongoing_trip_id UUID NOT NULL,
    rider_id UUID NOT NULL,
    driver_id UUID NOT NULL,
    rating SMALLINT NOT NULL,
    comment TEXT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_trip_ratings_ongoing_trip FOREIGN KEY (ongoing_trip_id) REFERENCES ongoing_trips(id) ON DELETE CASCADE,
    CONSTRAINT fk_trip_ratings_rider FOREIGN KEY (rider_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_trip_ratings_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    CONSTRAINT chk_trip_ratings_rating CHECK (rating BETWEEN 1 AND 5)
);

-- One rating per trip -- also the concurrency guard a duplicate-submit race
-- relies on (ON CONFLICT (ongoing_trip_id) DO NOTHING).
CREATE UNIQUE INDEX IF NOT EXISTS idx_trip_ratings_ongoing_trip ON trip_ratings (ongoing_trip_id);
CREATE INDEX IF NOT EXISTS idx_trip_ratings_driver ON trip_ratings (driver_id);

-- Denormalized onto drivers so R05's "driver card shows a rating" and
-- D11's rating stat tile are a single-row read, not an aggregate query over
-- every trip_ratings row every time. rating_average is NULL (not 0) until
-- a driver's first rating, so the client can render "New driver" instead
-- of a misleading 0.0.
ALTER TABLE drivers
    ADD COLUMN rating_average NUMERIC(3,2) NULL,
    ADD COLUMN rating_count INTEGER NOT NULL DEFAULT 0;

ALTER TABLE drivers
    ADD CONSTRAINT chk_drivers_rating_average CHECK (rating_average IS NULL OR (rating_average >= 1 AND rating_average <= 5)),
    ADD CONSTRAINT chk_drivers_rating_count CHECK (rating_count >= 0);
