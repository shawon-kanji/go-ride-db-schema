# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Shared database schema package for Go Ride services: versioned SQL migrations (`migrations/`), matching GORM model structs (`models/`), and a small migration-runner CLI (`cmd/migrate`). It is consumed as a Go module by sibling repos (`go-ride-backend`, `go-ride-kafka-consumers`) via a `replace` directive pointing at a local checkout — this repo owns the schema; the consuming repos own the query/business logic built on top of it.

This repo has no Dockerfile, Helm chart, or app-level CI/CD of its own. Migrations are applied by whichever CI/CD pipeline is deploying a consuming service, which runs `cmd/migrate` against that environment's database as a precondition before rollout (not a Kubernetes Job — see `go-ride-infra`'s `docs/architecture.md`). Locally in `go-ride-infra`'s kind cluster, `go-ride-infra/local/deploy-local.sh` prints the `go run ./cmd/migrate up` command to run manually.

## Commands

```bash
make tidy                # go mod tidy
make test                # go test ./...
make migrate-up          # go run ./cmd/migrate up
make migrate-down        # go run ./cmd/migrate down (one step)
make migrate-version     # go run ./cmd/migrate version
make seed-fare-config    # go run ./cmd/seed-fare-config
```

Migration DB connection is env-driven (`internal/config.LoadDB`): `DB_HOST` (localhost), `DB_PORT` (5432), `DB_USER` (postgres), `DB_PASSWORD` (postgres), `DB_NAME` (go_ride), `DB_SSLMODE` (disable) — see `.env.example`. Requires a running local Postgres.

There are currently no `_test.go` files in this repo; `go test ./...` succeeds trivially. CI (`.github/workflows/ci.yml`) additionally spins up a real Postgres 16 service container and runs `migrate up` + `migrate version` against it on every PR/push to `main` — this is the actual correctness check for schema changes, not unit tests. It also fails the build if `go mod tidy` produces a diff.

## Architecture

**Migrations are the source of truth.** `migrations/*.sql` are golang-migrate-style paired files (`NNNNNN_description.up.sql` / `.down.sql`, sequential 6-digit prefix) embedded into the binary via `migrations/embed.go` (`//go:embed *.sql`). `internal/migrate/migrate.go` wraps `golang-migrate` (`postgres` driver + `iofs` source) with three operations used by `cmd/migrate/main.go`: `Up`, `Down` (single step via `m.Steps(-1)`), `Version`. There is no ORM auto-migration — `models/` structs are hand-kept in sync with the SQL by convention, not generated from or generating the schema.

**Adding a schema change** means: add the next-numbered `up`/`down` SQL pair in `migrations/`, and update/add the corresponding struct in `models/` to match. Look at a recent pair (e.g. `000019_add_cancellation_fields.*.sql` + `models/ongoing_trip.go`) for the expected shape before writing a new one.

**Model conventions** (see `models/*.go`): every struct has an explicit `TableName()` method; primary keys are `uuid.UUID` with `gorm:"type:uuid;primaryKey"` (DB default `gen_random_uuid()`); nullable columns are pointer types (`*time.Time`, `*string`, `*float64`); string-enum-like status columns are backed by exported `const` blocks in the same file (e.g. `OngoingTripStatus*`, `VehicleCategory*`) rather than a Go enum type, matching `varchar` + `CHECK` constraints in the SQL.

**Domain shape**, roughly in migration order: `users` / `drivers` (separate tables, not a shared identity table) → `driver_locations` (geospatial: lat/lng + geohash + a leaf-level S2 cell ID stored as `numeric(20,0)` because `uint64` can exceed Postgres `bigint`'s signed range, indexed for range queries used by nearest-driver dispatch in `go-ride-kafka-consumers`) → `trip_requests` → `ongoing_trips` (the active-trip row; references `vehicle_id`, carries cancellation audit columns and cash-payment tracking fields, not a payment gateway) → `driver_job_offers` (dispatch offer/accept flow) → `trip_history` → `trip_fares` / `fare_surcharges` / `fare_configs` (versioned, effective-dated fare rules keyed by `city_code` + `service_type`, with `priority` for overlap resolution) → `vehicles` (belongs to a driver, one `is_active` vehicle per driver enforced by a partial unique index) → `driver_documents` (KYC uploads: driver-level identity documents with `vehicle_id IS NULL`, plus five vehicle-scoped document types — registration, photo front/back/side, number plate — each linked to a specific `vehicle_id`; `drivers.kyc_status` tracks driver identity verification separately from per-vehicle document approval, which has no dedicated status column and is derived live from `driver_documents.status`).

**`cmd/seed-fare-config`** is a standalone idempotent seeder (upsert via `ON CONFLICT (id) DO UPDATE`) for baseline `fare_configs` rows, useful for local/test environments; it is not part of the migration chain and doesn't run in CI.

## Cross-repo context

Changes here ripple into `go-ride-backend` and `go-ride-kafka-consumers`, which import this module as a tagged version (`go get github.com/shawon-kanji/go-ride-db-schema@vX.Y.Z && go mod tidy` in each consuming repo, as a commit separate from the feature code that uses the new schema — see each repo's own CLAUDE.md/README) and depend directly on these model structs and table shapes — check those repos for usages before renaming or dropping columns. `go-ride-backend` is currently pinned to `v0.4.2`; `go-ride-kafka-consumers` to `v0.3.6` (it doesn't touch `driver_documents`/`kyc_status`, so it hasn't needed the newer migrations).
