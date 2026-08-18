ALTER TABLE trip_requests
    ADD COLUMN cancellation_note TEXT NULL;

ALTER TABLE trip_requests
    ADD CONSTRAINT chk_trip_requests_cancellation_reason
        CHECK (cancellation_reason IS NULL OR cancellation_reason IN (
            'rider_absent', 'rider_requested', 'vehicle_problem', 'unsafe_destination', 'other'
        ));

ALTER TABLE ongoing_trips
    ADD COLUMN cancellation_note TEXT NULL;

ALTER TABLE ongoing_trips
    ADD CONSTRAINT chk_ongoing_trips_cancellation_reason
        CHECK (cancellation_reason IS NULL OR cancellation_reason IN (
            'rider_absent', 'rider_requested', 'vehicle_problem', 'unsafe_destination', 'other'
        ));
