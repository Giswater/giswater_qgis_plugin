/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- SECTOR
CREATE OR REPLACE VIEW v_ui_sector
AS
SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    et.idval AS sector_type,
    ms.name AS macrosector,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text AS graphconfig,
    s.stylesheet::text AS stylesheet,
    s.lock_level,
    s.link,
    s.addparam::text AS addparam,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
FROM sector s
LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text
    AND et.typevalue = 'sector_type'
WHERE s.sector_id > 0
  AND (
      s.expl_id IS NULL
      OR s.expl_id = '{}'::int4[]
      OR 0 = ANY (s.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (s.expl_id)
      )
  )
ORDER BY s.sector_id;

CREATE OR REPLACE VIEW ve_sector
AS
SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    s.sector_type,
    s.macrosector_id,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text AS graphconfig,
    s.stylesheet::text AS stylesheet,
    s.lock_level,
    s.link,
    s.the_geom,
    s.addparam::text AS addparam,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
FROM sector s
WHERE s.sector_id > 0
  AND (
      s.expl_id IS NULL
      OR s.expl_id = '{}'::int4[]
      OR 0 = ANY (s.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (s.expl_id)
      )
  )
ORDER BY s.sector_id;

CREATE OR REPLACE VIEW v_ui_sector_sel
AS
SELECT s.*
FROM v_ui_sector s
WHERE EXISTS (
    SELECT 1
    FROM selector_sector ss
    WHERE ss.sector_id = s.sector_id
      AND ss.cur_user = CURRENT_USER
);

-- MACROSECTOR
CREATE OR REPLACE VIEW v_ui_macrosector
AS
SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.muni_id,
    m.stylesheet::text AS stylesheet,
    m.lock_level,
    m.link,
    m.addparam::text AS addparam,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
FROM macrosector m
WHERE m.macrosector_id > 0
  AND (
      m.expl_id IS NULL
      OR m.expl_id = '{}'::int4[]
      OR 0 = ANY (m.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (m.expl_id)
      )
  )
ORDER BY m.macrosector_id;

CREATE OR REPLACE VIEW ve_macrosector
AS
SELECT DISTINCT ON (m.macrosector_id) m.macrosector_id,
    m.code,
    m.name,
    m.descript,
    m.active,
    m.expl_id,
    m.muni_id,
    m.stylesheet::text AS stylesheet,
    m.lock_level,
    m.link,
    m.the_geom,
    m.addparam::text AS addparam,
    m.created_at,
    m.created_by,
    m.updated_at,
    m.updated_by
FROM macrosector m
WHERE m.macrosector_id > 0
  AND (
      m.expl_id IS NULL
      OR m.expl_id = '{}'::int4[]
      OR 0 = ANY (m.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (m.expl_id)
      )
  )
ORDER BY m.macrosector_id;

CREATE OR REPLACE VIEW v_ui_macrosector_sel
AS
SELECT m.*
FROM v_ui_macrosector m
WHERE EXISTS (
    SELECT 1
    FROM selector_macrosector ss
    WHERE ss.macrosector_id = m.macrosector_id
      AND ss.cur_user = CURRENT_USER
);

-- DMA
CREATE OR REPLACE VIEW v_ui_dma
AS
SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.effc,
    d.graphconfig::text AS graphconfig,
    d.stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dma d
LEFT JOIN edit_typevalue et ON et.id::text = d.dma_type::text
    AND et.typevalue = 'dma_type'
WHERE d.dma_id > 0
  AND (
      d.expl_id IS NULL
      OR d.expl_id = '{}'::int4[]
      OR 0 = ANY (d.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (d.expl_id)
      )
  );

CREATE OR REPLACE VIEW ve_dma
AS
SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.effc,
    d.graphconfig::text AS graphconfig,
    d.stylesheet,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dma d
WHERE d.dma_id > 0
  AND (
      d.expl_id IS NULL
      OR d.expl_id = '{}'::int4[]
      OR 0 = ANY (d.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (d.expl_id)
      )
  );

CREATE OR REPLACE VIEW v_ui_dma_sel
AS
SELECT d.*
FROM v_ui_dma d
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (d.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- MACROOMZONE
CREATE OR REPLACE VIEW v_ui_macroomzone
AS
SELECT DISTINCT ON (m.macroomzone_id) m.macroomzone_id,
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
FROM macroomzone m
WHERE m.macroomzone_id > 0
  AND (
      m.expl_id IS NULL
      OR m.expl_id = '{}'::int4[]
      OR 0 = ANY (m.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (m.expl_id)
      )
  )
ORDER BY m.macroomzone_id;

CREATE OR REPLACE VIEW ve_macroomzone
AS
SELECT DISTINCT ON (m.macroomzone_id) m.macroomzone_id,
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
    m.updated_by,
    m.the_geom
FROM macroomzone m
WHERE m.macroomzone_id > 0
  AND (
      m.expl_id IS NULL
      OR m.expl_id = '{}'::int4[]
      OR 0 = ANY (m.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (m.expl_id)
      )
  )
ORDER BY m.macroomzone_id;

CREATE OR REPLACE VIEW v_ui_macroomzone_sel
AS
SELECT m.*
FROM v_ui_macroomzone m
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (m.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- DRAINZONE
CREATE OR REPLACE VIEW v_ui_drainzone
AS
SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM drainzone d
LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text
    AND et.typevalue = 'drainzone_type'
WHERE d.drainzone_id > 0
  AND (
      d.expl_id IS NULL
      OR d.expl_id = '{}'::int4[]
      OR 0 = ANY (d.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (d.expl_id)
      )
  )
ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW ve_drainzone
AS
SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by,
    d.the_geom
FROM drainzone d
WHERE d.drainzone_id > 0
  AND (
      d.expl_id IS NULL
      OR d.expl_id = '{}'::int4[]
      OR 0 = ANY (d.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (d.expl_id)
      )
  )
ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW v_ui_drainzone_sel
AS
SELECT d.*
FROM v_ui_drainzone d
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (d.expl_id)
      AND se.cur_user = CURRENT_USER
);

--DWFZONE
CREATE OR REPLACE VIEW v_ui_dwfzone
AS
SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dwfzone_type,
    da.name AS drainzone,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dwfzone d
LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text
    AND et.typevalue = 'dwfzone_type'
LEFT JOIN drainzone da ON d.drainzone_id = da.drainzone_id
WHERE d.dwfzone_id > 0
  AND (
      d.expl_id IS NULL
      OR d.expl_id = '{}'::int4[]
      OR 0 = ANY (d.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (d.expl_id)
      )
  )
ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW ve_dwfzone
AS
SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dwfzone_type,
    d.drainzone_id,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dwfzone d
WHERE d.dwfzone_id > 0
  AND (
      d.expl_id IS NULL
      OR d.expl_id = '{}'::int4[]
      OR 0 = ANY (d.expl_id)
      OR EXISTS (
          SELECT 1
          FROM vf_exploitation ve
          WHERE ve.expl_id = ANY (d.expl_id)
      )
  )
ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW v_ui_dwfzone_sel
AS
SELECT d.*
FROM v_ui_dwfzone d
WHERE EXISTS (
    SELECT 1
    FROM selector_expl se
    WHERE se.expl_id = ANY (d.expl_id)
      AND se.cur_user = CURRENT_USER
);

-- DRAINZONE
UPDATE config_form_fields
SET iseditable = true, ismandatory = true,
    widgettype = 'multiple_option',
    dv_querytext = 'SELECT expl_id AS id, name AS idval FROM vf_exploitation WHERE expl_id > 0',
    widgetcontrols = '{"setMultiline": false, "valueRelation": {"layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json
WHERE formname = 've_drainzone' AND formtype = 'form_feature' AND columnname = 'expl_id' AND tabname = 'tab_none';

UPDATE config_form_fields
SET iseditable = true, ismandatory = true,
    widgettype = 'multiple_option',
    dv_querytext = 'SELECT muni_id AS id, name AS idval FROM ve_municipality WHERE muni_id > 0',
    widgetcontrols = '{"setMultiline": false, "valueRelation": {"layer": "ve_municipality", "activated": true, "keyColumn": "muni_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json
WHERE formname = 've_drainzone' AND formtype = 'form_feature' AND columnname = 'muni_id' AND tabname = 'tab_none';

UPDATE config_form_fields
SET iseditable = true, ismandatory = true,
    widgettype = 'multiple_option',
    dv_querytext = 'SELECT sector_id AS id, name AS idval FROM ve_sector WHERE active IS TRUE',
    widgetcontrols = '{"setMultiline": false, "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json
WHERE formname = 've_drainzone' AND formtype = 'form_feature' AND columnname = 'sector_id' AND tabname = 'tab_none';

-- DWFZONE
UPDATE config_form_fields
SET iseditable = true, ismandatory = true,
    widgettype = 'multiple_option',
    dv_querytext = 'SELECT expl_id AS id, name AS idval FROM vf_exploitation WHERE expl_id > 0',
    widgetcontrols = '{"setMultiline": false, "valueRelation": {"layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json
WHERE formname = 've_dwfzone' AND formtype = 'form_feature' AND columnname = 'expl_id' AND tabname = 'tab_none';

UPDATE config_form_fields
SET iseditable = true, ismandatory = true,
    widgettype = 'multiple_option',
    dv_querytext = 'SELECT muni_id AS id, name AS idval FROM ve_municipality WHERE muni_id > 0',
    widgetcontrols = '{"setMultiline": false, "valueRelation": {"layer": "ve_municipality", "activated": true, "keyColumn": "muni_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json
WHERE formname = 've_dwfzone' AND formtype = 'form_feature' AND columnname = 'muni_id' AND tabname = 'tab_none';

UPDATE config_form_fields
SET iseditable = true, ismandatory = true,
    widgettype = 'multiple_option',
    dv_querytext = 'SELECT sector_id AS id, name AS idval FROM ve_sector WHERE active IS TRUE',
    widgetcontrols = '{"setMultiline": false, "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json
WHERE formname = 've_dwfzone' AND formtype = 'form_feature' AND columnname = 'sector_id' AND tabname = 'tab_none';
