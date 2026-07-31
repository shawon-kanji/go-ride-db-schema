# go-ride-db-schema

Shared database schema package for Go Ride services.

## Includes

- GORM model structs under `models/`
- Versioned SQL migrations under `migrations/`
- Embedded migration runner command under `cmd/migrate`

## Local usage in sibling repos

Add to `go.mod`:

```go
require github.com/shawon-kanji/go-ride-db-schema v0.0.0
replace github.com/shawon-kanji/go-ride-db-schema => ../go-ride-db-schema
```

## Run migrations

```bash
go run ./cmd/migrate up
```

Supported commands:

- `up` (default)
- `down`
- `version`

DB config env vars:

- `DB_HOST` (default `localhost`)
- `DB_PORT` (default `5432`)
- `DB_USER` (default `postgres`)
- `DB_PASSWORD` (default `postgres`)
- `DB_NAME` (default `go_ride`)
- `DB_SSLMODE` (default `disable`)

## Seed fare configs for testing

The repository includes a reusable, idempotent fare config seed command that upserts a baseline dataset into `fare_configs`:

- `KUL / RIDE` active default profile
- `KUL / RIDE_PREMIUM` active premium profile
- `JHB / RIDE` active default profile
- `KUL / RIDE` legacy inactive profile with a closed effective window

Run it with:

```bash
make seed-fare-config
```

or:

```bash
go run ./cmd/seed-fare-config
```

## Deployment

This repo has no Dockerfile, Helm chart, or CI/CD of its own — schema
migrations are applied by whichever CI/CD pipeline is deploying a
consuming service (`go-ride-kafka-consumers`, `go-ride-backend`), which runs
[`cmd/migrate`](cmd/migrate) against that environment's database as a
precondition before rolling out. Not a Kubernetes Job — see
[`go-ride-infra`](https://github.com/shawon-kanji/go-ride-infra)'s
[`docs/architecture.md`](https://github.com/shawon-kanji/go-ride-infra/blob/main/docs/architecture.md)
("Schema migrations run through CI/CD, not a k8s Job").

The RDS Postgres instance each environment's migration targets is
provisioned by `go-ride-infra`'s
[`terraform/modules/rds`](https://github.com/shawon-kanji/go-ride-infra/blob/main/terraform/modules/rds)
(one instance per environment, in `terraform/environments/staging` /
`terraform/environments/production`); locally, `go-ride-infra/local/deploy-local.sh`
prints the exact `go run ./cmd/migrate up` invocation to run manually
against the in-cluster Postgres (no CI/CD in kind, so this one step stays
manual there).
