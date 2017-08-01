/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- Parametrize functions and function triggers
INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (10, 'gw_fct_anl_arc_same_startend', 'function', 'utils', null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (20, 'gw_fct_anl_connec_duplicated', 'function', 'utils',null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (30, 'gw_fct_anl_node_duplicated', 'function', 'utils',null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (40, 'gw_fct_anl_node_orphan', 'function', 'utils',null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (50, 'gw_fct_anl_node_sink', 'function', 'utils',null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (60, 'gw_fct_clone_schema', 'function', 'utils',null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (70, 'gw_fct_connec_to_network', 'function', 'utils',null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (80, 'gw_fct_delete_node', 'function', 'utils', null, 'integer');

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (90, 'gw_fct_node2arc', 'function','utils',null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (100, 'gw_fct_set_functions_schema', 'function', 'utils',null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (110, 'gw_trg_arc_delete','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (120, 'gw_trg_arc_geometry_update','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (130, 'gw_trg_connec_proximity','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (140, 'gw_trg_connec_update','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (150, 'gw_trg_edit_link','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (160, 'gw_trg_link_delete','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (170, 'gw_trg_node_proximity','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (180, 'gw_trg_vnode_update','trigger function', 'utils', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (310, 'gw_fct_mincut','function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (320, 'gw_trg_valve_analytics','function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (330, 'gw_trg_arc_searchnodes','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (340, 'gw_trg_edit_arc','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (350, 'gw_trg_edit_connec','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (360, 'gw_trg_edit_inp_arc','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (370, 'gw_trg_edit_inp_node','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (380, 'gw_trg_edit_node','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (390, 'gw_trg_edit_valve','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (400, 'gw_trg_node_update','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (410, 'gw_trg_ui_doc','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (420, 'gw_trg_ui_element','trigger function', 'ws', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (710, 'gw_fct_dump_subcatchments','function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (720, 'gw_fct_flow_exit','function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (730, 'gw_fct_flow_trace','function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (740, 'gw_fct_gully_to_network','function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (750, 'gw_trg_arc_searchnodes','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (760, 'gw_trg_edit_arc','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (770, 'gw_trg_edit_connec','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (780, 'gw_trg_edit_gully','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (790, 'gw_trg_edit_inp_arc','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (800, 'gw_trg_edit_inp_node','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (810, 'gw_trg_edit_node','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (820, 'gw_trg_node_update','trigger function', 'ud', null, null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (430, 'gw_trg_edit_man_node', 'trigger function', 'ws', NULL, NULL);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (440, 'gw_trg_edit_man_connec', 'trigger function', 'ws', NULL, NULL);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type)  
VALUES (830, 'gw_trg_edit_man_node', 'trigger function', 'ud', NULL, NULL);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (840, 'gw_trg_edit_man_arc', 'trigger function', 'ud', NULL, NULL);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (850, 'gw_trg_edit_man_gully', 'trigger function', 'ud', NULL, NULL);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (860, 'gw_trg_edit_man_connec', 'trigger function', 'ud', NULL, NULL);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (190, 'gw_fct_node_state_update', 'trigger function', 'utils', null,null);

INSERT INTO audit_cat_function (id, name, function_type, context, input_params, return_type) 
VALUES (200, 'gw_fct_arc_state_update', 'trigger function', 'utils', null,null);

