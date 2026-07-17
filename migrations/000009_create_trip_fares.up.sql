CREATE TABLE IF NOT EXISTS trip_fares (
    fare_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL UNIQUE,
    currency_code VARCHAR(3) NOT NULL,
    base_fare NUMERIC(12, 2) NOT NULL DEFAULT 0,
    distance_fare NUMERIC(12, 2) NOT NULL DEFAULT 0,
    time_fare NUMERIC(12, 2) NOT NULL DEFAULT 0,
    surcharge_total NUMERIC(12, 2) NOT NULL DEFAULT 0,
    discount_total NUMERIC(12, 2) NOT NULL DEFAULT 0,
    surge_multiplier NUMERIC(8, 4) NOT NULL DEFAULT 1,
    total_fare NUMERIC(12, 2) NOT NULL DEFAULT 0,
    pricing_version VARCHAR(64) NOT NULL DEFAULT 'v1',
    locked_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_trip_fares_request FOREIGN KEY (request_id) REFERENCES trip_requests(request_id) ON DELETE CASCADE,
    CONSTRAINT chk_trip_fares_currency_code CHECK (char_length(currency_code) = 3),
    CONSTRAINT chk_trip_fares_surge_multiplier CHECK (surge_multiplier >= 1)
);

CREATE INDEX IF NOT EXISTS idx_trip_fares_locked_at ON trip_fares (locked_at);
CREATE INDEX IF NOT EXISTS idx_trip_fares_expires_at ON trip_fares (expires_at);