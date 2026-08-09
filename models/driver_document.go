package models

import (
	"time"

	"github.com/google/uuid"
)

const (
	DriverDocumentTypeSelfie              = "selfie"
	DriverDocumentTypeGovtIDFront         = "govt_id_front"
	DriverDocumentTypeGovtIDBack          = "govt_id_back"
	DriverDocumentTypeDrivingLicenseFront = "driving_license_front"
	DriverDocumentTypeDrivingLicenseBack  = "driving_license_back"
	DriverDocumentTypeVehicleRegistration = "vehicle_registration"
)

const (
	DriverDocumentStatusUploaded = "uploaded"
	DriverDocumentStatusApproved = "approved"
	DriverDocumentStatusRejected = "rejected"
)

type DriverDocument struct {
	ID              uuid.UUID  `gorm:"column:id;type:uuid;primaryKey"`
	DriverID        uuid.UUID  `gorm:"column:driver_id;type:uuid;not null;index"`
	VehicleID       *uuid.UUID `gorm:"column:vehicle_id;type:uuid"`
	DocumentType    string     `gorm:"column:document_type;type:varchar(30);not null"`
	FileURL         string     `gorm:"column:file_url;type:text;not null"`
	Status          string     `gorm:"column:status;type:varchar(20);not null;default:uploaded"`
	RejectionReason *string    `gorm:"column:rejection_reason;type:text"`
	AIVerdict       *string    `gorm:"column:ai_verdict;type:varchar(20)"`
	AIScore         *float64   `gorm:"column:ai_score;type:numeric(5,4)"`
	AICheckedAt     *time.Time `gorm:"column:ai_checked_at"`
	IsCurrent       bool       `gorm:"column:is_current;not null;default:true"`
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

func (DriverDocument) TableName() string {
	return "driver_documents"
}
