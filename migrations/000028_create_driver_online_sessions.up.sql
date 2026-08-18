CREATE TABLE IF NOT EXISTS driver_online_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_driver_online_sessions_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    CONSTRAINT chk_driver_online_sessions_ended_after_started CHECK (ended_at IS NULL OR ended_at >= started_at)
);

CREATE INDEX IF NOT EXISTS idx_driver_online_sessions_driver_started ON driver_online_sessions (driver_id, started_at);

-- At most one open (ended_at IS NULL) session per driver at a time -- also
-- doubles as the concurrency guard an online-toggle race relies on (ON
-- CONFLICT (driver_id) WHERE ended_at IS NULL DO NOTHING), same
-- partial-unique-index pattern as vehicles.idx_vehicles_driver_active.
CREATE UNIQUE INDEX IF NOT EXISTS idx_driver_online_sessions_driver_open ON driver_online_sessions (driver_id) WHERE ended_at IS NULL;
