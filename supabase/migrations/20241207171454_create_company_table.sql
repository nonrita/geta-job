-- 企業ステートグループテーブルの作成
-- ステートをカテゴリ別にグループ化するためのテーブル
CREATE TABLE company_state_groups (
  id SERIAL PRIMARY KEY,           -- グループの一意識別子
  group_name TEXT NOT NULL UNIQUE  -- グループ名（重複不可）
);

-- 企業ステートテーブルの作成（グループ参照を含む）
-- 個別の企業ステートを定義し、グループと関連付けるテーブル
CREATE TABLE company_states (
  id SERIAL PRIMARY KEY,                                        -- ステートの一意識別子
  state_name TEXT NOT NULL UNIQUE,                              -- ステート名（重複不可）
  group_id INTEGER REFERENCES company_state_groups(id) NOT NULL -- 所属するグループのID
);

-- ステートグループの初期データ挿入
-- 基本的なステートグループを事前に定義
INSERT INTO company_state_groups (group_name) VALUES
  ('興味段階'),      -- 企業に興味を持った初期段階
  ('選考プロセス中'), -- 選考プロセスに入っている段階
  ('結果段階'),      -- 選考結果が出た段階
  ('その他');        -- 上記以外の段階

-- 企業ステートの初期データ挿入
-- 各ステートをグループに関連付けて挿入
INSERT INTO company_states (state_name, group_id) VALUES
  ('興味あり', (SELECT id FROM company_state_groups WHERE group_name = '興味段階')),
  ('面談予定', (SELECT id FROM company_state_groups WHERE group_name = '選考プロセス中')),
  ('説明会参加', (SELECT id FROM company_state_groups WHERE group_name = '選考プロセス中')),
  ('選考中', (SELECT id FROM company_state_groups WHERE group_name = '選考プロセス中')),
  ('内定', (SELECT id FROM company_state_groups WHERE group_name = '結果段階')),
  ('不採用', (SELECT id FROM company_state_groups WHERE group_name = '結果段階')),
  ('辞退', (SELECT id FROM company_state_groups WHERE group_name = '結果段階')),
  ('その他', (SELECT id FROM company_state_groups WHERE group_name = 'その他'));

-- 企業管理テーブルの作成
-- ユーザーごとの企業との関係性を追跡管理するテーブル
CREATE TABLE company_tracking (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,  -- エントリーの一意識別子
  user_id UUID REFERENCES auth.users NOT NULL,     -- ユーザーID（auth.usersテーブルを参照）
  company_name TEXT NOT NULL,                      -- 企業名
  state_id INTEGER REFERENCES company_states(id) NOT NULL,  -- 現在の状態（company_statesテーブルを参照）
  memo TEXT,                                       -- メモ欄（追加情報や備考）
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,  -- レコード作成日時
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL   -- レコード更新日時
);

-- 企業管理テーブルの行レベルセキュリティを有効化
ALTER TABLE company_tracking ENABLE ROW LEVEL SECURITY;

-- ユーザーが自身の企業追跡エントリーを管理できるポリシーを作成
-- これにより、ユーザーは自分のエントリーのみを挿入、更新、閲覧、削除できる
CREATE POLICY "Users can manage their own company tracking entries"
ON company_tracking
USING (auth.uid() = user_id);