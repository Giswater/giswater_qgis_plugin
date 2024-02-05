/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Data for Name: value_state; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state VALUES (0, 'OBSOLETE', NULL);
INSERT INTO value_state VALUES (2, 'PLANIFIED', NULL);
INSERT INTO value_state VALUES (1, 'OPERATIVE', NULL);


--
-- Data for Name: value_state_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state_type VALUES (3, 2, 'PLANIFIED', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUCT', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISIONAL', false, true);
INSERT INTO value_state_type VALUES (99, 2, 'FICTICIUS', true, false);
INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETE', false, false);
INSERT INTO value_state_type VALUES (2, 1, 'OPERATIVE', true, true);


--
-- Data for Name: edit_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO edit_typevalue VALUES ('nullvalue', '0', NULL, NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'integer', 'integer', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'text', 'text', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'date', 'date', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'boolean', 'boolean', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'numeric', 'numeric', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('sector_type', 'distribution', 'distribution', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('sector_type', 'undefined', 'undefined', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('sector_type', 'source', 'source', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('dqa_type', 'chlorine', 'chlorine', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('dqa_type', 'undefined', 'undefined', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('dqa_type', 'other', 'other', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('raster_type', 'DEM', 'DEM', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('raster_type', 'Slope', 'Slope', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('valve_ordinarystatus', '0', 'closed', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('valve_ordinarystatus', '1', 'opened', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('valve_ordinarystatus', '2', 'maybe', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_verified', 'TO REVIEW', 'TO REVIEW', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_verified', 'VERIFIED', 'VERIFIED', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '0', 'No changes', 'There are no changes above or below the tolerance values', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '1', 'new element', 'New element inserted in the review', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '2', 'Geometry modified', 'Geometry modified in the review. Other data can also be modified', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '3', 'Data modified', 'Changes in the data, not in the geometry', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '0', 'Rejected', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '1', 'Accepted', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '2', 'To review', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '0', 'FALSE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '1', 'MAYBE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '2', 'TRUE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '3', 'UNKNOWN', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('graphdelimiter_type', 'DMA', 'DMA', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('graphdelimiter_type', 'DQA', 'DQA', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('graphdelimiter_type', 'MINSECTOR', 'MINSECTOR', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('graphdelimiter_type', 'NONE', 'NONE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('graphdelimiter_type', 'PRESSZONE', 'PRESSZONE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('graphdelimiter_type', 'SECTOR', 'SECTOR', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '4', 'Only review observations', NULL, NULL);


--
-- Data for Name: om_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO om_typevalue VALUES ('visit_parameter_criticity', '1', 'Urgent', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_parameter_criticity', '2', 'High', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_parameter_criticity', '3', 'Normal', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_parameter_criticity', '4', 'Minor', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_cause', '1', 'Accidental', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_cause', '2', 'Planified', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_class', '1', 'Network mincut', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_class', '2', 'Connec mincut', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_class', '3', 'Hydrometer mincut', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '1', 'In Progress', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '2', 'Finished', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '0', 'Planified', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '3', 'Canceled', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_type', '1', 'planned', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_type', '2', 'unexpected', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '1', 'Started', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '2', 'Stand-by', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '3', 'Canceled', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '4', 'Finished', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_param_action', '1', 'Complementary events', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_param_action', '2', 'Incompatible events', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_param_action', '3', 'Redundant events', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_form_type', 'event_standard', 'event_standard', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_form_type', 'event_ud_arc_rehabit', 'event_ud_arc_rehabit', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_form_type', 'event_ud_arc_standard', 'event_ud_arc_standard', NULL, NULL);
INSERT INTO om_typevalue VALUES ('profile_papersize', '0', 'CUSTOM', NULL, NULL);
INSERT INTO om_typevalue VALUES ('profile_papersize', '1', 'DIN A5 - 210x148', NULL, '{"xdim":210, "ydim":148}');
INSERT INTO om_typevalue VALUES ('profile_papersize', '2', 'DIN A4 - 297x210', NULL, '{"xdim":297, "ydim":210}');
INSERT INTO om_typevalue VALUES ('profile_papersize', '3', 'DIN A3 - 420x297', NULL, '{"xdim":420, "ydim":297}');
INSERT INTO om_typevalue VALUES ('profile_papersize', '4', 'DIN A2 - 594x420', NULL, '{"xdim":594, "ydim":420}');
INSERT INTO om_typevalue VALUES ('profile_papersize', '5', 'DIN A1 - 840x594', NULL, '{"xdim":840, "ydim":594}');
INSERT INTO om_typevalue VALUES ('mincut_state', '4', 'On planning', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_param_type', 'INSPECTION', 'INSPECTION', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'RECONST', 'RECONST', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'OTHER', 'OTHER', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'REHABIT', 'REHABIT', NULL, '{"go2plan":true}');
INSERT INTO om_typevalue VALUES ('waterbalance_method', 'CPW', 'CRM PERIOD WINDOW', NULL, NULL);
INSERT INTO om_typevalue VALUES ('waterbalance_method', 'DCW', 'DMA CENTROID WINDOW', NULL, NULL);


--
-- Data for Name: doc_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO doc_type VALUES ('AS_BUILT', NULL);
INSERT INTO doc_type VALUES ('INCIDENT', NULL);
INSERT INTO doc_type VALUES ('WORK RAPPORT', NULL);
INSERT INTO doc_type VALUES ('OTHER', NULL);
INSERT INTO doc_type VALUES ('PICTURE', NULL);


--
-- Data for Name: plan_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO plan_typevalue VALUES ('psector_status', '2', 'PLANNED', 'Psector planned', NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '1', 'HIGH_PRIORITY', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '2', 'NORMAL_PRIORITY', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '3', 'LOW_PRIORITY', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_type', '1', 'Planified', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '1', 'Reconstruction', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '2', 'Rehabilitation', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm3', 'm3', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm2', 'm2', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm', 'm', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'pa', 'pa', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'u', 'u', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'kg', 'kg', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 't', 't', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '0', 'EXECUTED (Save Trace)', 'Psector executed. Its elements are copied to traceability tables', NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '1', 'ONGOING (Keep Plan)', 'Psector on course', NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '3', 'CANCELED (Save Trace)', 'Psector canceled. Its elements are copied to traceability tables', NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '4', 'EXECUTED (Set OPERATIVE and Save Trace)', 'Psector executed. Its elements are set to On Service and also copied to traceability tables', NULL);


--
-- Data for Name: config_csv; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO config_csv VALUES (234, 'Import db prices', 'The csv file must contains next columns on same position: id, unit, descript, text, price. 
- The column price must be numeric with two decimals. 
- You can choose a catalog name for these prices setting an import label. 
', 'gw_fct_import_dbprices', true, 1, NULL);
INSERT INTO config_csv VALUES (238, 'Import om visit', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'gw_fct_import_omvisit', true, 5, NULL);
INSERT INTO config_csv VALUES (236, 'Import addfields', 'The csv file must containts next columns on same position: 
feature_id (can be arc, node or connec), parameter_id (choose from sys_addfields), value_param. ', 'gw_fct_import_addfields', true, 3, NULL);
INSERT INTO config_csv VALUES (235, 'Import elements', 'The csv file must containts next columns on same position:
Id (arc_id, node_id, connec_id), code, elementcat_id, observ, comment, num_elements, state type (id), workcat_id, verified (choose from edit_typevalue>value_verified).
- Observations and comments fields are optional
- ATTENTION! Import label has to be filled with the type of element (node, arc, connec)', 'gw_fct_import_elements', true, 2, NULL);
INSERT INTO config_csv VALUES (384, 'Import inp curves', 'Function to automatize the import of inp curves files. 
The csv file must containts next columns on same position: 
curve_id, x_value, y_value, curve_type (for WS project OR UD project curve_type has diferent values. Check user manual)', 'gw_fct_import_inp_curve', true, 9, NULL);
INSERT INTO config_csv VALUES (386, 'Import inp patterns', 'Function to automatize the import of inp patterns files. 
The csv file must containts next columns on same position: 
pattern_id, pattern_type, factor1,.......,factorn. 
For WS use up factor18, repeating rows if you like. 
For UD use up factor24. More than one row for pattern is not allowed', 'gw_fct_import_inp_pattern', true, 9, NULL);
INSERT INTO config_csv VALUES (444, 'Import cat_feature_arc', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 12, NULL);
INSERT INTO config_csv VALUES (445, 'Import cat_feature_node', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, isarcdivide, isprofilesurface, choose_hemisphere, code_autofill, double_geom, num_arcs, graph_delimiter, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 13, NULL);
INSERT INTO config_csv VALUES (446, 'Import cat_feature_connec', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 14, NULL);
INSERT INTO config_csv VALUES (448, 'Import cat_node', 'The csv file must contain the following columns in the exact same order: 
id, nodetype_id, matcat_id, pnom, dnom, dint, dext, shape, descript, link, brand, model, svg, estimated_depth, cost_unit, cost, active, label, ischange, acoeff', 'gw_fct_import_catalog', true, 16, NULL);
INSERT INTO config_csv VALUES (449, 'Import cat_connec', 'The csv file must contain the following columns in the exact same order: 
id, connectype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, active, label', 'gw_fct_import_catalog', true, 17, NULL);
INSERT INTO config_csv VALUES (450, 'Import cat_arc', 'The csv file must contain the following columns in the exact same order: 
id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, shape, acoeff, connect_cost', 'gw_fct_import_catalog', true, 15, NULL);
INSERT INTO config_csv VALUES (469, 'Import scada_x_data', 'Import scada_x_data', 'gw_fct_import_scada_x_data', false, 18, NULL);
INSERT INTO config_csv VALUES (470, 'Import hydrometer_x_data', 'Import hdyrometer_x_data', 'gw_fct_import_hydrometer_x_data', false, 19, NULL);
INSERT INTO config_csv VALUES (471, 'Import crm period values', 'Import crm period values', 'gw_fct_import_cat_period', false, 20, NULL);
INSERT INTO config_csv VALUES (500, 'Import valve status', 'The csv file must have the folloWing fields:
dscenario_name, node_id, status', 'gw_fct_import_valve_status', false, NULL, NULL);
INSERT INTO config_csv VALUES (501, 'Import dscenario demands', 'The csv file must have the folloWing fields:
dscenario_name, feature_id, feature_type, demand_type, value, source', 'gw_fct_import_dscenario_demands', false, NULL, NULL);


--
-- Data for Name: sys_message; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO sys_message VALUES (2038, 'The exit arc must be reversed. Arc =', NULL, 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2058, 'It is not possible to relate this geometry to any node.', 'The node must be type ''CHAMBER'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (-1, 'Uncatched error', 'Open PotgreSQL log file to get more details', 2, true, 'generic', 'core');
INSERT INTO sys_message VALUES (1002, 'Test trigger', 'Trigger test', 0, true, 'ws_trg', 'core');
INSERT INTO sys_message VALUES (2008, 'Arc not found', 'Please check table arc', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3010, 'The minimum arc length of this exportation is: ', 'This length is less than nod2arc parameter. You need to update config.node2arc parameter to value less than it.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2122, 'Arc not found on insertion process', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3008, 'The values of addfields are different for both arcs.', 'Review your data to make them equal.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3012, 'The position value is bigger than the full length of the arc. ', 'Please review your data.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3014, 'The position id is not node_1 or node_2 of selected arc.', 'Please review your data.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3016, 'New field overlaps the existing one', 'Modify the order value.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3018, 'Customer code is duplicated for connecs with state=1', 'Review your data.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3024, 'Can''t delete the parameter. There is at least one event related to it', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3026, 'Can''t delete the class. There is at least one visit related to it', 'The class will be set to unactive.', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3028, 'Can''t modify typevalue:', 'It''s impossible to change system values.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3030, 'Can''t delete typevalue:', 'It''s being used in a table.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3032, 'Can''t apply the foreign key', 'there are values already inserted that are not present in the catalog', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3034, 'Inventory state and state type of planified features has been updated', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3036, 'Selected state type doesn''t correspond with state', 'Modify the value of state or state type.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3038, 'Inserted value has unaccepted characters:', 'Don''t use accents, dots or dashes in the id and child view name', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3040, 'User with this name already exists', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3042, 'Arc with state 2 cant be divided by node with state 1.', 'To divide an arc, the state of the node has to be the same', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3044, 'Can''t detect any arc to divide.', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3046, 'Selected node type doesn''t divide arc. Node type: ', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3048, 'Flow length is longer than length of exit arc feature', 'Please review your project!', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3050, 'It is not possible to relate connects with state=1 to arcs with state=2', 'Please check your map', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3052, 'Connect2network tool is not enabled for connec''s with state=2. Connec_id:', 'For planned connec''s you must create the link manually (one link for each alternative and one connec) by using the psector form and relate the connec using the arc_id field. After that you will be able to customize the link''s geometry.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3054, 'Connect2network tool is not enabled for gullies with state=2. Gully_id:', 'For planned gullies you must create the link manually (one link for each alternative and one gully) by using the psector form and relate the gully using the arc_id field. After that you will be able to customize the link''s geometry.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3056, 'It is impossible to validate the arc without assigning value of arccat_id. Arc_id:', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3058, 'It is impossible to validate the connec without assigning value of connecat_id. Connec_id:', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3060, 'It is impossible to validate the node without assigning value of nodecat_id. Node_id:', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3062, 'Selected gratecat_id has NULL width or length. Gratecat_id:', 'Check grate catalog or your custom config values before continue', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3064, 'There is a pattern with same name on inp_pattern table', 'Please check before continue.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3066, 'The dma and period don''t exists yet on dma-period table (ext_rtc_scada_dma_period). It means there are no values for that dma or for that CRM period into GIS', 'Please check it before continue.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3068, 'The dma/period defined on the dma-period table (ext_rtc_scada_dma_period) has a pattern_id defined', 'Please check it before continue.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3070, 'Link needs one connec/gully feature as start point. Geometry have been checked and there is no connec/gully feature as start/end point', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3072, 'It is not possible to connect link closer than 0.25 meters from nod2arc features in order to prevent conflits if this node may be a nod2arc', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3074, 'It is mandatory to connect as init point one connec or gully with link', NULL, 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3078, 'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id:', 'On planning mode it is possible to create more than one link, one for each alternative, but it is mandatory to use the psector form and relate gully using arc_id field. After that you will be able to customize the link''s geometry.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3084, 'It is not enabled to insert vnodes. if you are looking to join links you can use vconnec to join it', 'You can create vconnec feature and simbolyze it as vnodes. By using vconnec as vnodes you will have all features in terms of propagation of arc_id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3086, 'It is not enabled to update vnodes', 'If you are looking to update endpoint of links use the link''s layer to do it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3088, 'It is not enabled to delete vnodes', 'Vnode will be automaticly deleted when link connected to vnode disappears', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3092, 'Only arc is available as input feature to execute mincut', NULL, 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3094, 'One of new arcs has no length', 'The selected node may be its final.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3096, 'If widgettype=typeahead, isautoupdate must be FALSE', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3098, 'If widgettype=typeahead and dv_querytext_filterc is not null dv_parent_id must be combo', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3100, 'If widgettype=typeahead, id and idval for dv_querytext expression must be the same field', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3102, 'If dv_querytext_filterc is not null dv_parent_id is mandatory', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3104, 'When dv_querytext_filterc, dv_parent_id must be a valid column for this form. Please check form because there is not column_id with this name', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3106, 'There is no presszone defined in the model', NULL, 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3108, 'Feature is out of any presszone, feature_id:', NULL, 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3110, 'There is no municipality defined in the model', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3112, 'No class visit', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3114, 'sucessfully deleted', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3116, 'does not exists, impossible to delete it', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3118, 'sucessfully inserted', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3120, 'sucessfully updated', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3122, 'Visit class have been changed. Previous data have been deleted', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3124, 'Visit manager have been initialized', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3126, 'Visit manager have been finished', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3128, 'Lot succesfully saved', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3130, 'Lot succesfully deleted', NULL, 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3006, 'There are one or more arc(s) with null nodes. Mincut is broken.', 'Please review your data', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3002, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2120, 'There is an inconsistency between node and arc state', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2110, 'Define at least one value of state_type with state=0', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2108, 'There is at least one node attached to the deleted feature. (num. node,feature_id)=', 'Review your data. The deleted feature can''t have any nodes attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2106, 'The provided node_id doesn''t exist as a ''TANK'' (system type)', 'Look for another node', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2104, 'The provided node_id doesn''t exist as a ''REGISTER'' (system type)', 'Look for another node', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2102, 'It is not possible to relate this geometry to any node.', 'The node must be type ''TANK'' (system type).', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2100, 'It is not possible to relate this geometry to any node.', 'The node must be type ''REGISTER'' (system type).', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2098, 'The provided connec_id doesn''t exist as a ''FOUNTAIN'' (system type)', 'Look for another connec', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2096, 'It is not possible to relate this geometry to any connec.', 'The connec must be type ''FOUNTAIN'' (system type).', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2094, 'Please, assign one connec to relate this polygon geometry', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2092, 'There are null values on the [price] column of csv', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2090, 'There are null [descript] values on the imported csv', 'Please complete it before to continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2088, 'There are [units] values nulls or not defined on price_value_unit table  =', 'Please fill it before to continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2086, 'There are null values on the [id] column of csv. Check it', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2084, 'The module does not exists. Module =', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2082, 'The extension does not exists. Extension =', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2080, 'The x value is too large. The total length of the line is ', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2078, 'Query text =', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2076, 'Flow length is longer than length of exit arc feature', 'Please review your project', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2074, 'You must define the length of the flow regulator', NULL, 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2072, 'You need to set to_arc/node_id values with topologic coherency', 'Node_id must be the node_1 of the exit arc feature', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2070, 'You need to set a value of to_arc column before continue', NULL, 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2068, 'The provided node_id don''t exists as a ''WWTP'' (system type)', 'Please look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2066, 'The provided node_id don''t exists as a ''CHAMBER'' (system type)', 'Please look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2064, 'The provided node_id doesn''t exist as a ''STORAGE'' (system type)', 'Look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2062, 'The provided node_id doesn''t exist as a ''NETGULLY'' (system type)', 'Look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2060, 'It is not possible to relate this geometry to any node.', 'The node must be type ''WWTP'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3090, 'Please enter a valid graphClass', NULL, 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2056, 'It is not possible to relate this geometry to any node.', 'The node must be type ''STORAGE'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2054, 'It is not possible to relate this geometry to any node.', 'The node must be type ''NETGULLY'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2052, 'Polygon not related with any node', 'Insert node_id in order to assign the polygon geometry to the feature', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2050, 'The provided gully_id doesn''t exist.', 'Look for another gully_id', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2048, 'Polygon not related with any gully', 'Insert gully_id in order to assign the polygon geometry to the feature', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2046, 'State type is not a value of the defined state. Please review your data', 'State type must be related to states', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2044, 'Presszone is not into the defined exploitation. Please review your data', 'The element must be inside the press zone which is related to the defined exploitation', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2042, 'Dma is not into the defined exploitation. Please review your data', 'The element must be inside the dma which is related to the defined exploitation', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2040, 'Reduced geometry is not a Linestring, (arc_id,geom type)=', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2036, 'It is impossible to validate the arc without assigning value of arccat_id, arc_id:', 'Please assign an arccat_id value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2034, 'Your catalog is different than node type', 'Your data must be in the node catalog too', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2032, 'Please, fill the node catalog value or configure it with the value default parameter', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2030, 'The feature not have state(2) value to be replaced, state = ', 'The feature must have state 2 to be replaced', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2028, 'The feature does not have state(1) value to be replaced, state = ', 'The feature must have state 1 to be replaced', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2026, 'There are conflicts against another planified mincut.', 'Please review your data', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2024, 'Feature is out of any municipality,feature_id:', 'Please review your data', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2022, '(arc_id, geom type) =', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2020, 'One or more vnodes are closer than configured minimum distance', 'Check your project or modify the configuration properties (config.node_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2018, 'At least one of the extremal nodes of the arc is not present on the alternative updated. The planified network has losed the topology', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2016, 'It''s not enabled to modify the start/end point of link', 'If you want to reconnect the features, delete this link and draw a new one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2015, 'There is no state-1 feature as endpoint of link. It is impossible to create it', 'Try to connect the link to one arc / node / connec / gully or vnode with state=1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2014, 'You need to connec the link to one connec/gully', 'Links must be connected to ohter elements', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2012, 'Feature is out of exploitation, feature_id:', 'Take a look on your map and use the approach of the exploitations!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2010, 'There are no values on the cat_element table.', 'Elementcat_id is required. Insert values into cat_element table or use a default value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2006, 'It is impossible to use the node to fusion two arcs', 'Node doesn''t have 2 arcs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2004, 'It is impossible to use the node to fusion two arcs', 'Pipes have different types', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2002, 'Node not found', 'Please check table node', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1110, 'There are no exploitations defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1106, 'Delete is not allowed. There is hydrometer_id on ...', NULL, 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1104, 'Update is not allowed ...', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1102, 'Insert is not allowed. There is no hydrometer_id on ...', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1100, 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is:', 'Review your data. It''s not possible to have more than one node with the same state at the same position.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1098, 'It''s not allowe to have node with state(1) or(2) over one existing node with state(1).', 'Use the button replace node. It''s not possible to have more than one nodes with the same state at the same position', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1097, 'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is:', 'Please ckeck it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1096, 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is:', 'Review your project data.It''s not possible to have more than one nodes with the same state at the same position.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1094, 'Your catalog is different than node type', 'You must use a node type defined in node catalogs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1092, 'Your default value catalog is not enabled using the node type choosed', 'You must use a node type defined in node catalogs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1090, 'You must choose a node catalog value for this feature', 'Nodecat_id is required. Fill the table cat_node or use a default value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1088, 'Connec catalog is different than connec type', 'Use a connec type defined in connec catalogs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1086, 'You must choose a connec catalog value for this feature', 'Connecat_id is required. Fill the table cat_connec or use a default value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1084, 'Nonexistent node_id:', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1083, 'Please configure your own psector vdefault variable', 'To work with planified elements it is mandatory to have always defined the work psector using the psector vdefault variable', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1082, 'Nonexistent arc_id:', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1081, 'There are not psectors defined on the project', 'You need to have at least one psector created to add planified elements', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1080, 'You don''t have permissions to manage with psector', 'Please check if your profile has role_master in order to manage with plan issues', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1078, 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: ', NULL, 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1076, 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: ', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1074, 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: ', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1072, 'Before downgrading the node to state 0, disconnect the associated features, node_id: ', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1070, 'The feature can''t be replaced, because it''s state is different than 1. State = ', 'To replace a feature, it must have state = 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1068, 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)=', 'Review your data. The deleted feature can''t have any gullies attached.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1066, 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) =', 'Review your data. The deleted feature can''t have any connecs attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1064, 'There is at least one link attached to the deleted feature. (num. link,feature_id) =', 'Review your data. The deleted feature can''t have any links attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1062, 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) =', 'Review your data. The deleted feature can''t have any visits attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1060, 'There is at least one document attached to the deleted feature. (num. document,feature_id) =', 'Review your data. The deleted feature can''t have any documents attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1058, 'There is at least one element attached to the deleted feature. (num. element,feature_id) =', 'Review your data. The deleted feature can''t have any elements attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1056, 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) =', 'Review your data. The deleted feature can''t have any arcs attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1054, 'It''is impossible to divide an arc with state=(1) using a node with state=(2)', 'To divide an arc, the state of the used node has to be 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1052, 'It''s impossible to divide an arc using node that has state=(0)', 'To divide an arc, the state of the node has to be 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1050, 'It''s impossible to divide an arc with state=(0)', 'To divide an arc, the state has to be 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1048, 'Elev is not an updatable column', 'Please use top_elev or ymax to modify this value', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1046, 'Exists one o more nodes closer than configured minimum distance, node_id: ', 'Check your project or modify the configuration properties (config.node_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1044, 'Exists one o more connecs closer than configured minimum distance, connec_id:', 'Check your project or modify the configuration properties (config.connec_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1042, 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id:', 'Check your project or modify the configuration properties.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1040, 'One or more arcs has the same node as Node1 and Node2. Node_id:', 'Check your project or modify the configuration properties', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1038, 'Delete valves from this table is not allowed', 'To delete valves, use layer node in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1036, 'There are columns in this table not allowed to edit', 'Try to update open, accesibility, broken, mincut_anl or hydraulic_anl', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1034, 'Insert a new valve in this table is not allowed', 'To insert a new valve, use layer ndoe in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1032, 'Delete nodes from this table is not allowed', 'To delete nodes, use layer node in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1030, 'Insert a new node in this table is not allowed', 'To insert new node, use layer node INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1028, 'Delete arcs from this table is not allowed', 'To delete arcs, use layer arc in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1026, 'Insert new arc in this table is not allowed', 'To insert new arc, use layer arc in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1024, 'There are no grate catalog values defined in the model', 'Define at least one', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1022, 'There are no connec catalog values defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1020, 'There are no arc catalog values defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1018, 'There are no arc types defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1016, 'It''s impossible to change node catalog', 'The new node catalog doesn''t belong to the same type as the old node catalog (node_type.type) ', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1014, 'Feature is out of dma, feature_id:', 'Take a look on your map and use the approach of the dma', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1012, 'There is no dma defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1010, 'Feature is out of sector, feature_id:', 'Take a look on your map and use the approach of the sectors!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1008, 'There are no sectors defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1006, 'There are no node catalog values defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1004, 'There are no node types defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3132, 'Schema defined does not exists. Check your qgis project variable gwAddSchema', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3134, 'There''s no default value for Obsolete state_type', 'You need to define one default value for Obsolete state_type', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3136, 'There''s no default value for On Service state_type', 'You need to define one default value for On Service state_type', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3138, 'Before use connec on planified mode you need to create a related link', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3144, 'Exploitation of the feature is different than the one of the related arc. Arc_id: ', 'Both features should have the same exploitation.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3162, 'This feature is a final node for planned arc ', 'It''s necessary to remove arcs first, then nodes', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3022, 'The inserted value is not present in a catalog.', 'Add it to the corresponding typevalue table in order to use it.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3166, 'Id value for this catalog already exists', 'Look for it in the proposed values or set a new id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3168, 'Before set isparent=TRUE, other field has to have related dv_parent_id', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3170, 'Before delete dv_parent_id, you must set isparent=FALSE to the parent field', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3172, 'Value inserted into field featurecat_id is not defined in a table cat_feature', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3178, 'It is no possible to relate planned connec/gully over planned connec/gully wich not are on same psector.', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3180, 'You are trying to modify some network element with related connects (connec / gully) on psector not selected.', 'Please activate the psector before!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3160, 'This feature with state = 2 is only attached to one psector', 'If you are looking to unlink from this psector, it is necessary to remove it from ve_* or v_edit_* or using end feature tool.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3080, 'It is not possible to relate connect with state=1 over network feature with state=2, connect:', 'Choose another end feature element with operative state (1).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3182, 'It is not allowed to downgrade (state=0) on psector tables for planned features (state=2). Planned features only must have state=1 on psector.', 'If you are looking for unlink it, please remove it from psector. If feature only belongs to this psector, and you are looking to unlink it, you will need to delete from ve_* or v_edit_* or use end feature tool.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3140, 'Node is connected to arc which is involved in psector', 'Try replacing node with feature replace tool or disconnect it using end feature tool', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3146, 'Backup name is missing', 'Insert value in key backupName', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3148, 'Backup name already exists', 'Try with other name or delete the existing one before', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3150, 'Backup has no data related to table', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3152, 'Null values on geom1 or geom2 fields on element catalog', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3154, 'It is not possible to add this connec to psector because it is related to node', 'Move endpoint of link closer than 0.01m to relate it to parent arc', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3156, 'Input parameter has null value', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3158, 'Value of the function variable is null', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3174, 'No valve has been choosen', 'You can continue by clicking on more valves or finish the process by clicking again on Change Valve Status', 0, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3176, 'Change valve status done successfully', 'You can continue by clicking on more valves or finish the process by executing Refresh Mincut', 0, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3184, 'There is at least one hydrometer related to the feature', 'Connec with state=0 can''t have any hydrometers state=1 attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3186, 'Workspace is being used by some user and can not be deleted', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3188, 'Workspace name already exists', 'Please set a new one or delete existing workspace', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3190, 'There are no nodes defined as arcs finals', 'First insert csv file with nodes definition', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3192, 'It is not possible to connect on service arc with a planified node', 'Reconnect arc with node state 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3194, 'It is not possible to downgrade connec because has operative hydrometer associated', 'Unlink hydrometers first', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3196, 'Shortcut key is already defined for another feature', 'Change it before uploading configuration', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3198, 'Field defined as target for DEM data is not related to elevation', 'Configure correctly parameter admin_raster_dem on config_param_system table or using configuration button', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3200, 'Workspace is not editable you can''t modify it nor delete it', NULL, 2, true, 'utils', NULL);
INSERT INTO sys_message VALUES (3142, 'Node is involved in psector', 'It''s used as init or final node on planified arcs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3202, 'It''s not possible to break planned arcs by using operative nodes', 'Try it using planned nodes', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3204, 'This connec has an associated link', 'Remove the associated link and arc_id field will be set to null', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3208, 'This connec has an associated link', 'Remove the associated link and arc_id field will be set to null', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3210, 'It''s impossible to downgrade the state of a planned connec', 'To unlink,  remove from psector dialog or delete it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3212, 'It''s impossible to update arc_id from psector dialog because this planned link has not arc as exit-type', 'Use connec dialog to update it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3218, 'It''s impossible to attach operative link to planned feature', 'Set link''s state to planned to continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3220, 'It''s impossible to change link''s state to operative, because it''s related to a planned feature', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3222, 'It''s impossible to upgrade link', 'In order to work with planned link, create new one by drawing it on link layer, using link2network button or feature/psector dialogs (setting arc_id)', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3224, 'It''s impossible to create a planned link for operative feature (connec/gully)', 'If you are working on psector, use link2network button or feature/psector dialogs(setting arc_id) and then modify it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3226, 'It''s impossible to downgrade link', 'If you want to remove it from psector, delete it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3076, 'It is not possible to create the link. On inventory mode only one link is enabled for each connec. Connec_id:', 'In order to relate link with psector use psector dialog or link2network button. you can''t draw in on link layer', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3082, 'The psector strategy is limited to only one psector when connect is related to not VNODE exit_type (link_class = 2). If you like to manage diferent psector with this connect, please use VNODE as exit_type feature', 'You can''t have two links related to the same feature (connec/gully) in one psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3228, 'It is not possible to insert arc into psector because has operative connects associated', 'You need to previously insert related connects into psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3164, 'Arc have incorrectly defined final nodes in this plan alternative', 'Make sure that arcs finales are on service or check by using toolbox function Check plan data (fid= 355)', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3238, 'Dscenario with this name doesn''t exist', 'Create an empty dscenario with the same name as indicated in csv file in order to continue the import of data', 2, true, 'ws', 'core');

ALTER TABLE cat_feature DISABLE TRIGGER gw_trg_cat_feature_after;
--
-- Data for Name: cat_feature; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature VALUES ('WJOIN', 'WJOIN', 'CONNEC', 'Ctrl+Z', 'v_edit_connec', 've_connec_wjoin', 'Wjoin', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VCONNEC', 'WJOIN', 'CONNEC', NULL, 'v_edit_connec', 've_connec_vconnec', 'Virtual connec', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('PIPE', 'PIPE', 'ARC', 'P', 'v_edit_arc', 've_arc_pipe', 'Water distribution pipe', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CHECK_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_check_valve', 'Check valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('PR_REDUC_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_pr_reduc_valve', 'Pressure reduction valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('GREEN_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_green_valve', 'Green valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CURVE', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_curve', 'Curve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('ENDLINE', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_endline', 'End of the line', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('FL_CONTR_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_fl_contr_valve', 'Flow control valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('GEN_PURP_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_gen_purp_valve', 'General purpose valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('PR_BREAK_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_pr_break_valve', 'Pressure break valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('OUTFALL_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_outfall_valve', 'Outfall valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('PR_SUSTA_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_pr_susta_valve', 'Pressure sustainer valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('SHUTOFF_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_shutoff_valve', 'Shutoff valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('THROTTLE_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_throttle_valve', 'Throttle-valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_t', 'Junction where 3 pipes converge', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_x', 'Junction where 4 pipes converge', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('AIR_VALVE', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_air_valve', 'Air valve', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('ADAPTATION', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_adaptation', 'Adaptation junction', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('JUNCTION', 'JUNCTION', 'NODE', 'Alt+J', 'v_edit_node', 've_node_junction', 'Junction', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('TANK', 'TANK', 'NODE', 'Alt+K', 'v_edit_node', 've_node_tank', 'Tank', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('FOUNTAIN', 'FOUNTAIN', 'CONNEC', 'Ctrl+N', 'v_edit_connec', 've_connec_fountain', 'Ornamental fountain', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('TAP', 'TAP', 'CONNEC', 'Ctrl+T', 'v_edit_connec', 've_connec_tap', 'Water source', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('GREENTAP', 'GREENTAP', 'CONNEC', 'Ctrl+G', 'v_edit_connec', 've_connec_greentap', 'Greentap', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC', 'A', 'v_edit_arc', 've_arc_varc', 'Virtual section of the pipe network. Used to connect arcs and nodes when polygons exists', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CONTROL_REGISTER', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_control_register', 'Control register', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('BYPASS_REGISTER', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_bypass_register', 'Bypass-register', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('VALVE_REGISTER', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_valve_register', 'Valve register', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('WATER_CONNECTION', 'NETWJOIN', 'NODE', NULL, 'v_edit_node', 've_node_water_connection', 'Water connection', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('FLOWMETER', 'METER', 'NODE', NULL, 'v_edit_node', 've_node_flowmeter', 'Flow meter', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('EXPANTANK', 'EXPANSIONTANK', 'NODE', NULL, 'v_edit_node', 've_node_expantank', 'Expansiontank', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('PRESSURE_METER', 'METER', 'NODE', NULL, 'v_edit_node', 've_node_pressure_meter', 'Pressure meter', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('FILTER', 'FILTER', 'NODE', 'Alt+F', 'v_edit_node', 've_node_filter', 'Filter', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('FLEXUNION', 'FLEXUNION', 'NODE', 'Alt+U', 'v_edit_node', 've_node_flexunion', 'Flex union', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('HYDRANT', 'HYDRANT', 'NODE', 'Alt+H', 'v_edit_node', 've_node_hydrant', 'Hydrant', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('MANHOLE', 'MANHOLE', 'NODE', 'Alt+L', 'v_edit_node', 've_node_manhole', 'Inspection chamber', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE', 'Alt+E', 'v_edit_node', 've_node_netelement', 'Netelement', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'NODE', 'Alt+B', 'v_edit_node', 've_node_netsamplepoint', 'Netsamplepoint', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('REDUCTION', 'REDUCTION', 'NODE', 'Alt+R', 'v_edit_node', 've_node_reduction', 'Reduction', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('REGISTER', 'REGISTER', 'NODE', 'Alt+I', 'v_edit_node', 've_node_register', 'Register', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('SOURCE', 'SOURCE', 'NODE', 'Alt+S', 'v_edit_node', 've_node_source', 'Source', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('WATERWELL', 'WATERWELL', 'NODE', 'Alt+W', 'v_edit_node', 've_node_waterwell', 'Waterwell', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('WTP', 'WTP', 'NODE', 'Alt+X', 'v_edit_node', 've_node_wtp', 'Water treatment point', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('PUMP', 'PUMP', 'NODE', 'Alt+P', 'v_edit_node', 've_node_pump', 'Pump', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CLORINATHOR', 'NETELEMENT', 'NODE', NULL, 'v_edit_node', 've_node_clorinathor', 'Element to reclorate water', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 'v_edit_link', 'Link', NULL, true, false, NULL);


--
-- Data for Name: cat_feature_arc; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_arc VALUES ('PIPE', 'PIPE', 'PIPE');
INSERT INTO cat_feature_arc VALUES ('VARC', 'VARC', 'PIPE');


--
-- Data for Name: cat_feature_connec; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_connec VALUES ('WJOIN', 'WJOIN', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('FOUNTAIN', 'FOUNTAIN', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('TAP', 'TAP', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('GREENTAP', 'GREENTAP', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('VCONNEC', 'WJOIN', '{"activated":false,"value":1}', 'JUNCTION');


--
-- Data for Name: cat_feature_node; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_node VALUES ('JUNCTION', 'JUNCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CLORINATHOR', 'NETELEMENT', 'SHORTPIPE', 2, true, true, 'DQA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('T', 'JUNCTION', 'JUNCTION', 3, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('X', 'JUNCTION', 'JUNCTION', 4, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ADAPTATION', 'JUNCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CURVE', 'JUNCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ENDLINE', 'JUNCTION', 'JUNCTION', 1, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('FL_CONTR_VALVE', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('GEN_PURP_VALVE', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PR_SUSTA_VALVE', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PR_REDUC_VALVE', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PR_BREAK_VALVE', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('THROTTLE_VALVE', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('GREEN_VALVE', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('OUTFALL_VALVE', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('AIR_VALVE', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('SHUTOFF_VALVE', 'VALVE', 'SHORTPIPE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CHECK_VALVE', 'VALVE', 'SHORTPIPE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('REGISTER', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVE_REGISTER', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('BYPASS_REGISTER', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CONTROL_REGISTER', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('NETELEMENT', 'NETELEMENT', 'JUNCTION', 2, true, true, 'DQA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('EXPANTANK', 'EXPANSIONTANK', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('FILTER', 'FILTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('FLEXUNION', 'FLEXUNION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PRESSURE_METER', 'METER', 'JUNCTION', 2, true, true, 'DMA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('FLOWMETER', 'METER', 'JUNCTION', 2, true, true, 'DMA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('HYDRANT', 'HYDRANT', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('MANHOLE', 'MANHOLE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('NETSAMPLEPOINT', 'NETSAMPLEPOINT', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PUMP', 'PUMP', 'PUMP', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('REDUCTION', 'REDUCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('SOURCE', 'SOURCE', 'RESERVOIR', 2, true, true, 'SECTOR', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('TANK', 'TANK', 'TANK', 9, true, true, 'SECTOR', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('WATER_CONNECTION', 'NETWJOIN', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('WATERWELL', 'WATERWELL', 'RESERVOIR', 2, true, true, 'SECTOR', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('WTP', 'WTP', 'RESERVOIR', 2, true, true, 'SECTOR', false, '{"activated":false,"value":1}');

--
-- Data for Name: config_graph_valve; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO config_graph_valve VALUES ('SHUTOFF_VALVE', true);

ALTER TABLE cat_feature ENABLE TRIGGER gw_trg_cat_feature_after;

--
-- Data for Name: element_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO element_type VALUES ('REGISTER', true, true, 'REGISTER', NULL);
INSERT INTO element_type VALUES ('MANHOLE', true, true, 'MANHOLE', NULL);
INSERT INTO element_type VALUES ('COVER', true, true, 'COVER', NULL);
INSERT INTO element_type VALUES ('STEP', true, true, 'STEP', NULL);
INSERT INTO element_type VALUES ('PROTECT_BAND', true, true, 'PROTECT BAND', NULL);
INSERT INTO element_type VALUES ('HYDRANT_PLATE', true, true, 'HYDRANT_PLATE', NULL);


