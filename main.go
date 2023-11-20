package main

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/hiima/rls-with-orms/models"
	_ "github.com/jackc/pgx/v5/stdlib"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

var txKey = struct{}{}

func main() {
	// boot server
	db, err := sql.Open("pgx", "host=localhost port=5432 user=api password=api dbname=local sslmode=disable")
	dieIf(err)

	if err := db.Ping(); err != nil {
		dieIf(err)
	}

	db.SetMaxIdleConns(10)
	db.SetMaxOpenConns(10)
	db.SetConnMaxLifetime(300 * time.Second)
	boil.DebugMode = true
	boil.SetDB(db)

	// middleware
	ctx := context.Background()
	tx, txErr := boil.BeginTx(ctx, &sql.TxOptions{Isolation: sql.LevelDefault, ReadOnly: true})
	if txErr != nil {
		dieIf(err)
	}

	if _, err := tx.ExecContext(ctx, "SET LOCAL api.current_realm_id = 1"); err != nil {
		dieIf(err)
	}
	ctx = context.WithValue(ctx, txKey, tx)

	// handler, usecase, ...
	users := models.Users().AllP(ctx, tx)
	for _, user := range users {
		fmt.Println(user.ID, user.RealmID)
	}

	fmt.Println("ok")
}

func dieIf(err error) {
	if err != nil {
		panic(err)
	}
}
