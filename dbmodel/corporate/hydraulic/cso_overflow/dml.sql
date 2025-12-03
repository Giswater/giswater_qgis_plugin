/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public;


INSERT INTO config_param_system ("parameter", value, descript) VALUES('cso_daily_supply', '150', 'Daily supply of water (L x hab x day)') ON CONFLICT ("parameter") DO NOTHING;
INSERT INTO config_param_system ("parameter", value, descript) VALUES('cso_returncoeff', '0.8', 'Return coefficient (%)');


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(9997, 'gw_fct_cso_calculation', 'ud', 'function', 'json', 'json', 'CSO Algorithm', 'role_admin', NULL, 'core');

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active) 
VALUES(9997, 'CSO Algorithm', '{"featureType":[]}'::json, '[
  {
    "label": "Exploitation:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id AS id, concat(expl_id, ' - ', name) AS idval FROM exploitation e WHERE length(expl_id::text) <3 AND expl_id>0 ORDER BY 1",
    "layoutorder": 1
  },
  {
    "widgetname": "drainzoneId",
    "label": "Drainzone",
    "widgettype": "text",
    "datatype": "text",
    "tooltip": "1234, 529857, 478374",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2
  },
  {
    "label": "Mode:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "mode",
    "widgettype": "combo",
    "dvQueryText": "SELECT 'CALIBRATION' as id, 'CALIBRATION' as idval UNION SELECT 'EXECUTION' as id, 'EXECUTION' as idval",
    "layoutorder": 3
  },
  {
    "widgetname": "inflowsDscenarioName",
    "label": "Inflows dscenario name (OPTIONAL):",
    "widgettype": "text",
    "datatype": "text",
    "placeholder": "Leave null to not create an inflows dscenario",
    "layoutname": "grl_option_parameters",
    "layoutorder": 4
  }
]'::json, NULL, true;
