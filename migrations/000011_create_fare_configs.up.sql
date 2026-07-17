CREATE TABLE IF NOT EXISTS fare_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    city_code VARCHAR(32) NOT NULL,
    service_type VARCHAR(32) NOT NULL,
    currency_code VARCHAR(3) NOT NULL,
    base_fare NUMERIC(12, 2) NOT NULL,
    per_km_rate NUMERIC(12, 2) NOT NULL,
    per_minute_rate NUMERIC(12, 2) NOT NULL,
    minimum_fare NUMERIC(12, 2) NOT NULL,
    booking_fee NUMERIC(12, 2) NOT NULL DEFAULT 0,
    cancellation_fee NUMERIC(12, 2) NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    effective_from TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    effective_to TIMESTAMPTZ NULL,
    priority INTEGER NOT NULL DEFAULT 100,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_fare_configs_currency_code CHECK (char_length(currency_code) = 3)
);

CREATE INDEX IF NOT EXISTS idx_fare_configs_city_service_active ON fare_configs (city_code, service_type, is_active);
CREATE INDEX IF NOT EXISTS idx_fare_configs_effective_window ON fare_configs (effective_from, effective_to);
CREATE INDEX IF NOT EXISTS idx_fare_configs_priority ON fare_configs (priority);