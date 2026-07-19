package models

import (
	"time"

	"github.com/google/uuid"
)

type TripFare struct {
	ID              uuid.UUID  `gorm:"column:fare_id;type:uuid;primaryKey"`
	RequestID       *uuid.UUID `gorm:"column:request_id;type:uuid;uniqueIndex"`
	RiderID         uuid.UUID  `gorm:"column:rider_id;type:uuid;not null;index"`
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
	LockedAt        time.Time  `gorm:"column:locked_at;not null"`
	ExpiresAt       *time.Time `gorm:"column:expires_at"`
	CreatedAt       time.Time
	UpdatedAt       time.Time
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
