ALTER TABLE trip_requests
    ADD COLUMN cancellation_reason TEXT NULL,
    ADD COLUMN cancelled_by VARCHAR(20) NULL;

ALTER TABLE trip_requests
    ADD CONSTRAINT chk_trip_requests_cancelled_by
        CHECK (cancelled_by IS NULL OR cancelled_by IN ('rider', 'driver', 'system'));

ALTER TABLE ongoing_trips
    ADD COLUMN cancellation_reason TEXT NULL,
    ADD COLUMN cancelled_by VARCHAR(20) NULL;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT chk_ongoing_trips_cancelled_by
        CHECK (cancelled_by IS NULL OR cancelled_by IN ('rider', 'driver', 'system'));

ALTER TABLE driver_job_offers
    ADD COLUMN withdrawn_at TIMESTAMPTZ NULL;
