ALTER TABLE ongoing_trips
    ADD COLUMN vehicle_id UUID NULL;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT fk_ongoing_trips_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_ongoing_trips_vehicle_id ON ongoing_trips (vehicle_id);
