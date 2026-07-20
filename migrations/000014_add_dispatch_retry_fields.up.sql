ALTER TABLE trip_requests
    ADD COLUMN dispatch_attempt_count INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN dispatch_radius_km DOUBLE PRECISION NULL,
    ADD COLUMN next_dispatch_at TIMESTAMPTZ NULL;

CREATE INDEX IF NOT EXISTS idx_trip_requests_dispatch_sweep
    ON trip_requests (next_dispatch_at)
    WHERE next_dispatch_at IS NOT NULL;
