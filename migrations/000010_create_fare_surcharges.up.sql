CREATE TABLE IF NOT EXISTS fare_surcharges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fare_id UUID NOT NULL,
    surcharge_type VARCHAR(64) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    multiplier NUMERIC(8, 4) NULL,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    applied_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fare_surcharges_fare FOREIGN KEY (fare_id) REFERENCES trip_fares(fare_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_fare_surcharges_fare_id ON fare_surcharges (fare_id);
CREATE INDEX IF NOT EXISTS idx_fare_surcharges_type ON fare_surcharges (surcharge_type);