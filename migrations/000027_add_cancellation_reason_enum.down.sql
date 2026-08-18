ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS chk_ongoing_trips_cancellation_reason;

ALTER TABLE ongoing_trips
    DROP COLUMN IF EXISTS cancellation_note;

ALTER TABLE trip_requests
    DROP CONSTRAINT IF EXISTS chk_trip_requests_cancellation_reason;

ALTER TABLE trip_requests
    DROP COLUMN IF EXISTS cancellation_note;
