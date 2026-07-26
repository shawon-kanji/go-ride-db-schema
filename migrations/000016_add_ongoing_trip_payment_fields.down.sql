ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS chk_ongoing_trips_status;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT chk_ongoing_trips_status
        CHECK (status IN ('assigned', 'driver_arriving', 'in_progress', 'completed', 'cancelled'));

ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS chk_ongoing_trips_payment_status;

ALTER TABLE ongoing_trips
    DROP COLUMN IF EXISTS payment_collected_at,
    DROP COLUMN IF EXISTS payment_status,
    DROP COLUMN IF EXISTS final_fare,
    DROP COLUMN IF EXISTS ended_at;
