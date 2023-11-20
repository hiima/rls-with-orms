-- +goose Up
-- +goose StatementBegin
-- realms テーブルに対するポリシー
ALTER TABLE realms ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_realms ON realms FOR SELECT USING (id = current_setting('api.current_realm_id')::INTEGER);

-- users テーブルに対するポリシー
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_users ON users FOR SELECT USING (realm_id = current_setting('api.current_realm_id')::INTEGER);

-- posts テーブルに対するポリシー
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY select_posts ON posts FOR SELECT USING (realm_id = current_setting('api.current_realm_id')::INTEGER);
CREATE POLICY insert_posts ON posts FOR INSERT WITH CHECK (realm_id = current_setting('api.current_realm_id')::INTEGER);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
SELECT 'down SQL query';
-- +goose StatementEnd
