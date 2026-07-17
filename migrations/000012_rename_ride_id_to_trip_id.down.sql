ALTER TABLE trip_history RENAME COLUMN trip_id TO ride_id;
ALTER INDEX IF EXISTS idx_trip_history_trip_created_at RENAME TO idx_trip_history_ride_created_at;

ALTER TABLE driver_job_offers RENAME COLUMN trip_id TO ride_id;

ALTER TABLE ongoing_trips RENAME COLUMN trip_id TO ride_id;
ALTER TABLE ongoing_trips RENAME COLUMN id TO trip_id;

ALTER TABLE trip_requests RENAME COLUMN trip_id TO ride_id;
ALTER INDEX IF EXISTS idx_trip_requests_trip_id RENAME TO idx_trip_requests_ride_id;