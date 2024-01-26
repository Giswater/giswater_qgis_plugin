/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Data for Name: value_state; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state VALUES (0, 'OBSOLET', NULL);
INSERT INTO value_state VALUES (2, 'PLANIFICAT', NULL);
INSERT INTO value_state VALUES (1, 'OPERATIU', NULL);


--
-- Data for Name: value_state_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state_type VALUES (3, 2, 'PLANIFICAT', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUIR', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISIONAL', false, true);
INSERT INTO value_state_type VALUES (99, 2, 'FICTICIUS', true, false);
INSERT INTO value_state_type VALUES (1, 0, 'OBSOLET', false, false);
INSERT INTO value_state_type VALUES (2, 1, 'OPERATIU', true, true);


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
INSERT INTO edit_typevalue VALUES ('value_verified', 'PER REVISAR', 'PER REVISAR', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_verified', 'VERIFICAT', 'VERIFICAT', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '0', 'Sense canvis', 'No hi ha canvis per sobre o sota dels llindars de tolerancia', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '1', 'Nou element', 'Nou element introduit per revisar', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '2', 'Geometria modificada', 'Geometria modificada en la revisió. Altre dates es poden haber modificat', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '3', 'Dades modificades', 'Cavis en les dades, no en la geometria', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '0', 'Rebutjat', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '1', 'Aceptat', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '2', 'A revisar', NULL, NULL);
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
INSERT INTO om_typevalue VALUES ('visit_status', '1', 'Iniciada', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '2', 'Stand-by', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '3', 'Cancelada', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_status', '4', 'Finalitzada', NULL, NULL);
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
INSERT INTO om_typevalue VALUES ('visit_param_type', 'INSPECCIO', 'INSPECCIO', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'DESPERFECTES', 'DESPERFECTES', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'RECONSTRUIR', 'RECONSTRUIR', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'ALTRES', 'ALTRES', NULL, '{"go2plan":false}');


--
-- Data for Name: doc_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO doc_type VALUES ('AS_BUILT', NULL);
INSERT INTO doc_type VALUES ('INCIDENT', NULL);
INSERT INTO doc_type VALUES ('RELACIO DE TREBALL', NULL);
INSERT INTO doc_type VALUES ('ALTRES', NULL);
INSERT INTO doc_type VALUES ('FOTO', NULL);


--
-- Data for Name: plan_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO plan_typevalue VALUES ('psector_status', '2', 'PLANIFICAT', 'Psector planificat', NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '1', 'PRIORITAT ALTA', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '2', 'PRIORITAT NORMAL', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '3', 'PRIORITAT BAIXA', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_type', '1', 'Planificat', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '1', 'Reconstrucció', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '2', 'Rehabilitació', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm3', 'm3', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm2', 'm2', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'm', 'm', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'pa', 'pa', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'u', 'u', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 'kg', 'kg', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('price_units', 't', 't', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '0', 'EXECUTED (Save Trace)', 'Psector executed. Its elements are copied to traceability tables', NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '1', 'ONGOING (Keep Plan)', 'Psector en curs', NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '3', 'CANCELED (Save Trace)', 'Psector canceled. Its elements are copied to traceability tables', NULL);
INSERT INTO plan_typevalue VALUES ('psector_status', '4', 'EXECUTED (Set OPERATIVE and Save Trace)', 'Psector executed. Its elements are set to On Service and also copied to traceability tables', NULL);


--
-- Data for Name: config_csv; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO config_csv VALUES (408, 'Import istram nodes', NULL, 'gw_fct_import_istram', false, 10, '{"query": "SELECT node_id, top_elev, sys_elev FROM v_edit_node ", "layerName":"Nodes", "group": "ISTRAM"}');
INSERT INTO config_csv VALUES (234, 'Importar preus a la base de dades', 'El fitxer csv ha de tenir aquestes columnes per ordre: id, unit, descript, text, price.
- La columna price ha de ser tipus numero amb dos decimals.
- Pots triar un cataleg per els preus importats assignant-lo a Import label.
- Atencio: el fitxer csv ha de tenir una fila inicial amb els noms de columna', 'gw_fct_import_dbprices', true, 1, NULL);
INSERT INTO config_csv VALUES (238, 'Import om visit', 'To use this import csv function parameter you need to configure before execute it the system parameter ''utils_csv2pg_om_visit_parameters''. 
Also whe recommend to read before the annotations inside the function to work as well as posible with', 'gw_fct_import_omvisit', true, 5, NULL);
INSERT INTO config_csv VALUES (236, 'Importar camps addicionals', 'The csv file must containts next columns on same position: 
feature_id (can be arc, node or connec), parameter_id (choose from sys_addfields), value_param. ', 'gw_fct_import_addfields', true, 3, NULL);
INSERT INTO config_csv VALUES (235, 'Importar elements', 'The csv file must containts next columns on same position:
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

INSERT INTO sys_message VALUES (2080, 'El valor de x es massa garn. La longitud total de la línea és', 'None', 2, true, 'utils', 'core');
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
INSERT INTO sys_message VALUES (3174, 'No valve has been choosen', 'You can continue by clicking on more valves or finish the process by clicking again on Change Valve Status', 0, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3176, 'Change valve status done successfully', 'You can continue by clicking on more valves or finish the process by executing Refresh Mincut', 0, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1014, 'La funció està fora de dma, feature_id:', 'Miri el mapa i utilitzi l''aproximació dma', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1060, 'Hi ha al menys un document adjunt a la funció eliminada. (num. document,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap document adjunt.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1110, 'No hi ha explotacions definidas en el model', 'Defineix el menys un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3042, 'L''arc amb l''estat 2 no pot ser dividid pel node amb l''estat 1.', 'Per a dividr en arc, l''estat del node ha de ser el mateix', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1056, 'Hi ha al menys un arc adjunt a la funció eliminada. (num. arc,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap arc adjunt.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1058, 'Hi ha al menys un element adjunt a la funció eliminada. (num. element,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap element  adjunt.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2015, 'No hi ha una funció de estat-1 com punt final de conecció. És impossible crear-lo', 'Intenti conectar l''enllaç a un arc / node / escomesa / embornal o vnode amb estat=1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2032, 'Completi el valor del catàlag de nodes o configúral amb el paràmetre predeterminat del valor', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1083, 'Si us plau configuri la seva propia variable psector vdefault', 'Per a treballa amb element planificats és obligatori tenir sempre definit el psector de treball utilitzant la variable psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1008, 'No hi ha sectors definits en el model', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2042, 'Dma no està en la explotació definida. Si su plau revisi les seves dades', 'L''element ha d''estar dintre del dma que està relacionat amb l''explotació definida', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3018, 'El còdig de client està duplicat per a escomeses amb estat=1', 'Revisi les seves dades.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1096, 'Node amb estat 2 a sobre d''un altre node amb estat=2 en la mateixa alternativa no està permès. El node és :', 'Revisi les dades del seu projecte. No és possible tenir més d''un node amb el mateix estat en la mateixa posició', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3022, 'El valor instertat no està permès en el catàlag. Catalog, field:', 'Agréguuili a la taula typevalue correcpondent per a poder utilitzar-la.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1044, 'Existeixen una o més conexions més properes que la distancia mínima configurada, conneec_id:', 'Verifiqui el seu projecte o modifiqui les propietats de configuració', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3036, 'El tipus d''estat seleccionat no es pot correspondre amb l''estat', 'Modifiqui el valor d''estat o tipus d''estat.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3048, 'La longitud del fluxe es major que la longitud de l''arc de sortida de l''element de xarxa', '¡Si us plau revisi el seu projecte!', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1098, 'No està permès tenir un node amb l''estat (1) o (2) a sobred''un altre amb estat (2). El node és:', 'Utilitzi el botó reemplaçar node. No és possible tenir més d''un node definit en el mateixa posició', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3034, 'S''ha actualitzat l''estat de l''inventari i el tipus d''estat dels elements de xarxa planificats', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3066, 'El dma i el periode encara no existeixen en la taula dma-period (ext_rct_scada_dma_period). Significa que no hi ha valors per a aquell dma o  per a aquell periode de CRM en el SIG', 'Si us plau verifiqi abans de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3046, 'el tipus de node seleccionat no divideix l''arc. Tipus de node:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1097, 'No està permès insertar / actualitzar un node amb l''estat (1) sobre un altre amb l''estat (1) també. El node és:', 'Si us plau comprovi-ho', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3070, 'L''enllaç necessita un element de xarxa per escomesa/embornal com unpunt de partida. S''ha comprovat que la geometria i no hi ha cap element de xarxa de escomesa/embornal com un punt inicial/final', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3050, 'No es possible relacionar a escomeses amb estat=1 amb arcs amb estat=2', '¡Si us plau revisi el seu mapa!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1012, 'No hi ha dma definit en el model', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1064, 'Hi ha al menys un link adjunt a la funció eliminada. (num. link,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap enllaç adjunt.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1016, 'És impossible canviar el catàlag de nodes', 'El nou catàlag de nodes no pertany a l''antic catàlag de nodes (node_type.type)', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1104, 'La actualització no està permesa', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1080, 'No tens permisos per a administrar amb psector', 'Si us plau comprovi si el seu perfil té role_master per a poder gestionar els problemes de plan', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2068, 'El node_id proporcionat no existeix com ''WWTP''  (tipus de sistema)', 'Si us plau, busqui un altre node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2028, 'La caractarística no té un valor d''estat(1) per a ser reemplaçada, estat =', 'La característica ha de tenir l''estat 1 per a ser reemplaçada', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1100, 'No està permès insetar /actualitzar un node amb estat (2) a sobre d''un altre amb estat (2). El node és :', 'Revisi les seves dades. No és possible tenir més d''un node amb el mateix estat en la mateixa posició.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3068, 'El dma/period definit en la taula dma-period (ext_rct_scada_dma_period) tenen un patern_id definit', 'Si us plau verifiqui abans de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3032, 'No es pot aplicar la clau forana', 'Ja hi ha valors ensertats que no estan presents', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1081, 'No hi ha psectors definits en el projecte', 'Necessita almenys un psector creat per a afegir elements planificats', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3062, 'El grillat_id seleccionat té una amplda o llargada NULL. Gratecat_id:', 'Verifiqui el catàlag de reixes o els seus valors de configuració personalitzats abans de continuar', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2094, 'Si us plau, assigni un connec per a relacionar aquest polígon geomètric', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2098, 'El connec_id facilitat no existetix com ''FOUNTAIN'' (tipus de sisitema)', 'Busqui una altre escomesa', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3084, 'No està habilitat per a insertar vnode. Si està  busccand unir enllaços, el pot unir utilitzant vconnec per a unir-los', 'Pot crear l''element de xarxa vconnec i simbolitzar-la com vnodes. Al utilitzar vconnec com vnodes, tindrà tots els elements de xarxa en terminis de programació d''arc_id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2016, 'No està habilitat per a modificar el punt inici/final de l''enllaç', 'Si vol tornar a conectar les funcions, elimini aquest enllaç i dibuixi un nou', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1010, 'La funció està fora del sector, feature_id:', 'Miri el mapa i utilitzi l''aproximació dels sectors', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1068, 'Hi ha al menys un gully adjunt a la funció eliminada. (num. gully,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap embornal adjunt.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1028, 'Eliminar arcs d''aquesta taula no està permès', 'Per eliminar un nou arc, utilitzi la capa arc en INVENTARI', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3052, 'L''eina Connect2network no està habilitada per a escomeses amb estat=2. Connec_id:', 'Per a les escomeses planificades, s''ha de crear l''enllaç manualment (un enllaç per a cada alternativa i una escomese) utilitzant el formulari psector i relacionant l''escomesa utilitzant el cap arc_id. Després d''aixó, podràs personalitzar la geometria de l''enllaç', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3058, 'És impossible vailidar l''escomesa sense assignar el valor de conncat_id . Connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3026, 'No es pot eliminar la classe. Hi ha al menys una visita relacionada.', 'La classe s''establirà com a inactiva.', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1022, 'Noi hi ha valors de catàlag de conexió definits en el model', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1054, 'És impossible dividir un arc amb estat=(1) utilitzant un node amb estat=(2)', 'Per a dividir un arc, l''estat del node utilitzat ha de ser 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3078, 'No és possible crear l''enllaç. En el mode inventari, només s''habilita un enllaç per a cada escomesa. Gully_id:', 'En el node de planificació és impossible crear més d''un enllaç, un per a cada alternativa, però és obligatori utilitzar el formulari psector i relacionar l''escomesa utilitzant el camp arc_id. Després d''això, podrà personalitzar la geometria de l''enllaç.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1050, 'És impossible dividir un arc amb estat=(0)', 'Per a dividir un arc, l''estat ha de ser 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2002, 'Node no trobat', 'Si us plau verifiqui la taula del node', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1066, 'Hi ha al menys un connec adjunt a la funció eliminada. (num. connec,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap escomesa adjunta.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3072, 'NBo és possible conectar l''enllaç a menys de 0,25 metres dels elements de xarxa nod2arc per a evitar conflictes si aquest node és un nod2arc ', 'Si us plau verifiqui abans de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2024, 'La funció està fora de qualsevol municipi, feature_id', 'Si us plau revisi les seves dades', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1078, 'Abans de degradar el gully a l''estat 0, desconecti les funcions associades, gully_id:', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1070, 'Les caractarístiques no es poden reemplaçar, perquè el seu estat és diferent a 1. Estat =', 'Per a reemplaçar una caractarística, ha de tenir un estat = 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2048, 'Polígon no relacionat amb cap gully', 'Insereixi gully_id per a assignar la geometyria del polígon a l''entitat', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1002, 'Prova de trigger', 'Prova de trigger', 0, true, 'ws_trg', 'core');
INSERT INTO sys_message VALUES (1076, 'Abans de degradar la conecció a l''estat 0, desconecti les característiques associades, connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (-1, 'Error no capturat', 'Obri l''arxiu de registre PostgreSQL per obtenbir més detalls', 2, true, 'generic', 'core');
INSERT INTO sys_message VALUES (2096, 'No és possible relacionar aquesat geometría amb cap connec', 'L''escomesa ha de ser del tipus ''FOUNTAIN'' (tipus de sistema)', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1052, 'És impossible dividir un arc utilitzant un node que té un estat=(0)', 'Per dividir u arc, l''estat del node ha de ser 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2050, 'El gully_id proporcionat no existeix', 'Busqui un altre gully_id', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1024, 'No hi ha valors de catàlag de reixeta definits en el model', 'Definir com a mínim un', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1004, 'No hi ha tipus de nodes definits en el model', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3094, 'One of new arcs has no length', 'The selected node may be its final.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3096, 'If widgettype=typeahead, isautoupdate must be FALSE', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1026, 'Insertar un nou arc en aquesta taula no està permès', 'Per insertar un nou arc, utilitzi la capa arc en INVENTARI', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3098, 'If widgettype=typeahead and dv_querytext_filterc is not null dv_parent_id must be combo', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1042, 'Un o més arcs no es van insertar/actualitzar perquè no tenen un node inicial/final. Arc_id:', 'Verifiqui el seu projecte o modifiqui les propietats de configuració', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2066, 'El node_id proporcionat no existeix com ''CHAMBER'' (tipo de sistema)', 'Si us plau, busqui un altre node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1090, 'Ha de triar un valor de catàlag de nodes per a aquesta característica', 'Nodecat_id és obligatori. Ompli la taula cat_node o utilitzi un valor predeterminat', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2010, 'No hi ha valors en la taula cat_element', 'Es requereix qeu elementcat_id insereixi valors a la taula cat_elemt o utilitzi un valor predeterminat', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3100, 'If widgettype=typeahead, id and idval for dv_querytext expression must be the same field', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2088, 'Hi ha [unitats] vlaros nuls o no definits en la taula price_value_unit =', 'Si us plau ompli abans de continuar', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3102, 'If dv_querytext_filterc is not null dv_parent_id is mandatory', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3104, 'When dv_querytext_filterc, dv_parent_id must be a valid column for this form. Please check form because there is not column_id with this name', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3106, 'There is no presszone defined in the model', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3108, 'Feature is out of any presszone, feature_id:', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3028, 'No es pot modificar typevalue:', 'És impossible canviar els valors del sistema.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2004, 'És impossible utilitzar el node per a fusionar dos arcs', 'Les canonades tenen diferents tipus.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3016, 'El nou camp es sobreposa al existent', 'Modifiqui el valor de la comanda.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3044, 'No es pot detectar cap arc per a dividir.', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3030, 'No es pot eliminar typevalue:', 'S''està utilitzant en una taula.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3024, 'No es pot eliminar el paràmetre. Hi ha al menys un event relacionat amb ell.', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3040, 'L''usuari amnb aquest nom ja existeix', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3064, 'Hi ha un patró amb el mateix nom en la taula inp_pattern', 'Si us plau verifiqui abans de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3038, 'El valor insertat té caràcters no acceptats:', 'No utuilitzi accents, punts o guions en la idetificació i el nom de la vista child', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1018, 'No hi ha tipus d''arc defnits en el model', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3110, 'There is no municipality defined in the model', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2006, 'És impossible utilitzar el node per a fusionar dos arcs', 'El node no té 2 arcs', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3112, 'No class visit', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3114, 'sucessfully deleted', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3056, 'És impossible vailidar l''arc sense assignar el valor d''arccat _id . Arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3060, 'És impossible vailidar lel node sense assignar el valor de nodecat_id . Node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3116, 'does not exists, impossible to delete it', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1034, 'Insertar una nova vàlvula en aquesta taula no està permès', 'Per insertar una nova vàlvula, utilitzi la capa node en INVENTARI', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2008, 'Arc no trobat', 'Si us plau verifiqui la taula del node', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3118, 'sucessfully inserted', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3120, 'sucessfully updated', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3122, 'Visit class have been changed. Previous data have been deleted', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3124, 'Visit manager have been initialized', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3126, 'Visit manager have been finished', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1102, 'Inserir no estar permès. No hi ha hidrometer_id en...', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1032, 'Eliminar nodes d''aquesta taula no està permès', 'Per eliminar un nou node, utilitzi la capa node en INVENTARI', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1106, 'Eliminar no està permès. Hi ha hidrometer_id a ...', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1084, 'Inexistent node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1082, 'Inexistent arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2034, 'El seu catàlag és diferent al tipus de node', 'Les seves dades també han d''estar en e catàlag de nodes', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1072, 'Abans de degradar el node a l''estat 0, desconecti les característiques associades, node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1038, 'Eliminar vàlvules d''aquesta taula no està permès', 'Para eliminar vàlvules, utilitzi la capa node INVENTARI', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2038, 'L''arc de sortida ha de ser revertit. Arc =', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2022, '(arc_id, geom type) = ', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1074, 'Abans de degardar l''arc a l''estat 0, desconecti les característiques associades, arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2100, 'No és possible relacionar aquesat geometría amb cap node', 'El node ha de ser del tipus ''REGISTER'' (tipus de sistema)', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2104, 'El node_id facilitat no existeix com '' REGISTER''  (tipus de sistema)', 'Busqui un altre node', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2012, 'La caractarística està fora d''explotació, feature_id', 'Miri el mapa i utilitzi l''approximació de les explotacions', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2102, 'No és possible relacionar aquesat geometría amb cap node', 'El node ha de ser del tipus ''TANK'' (tipus de sistema)', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2014, 'Necessita conectar l''enllaç  a un connec/gully', 'Els enllaços han d''estar conectats a altres elements', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1094, 'El seu catàlag és diferent al tipus de node', 'Ha d''usar un tipus de node definit en els catàlags de nodes', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1048, 'Elev no és una columna actualitzable', 'Utilitzi top_elev o ymax per a modificar aquest valor', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3128, 'Lot succesfully saved', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2026, 'Hi ha conflictes contra un altre mincut planejat.', 'Si us plau revisi les seves dades', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3130, 'Lot succesfully deleted', 'None', 0, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3132, 'Schema defined does not exists. Check your qgis project variable gwAddSchema', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2092, 'Hi ha valors nuls en la columne [price] de csv', 'Si us plau revisi abans de continuar', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2040, 'La geometria reduida no és una cadena lineal, (arc_id, geomtype)=', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2086, 'Hi ha valors nuls en la columne [id] de csv. Revise''l', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2082, 'La extensió no existeix. Extension =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2106, 'El node_id proporcionat no existeix com ''TANK'' (tipus de sistema)', 'Busqui un altre node', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2076, 'La longitud del fluxe és major que la longitud de la caractarística de l''arc de sortida', 'Si us plau, revisi el seu projecte ', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2084, 'El mòdul no existeix. Mòdul =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2078, 'Text de la consulta =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2074, 'Ha de definir la longitud del regulador de fluxe', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3080, 'No és possible relacionar escomesa amb estat=2 a sobre l''element de xarxa amb estat=1. Conne_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2120, 'Hi ha una inconsistencia entre els estats d''arc i node', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2108, 'Hi ha al menys un node adjunt a la funció eliminada. (num. node,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap node adjunt.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2110, 'defineix al menys un valor de state_type con state=0', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2122, 'Arc no trobat en el proces de inserció', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3074, 'És obligatori connectar com punt d''inici una escomesa  o embornal amb enllaç', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3088, 'No està habilitat per a actualitzar vnodes', 'Vnode s''eliinarà automàticament quan l?enllaç conectat a vnode desapareixi', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2036, 'És impossible validar l''arc sense assignar el valor de arccat_id, arc_id:', 'Assigni un valor arccat_id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2070, 'Ha d''establir un valor de la columne to_arc abans de continuar', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2064, 'El node_id proporcionat no existeix com ''STORAGE'' (tipus de sistema)', 'Busqui un altre node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2060, 'No és possible relacionar la geometria amb cap node', 'El node ha de ser de tipus ''WWTP'' (tipus de sistema)', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3092, 'Només l''arc està disponible com ha element de xarxa de entrada per a executar el polígon de tall', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2054, 'No és possible relacionar la geometria amb cap node', 'El node ha de ser de tipus ''NETGULLY'' (tipus de sistema)', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1020, 'No hi ha valors de catàlag d''arc definits en el model', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2052, 'Polígon no relacionat amb cap node', 'Insereixi node_id per a assignar la geometyria del polígon a l''entitat', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1006, 'No hi ha valors del catàlag de nodes definits en el model ', 'Definir com a mínim un', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2072, 'Ha d''establir els valors to_arc/node_id amb coherencia topològica', 'Node _id ha de ser el node-1 de la funció d''arc de sortida', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1046, 'Existeixen un o més nodes més aprop que la distancia configurada, node_id:', 'Verifiqui el seu projecte o modifiqui les propietats de configuració', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2046, 'El tipus d''estat no és un valor de l''estat definit. Si us plau revisis les seves dades', 'El tipus d''estat ha d''estat relacionat amb els estats', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3086, 'No està habilitat per a actualitzar vnodes', 'Si està buscant actualitzar el punt final dels enllaços, utilizi la capa de l''enllaç per a fer-ho', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2062, 'El node_id proporcionat no existeix com ''NETGULLY'' (tipus de sistema)', 'Busqui un altre node', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2058, 'No és possible relacionar la geometria amb cap node', 'El node ha de ser de tipus ''CHAMBER'' (tipus de sistema)', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2020, 'Un o més vnodes està més aprop que la distancia mínima configurada', 'Verifiqui el seu projecte o modifiqui les propietats de configuració (config.node_proximity)', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2030, 'Les característiques no tene un valor d''estat (2) per a ser reemplaçat, estat =', 'La caractarística ha de tenir l''estat 2 per a ser reemplaçat', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1092, 'El seu catàlag de valors predeterminats no està habilitat utilitzant el tipus de node seleccionat', 'Ha d''utilitzar un tipus de node definit en els catàlags de nodes', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2056, 'No és possible relacionar la geometria amb cap node', 'El node ha de ser de tipus ''STORAGE'' (tipus de sistema)', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1036, 'Hi ha columnes en aquesta taula que no es poden editar', 'Intenti actualitzar open, accesibility, broken, mincut_anl o hydraulic_anl', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1086, 'Ha de triar un valor de catàlag de conexió per a aquesta funció', ' Es requereix que Connecat_id ompli la taula cat_connec o utilitzi un valor predeterminat', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1040, 'Un o més arcs tenen el mateix node que Node1 i Node2. Node_id', 'Verifiqui el seu projecte o modifiqui les propietats de configuració', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1088, 'El catàlag Connec és diferent al tipus de conecció', 'Utilizi un tipus de conecció definida en els catàlags de conecció', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2018, 'Al menys un dels nodes extrems de l''arc no està present en l''alternativa actualitzada. La red planificada ha  perdut la topologia.', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1030, 'Insertar un nou node en aquesta taula no està permès', 'Per insertar un nou node, utilitzi la capa node en INVENTARI', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2044, 'Presszone no està en l''explotació definida. Si us plau revisi les seves dades', 'L''element ha d''esatr dintre de la zona de pressió relacionada amb l''explotació definida', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2090, 'Hi ha valors [descriptius] nuls en csv importat', 'Si us plau, completi''l abans per a continuar', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1062, 'Hi ha al menys un visit adjunt a la funció eliminada. (num. visit,feature_id) =', 'Revisi les seves dades. L''element  de xarxa eliminat no pot tenir cap visita adjunta.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3010, 'La longitud d''arc mínima d''aquesat exportació és:', 'Aquesta longitud és menor que el paràmetre nod2arc. Ha d''actualiotzar-se el paràmetre config.node2arc per a que tingui un valor menor.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3054, 'L''eina Connect2network no està habilitada per a embornals amb estat=2. Gully_id:', 'Per als embornals planificatd, s''ha de crear l''enllaç manualment (un enllaç per a cada alternativa i un embornal) utilitzant el formulari psector i relacionant l''escomesa utilitzant el cap arc_id. Després d''aixó, podràs personalitzar la geometria de l''enllaç', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3184, 'There is at least one hydrometer related to the feature', 'Connec with state=0 can''t have any hydrometers state=1 attached.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3186, 'Workspace is being used by some user and can not be deleted', NULL, 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3188, 'Workspace name already exists', 'Please set a new one or delete existing workspace', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3190, 'There are no nodes defined as arcs finals', 'First insert csv file with nodes definition', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3192, 'It is not possible to connect on service arc with a planified node', 'Reconnect arc with node state 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3194, 'The value can not be inserted', 'It is not present on a table', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3196, 'Shortcut key is already defined for another feature', 'Change it before uploading configuration', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3090, 'Si us plau ingressi una graphClass vàlida', 'None', 2, true, 'ws', 'core');
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
INSERT INTO sys_message VALUES (3076, 'No és possible crear l''enllaç. En el mode d''inventari, només s''habilita un enllaç per a cada escomesa. Cennec_id:', 'In order to relate link with psector use psector dialog or link2network button. you can''t draw in on link layer', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3082, 'No és possible relacionar escomesa amb una altre escomesa o node mentres es treballa amb alternatives en el mode de planificació. Només els arcs estan disponibles', 'You can''t have two links related to the same feature (connec/gully) in one psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3206, 'This gully has an associated link', 'Remove the associated link and arc_id field will be set to null', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3214, 'It''s impossible to downgrade the state of a planned gully', 'To unlink it from psector remove row or delete gully', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3216, 'It''s impossible to update arc_id from psector dialog because this planned link has not arc as exit-type', 'Use gully dialog to update it', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3228, 'It is not possible to insert arc into psector because has operative connects associated', 'You need to previously insert related connects into psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3164, 'Arc have incorrectly defined final nodes in this plan alternative', 'Make sure that arcs finales are on service or check by using toolbox function Check plan data (fid= 355)', 2, true, 'utils', 'core');


--
-- Data for Name: cat_feature; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature VALUES ('ESCOMESA', 'CONNEC', 'CONNEC', NULL, 'v_edit_connec', 've_connec_escomesa', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('ESCOMESA_FICTICIA', 'CONNEC', 'CONNEC', NULL, 'v_edit_connec', 've_connec_escomesa_ficticia', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CONDUCTE', 'CONDUIT', 'ARC', NULL, 'v_edit_arc', 've_arc_conducte', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('IMPULSIO', 'CONDUIT', 'ARC', NULL, 'v_edit_arc', 've_arc_impulsio', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('PUNT_ALT', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_punt_alt', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('REGISTRE', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_registre', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CANVI_SECCIO', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_canvi_seccio', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('NODE_FICTICI', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_node_fictici', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('DESGUAS', 'OUTFALL', 'NODE', NULL, 'v_edit_node', 've_node_desguas', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('UNIO', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_unio', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('PRESA', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_presa', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('EMBORNAL', 'GULLY', 'GULLY', NULL, 'v_edit_gully', 've_gully_embornal', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('REIXA', 'GULLY', 'GULLY', NULL, 'v_edit_gully', 've_gully_reixa', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('EMBORNAL_FICTICI', 'GULLY', 'GULLY', NULL, 'v_edit_gully', 've_gully_embornal_fictici', NULL, NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('SIFO', 'SIPHON', 'ARC', NULL, 'v_edit_arc', 've_arc_sifo', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('RAPID', 'WACCEL', 'ARC', NULL, 'v_edit_arc', 've_arc_rapid', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('FICTICI', 'VARC', 'ARC', NULL, 'v_edit_arc', 've_arc_fictici', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('POU_CIRCULAR', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_pou_circular', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('SALT', 'WJUMP', 'NODE', NULL, 'v_edit_node', 've_node_salt', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('POU_RECTANGULAR', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_pou_rectangular', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ARQUETA_SORRERA', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_arqueta_sorrera', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('EDAR', 'WWTP', 'NODE', NULL, 'v_edit_node', 've_node_edar', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('VALVULA', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('EMBORNAL_TOPO', 'NETGULLY', 'NODE', NULL, 'v_edit_node', 've_node_embornal_topo', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ELEMENT_TOPO', 'NETELEMENT', 'NODE', NULL, 'v_edit_node', 've_node_element_topo', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('INICI', 'NETINIT', 'NODE', NULL, 'v_edit_node', 've_node_inici', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CAMBRA', 'CHAMBER', 'NODE', NULL, 'v_edit_node', 've_node_cambra', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('DIPOSIT', 'STORAGE', 'NODE', NULL, 'v_edit_node', 've_node_diposit', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('DIPOSIT_DESBORDAMENT', 'STORAGE', 'NODE', NULL, 'v_edit_node', 've_node_diposit_desbordament', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ESTACIO_BOMBAMENT', 'CHAMBER', 'NODE', NULL, 'v_edit_node', 've_node_estacio_bombament', NULL, NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 'v_edit_link', 'Link', NULL, true, false, NULL);


--
-- Data for Name: cat_feature_arc; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_arc VALUES ('CONDUCTE', 'CONDUIT', 'CONDUIT');
INSERT INTO cat_feature_arc VALUES ('IMPULSIO', 'CONDUIT', 'CONDUIT');
INSERT INTO cat_feature_arc VALUES ('SIFO', 'SIPHON', 'CONDUIT');
INSERT INTO cat_feature_arc VALUES ('RAPID', 'WACCEL', 'CONDUIT');
INSERT INTO cat_feature_arc VALUES ('FICTICI', 'VARC', 'OUTLET');


--
-- Data for Name: cat_feature_connec; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_connec VALUES ('ESCOMESA', 'CONNEC', '{"activated":false,"value":1}');
INSERT INTO cat_feature_connec VALUES ('ESCOMESA_FICTICIA', 'CONNEC', '{"activated":false,"value":1}');


--
-- Data for Name: cat_feature_gully; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_gully VALUES ('EMBORNAL', 'GULLY', '{"activated":false,"value":1}', 'GULLY');
INSERT INTO cat_feature_gully VALUES ('REIXA', 'GULLY', '{"activated":false,"value":1}', 'GULLY');
INSERT INTO cat_feature_gully VALUES ('EMBORNAL_FICTICI', 'GULLY', '{"activated":false,"value":1}', 'GULLY');


--
-- Data for Name: cat_feature_node; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_node VALUES ('POU_CIRCULAR', 'MANHOLE', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PUNT_ALT', 'JUNCTION', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('REGISTRE', 'JUNCTION', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CANVI_SECCIO', 'JUNCTION', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('NODE_FICTICI', 'JUNCTION', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('SALT', 'WJUMP', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('POU_RECTANGULAR', 'MANHOLE', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ARQUETA_SORRERA', 'MANHOLE', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('EDAR', 'WWTP', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA', 'VALVE', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('DESGUAS', 'OUTFALL', 'OUTFALL', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('EMBORNAL_TOPO', 'NETGULLY', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('UNIO', 'JUNCTION', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ELEMENT_TOPO', 'NETELEMENT', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('INICI', 'NETINIT', 'JUNCTION', 2, true, true, NULL, 0, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CAMBRA', 'CHAMBER', 'STORAGE', 2, true, true, NULL, 2, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PRESA', 'CHAMBER', 'JUNCTION', 2, true, true, NULL, 2, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('DIPOSIT', 'STORAGE', 'STORAGE', 2, true, true, NULL, 2, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('DIPOSIT_DESBORDAMENT', 'STORAGE', 'STORAGE', 2, true, true, NULL, 2, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ESTACIO_BOMBAMENT', 'CHAMBER', 'STORAGE', 2, true, true, NULL, 2, '{"activated":false,"value":1}');


--
-- Data for Name: element_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO element_type VALUES ('TAPA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('COMPORTA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('SENSOR_IOT', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('BOMBA', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PATE', true, true, NULL, NULL);
INSERT INTO element_type VALUES ('PROTECTOR', true, true, NULL, NULL);


