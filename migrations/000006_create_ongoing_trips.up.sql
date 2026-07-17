CREATE TABLE IF NOT EXISTS ongoing_trips (
    trip_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL UNIQUE,
    ride_id UUID NOT NULL UNIQUE,
    rider_id UUID NOT NULL,
    driver_id UUID NOT NULL,
    status VARCHAR(40) NOT NULL DEFAULT 'assigned',
    pickup_lat DOUBLE PRECISION NOT NULL,
    pickup_lng DOUBLE PRECISION NOT NULL,
    dropoff_lat DOUBLE PRECISION NOT NULL,
    dropoff_lng DOUBLE PRECISION NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMPTZ NULL,
    completed_at TIMESTAMPTZ NULL,
    cancelled_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ongoing_trips_request FOREIGN KEY (request_id) REFERENCES trip_requests(request_id) ON DELETE CASCADE,
    CONSTRAINT fk_ongoing_trips_rider FOREIGN KEY (rider_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_ongoing_trips_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    CONSTRAINT chk_ongoing_trips_status CHECK (status IN ('assigned', 'driver_arriving', 'in_progress', 'completed', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS idx_ongoing_trips_driver_status ON ongoing_trips (driver_id, status);
CREATE INDEX IF NOT EXISTS idx_ongoing_trips_rider_status ON ongoing_trips (rider_id, status);
CREATE INDEX IF NOT EXISTS idx_ongoing_trips_assigned_at ON ongoing_trips (assigned_at);