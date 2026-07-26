CREATE TABLE IF NOT EXISTS vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL,
    plate_number VARCHAR(20) NOT NULL,
    color VARCHAR(50) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    seat_count INTEGER NOT NULL,
    category VARCHAR(20) NOT NULL DEFAULT 'normal',
    is_active BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vehicles_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    CONSTRAINT chk_vehicles_category CHECK (category IN ('normal', 'luxury')),
    CONSTRAINT chk_vehicles_seat_count CHECK (seat_count > 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_vehicles_plate_number ON vehicles (plate_number);
CREATE INDEX IF NOT EXISTS idx_vehicles_driver_id ON vehicles (driver_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_vehicles_driver_active ON vehicles (driver_id) WHERE is_active;
