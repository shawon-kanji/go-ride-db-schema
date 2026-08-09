ALTER TABLE driver_documents
    DROP CONSTRAINT IF EXISTS chk_driver_documents_document_type;

ALTER TABLE driver_documents
    ADD CONSTRAINT chk_driver_documents_document_type CHECK (document_type IN (
        'selfie', 'govt_id_front', 'govt_id_back', 'driving_license_front', 'driving_license_back',
        'vehicle_registration'
    ));
