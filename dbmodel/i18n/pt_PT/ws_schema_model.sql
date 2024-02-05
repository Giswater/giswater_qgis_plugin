/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Data for Name: value_state; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state VALUES (0, 'OBSOLETO', NULL);
INSERT INTO value_state VALUES (1, 'EM SERVICO', NULL);
INSERT INTO value_state VALUES (2, 'PLANIFICADO', NULL);


--
-- Data for Name: value_state_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO value_state_type VALUES (2, 1, 'EM SERVICO', true, true);
INSERT INTO value_state_type VALUES (3, 2, 'PLANIFICADO', true, true);
INSERT INTO value_state_type VALUES (4, 2, 'RECONSTRUIR', true, false);
INSERT INTO value_state_type VALUES (5, 1, 'PROVISORIO', false, true);
INSERT INTO value_state_type VALUES (99, 2, 'FICTICIUS', true, false);
INSERT INTO value_state_type VALUES (1, 0, 'OBSOLETO', false, false);


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
INSERT INTO edit_typevalue VALUES ('value_verified', 'REVER', 'REVER', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_verified', 'VERIFICADO', 'VERIFICADO', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '0', 'Sem alteracoes', 'Nao ha alteracoes acima ou abaixo dos valores de tolerancia', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '1', 'novo elemento', 'Novo elemento inserido na revisao', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '2', 'Geometria modificada', 'Geometria modificada na revisao. Outros dados tambem podem ser modificados', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_status', '3', 'Dados modificados', 'Mudancas nos dados, nao na geometria', NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '0', 'Rejeitado', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '1', 'Aceite', NULL, NULL);
INSERT INTO edit_typevalue VALUES ('value_review_validation', '2', 'Rever', NULL, NULL);
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
INSERT INTO om_typevalue VALUES ('mincut_cause', '1', 'Acidental', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_cause', '2', 'Planejado', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_class', '1', 'Corte na Rede', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_class', '2', 'Corte em Ligacao Predial', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_class', '3', 'Corte em hidrometro', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '1', 'Em Andamento', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '2', 'Finalizado', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '0', 'Planejado', NULL, NULL);
INSERT INTO om_typevalue VALUES ('mincut_state', '3', 'Canceled', NULL, NULL);
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
INSERT INTO om_typevalue VALUES ('mincut_state', '4', 'On planning', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_param_type', 'INSPECAO', 'INSPECAO', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'REHABILITACAO', 'REHABILITACAO', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'RECONSTRUCAO', 'RECONSTRUCAO', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('visit_param_type', 'OUTRO', 'OUTRO', NULL, '{"go2plan":false}');
INSERT INTO om_typevalue VALUES ('waterbalance_method', 'CPW', 'CRM PERIOD WINDOW', NULL, NULL);
INSERT INTO om_typevalue VALUES ('waterbalance_method', 'DCW', 'DMA CENTROID WINDOW', NULL, NULL);


--
-- Data for Name: doc_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO doc_type VALUES ('AS_BUILT', NULL);
INSERT INTO doc_type VALUES ('INCIDENTE', NULL);
INSERT INTO doc_type VALUES ('RELATORIO DE TRABALHO', NULL);
INSERT INTO doc_type VALUES ('OUTRO', NULL);
INSERT INTO doc_type VALUES ('FOTOGRAFIA', NULL);


--
-- Data for Name: plan_typevalue; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO plan_typevalue VALUES ('value_priority', '1', 'ALTA', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '2', 'NORMAL', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('value_priority', '3', 'BAIXA', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('psector_type', '1', 'Planificado', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '1', 'Reconstrucao', NULL, NULL);
INSERT INTO plan_typevalue VALUES ('result_type', '2', 'Rehabilitacao', NULL, NULL);
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
INSERT INTO config_csv VALUES (444, 'Import cat_feature_arc', 'The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active', 'gw_fct_import_cat_feature', true, 12, NULL);
INSERT INTO config_csv VALUES (386, 'Import inp patterns', 'Function to automatize the import of inp patterns files. 
The csv file must containts next columns on same position: 
pattern_id, pattern_type, factor1,.......,factorn. 
For WS use up factor18, repeating rows if you like. 
For UD use up factor24. More than one row for pattern is not allowed', 'gw_fct_import_inp_pattern', true, 9, NULL);
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

INSERT INTO sys_message VALUES (1012, 'Não há dma definida no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
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
INSERT INTO sys_message VALUES (1014, 'O elemento de rede está fora da dma, feature_id:', 'Verifique o seu mapa e use a abordagem do dma', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1060, 'Há pelo menos um documento adjunto ao elemento de rede eliminado.(num. document,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhum documento adjunto.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1110, 'Não há explorações definidas no modelo', 'Defina pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3042, 'O arco com o estado 2 não pode ser dividido pelo nó com o estado 1.', 'Para dividir um arco, o estado do nó deve ser o mesmo', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1056, 'Há pelo menos um arco adjunto ao elemento de rede eliminado. (num. arc,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhum arco adjunto.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1058, 'Há pelo menos um elemento adjunto ao elemento de rede eliminado. (num. element,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhum elemento adjunto.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2015, 'Não há um elemento de rede de estado-1 como ponto final de conexão. É impossível criá-lo', 'Tente conectar a ligação a um arco / nó / conexão / sarjeta ou vnode com estado=1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2032, 'Por favor, preencha o valor do catálogo de nós ou configure-o com o parâmetro padrão do valor', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1083, 'Por favor configure a sua própria variável psector vdefault', 'Para trabalhar com elementos planificados é obrigatório ter sempre definido o psector de trabalho utilizando a variável psector vdefault', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1008, 'Não há setores definidos no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2042, 'A Dma não está na exploração definida. Por favor revise os seus dados', 'O elemento deve estar dentro do dma que está relacionado à exploração definida', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3018, 'O código de cliente está duplicado para conexões com estado=1', 'Reveja os seus dados.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1096, 'Nó com estado 2 sobre outro nó com estado=2 na mesma alternativa não está permitido. O nó é:', 'Reveja os dados do seu projeto. Não é possível ter mais de um nó con o mesmo estado na mesma posição.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3022, 'O valor inserido não está presente num catálogo. Catalog, field:', 'Adicione-o à tabela de valor de tipo correspondente para que possa usá-lo.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1044, 'Existe uma ou mais conexões mais próximos que a distância miníma configurada, connec_id:', 'Verifique o seu projeto ou modifique as propriedades de configuração (config.connec_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3036, 'O tipo de estado selecionado não corresponde com o estado', 'Modifique o valor de estado ou tipo de estado.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3048, 'O comprimento do fluxo é maior que o comprimento do arco de saída do elemento de rede', 'Por favor reveja o seu projeto!', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1098, 'Não é permitido ter um nó com o estado (1) ou (2) sobre um nó existente com o estado (1).', 'Utilize o botão substituir nó. Não é possível ter mais de um nó com o mesmo estado na mesma posição', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3034, 'Foi atualizado o estado do inventário e o tipo de estado dos elementos de rede planificados', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3066, 'O dma e o período ainda não existem na tabela dma-period (ext_rtc_scada_dma_period). Significa que não existem valores para esse dma ou para esse período de CRM no SIG', 'Por favor verifique antes de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3046, 'O tipo de nó selecionado não divide o arco. Tipo de nó:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1097, 'Não é permitido inserir / atualizar um nó com o estado (1) sobre outro com o estado (1) também. O nó é:', 'Por favor comprove-o', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3070, 'A ligação necessita de um elemento de rede de conexão/sarjeta como ponto de partida. Foi comprovada a geometria e não há nenhum elemento de rede de conexão/sarjeta como ponto inicial/final', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3050, 'Não é possível relacionar conexões com estado=1 com arcos com estado=2', 'Por favor reveja o seu mapa!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1064, 'Há pelo menos uma ligação adjunta ao elemento de rede eliminado.(num. link,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhuma ligação adjunta.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1016, 'É impossível mudar o catálogo de nós', 'O novo catálogo de nós não pertence ao mesmo tipo que o catálogo de nós antigo (node_type.type)', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1104, 'Atualizar não é permitido ...', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1080, 'Não tem permissões para administrar com psector', 'Por favor comprove se o seu perfil tem role_master para poder gerir os problemas do plano', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2068, 'O node_id fornecido não existe como um ''WWTP'' (tipo de sistema)', 'Por favor procure outro nó', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2028, 'O elemento de rede não possui o valor do estado(1) a ser substituído, state =', 'O elemento de rede deve ter o estado 1 para ser substituído', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1100, 'Não é permitido inserir / atualizar um nó com estado (2) sobre outro com estado (2). O nó é:', 'Reveja os seus dados. Não é possível ter mais de um nó com o mesmo estado na mesma posição.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3068, 'O dma/period definido na tabela dma-period (ext_rtc_scada_dma_period) tem um pattern_id definido', 'Por favor verifique antes de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3032, 'Não se pode aplicar a chave estrangeira', 'já existem valores inseridos que não estão presentes no catálogo', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1081, 'Não há psectores definidos no projeto', 'Necessita de ter pelo menos um psector criado para adicionar elementos planificados', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3062, 'O grillcat_id selecionado tem uma largura ou comprimento NULL. Gratecat_id:', 'Verifique o catálogo da grade ou as suas configurações personalizadas antes de continuar', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2094, 'Por favor, atribua uma conexão para relacionar esta geometria de polígono', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2098, 'O connec_id facilitado não existe como ''FOUNTAIN'' (tipo de sistema)', 'Procure outra conexão', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3084, 'Não está habilitado para inserir vnodes. Se está procurando unir ligações, pode usar vconnec para uni-los', 'Pode criar o elemento de rede vconnec e simbolizá-la como vnodes. Ao usar vconnec como vnodes, terá todos os elementos de rede en termos de propagação de arc_id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2016, 'Não está habilitado para modificar o ponto inicial/final da conexão', 'Se deseja reconectar os elementos de rede, exclua esta ligação e desenhe uma nova.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1010, 'O elemento de rede está fora do setor, feature_id:', 'Verifique o seu mapa e use a abordagem dos setores!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1068, 'Há pelo menos uma sarjeta adjunta ao elemento de rede eliminado.(num. gully,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhuma sarjeta adjunta.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1028, 'Apagar arcos desta tabela não é permitido', 'Para apagar arcos, use a camada de arco em INVENTARIO', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3096, 'If widgettype=typeahead, isautoupdate must be FALSE', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3052, 'A ferramenta Connect2network não está habilitada para conexões com estado=2. Connec_id:', 'Para as conexões planificadas, deve criar a ligação manualmente (uma ligação para cada alternativa e uma conexão) utilizando o formulario psector e relacionando a conexão utilizando o campo arc_id. Depois disso, poderá personalizar a geometria da ligação.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3058, 'É impossível validar a conexão sem atribuir o valor de connecat_id. Connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3026, 'Não se pode eliminar a classe. Há pelo menos uma visita relacionada', 'A classe se estabelecerá como inativa.', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1022, 'Não há valores de catálogo de conexão definidos no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1054, 'É impossível dividir um arco com o estado=(1) usando um nó com o estado=(2)', 'Para dividir um arco, o estado do nó usado deve ser 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3078, 'Não é possível criar a ligação. No modo de inventário, só se habilita uma ligação para cada sarjeta. Gully_id:', 'No modo de planificação é possível criar mais de uma ligação, uma para cada alternativa, mas é obrigatório usar o formulário psector e relacionar a sarjeta usando o campo arc_id. Depois disso, poderá personalizar a geometria da ligação.', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1050, 'É impossível dividir um arco que tem estado=(0)', 'Para dividir um arco, o estado tem de ser 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2002, 'Nó não encontrado', 'Por favor verifique a tabela de nó ', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1066, 'Há pelo menos uma conexão adjunta ao elemento de rede eliminado.(num. connec,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhuma conexão adjunta.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3072, 'Não é possível conectar a ligação a menos de 0,25 metros dos elementos de rede nod2arc para evitar conflitos se o nó poder ser um nod2arc', 'Por favor verifique antes de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2024, 'O elemento de rede está fora de qualquer município, feature_id:', 'Por favor reveja os seus dados', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1078, 'Antes de fazer o downgrade da sarjeta para o estado 0, desconecte os elemento de rede associados, gully_id:', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1070, 'O elemento de rede não pode ser substituído, porque o seu estado é diferente de 1. State =', 'Para substituir um elemento de rede, deve ter estado = 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2048, 'Polígono não relacionado a nenhuma sarjeta', 'Insira gully_id para atribuir a geometria do polígono ao elemento de rede', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1002, 'Testar trigger', 'Testar Trigger', 0, true, 'ws_trg', 'core');
INSERT INTO sys_message VALUES (1076, 'Antes de fazer o downgrade da conexão para o estado 0, desconecte os elemento de rede associados, connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (-1, 'Erro não capturado', 'Abra o ficheiro de registo de PostgreSQL para obter mais detalhes', 2, true, 'generic', 'core');
INSERT INTO sys_message VALUES (2096, 'Não é possível relacionar esta geometria com nenhuma conexão.', 'A conexão tem que ser do tipo ''FOUNTAIN'' (tipo de sistema)', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1052, 'É impossível dividir um arco usando um nó que tem estado=(0)', 'Para dividir um arco, o estado do nó tem de ser 1', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2050, 'O gully_id proporcionado não existe.', 'Procure outro gully_id', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1024, 'Não há valores de catálogo de grade definidos no modelo', 'Definir pelo menos um', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1004, 'Não há tipos de nós definidos no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3094, 'One of new arcs has no length', 'The selected node may be its final.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1026, 'Inserir novo arco nesta tabela não é permitido', 'Para inserir novo arco, use a camada de arco em INVENTARIO', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3098, 'If widgettype=typeahead and dv_querytext_filterc is not null dv_parent_id must be combo', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1042, 'Um ou mais arcos não foram inseridos/atualizados porque não têm nó inicial/final. Arc_id:', 'Verifique o seu projeto ou modifique as propriedades de configuração.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2066, 'O node_id fornecido não existe como um ''CHAMBER'' (tipo de sistema)', 'Por favor procure outro nó', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1090, 'Tem de escolher um valor de catálogo de nós para este elemento de rede', 'Nodecat_id é necessário. Preencha a tabela cat_node ou use um valor padrão', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2010, 'Não há valores na tabela cat_element.', 'É necessário Elementcat_id. Insira valores na tabela cat_element ou use um valor padrão', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3100, 'If widgettype=typeahead, id and idval for dv_querytext expression must be the same field', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3090, 'Por favor atribua una graphClass válida', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2088, 'Há [unidades] valores nulos ou não definidos na tabela price_value_unit =', 'Por favor preencha antes de continuar', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3102, 'If dv_querytext_filterc is not null dv_parent_id is mandatory', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3104, 'When dv_querytext_filterc, dv_parent_id must be a valid column for this form. Please check form because there is not column_id with this name', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3106, 'There is no presszone defined in the model', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3108, 'Feature is out of any presszone, feature_id:', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3028, 'Não se pode modificar typevalue:', 'É impossível alterar os valores do sistema.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2004, 'É impossível usar o nó para fundir dois arcos.', 'Os canos têm diferentes tipos.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3016, 'O novo campo sobrepõe-se ao existente', 'Modifique o valor do pedido.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3044, 'Não se pode detetar nenhum arco para dividir.', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3030, 'Não se pode eliminar typevalue:', 'Está sendo usado numa tabla.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3024, 'Não se pode eliminar o parâmetro. Há pelo menos um evento relacionado com ele', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3040, 'O usuário com este nome já existe', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3064, 'Há um padrão com o mesmo nome na tabela inp_pattern', 'Por favor verifique antes de continuar.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3038, 'O valor inserido tem caracteres não aceites:', 'Não use acentos, pontos ou hífens na identificación e nome da vista child', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3014, 'A identificação da posição no é nó_1 ou nó_2 do arco selecionado.', 'Por favor reveja os seus dados', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1018, 'Não há tipos de arco definidos no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3012, 'O valor de posição é maior que o comprimento total do arco.', 'Por favor reveja os seus dados', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3110, 'There is no municipality defined in the model', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2006, 'É impossível usar o nó para fundir dois arcos.', 'O nó não tem 2 arcos', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3056, 'É impossível validar o arco sem atribuir o valor de arccat_id. Arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3060, 'É impossível validar o nó sem atribuir o valor de nodecat_id. Node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1034, 'Inserir uma nova válvula nesta tabela não é permitido', 'Para inserir uma nova válvula, use a camada de nó em INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2008, 'Arco não encontrado', 'Por favor verifique a tabela de arco', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1102, 'Inserir não é permitido. Não há hydrometer_id em ...', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1032, 'Apagar nós desta tabela não é permitido', 'Para apagar nós, use a camada de nó em INVENTARIO', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1106, 'Apagar não é permitido. Há hydrometer_id em ...', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1084, 'Inexistente node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1082, 'Inexistente arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2034, 'O seu catálogo é diferente do tipo de nó', 'Os seus dados também devem estar no catálogo de nós', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1072, 'Antes de fazer o downgrade do nó para o estado 0, desconecte os elemento de rede associados, node_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1038, 'Apagar válvulas desta tabela não é permitido', 'Para eliminar válvulas, use a camada de nó em INVENTORY', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2038, 'O arco de saída tem que ser invertido. Arc =', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2022, '(arc_id, geom type) =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1074, 'Antes de fazer o downgrade do arco para o estado 0, desconecte os elemento de rede associados, arc_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2100, 'Não é possível relacionar esta geometria com nenhum nó.', 'O nó tem que ser do tipo ''REGISTER'' (tipo de sistema)', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2104, 'O node_id facilitado não existe como ''REGISTER'' (tipo de sistema)', 'Procure outro nó', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2012, 'O elemento de rede está fora de exploração, feature_id:', 'Verifique o seu mapa e use a abordagem das explorações!', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2102, 'Não é possível relacionar esta geometria com nenhum nó.', 'O nó tem que ser do tipo ''TANK'' (tipo de sistema)', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2014, 'Precisa de conetar a ligação a uma conexão/sarjeta', 'As ligações devem estar conectadas a outros elementos', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1094, 'O seu catálogo é diferente do tipo de nó', 'Deve usar um tipo de nó definido nos catálogos de nós', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1048, 'Elev não é uma coluna actualizável', 'Por favor use top_elev ou ymax para modificar este valor.', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2026, 'Existem conflitos contra outro polígono de corte planeado.', 'Por favor reveja os seus dados', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (3132, 'Schema defined does not exists. Check your qgis project variable gwAddSchema', 'None', 1, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2092, 'Há valores nulos na coluna [price] do csv', 'Por favor reveja antes de continuar', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2080, 'O valor de x é demasiado grande. O comprimento total da linha é', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2040, 'A geometria reduzida não é uma cadeia lineal, (arc_id,geomtype)=', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2086, 'Existem valores nulos na coluna [id] de csv. Reveja-o', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2082, 'A extensão não existe. Extensão =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2106, 'O node_id proporcionado não existe como ''TANK'' (tipo de sistema)', 'Procure outro nó', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2076, 'O comprimento do fluxo é maior que o comprimento do arco de saída do elemento de rede', 'Por favor reveja o seu projeto', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2084, 'O módulo não existe. Módulo =', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2078, 'Texto da consulta=', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2074, 'Deve definir o comprimento do regulador de fluxo', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3080, 'Não é possível relacionar conexão com estado=2 sobre o elemento de rede com estado=1. Connec_id:', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2120, 'Há uma inconsistência entre os estados de arco e nó', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2108, 'Há pelo menos um nó adjunto ao elemento de rede eliminado.(num. node,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhum nó adjunto.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2110, 'Defina pelo menos um valor de state_type com estado=0', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2122, 'Arco não encontrado no processo de inserção', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3074, 'É obrigatório conectar como ponto de início uma conexão ou sarjeta com ligação', 'None', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3088, 'Não está habilitado para eliminar vnodes', 'Vnode será eliminado automaticamente quando a ligação conectada ao vnode desapareça', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2036, 'É impossível validar o arco sem atribuir o valor de arccat_id, arc_id:', 'Atribua o valor arccat_id', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2070, 'Deve estabelecer um valor da coluna to_arc antes de continuar', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2064, 'O node_id proporcionado não existe como ''STORAGE'' (tipo de sistema)', 'Procure outro nó', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2060, 'Não é possível relacionar esta geometria com nenhum nó.', 'O nó deve ser do tipo ''WWTP'' (tipo de sistema).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (3092, 'Só o arco está disponível como elemento de rede de entrada para executar o polígono de corte', 'None', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2054, 'Não é possível relacionar esta geometria com nenhum nó.', 'O nó deve ser do tipo ''NETGULLY'' (tipo de sistema).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1020, 'Não há valores de catálogo de arco definidos no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2052, 'Polígono não relacionado a nenhum nó', 'Insira node_id para atribuir a geometria do polígono ao elemento de rede', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1006, 'Não há valores de catálogo de nós definidos no modelo', 'Definir pelo menos um', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2072, 'Deve estabelecer os valores to_arc/node_id com coerência topológica', 'Node_id deve ser o nó_1 do arco de saída do elemento de rede', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (1046, 'Existe um ou mais nós mais próximos que a distância miníma configurada, node_id:', 'Verifique o seu projeto ou modifique as propriedades de configuração (config.node_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2046, 'O tipo de estado não é um valor do estado definido. Por favor revise os seus dados', 'O tipo de estado deve estar relacionado aos estados', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3086, 'Não está habilitado para atualizar vnodes', 'Se está procurando atualizar o punto final das ligações, use a capa da ligação para fazê-lo', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2062, 'O node_id proporcionado não existe como ''NETGULLY'' (tipo de sistema)', 'Procure outro nó', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2058, 'Não é possível relacionar esta geometria com nenhum nó.', 'O nó deve ser do tipo ''CHAMBER'' (tipo de sistema).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (2020, 'Um ou mais vnodes estão mais próximos que a distância mínima configurada', 'Verifique o seu projeto ou modifique as propriedades de configuração (config.node_proximity).', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2030, 'O elemento de rede não possui o valor do estado(2) a ser substituído, state =', 'O elemento de rede deve ter o estado 2 para ser substituído', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1092, 'O seu catálogo de valores padrão não está ativado usando o tipo de nó escolhido', 'Deve usar um tipo de nó definido nos catálogos de nós', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2056, 'Não é possível relacionar esta geometria com nenhum nó.', 'O nó deve ser do tipo ''STORAGE'' (tipo de sistema).', 2, true, 'ud', 'core');
INSERT INTO sys_message VALUES (1036, 'Existem colunas nesta tabela que não são permitidas editar', 'Tente atualizar open, accesibility, broken, mincut_anl ou hydraulic_anl', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1086, 'Deve escolher um valor de catálogo de conexão para esse elemento de rede', 'É necessário Connecat_id. Preencha a tabela cat_connec ou use um valor padrão', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1040, 'Um ou mais arcos têm o mesmo nó que Nó1 e Nó2. Node_id:', 'Verifique o seu projeto ou modifique as propriedades de configuração', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1088, 'O catálogo de conexão é diferente do tipo de conexão', 'Use um tipo de conexão definido nos catálogos de conexão', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2018, 'Pelo menos um dos nós extremos do arco não está presente na alternativa atualizada. A rede planeada perdeu a topologia', 'None', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1030, 'Inserir um novo nó nesta tabela não é permitido', 'Para inserir novo nó, use a camada de nó em INVENTARIO', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (2044, 'A zona de pressão não está na exploração definida. Por favor revise os seus dados', 'O elemento deve estar dentro da zona de pressão relacionada à exploração definida', 2, true, 'ws', 'core');
INSERT INTO sys_message VALUES (2090, 'Existem valores [descrição] nulos no csv importado', 'Por favor complete-o antes para continuar', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (1062, 'Há pelo menos uma visita adjunta ao elemento de rede eliminado.(num. visit,feature_id) =', 'Reveja os seus dados. O elemento de rede eliminado não pode ter nenhuma visita adjunta.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3010, 'O comprimento de arco mínimo desta exportação é:', 'Este comprimento é menor que o parâmetro nod2arc. Deve atualizar o parâmetro config.node2arc para ter um valor inferior.', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3054, 'A ferramenta Connect2network não está habilitada para sarjetas com estado=2. Gully_id:', 'Para as sarjetas planificadas, deve criar a ligação manualmente (uma ligação para cada alternativa e uma sarjeta) utilizando o formulario psector e relacionando a sarjeta utilizando o campo arc_id. Depois disso, poderá personalizar a geometria da ligação.', 2, true, 'utils', 'core');
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
INSERT INTO sys_message VALUES (3076, 'Não é possível criar a ligação. No modo de inventário, só se habilita uma ligação para cada conexão. Connec_id:', 'In order to relate link with psector use psector dialog or link2network button. you can''t draw in on link layer', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3082, 'Não é possível relacionar conexão com outra conexão ou nó enquanto se trabalha com alternativas no modo de planificação. Só os arcos estão disponíveis', 'You can''t have two links related to the same feature (connec/gully) in one psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3228, 'It is not possible to insert arc into psector because has operative connects associated', 'You need to previously insert related connects into psector', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3164, 'Arc have incorrectly defined final nodes in this plan alternative', 'Make sure that arcs finales are on service or check by using toolbox function Check plan data (fid= 355)', 2, true, 'utils', 'core');
INSERT INTO sys_message VALUES (3238, 'Dscenario with this name doesn''t exist', 'Create an empty dscenario with the same name as indicated in csv file in order to continue the import of data', 2, true, 'ws', 'core');


--
-- Data for Name: cat_feature; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature VALUES ('LIGACAO', 'WJOIN', 'CONNEC', NULL, 'v_edit_connec', 've_connec_ligacao', 'Ligação', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('TUBULACAO', 'PIPE', 'ARC', NULL, 'v_edit_arc', 've_arc_tubulacao', 'Tubulação', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_BORBOLETA', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_borboleta', 'Valvula borboleta/ reguladora de fluxo', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_PARADA', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_parada', 'Valvula de parada', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('RESERVATORIO', 'TANK', 'NODE', NULL, 'v_edit_node', 've_node_reservatorio', 'Reservatorio', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_IRRIGA', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_irriga', 'Valvula para irrigação', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_EXULTORIO', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_exultorio', 'Valvula tipo exultório', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_GERAL', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_geral', 'Valvula de aplicação geral', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('UNIAO', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_uniao', 'União', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_SUST_PRES', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_sust_pres', 'Valvula sustentadora de pressão', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_REDU_PRES', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_redu_pres', 'Valvula redutora de pressão', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_QUEBRA_VACUO', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_quebra_vacuo', 'Válvula Quebra Vácuo', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('T', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_t', 'União tipo Tê', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('X', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_x', 'União tipo X', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('ADAPTADOR', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_adaptador', 'Adaptador', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('CURVA', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_curva', 'Curva', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('FIM_REDE', 'JUNCTION', 'NODE', NULL, 'v_edit_node', 've_node_fim_rede', 'Fim de rede', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VALVULA_CUNHA', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_valvula_cunha', 'Valvula de cunha', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('VENTOSA', 'VALVE', 'NODE', NULL, 'v_edit_node', 've_node_ventosa', 'Valvula ventosa', NULL, true, true, NULL);
INSERT INTO cat_feature VALUES ('FONTE_ORNAMENTAL', 'FOUNTAIN', 'CONNEC', NULL, 'v_edit_connec', 've_connec_fonte_ornamental', 'Fonte Ornamental', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('TORNERIA', 'TAP', 'CONNEC', NULL, 'v_edit_connec', 've_connec_torneria', 'Torneria', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('PONTO_IRRIGACAO', 'GREENTAP', 'CONNEC', NULL, 'v_edit_connec', 've_connec_ponto_irrigacao', 'Ponto de irrigação', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('VARC', 'VARC', 'ARC', 'A', 'v_edit_arc', 've_arc_varc', 'Tubulação virtual', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('HIDRANTE', 'HYDRANT', 'NODE', NULL, 'v_edit_node', 've_node_hidrante', 'Hidrante', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CONE_REDUCAO', 'REDUCTION', 'NODE', NULL, 'v_edit_node', 've_node_cone_reducao', 'Cone de redução', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('BOMBA', 'PUMP', 'NODE', NULL, 'v_edit_node', 've_node_bomba', 'Bomba', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('PONTO_INSPECAO', 'MANHOLE', 'NODE', NULL, 'v_edit_node', 've_node_ponto_inspecao', 'Ponto de inspeção', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('REGISTRO', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_registro', 'Registro de passagem', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('REGISTRO_VALVULA', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_registro_valvula', 'Registro de válvula', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('LIGACAO_TOPO', 'NETWJOIN', 'NODE', NULL, 'v_edit_node', 've_node_ligacao_topo', 'Conexão predial direta na rede', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('JUNTA_ELASTICA', 'FLEXUNION', 'NODE', NULL, 'v_edit_node', 've_node_junta_elastica', 'Junta elástica', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('MEDIDOR_PRES', 'METER', 'NODE', NULL, 'v_edit_node', 've_node_medidor_pres', 'Medidor de pressão', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('COLETA_AMOSTRA', 'NETSAMPLEPOINT', 'NODE', NULL, 'v_edit_node', 've_node_coleta_amostra', 'Ponto de coleta de amostra', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('NETELEMENT', 'NETELEMENT', 'NODE', 'Alt+E', 'v_edit_node', 've_node_netelement', 'Elemento geral sob traçado da rede', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('BYPASS', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_bypass', 'Ponto de bypass de rede', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('HIDROMETRO', 'REGISTER', 'NODE', NULL, 'v_edit_node', 've_node_hidrometro', 'Hidrometro', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('TANQUE_EXPAN', 'EXPANSIONTANK', 'NODE', NULL, 'v_edit_node', 've_node_tanque_expan', 'Tanque de expansão termica de agua', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('FILTRO', 'FILTER', 'NODE', NULL, 'v_edit_node', 've_node_filtro', 'Filtro', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CAPT_SUBT', 'WATERWELL', 'NODE', NULL, 'v_edit_node', 've_node_capt_subt', 'Poço de captação', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('CAPT_SUP', 'SOURCE', 'NODE', NULL, 'v_edit_node', 've_node_capt_sup', 'Ponto de Captação', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('ETA', 'WTP', 'NODE', NULL, 'v_edit_node', 've_node_eta', 'Estação de Tratamento de Água', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('MEDIDOR', 'METER', 'NODE', NULL, 'v_edit_node', 've_node_medidor', 'Medidor de Vazão', NULL, true, false, NULL);
INSERT INTO cat_feature VALUES ('LINK', 'LINK', 'LINK', NULL, 'v_edit_link', 'v_edit_link', 'Link', NULL, true, false, NULL);


--
-- Data for Name: cat_feature_arc; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_arc VALUES ('TUBULACAO', 'PIPE', 'PIPE');
INSERT INTO cat_feature_arc VALUES ('VARC', 'VARC', 'PIPE');


--
-- Data for Name: cat_feature_connec; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_connec VALUES ('LIGACAO', 'WJOIN', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('FONTE_ORNAMENTAL', 'FOUNTAIN', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('TORNERIA', 'TAP', '{"activated":false,"value":1}', 'JUNCTION');
INSERT INTO cat_feature_connec VALUES ('PONTO_IRRIGACAO', 'GREENTAP', '{"activated":false,"value":1}', 'JUNCTION');


--
-- Data for Name: cat_feature_node; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO cat_feature_node VALUES ('UNIAO', 'JUNCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('T', 'JUNCTION', 'JUNCTION', 3, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('X', 'JUNCTION', 'JUNCTION', 4, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ADAPTADOR', 'JUNCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CURVA', 'JUNCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('FIM_REDE', 'JUNCTION', 'JUNCTION', 1, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_BORBOLETA', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_GERAL', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_SUST_PRES', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_REDU_PRES', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_QUEBRA_VACUO', 'VALVE', 'VALVE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_IRRIGA', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_EXULTORIO', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_CUNHA', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VENTOSA', 'VALVE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('VALVULA_PARADA', 'VALVE', 'SHORTPIPE', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('REGISTRO', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('REGISTRO_VALVULA', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('BYPASS', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('HIDROMETRO', 'REGISTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('NETELEMENT', 'NETELEMENT', 'JUNCTION', 2, true, true, 'DQA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('TANQUE_EXPAN', 'EXPANSIONTANK', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('FILTRO', 'FILTER', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('JUNTA_ELASTICA', 'FLEXUNION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('MEDIDOR_PRES', 'METER', 'JUNCTION', 2, true, true, 'DMA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('MEDIDOR', 'METER', 'JUNCTION', 2, true, true, 'DMA', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('HIDRANTE', 'HYDRANT', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('PONTO_INSPECAO', 'MANHOLE', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('COLETA_AMOSTRA', 'NETSAMPLEPOINT', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('BOMBA', 'PUMP', 'PUMP', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CONE_REDUCAO', 'REDUCTION', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CAPT_SUP', 'SOURCE', 'RESERVOIR', 2, true, true, 'SECTOR', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('RESERVATORIO', 'TANK', 'TANK', 9, true, true, 'SECTOR', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('LIGACAO_TOPO', 'NETWJOIN', 'JUNCTION', 2, true, true, 'NONE', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('CAPT_SUBT', 'WATERWELL', 'RESERVOIR', 2, true, true, 'SECTOR', false, '{"activated":false,"value":1}');
INSERT INTO cat_feature_node VALUES ('ETA', 'WTP', 'RESERVOIR', 2, true, true, 'SECTOR', false, '{"activated":false,"value":1}');


--
-- Data for Name: config_graph_valve; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO config_graph_valve VALUES ('VALVULA_PARADA', true);


--
-- Data for Name: element_type; Type: TABLE DATA; Schema: ; Owner: -
--

INSERT INTO element_type VALUES ('REGISTRO', true, true, 'REGISTRO', NULL);
INSERT INTO element_type VALUES ('PV', true, true, 'PV', NULL);
INSERT INTO element_type VALUES ('CAPA', true, true, 'CAPA', NULL);
INSERT INTO element_type VALUES ('BATENTE', true, true, 'BATENTE', NULL);
INSERT INTO element_type VALUES ('PROTECAO_DE_BANDA', true, true, 'PROTECAO DE BANDA', NULL);
INSERT INTO element_type VALUES ('PLACA_HIDRANTE', true, true, 'PLACA_HIDRANTE', NULL);


