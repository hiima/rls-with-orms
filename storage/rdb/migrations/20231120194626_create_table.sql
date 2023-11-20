-- +goose Up
-- +goose StatementBegin
-- realms テーブルの作成
CREATE TABLE realms (
    id SERIAL PRIMARY KEY
);

-- users テーブルの作成
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    realm_id INTEGER,
    FOREIGN KEY (realm_id) REFERENCES realms(id)
);

-- posts テーブルの作成
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    realm_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (realm_id) REFERENCES realms(id)
);

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO api;

-- seeds
INSERT INTO realms (id) VALUES (1), (2);
INSERT INTO users (realm_id) VALUES (1), (1), (2), (2);
INSERT INTO posts (user_id, realm_id) VALUES (1, 1), (1, 1), (2, 1), (2, 1), (3, 2), (3, 2), (4, 2), (4, 2);

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
SELECT 'down SQL query';
-- +goose StatementEnd
