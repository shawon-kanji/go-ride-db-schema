DROP INDEX IF EXISTS idx_trip_fares_request_id_null;
DROP INDEX IF EXISTS idx_trip_fares_rider_id;

ALTER TABLE trip_fares DROP CONSTRAINT IF EXISTS fk_trip_fares_rider;

ALTER TABLE trip_fares
    DROP COLUMN IF EXISTS search_radius_km,
    DROP COLUMN IF EXISTS pickup_s2_cell_id,
    DROP COLUMN IF EXISTS pickup_geohash,
    DROP COLUMN IF EXISTS dropoff_lng,
    DROP COLUMN IF EXISTS dropoff_lat,
    DROP COLUMN IF EXISTS pickup_lng,
    DROP COLUMN IF EXISTS pickup_lat,
    DROP COLUMN IF EXISTS rider_id;

-- NOTE: this fails if any trip_fares row has request_id IS NULL (an unconsumed
-- fare-estimate created under the new flow). Clean up orphaned rows before
-- down-migrating past this point.
ALTER TABLE trip_fares ALTER COLUMN request_id SET NOT NULL;
