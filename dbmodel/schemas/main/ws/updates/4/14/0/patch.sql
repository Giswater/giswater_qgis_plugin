/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- PRESSZONE
CREATE OR REPLACE VIEW v_ui_presszone
AS
SELECT DISTINCT ON (p.presszone_id) p.presszone_id,
    p.code,
    p.name,
    p.descript,
    p.active,
    et.idval AS presszone_type,
    p.expl_id,
    p.sector_id,
    p.muni_id,
    p.avg_press,
    p.head,
    p.graphconfig::text AS graphconfig,
    p.stylesheet::text AS stylesheet,
    p.lock_level,
    p.link,
    p.addparam::text AS addparam,
    p.created_at,
    p.created_by,
    p.updated_at,
    p.updated_by
FROM presszone p
LEFT JOIN edit_typevalue et ON et.id::text = p.presszone_type
    AND et.typevalue = 'presszone_type'
WHERE p.presszone_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (p.expl_id)
  )
ORDER BY p.presszone_id;

CREATE OR REPLACE VIEW v_ui_presszone_sel
AS
SELECT p.*
FROM v_ui_presszone p
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (p.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- MACRODMA
CREATE OR REPLACE VIEW v_ui_macrodma
AS
SELECT DISTINCT ON (m.macrodma_id) m.macrodma_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.sector_id,
    m.muni_id,
    m.stylesheet::text AS stylesheet,
    m.lock_level,
    m.link,
    m.addparam::text AS addparam,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
FROM macrodma m
WHERE m.macrodma_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (m.expl_id)
  )
ORDER BY m.macrodma_id;

CREATE OR REPLACE VIEW v_ui_macrodma_sel
AS
SELECT m.*
FROM v_ui_macrodma m
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (m.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- MACRODQA
CREATE OR REPLACE VIEW v_ui_macrodqa
AS
SELECT DISTINCT ON (m.macrodqa_id) m.macrodqa_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.sector_id,
    m.muni_id,
    m.stylesheet::text AS stylesheet,
    m.lock_level,
    m.link,
    m.addparam::text AS addparam,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
FROM macrodqa m
WHERE m.macrodqa_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (m.expl_id)
  )
ORDER BY m.macrodqa_id;

CREATE OR REPLACE VIEW v_ui_macrodqa_sel
AS
SELECT m.*
FROM v_ui_macrodqa m
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (m.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- DQA
CREATE OR REPLACE VIEW v_ui_dqa
AS
SELECT DISTINCT ON (d.dqa_id) d.dqa_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dqa_type,
    md.name AS macrodqa,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dqa d
LEFT JOIN macrodqa md USING (macrodqa_id)
LEFT JOIN edit_typevalue et ON et.id::text = d.dqa_type::text
    AND et.typevalue = 'dqa_type'
WHERE d.dqa_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (d.expl_id)
  )
ORDER BY d.dqa_id;

CREATE OR REPLACE VIEW v_ui_dqa_sel
AS
SELECT d.*
FROM v_ui_dqa d
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (d.expl_id)
      AND se.cur_user = CURRENT_USER
);

--SUPPLYZONE
CREATE OR REPLACE VIEW v_ui_supplyzone
AS
SELECT DISTINCT ON (d.supplyzone_id) d.supplyzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS supplyzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM supplyzone d
LEFT JOIN edit_typevalue et ON et.id::text = d.supplyzone_type::text
    AND et.typevalue = 'supplyzone_type'
WHERE d.supplyzone_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (d.expl_id)
  )
ORDER BY d.supplyzone_id;

CREATE OR REPLACE VIEW v_ui_supplyzone_sel
AS
SELECT d.*
FROM v_ui_supplyzone d
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (d.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- CRMZONE
CREATE OR REPLACE VIEW v_ui_crmzone
AS
SELECT DISTINCT ON (c.crmzone_id) c.crmzone_id,
    c.code,
    c.name,
    c.descript,
    c.active,
    mc.name AS macrocrmzone,
    c.expl_id,
    c.sector_id,
    c.muni_id,
    c.created_at,
    c.created_by,
    c.updated_at,
    c.updated_by
FROM crmzone c
LEFT JOIN macrocrmzone mc USING (macrocrmzone_id)
WHERE c.crmzone_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (c.expl_id)
  )
ORDER BY c.crmzone_id;

CREATE OR REPLACE VIEW v_ui_crmzone_sel
AS
SELECT c.*
FROM v_ui_crmzone c
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (c.expl_id)
      AND se.cur_user = CURRENT_USER
);
