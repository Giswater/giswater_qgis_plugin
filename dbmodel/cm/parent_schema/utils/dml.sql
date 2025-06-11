/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = PARENT_SCHEMA, public, pg_catalog;

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES
('plugin_campaign', '{"campaignManage":"TRUE"}', 'External plugin to use functionality of planified campaign/lots review/visits', FALSE, 'utils', 'json') ON CONFLICT (parameter) DO NOTHING;

INSERT INTO SCHEMA_NAME.cat_pschema (name) VALUES ('PARENT_SCHEMA');

UPDATE PARENT_SCHEMA.config_param_system
   SET value = '{"schemaName":"SCHEMA_NAME"}'
 WHERE parameter = 'admin_schema_cm';

UPDATE SCHEMA_NAME.sys_version AS dst
   SET
     giswater  = src.giswater,
     "language" = src."language",
     epsg      = src.epsg
  FROM (
    SELECT giswater, "language", epsg
      FROM PARENT_SCHEMA.sys_version
     ORDER BY date DESC
     LIMIT 1
  ) AS src; 

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES (3426, 'gw_fct_cm_integrate_production', 'utils', 'function', NULL, 'json', 'Function to integrate an specific campaign from campaign manage into production schema', 'role_admin', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3426, 'Integrate campaign into production', '{"featureType":[]}'::json, 
'[{"widgetname": "campaignId", "label": "Campaign:", "widgettype": "combo", "datatype": "text", "tooltip": "Campaign to be inserted into production environment", "layoutname": "grl_option_parameters", "layoutorder": 1, "dvQueryText": "select campaign_id as id, name as idval from cm.om_campaign WHERE status = 8 order by name", "isNullValue": "true", "selectedId": ""}]', NULL, true, '{4}');