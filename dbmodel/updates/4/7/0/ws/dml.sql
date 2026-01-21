/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 05/01/2026
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3528, 'gw_fct_get_epa_result_families', 'ws', 'function', 'text, integer', 'json', 'Function to get json with EPA result families.', NULL, NULL, 'core', NULL);

-- 08/01/2026
UPDATE config_form_fields
	SET dv_isnullvalue=true
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';

-- 09/01/2026
UPDATE sys_feature_class SET epa_default = 'JUNCTION' WHERE type IN ('CONNEC');

-- 16/01/2026
INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable,"source")
VALUES ('inp_options_demand_weight_factor','epaoptions','Use demand in DMA weight factor format','role_epa','Demand weight factor format:',true,(SELECT MAX(layoutorder) + 1 FROM sys_param_user WHERE formname='epaoptions' AND layoutname='lyt_general_2'),'ws',false,false,'boolean','check',true,'FALSE','lyt_general_2',true,'core');

INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('inp_options_demand_weight_factor', 'FALSE', 'postgres') ON CONFLICT DO NOTHING;

-- 21/01/2026
UPDATE config_csv SET descript = 'The csv file must contain the following fields: dscenario_name, feature_id, feature_type, value, pattern_id, demand_type, source.' WHERE fid = 501;

UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Scenario name:",
    "value": "",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "name",
    "widgettype": "text",
    "layoutorder": 1
  },
  {
    "label": "Scenario descript:",
    "value": "",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "descript",
    "widgettype": "text",
    "layoutorder": 2
  },
  {
    "label": "Exploitation:",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": "0",
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id as id, name as idval FROM exploitation where expl_id>0 UNION select 99999 as id, ''ALL'' as idval order by id desc",
    "layoutorder": 4
  },
  {
    "label": "Choose time method:",
    "comboIds": [
      1,
      2
    ],
    "datatype": "text",
    "comboNames": [
      "PERIOD ID",
      "DATE INTERVAL"
    ],
    "layoutname": "grl_option_parameters",
    "widgetname": "patternOrDate",
    "widgettype": "combo",
    "isMandatory": true,
    "layoutorder": 5
  },
  {
    "label": "if PERIOD_ID - Period:",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": "1",
    "widgetname": "period",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, code as idval FROM ext_cat_period",
    "layoutorder": 6
  },
  {
    "label": "[if DATE INTERVAL] Source CRM init date:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "initDate",
    "widgettype": "datetime",
    "layoutorder": 7
  },
  {
    "label": "[if DATE INTERVAL] Source CRM end date:",
    "value": "2015-07-30 00:00:00",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "endDate",
    "widgettype": "datetime",
    "layoutorder": 8
  },
  {
    "label": "Only hydrometers with waterbal true:",
    "value": null,
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "widgetname": "onlyIsWaterBal",
    "widgettype": "check",
    "layoutorder": 9
  },
  {
    "label": "Feature pattern:",
    "tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.",
    "comboIds": [
      1,
      2,
      3,
      4,
      5,
      6,
      7
    ],
    "datatype": "text",
    "comboNames": [
      "NONE",
      "SECTOR-DEFAULT",
      "DMA-DEFAULT",
      "DMA-PERIOD",
      "HYDROMETER-PERIOD",
      "HYDROMETER-CATEGORY",
      "FEATURE-PATTERN"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": "",
    "widgetname": "pattern",
    "widgettype": "combo",
    "layoutorder": 10
  },
  {
    "label": "Demand units:",
    "tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.",
    "comboIds": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "datatype": "text",
    "comboNames": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": "",
    "widgetname": "demandUnits",
    "widgettype": "combo",
    "layoutorder": 11
  },
  {
    "label": "Demand as DMA weight factor:",
    "tooltip": "",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "widgetname": "export_weight",
    "widgettype": "check",
    "layoutorder": 12
  }
]'::json
	WHERE id=3110;
