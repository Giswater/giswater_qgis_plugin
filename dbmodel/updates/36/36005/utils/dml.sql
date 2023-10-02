/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP RULE macroexploitation_undefined ON macroexploitation;
DROP RULE macroexploitation_del_undefined ON macroexploitation;

INSERT INTO macroexploitation VALUES (1, 'Default', 'Default macroexploitation', NULL) ON CONFLICT (macroexpl_id) DO NOTHING;


CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;
   
  CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;
   
 
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3280, 'gw_fct_setnoderotation', 'utils', 'function', 'json', 'json', 'Function to update massively the column rotation for nodes. Function works with the selection of user (exploitation and psectors)', 'role_edit', null, 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (516, 'Node rotation update', 'utils', null, 'core', true, 'Function process', null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_toolbox 
VALUES (3280, 'Massive node rotation update','{"featureType":[]}', '{}', null, true, '{4}') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user (id, formname, descript, sys_role, project_type, ismandatory, source) 
VALUES ('edit_disable_arctopocontrol', 'dynamic', 'If true, topocontrol is disabled', 'role_edit', 'utils', true, 'core');

INSERT INTO sys_param_user (id, formname, descript, sys_role, project_type, ismandatory, source) 
VALUES ('edit_disable_update_nodevalues', 'dynamic', 'If true, topocontrol is disabled', 'role_edit', 'utils', true, 'core');


