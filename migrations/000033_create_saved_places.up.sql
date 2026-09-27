CREATE TABLE IF NOT EXISTS saved_places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    label VARCHAR(100) NOT NULL,
    place_type VARCHAR(20) NOT NULL DEFAULT 'other',
    formatted_address VARCHAR(500) NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_saved_places_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_saved_places_place_type CHECK (place_type IN ('home', 'work', 'other'))
);

CREATE INDEX IF NOT EXISTS idx_saved_places_user_id ON saved_places (user_id);

-- A rider can save at most one Home and one Work (R01/R07 show each as a
-- single fixed row); any number of 'other' places is fine.
CREATE UNIQUE INDEX IF NOT EXISTS idx_saved_places_user_home ON saved_places (user_id) WHERE place_type = 'home';
CREATE UNIQUE INDEX IF NOT EXISTS idx_saved_places_user_work ON saved_places (user_id) WHERE place_type = 'work';
