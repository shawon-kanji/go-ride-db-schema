package models

import (
	"time"

	"github.com/google/uuid"
)

type DriverJobOffer struct {
	ID               uuid.UUID  `gorm:"column:job_offer_id;type:uuid;primaryKey"`
	RequestID        uuid.UUID  `gorm:"column:request_id;type:uuid;not null;index"`
	TripID           uuid.UUID  `gorm:"column:trip_id;type:uuid;not null;index"`
	DriverID         uuid.UUID  `gorm:"column:driver_id;type:uuid;not null;index"`
	OfferRank        int        `gorm:"column:offer_rank;not null;default:0"`
	Status           string     `gorm:"type:varchar(40);not null;default:pending"`
	DeliveryStatus   string     `gorm:"column:delivery_status;type:varchar(40);not null;default:pending"`
	DeliveryAttempts int        `gorm:"column:delivery_attempts;not null;default:0"`
	ResponseReason   *string    `gorm:"column:response_reason;type:text"`
	CorrelationID    *string    `gorm:"column:correlation_id;type:varchar(128)"`
	OfferedAt        time.Time  `gorm:"column:offered_at;not null"`
	ExpiresAt        time.Time  `gorm:"column:expires_at;not null"`
	RespondedAt      *time.Time `gorm:"column:responded_at"`
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

func (DriverJobOffer) TableName() string {
	return "driver_job_offers"
}
