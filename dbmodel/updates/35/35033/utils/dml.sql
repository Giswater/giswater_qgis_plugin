/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_param_system(parameter, value, descript, 
label,  isenabled,  project_type, datatype, widgettype, ismandatory, iseditable)
VALUES ('edit_review_auto_field_checked', 'false', 'If true, at saving review data it would be automatically set as finished.',
'Review automatic field check:',
false, 'utils', 'boolean', 'check', false,true);

INSERT INTO sys_function(id, function_name, project_type, function_type, descript, sys_role,  source)
VALUES (3194, 'gw_fct_infofromid', 'utils', 'function', 'Function that works internally with gw_fct_getinfofromid', 'role_basic', 'core') ON CONFLICT (id) DO NOTHING;

ALTER TABLE arc ALTER COLUMN state_type SET NOT NULL;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3198, 'gw_fct_setclosestaddress', 'utils', 'function', NULL, NULL, 'Function to capture automatically closest address from every node/connec.
- Type: choose if you want to update all node/connec or just a specific type of them.
- Field to update: possible fields to update are postnumber(integer) and postcomplement(text). The most usual is postnumber, but if address number is not numeric, then you will need to update postcomplement.
- Search buffer: maximum distance to look for an address from the point.
- Elements to update: if you dont''t want to update all elements, choose to only update the ones where streetaxis_id, postnumber or postcomplement is null.', 'role_edit', NULL, 'core');

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam) 
VALUES(486, 'Get address values from closest street number', 'utils', NULL, 'core', false, 'Function process', NULL);