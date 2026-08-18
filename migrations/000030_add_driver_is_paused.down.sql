ALTER TABLE drivers
    DROP CONSTRAINT IF EXISTS chk_drivers_is_paused_requires_online;

ALTER TABLE drivers
    DROP COLUMN IF EXISTS is_paused;
