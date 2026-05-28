/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"inp_timeseries", "column":"addparam"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timeseries", "column":"addparam", "dataType":"json"}}$$);

CREATE OR REPLACE VIEW v_edit_inp_dwf AS 
 SELECT i.dwfscenario_id,
    node_id,
    i.value,
    i.pat1,
    i.pat2,
    i.pat3,
    i.pat4,
    the_geom
   FROM config_param_user c, inp_dwf i
   JOIN v_edit_inp_junction USING (node_id)
   WHERE c.cur_user::name = CURRENT_USER AND c.parameter::text = 'inp_options_dwfscenario'::text AND c.value::integer = i.dwfscenario_id;


DROP VIEW v_edit_inp_orifice;
 CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
 SELECT v_edit_arc.arc_id,
    v_edit_arc.node_1,
    v_edit_arc.node_2,
    v_edit_arc.y1,
    v_edit_arc.custom_y1,
    v_edit_arc.elev1,
    v_edit_arc.custom_elev1,
    v_edit_arc.sys_elev1,
    v_edit_arc.y2,
    v_edit_arc.custom_y2,
    v_edit_arc.elev2,
    v_edit_arc.custom_elev2,
    v_edit_arc.sys_elev2,
    v_edit_arc.arccat_id,
    v_edit_arc.gis_length,
    v_edit_arc.sector_id,
    v_edit_arc.macrosector_id,
    v_edit_arc.state,
    v_edit_arc.state_type,
    v_edit_arc.annotation,
    v_edit_arc.inverted_slope,
    v_edit_arc.custom_length,
    v_edit_arc.expl_id,
    inp_orifice.ori_type,
    inp_orifice.offsetval,
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    v_edit_arc.the_geom,
    inp_orifice.close_time
   FROM v_edit_arc
     JOIN inp_orifice USING (arc_id)
  WHERE v_edit_arc.is_operative IS TRUE;

CREATE TRIGGER gw_trg_edit_inp_arc_orifice
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_orifice
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_orifice');


CREATE OR REPLACE VIEW v_edit_inp_subcatchment AS 
 SELECT a.* from (SELECT inp_subcatchment.hydrology_id,
    inp_subcatchment.subc_id,
    inp_subcatchment.outlet_id,
    inp_subcatchment.rg_id,
    inp_subcatchment.area,
    inp_subcatchment.imperv,
    inp_subcatchment.width,
    inp_subcatchment.slope,
    inp_subcatchment.clength,
    inp_subcatchment.snow_id,
    inp_subcatchment.nimp,
    inp_subcatchment.nperv,
    inp_subcatchment.simp,
    inp_subcatchment.sperv,
    inp_subcatchment.zero,
    inp_subcatchment.routeto,
    inp_subcatchment.rted,
    inp_subcatchment.maxrate,
    inp_subcatchment.minrate,
    inp_subcatchment.decay,
    inp_subcatchment.drytime,
    inp_subcatchment.maxinfil,
    inp_subcatchment.suction,
    inp_subcatchment.conduct,
    inp_subcatchment.initdef,
    inp_subcatchment.curveno,
    inp_subcatchment.conduct_2,
    inp_subcatchment.drytime_2,
    inp_subcatchment.sector_id,
    inp_subcatchment.the_geom,
    inp_subcatchment.descript,
    inp_subcatchment.minelev,
    muni_id
   FROM inp_subcatchment
   LEFT JOIN node ON node_id = outlet_id
   ) a, config_param_user, selector_sector, selector_municipality
   WHERE a.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
   AND a.muni_id = selector_municipality.muni_id AND selector_municipality.cur_user = "current_user"()::text 
   AND a.hydrology_id = config_param_user.value::integer AND config_param_user.cur_user::text = "current_user"()::text 
   AND config_param_user.parameter::text = 'inp_options_hydrology_scenario'::text;



CREATE OR REPLACE VIEW v_rpt_arcflow_sum AS 
 SELECT rpt_inp_arc.id,
    rpt_inp_arc.arc_id,
    rpt_inp_arc.result_id,
    rpt_inp_arc.arc_type,
    rpt_inp_arc.arccat_id,
    rpt_inp_arc.sector_id,
    rpt_inp_arc.the_geom,
    rpt_arcflow_sum.arc_type AS swarc_type,
    rpt_arcflow_sum.max_flow,
    rpt_arcflow_sum.time_days,
    rpt_arcflow_sum.time_hour,
    rpt_arcflow_sum.max_veloc,
    coalesce(rpt_arcflow_sum.mfull_flow,0::numeric(12,4)) as mfull_flow,
    coalesce(rpt_arcflow_sum.mfull_dept,0::numeric(12,4)) as mfull_dept,
    rpt_arcflow_sum.max_shear,
    rpt_arcflow_sum.max_hr,
    rpt_arcflow_sum.max_slope,
    rpt_arcflow_sum.day_max,
    rpt_arcflow_sum.time_max,
    rpt_arcflow_sum.min_shear,
    rpt_arcflow_sum.day_min,
    rpt_arcflow_sum.time_min
   FROM selector_rpt_main,
    rpt_inp_arc
     JOIN rpt_arcflow_sum ON rpt_arcflow_sum.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_arcflow_sum.result_id::text = selector_rpt_main.result_id::text AND selector_rpt_main.cur_user = "current_user"()::text AND rpt_inp_arc.result_id::text = selector_rpt_main.result_id::text;



CREATE OR REPLACE VIEW v_state_link_connec AS 
WITH 
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link_gully AS 
WITH 
p AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_state_link AS
WITH 
c AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
g AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT c.link_id FROM sp, se, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	EXCEPT ALL
SELECT g.link_id FROM sp, se, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT c.link_id FROM sp, se, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT g.link_id FROM sp, se, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;
   

DELETE FROM sys_table WHERE id='archived_rpt_inp_pattern_value';

UPDATE sys_table SET context='{"level_1":"EPA","level_2":"HYDROLOGY"}', alias='Dry Weather Flows (DWF)', orderby=5 WHERE id  = 'v_edit_inp_dwf';

UPDATE config_toolbox SET inputparams = '
[
{"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT hydrology_id as id, name as idval FROM cat_hydrology WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":"$userDscenario"},
{"widgetname":"name", "label":"Name: (*)","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for hydrology scenario (mandatory)", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"text", "label":"Text:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Text of hydrology scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"hydrology scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":6, "value":"true"}
]'
WHERE id = 3294;

UPDATE config_form_fields SET iseditable = true where columnname = 'to_arc';

UPDATE config_form_fields SET iseditable = true where columnname like '%road%';

UPDATE config_form_fields SET iseditable = true where columnname like 'coef_curve';

UPDATE config_form_fields SET hidden = true where columnname in ('geom3', 'geom4') and formname like '%orifice%';

UPDATE config_form_fields SET hidden = true where columnname in ('apond') and formname like '%storage%';

UPDATE sys_param_user SET dv_isnullvalue = true where id = 'inp_options_hydrology_scenario';

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario', 'LIDS', 'LIDS');

UPDATE config_form_fields SET linkedobject='tbl_event_x_gully' WHERE formname='gully' AND formtype='form_feature' AND tabname='tab_event' AND linkedobject = 'tbl_visit_x_gully';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3326, 'gw_fct_epa_hydraulic_performance', 'ud', 'function', 'json', 'json', 'Function to calculate the hydraulic performance of network', 'role_epa', NULL, 'core');

INSERT INTO config_toolbox
VALUES (3326, 'Calculate the hydraulic performance for specific result','{"featureType":[]}',
'[
{"widgetname":"resultId", "label":"Result_id:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Result_id", "dvQueryText":"SELECT result_id as id,  result_id as idval FROM rpt_cat_result WHERE status = 2","layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"wwtpOutfalls", "label":"Outfalls as WWTP:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Outfalls as WWTP", "placeholder":"234,235,3246", "layoutname":"grl_option_parameters","layoutorder":2, "value":""}
]'
,null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess VALUES (531, 'fprocess to calculate the performance of ud networks','ud',null,'core',FALSE, 'Function process')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, widgettype, label, tooltip, ismandatory, isparent, iseditable, dv_querytext, dv_orderby_id, dv_isnullvalue, hidden)
SELECT 'v_edit_raingage', 'form_feature', 'tab_none', columnname, widgettype, label, tooltip, false, isparent, iseditable, 'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL', dv_orderby_id, dv_isnullvalue, hidden FROM config_form_fields
WHERE columnname  = 'muni_id' AND formname = 'v_ext_address';

UPDATE sys_param_user set dv_querytext = 'SELECT id, id as idval FROM v_edit_inp_timeseries WHERE timser_type= ''Rainfall'' and active' where id = 'inp_options_setallraingages';

INSERT INTO inp_typevalue VALUES ('inp_value_options_in','MODIFIED_GREEN_AMPT','MODIFIED_GREEN_AMPT');

UPDATE sys_function SET descript='Function to manage values of defined target hydrology catalog (delete or copy from another one). It works with all objects linked with hydrology catalog (Subcatchment, Lids, Loadings, Coverages and Groundwater).' WHERE id=3100 AND function_name='gw_fct_manage_hydrology_values';

UPDATE sys_param_user SET placeholder = 'MM/DD/YYYY' WHERE id in ('inp_options_end_date','inp_options_start_date', 'inp_options_report_start_date');


UPDATE config_form_tabs
	SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionMapZone","actionTooltip": "Add Mapzone","disabled": false},{"actionName": "actionGetParentId","actionTooltip": "Set parent_id","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionRotation","actionTooltip": "Rotation","disabled": false},{"actionName": "actionRotation","disabled": false}]'::json
	WHERE formname='v_edit_node' AND tabname='tab_epa';
UPDATE config_form_tabs
	SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionOrifice","actionTooltip": "Orifice","disabled": false},{"actionName": "actionOutlet","actionTooltip": "Outlet","disabled": false},{"actionName": "actionPump","actionTooltip": "Pump","disabled": false},{"actionName": "actionWeir","actionTooltip": "Weir","disabled": false},{"actionName": "actionDemand","actionTooltip": "DWF","disabled": false}]'::json
	WHERE formname='ve_epa_junction' AND tabname='tab_epa';
UPDATE config_form_tabs
	SET tabactions='[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionOrifice","actionTooltip": "Orifice","disabled": false},{"actionName": "actionOutlet","actionTooltip": "Outlet","disabled": false},{"actionName": "actionPump","actionTooltip": "Pump","disabled": false},{"actionName": "actionWeir","actionTooltip": "Weir","disabled": false}]'::json
	WHERE formname='ve_epa_storage' AND tabname='tab_epa';

ALTER TABLE cat_dwf_scenario ADD CONSTRAINT cat_dwf_scenario_unique_idval UNIQUE(idval);
ALTER TABLE cat_hydrology ADD CONSTRAINT cat_hydrology_unique_name UNIQUE(name);

ALTER TABLE inp_dscenario_lid_usage DROP CONSTRAINT inp_dscenario_lid_usage_pkey;

ALTER TABLE inp_dscenario_lid_usage ADD CONSTRAINT inp_dscenario_lid_usage_pkey PRIMARY KEY(dscenario_id, subc_id);

ALTER TABLE inp_dscenario_lid_usage ALTER COLUMN lidco_id DROP NOT NULL;

SELECT * FROM config_form_fields where columnname = 'lidco_id';

ALTER TABLE temp_lid_usage DROP CONSTRAINT temp_lid_usage_pkey ;

ALTER TABLE temp_lid_usage ADD CONSTRAINT temp_lid_usage_pkey PRIMARY KEY(subc_id);

ALTER TABLE temp_lid_usage ALTER COLUMN lidco_id DROP NOT NULL;

INSERT INTO config_fprocess VALUES (140,'rpt_lidperformance_sum', 'LID Performance Summary', 88);

ALTER TABLE rpt_runoff_quant ADD CONSTRAINT rpt_runoff_quant_unique_result_id UNIQUE (result_id);

ALTER TABLE rpt_flowrouting_cont ADD CONSTRAINT rpt_flowrouting_cont_unique_result_id UNIQUE (result_id);

ALTER TABLE temp_lid_usage DROP CONSTRAINT temp_lid_usage_pkey;
ALTER TABLE temp_lid_usage  ADD CONSTRAINT temp_lid_usage_pkey PRIMARY KEY(subc_id,lidco_id);
