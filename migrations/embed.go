package migrations

import "embed"

// Files embeds SQL migrations.
//
//go:embed *.sql
var Files embed.FS
