package models

import (
	"time"

	"github.com/google/uuid"
)

// ServiceType* are the three ride tiers R03 actually specifies (Standard /
// Standard 6 Seater / Standard Plus), named after fare_configs' pre-existing
// RIDE/RIDE_PREMIUM seed convention rather than a new vocabulary.
// ServiceTypeRide is the default, applied to every row that predates B1.
const (
	ServiceTypeRide        = "RIDE"
	ServiceTypeRideXL      = "RIDE_XL"
	ServiceTypeRidePremium = "RIDE_PREMIUM"
)

func ValidServiceTypes() []string {
	return []string{ServiceTypeRide, ServiceTypeRideXL, ServiceTypeRidePremium}
}

type TripFare struct {
	ID              uuid.UUID  `gorm:"column:fare_id;type:uuid;primaryKey"`
	RequestID       *uuid.UUID `gorm:"column:request_id;type:uuid;uniqueIndex"`
	RiderID         uuid.UUID  `gorm:"column:rider_id;type:uuid;not null;index"`
	ServiceType     string     `gorm:"column:service_type;type:varchar(32);not null;default:RIDE"`
	PickupLat       float64    `gorm:"column:pickup_lat;type:double precision;not null"`
	PickupLng       float64    `gorm:"column:pickup_lng;type:double precision;not null"`
	DropoffLat      float64    `gorm:"column:dropoff_lat;type:double precision;not null"`
	DropoffLng      float64    `gorm:"column:dropoff_lng;type:double precision;not null"`
	PickupGeohash   string     `gorm:"column:pickup_geohash;type:varchar(32);not null;default:''"`
	PickupS2CellID  string     `gorm:"column:pickup_s2_cell_id;type:varchar(32);not null;default:''"`
	SearchRadiusKM  float64    `gorm:"column:search_radius_km;type:double precision;not null;default:20"`
	CurrencyCode    string     `gorm:"column:currency_code;type:varchar(3);not null"`
	BaseFare        float64    `gorm:"column:base_fare;type:numeric(12,2);not null;default:0"`
	DistanceFare    float64    `gorm:"column:distance_fare;type:numeric(12,2);not null;default:0"`
	TimeFare        float64    `gorm:"column:time_fare;type:numeric(12,2);not null;default:0"`
	SurchargeTotal  float64    `gorm:"column:surcharge_total;type:numeric(12,2);not null;default:0"`
	DiscountTotal   float64    `gorm:"column:discount_total;type:numeric(12,2);not null;default:0"`
	SurgeMultiplier float64    `gorm:"column:surge_multiplier;type:numeric(8,4);not null;default:1"`
	TotalFare       float64    `gorm:"column:total_fare;type:numeric(12,2);not null;default:0"`
	PricingVersion  string     `gorm:"column:pricing_version;type:varchar(64);not null;default:v1"`
	// RouteDistanceKM/RouteDurationMinutes/RoutePolyline come from a real
	// directions provider, not the haversine straight-line estimate used
	// when it's nil (provider call failed or was never attempted) — see
	// cab-request-handler's buildFareEstimate.
	RouteDistanceKM      *float64   `gorm:"column:route_distance_km;type:double precision"`
	RouteDurationMinutes *float64   `gorm:"column:route_duration_minutes;type:double precision"`
	RoutePolyline        *string    `gorm:"column:route_polyline;type:text"`
	LockedAt             time.Time  `gorm:"column:locked_at;not null"`
	ExpiresAt            *time.Time `gorm:"column:expires_at"`
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

func (TripFare) TableName() string {
	return "trip_fares"
}

func (f TripFare) IsConsumed() bool {
	return f.RequestID != nil
}

func (f TripFare) IsExpired(now time.Time) bool {
	return f.ExpiresAt != nil && now.After(*f.ExpiresAt)
}
