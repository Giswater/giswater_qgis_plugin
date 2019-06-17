/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET isdeprecated=true WHERE id='gw_trg_arc_orphannode_delete';

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2702, 'gw_fct_grafanalytics', 'ws','function', '{"featureType":""}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"string","layoutname":"grl_option_parameters","layout_order":1,"value":"SECTORA"},
{"widgetname":"arc", "label":"Arcid:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layout_order":2,"value":null},
{"widgetname":"node", "label":"Nodeid:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layout_order":3,"value":null}]',
'Function to analyze graf of network. Multiple analysis is avaliable' ,'role_om',FALSE, TRUE, TRUE);


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, descript, sys_role_id, isdeprecated, istoolbox, isparametric)
VALUES (2704, 'gw_fct_grafanalytics_engine', 'ws','function', 'Engine function of grafanalytics', 'role_om',FALSE, FALSE,FALSE);



UPDATE config_param_system SET isenabled=false, isdeprecated='true' WHERE parameter='gw_trg_arc_orphannode_delete';

UPDATE node_type SET graf_delimiter = 'NONE';
UPDATE node_type SET graf_delimiter = 'MINSECTOR' WHERE type='VALVE';
UPDATE node_type SET graf_delimiter = 'PRESSZONE' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DQA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DMA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'SECTOR' WHERE type IN ('TANK', 'WATERWELL', 'WTP', 'SOURCE');

DELETE FROM dattrib_type;

UPDATE sys_fprocess_cat SET name='Sector inlet nodes' WHERE id=30;
INSERT INTO sys_fprocess_cat VALUES (43, 'Presszone from inside arcs', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (44, 'Presszone inlet nodes', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (45, 'DQA from inside arcs', 'om', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (46, 'DQA inlet nodes', 'om', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (47, 'DMA from inside arcs', 'om', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (48, 'DMA inlet nodes', 'om', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (49, 'Sector from inside arcs', 'om', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (50, 'Static pressure', 'om', '', 'ws');
INSERT INTO sys_fprocess_cat VALUES (51, 'Pipe capacity', 'om', '', 'ws');


INSERT INTO macroexploitation VALUES (-1, 'Ficticius marcroexploitation');
INSERT INTO exploitation VALUES (-1, 'Ficticius exploitation',-1);
INSERT INTO dma VALUES (-1, 'Ficticius for node delimiters');
INSERT INTO sector VALUES (-1, 'Ficticius for node delimiters');
INSERT INTO cat_presszone VALUES (-1, 'Ficticius for node delimiters',-1);
