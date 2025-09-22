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
