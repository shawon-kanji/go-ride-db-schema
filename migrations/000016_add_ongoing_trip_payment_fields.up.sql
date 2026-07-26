ALTER TABLE ongoing_trips
    ADD COLUMN ended_at TIMESTAMPTZ NULL,
    ADD COLUMN final_fare NUMERIC(12,2) NULL,
    ADD COLUMN payment_status VARCHAR(20) NULL,
    ADD COLUMN payment_collected_at TIMESTAMPTZ NULL;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT chk_ongoing_trips_payment_status
        CHECK (payment_status IS NULL OR payment_status IN ('pending', 'collected'));

ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS chk_ongoing_trips_status;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT chk_ongoing_trips_status
        CHECK (status IN ('assigned', 'driver_arriving', 'in_progress', 'awaiting_payment', 'completed', 'cancelled'));
