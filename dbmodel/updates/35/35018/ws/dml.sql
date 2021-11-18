/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/11

-- fix pjoint_id & pjoint_type for connecs with link
UPDATE connec SET pjoint_id = exit_id, pjoint_type = exit_type 
FROM (select feature_id, exit_id, exit_type from link where feature_id IN (select connec_id from connec where pjoint_id is null) 
AND exit_type IN ('NODE', 'VNODE'))a
WHERE connec_id  = feature_id AND pjoint_id IS NULL;

-- fix pjoint_id & pjoint_type for connecs without lik over arcs
UPDATE connec b SET pjoint_id = b.connec_id, pjoint_type='CONNEC' FROM (
SELECT a.arc_id, c.connec_id FROM arc a,
(SELECT DISTINCT ON (connec_id) connec_id, the_geom FROM connec where pjoint_id IS NULL OR pjoint_type IS NULL AND state=1)c
WHERE public.st_dwithin (a.the_geom, c.the_geom, 0.01) AND a.state=1
)d WHERE b.connec_id = d.connec_id;


--2021/11/12
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (420, 'Check nodarcs','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3106, 'gw_fct_pg2epa_check_nodarc', 'ws', 'function', 'json', 
'json', 'Function to check nodarcs inconsistency.
This function must be used when go2epa crashes creating nodarcs. It works with the selected expl/sector choosed by user', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3106,'Check nodarc inconsistency', '{"featureType":[]}', NULL, NULL, TRUE) 
ON CONFLICT (id) DO NOTHING;

UPDATE sys_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols::json, 'spinboxDecimals'::text, 0::integer) WHERE id = 'inp_options_maxcheck';
UPDATE sys_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols::json, 'maximumNumber'::text, 999::integer) WHERE id = 'inp_options_maxcheck';

UPDATE sys_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols::json, 'spinboxDecimals'::text, 0::integer) WHERE id = 'inp_options_trials';
UPDATE sys_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols::json, 'maximumNumber'::text, 999::integer) WHERE id = 'inp_options_trials';

UPDATE sys_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols::json, 'spinboxDecimals'::text, 0::integer) WHERE id = 'inp_options_unbalanced_n';
UPDATE sys_param_user SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols::json, 'maximumNumber'::text, 999::integer) WHERE id = 'inp_options_unbalanced_n';

--2021/11/18
update config_param_system set layoutname = null, layoutorder=null, isenabled=false where layoutname in ('lyt_system', 'lyt_topology', 'lyt_builder', 'lyt_review');
update sys_param_user set layoutname = null, layoutorder=null, isenabled=false where id='qgis_form_log_hidden';

-- lyt_system
update config_param_system set layoutname='lyt_system', layoutorder=2, isenabled=true, widgettype='text' where "parameter"='admin_crm_periodseconds_vdefault';
update config_param_system set layoutname='lyt_system', layoutorder=3, isenabled=true where "parameter"='admin_currency';
update config_param_system set layoutname='lyt_system', layoutorder=4, isenabled=true, label='Custom form tab labels:', descript='Used to manage labels on diferent tabs in custom form Data tab' where "parameter"='admin_customform_param';
update config_param_system set layoutname='lyt_system', layoutorder=5, isenabled=true, label='Form header filed to use:', datatype='json', widgettype='text' where "parameter"='admin_formheader_field';
update config_param_system set layoutname='lyt_system', layoutorder=6, isenabled=true, widgettype='text', descript='Manage updates of i18n labels and tooltips. (0: update always owerwriting current values, 1: update only when value is null, 2:never update}' where "parameter"='admin_i18n_update_mode';
update config_param_system set layoutname='lyt_system', layoutorder=7, isenabled=true, widgettype='text', label='Manage cat_feature:' where "parameter"='admin_manage_cat_feature';
update config_param_system set layoutname='lyt_system', layoutorder=8, isenabled=false, widgettype='text', label='Folder path for python:' where "parameter"='admin_python_folderpath';
update config_param_system set layoutname='lyt_system', layoutorder=9, isenabled=true, widgettype='check' where "parameter"='admin_config_control_trigger';
update config_param_system set layoutname='lyt_system', layoutorder=11, isenabled=true, widgettype='check', label='CRM schema:' where "parameter"='admin_crm_schema';
update config_param_system set layoutname='lyt_system', layoutorder=12, isenabled=true, label='Raster DEM:' where "parameter"='admin_raster_dem';
update config_param_system set layoutname='lyt_system', layoutorder=13, isenabled=true where "parameter"='admin_exploitation_x_user';


-- lyt_topology
update config_param_system set layoutname='lyt_topology', layoutorder=1, isenabled=true, label='Arc searchnodes:' where "parameter"='edit_arc_searchnodes';
update config_param_system set layoutname='lyt_topology', layoutorder=2, isenabled=true where "parameter"='edit_node_proximity';
update config_param_system set layoutname='lyt_topology', layoutorder=3, isenabled=true where "parameter"='edit_connec_proximity';
update config_param_system set layoutname='lyt_topology', layoutorder=4, isenabled=true where "parameter"='edit_arc_divide';
update config_param_system set layoutname='lyt_topology', layoutorder=5, isenabled=true where "parameter"='edit_element_doublegeom';
update config_param_system set layoutname='lyt_topology', layoutorder=6, isenabled=true, label='Buffer to set mapzone on insert:', descript='Buffer to set mapzone on insert when feautre has no other feature connected and user has no default value' where "parameter"='edit_feature_buffer_on_mapzone';
update config_param_system set layoutname='lyt_topology', layoutorder=7, isenabled=true, descript='Enable/disable automatic delete of orphan nodes when arc is removed and some node have been disconnected' where "parameter"='edit_arc_orphannode_delete';
update config_param_system set layoutname='lyt_topology', layoutorder=8, isenabled=true where "parameter"='edit_arc_samenode_control';
update config_param_system set layoutname='lyt_topology', layoutorder=9, isenabled=true, label='Topocontrol disable error:' where "parameter"='edit_topocontrol_disable_error';
update config_param_system set layoutname='lyt_topology', layoutorder=10, isenabled=false where "parameter"='edit_state_topocontrol';
update config_param_system set layoutname='lyt_topology', layoutorder=11, isenabled=true, label='Enable update of node1 & node2 values:', descript='If true, user can manually update node_1 and node_2 value (using SQL consle or attribute table). Used in migrations with trustly data for not execute arc_searchnodes trigger' where "parameter"='edit_arc_enable nodes_update';

-- lyt_admin_om
delete from config_param_system where "parameter"='om_visit_duration_vdefault';
update config_param_system set layoutname='lyt_admin_om', layoutorder=1, isenabled=true, label='Mincut version:' where "parameter"='om_mincut_version';
update config_param_system set layoutname='lyt_admin_om', layoutorder=2, isenabled=true, widgettype='check', label='Mincut debug:' where "parameter"='om_mincut_debug';
update config_param_system set layoutname='lyt_admin_om', layoutorder=3, isenabled=true, widgettype='check', label='Mincut disable check temporary overlap:' where "parameter"='om_mincut_disable_check_temporary_overlap';
update config_param_system set layoutname='lyt_admin_om', layoutorder=4, isenabled=false where "parameter"='om_mincut_valvestatus_unaccess';
update config_param_system set layoutname='lyt_admin_om', layoutorder=5, isenabled=true, widgettype='check', label='Mincut valve2tank traceability:' where "parameter"='om_mincut_valve2tank_traceability';
update config_param_system set layoutname='lyt_admin_om', layoutorder=6, isenabled=true, "datatype"='boolean', widgettype='check', label='Mapzones automatic config:' where "parameter"='utils_grafanalytics_automatic_config';
update config_param_system set layoutname='lyt_admin_om', layoutorder=9, isenabled=true, "datatype"='json', widgettype='text', label='Automatic grafanalytics trigger:' where "parameter"='utils_grafanalytics_automatic_trigger';
update config_param_system set layoutname='lyt_admin_om', layoutorder=8, isenabled=true, "datatype"='json', widgettype='text', label='Mapzones dynamic symbology:' where "parameter"='utils_grafanalytics_dynamic_symbology';
update config_param_system set layoutname='lyt_admin_om', layoutorder=7, isenabled=true, "datatype"='json', widgettype='text', label='Dynamic mapzones:' where "parameter"='utils_grafanalytics_status';
update config_param_system set layoutname='lyt_admin_om', layoutorder=10, isenabled=true, "datatype"='text', widgettype='text', label='Add mapzone:' where "parameter"='admin_addmapzone';
update config_param_system set layoutname='lyt_admin_om', layoutorder=11, isenabled=true, label='Review node tolerance:', descript='Tolerance of difference allowed for node values in case of revision' where "parameter"='edit_review_node_tolerance';
update config_param_system set layoutname='lyt_admin_om', layoutorder=12, isenabled=true, "datatype"='json', widgettype='text' where "parameter"='om_visit_parameters';
update config_param_system set layoutname='lyt_admin_om', layoutorder=13, isenabled=false, widgettype='text' where "parameter"='om_mincut_enable_alerts';

-- lyt_admin_other
update config_param_system set layoutname='lyt_admin_other', layoutorder=1, isenabled=true where "parameter"='edit_link_update_connecrotation';
update config_param_system set layoutname='lyt_admin_other', layoutorder=2, isenabled=true, "datatype"='text', widgettype='text', label='Element form hide widgets:', descript='Variable to customize widgets from element form. Available widggets and format example:
["element_id", "code", "element_type", "elementcat_id", "num_elements", "state", "state_type", "expl_id", "ownercat_id", "location_type", "buildercat_id", "builtdate", "workcat_id", "workcat_id_end", "comment", "observ", "link", "verified", "rotation", "undelete", "btn_add_geom"]' where "parameter"='qgis_form_element_hidewidgets';
update config_param_system set layoutname='lyt_admin_other', layoutorder=3, isenabled=true, "datatype"='json', widgettype='text', label='EPA auto update inp tables:' where "parameter"='epa_automatic_man2inp_values';
update config_param_system set layoutname='lyt_admin_other', layoutorder=4, isenabled=true, "datatype"='json', widgettype='text', label='EPA outlayer values:' where "parameter"='epa_outlayer_values';
update config_param_system set layoutname='lyt_admin_other', layoutorder=5, isenabled=true, "datatype"='json', widgettype='text', label='EPA patterns:' where "parameter"='epa_patterns';
update config_param_system set layoutname='lyt_admin_other', layoutorder=6, isenabled=true, "datatype"='text', widgettype='text', label='EPA shutoff valve:' where "parameter"='epa_shutoffvalve';
update config_param_system set layoutname='lyt_admin_other', layoutorder=7, isenabled=true, widgettype='text', label='EPA units factor:' where "parameter"='epa_units_factor';
update config_param_system set layoutname='lyt_admin_other', layoutorder=8, isenabled=true, widgettype='text', label='Psector execute actions:' where "parameter"='plan_psector_execute_action';
update config_param_system set layoutname='lyt_admin_other', layoutorder=9, isenabled=true, widgettype='text' where "parameter"='plan_psector_statetype';
update config_param_system set layoutname='lyt_admin_other', layoutorder=10, isenabled=false, widgettype='text' where "parameter"='plan_statetype_ficticius';
update config_param_system set layoutname='lyt_admin_other', layoutorder=11, isenabled=false, widgettype='text', label='Plan statetype planned:' where "parameter"='plan_statetype_planned';
update config_param_system set layoutname='lyt_admin_other', layoutorder=12, isenabled=false, widgettype='text', label='Plan statetype reconstruct:' where "parameter"='plan_statetype_reconstruct';



