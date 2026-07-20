DROP INDEX IF EXISTS idx_trip_requests_dispatch_sweep;

ALTER TABLE trip_requests
    DROP COLUMN IF EXISTS next_dispatch_at,
    DROP COLUMN IF EXISTS dispatch_radius_km,
    DROP COLUMN IF EXISTS dispatch_attempt_count;
