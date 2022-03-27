/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/03/09
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3136, 'gw_fct_import_inp_urn', 'utils', 'function', NULL, 'json', 'Function that replaces text ids with an integer urn', 'role_admin', NULL, 'core');

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type)
VALUES (439, 'Set integer id on import inp', 'utils', NULL, 'core', false, 'Function process');

update sys_fprocess set fprocess_type='Function process' where fid in (438, 432);

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3138, 'gw_trg_sysaddfields', 'utils', 'function trigger', NULL, NULL, 'Trigger that controls setting addfileds as unactive', 'role_admin', NULL, 'core');

--2022/03/15
update config_typevalue set id='{"level_1":"MASTERPLAN","level_2":"PRICES"}' where id='{"level_1":"PLAN","level_2":"PRICES"}';
update config_typevalue set id='{"level_1":"MASTERPLAN","level_2":"PSECTOR"}' where id='{"level_1":"PLAN","level_2":"PSECTOR"}';

update sys_table set context='{"level_1":"MASTERPLAN","level_2":"PSECTOR"}' where context='{"level_1":"PLAN","level_2":"PSECTOR"}';
update sys_table set context='{"level_1":"MASTERPLAN","level_2":"PRICES"}' where context='{"level_1":"PLAN","level_2":"PRICES"}';

--2022/03/21
UPDATE config_toolbox SET inputparams = '[{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["DELETE VALUES & COPY FROM", "KEEP VALUES & COPY FROM", "DELETE SCENARIO"], "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":""},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":""}
  ]' WHERE id = 3042;

UPDATE polygon SET state = 1;

INSERT INTO config_info_layer VALUES ('v_polygon', false, null, false, 'info_feature', null, 21)

INSERT INTO sys_table (id, descript, sys_role, source)
VALUES ('v_polygon', 'Table to enable the info for polygons. Table need to be load on qgis project', 'role_basic', 'giswater') 
ON CONFLICT (id) DO NOTHING;