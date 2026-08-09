package models

import (
	"time"

	"github.com/google/uuid"
)

const (
	DriverKycStatusNotStarted = "not_started"
	DriverKycStatusInReview   = "in_review"
	DriverKycStatusApproved   = "approved"
	DriverKycStatusRejected   = "rejected"
)

type Driver struct {
	ID              uuid.UUID `gorm:"type:uuid;primaryKey"`
	Email           string    `gorm:"type:varchar(255);uniqueIndex;not null"`
	PasswordHash    string    `gorm:"type:varchar(255);not null"`
	FirstName       string    `gorm:"type:varchar(100);not null"`
	LastName        string    `gorm:"type:varchar(100);not null"`
	AccountStatus   string    `gorm:"type:varchar(50);not null;default:pending"`
	IsEmailVerified bool      `gorm:"not null;default:false"`
	IsOnline        bool      `gorm:"column:is_online;not null;default:false"`
	KycStatus       string    `gorm:"column:kyc_status;type:varchar(20);not null;default:not_started"`
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

func (Driver) TableName() string {
	return "drivers"
}
