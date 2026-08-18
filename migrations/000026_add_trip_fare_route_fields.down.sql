ALTER TABLE trip_fares
    DROP COLUMN IF EXISTS route_polyline,
    DROP COLUMN IF EXISTS route_duration_minutes,
    DROP COLUMN IF EXISTS route_distance_km;
