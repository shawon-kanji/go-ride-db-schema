package models

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type TripHistory struct {
	ID            uuid.UUID       `gorm:"type:uuid;primaryKey"`
	RequestID     uuid.UUID       `gorm:"column:request_id;type:uuid;not null;index"`
	RideID        uuid.UUID       `gorm:"column:ride_id;type:uuid;not null;index"`
	RiderID       *uuid.UUID      `gorm:"column:rider_id;type:uuid;index"`
	DriverID      *uuid.UUID      `gorm:"column:driver_id;type:uuid;index"`
	EventType     string          `gorm:"column:event_type;type:varchar(64);not null;index"`
	FromStatus    *string         `gorm:"column:from_status;type:varchar(40)"`
	ToStatus      *string         `gorm:"column:to_status;type:varchar(40)"`
	EventPayload  json.RawMessage `gorm:"column:event_payload;type:jsonb;not null;default:'{}'::jsonb"`
	CorrelationID *string         `gorm:"column:correlation_id;type:varchar(128)"`
	CreatedAt     time.Time
}

func (TripHistory) TableName() string {
	return "trip_history"
}
