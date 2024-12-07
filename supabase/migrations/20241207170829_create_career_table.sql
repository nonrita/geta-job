-- ユーザーの経歴テーブルの作成
CREATE TABLE user_career (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,  -- 経歴エントリーの一意識別子
  user_id UUID REFERENCES auth.users NOT NULL,     -- ユーザーID（auth.usersテーブルを参照）
  date DATE NOT NULL,                              -- 経歴の日付
  description TEXT NOT NULL,                       -- 経歴の説明
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL,  -- レコード作成日時
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::TEXT, NOW()) NOT NULL   -- レコード更新日時
);

-- ユーザー経歴テーブルの行レベルセキュリティを有効化
ALTER TABLE user_career ENABLE ROW LEVEL SECURITY;

-- ユーザーが自身の経歴を挿入できるポリシーを作成
CREATE POLICY "Users can insert their own career entries."
ON user_career FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- ユーザーが自身の経歴を更新できるポリシーを作成
CREATE POLICY "Users can update their own career entries."
ON user_career FOR UPDATE
USING (auth.uid() = user_id);

-- ユーザーが自身の経歴を閲覧できるポリシーを作成
CREATE POLICY "Users can view their own career entries."
ON user_career FOR SELECT
USING (auth.uid() = user_id);

-- ユーザーが自身の経歴を削除できるポリシーを作成
CREATE POLICY "Users can delete their own career entries."
ON user_career FOR DELETE
USING (auth.uid() = user_id);