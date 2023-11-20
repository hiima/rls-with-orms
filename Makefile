db.reset:
	docker compose down --volumes && docker compose up -d db

db.migrate:
	goose -dir storage/rdb/migrations/ postgres "host=localhost user=postgres password=postgres dbname=local sslmode=disable" up
