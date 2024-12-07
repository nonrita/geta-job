-- ユーザースキルテーブルの作成
CREATE TABLE user_skills (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,  -- スキルエントリーの一意識別子
  user_id UUID REFERENCES auth.users NOT NULL,     -- ユーザーID（auth.usersテーブルを参照）
  skill_name TEXT NOT NULL,                        -- スキル名
  years_of_experience INTEGER,                     -- 経験年数
  additional_info TEXT,                            -- 追加情報
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,  -- レコード作成日時
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL   -- レコード更新日時
);

-- ユーザースキルテーブルの行レベルセキュリティを有効化
ALTER TABLE user_skills ENABLE ROW LEVEL SECURITY;

-- ユーザーが自身のスキルを挿入できるポリシーを作成
CREATE POLICY "Users can insert their own skills."
ON user_skills FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- ユーザーが自身のスキルを更新できるポリシーを作成
CREATE POLICY "Users can update their own skills."
ON user_skills FOR UPDATE
USING (auth.uid() = user_id);

-- ユーザーが自身のスキルを閲覧できるポリシーを作成
CREATE POLICY "Users can view their own skills."
ON user_skills FOR SELECT
USING (auth.uid() = user_id);

-- ユーザーが自身のスキルを削除できるポリシーを作成
CREATE POLICY "Users can delete their own skills."
ON user_skills FOR DELETE
USING (auth.uid() = user_id);