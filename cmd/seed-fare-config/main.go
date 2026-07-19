package main

import (
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/shawon-kanji/go-ride-db-schema/internal/config"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type fareConfigSeed struct {
	ID              string
	CityCode        string
	ServiceType     string
	CurrencyCode    string
	BaseFare        float64
	PerKMRate       float64
	PerMinuteRate   float64
	MinimumFare     float64
	BookingFee      float64
	CancellationFee float64
	IsActive        bool
	EffectiveFrom   time.Time
	EffectiveTo     *time.Time
	Priority        int
	MetadataJSON    string
}

var seededFareConfigs = []fareConfigSeed{
	{
		ID:              "5f5868a6-38df-45f2-b20f-57f9df9509b6",
		CityCode:        "KUL",
		ServiceType:     "RIDE",
		CurrencyCode:    "MYR",
		BaseFare:        4.5,
		PerKMRate:       1.8,
		PerMinuteRate:   0.35,
		MinimumFare:     7.5,
		BookingFee:      1.2,
		CancellationFee: 3.5,
		IsActive:        true,
		EffectiveFrom:   time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC),
		Priority:        100,
		MetadataJSON:    `{"label":"kul-ride-default","country":"MY","region":"klang-valley","seed_version":"v1"}`,
	},
	{
		ID:              "be9857fd-5be7-40fd-b4cb-d49cfaf53bd9",
		CityCode:        "KUL",
		ServiceType:     "RIDE_PREMIUM",
		CurrencyCode:    "MYR",
		BaseFare:        8.5,
		PerKMRate:       2.8,
		PerMinuteRate:   0.5,
		MinimumFare:     12,
		BookingFee:      2,
		CancellationFee: 6,
		IsActive:        true,
		EffectiveFrom:   time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC),
		Priority:        100,
		MetadataJSON:    `{"label":"kul-ride-premium-default","country":"MY","region":"klang-valley","seed_version":"v1"}`,
	},
	{
		ID:              "6dcf8e0d-8263-47f6-9e2e-446f875f70f9",
		CityCode:        "JHB",
		ServiceType:     "RIDE",
		CurrencyCode:    "MYR",
		BaseFare:        4,
		PerKMRate:       1.6,
		PerMinuteRate:   0.3,
		MinimumFare:     6.5,
		BookingFee:      1,
		CancellationFee: 3,
		IsActive:        true,
		EffectiveFrom:   time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC),
		Priority:        100,
		MetadataJSON:    `{"label":"jhb-ride-default","country":"MY","region":"southern","seed_version":"v1"}`,
	},
	{
		ID:              "eb7f5f3b-daf9-49c6-8387-70dd2f07b7a1",
		CityCode:        "KUL",
		ServiceType:     "RIDE",
		CurrencyCode:    "MYR",
		BaseFare:        5,
		PerKMRate:       2,
		PerMinuteRate:   0.4,
		MinimumFare:     8,
		BookingFee:      1.5,
		CancellationFee: 4,
		IsActive:        false,
		EffectiveFrom:   time.Date(2025, 1, 1, 0, 0, 0, 0, time.UTC),
		EffectiveTo:     timePtr(time.Date(2025, 12, 31, 23, 59, 59, 0, time.UTC)),
		Priority:        90,
		MetadataJSON:    `{"label":"kul-ride-legacy","country":"MY","status":"deprecated","seed_version":"v1"}`,
	},
}

const seedFareConfigSQL = `
INSERT INTO fare_configs (
	id,
	city_code,
	service_type,
	currency_code,
	base_fare,
	per_km_rate,
	per_minute_rate,
	minimum_fare,
	booking_fee,
	cancellation_fee,
	is_active,
	effective_from,
	effective_to,
	priority,
	metadata,
	updated_at
) VALUES (
	$1, $2, $3, $4,
	$5, $6, $7, $8,
	$9, $10, $11, $12,
	$13, $14, $15::jsonb, CURRENT_TIMESTAMP
)
ON CONFLICT (id) DO UPDATE
SET
	city_code = EXCLUDED.city_code,
	service_type = EXCLUDED.service_type,
	currency_code = EXCLUDED.currency_code,
	base_fare = EXCLUDED.base_fare,
	per_km_rate = EXCLUDED.per_km_rate,
	per_minute_rate = EXCLUDED.per_minute_rate,
	minimum_fare = EXCLUDED.minimum_fare,
	booking_fee = EXCLUDED.booking_fee,
	cancellation_fee = EXCLUDED.cancellation_fee,
	is_active = EXCLUDED.is_active,
	effective_from = EXCLUDED.effective_from,
	effective_to = EXCLUDED.effective_to,
	priority = EXCLUDED.priority,
	metadata = EXCLUDED.metadata,
	updated_at = CURRENT_TIMESTAMP
`

func main() {
	dbCfg, err := config.LoadDB()
	if err != nil {
		log.Fatalf("load db config: %v", err)
	}

	db, err := sql.Open("pgx", dbCfg.DSN())
	if err != nil {
		log.Fatalf("open db: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("ping db: %v", err)
	}

	if err := seedFareConfigs(db); err != nil {
		log.Fatalf("seed fare configs: %v", err)
	}

	log.Printf("fare config seeding complete (%d rows upserted)", len(seededFareConfigs))
}

func seedFareConfigs(db *sql.DB) error {
	tx, err := db.Begin()
	if err != nil {
		return fmt.Errorf("begin tx: %w", err)
	}
	defer tx.Rollback()

	for _, entry := range seededFareConfigs {
		if _, err := tx.Exec(
			seedFareConfigSQL,
			entry.ID,
			entry.CityCode,
			entry.ServiceType,
			entry.CurrencyCode,
			entry.BaseFare,
			entry.PerKMRate,
			entry.PerMinuteRate,
			entry.MinimumFare,
			entry.BookingFee,
			entry.CancellationFee,
			entry.IsActive,
			entry.EffectiveFrom,
			entry.EffectiveTo,
			entry.Priority,
			entry.MetadataJSON,
		); err != nil {
			return fmt.Errorf("upsert fare config %s/%s: %w", entry.CityCode, entry.ServiceType, err)
		}
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("commit tx: %w", err)
	}
	return nil
}

func timePtr(t time.Time) *time.Time {
	return &t
}
