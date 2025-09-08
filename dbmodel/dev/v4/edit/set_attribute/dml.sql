/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4350, '%v_count% rows updated.', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4352, 'Selected option disabled.', NULL, 0, true, 'utils', 'core', 'AUDIT') ON CONFLICT DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, active) 
VALUES(670, 'Set attribute', 'utils', NULL, 'core', true, 'Function process', true) ON CONFLICT DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) VALUES(3514, 'Set attribute', '{"featureType":["arc"]}'::json, '[
  {
    "widgetname": "expl_id",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "integer",
    "tooltip": "Choose a new exploitation",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "dvQueryText": "SELECT expl_id as id, name as idval FROM exploitation WHERE active",
    "selectedId": ""
  },
  {
    "widgetname": "arccat_id",
    "label": "Arc catalog:",
    "widgettype": "combo",
    "datatype": "text",
    "dvQueryText": "SELECT id, id as idval FROM cat_arc",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
    "value": ""
  },
  {
    "widgetname": "workcat_id",
    "label": "Workcat:",
    "widgettype": "combo",
    "datatype": "text",
    "dvQueryText": "SELECT id, id as idval FROM cat_work",
    "layoutname": "grl_option_parameters",
    "layoutorder": 3,
    "value": "",
    "isNullValue": true
  },
  {
    "widgetname": "datasource",
    "label": "Datasource:",
    "widgettype": "text",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "layoutorder": 4,
    "selectedId": ""
  },
  {
    "widgetname": "builtdate",
    "label": "Builtdate:",
    "widgettype": "datetime",
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "isMandatory": false,
    "value": ""
  }
]'::json, NULL, true, '{4}') ON CONFLICT DO NOTHING;