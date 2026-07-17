CREATE TABLE IF NOT EXISTS driver_job_offers (
    job_offer_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,
    ride_id UUID NOT NULL,
    driver_id UUID NOT NULL,
    offer_rank INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(40) NOT NULL DEFAULT 'pending',
    delivery_status VARCHAR(40) NOT NULL DEFAULT 'pending',
    delivery_attempts INTEGER NOT NULL DEFAULT 0,
    response_reason TEXT NULL,
    correlation_id VARCHAR(128) NULL,
    offered_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMPTZ NOT NULL,
    responded_at TIMESTAMPTZ NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_driver_job_offers_request FOREIGN KEY (request_id) REFERENCES trip_requests(request_id) ON DELETE CASCADE,
    CONSTRAINT fk_driver_job_offers_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    CONSTRAINT chk_driver_job_offers_status CHECK (status IN ('pending', 'accepted', 'rejected', 'expired', 'withdrawn')),
    CONSTRAINT chk_driver_job_offers_delivery_status CHECK (delivery_status IN ('pending', 'sent', 'delivered', 'seen', 'failed'))
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_driver_job_offers_request_driver ON driver_job_offers (request_id, driver_id);
CREATE INDEX IF NOT EXISTS idx_driver_job_offers_driver_status ON driver_job_offers (driver_id, status);
CREATE INDEX IF NOT EXISTS idx_driver_job_offers_request_status ON driver_job_offers (request_id, status);
CREATE INDEX IF NOT EXISTS idx_driver_job_offers_expires_at ON driver_job_offers (expires_at);