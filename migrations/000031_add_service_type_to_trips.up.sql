-- Three ride tiers, matching R03's actual mockup content (Standard /
-- Standard 6 Seater / Standard Plus) rather than vehicles.category's two
-- values (normal/luxury) -- see go-ride-kafka-consumers' nearestDriversQuery
-- for how a tier maps onto vehicle eligibility (seat_count / category), not
-- a 1:1 rename of the vehicle categories.
ALTER TABLE trip_fares
    ADD COLUMN service_type VARCHAR(32) NOT NULL DEFAULT 'RIDE';

ALTER TABLE trip_fares
    ADD CONSTRAINT chk_trip_fares_service_type CHECK (service_type IN ('RIDE', 'RIDE_XL', 'RIDE_PREMIUM'));

-- Denormalized from the chosen trip_fares row at booking time so dispatch's
-- nearest-driver query can filter by tier without joining back to
-- trip_fares on its hot path (same convention as pickup/dropoff already
-- being duplicated onto trip_requests).
ALTER TABLE trip_requests
    ADD COLUMN service_type VARCHAR(32) NOT NULL DEFAULT 'RIDE';

ALTER TABLE trip_requests
    ADD CONSTRAINT chk_trip_requests_service_type CHECK (service_type IN ('RIDE', 'RIDE_XL', 'RIDE_PREMIUM'));
