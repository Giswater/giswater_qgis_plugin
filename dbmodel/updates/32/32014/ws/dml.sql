/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE node_type SET graf_delimiter = 'NONE';
UPDATE node_type SET graf_delimiter = 'MINSECTOR' WHERE type='VALVE';
UPDATE node_type SET graf_delimiter = 'PRESSZONE' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DQA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'DMA' WHERE type=NULL;
UPDATE node_type SET graf_delimiter = 'SECTOR' WHERE type IN ('TANK', 'WATERWELL', 'WTP', 'SOURCE');


INSERT INTO macroexploitation VALUES (-1, 'Undefined marcroexploitation');
INSERT INTO exploitation VALUES (-1, 'Undefined exploitation',-1);
INSERT INTO dma VALUES (-1, 'Undefined dma');
INSERT INTO sector VALUES (-1, 'Undefined sector');
INSERT INTO cat_presszone VALUES (-1, 'Undefined presszone',-1);

INSERT INTO inp_typevalue VALUES ('inp_recursive_function', '1', 'HYDRANT ANALYSIS', null, '{"functionName":"gw_fct_go2epa_hdyrant", "fprocessCat":"47", "steps":"5"}');
INSERT INTO inp_typevalue VALUES ('inp_recursive_function', '2', 'EPA OPTIMIZATION', null, '{"functionName":"gw_fct_go2epa_gaoptimization", "fprocessCat":"49", "steps":"9999"}');


SELECT setval('SCHEMA_NAME.man_addfields_parameter_id_seq', (SELECT max(id) FROM man_addfields_parameter), true);
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('minsector', 'PIPE', true, 'integer', NULL, NULL, '{"fprocesscat_id":"34"}', 'as', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('minsector', 'JUNCTION', true, 'integer', NULL, NULL, '{"fprocesscat_id":"34"}', 'AS', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('dqa', 'PIPE', true, 'integer', NULL, NULL, '{"fprocesscat_id":"44"}', 'as', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('dqa', 'JUNCTION', true, 'integer', NULL, NULL, '{"fprocesscat_id":"44"}', 'AS', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('staticpressure', 'PIPE', true, 'integer', NULL, NULL, '{"fprocesscat_id":"46"}', 'as', 'QTextEdit');
INSERT INTO man_addfields_parameter (param_name, cat_feature_id, is_mandatory, datatype_id, field_length, num_decimals, default_value, form_label, widgettype_id) 
VALUES ('staticpressure', 'JUNCTION', true, 'integer', NULL, NULL, '{"fprocesscat_id":"46"}', 'AS', 'QTextEdit');

