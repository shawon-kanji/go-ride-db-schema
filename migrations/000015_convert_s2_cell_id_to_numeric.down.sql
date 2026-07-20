ALTER TABLE driver_locations
    ALTER COLUMN s2_cell_id TYPE VARCHAR(32) USING s2_cell_id::text;
