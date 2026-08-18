ALTER TABLE ongoing_trips
    DROP CONSTRAINT IF EXISTS chk_ongoing_trips_start_pin;

ALTER TABLE ongoing_trips
    DROP COLUMN IF EXISTS start_pin;
