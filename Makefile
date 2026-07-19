APP_NAME=go-ride-db-schema

.PHONY: tidy test migrate-up migrate-down migrate-version seed-fare-config

tidy:
	go mod tidy

test:
	go test ./...

migrate-up:
	go run ./cmd/migrate up

migrate-down:
	go run ./cmd/migrate down

migrate-version:
	go run ./cmd/migrate version

seed-fare-config:
	go run ./cmd/seed-fare-config
