-- Adds vehicle photo (front/back/side) and number plate as additional
-- vehicle-scoped document_type values. Postgres CHECK constraints must be
-- dropped and recreated to widen their allowed values.
ALTER TABLE driver_documents
    DROP CONSTRAINT IF EXISTS chk_driver_documents_document_type;

ALTER TABLE driver_documents
    ADD CONSTRAINT chk_driver_documents_document_type CHECK (document_type IN (
        'selfie', 'govt_id_front', 'govt_id_back', 'driving_license_front', 'driving_license_back',
        'vehicle_registration', 'vehicle_photo_front', 'vehicle_photo_back', 'vehicle_photo_side',
        'vehicle_number_plate'
    ));
