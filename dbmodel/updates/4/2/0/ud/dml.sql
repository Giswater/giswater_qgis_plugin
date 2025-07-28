/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--26/06/2025

UPDATE sys_function SET function_alias = 'CREATE EMPTY HYDROLOGY SCENARIO' WHERE function_name = 'gw_fct_create_hydrology_scenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4020, 'Infiltration: %v_infiltration%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4022, 'Text: %v_text%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4024, 'The hydrology scenario ( %v_scenarioid% ) already exists with proposed name %v_name%. Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4026, 'This new hydrology scenario is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'CREATE EMPTY DSCENARIO' WHERE function_name = 'gw_fct_create_dwf_scenario_empty';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3880, 'ERROR: The dwf scenario already exists with proposed name (%v_idval%). Please try another one.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3882, 'Id_val: %v_idval%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3884, 'Descript: %v_startdate%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3886, 'Parent: %v_enddate%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3888, 'Type: %v_observ%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3890, 'active: %v_active%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3892, 'Expl_id: %v_expl_id%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3894, 'The new dscenario (%v_scenarioid%) have been created sucessfully', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3896, 'The new dscenario is now your current DWF scenario', null, 0, true, 'utils', 'core', 'AUDIT');

--26/06/2025
UPDATE sys_function SET function_alias = 'DUPLICATE DWF SCENARIO' WHERE function_name = 'gw_fct_duplicate_dwf_scenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3898, 'Dwf scenario named "%v_idval%" created with values from Dwf scenario ( %v_copyfrom% ).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (3900, 'Copied values from Dwf scenario ( %v_copyfrom% ) to new Dwf scenario ( %v_scenarioid% ).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4302, 'This DWF scenario is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

--27/06/2025

UPDATE sys_function SET function_alias = 'MANAGE DWF VALUES' WHERE function_name = 'gw_fct_manage_dwf_values';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4028, 'Sector: %v_sector_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4030, '%v_count% row(s) have been keep from inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4032, 'No rows have been inserted on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4034, '%v_count2% row(s) have been inserted on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4036, '%v_count% row(s) have been removed from inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4038, '%v_count% row(s) have been inserted into inp_dwf table from v_edit_inp_junction table.', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'MANAGE HYDROLOGY VALUES' WHERE function_name = 'gw_fct_manage_hydrology_values';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4040, 'Infiltration method for (%v_source_name%) and (%v_target_name%) are not the same.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4042, '%v_count% row(s) have been removed from inp_subcathment table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4044, '%v_count% row(s) have been removed from inp_loadings table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4046, '%v_count% row(s) have been removed from inp_groundwater table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4048, '%v_count% row(s) have been removed from inp_coverage table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4050, 'Target and source have same infiltration method.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4052, 'No rows have been inserted for sector %v_sector% on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4054, '%v_count2% row(s) have been inserted for sector %v_sector% on inp_%object_rec% table.', null, 0, true, 'utils', 'core', 'AUDIT');

--27/06/2025
UPDATE sys_function SET function_alias = 'SET JUNCTIONS OUTLET' WHERE function_name = 'gw_fct_epa_setjunctionsoutlet';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4306, 'Minimun distance used: %v_mindistance%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4308, 'Initial junctions: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4310, 'Total junctions after process: %v_count%', null, 0, true, 'utils', 'core', 'AUDIT');

--27/06/2025
UPDATE sys_function SET function_alias = 'DUPLICATE HYDROLOGY SCENARIO' WHERE function_name = 'gw_fct_duplicate_hydrology_scenario';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4312, 'Source scenario: %v_sourcename%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4314, 'New scenario: %v_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4316, 'Hydrology scenario named (%v_name%) have been created with values from hydrology scenario (%v_sourcename%).', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4318, 'The new hydrology scenario (%v_name%) is now your current scenario.', null, 0, true, 'utils', 'core', 'AUDIT');

--30/06/2025

UPDATE sys_function SET function_alias = 'SET OPTIMUM OUTLET' WHERE function_name = 'gw_fct_epa_setoptimumoutlet';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4202, 'SECTOR ID: %v_sector%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4204, 'HYDROLOGY SCENARIO: %v_name%', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4206, '%v_count2-v_count1% subcatchments have been updated with outlet values', null, 0, true, 'utils', 'core', 'AUDIT');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4208, '0 subcatchments have been updated with outlet values', null, 0, true, 'utils', 'core', 'AUDIT');

UPDATE sys_function SET function_alias = 'FLUID TYPE CALCULATION' WHERE function_name = 'gw_fct_graphanalytics_fluid_type';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4210, 'Fluid type calculation done succesfully', null, 0, true, 'utils', 'core', 'UI');


-- 03/07/2025
UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "DWFZONE",
      "SECTOR"
    ],
    "comboNames": [
      "Drainage area (DRAINZONE + DWFZONE)",
      "SECTOR"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "forceOpen",
    "label": "Force open nodes: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "value": null
  },
  {
    "widgetname": "forceClosed",
    "label": "Force closed nodes: (*)",
    "widgettype": "text",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": null
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use selected psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      6
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "EPA SUBCATCH"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  },
  {
    "widgetname": "fromZero",
    "label": "Mapzones from zero:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, mapzones are calculated automatically from zero",
    "layoutname": "grl_option_parameters",
    "layoutorder": 12,
    "value": null
  }
]'::json WHERE id=2768;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3482, 'Macromapzones analysis', '{"featureType":[]}'::json, '[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "MACROSECTOR",
      "MACROOMZONE"
    ],
    "comboNames": [
      "MACROSECTOR",
      "MACROOMZONE"
    ],
    "selectedId": null
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": null
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": null
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      3,
      4
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "PLOT & PIPE BUFFER",
      "LINK & PIPE BUFFER"
    ],
    "selectedId": null
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": null
  }
]'::json, NULL, true, '{4}');
-- 30/06/2025
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_inlet_type', 'GULLY', 'GULLY', NULL, NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('_inp_typevalue_inlet_type', 'CULVERT', 'CULVERT', NULL, NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) VALUES('inp_typevalue_dscenario', 'INLET', 'INLET', NULL, NULL);
INSERT INTO sys_feature_epa_type (id,feature_type,epa_table,active)	VALUES ('INLET','NODE','inp_inlet',true);

INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('ve_epa_inlet', 'tab_epa', 'EPA', NULL, 'role_basic', NULL, '[{"actionName": "actionEdit","actionTooltip": "Edit","disabled": false},{"actionName": "actionZoom","actionTooltip": "Zoom In","disabled": false},{"actionName": "actionCentered","actionTooltip": "Center","disabled": false},{"actionName": "actionZoomOut","actionTooltip": "Zoom Out","disabled": false},{"actionName": "actionCatalog","actionTooltip": "Change Catalog","disabled": false},{"actionName": "actionWorkcat","actionTooltip": "Add Workcat","disabled": false},{"actionName": "actionCopyPaste","actionTooltip": "Copy Paste","disabled": false},{"actionName": "actionLink","actionTooltip": "Open Link","disabled": false},{"actionName": "actionHelp","actionTooltip": "Help","disabled": false},{"actionName": "actionInterpolate","actionTooltip": "Interpolate","disabled": false},{"actionName": "actionGetArcId","actionTooltip": "Set arc_id","disabled": false},{"actionName": "actionOrifice","actionTooltip": "Orifice","disabled": false},{"actionName": "actionOutlet","actionTooltip": "Outlet","disabled": false},{"actionName": "actionPump","actionTooltip": "Pump","disabled": false},{"actionName": "actionWeir","actionTooltip": "Weir","disabled": false},{"actionName": "actionDemand","actionTooltip": "DWF","disabled": false}]'::json, 1, '{4}');

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'y0', 'lyt_epa_data_1', 1, 'numeric', 'text', 'y0:', 'y0', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'ysur', 'lyt_epa_data_1', 2, 'numeric', 'text', 'ysur:', 'ysur', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'apond', 'lyt_epa_data_1', 3, 'numeric', 'text', 'apond:', 'apond', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'inlet_type', 'lyt_epa_data_1', 4, 'string', 'combo', 'inlet_type:', 'inlet_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_inlet_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'outlet_type', 'lyt_epa_data_1', 5, 'string', 'combo', 'outlet_type:', 'outlet_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_gully_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'gully_method', 'lyt_epa_data_1', 6, 'string', 'combo', 'gully_method:', 'gully_method', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_gully_method''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'custom_top_elev', 'lyt_epa_data_1', 7, 'double', 'text', 'custom_top_elev:', 'custom_top_elev', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'custom_depth', 'lyt_epa_data_1', 8, 'double', 'text', 'custom_depth:', 'custom_depth', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'inlet_length', 'lyt_epa_data_1', 9, 'double', 'text', 'inlet_length:', 'inlet_length', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'inlet_width', 'lyt_epa_data_1', 10, 'double', 'text', 'inlet_width:', 'inlet_width', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'cd1', 'lyt_epa_data_1', 11, 'double', 'text', 'cd1:', 'cd1', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'cd2', 'lyt_epa_data_1', 12, 'double', 'text', 'cd2:', 'cd2', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'efficiency', 'lyt_epa_data_1', 13, 'double', 'text', 'efficiency:', 'efficiency', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'depth_average', 'lyt_epa_data_2', 1, 'string', 'text', 'Average depth:', 'Average depth', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'depth_max', 'lyt_epa_data_2', 2, 'string', 'text', 'Max depth:', 'Max depth', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'depth_max_day', 'lyt_epa_data_2', 3, 'string', 'text', 'Max depth/day:', 'Max depth per day', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'depth_max_hour', 'lyt_epa_data_2', 4, 'string', 'text', 'Max depth/hour:', 'Max depth per hour', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'flood_hour', 'lyt_epa_data_2', 7, 'string', 'text', 'Flood hour:', 'Flood hour', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'flood_max_ponded', 'lyt_epa_data_2', 12, 'string', 'text', 'Max ponded flood :', 'Max ponded flood', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'flood_max_rate', 'lyt_epa_data_2', 8, 'string', 'text', 'Maximum food rate:', 'Maximum food rate', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'flood_total', 'lyt_epa_data_2', 11, 'string', 'text', 'Total flood:', 'Total flood', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'surcharge_hour', 'lyt_epa_data_2', 5, 'string', 'text', 'Surcharge/hour:', 'Surcharge per hour', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'surgarge_max_height', 'lyt_epa_data_2', 6, 'string', 'text', 'max height of surgarge:', 'Max height of surgarge', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'time_day', 'lyt_epa_data_2', 9, 'string', 'text', 'Day:', 'Day', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'time_hour', 'lyt_epa_data_2', 10, 'string', 'text', 'Hour:', 'Hour', NULL, false, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_none', 'dscenario_id', 'lyt_epa_data_1', 1, 'integer', 'combo', 'Dscenario ID', 'Dscenario ID', NULL, true, false, true, false, false, 'SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE dscenario_id IS NOT NULL', true, false, NULL, NULL, NULL, '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'y0', 'lyt_epa_data_1', 3, 'numeric', 'text', 'y0:', 'y0', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'ysur', 'lyt_epa_data_1', 4, 'numeric', 'text', 'ysur:', 'ysur', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'apond', 'lyt_epa_data_1', 5, 'numeric', 'text', 'apond:', 'apond', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'inlet_type', 'lyt_epa_data_1', 6, 'string', 'combo', 'inlet_type:', 'inlet_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_inlet_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'outlet_type', 'lyt_epa_data_1', 7, 'string', 'combo', 'outlet_type:', 'outlet_type', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_gully_type''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'gully_method', 'lyt_epa_data_1', 8, 'string', 'combo', 'gully_method:', 'gully_method', NULL, false, false, true, false, false, 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_gully_method''', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'custom_top_elev', 'lyt_epa_data_1', 9, 'double', 'text', 'custom_top_elev:', 'custom_top_elev', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'custom_depth', 'lyt_epa_data_1', 10, 'double', 'text', 'custom_depth:', 'custom_depth', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'inlet_length', 'lyt_epa_data_1', 11, 'double', 'text', 'inlet_length:', 'inlet_length', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'inlet_width', 'lyt_epa_data_1', 12, 'double', 'text', 'inlet_width:', 'inlet_width', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'cd1', 'lyt_epa_data_1', 13, 'double', 'text', 'cd1:', 'cd1', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'cd2', 'lyt_epa_data_1', 14, 'double', 'text', 'cd2:', 'cd2', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_epa', 'efficiency', 'lyt_epa_data_1', 15, 'double', 'text', 'efficiency:', 'efficiency', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('inp_dscenario_inlet', 'form_feature', 'tab_none', 'node_id', NULL, 2, 'string', 'text', 'Node id:', 'Node id:', NULL, true, false, false, false, false, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);

-- 07/07/2025
UPDATE config_form_fields SET iseditable=false WHERE formname='v_edit_drainzone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';
UPDATE config_form_fields SET iseditable=false WHERE formname='v_ui_drainzone' AND formtype='form_feature' AND columnname='graphconfig' AND tabname='tab_none';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,widgetcontrols,hidden)
	VALUES ('v_ui_dwfzone','form_feature','tab_none','drainzone_id','lyt_data_1',11,'text','combo','drainzone_id','drainzone_id',false,false,true,false,false,'SELECT drainzone_id id, name idval FROM v_edit_drainzone','{"setMultiline":false}'::json,false);

-- 10/07/2025
-- UPDATE config_form_fields SET layoutname = 'lyt_bot_1' WHERE formtype='form_feature' AND tab_name='tab_data' AND columnname in ('sector_id', 'omzone_id', 'state_type', 'state');
-- formname = 've_node_highpoint' and (columnname ilike 'omzone%' or columnname ilike 'sector_id%' or columnname ilike 'state%')

-- UPDATE config_form_fields SET layoutorder = 44, widgetcontrols = '{"setMultiline":false}'::json WHERE formname = 've_node_highpoint' AND columnname = 'verified' AND tab_name = 'tab_data' AND formtype = 'form_feature';

-- 14/07/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES
    (3410, 'gw_trg_array_fk_array_table', 'utils', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL),
    (3412, 'gw_trg_array_fk_id_table', 'utils', 'function', NULL, NULL, NULL, NULL, NULL, 'core', NULL)
ON CONFLICT (id) DO UPDATE SET project_type = 'utils';

INSERT INTO dma (dma_id, name) VALUES (0, 'UNDEFINED');

-- 14/07/2025
UPDATE sys_foreignkey SET target_field='gully_method'
WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_gully_method' AND target_table='inp_gully' AND target_field='method';
UPDATE sys_foreignkey SET target_field='gully_method'
WHERE typevalue_table='inp_typevalue' AND typevalue_name='inp_typevalue_gully_method' AND target_table='inp_netgully' AND target_field='method';

UPDATE sys_param_user SET layoutorder = 25 WHERE id = 'utils_psector_strategy';

UPDATE config_form_fields SET formname='v_edit_inp_gully', formtype='form_feature', columnname='gully_method', tabname='tab_data' WHERE formname='v_edit_inp_gully' AND formtype='form_feature' AND columnname='gully_method' AND tabname='tab_data';
UPDATE config_form_fields SET formname='v_edit_inp_netgully', formtype='form_feature', columnname='gully_method', tabname='tab_data' WHERE formname='v_edit_inp_netgully' AND formtype='form_feature' AND columnname='gully_method' AND tabname='tab_data';
UPDATE config_form_fields SET formname='ve_epa_gully', formtype='form_feature', columnname='gully_method', tabname='tab_epa' WHERE formname='ve_epa_gully' AND formtype='form_feature' AND columnname='gully_method' AND tabname='tab_epa';
UPDATE config_form_fields SET formname='ve_epa_netgully', formtype='form_feature', columnname='gully_method', tabname='tab_epa' WHERE formname='ve_epa_netgully' AND formtype='form_feature' AND columnname='gully_method' AND tabname='tab_epa';

UPDATE sys_message SET error_message = 'The table chosen does not fit with any epa dscenario. Please try another one.' WHERE id = 3698;

UPDATE inp_typevalue SET typevalue='_inp_typevalue_gully_method' WHERE typevalue='inp_typevalue_gully_method' AND id='UPC';
UPDATE inp_typevalue SET typevalue='_inp_typevalue_gully_type' WHERE typevalue='inp_typevalue_gully_type' AND id='Sink';

UPDATE config_param_system SET value='{"sys_display_name":"concat(gully_id, '' : '', gullycat_id)","sys_tablename":"v_edit_gully","sys_pk":"gully_id","sys_fct":"gw_fct_getinfofromid","sys_filter":"","sys_geom":"the_geom"}' WHERE "parameter"='basic_search_v2_tab_network_gully';
UPDATE config_param_system SET value='{"sys_display_name":"concat(connec_id, '' : '', conneccat_id)","sys_tablename":"v_edit_connec","sys_pk":"connec_id","sys_fct":"gw_fct_getinfofromid","sys_filter":"","sys_geom":"the_geom"}' WHERE "parameter"='basic_search_v2_tab_network_connec';

-- 24/07/2025
INSERT INTO config_form_tabs (formname, tabname, "label", tooltip, sys_role, tabfunction, tabactions, orderby, device) VALUES('v_edit_raingage', 'tab_data', 'Data', 'Data', 'role_edit', NULL, '[
  {
    "actionName": "actionEdit",
    "disabled": false
  },
  {
    "actionName": "actionZoom",
    "disabled": false
  },
  {
    "actionName": "actionCentered",
    "disabled": false
  },
  {
    "actionName": "actionZoomOut",
    "disabled": false
  },
  {
    "actionName": "actionHelp",
    "disabled": false
  }
]'::json, 0, '{4,5}');

UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='rg_id' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='form_type' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='intvl' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='scf' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='rgage_type' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='timser_id' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='fname' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='sta' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='units' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='muni_id' AND tabname='tab_none';
UPDATE config_form_fields SET tabname='tab_data' WHERE formname='v_edit_raingage' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_none';

UPDATE config_info_layer SET formtemplate='info_feature' WHERE layer_id='v_edit_raingage';

-- 25/07/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3490, 'gw_fct_graphanalytics_omunit', 'ud', 'function', 'json', 'json', 'Dynamic analisys to sectorize network using the flow traceability function and establish omunits.', 'role_plan', NULL, 'core', 'OMUNIT DYNAMIC SECTORITZATION');
INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3490, 'Omunit analysis', '{"featureType":[]}'::json, '[{"widgetname": "exploitation", "label": "Exploitation:", "widgettype": "combo", "datatype": "text", "tooltip": "Choose exploitation to work with", "layoutname": "grl_option_parameters", "layoutorder": 2, "dvQueryText": "SELECT id, idval FROM ( SELECT -901 AS id, ''User selected expl'' AS idval, ''a'' AS sort_order UNION SELECT -902 AS id, ''All exploitations'' AS idval, ''b'' AS sort_order UNION SELECT expl_id AS id, name AS idval, ''c'' AS sort_order FROM exploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC", "selectedId": ""}, {"widgetname": "usePlanPsector", "label": "Use masterplan psectors:", "widgettype": "check", "datatype": "boolean", "layoutname": "grl_option_parameters", "layoutorder": 6, "value": ""}, {"widgetname": "commitChanges", "label": "Commit changes:", "widgettype": "check", "datatype": "boolean", "layoutname": "grl_option_parameters", "layoutorder": 7, "value": ""}, {"widgetname": "updateMapZone", "label": "Update mapzone geometry method:", "widgettype": "combo", "datatype": "integer", "layoutname": "grl_option_parameters", "layoutorder": 8, "comboIds": [0, 1, 2, 3], "comboNames": ["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId": ""}, {"widgetname": "geomParamUpdate", "label": "Geometry parameter:", "widgettype": "text", "datatype": "float", "layoutname": "grl_option_parameters", "layoutorder": 10, "isMandatory": false, "placeholder": "5-30", "value": ""}]'::json, NULL, true, '{4}');

-- 28/07/2025
UPDATE sys_table SET id='ve_gully' WHERE id='v_edit_gully';
UPDATE sys_style SET layername = 've_gully' WHERE layername = 'v_edit_gully';
UPDATE cat_feature SET parent_layer = 've_gully' WHERE parent_layer = 'v_edit_gully';
