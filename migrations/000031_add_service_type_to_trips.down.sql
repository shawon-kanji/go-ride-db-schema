ALTER TABLE trip_requests
    DROP CONSTRAINT IF EXISTS chk_trip_requests_service_type;

ALTER TABLE trip_requests
    DROP COLUMN IF EXISTS service_type;

ALTER TABLE trip_fares
    DROP CONSTRAINT IF EXISTS chk_trip_fares_service_type;

ALTER TABLE trip_fares
    DROP COLUMN IF EXISTS service_type;
