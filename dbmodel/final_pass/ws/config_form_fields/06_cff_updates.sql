/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DELETE FROM config_form_fields WHERE (formname ILIKE '%frelem%' OR formname ILIKE '%genelem%') AND tabname = 'tab_none';
DELETE FROM config_form_fields WHERE formname ILIKE '%frelem%' AND columnname = 'nodarc_id';

-- Correct sourcetable in widgetfunction
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_connec",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json
	WHERE formname='connec' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_node",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json
	WHERE formname='node' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json
	WHERE formname='ve_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json
	WHERE formname='ve_link_link' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json
	WHERE formname='ve_link_pipelink' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element_x_link",
    "targetwidget": "tab_elements_tbl_elements",
    "field_object_id": "element_id",
    "sourceview": "element"
  }
}'::json
	WHERE formname='ve_link_vlink' AND formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements';

UPDATE config_form_fields SET dv_querytext = 'WITH check_value AS (
  SELECT value::integer AS psector_value 
  FROM config_param_user 
  WHERE parameter = ''plan_psector_current''
  AND cur_user = current_user
)
SELECT id, name as idval 
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT psector_value FROM check_value) IS NULL THEN id != 2 
  ELSE id=2 
END' WHERE columnname = 'state';



-- last update
-- Normalize "label": replace underscores with spaces, trim, ensure only the first letter is uppercase,
-- and append a colon if missing. Only updates rows needing changes.
UPDATE config_form_fields
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        formname, formtype, columnname, tabname,
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM config_form_fields
) AS sub
WHERE config_form_fields.formname   = sub.formname
  AND config_form_fields.formtype   = sub.formtype
  AND config_form_fields.columnname = sub.columnname
  AND config_form_fields.tabname    = sub.tabname
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );

UPDATE config_param_system
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        "parameter",
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM config_param_system
) AS sub
WHERE config_param_system."parameter" = sub."parameter"
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );

UPDATE config_form_fields SET "datatype"='string', widgettype='combo', ismandatory=false, iseditable=false, dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE ((featurecat_id is null AND feature_type=''NODE'') ) AND active IS TRUE  OR ''WATER_CONNECTION'' = ANY(featurecat_id::text[])', dv_isnullvalue=true WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DELETE FROM config_form_fields WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='n_hydrometer' AND tabname='tab_none';

-- 08/08/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder, field_layoutorder)
VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder, field_layoutorder)
VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder, field_layoutorder)
VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder, field_layoutorder)
VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder, field_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder, field_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2, NULL)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;