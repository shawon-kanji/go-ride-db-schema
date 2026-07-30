ALTER TABLE driver_job_offers
    DROP COLUMN IF EXISTS withdrawn_at;

ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS chk_ongoing_trips_cancelled_by;

ALTER TABLE ongoing_trips
    DROP COLUMN IF EXISTS cancelled_by,
    DROP COLUMN IF EXISTS cancellation_reason;

ALTER TABLE trip_requests
    DROP CONSTRAINT IF EXISTS chk_trip_requests_cancelled_by;

ALTER TABLE trip_requests
    DROP COLUMN IF EXISTS cancelled_by,
    DROP COLUMN IF EXISTS cancellation_reason;
