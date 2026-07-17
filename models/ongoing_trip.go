package models

import (
	"time"

	"github.com/google/uuid"
)

type OngoingTrip struct {
	TripID      uuid.UUID  `gorm:"column:trip_id;type:uuid;primaryKey"`
	RequestID   uuid.UUID  `gorm:"column:request_id;type:uuid;not null;uniqueIndex"`
	RideID      uuid.UUID  `gorm:"column:ride_id;type:uuid;not null;uniqueIndex"`
	RiderID     uuid.UUID  `gorm:"column:rider_id;type:uuid;not null;index"`
	DriverID    uuid.UUID  `gorm:"column:driver_id;type:uuid;not null;index"`
	Status      string     `gorm:"type:varchar(40);not null;default:assigned"`
	PickupLat   float64    `gorm:"column:pickup_lat;type:double precision;not null"`
	PickupLng   float64    `gorm:"column:pickup_lng;type:double precision;not null"`
	DropoffLat  float64    `gorm:"column:dropoff_lat;type:double precision;not null"`
	DropoffLng  float64    `gorm:"column:dropoff_lng;type:double precision;not null"`
	AssignedAt  time.Time  `gorm:"column:assigned_at;not null"`
	StartedAt   *time.Time `gorm:"column:started_at"`
	CompletedAt *time.Time `gorm:"column:completed_at"`
	CancelledAt *time.Time `gorm:"column:cancelled_at"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

func (OngoingTrip) TableName() string {
	return "ongoing_trips"
}
