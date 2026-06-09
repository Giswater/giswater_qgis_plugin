/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4634, 'The following mapzones have no nodeParent: %feature_list%', 'Check for nulls in graphconfigs', 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4636, 'There are no mapzones with no nodeParent', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT DO NOTHING;

UPDATE config_form_fields
SET "label" = NULL, layoutorder = 3
WHERE formname = 'mapzone_manager'
  AND formtype = 'form_mapzone'
  AND tabname = 'tab_none'
  AND columnname = 'chk_active';

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES(
    'mapzone_manager', 'form_mapzone', 'tab_none', 'lbl_show_inactive', 'lyt_mapzone_mng_1', 2,
    NULL, 'label', 'Show inactive', 'Show inactive mapzones', NULL,
    false, false, true, false, false,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    false, NULL
);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES(
    'mapzone_manager', 'form_mapzone', 'tab_none', 'lbl_filter_selector', 'lyt_mapzone_mng_1', 4,
    NULL, 'label', 'Filter by selector', 'Use selector to filter the table', NULL,
    false, false, true, false, false,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    false, NULL
);

INSERT INTO config_form_fields
(formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('mapzone_manager', 'form_mapzone', 'tab_none', 'chk_filter_selector', 'lyt_mapzone_mng_1', 5, 'boolean', 'check', NULL, 'Use selector to filter the table', NULL, false, false, true, false, true, NULL, NULL, NULL, NULL, NULL, NULL, '{"vdefault_value": true}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES(
    'mapzone_manager', 'form_mapzone', 'tab_none', 'hspacer', 'lyt_mapzone_mng_1', 6,
    NULL, 'hspacer', NULL, NULL, NULL,
    false, false, true, false, NULL,
    NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
    false, NULL
);

UPDATE config_form_fields SET layoutorder = 7  WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_flood';
UPDATE config_form_fields SET layoutorder = 8  WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_execute';
UPDATE config_form_fields SET layoutorder = 9  WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_config';
UPDATE config_form_fields SET layoutorder = 10 WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_toggle_active';
UPDATE config_form_fields SET layoutorder = 11 WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_create';
UPDATE config_form_fields SET layoutorder = 12 WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_update';
UPDATE config_form_fields SET layoutorder = 13 WHERE formname = 'mapzone_manager' AND formtype = 'form_mapzone' AND tabname = 'tab_none' AND columnname = 'btn_delete';

CREATE OR REPLACE VIEW vf_exploitation AS 
WITH all_exploitation AS (
    SELECT 
        e.expl_id, EXISTS (
             SELECT 1
            FROM cat_manager cm
            WHERE (
                e.expl_id = ANY (cm.expl_id)
            ) AND (
                EXISTS (
                    SELECT 1
                    FROM unnest(cm.rolename) r(role)
                    WHERE pg_has_role(CURRENT_USER, r.role::name, 'member'::text)))
        ) AS has_permissions
    FROM exploitation e
      WHERE e.active 
      AND e.expl_id > 0
), permission_exploitation as (
    SELECT expl_id
    FROM all_exploitation
    WHERE (
        ((SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_exploitation_x_user') AND has_permissions) 
        OR NOT (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_exploitation_x_user')
    )
)
SELECT *
FROM permission_exploitation;

-- SECTOR
CREATE OR REPLACE VIEW v_ui_sector
AS
SELECT DISTINCT ON (s.sector_id) s.sector_id,
    s.code, s.name, s.descript, s.active,
    et.idval AS sector_type,
    ms.name AS macrosector,
    s.expl_id, s.muni_id, s.avg_press, s.pattern_id,
    s.graphconfig::text AS graphconfig,
    s.stylesheet::text AS stylesheet,
    s.lock_level, s.link, s.addparam::text AS addparam,
    s.created_at, s.created_by, s.updated_at, s.updated_by
FROM sector s
LEFT JOIN macrosector ms USING (macrosector_id)
LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text
    AND et.typevalue = 'sector_type'
WHERE s.sector_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (s.expl_id)
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
    m.code, m.name, m.descript, m.active,
    m.expl_id, m.muni_id,
    m.stylesheet::text AS stylesheet,
    m.lock_level, m.link, m.addparam::text AS addparam,
    m.created_at, m.created_by, m.updated_at, m.updated_by
FROM macrosector m
WHERE m.macrosector_id > 0
  AND EXISTS (
      SELECT 1 FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (m.expl_id)
  )
ORDER BY m.macrosector_id;

CREATE OR REPLACE VIEW v_ui_macrosector_sel
AS
SELECT m.*
FROM v_ui_macrosector m
WHERE EXISTS (
    SELECT 1 FROM selector_macrosector ss
    WHERE ss.macrosector_id = m.macrosector_id
      AND ss.cur_user = CURRENT_USER
);

-- DMA
CREATE OR REPLACE VIEW v_ui_dma
AS
SELECT DISTINCT ON (d.dma_id) d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dma_type,
    md.name AS macrodma,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.avg_press,
    d.pattern_id,
    d.effc,
    d.graphconfig::text AS graphconfig,
    d.stylesheet::text AS stylesheet,
    d.lock_level,
    d.link,
    d.addparam::text AS addparam,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
FROM dma d
LEFT JOIN macrodma md USING (macrodma_id)
LEFT JOIN edit_typevalue et ON et.id::text = d.dma_type::text
    AND et.typevalue = 'dma_type'
WHERE d.dma_id > 0
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (d.expl_id)
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
  AND EXISTS (
      SELECT 1
      FROM vf_exploitation ve
      WHERE ve.expl_id = ANY (m.expl_id)
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
