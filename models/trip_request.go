package models

import (
	"time"

	"github.com/google/uuid"
)

const (
	TripRequestStatusSearchStarted  = "search_started"
	TripRequestStatusSearching      = "searching"
	TripRequestStatusOffered        = "offered"
	TripRequestStatusDriverAccepted = "driver_accepted"
	TripRequestStatusDriverRejected = "driver_rejected"
	TripRequestStatusTimedOut       = "timed_out"
	TripRequestStatusAssigned       = "assigned"
	TripRequestStatusCancelled      = "cancelled"
)

func ActiveTripRequestStatuses() []string {
	return []string{
		TripRequestStatusSearchStarted,
		TripRequestStatusSearching,
		TripRequestStatusOffered,
		TripRequestStatusDriverAccepted,
		TripRequestStatusDriverRejected,
	}
}

type TripRequest struct {
	ID              uuid.UUID  `gorm:"column:request_id;type:uuid;primaryKey"`
	TripID          uuid.UUID  `gorm:"column:trip_id;type:uuid;not null;index"`
	RiderID         uuid.UUID  `gorm:"column:rider_id;type:uuid;not null;index"`
	FareID          *uuid.UUID `gorm:"column:fare_id;type:uuid;index"`
	Status          string     `gorm:"type:varchar(40);not null;default:search_started"`
	PickupLat       float64    `gorm:"column:pickup_lat;type:double precision;not null"`
	PickupLng       float64    `gorm:"column:pickup_lng;type:double precision;not null"`
	DropoffLat      float64    `gorm:"column:dropoff_lat;type:double precision;not null"`
	DropoffLng      float64    `gorm:"column:dropoff_lng;type:double precision;not null"`
	PickupGeohash   string     `gorm:"column:pickup_geohash;type:varchar(32);not null;default:''"`
	PickupS2CellID  string     `gorm:"column:pickup_s2_cell_id;type:varchar(32);not null;default:''"`
	SearchRadiusKM  float64    `gorm:"column:search_radius_km;type:double precision;not null;default:20"`
	IdempotencyKey  *string    `gorm:"column:idempotency_key;type:varchar(128)"`
	CorrelationID   *string    `gorm:"column:correlation_id;type:varchar(128)"`
	RequestedAt     time.Time  `gorm:"column:requested_at;not null"`
	SearchStartedAt *time.Time `gorm:"column:search_started_at"`
	AssignedAt      *time.Time `gorm:"column:assigned_at"`
	CancelledAt     *time.Time `gorm:"column:cancelled_at"`
	TimedOutAt      *time.Time `gorm:"column:timed_out_at"`
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

func (TripRequest) TableName() string {
	return "trip_requests"
}
