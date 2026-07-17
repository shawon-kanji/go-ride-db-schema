CREATE TABLE IF NOT EXISTS trip_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    ride_id UUID NOT NULL,
    rider_id UUID NULL,
    driver_id UUID NULL,
    event_type VARCHAR(64) NOT NULL,
    from_status VARCHAR(40) NULL,
    to_status VARCHAR(40) NULL,
    event_payload JSONB NOT NULL DEFAULT '{}'::jsonb,
    correlation_id VARCHAR(128) NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_trip_history_request FOREIGN KEY (request_id) REFERENCES trip_requests(request_id) ON DELETE CASCADE,
    CONSTRAINT fk_trip_history_rider FOREIGN KEY (rider_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_trip_history_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_trip_history_request_created_at ON trip_history (request_id, created_at);
CREATE INDEX IF NOT EXISTS idx_trip_history_ride_created_at ON trip_history (ride_id, created_at);
CREATE INDEX IF NOT EXISTS idx_trip_history_event_type ON trip_history (event_type);