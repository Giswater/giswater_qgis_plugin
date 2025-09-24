/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_table SET alias = 'Inp Raingage' WHERE id = 've_raingage';

-- 15/09/2025
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='ve_inp_dscenario_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_arc' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:'
	WHERE formname='cat_node' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_connec' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='inp_dscenario_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Internal diameter:',tooltip='Internal diameter'
	WHERE formname='cat_link' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_none';

DELETE FROM sys_param_user WHERE id='edit_connec_linkcat_vdefault';

-- Dma type
UPDATE config_form_fields
	SET "label"='Dma type:'
	WHERE formname='ve_dma' AND formtype='form_feature' AND columnname='dma_type' AND tabname='tab_none';

-- plan_netscenario
UPDATE config_form_fields
	SET "label"='Netscenario id:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='netscenario_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Netscenario name:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='netscenario_name' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Dma id:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Pattern id:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Expl id2:'
	WHERE formname='ve_plan_netscenario_dma' AND formtype='form_feature' AND columnname='expl_id2' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Netscenario id:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='netscenario_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Dma id:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='dma_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Pattern id:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_none';
UPDATE config_form_fields
	SET "label"='Lastupdate user:'
	WHERE formname='plan_netscenario_dma' AND formtype='form_feature' AND columnname='lastupdate_user' AND tabname='tab_none';

-- 16/09/2025
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_adaptation' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_air_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_bypass_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_check_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_clorinathor' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_control_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_curve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_endline' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_expantank' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_filter' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_fl_contr_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_flexunion' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_flowmeter' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_gen_purp_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_green_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_hydrant' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_junction' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_netsamplepoint' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_outfall_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pr_break_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pr_reduc_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pr_susta_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pressure_meter' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pump' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_reduction' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_shutoff_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_source' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_t' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_tank' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_throttle_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_valve_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_waterwell' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_wtp' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_x' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_fountain' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_greentap' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_tap' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_vconnec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_wjoin' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_water_connection' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype,
"label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id,
dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden,web_layoutorder)
VALUES('inp_dscenario_frvalve', 'form_feature', 'tab_none', 'status', 'lyt_main_1', 9, 'string', 'combo', 'Status:', 'Status', NULL,
false, NULL, true, NULL, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_value_status_valve''',
NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;

-- 24/09/2025
UPDATE config_toolbox SET inputparams='[
{"label": "Create mapzones for netscenario:", "value": null, "tooltip": "Create mapzone for a selected netscenario", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "netscenario", "widgettype": "combo", "dvQueryText": "select netscenario_id as id, name as idval from plan_netscenario  order by name", "isNullValue": "true", "layoutorder": 1}, 
{"label": "Exploitation:", "value": null, "tooltip": "Choose exploitation to work with", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "exploitation", "widgettype": "combo", "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "layoutorder": 2}, 
{"label": "Force open nodes: (*)", "value": null, "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "forceOpen", "widgettype": "linetext", "isMandatory": false, "layoutorder": 3, "placeholder": "1015,2231,3123"}, 
{"label": "Force closed nodes: (*)", "value": null, "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there", "datatype": "text", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "forceClosed", "widgettype": "text", "isMandatory": false, "layoutorder": 4, "placeholder": "1015,2231,3123"}, 
{"label": "Use selected psectors:", "value": null, "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network", "datatype": "boolean", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "usePlanPsector", "widgettype": "check", "layoutorder": 5}, 
{"label": "Mapzone constructor method:", "value": null, "comboIds": [0, 1, 2, 3, 4], "datatype": "integer", "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "updateMapZone", "widgettype": "combo", "layoutorder": 6}, 
{"label": "Pipe buffer", "value": null, "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "datatype": "float", "layoutname": "grl_option_parameters", "selectedId": null, "widgetname": "geomParamUpdate", "widgettype": "text", "isMandatory": false, "layoutorder": 7, "placeholder": "5-30"}]'::json WHERE id=3256;

ALTER TABLE plan_netscenario_dma RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE plan_netscenario_dma ALTER COLUMN updated_at TYPE timestamptz USING updated_at::timestamptz;
ALTER TABLE plan_netscenario_dma RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE plan_netscenario_presszone RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE plan_netscenario_presszone ALTER COLUMN updated_at TYPE timestamptz USING updated_at::timestamptz;
ALTER TABLE plan_netscenario_presszone RENAME COLUMN lastupdate_user TO updated_by;

