-- プロフィールテーブルの作成
CREATE TABLE profiles (
  user_id UUID REFERENCES auth.users NOT NULL PRIMARY KEY, -- ユーザーID（auth.usersテーブルを参照）
  icon_url TEXT,                                           -- アイコン画像のURL
  bio TEXT,                                                -- 自己紹介文
  is_job_hunting BOOLEAN DEFAULT FALSE,                    -- 就活中かどうかのフラグ
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL, -- レコード作成日時
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL  -- レコード更新日時
);

-- プロフィールテーブルの行レベルセキュリティを有効化
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- ユーザーが自分のプロフィールを挿入できるポリシーを作成
CREATE POLICY "Users can insert their own profile."
ON profiles FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- ユーザーが自分のプロフィールを更新できるポリシーを作成
CREATE POLICY "Users can update own profile."
ON profiles FOR UPDATE
USING (auth.uid() = user_id);

-- すべてのユーザーがプロフィールを閲覧できるポリシーを作成
CREATE POLICY "Profiles are viewable by everyone."
ON profiles FOR SELECT
USING (TRUE);