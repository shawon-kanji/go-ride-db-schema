package models

import (
	"time"

	"github.com/google/uuid"
)

type Driver struct {
	ID              uuid.UUID `gorm:"type:uuid;primaryKey"`
	Email           string    `gorm:"type:varchar(255);uniqueIndex;not null"`
	PasswordHash    string    `gorm:"type:varchar(255);not null"`
	FirstName       string    `gorm:"type:varchar(100);not null"`
	LastName        string    `gorm:"type:varchar(100);not null"`
	AccountStatus   string    `gorm:"type:varchar(50);not null;default:pending"`
	IsEmailVerified bool      `gorm:"not null;default:false"`
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

func (Driver) TableName() string {
	return "drivers"
}
