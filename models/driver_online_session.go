package models

import (
	"time"

	"github.com/google/uuid"
)

// DriverOnlineSession records one continuous online interval for a driver,
// opened when they go online and closed when they go offline — the
// audit trail C4/POLISHED-MVP.md needed since drivers.is_online is a single
// boolean with no history. At most one open (EndedAt == nil) row per driver
// at a time, enforced by a partial unique index (idx_driver_online_sessions_driver_open).
type DriverOnlineSession struct {
	ID        uuid.UUID  `gorm:"column:id;type:uuid;primaryKey"`
	DriverID  uuid.UUID  `gorm:"column:driver_id;type:uuid;not null;index"`
	StartedAt time.Time  `gorm:"column:started_at;not null"`
	EndedAt   *time.Time `gorm:"column:ended_at"`
	CreatedAt time.Time
	UpdatedAt time.Time
}

func (DriverOnlineSession) TableName() string {
	return "driver_online_sessions"
}
