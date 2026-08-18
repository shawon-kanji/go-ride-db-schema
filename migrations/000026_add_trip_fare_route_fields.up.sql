ALTER TABLE trip_fares
    ADD COLUMN route_distance_km DOUBLE PRECISION NULL,
    ADD COLUMN route_duration_minutes DOUBLE PRECISION NULL,
    ADD COLUMN route_polyline TEXT NULL;
