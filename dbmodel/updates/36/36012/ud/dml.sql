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
INSERT INTO config_style VALUES (101, 'GwBasic', NULL, 'role_basic', '{"orderBy":1}', false, true);
INSERT INTO config_style VALUES (102, 'GwEpa', NULL, 'role_basic', '{"orderBy":2}', false, true);
INSERT INTO config_style VALUES (103, 'GwGraphConfig', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (104, 'GwInpLog', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (105, 'GwFlowTrace', NULL, NULL, NULL, true, true);
INSERT INTO config_style VALUES (106, 'GwFlowExit', NULL, NULL, NULL, true, true);

UPDATE sys_style SET layername='line', styleconfig_id = 104 WHERE layername='INP result line';
UPDATE sys_style SET layername='point', styleconfig_id = 104 WHERE layername='INP result point';
UPDATE sys_style SET layername='line', styleconfig_id = 105 WHERE layername='Flow trace arc';
UPDATE sys_style SET layername='point', styleconfig_id = 105 WHERE layername='Flow trace node';
UPDATE sys_style SET layername='line', styleconfig_id = 106 WHERE layername='Flow exit arc';
UPDATE sys_style SET layername='point', styleconfig_id = 106 WHERE layername='Flow exit node';

UPDATE sys_style SET layername='v_edit_arc', styleconfig_id = 102 WHERE layername='v_edit_arc SWMM point of view';
UPDATE sys_style SET layername='v_edit_connec', styleconfig_id = 102 WHERE layername='v_edit_gully SWMM point of view';
UPDATE sys_style SET layername='v_edit_node', styleconfig_id = 102 WHERE layername='v_edit_node SWMM point of view';
UPDATE sys_style SET layername='v_edit_link', styleconfig_id = 102 WHERE layername='v_edit_link SWMM point of view';

UPDATE sys_style SET styleconfig_id = 101 WHERE styleconfig_id is null;

ALTER TABLE sys_style ALTER COLUMN styleconfig_id SET NOT NULL;

UPDATE link SET muni_id = g.muni_id FROM gully g WHERE gully_id =  feature_id;

INSERT INTO sys_function VALUES
(3054,'gw_fct_setmapzoneconfig','utils','function','json','json',
'Function that changes configuration of a mapzone after using node replace, arc fusion or divide tool on features that are involved in a mapzone',
'role_edit','','core');

UPDATE config_form_tableview SET columnindex=4 WHERE objectname='v_ui_rpt_cat_result' AND columnname='status';
UPDATE config_form_tableview SET columnindex=6 WHERE objectname='v_ui_rpt_cat_result' AND columnname='descript';
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('epa_toolbar', 'utils', 'v_ui_rpt_cat_result', 'iscorporate', 5, true, NULL, NULL, NULL, NULL);


DELETE FROM sys_table WHERE id = 'v_anl_pgrouting_arc';
DELETE FROM sys_table WHERE id = 'v_anl_pgrouting_node';

DELETE FROM sys_table WHERE id = 'v_edit_man_netelement';


DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_downstream_recursive';
DELETE FROM sys_function WHERE function_name = 'gw_fct_graphanalytics_upstream_recursive';

drop view if exists vi_parent_arc;


--27/08/2024
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_node', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('rpt_arc', NULL, 'role_epa', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('selector_period', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_hydroval', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('v_ui_drainzone', NULL, 'role_basic', 'core') ON CONFLICT (id) DO NOTHING ;

UPDATE sys_table SET id='v_rpt_lidperformance_sum' WHERE id='v_rpt_lidperfomance_sum';
UPDATE sys_table SET id='v_rpt_comp_lidperformance_sum' WHERE id='v_rpt_comp_lidperfomance_sum';
UPDATE sys_style SET layername='v_rpt_lidperformance_sum' WHERE layername='v_rpt_lidperfomance_sum';
UPDATE sys_style SET layername='v_rpt_comp_lidperformance_sum' WHERE layername='v_rpt_comp_lidperfomance_sum';

UPDATE sys_table SET id='v_rpt_subcatchwashoff_sum' WHERE id='v_rpt_subcatchwasoff_sum';
UPDATE sys_table SET id='v_rpt_comp_subcatchwashoff_sum' WHERE id='v_rpt_comp_subcatchwasoff_sum';
UPDATE sys_style SET layername='v_rpt_subcatchwashoff_sum' WHERE layername='v_rpt_subcatchwasoff_sum';
UPDATE sys_style SET layername='v_rpt_comp_subcatchwashoff_sum' WHERE layername='v_rpt_comp_subcatchwasoff_sum';
UPDATE config_form_fields SET formname='v_rpt_subcatchwashoff_sum' WHERE formname='v_rpt_subcatchwasoff_sum';
UPDATE config_form_fields SET formname='v_rpt_comp_subcatchwashoff_sum' WHERE formname='v_rpt_comp_subcatchwasoff_sum';

-- 28/08/2024
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('gully', 'form_feature', 'tab_none', 'btn_accept', 'lyt_buttons', 0, NULL, 'button', NULL, 'Accept', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Accept"}'::json, '{"functionName": "accept", "params": {}}'::json, NULL, false, 0);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('gully', 'form_feature', 'tab_none', 'btn_apply', 'lyt_buttons', 0, NULL, 'button', NULL, 'Apply', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Apply"}'::json, '{"functionName": "apply", "params": {}}'::json, NULL, false, 1);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('gully', 'form_feature', 'tab_none', 'btn_cancel', 'lyt_buttons', 0, NULL, 'button', NULL, 'Cancel', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"text":"Cancel"}'::json, '{"functionName": "cancel", "params": {}}'::json, NULL, false, 2);

-- 29/08/2024
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_result_status', '3', 'ARCHIVED', NULL, NULL);

-- get values by intersection
update drainzone d set sector_id = s.sector_id from sector s where st_intersects(s.the_geom, d.the_geom);

update raingage r set muni_id = a.muni_id from (
select r.rg_id, m.muni_id from raingage r left join ext_municipality m on st_dwithin (m.the_geom, r.the_geom, 0.01)
)a where r.rg_id = a.rg_id;


update "element" e set muni_id = a.muni_id, sector_id = a.sector_id from (
select element_id, gully_id, g.muni_id, g.sector_id from element_x_gully
left join gully g using (gully_id)
)a where e.element_id = a.element_id;

update "element" set sector_id = 0 where sector_id is null;

update link b set sector_id = a.sector_id, muni_id = a.muni_id from (
select feature_id, c.sector_id, c.muni_id from link l
left join gully c on l.feature_id = c.gully_id where l.feature_type = 'GULLY'
)a where b.feature_id = a.feature_id;


update om_visit e set muni_id = a.muni_id, sector_id = a.sector_id from (
select visit_id, gully_id, n.muni_id, n.sector_id from om_visit_x_gully
    left join gully n using (gully_id)
)a where e.id = a.visit_id;

update om_visit set sector_id = 0 where sector_id is null;

-- 03/09/2024
UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml","id":"106"},"line":{"style":"qml","id":"106"}}}'::json
	WHERE id=2214;
UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml","id":"105"},"line":{"style":"qml","id":"105"}}}'::json
	WHERE id=2218;

