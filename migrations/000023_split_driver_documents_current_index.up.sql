-- driver_documents.vehicle_id links a vehicle_registration document to a
-- specific vehicle. The original single unique index on (driver_id,
-- document_type) WHERE is_current would block a driver from having current
-- registration documents for two different vehicles at once. Split it into
-- one index for driver-level identity documents (vehicle_id IS NULL) and
-- one for vehicle-level documents, unique per vehicle_id instead of per
-- driver_id.
DROP INDEX IF EXISTS idx_driver_documents_driver_type_current;

CREATE UNIQUE INDEX IF NOT EXISTS idx_driver_documents_driver_type_current
    ON driver_documents (driver_id, document_type)
    WHERE is_current AND vehicle_id IS NULL;

CREATE UNIQUE INDEX IF NOT EXISTS idx_driver_documents_vehicle_type_current
    ON driver_documents (vehicle_id, document_type)
    WHERE is_current AND vehicle_id IS NOT NULL;
