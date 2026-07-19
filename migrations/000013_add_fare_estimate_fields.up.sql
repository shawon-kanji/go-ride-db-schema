-- Allow a trip_fares row to exist before any trip_requests row (fare-estimate step).
-- UNIQUE still allows multiple NULLs, so this keeps the FK/unique guarantee once booked.
ALTER TABLE trip_fares ALTER COLUMN request_id DROP NOT NULL;

-- Make fare-estimate self-contained: carry rider + pickup/dropoff/geo/search-radius
-- on the fare row itself, so /request-cab can look everything up from fare_id alone.
ALTER TABLE trip_fares
    ADD COLUMN rider_id UUID,
    ADD COLUMN pickup_lat DOUBLE PRECISION,
    ADD COLUMN pickup_lng DOUBLE PRECISION,
    ADD COLUMN dropoff_lat DOUBLE PRECISION,
    ADD COLUMN dropoff_lng DOUBLE PRECISION,
    ADD COLUMN pickup_geohash VARCHAR(32) NOT NULL DEFAULT '',
    ADD COLUMN pickup_s2_cell_id VARCHAR(32) NOT NULL DEFAULT '',
    ADD COLUMN search_radius_km DOUBLE PRECISION NOT NULL DEFAULT 20;

-- Existing rows are always request-bound today, so backfill from the
-- linked trip_requests row rather than a placeholder value.
UPDATE trip_fares tf
SET rider_id       = tr.rider_id,
    pickup_lat     = tr.pickup_lat,
    pickup_lng     = tr.pickup_lng,
    dropoff_lat    = tr.dropoff_lat,
    dropoff_lng    = tr.dropoff_lng,
    pickup_geohash = tr.pickup_geohash,
    pickup_s2_cell_id = tr.pickup_s2_cell_id,
    search_radius_km  = tr.search_radius_km
FROM trip_requests tr
WHERE tf.request_id = tr.request_id;

ALTER TABLE trip_fares
    ALTER COLUMN rider_id SET NOT NULL,
    ALTER COLUMN pickup_lat SET NOT NULL,
    ALTER COLUMN pickup_lng SET NOT NULL,
    ALTER COLUMN dropoff_lat SET NOT NULL,
    ALTER COLUMN dropoff_lng SET NOT NULL;

ALTER TABLE trip_fares
    ADD CONSTRAINT fk_trip_fares_rider FOREIGN KEY (rider_id) REFERENCES users(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_trip_fares_rider_id ON trip_fares (rider_id);
CREATE INDEX IF NOT EXISTS idx_trip_fares_request_id_null ON trip_fares (request_id) WHERE request_id IS NULL;
