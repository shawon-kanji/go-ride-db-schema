DROP INDEX IF EXISTS idx_driver_documents_vehicle_type_current;
DROP INDEX IF EXISTS idx_driver_documents_driver_type_current;

CREATE UNIQUE INDEX IF NOT EXISTS idx_driver_documents_driver_type_current
    ON driver_documents (driver_id, document_type)
    WHERE is_current;
