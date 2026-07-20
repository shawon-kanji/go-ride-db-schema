ALTER TABLE driver_locations
    ALTER COLUMN s2_cell_id TYPE NUMERIC(20,0) USING s2_cell_id::numeric;
