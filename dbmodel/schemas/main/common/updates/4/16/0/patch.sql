/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3560, 'gw_fct_scada_graph_build', 'utils', 'function', 'json', 'json', 'Creates a scada graph edge: insert, check/fix and export JSON.', 'role_om', NULL, 'core', NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES
('formtype_typevalue', 'profile_interpolation', 'profile_interpolation', 'profileInterpolation', NULL),
('formtype_typevalue', 'scada_graph', 'scada_graph', 'scadaGraph', NULL)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES
('layout_name_typevalue', 'lyt_profile_node_1', 'lyt_profile_node_1', 'lytProfileNode1', '{"lytOrientation": "horizontal"}'::json),
('layout_name_typevalue', 'lyt_profile_node_2', 'lyt_profile_node_2', 'lytProfileNode2', '{"lytOrientation": "horizontal"}'::json),
('layout_name_typevalue', 'lyt_profile_interp_1', 'lyt_profile_interp_1', 'lytProfileInterp1', '{"lytOrientation": "vertical"}'::json),
('layout_name_typevalue', 'lyt_scada_node_1', 'lyt_scada_node_1', 'lytScadaNode1', '{"lytOrientation": "horizontal"}'::json),
('layout_name_typevalue', 'lyt_scada_node_2', 'lyt_scada_node_2', 'lytScadaNode2', '{"lytOrientation": "horizontal"}'::json),
('layout_name_typevalue', 'lyt_buttons', 'lyt_buttons', 'lytButtons', '{"lytOrientation": "horizontal"}'::json)
ON CONFLICT (typevalue, id) DO NOTHING;
