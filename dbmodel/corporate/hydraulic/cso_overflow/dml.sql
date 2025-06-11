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
    "widgetname": "macroexplId",
    "label": "Macroexploitation",
    "widgettype": "combo",
    "datatype": "integer",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 15,
    "isMandatory": false,
    "dvQueryText":"SELECT id, idval FROM ( SELECT -901 AS id, ''User selected macroexpl'' AS idval, ''a'' AS sort_order UNION SELECT macroexpl_id AS id, concat(macroexpl_id, '' - '', name) AS idval, ''c'' AS sort_order FROM macroexploitation WHERE active IS NOT FALSE ) a ORDER BY sort_order ASC, idval ASC",
    "selectedId": ""
  },
  {
    "widgetname": "drainzoneId",
    "label": "Drainzone id",
    "widgettype": "text",
    "datatype": "text",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 16,
    "isMandatory": false,
    "placeholder": "5,456,589",
    "value": ""
  }
]'::json, NULL, true);
