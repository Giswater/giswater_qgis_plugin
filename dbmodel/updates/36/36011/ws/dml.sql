/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source")
VALUES(3308, 'gw_fct_create_full_network_dscenario', 'ws', 'function', 'json', 'json', 'Function to create full network dscenario', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device)
VALUES(3308, 'Create full Network dscenario', '{"featureType":[]}'::json, '[
{"widgetname":"name", "label":"Name:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name of the new dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"descript", "label":"descript:","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"descript of new scenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"dwf scenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":3, "value":null}
]'::json, NULL, true, '{4}')
ON CONFLICT (id) DO  NOTHING;

INSERT INTO config_graph_checkvalve SELECT node_id, to_arc, true FROM inp_shortpipe WHERE _status_ = 'CV' 
ON CONFLICT (node_id) DO NOTHING;

UPDATE config_form_fields SET iseditable=false, widgettype='text', dv_querytext=null where columnname = 'status' and formname IN ('v_edit_inp_shortpipe','ve_epa_shortpipe');

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue in ('inp_value_status_shortpipe');
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
