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
INSERT INTO value_state VALUES (1, 'EN_SERVICE', NULL);
INSERT INTO value_state VALUES (2, 'PLANIFIE', NULL);


--
-- Data for Name: value_state_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state_type VALUES (2, 1, 'EN_SERVICE', true, true);
INSERT INTO value_state_type VALUES (3, 2, 'PLANIFIÉ', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUIT', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PREVISIONNEL', false, true);
INSERT INTO value_state_type VALUES (99, 2, 'FICTICIUS', true, false);
INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETE', false, false);


--
-- Data for Name: edit_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO edit_typevalue VALUES ('nullvalue', '0', NULL, NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'integer', 'integer', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'text', 'text', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'date', 'date', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'boolean', 'boolean', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('man_addfields_cat_datatype', 'numeric', 'numeric', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('raster_type', 'DEM', 'DEM', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('raster_type', 'Slope', 'Slope', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_verified', 'A VERIFIE', 'A VERIFIE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_verified', 'VERIFIE', 'VERIFIE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '0', 'Aucun changement', 'Aucun changement au-dessus ou au-dessous des valeurs de tolérance', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '1', 'nouveau element', 'Nouveau élément inséré à la vérification', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '2', 'Géometrie modifié', 'Géometrie modifié lors de la vérification. D autres éléments peuvent avoir été modifié ', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '3', 'Donnée modifiée', 'Changement dans les données, exception faite de la geometrie', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '0', 'Rejeté', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '1', 'Accepté', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '2', 'A vérifier', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '0', 'FALSE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '1', 'MAYBE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '2', 'TRUE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_boolean', '3', 'UNKNOWN', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('gully_units_placement', 'WIDTH-SIDE', 'WIDTH-SIDE', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('gully_units_placement', 'LENGTH-SIDE', 'LENGTH-SIDE', NULL, NULL);
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
INSERT INTO om_typevalue VALUES ('visit_type', '1', 'planned', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_type', '2', 'unexpected', NULL, NULL);
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
INSERT INTO om_typevalue VALUES ('visit_param_type', 'INSPECTION', 'INSPECTION', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'RECONST', 'RECONST', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'AUTRE', 'AUTRE', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'REHABIT', 'REHABIT', NULL, '{"go2plan":true}');


--
-- Data for Name: doc_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO doc_type VALUES ('AS_BUILT', NULL);
INSERT INTO doc_type VALUES ('INCIDENT', NULL);
INSERT INTO doc_type VALUES ('RAPPORT TRAVAIL', NULL);
INSERT INTO doc_type VALUES ('AUTRE', NULL);
INSERT INTO doc_type VALUES ('PHOTO', NULL);


--
-- Data for Name: plan_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO plan_typevalue VALUES ('value_priority', '1', 'PRIORITE_MAX', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '2', 'PRIORITE_NORMALE', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '3', 'PRIORITE_BASSE', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_type', '1', 'Planifié', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '1', 'Reconstruction', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '2', 'Réhabilitation', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm3', 'm3', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm2', 'm2', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm', 'm', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'pa', 'pa', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'u', 'u', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'kg', 'kg', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 't', 't', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '4', 'EXECUTED (Set OPERATIVE and Save Trace)', 'Psector executed. Its elements are set to On Service and also copied to traceability tables', NULL);


--
-- Data for Name: config_csv; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO config_csv VALUES (234, 'Import prix BD', 'Le fichier csv doit contenir les colonnes suivantes aux mêmes positions : id, unit, descript, text, price. 
- La colonne de prix doit être un numérique avec deux décimales. 
- Vous pouvez choisir un nom de catalogue pour ces prix en définissant une étiquette d importation. 
- Attention, le fichier csv nécessite une ligne d en-tête', 'gw_fct_import_dbprices', true, 1, NULL);
INSERT INTO config_csv VALUES (238, 'Import om visit', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'gw_fct_import_omvisit', true, 5, NULL);
INSERT INTO config_csv VALUES (408, 'Import istram nodes', NULL, 'gw_fct_import_istram', false, 10, '{"query": "SELECT node_id, top_elev, sys_elev FROM v_edit_node ", "layerName":"Nodes", "group": "ISTRAM"}');
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
INSERT INTO config_csv VALUES (385, 'Import inp timeseries', 'Function to assist the import of timeseries for inp models.
The csv file must containts next columns on same position: 
timeseries, type, mode, date, hour, time, value (fill date/hour for ABSOLUTE or time for RELATIVE)', 'gw_fct_import_inp_timeseries', true, 9, NULL);
INSERT INTO config_csv VALUES (409, 'Import istram arcs', NULL, 'gw_fct_import_istram', false, 11, '{"query": "SELECT arc_id, sys_elev1, sys_elev2, cat_shape, matcat_id, cat_geom1, cat_geom2 FROM v_edit_arc ", "layerName":"Arcs", "group": "ISTRAM"}');
INSERT INTO config_csv VALUES (444, 'Import cat_feature_arc', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 12, NULL);
INSERT INTO config_csv VALUES (445, 'Import cat_feature_node', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, isarcdivide, isprofilesurface, code_autofill, choose_hemisphere, double_geom, num_arcs, isexitupperintro, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 13, NULL);
INSERT INTO config_csv VALUES (446, 'Import cat_feature_connec', 'The csv file must contain the following columns in the exact same order: 
id, system_id, code_autofill, double_geom, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 14, NULL);
INSERT INTO config_csv VALUES (447, 'Import cat_feature_gully', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, double_geom, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 15, '{"table": "cat_feature_gully"}');
INSERT INTO config_csv VALUES (448, 'Import cat_node', 'The csv file must contain the following columns in the exact same order: 
id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, cost, active, label, node_type, acoeff', 'gw_fct_import_catalog', true, 16, NULL);
INSERT INTO config_csv VALUES (449, 'Import cat_connec', 'The csv file must contain the following columns in the exact same order: 
id, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, label, connec_type', 'gw_fct_import_catalog', true, 17, NULL);
INSERT INTO config_csv VALUES (450, 'Import cat_arc', 'The csv file must contain the following columns in the exact same order: 
id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6,geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, tsect_id, curve_id, arc_type, acoeff, connect_cost', 'gw_fct_import_catalog', true, 15, NULL);
INSERT INTO config_csv VALUES (451, 'Import cat_grate', 'The csv file must contain the following columns in the exact same order: 
id, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, label, gully_type', 'gw_fct_import_catalog', true, 18, NULL);
INSERT INTO config_csv VALUES (469, 'Import scada_x_data', 'Import scada_x_data', 'gw_fct_import_scada_x_data', false, 18, NULL);
INSERT INTO config_csv VALUES (470, 'Import hydrometer_x_data', 'Import hdyrometer_x_data', 'gw_fct_import_hydrometer_x_data', false, 19, NULL);
INSERT INTO config_csv VALUES (471, 'Import crm period values', 'Import crm period values', 'gw_fct_import_cat_period', false, 20, NULL);


--
-- Data for Name: sys_message; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO sys_message VALUES (2078, 'Query text =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3018, 'Customer code is duplicated for connecs with state=1', 'Review your data.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3134, 'There''s no default value for Obsolete state_type', 'You need to define one default value for Obsolete state_type', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3136, 'There''s no default value for On Service state_type', 'You need to define one default value for On Service state_type', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3138, 'Before use connec on planified mode you need to create a related link', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3144, 'Exploitation of the feature is different than the one of the related arc. Arc_id: ', 'Both features should have the same exploitation.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3162, 'This feature is a final node for planned arc ', 'It''s necessary to remove arcs first, then nodes', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3166, 'Id value for this catalog already exists', 'Look for it in the proposed values or set a new id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3168, 'Before set isparent=TRUE, other field has to have related dv_parent_id', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3170, 'Before delete dv_parent_id, you must set isparent=FALSE to the parent field', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3172, 'Value inserted into field featurecat_id is not defined in a table cat_feature', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3178, 'It is no possible to relate planned connec/gully over planned connec/gully wich not are on same psector.', NULL, 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3180, 'You are trying to modify some network element with related connects (connec / gully) on psector not selected.', 'Please activate the psector before!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3160, 'This feature with state = 2 is only attached to one psector', 'If you are looking to unlink from this psector, it is necessary to remove it from ve_* or v_edit_* or using end feature tool.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3182, 'It is not allowed to downgrade (state=0) on psector tables for planned features (state=2). Planned features only must have state=1 on psector.', 'If you are looking for unlink it, please remove it from psector. If feature only belongs to this psector, and you are looking to unlink it, you will need to delete from ve_* or v_edit_* or use end feature tool.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3140, 'Node is connected to arc which is involved in psector', 'Try replacing node with feature replace tool or disconnect it using end feature tool', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3146, 'Backup name is missing', 'Insert value in key backupName', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3148, 'Backup name already exists', 'Try with other name or delete the existing one before', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3150, 'Backup has no data related to table', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3152, 'Null values on geom1 or geom2 fields on element catalog', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3154, 'It is not possible to add this connec to psector because it is related to node', 'Move endpoint of link closer than 0.01m to relate it to parent arc', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3156, 'Input parameter has null value', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3158, 'Value of the function variable is null', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1014, 'Feature is out of dma, feature_id:', 'Take a look on your map and use the approach of the dma', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1060, 'There is at least one document attached to the deleted feature. (num. document,feature_id) =', 'Review your data. The deleted feature can''t have any documents attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1110, 'There are no exploitations defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3042, 'Arc with state 2 cant be divided by node with state 1.', 'To divide an arc, the state of the node has to be the same', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1056, 'There is at least one arc attached to the deleted feature. (num. arc,feature_id) =', 'Review your data. The deleted feature can''t have any arcs attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1058, 'There is at least one element attached to the deleted feature. (num. element,feature_id) =', 'Review your data. The deleted feature can''t have any elements attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2015, 'There is no state-1 feature as endpoint of link. It is impossible to create it', 'Try to connect the link to one arc / node / connec / gully or vnode with state=1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2032, 'Please, fill the node catalog value or configure it with the value default parameter', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1083, 'Please configure your own psector vdefault variable', 'To work with planified elements it is mandatory to have always defined the work psector using the psector vdefault variable', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1008, 'There are no sectors defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2042, 'Dma is not into the defined exploitation. Please review your data', 'The element must be inside the dma which is related to the defined exploitation', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1096, 'Node with state 2 over another node with state=2 on same alternative it is not allowed. The node is:', 'Review your project data.It''s not possible to have more than one nodes with the same state at the same position.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3022, 'The inserted value is not present in a catalog. Catalog, field:', 'Add it to the corresponding typevalue table in order to use it.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1044, 'Exists one o more connecs closer than configured minimum distance, connec_id:', 'Check your project or modify the configuration properties (config.connec_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3036, 'Selected state type doesn''t correspond with state', 'Modify the value of state or state type.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3048, 'Flow length is longer than length of exit arc feature', 'Please review your project!', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1098, 'It''s not allowe to have node with state(1) or(2) over one existing node with state(1).', 'Use the button replace node. It''s not possible to have more than one nodes with the same state at the same position', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3034, 'Inventory state and state type of planified features has been updated', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3066, 'The dma and period don''t exists yet on dma-period table (ext_rtc_scada_dma_period). It means there are no values for that dma or for that CRM period into GIS', 'Please check it before continue.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3046, 'Selected node type doesn''t divide arc. Node type: ', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1097, 'It is not allowed to insert/update one node with state(1) over another one with state (1) also. The node is:', 'Please ckeck it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3070, 'Link needs one connec/gully feature as start point. Geometry have been checked and there is no connec/gully feature as start/end point', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3050, 'It is not possible to relate connects with state=1 to arcs with state=2', 'Please check your map', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1012, 'There is no dma defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1064, 'There is at least one link attached to the deleted feature. (num. link,feature_id) =', 'Review your data. The deleted feature can''t have any links attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1016, 'It''s impossible to change node catalog', 'The new node catalog doesn''t belong to the same type as the old node catalog (node_type.type) ', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1104, 'Update is not allowed ...', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1080, 'You don''t have permissions to manage with psector', 'Please check if your profile has role_master in order to manage with plan issues', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2068, 'The provided node_id don''t exists as a ''WWTP'' (system type)', 'Please look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2028, 'The feature does not have state(1) value to be replaced, state = ', 'The feature must have state 1 to be replaced', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1100, 'It is not allowed to insert/update one node with state (2) over another one with state (2). The node is:', 'Review your data. It''s not possible to have more than one node with the same state at the same position.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3068, 'The dma/period defined on the dma-period table (ext_rtc_scada_dma_period) has a pattern_id defined', 'Please check it before continue.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3032, 'Can''t apply the foreign key', 'there are values already inserted that are not present in the catalog', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1081, 'There are not psectors defined on the project', 'You need to have at least one psector created to add planified elements', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3062, 'Selected gratecat_id has NULL width or length. Gratecat_id:', 'Check grate catalog or your custom config values before continue', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2094, 'Please, assign one connec to relate this polygon geometry', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2098, 'The provided connec_id doesn''t exist as a ''FOUNTAIN'' (system type)', 'Look for another connec', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3084, 'It is not enabled to insert vnodes. if you are looking to join links you can use vconnec to join it', 'You can create vconnec feature and simbolyze it as vnodes. By using vconnec as vnodes you will have all features in terms of propagation of arc_id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2016, 'It''s not enabled to modify the start/end point of link', 'If you want to reconnect the features, delete this link and draw a new one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1010, 'Feature is out of sector, feature_id:', 'Take a look on your map and use the approach of the sectors!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1068, 'There is at least one gully attached to the deleted feature. (num. gully,feature_id)=', 'Review your data. The deleted feature can''t have any gullies attached.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1028, 'Delete arcs from this table is not allowed', 'To delete arcs, use layer arc in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3052, 'Connect2network tool is not enabled for connec''s with state=2. Connec_id:', 'For planned connec''s you must create the link manually (one link for each alternative and one connec) by using the psector form and relate the connec using the arc_id field. After that you will be able to customize the link''s geometry.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3058, 'It is impossible to validate the connec without assigning value of connecat_id. Connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3026, 'Can''t delete the class. There is at least one visit related to it', 'The class will be set to unactive.', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1022, 'There are no connec catalog values defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1054, 'It''is impossible to divide an arc with state=(1) using a node with state=(2)', 'To divide an arc, the state of the used node has to be 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3078, 'It is not possible to create the link. On inventory mode only one link is enabled for each gully. Gully_id:', 'On planning mode it is possible to create more than one link, one for each alternative, but it is mandatory to use the psector form and relate gully using arc_id field. After that you will be able to customize the link''s geometry.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1050, 'It''s impossible to divide an arc with state=(0)', 'To divide an arc, the state has to be 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2002, 'Node not found', 'Please check table node', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1066, 'There is at least one connec attached to the deleted feature. (num. connec,feature_id) =', 'Review your data. The deleted feature can''t have any connecs attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1094, 'Your catalog is different than node type', 'You must use a node type defined in node catalogs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3072, 'It is not possible to connect link closer than 0.25 meters from nod2arc features in order to prevent conflits if this node may be a nod2arc', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2024, 'Feature is out of any municipality,feature_id:', 'Please review your data', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1078, 'Before downgrading the gully to state 0, disconnect the associated features, gully_id: ', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1070, 'The feature can''t be replaced, because it''s state is different than 1. State = ', 'To replace a feature, it must have state = 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2048, 'Polygon not related with any gully', 'Insert gully_id in order to assign the polygon geometry to the feature', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1002, 'Test trigger', 'Trigger test', 0, true, 'ws_trg', 'core');
INSERT INTO sys_message VALUES (1076, 'Before downgrading the connec to state 0, disconnect the associated features, connec_id: ', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (-1, 'Uncatched error', 'Open PotgreSQL log file to get more details', 2, true, 'generic', 'core');
INSERT INTO sys_message VALUES (2096, 'It is not possible to relate this geometry to any connec.', 'The connec must be type ''FOUNTAIN'' (system type).', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1052, 'It''s impossible to divide an arc using node that has state=(0)', 'To divide an arc, the state of the node has to be 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2050, 'The provided gully_id doesn''t exist.', 'Look for another gully_id', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1024, 'There are no grate catalog values defined in the model', 'Define at least one', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1004, 'There are no node types defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3094, 'One of new arcs has no length', 'The selected node may be its final.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3096, 'If widgettype=typeahead, isautoupdate must be FALSE', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1026, 'Insert new arc in this table is not allowed', 'To insert new arc, use layer arc in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3098, 'If widgettype=typeahead and dv_querytext_filterc is not null dv_parent_id must be combo', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1042, 'One or more arcs was not inserted/updated because it has not start/end node. Arc_id:', 'Check your project or modify the configuration properties.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2066, 'The provided node_id don''t exists as a ''CHAMBER'' (system type)', 'Please look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1090, 'You must choose a node catalog value for this feature', 'Nodecat_id is required. Fill the table cat_node or use a default value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2010, 'There are no values on the cat_element table.', 'Elementcat_id is required. Insert values into cat_element table or use a default value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3100, 'If widgettype=typeahead, id and idval for dv_querytext expression must be the same field', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2088, 'There are [units] values nulls or not defined on price_value_unit table  =', 'Please fill it before to continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3102, 'If dv_querytext_filterc is not null dv_parent_id is mandatory', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3104, 'When dv_querytext_filterc, dv_parent_id must be a valid column for this form. Please check form because there is not column_id with this name', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3106, 'There is no presszone defined in the model', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3108, 'Feature is out of any presszone, feature_id:', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3028, 'Can''t modify typevalue:', 'It''s impossible to change system values.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2004, 'It is impossible to use the node to fusion two arcs', 'Pipes have different types', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3016, 'New field overlaps the existing one', 'Modify the order value.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3044, 'Can''t detect any arc to divide.', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3030, 'Can''t delete typevalue:', 'It''s being used in a table.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3024, 'Can''t delete the parameter. There is at least one event related to it', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3040, 'User with this name already exists', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3064, 'There is a pattern with same name on inp_pattern table', 'Please check before continue.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3038, 'Inserted value has unaccepted characters:', 'Don''t use accents, dots or dashes in the id and child view name', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1018, 'There are no arc types defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3110, 'There is no municipality defined in the model', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2006, 'It is impossible to use the node to fusion two arcs', 'Node doesn''t have 2 arcs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3056, 'It is impossible to validate the arc without assigning value of arccat_id. Arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3060, 'It is impossible to validate the node without assigning value of nodecat_id. Node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1034, 'Insert a new valve in this table is not allowed', 'To insert a new valve, use layer ndoe in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2008, 'Arc not found', 'Please check table arc', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1102, 'Insert is not allowed. There is no hydrometer_id on ...', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1032, 'Delete nodes from this table is not allowed', 'To delete nodes, use layer node in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1106, 'Delete is not allowed. There is hydrometer_id on ...', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1084, 'Nonexistent node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1082, 'Nonexistent arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2034, 'Your catalog is different than node type', 'Your data must be in the node catalog too', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1072, 'Before downgrading the node to state 0, disconnect the associated features, node_id: ', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1038, 'Delete valves from this table is not allowed', 'To delete valves, use layer node in INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2038, 'The exit arc must be reversed. Arc =', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2022, '(arc_id, geom type) =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1074, 'Before downgrading the arc to state 0, disconnect the associated features, arc_id: ', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2100, 'It is not possible to relate this geometry to any node.', 'The node must be type ''REGISTER'' (system type).', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2104, 'The provided node_id doesn''t exist as a ''REGISTER'' (system type)', 'Look for another node', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2012, 'Feature is out of exploitation, feature_id:', 'Take a look on your map and use the approach of the exploitations!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2102, 'It is not possible to relate this geometry to any node.', 'The node must be type ''TANK'' (system type).', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2014, 'You need to connec the link to one connec/gully', 'Links must be connected to ohter elements', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1048, 'Elev is not an updatable column', 'Please use top_elev or ymax to modify this value', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2026, 'There are conflicts against another planified mincut.', 'Please review your data', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3132, 'Schema defined does not exists. Check your qgis project variable gwAddSchema', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2092, 'There are null values on the [price] column of csv', 'Please check it before continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2080, 'The x value is too large. The total length of the line is ', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2040, 'Reduced geometry is not a Linestring, (arc_id,geom type)=', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2086, 'There are null values on the [id] column of csv. Check it', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2082, 'The extension does not exists. Extension =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2106, 'The provided node_id doesn''t exist as a ''TANK'' (system type)', 'Look for another node', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2076, 'Flow length is longer than length of exit arc feature', 'Please review your project', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2084, 'The module does not exists. Module =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2074, 'You must define the length of the flow regulator', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3080, 'It''s not possible to relate connec with state=2 over feature with state=1. Connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2120, 'There is an inconsistency between node and arc state', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2108, 'There is at least one node attached to the deleted feature. (num. node,feature_id)=', 'Review your data. The deleted feature can''t have any nodes attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2110, 'Define at least one value of state_type with state=0', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2122, 'Arc not found on insertion process', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3074, 'It is mandatory to connect as init point one connec or gully with link', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3088, 'It is not enabled to delete vnodes', 'Vnode will be automaticly deleted when link connected to vnode disappears', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2036, 'It is impossible to validate the arc without assigning value of arccat_id, arc_id:', 'Please assign an arccat_id value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2070, 'You need to set a value of to_arc column before continue', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2064, 'The provided node_id doesn''t exist as a ''STORAGE'' (system type)', 'Look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2060, 'It is not possible to relate this geometry to any node.', 'The node must be type ''WWTP'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3092, 'Only arc is available as input feature to execute mincut', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2054, 'It is not possible to relate this geometry to any node.', 'The node must be type ''NETGULLY'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1020, 'There are no arc catalog values defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2052, 'Polygon not related with any node', 'Insert node_id in order to assign the polygon geometry to the feature', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1006, 'There are no node catalog values defined in the model', 'Define at least one', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2072, 'You need to set to_arc/node_id values with topologic coherency', 'Node_id must be the node_1 of the exit arc feature', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1046, 'Exists one o more nodes closer than configured minimum distance, node_id: ', 'Check your project or modify the configuration properties (config.node_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2046, 'State type is not a value of the defined state. Please review your data', 'State type must be related to states', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3086, 'It is not enabled to update vnodes', 'If you are looking to update endpoint of links use the link''s layer to do it', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2062, 'The provided node_id doesn''t exist as a ''NETGULLY'' (system type)', 'Look for another node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2058, 'It is not possible to relate this geometry to any node.', 'The node must be type ''CHAMBER'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2020, 'One or more vnodes are closer than configured minimum distance', 'Check your project or modify the configuration properties (config.node_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2030, 'The feature not have state(2) value to be replaced, state = ', 'The feature must have state 2 to be replaced', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1092, 'Your default value catalog is not enabled using the node type choosed', 'You must use a node type defined in node catalogs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2056, 'It is not possible to relate this geometry to any node.', 'The node must be type ''STORAGE'' (system type).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1036, 'There are columns in this table not allowed to edit', 'Try to update open, accesibility, broken, mincut_anl or hydraulic_anl', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1086, 'You must choose a connec catalog value for this feature', 'Connecat_id is required. Fill the table cat_connec or use a default value', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1040, 'One or more arcs has the same node as Node1 and Node2. Node_id:', 'Check your project or modify the configuration properties', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1088, 'Connec catalog is different than connec type', 'Use a connec type defined in connec catalogs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2018, 'At least one of the extremal nodes of the arc is not present on the alternative updated. The planified network has losed the topology', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1030, 'Insert a new node in this table is not allowed', 'To insert new node, use layer node INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2044, 'Presszone is not into the defined exploitation. Please review your data', 'The element must be inside the press zone which is related to the defined exploitation', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2090, 'There are null [descript] values on the imported csv', 'Please complete it before to continue', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1062, 'There is at least one visit attached to the deleted feature. (num. visit,feature_id) =', 'Review your data. The deleted feature can''t have any visits attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3010, 'The minimum arc length of this exportation is: ', 'This length is less than nod2arc parameter. You need to update config.node2arc parameter to value less than it.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3054, 'Connect2network tool is not enabled for gullies with state=2. Gully_id:', 'For planned gullies you must create the link manually (one link for each alternative and one gully) by using the psector form and relate the gully using the arc_id field. After that you will be able to customize the link''s geometry.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3174, 'No valve has been choosen', 'You can continue by clicking on more valves or finish the process by clicking again on Change Valve Status', 0, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3176, 'Change valve status done successfully', 'You can continue by clicking on more valves or finish the process by executing Refresh Mincut', 0, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3184, 'There is at least one hydrometer related to the feature', 'Connec with state=0 can''t have any hydrometers state=1 attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3186, 'Workspace is being used by some user and can not be deleted', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3188, 'Workspace name already exists', 'Please set a new one or delete existing workspace', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3190, 'There are no nodes defined as arcs finals', 'First insert csv file with nodes definition', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3192, 'It is not possible to connect on service arc with a planified node', 'Reconnect arc with node state 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3194, 'The value can not be inserted', 'It is not present on a table', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3196, 'Shortcut key is already defined for another feature', 'Change it before uploading configuration', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3090, 'Please enter a valid graphClass', 'None', 2, true, 'ws', 'core');
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
INSERT INTO sys_message VALUES (3082, 'It''s not possible to relate connec over other connec or node while working with alternatives on planning mode. Only arcs are avaliable', 'You can''t have two links related to the same feature (connec/gully) in one psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3206, 'This gully has an associated link', 'Remove the associated link and arc_id field will be set to null', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3214, 'It''s impossible to downgrade the state of a planned gully', 'To unlink it from psector remove row or delete gully', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3216, 'It''s impossible to update arc_id from psector dialog because this planned link has not arc as exit-type', 'Use gully dialog to update it', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3228, 'It is not possible to insert arc into psector because has operative connects associated', 'You need to previously insert related connects into psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3164, 'Arc have incorrectly defined final nodes in this plan alternative', 'Make sure that arcs finales are on service or check by using toolbox function Check plan data (fid= 355)', 2, true, 'utils', 'core');


--
-- Data for Name: cat_feature; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature VALUES ('CONNEXION', 'CONNEC', 'CONNEC', NULL, 'v_edit_connec', 've_connec_connexion', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CONDUIT', 'CONDUIT', 'ARC', 'D', 'v_edit_arc', 've_arc_conduit', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('POMPE_TUYAU', 'CONDUIT', 'ARC', NULL, 'v_edit_arc', 've_arc_pompe_tuyau', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('POINTHAUT', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_pointhaut', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('COMPTEUR', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_compteur', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CHANGE', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_change', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('NOEUD_VIRTUEL', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_noeud_virtuel', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CHUTE', 'OUTFALL', 'NODE', NULL, 'v_edit_node', 've_node_chute', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('JONCTION', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_jonction', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('DEVERSOIR', 'GULLY', 'GULLY', NULL, 'v_edit_gully', 've_gully_deversoir', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('POLYGON_CANIVEAU', 'GULLY', 'GULLY', NULL, 'v_edit_gully', 've_gully_polygon_caniveau', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('SIPHON', 'SIPHON', 'ARC', 'S', 'v_edit_arc', 've_arc_siphon', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ACCELERATEUR_EAU', 'WACCEL', 'ARC', NULL, 'v_edit_arc', 've_arc_accelerateur_eau', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ARC_VIRTUEL', 'VARC', 'ARC', NULL, 'v_edit_arc', 've_arc_arc_virtuel', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('REGARD_CIRC', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_regard_circ', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('SAUT', 'WJUMP', 'NODE', NULL, 'v_edit_node', 've_node_saut', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('REGARD_RECT', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_regard_rect', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('SANDBOX', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_sandbox', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('USINE_RETRAITEMENT', 'WWTP', 'NODE', NULL, 'v_edit_node', 've_node_usine_retraitement', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('VALVE', 'VALVE', 'NODE', 'Alt+V', 'v_edit_node', 've_node_valve', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CANIVEAU_TOPO', 'NETGULLY', 'NODE', NULL, 'v_edit_node', 've_node_caniveau_topo', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ELEMENT_RESEAU', 'NETELEMENT', 'NODE', NULL, 'v_edit_node', 've_node_element_reseau', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('INIT_RESEAU', 'NETINIT', 'NODE', NULL, 'v_edit_node', 've_node_init_reseau', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CHAMBRE', 'CHAMBER', 'NODE', NULL, 'v_edit_node', 've_node_chambre', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('SEUIL', 'CHAMBER', 'NODE', NULL, 'v_edit_node', 've_node_seuil', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('BASSIN_RETENTION', 'STORAGE', 'NODE', NULL, 'v_edit_node', 've_node_bassin_retention', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('BASSIN_DEBORDEMENT', 'STORAGE', 'NODE', NULL, 'v_edit_node', 've_node_bassin_debordement', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('STATION_POMPAGE', 'CHAMBER', 'NODE', NULL, 'v_edit_node', 've_node_station_pompage', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 'v_edit_link', 'Link', NULL, true, false, NULL);


--
-- Data for Name: element_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO element_type VALUES ('COVER', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PORTE', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('CAPTEUR_IOT', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('POMPE', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('ETAPE', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PROTECTION', true, true, NULL, NULL);


