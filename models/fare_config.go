package models

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type FareConfig struct {
	ID              uuid.UUID       `gorm:"type:uuid;primaryKey"`
	CityCode        string          `gorm:"column:city_code;type:varchar(32);not null;index"`
	ServiceType     string          `gorm:"column:service_type;type:varchar(32);not null;index"`
	CurrencyCode    string          `gorm:"column:currency_code;type:varchar(3);not null"`
	BaseFare        float64         `gorm:"column:base_fare;type:numeric(12,2);not null"`
	PerKMRate       float64         `gorm:"column:per_km_rate;type:numeric(12,2);not null"`
	PerMinuteRate   float64         `gorm:"column:per_minute_rate;type:numeric(12,2);not null"`
	MinimumFare     float64         `gorm:"column:minimum_fare;type:numeric(12,2);not null"`
	BookingFee      float64         `gorm:"column:booking_fee;type:numeric(12,2);not null;default:0"`
	CancellationFee float64         `gorm:"column:cancellation_fee;type:numeric(12,2);not null;default:0"`
	IsActive        bool            `gorm:"column:is_active;not null;default:true;index"`
	EffectiveFrom   time.Time       `gorm:"column:effective_from;not null;index"`
	EffectiveTo     *time.Time      `gorm:"column:effective_to;index"`
	Priority        int             `gorm:"not null;default:100;index"`
	Metadata        json.RawMessage `gorm:"type:jsonb;not null;default:'{}'::jsonb"`
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

func (FareConfig) TableName() string {
	return "fare_configs"
}
