package main

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/shawon-kanji/go-ride-db-schema/internal/config"
	intmigrate "github.com/shawon-kanji/go-ride-db-schema/internal/migrate"
	"github.com/shawon-kanji/go-ride-db-schema/migrations"

	_ "github.com/jackc/pgx/v5/stdlib"
)

func main() {
	action := "up"
	if len(os.Args) > 1 {
		action = os.Args[1]
	}

	dbCfg, err := config.LoadDB()
	if err != nil {
		log.Fatalf("load db config: %v", err)
	}

	db, err := sql.Open("pgx", dbCfg.DSN())
	if err != nil {
		log.Fatalf("open db: %v", err)
	}
	defer db.Close()

	switch action {
	case "up":
		if err := intmigrate.Up(db, migrations.Files); err != nil {
			log.Fatalf("run migrations up: %v", err)
		}
		log.Printf("migrations up complete")
	case "down":
		if err := intmigrate.Down(db, migrations.Files); err != nil {
			log.Fatalf("run migration down: %v", err)
		}
		log.Printf("migration down step complete")
	case "version":
		version, dirty, err := intmigrate.Version(db, migrations.Files)
		if err != nil {
			log.Fatalf("read migration version: %v", err)
		}
		fmt.Printf("version=%d dirty=%v\n", version, dirty)
	default:
		log.Fatalf("unknown action %q (supported: up, down, version)", action)
	}
}
