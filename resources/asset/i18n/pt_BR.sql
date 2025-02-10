/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

INSERT INTO asset.value_result_type VALUES ('GLOBAL', 'GLOBAL');
INSERT INTO asset.value_result_type VALUES ('SELECTION', 'SELEÇÃO');

INSERT INTO asset.value_status VALUES ('CANCELED', 'CANCELADO');
INSERT INTO asset.value_status VALUES ('ON PLANNING', 'EM PLANEJAMENTO');
INSERT INTO asset.value_status VALUES ('FINISHED', 'FINALIZADO');

UPDATE asset.config_engine_def SET label = 'Vazamentos reais' WHERE parameter = 'rleak_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Vazamentos reais' WHERE parameter = 'rleak_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Probabilidad de falha' WHERE parameter = 'mleak_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Probabilidad de falha' WHERE parameter = 'mleak_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Longevidade' WHERE parameter = 'longevity_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Longevidade' WHERE parameter = 'longevity_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Vazão circulante' WHERE parameter = 'flow_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Vazão circulante' WHERE parameter = 'flow_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Água não faturada' WHERE parameter = 'nrw_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Água não faturada' WHERE parameter = 'nrw_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Estratégico' WHERE parameter = 'strategic_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Estratégico' WHERE parameter = 'strategic_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Conformidade' WHERE parameter = 'compliance_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Conformidade' WHERE parameter = 'compliance_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Coeficiente de taxa de vazamentos' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Taxa de desconto (%)' WHERE parameter = 'drate' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Peso de ano esperado' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Peso de conformidade' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Peso de estratégico' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Peso na matriz final por fatores estratégicos' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Peso na matriz final por ano de renovação' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Peso na matriz final por grau de conformidade' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Coeficiente de crescimento de vazamentos na tubulação' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Taxa de atualização real de preços (discount rate). Leva em conta o aumento de preços descontando a inflação.' WHERE parameter = 'drate' AND method = 'SH';

UPDATE asset.config_form_tableview SET alias = 'Diâmetro' WHERE tablename = 'config_catalog_def' AND columnname = 'dnom';
UPDATE asset.config_form_tableview SET alias = 'Custo de renovação' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_constr';
UPDATE asset.config_form_tableview SET alias = 'Custo de reparação (rede)' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_repmain';
UPDATE asset.config_form_tableview SET alias = 'Custo de reparação (ramal)' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_repserv';
UPDATE asset.config_form_tableview SET alias = 'Grau de conformidade' WHERE tablename = 'config_catalog_def' AND columnname = 'compliance';
UPDATE asset.config_form_tableview SET alias = 'Material' WHERE tablename = 'config_material_def' AND columnname = 'material';
UPDATE asset.config_form_tableview SET alias = 'Prob. de falha' WHERE tablename = 'config_material_def' AND columnname = 'pleak';
UPDATE asset.config_form_tableview SET alias = 'Longevidade máx.' WHERE tablename = 'config_material_def' AND columnname = 'age_max';
UPDATE asset.config_form_tableview SET alias = 'Longevidade med.' WHERE tablename = 'config_material_def' AND columnname = 'age_med';
UPDATE asset.config_form_tableview SET alias = 'Longevidade mín.' WHERE tablename = 'config_material_def' AND columnname = 'age_min';
UPDATE asset.config_form_tableview SET alias = 'Ano de construção' WHERE tablename = 'config_material_def' AND columnname = 'builtdate_vdef';
UPDATE asset.config_form_tableview SET alias = 'Grau de conformidade' WHERE tablename = 'config_material_def' AND columnname = 'compliance';
UPDATE asset.config_form_tableview SET alias = 'Parâmetro' WHERE tablename = 'config_engine_def' AND columnname = 'parameter';
UPDATE asset.config_form_tableview SET alias = 'Valor' WHERE tablename = 'config_engine_def' AND columnname = 'value';
UPDATE asset.config_form_tableview SET alias = 'Descrição' WHERE tablename = 'config_engine_def' AND columnname = 'alias';
UPDATE asset.config_form_tableview SET alias = 'Id' WHERE tablename = 'cat_result' AND columnname = 'result_id';
UPDATE asset.config_form_tableview SET alias = 'Resultado' WHERE tablename = 'cat_result' AND columnname = 'result_name';
UPDATE asset.config_form_tableview SET alias = 'Tipo' WHERE tablename = 'cat_result' AND columnname = 'result_type';
UPDATE asset.config_form_tableview SET alias = 'Descrição' WHERE tablename = 'cat_result' AND columnname = 'descript';
UPDATE asset.config_form_tableview SET alias = 'Relatório' WHERE tablename = 'cat_result' AND columnname = 'report';
UPDATE asset.config_form_tableview SET alias = 'Empreendimento' WHERE tablename = 'cat_result' AND columnname = 'expl_id';
UPDATE asset.config_form_tableview SET alias = 'Orçamento anual' WHERE tablename = 'cat_result' AND columnname = 'budget';
UPDATE asset.config_form_tableview SET alias = 'Ano horizonte' WHERE tablename = 'cat_result' AND columnname = 'target_year';
UPDATE asset.config_form_tableview SET alias = 'Data' WHERE tablename = 'cat_result' AND columnname = 'tstamp';
UPDATE asset.config_form_tableview SET alias = 'Usuário' WHERE tablename = 'cat_result' AND columnname = 'cur_user';
UPDATE asset.config_form_tableview SET alias = 'Status' WHERE tablename = 'cat_result' AND columnname = 'status';
UPDATE asset.config_form_tableview SET alias = 'Zona de pressão' WHERE tablename = 'cat_result' AND columnname = 'presszone_id';
UPDATE asset.config_form_tableview SET alias = 'Material' WHERE tablename = 'cat_result' AND columnname = 'material_id';
UPDATE asset.config_form_tableview SET alias = 'Seleção' WHERE tablename = 'cat_result' AND columnname = 'features';
UPDATE asset.config_form_tableview SET alias = 'Diâmetro' WHERE tablename = 'cat_result' AND columnname = 'dnom';