/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_fprocess SET project_type = 'ud' where fid = 522;


-- tabs arc
UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_arc' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_arc' AND tabname='tab_relations';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_arc' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_arc' AND tabname='tab_documents';

UPDATE config_form_tabs
    SET orderby=6
    WHERE formname='v_edit_arc' AND tabname='tab_plan';

-- tabs connec
UPDATE config_form_tabs
    SET orderby=1
    WHERE formname='v_edit_connec' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_connec' AND tabname='tab_hydrometer';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_connec' AND tabname='tab_hydrometer_val';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_connec' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_connec' AND tabname='tab_documents';

-- tabs node
UPDATE config_form_tabs
    SET orderby=2
    WHERE formname='v_edit_node' AND tabname='tab_connections';

UPDATE config_form_tabs
    SET orderby=3
    WHERE formname='v_edit_arc' AND tabname='tab_elements';

UPDATE config_form_tabs
    SET orderby=4
    WHERE formname='v_edit_arc' AND tabname='tab_event';

UPDATE config_form_tabs
    SET orderby=5
    WHERE formname='v_edit_arc' AND tabname='tab_documents';

UPDATE config_form_tabs
    SET orderby=6
    WHERE formname='v_edit_arc' AND tabname='tab_plan';

-- tabs gully
UPDATE config_form_tabs
	SET orderby=2
	WHERE formname='v_edit_gully' AND tabname='tab_elements';
UPDATE config_form_tabs
	SET orderby=3
	WHERE formname='v_edit_gully' AND tabname='tab_documents';
UPDATE config_form_tabs
	SET orderby=4
	WHERE formname='v_edit_gully' AND tabname='tab_event';


UPDATE config_form_tabs
	SET "label"='Connections' WHERE tabname='tab_connections';


-- 07/08/2024
INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype,
label,  tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, hidden)
WITH lyt as (SELECT distinct formname, max(layoutorder) as lytorder from config_form_fields
where layoutname ='lyt_data_2' and formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully') group by formname)
SELECT c.formname, formtype, tabname, 'placement_type', 'lyt_data_2', lytorder+1, datatype, widgettype, 'Placement Type', 'Placement Type', NULL, false, false, true, false, false
FROM config_form_fields c join lyt using (formname) WHERE c.formname  in ('v_edit_node','v_edit_arc','v_edit_connec','ve_node','ve_arc','ve_connec','v_edit_gully', 've_gully')
AND columnname='adate'
group by c.formname, formtype, tabname,  layoutname, datatype, widgettype, label, tooltip, placeholder, ismandatory, isparent,
iseditable, isautoupdate,  dv_querytext, dv_orderby_id, dv_isnullvalue, lytorder, hidden
ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cat_arc_visibility_vdef', '1', 'NO VISITABLE', 'The arc is not visitable', NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cat_arc_visibility_vdef', '2', 'SEMI VISITABLE', 'The arc is semi visitable, in some cases you can visit in others not', NULL);
INSERT INTO edit_typevalue (typevalue, id, idval, descript, addparam) VALUES('cat_arc_visibility_vdef', '3', 'VISITABLE', 'The arc is visitable', NULL);

UPDATE cat_arc SET visitability_vdef=3 WHERE visitability_vdef = 1; -- VISITABLE
UPDATE cat_arc SET visitability_vdef=1 WHERE visitability_vdef = 0; -- NO VISITABLE
UPDATE config_form_fields SET "datatype" = 'integer', widgettype = 'combo', iseditable = true,
hidden = false, dv_querytext = 'SELECT id, idval FROM edit_typevalue WHERE typevalue=''cat_arc_visibility_vdef'''
WHERE columnname = 'visitability' AND "datatype" = 'boolean';

UPDATE sys_table SET sys_role='role_edit' WHERE id='plan_psector_x_gully';

-- 13/08/2024
UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_node_shape WHERE id IS NOT NULL' WHERE formname='cat_node' AND formtype='form_feature' AND columnname='shape' AND tabname='tab_none';

-- 17/08/2024
INSERT INTO sys_foreignkey (typevalue_table, typevalue_name, target_table, target_field, active)
VALUES('config_typevalue', 'sys_style_context', 'sys_style', 'context', true);

INSERT INTO config_typevalue VALUES ('sys_style_context', 'TEMPLAYER', '{"orderBy":0}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'BASIC', '{"orderBy":10}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'SECTOR', '{"orderBy":20}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'DRAINZONE', '{"orderBy":30}');
INSERT INTO config_typevalue VALUES ('sys_style_context', 'SWMM', '{"orderBy":40}');

UPDATE sys_style SET context = 'TEMPLAYER' WHERE idval in ('INP result line', 'INP result point', 'Flow trace arc', 'Flow trace node');
UPDATE sys_style SET context = 'SWMM' WHERE idval in ('v_edit_arc SWMM point of view', 'v_edit_link SWMM point of view', 'v_edit_node SWMM point of view', 'v_edit_gully SWMM point of view');
UPDATE sys_style SET context = 'BASIC' WHERE context is null;
UPDATE sys_style SET idval = replace(idval, ' SWMM point of view', '');

SELECT setval('SCHEMA_NAME.sys_style_id_seq', 220, true);

INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_node', 'SECTOR', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_arc', 'SECTOR', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_connec', 'SECTOR', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_link', 'SECTOR', 'qml');

INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_node', 'DRAINZONE', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_arc', 'DRAINZONE', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_connec', 'DRAINZONE', 'qml');
INSERT INTO sys_style (idval, context, styletype) VALUES ('v_edit_link', 'DRAINZONE', 'qml');

UPDATE link SET muni_id = g.muni_id FROM gully g WHERE gully_id =  feature_id;

INSERT INTO sys_function VALUES
(3054,'gw_fct_setmapzoneconfig','utils','function','json','json',
'Function that changes configuration of a mapzone after using node replace, arc fusion or divide tool on features that are involved in a mapzone',
'role_edit','','core');