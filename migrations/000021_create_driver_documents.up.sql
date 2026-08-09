CREATE TABLE IF NOT EXISTS driver_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    driver_id UUID NOT NULL,
    vehicle_id UUID NULL,
    document_type VARCHAR(30) NOT NULL,
    file_url TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'uploaded',
    rejection_reason TEXT NULL,
    ai_verdict VARCHAR(20) NULL,
    ai_score NUMERIC(5, 4) NULL,
    ai_checked_at TIMESTAMPTZ NULL,
    is_current BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_driver_documents_driver FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE,
    CONSTRAINT fk_driver_documents_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE CASCADE,
    CONSTRAINT chk_driver_documents_document_type CHECK (document_type IN (
        'selfie', 'govt_id_front', 'govt_id_back', 'driving_license_front', 'driving_license_back', 'vehicle_registration'
    )),
    CONSTRAINT chk_driver_documents_status CHECK (status IN ('uploaded', 'approved', 'rejected'))
);

CREATE INDEX IF NOT EXISTS idx_driver_documents_driver_id ON driver_documents (driver_id);
CREATE INDEX IF NOT EXISTS idx_driver_documents_status ON driver_documents (status);
CREATE UNIQUE INDEX IF NOT EXISTS idx_driver_documents_driver_type_current ON driver_documents (driver_id, document_type) WHERE is_current;
