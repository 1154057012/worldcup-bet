-- 2026 世界杯下注记录 - 数据库建表脚本
-- 在 Supabase SQL Editor 中运行

-- 用户表（固定3个用户 + 1个隐藏用户）
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  is_hidden BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 插入固定用户
INSERT INTO users (name, is_hidden) VALUES
  ('杨起飞', FALSE),
  ('翟收米', FALSE),
  ('锐暴富', FALSE),
  ('神秘人', TRUE)
ON CONFLICT (name) DO NOTHING;

-- 下注记录表
CREATE TABLE IF NOT EXISTS bets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  match_name TEXT NOT NULL,          -- 比赛名称，如 "阿根廷 vs 巴西"
  bet_type TEXT NOT NULL,             -- 盘口类型，如 "胜负" "让球" "大小球"
  bet_detail TEXT,                    -- 下注内容，如 "阿根廷赢" "大2.5"
  odds NUMERIC(6,2) NOT NULL,        -- 赔率
  amount NUMERIC(10,2) NOT NULL,     -- 下注金额
  result TEXT CHECK (result IN ('走水', '收米', '收半米', '输半')),
  profit NUMERIC(10,2) DEFAULT 0,    -- 盈亏金额（正=赚，负=亏）
  match_time TIMESTAMPTZ,            -- 比赛时间
  note TEXT,                         -- 备注
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 索引
CREATE INDEX IF NOT EXISTS idx_bets_user_id ON bets(user_id);
CREATE INDEX IF NOT EXISTS idx_bets_created_at ON bets(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_bets_match_time ON bets(match_time DESC);

-- 关闭 RLS（因为不用登录，所有人共享数据）
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE bets ENABLE ROW LEVEL SECURITY;

-- 允许所有人读写（匿名访问）
CREATE POLICY "Allow all on users" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all on bets" ON bets FOR ALL USING (true) WITH CHECK (true);
