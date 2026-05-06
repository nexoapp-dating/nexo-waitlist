-- ════════════════════════════════════════════════════════
-- NEXO WAITLIST — Schema v2: campos críticos para matching
-- Aplicar manualmente en Supabase SQL Editor
-- Idempotente: usa IF NOT EXISTS / ADD COLUMN IF NOT EXISTS
--
-- Cambios respecto a la primera versión del archivo:
--  - lat/lng eliminados: la ubicación precisa se pedirá DENTRO de la app
--    móvil (con permisos del SO), no en el formulario web. La waitlist
--    solo guarda la ciudad declarada (waitlist.ciudad) a nivel grueso.
--  - position INT añadida: se congela al INSERT (no se recalcula). El
--    bridge la lee directamente para asignar founder_position.
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
  ADD COLUMN IF NOT EXISTS position INT;

-- Comentarios documentando cada columna
COMMENT ON COLUMN waitlist.busco IS 'A quién atrae el usuario (hombres/mujeres/ambos)';
COMMENT ON COLUMN waitlist.profesion IS 'Profesión declarada por el usuario, free text';
COMMENT ON COLUMN waitlist.bio IS 'Bio breve de 100 caracteres';
COMMENT ON COLUMN waitlist.intencion IS 'Intención declarada (algo serio/conocer/abierto)';
COMMENT ON COLUMN waitlist.orientation IS 'Orientación sexual del usuario (Hetero/Bi/Pan/Gay/Lesbiana)';
COMMENT ON COLUMN waitlist.idiomas IS 'Array de idiomas que habla (ES/CAT/EN/Otros)';
COMMENT ON COLUMN waitlist.fecha_nacimiento IS 'Fecha de nacimiento. Edad se calcula en runtime';
COMMENT ON COLUMN waitlist.position IS 'Posición del usuario al momento del registro. Congelada al INSERT, no recalculada.';

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
