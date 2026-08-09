ALTER TABLE drivers
    ADD COLUMN kyc_status VARCHAR(20) NOT NULL DEFAULT 'not_started';

ALTER TABLE drivers
    ADD CONSTRAINT chk_drivers_kyc_status
        CHECK (kyc_status IN ('not_started', 'in_review', 'approved', 'rejected'));
