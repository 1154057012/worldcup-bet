-- 在 Supabase SQL Editor 中执行此脚本

-- 1. 创建管理员密码验证函数（密码不暴露给前端）
CREATE OR REPLACE FUNCTION verify_admin_password(pwd text)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  RETURN pwd = '2026888';
END;
$$;

REVOKE ALL ON FUNCTION verify_admin_password(text) FROM public;
GRANT EXECUTE ON FUNCTION verify_admin_password(text) TO anon;

-- 2. 更新 result 列的 CHECK 约束（包含所有允许的结算状态）
ALTER TABLE bets DROP CONSTRAINT IF EXISTS bets_result_check;
ALTER TABLE bets ADD CONSTRAINT bets_result_check
  CHECK (result IS NULL OR result IN ('收米', '收半', '走水', '输半', '憾败', '其他'));
