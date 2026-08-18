package models

import (
	"time"

	"github.com/google/uuid"
)

// TripRating is a rider's post-trip rating of the driver — B7 in
// POLISHED-MVP.md. Scoped to rider-rates-driver only: the design (R06's
// rating prompt, D11's rating stat tile) never shows a driver rating a
// rider, so there's no symmetric RiderRating concept here.
type TripRating struct {
	ID            uuid.UUID `gorm:"column:id;type:uuid;primaryKey"`
	OngoingTripID uuid.UUID `gorm:"column:ongoing_trip_id;type:uuid;not null;uniqueIndex"`
	RiderID       uuid.UUID `gorm:"column:rider_id;type:uuid;not null"`
	DriverID      uuid.UUID `gorm:"column:driver_id;type:uuid;not null;index"`
	Rating        int       `gorm:"column:rating;not null"`
	Comment       *string   `gorm:"column:comment"`
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

func (TripRating) TableName() string {
	return "trip_ratings"
}
