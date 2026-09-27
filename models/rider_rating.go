package models

import (
	"time"

	"github.com/google/uuid"
)

// RiderRating is a driver's post-trip rating of the rider — the reverse
// direction of TripRating (rider-rates-driver). Kept as its own table rather
// than widening trip_ratings, since that table's rider_id/driver_id columns
// and doc comment treat the two directions as deliberately distinct.
type RiderRating struct {
	ID            uuid.UUID `gorm:"column:id;type:uuid;primaryKey"`
	OngoingTripID uuid.UUID `gorm:"column:ongoing_trip_id;type:uuid;not null;uniqueIndex"`
	DriverID      uuid.UUID `gorm:"column:driver_id;type:uuid;not null"`
	RiderID       uuid.UUID `gorm:"column:rider_id;type:uuid;not null;index"`
	Rating        int       `gorm:"column:rating;not null"`
	Comment       *string   `gorm:"column:comment"`
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

func (RiderRating) TableName() string {
	return "rider_ratings"
}
