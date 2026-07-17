CREATE TABLE IF NOT EXISTS trip_requests (
    request_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ride_id UUID NOT NULL,
    rider_id UUID NOT NULL,
    fare_id UUID NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'search_started',
    pickup_lat DOUBLE PRECISION NOT NULL,
    pickup_lng DOUBLE PRECISION NOT NULL,
    dropoff_lat DOUBLE PRECISION NOT NULL,
    dropoff_lng DOUBLE PRECISION NOT NULL,
    pickup_geohash VARCHAR(32) NOT NULL DEFAULT '',
    pickup_s2_cell_id VARCHAR(32) NOT NULL DEFAULT '',
    search_radius_km DOUBLE PRECISION NOT NULL DEFAULT 20,
    idempotency_key VARCHAR(128) NULL,
    correlation_id VARCHAR(128) NULL,
    requested_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    search_started_at TIMESTAMPTZ NULL,
    assigned_at TIMESTAMPTZ NULL,
    cancelled_at TIMESTAMPTZ NULL,
    timed_out_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_trip_requests_rider FOREIGN KEY (rider_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_trip_requests_status CHECK (status IN ('search_started', 'searching', 'offered', 'driver_accepted', 'driver_rejected', 'timed_out', 'assigned', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_trip_requests_ride_id ON trip_requests (ride_id);
CREATE INDEX IF NOT EXISTS idx_trip_requests_rider_id ON trip_requests (rider_id);
CREATE INDEX IF NOT EXISTS idx_trip_requests_fare_id ON trip_requests (fare_id);
CREATE INDEX IF NOT EXISTS idx_trip_requests_status_created_at ON trip_requests (status, created_at);
CREATE INDEX IF NOT EXISTS idx_trip_requests_requested_at ON trip_requests (requested_at);
CREATE UNIQUE INDEX IF NOT EXISTS idx_trip_requests_rider_idempotency ON trip_requests (rider_id, idempotency_key) WHERE idempotency_key IS NOT NULL;