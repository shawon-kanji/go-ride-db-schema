ALTER TABLE ongoing_trips
    ADD COLUMN start_pin VARCHAR(4) NULL;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT chk_ongoing_trips_start_pin
        CHECK (start_pin IS NULL OR start_pin ~ '^[0-9]{4}$');
