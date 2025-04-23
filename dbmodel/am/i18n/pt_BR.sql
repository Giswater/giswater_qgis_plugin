/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = am, public;

INSERT INTO value_result_type VALUES ('GLOBAL', 'GLOBAL');
INSERT INTO value_result_type VALUES ('SELECTION', 'SELEÇÃO');

INSERT INTO value_status VALUES ('CANCELED', 'CANCELADO');
INSERT INTO value_status VALUES ('ON PLANNING', 'EM PLANEJAMENTO');
INSERT INTO value_status VALUES ('FINISHED', 'FINALIZADO');

UPDATE config_engine_def SET label = 'Vazamentos reais' WHERE parameter = 'rleak_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Vazamentos reais' WHERE parameter = 'rleak_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Probabilidad de falha' WHERE parameter = 'mleak_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Probabilidad de falha' WHERE parameter = 'mleak_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Longevidade' WHERE parameter = 'longevity_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Longevidade' WHERE parameter = 'longevity_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Vazão circulante' WHERE parameter = 'flow_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Vazão circulante' WHERE parameter = 'flow_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Água não faturada' WHERE parameter = 'nrw_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Água não faturada' WHERE parameter = 'nrw_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Estratégico' WHERE parameter = 'strategic_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Estratégico' WHERE parameter = 'strategic_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Conformidade' WHERE parameter = 'compliance_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Conformidade' WHERE parameter = 'compliance_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Coeficiente de taxa de vazamentos' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE config_engine_def SET label = 'Taxa de desconto (%)' WHERE parameter = 'drate' AND method = 'SH';
UPDATE config_engine_def SET label = 'Peso de ano esperado' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE config_engine_def SET label = 'Peso de conformidade' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE config_engine_def SET label = 'Peso de estratégico' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Peso na matriz final por fatores estratégicos' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Peso na matriz final por ano de renovação' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Peso na matriz final por grau de conformidade' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Coeficiente de crescimento de vazamentos na tubulação' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Taxa de atualização real de preços (discount rate). Leva em conta o aumento de preços descontando a inflação.' WHERE parameter = 'drate' AND method = 'SH';

UPDATE config_form_tableview SET alias = 'Diâmetro' WHERE objectname = 'config_catalog_def' AND columnname = 'dnom';
UPDATE config_form_tableview SET alias = 'Custo de renovação' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_constr';
UPDATE config_form_tableview SET alias = 'Custo de reparação (rede)' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_repmain';
UPDATE config_form_tableview SET alias = 'Custo de reparação (ramal)' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_repserv';
UPDATE config_form_tableview SET alias = 'Grau de conformidade' WHERE objectname = 'config_catalog_def' AND columnname = 'compliance';
UPDATE config_form_tableview SET alias = 'Material' WHERE objectname = 'config_material_def' AND columnname = 'material';
UPDATE config_form_tableview SET alias = 'Prob. de falha' WHERE objectname = 'config_material_def' AND columnname = 'pleak';
UPDATE config_form_tableview SET alias = 'Longevidade máx.' WHERE objectname = 'config_material_def' AND columnname = 'age_max';
UPDATE config_form_tableview SET alias = 'Longevidade med.' WHERE objectname = 'config_material_def' AND columnname = 'age_med';
UPDATE config_form_tableview SET alias = 'Longevidade mín.' WHERE objectname = 'config_material_def' AND columnname = 'age_min';
UPDATE config_form_tableview SET alias = 'Ano de construção' WHERE objectname = 'config_material_def' AND columnname = 'builtdate_vdef';
UPDATE config_form_tableview SET alias = 'Grau de conformidade' WHERE objectname = 'config_material_def' AND columnname = 'compliance';
UPDATE config_form_tableview SET alias = 'Parâmetro' WHERE objectname = 'config_engine_def' AND columnname = 'parameter';
UPDATE config_form_tableview SET alias = 'Valor' WHERE objectname = 'config_engine_def' AND columnname = 'value';
UPDATE config_form_tableview SET alias = 'Descrição' WHERE objectname = 'config_engine_def' AND columnname = 'alias';
UPDATE config_form_tableview SET alias = 'Id' WHERE objectname = 'cat_result' AND columnname = 'result_id';
UPDATE config_form_tableview SET alias = 'Resultado' WHERE objectname = 'cat_result' AND columnname = 'result_name';
UPDATE config_form_tableview SET alias = 'Tipo' WHERE objectname = 'cat_result' AND columnname = 'result_type';
UPDATE config_form_tableview SET alias = 'Descrição' WHERE objectname = 'cat_result' AND columnname = 'descript';
UPDATE config_form_tableview SET alias = 'Relatório' WHERE objectname = 'cat_result' AND columnname = 'report';
UPDATE config_form_tableview SET alias = 'Empreendimento' WHERE objectname = 'cat_result' AND columnname = 'expl_id';
UPDATE config_form_tableview SET alias = 'Orçamento anual' WHERE objectname = 'cat_result' AND columnname = 'budget';
UPDATE config_form_tableview SET alias = 'Ano horizonte' WHERE objectname = 'cat_result' AND columnname = 'target_year';
UPDATE config_form_tableview SET alias = 'Data' WHERE objectname = 'cat_result' AND columnname = 'tstamp';
UPDATE config_form_tableview SET alias = 'Usuário' WHERE objectname = 'cat_result' AND columnname = 'cur_user';
UPDATE config_form_tableview SET alias = 'Status' WHERE objectname = 'cat_result' AND columnname = 'status';
UPDATE config_form_tableview SET alias = 'Zona de pressão' WHERE objectname = 'cat_result' AND columnname = 'presszone_id';
UPDATE config_form_tableview SET alias = 'Material' WHERE objectname = 'cat_result' AND columnname = 'material_id';
UPDATE config_form_tableview SET alias = 'Seleção' WHERE objectname = 'cat_result' AND columnname = 'features';
UPDATE config_form_tableview SET alias = 'Diâmetro' WHERE objectname = 'cat_result' AND columnname = 'dnom';