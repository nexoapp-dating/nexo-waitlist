-- ════════════════════════════════════════════════════════
-- NEXO WAITLIST — Schema v2: campos críticos para matching
-- Aplicar manualmente en Supabase SQL Editor
-- Idempotente: usa IF NOT EXISTS / ADD COLUMN IF NOT EXISTS
-- ════════════════════════════════════════════════════════

-- Añadir columnas nuevas (manteniendo compatibilidad con código existente)
ALTER TABLE waitlist
  ADD COLUMN IF NOT EXISTS busco TEXT,
  ADD COLUMN IF NOT EXISTS profesion TEXT,
  ADD COLUMN IF NOT EXISTS bio TEXT,
  ADD COLUMN IF NOT EXISTS intencion TEXT,
  ADD COLUMN IF NOT EXISTS orientation TEXT,
  ADD COLUMN IF NOT EXISTS idiomas JSONB DEFAULT '[]',
  ADD COLUMN IF NOT EXISTS fecha_nacimiento DATE,
  ADD COLUMN IF NOT EXISTS lat FLOAT,
  ADD COLUMN IF NOT EXISTS lng FLOAT;

-- Comentarios documentando cada columna
COMMENT ON COLUMN waitlist.busco IS 'A quién atrae el usuario (hombres/mujeres/ambos)';
COMMENT ON COLUMN waitlist.profesion IS 'Profesión declarada por el usuario, free text';
COMMENT ON COLUMN waitlist.bio IS 'Bio breve de 100 caracteres';
COMMENT ON COLUMN waitlist.intencion IS 'Intención declarada (algo serio/conocer/abierto)';
COMMENT ON COLUMN waitlist.orientation IS 'Orientación sexual del usuario (Hetero/Bi/Pan/Gay/Lesbiana)';
COMMENT ON COLUMN waitlist.idiomas IS 'Array de idiomas que habla (ES/CAT/EN/Otros)';
COMMENT ON COLUMN waitlist.fecha_nacimiento IS 'Fecha de nacimiento. Edad se calcula en runtime';
COMMENT ON COLUMN waitlist.lat IS 'Latitud del barrio seleccionado (centro aproximado)';
COMMENT ON COLUMN waitlist.lng IS 'Longitud del barrio seleccionado';

-- Mantener edad por compatibilidad mientras se migra (se calculará desde fecha_nacimiento)
-- NO eliminar columna edad todavía, dejar para sprint posterior

-- Verificación post-aplicación
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'waitlist'
ORDER BY ordinal_position;
