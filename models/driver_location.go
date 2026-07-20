package models

import (
	"time"

	"github.com/google/uuid"
)

type DriverLocation struct {
	ID        uuid.UUID `gorm:"type:uuid;primaryKey"`
	DriverID  uuid.UUID `gorm:"type:uuid;not null;uniqueIndex"`
	Latitude  float64   `gorm:"type:double precision;not null"`
	Longitude float64   `gorm:"type:double precision;not null"`
	Geohash   string    `gorm:"type:varchar(32);not null;index"`
	// Leaf-level (level 30) S2 cell ID, stored numerically (uint64 can exceed
	// Postgres bigint's signed range) so range queries against S2 coverings work.
	S2CellID   string    `gorm:"type:numeric(20,0);not null;index"`
	RecordedAt time.Time `gorm:"not null;index"`
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

func (DriverLocation) TableName() string {
	return "driver_locations"
}
