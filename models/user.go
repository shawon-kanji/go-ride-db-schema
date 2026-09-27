package models

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID            uuid.UUID `gorm:"type:uuid;primaryKey"`
	Email         string    `gorm:"type:varchar(255);uniqueIndex;not null"`
	PasswordHash  string    `gorm:"type:varchar(255);not null"`
	FirstName     string    `gorm:"type:varchar(100);not null"`
	LastName      string    `gorm:"type:varchar(100);not null"`
	AccountStatus string    `gorm:"type:varchar(50);not null;default:active"`
	DeactivatedAt *time.Time
	// RatingAverage is nil until the rider's first rating (from a driver) —
	// distinct from a real 0.0, which this scale never produces (1-5).
	RatingAverage *float64 `gorm:"column:rating_average;type:numeric(3,2)"`
	RatingCount   int      `gorm:"column:rating_count;not null;default:0"`
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

func (User) TableName() string {
	return "users"
}
