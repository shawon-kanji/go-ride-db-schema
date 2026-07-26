package models

import (
	"time"

	"github.com/google/uuid"
)

const (
	VehicleCategoryNormal = "normal"
	VehicleCategoryLuxury = "luxury"
)

type Vehicle struct {
	ID          uuid.UUID `gorm:"column:id;type:uuid;primaryKey"`
	DriverID    uuid.UUID `gorm:"column:driver_id;type:uuid;not null;index"`
	PlateNumber string    `gorm:"column:plate_number;type:varchar(20);not null;uniqueIndex"`
	Color       string    `gorm:"column:color;type:varchar(50);not null"`
	ModelName   string    `gorm:"column:model_name;type:varchar(100);not null"`
	SeatCount   int       `gorm:"column:seat_count;not null"`
	Category    string    `gorm:"column:category;type:varchar(20);not null;default:normal"`
	IsActive    bool      `gorm:"column:is_active;not null;default:false"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

func (Vehicle) TableName() string {
	return "vehicles"
}
