-- 在 Supabase SQL Editor 中执行此脚本
-- 创建管理员密码验证函数（密码不暴露给前端）

CREATE OR REPLACE FUNCTION verify_admin_password(pwd text)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- 密码仅存在于服务端，前端无法获取
  RETURN pwd = '2026888';
END;
$$;

-- 限制只允许 anon 调用
REVOKE ALL ON FUNCTION verify_admin_password(text) FROM public;
GRANT EXECUTE ON FUNCTION verify_admin_password(text) TO anon;
