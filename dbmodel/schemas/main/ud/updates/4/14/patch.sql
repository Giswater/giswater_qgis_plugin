/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--DRAINZONE
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
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (d.expl_id)
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
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (d.expl_id)
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
