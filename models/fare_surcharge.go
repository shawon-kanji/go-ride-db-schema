package models

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

type FareSurcharge struct {
	ID            uuid.UUID       `gorm:"type:uuid;primaryKey"`
	FareID        uuid.UUID       `gorm:"column:fare_id;type:uuid;not null;index"`
	SurchargeType string          `gorm:"column:surcharge_type;type:varchar(64);not null;index"`
	Amount        float64         `gorm:"type:numeric(12,2);not null;default:0"`
	Multiplier    *float64        `gorm:"type:numeric(8,4)"`
	Metadata      json.RawMessage `gorm:"type:jsonb;not null;default:'{}'::jsonb"`
	AppliedAt     time.Time       `gorm:"column:applied_at;not null"`
	CreatedAt     time.Time
}

func (FareSurcharge) TableName() string {
	return "fare_surcharges"
}
