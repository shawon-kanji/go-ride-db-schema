package models

import (
	"time"

	"github.com/google/uuid"
)

const (
	OngoingTripStatusAssigned        = "assigned"
	OngoingTripStatusDriverArriving  = "driver_arriving"
	OngoingTripStatusInProgress      = "in_progress"
	OngoingTripStatusAwaitingPayment = "awaiting_payment"
	OngoingTripStatusCompleted       = "completed"
	OngoingTripStatusCancelled       = "cancelled"

	OngoingTripPaymentStatusPending   = "pending"
	OngoingTripPaymentStatusCollected = "collected"
)

func ActiveOngoingTripStatuses() []string {
	return []string{
		OngoingTripStatusAssigned,
		OngoingTripStatusDriverArriving,
		OngoingTripStatusInProgress,
		OngoingTripStatusAwaitingPayment,
	}
}

type OngoingTrip struct {
	ID                 uuid.UUID  `gorm:"column:id;type:uuid;primaryKey"`
	RequestID          uuid.UUID  `gorm:"column:request_id;type:uuid;not null;uniqueIndex"`
	TripID             uuid.UUID  `gorm:"column:trip_id;type:uuid;not null;uniqueIndex"`
	RiderID            uuid.UUID  `gorm:"column:rider_id;type:uuid;not null;index"`
	DriverID           uuid.UUID  `gorm:"column:driver_id;type:uuid;not null;index"`
	VehicleID          *uuid.UUID `gorm:"column:vehicle_id;type:uuid"`
	Status             string     `gorm:"type:varchar(40);not null;default:assigned"`
	PickupLat          float64    `gorm:"column:pickup_lat;type:double precision;not null"`
	PickupLng          float64    `gorm:"column:pickup_lng;type:double precision;not null"`
	DropoffLat         float64    `gorm:"column:dropoff_lat;type:double precision;not null"`
	DropoffLng         float64    `gorm:"column:dropoff_lng;type:double precision;not null"`
	AssignedAt         time.Time  `gorm:"column:assigned_at;not null"`
	StartPin           *string    `gorm:"column:start_pin;type:varchar(4)"`
	StartedAt          *time.Time `gorm:"column:started_at"`
	EndedAt            *time.Time `gorm:"column:ended_at"`
	CompletedAt        *time.Time `gorm:"column:completed_at"`
	CancelledAt        *time.Time `gorm:"column:cancelled_at"`
	CancellationReason *string    `gorm:"column:cancellation_reason"`
	CancelledBy        *string    `gorm:"column:cancelled_by;type:varchar(20)"`
	FinalFare          *float64   `gorm:"column:final_fare;type:numeric(12,2)"`
	PaymentStatus      *string    `gorm:"column:payment_status;type:varchar(20)"`
	PaymentCollectedAt *time.Time `gorm:"column:payment_collected_at"`
	CreatedAt          time.Time
	UpdatedAt          time.Time
}

func (OngoingTrip) TableName() string {
	return "ongoing_trips"
}
