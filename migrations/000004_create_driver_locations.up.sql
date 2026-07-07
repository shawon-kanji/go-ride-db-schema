CREATE TABLE IF NOT EXISTS driver_locations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL UNIQUE,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    geohash VARCHAR(32) NOT NULL,
    s2_cell_id VARCHAR(32) NOT NULL,
    recorded_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_driver_locations_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_driver_locations_geohash ON driver_locations (geohash);
CREATE INDEX IF NOT EXISTS idx_driver_locations_s2_cell_id ON driver_locations (s2_cell_id);
CREATE INDEX IF NOT EXISTS idx_driver_locations_recorded_at ON driver_locations (recorded_at);
