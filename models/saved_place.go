package models

import (
	"time"

	"github.com/google/uuid"
)

const (
	SavedPlaceTypeHome  = "home"
	SavedPlaceTypeWork  = "work"
	SavedPlaceTypeOther = "other"
)

// SavedPlace is a rider's saved location (Home, Work, or a custom place),
// shown on R01's "Where to" suggestions and managed from R07's profile.
type SavedPlace struct {
	ID               uuid.UUID `gorm:"column:id;type:uuid;primaryKey"`
	UserID           uuid.UUID `gorm:"column:user_id;type:uuid;not null;index"`
	Label            string    `gorm:"column:label;type:varchar(100);not null"`
	PlaceType        string    `gorm:"column:place_type;type:varchar(20);not null;default:other"`
	FormattedAddress string    `gorm:"column:formatted_address;type:varchar(500);not null"`
	Lat              float64   `gorm:"column:lat;not null"`
	Lng              float64   `gorm:"column:lng;not null"`
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

func (SavedPlace) TableName() string {
	return "saved_places"
}
