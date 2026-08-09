# go-ride-db-schema

Shared database schema package for Go Ride services.

## Includes

- GORM model structs under `models/`
- Versioned SQL migrations under `migrations/`
- Embedded migration runner command under `cmd/migrate`

## Usage in sibling repos

Consuming repos (`go-ride-backend`, `go-ride-kafka-consumers`) pin a tagged version, not a local `replace` directive:

```bash
go get github.com/shawon-kanji/go-ride-db-schema@vX.Y.Z
go mod tidy
```

Commit the `go.mod`/`go.sum` bump as its own commit, separate from the feature code that uses the new schema. A local `replace github.com/shawon-kanji/go-ride-db-schema => ../go-ride-db-schema` directive is fine as a temporary aid while developing against unreleased migrations, but should be removed and replaced with a real tag before merging (see `go-ride-backend`/`go-ride-kafka-consumers` `go.mod` for the current pinned versions).

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
