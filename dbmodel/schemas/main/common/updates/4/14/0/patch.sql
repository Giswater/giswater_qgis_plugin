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
        e.expl_id,
        e.name, EXISTS (
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
    SELECT expl_id, name
    FROM all_exploitation
    WHERE (
        ((SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_exploitation_x_user') AND has_permissions) 
        OR NOT (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_exploitation_x_user')
    )
)
SELECT *
FROM permission_exploitation;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4638, 'This action cannot be performed because it affects a network you don''t have permissions to view', NULL, 2, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

UPDATE config_toolbox SET inputparams = replace(
inputparams::text,
'SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC',
'SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM vf_exploitation ) a ORDER BY sort_order ASC, idval ASC'
)::json
WHERE inputparams::text ILIKE '%SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC%';


CREATE OR REPLACE VIEW ve_exploitation
AS SELECT expl_id,
    code,
    name,
    macroexpl_id,
    owner_vdefault,
    descript,
    lock_level,
    active,
    the_geom,
    created_at,
    created_by,
    updated_at,
    updated_by
FROM exploitation e
WHERE EXISTS (
        SELECT 1
        FROM vf_exploitation ve
        WHERE ve.expl_id = e.expl_id
    );

UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::text, 've_municipality', 've_exploitation')::json
WHERE widgetcontrols::text ILIKE '%ve_municipality%' AND columnname = 'expl_visibility'AND formname ILIKE '%ve_element%';

UPDATE config_form_fields SET widgetcontrols = replace(widgetcontrols::text, 'muni_id', 'expl_id')::json
WHERE widgetcontrols::text ILIKE '%muni_id%' AND columnname = 'expl_visibility'AND formname ILIKE '%ve_element%';

UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 've_exploitation', 'vf_exploitation')
WHERE dv_querytext ILIKE '%ve_exploitation%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'exploitation', 'vf_exploitation')
WHERE dv_querytext ILIKE '%exploitation%' AND dv_querytext NOT ILIKE '%vf_exploitation%' AND dv_querytext NOT ILIKE '%macroexploitation%';

