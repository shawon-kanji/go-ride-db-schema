ALTER TABLE drivers
    ADD COLUMN is_paused BOOLEAN NOT NULL DEFAULT false;

-- Pause is a sub-state of being online (D08's chip is "distinct from going
-- offline", i.e. a temporary break within a shift, not a shift end) --
-- enforced here so a stray write can't leave a driver paused-but-offline.
ALTER TABLE drivers
    ADD CONSTRAINT chk_drivers_is_paused_requires_online CHECK (NOT is_paused OR is_online);
