DROP INDEX IF EXISTS idx_ongoing_trips_vehicle_id;

ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS fk_ongoing_trips_vehicle;

ALTER TABLE ongoing_trips
    DROP COLUMN IF EXISTS vehicle_id;
