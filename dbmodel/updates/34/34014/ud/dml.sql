/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/02
UPDATE sys_table SET id='cat_feature_gully' WHERE id = 'gully_type';

-- 2020/06/16
INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  placeholder,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, hidden) VALUES ('upsert_catalog_gully', 'form_catalog', 'geom1', 3, 'string', 'combo', 'geom1', 'Ex.:geom1', FALSE, FALSE, TRUE, FALSE, 'SELECT DISTINCT(geom1) AS id,  geom1  AS idval FROM cat_arc WHERE id IS NOT NULL', TRUE, FALSE, 'matcat_id', ' AND cat_arc.matcat_id   ', 'lyt_data_1', FALSE);
INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  placeholder,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, hidden) VALUES ('upsert_catalog_gully', 'form_catalog', 'id', 4, 'string', 'combo', 'id', 'Ex.:id', FALSE, FALSE, TRUE, FALSE, 'SELECT DISTINCT (id) AS id, id AS idval FROM cat_arc WHERE id IS NOT NULL', TRUE, FALSE, NULL, NULL, 'lyt_data_1', FALSE);
INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  placeholder,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, hidden) VALUES ('upsert_catalog_gully', 'form_catalog', 'matcat_id', 1, 'string', 'combo', 'material', 'Ex.:material', FALSE, TRUE, TRUE, FALSE, 'SELECT DISTINCT(matcat_id) AS id,  matcat_id  AS idval FROM cat_arc WHERE id IS NOT NULL', TRUE, FALSE, 'arccat_id', NULL, 'lyt_data_1', FALSE);
INSERT INTO config_form_fields (formname, formtype, columnname,  layoutorder, datatype, widgettype, label,  placeholder,  ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, layoutname, hidden) VALUES ('upsert_catalog_gully', 'form_catalog', 'shape', 2, 'string', 'combo', 'shape', 'Ex.:shape', FALSE, FALSE, TRUE, FALSE, 'SELECT DISTINCT(shape) AS id,  shape  AS idval FROM cat_arc WHERE id IS NOT NULL', TRUE, FALSE, 'matcat_id', ' AND cat_arc.matcat_id   ', 'lyt_data_1', FALSE);
