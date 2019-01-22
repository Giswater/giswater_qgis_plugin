/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-----------------------
-- Records of om_visit_class
-----------------------
INSERT INTO om_visit_class VALUES (0, 'Open visit', 'All it''s possible, multievent and multifeature (or not)', true, NULL, NULL, NULL, 'role_om');
INSERT INTO om_visit_class VALUES (1, 'Avaria tram', NULL, true, false, false, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (2, 'Inspecció i neteja connec', NULL, true, false, true, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (3, 'Avaria node', NULL, true, false, false, 'NODE', 'role_om');
INSERT INTO om_visit_class VALUES (4, 'Avaria connec', NULL, true, false, false, 'CONNEC', 'role_om');
INSERT INTO om_visit_class VALUES (5, 'Inspecció i neteja tram', NULL, true, false, true, 'ARC', 'role_om');
INSERT INTO om_visit_class VALUES (6, 'Inspecció i neteja node', NULL, true, false, true, 'NODE', 'role_om');

-----------------------
-- Records of inp_options
-----------------------
UPDATE inp_options SET quality='NONE_QUAL' WHERE quality='NONE';


--UPDATE inp_report SET status='YES_YNF' WHERE status='YES';

UPDATE inp_times SET statistic='NONE_TIMES' WHERE statistic='NONE';

-----------------------
-- Records of inp_typevalue
-----------------------

INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'PATTERN_PUMP', 'PATTERN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'HEAD_PUMP', 'HEAD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'SPEED_PUMP', 'SPEED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_pump', 'POWER_PUMP', 'POWER', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'GLOBAL_GL', 'GLOBAL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'AGE', 'AGE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_energy', 'DEMAND CHARGE', 'DEMAND CHARGE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_energy', 'GLOBAL', 'GLOBAL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'CONCEN', 'CONCEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'FLOWPACED', 'FLOWPACED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'MASS', 'MASS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_source', 'SETPOINT', 'SETPOINT', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_ampm', 'AM', 'AM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_ampm', 'PM', 'PM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'EFFICIENCY', 'EFFICIENCY', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'HEADLOSS', 'HEADLOSS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'PUMP', 'PUMP', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_curve', 'VOLUME', 'VOLUME', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', '2COMP', '2COMP', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', 'FIFO', 'FIFO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', 'LIFO', 'LIFO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_mixing', 'MIXED', 'MIXED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_noneall', 'ALL', 'ALL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_noneall', 'NONE', 'NONE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_headloss', 'C-M', 'C-M', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_headloss', 'D-W', 'D-W', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_headloss', 'H-W', 'H-W', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', ' ', ' ', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', 'SAVE', 'SAVE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', 'USE', 'USE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'CHEMICAL mg/L', 'CHEMICAL mg/L', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'CHEMICAL ug/L', 'CHEMICAL ug/L', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_rtc_coef', 'MIN', 'MIN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_rtc_coef', 'AVG', 'AVG', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_rtc_coef', 'MAX', 'MAX', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_unbal', 'CONTINUE', 'CONTINUE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_unbal', 'STOP', 'STOP', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'AFD', 'AFD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'CMD', 'CMD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'CMH', 'CMH', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'GPM', 'GPM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'IMGD', 'IMGD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'LPM', 'LPM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'LPS', 'LPS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'MGD', 'MGD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_units', 'MLD', 'MLD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 'EPA TABLES', 'EPA TABLES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 'INVENTORY VALUES', 'INVENTORY VALUES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 'MINCUT RESULTS', 'MINCUT RESULTS', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_param_energy', 'EFFIC', 'EFFIC', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_param_energy', 'PATTERN', 'PATTERN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_param_energy', 'PRICE', 'PRICE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesno', 'NO', 'NO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesno', 'YES', 'YES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'GPV', 'GPV', 'General Purpose Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'FCV', 'FCV', 'Flow Control Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'PBV', 'PBV', 'Pressure Break Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'PRV', 'PRV', 'Pressure Reduction Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'PSV', 'PSV', 'Pressure Sustain Valve');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_valve', 'TCV', 'TCV', 'Throttle Control Valve');
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_el', 'BULK_EL', 'BULK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_el', 'TANK_EL', 'TANK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_el', 'WALL_EL', 'WALL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_gl', 'BULK_GL', 'BULK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_gl', 'TANK_GL', 'TANK', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_reactions_gl', 'WALL_GL', 'WALL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pipe', 'CLOSED_PIPE', 'CLOSED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pipe', 'CV_PIPE', 'CV', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pipe', 'OPEN_PIPE', 'OPEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pump', 'CLOSED_PUMP', 'CLOSED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_pump', 'OPEN_PUMP', 'OPEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_valve', 'ACTIVE_VALVE', 'ACTIVE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_valve', 'CLOSED_VALVE', 'CLOSED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_status_valve', 'OPEN_VALVE', 'OPEN', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesnofull', 'FULL_YNF', 'FULL', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesnofull', 'NO_YNF', 'NO', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_yesnofull', 'YES_YNF', 'YES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'NONE_QUAL', 'NONE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'NONE_TIMES', 'NONE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'RANGE', 'RANGE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'MINIMUM', 'MINIMUM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'MAXIMUM', 'MAXIMUM', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_times', 'AVERAGED', 'AVERAGED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_qual', 'TRACE', 'TRACE', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'ROUGHNESS CORRELATION', 'ROUGHNESS CORRELATION', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'ORDER', 'ORDER', NULL);
INSERT INTO inp_typevalue VALUES ('inp_typevalue_reactions_gl', 'LIMITING POTENTIAL', 'LIMITING POTENTIAL', NULL);


-----------------------
-- Records of sys_csv2pg_config
-----------------------

INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (28, 10, 'rpt_node', 'Node Results', NULL, NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (29, 10, 'rpt_arc', 'Link Results', NULL, NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (31, 10, 'rpt_hydraulic_status', 'Hydraulic Status:', NULL, NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (30, 10, 'rpt_energy_usage', 'Pump Factor', NULL, NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (32, 10, 'rpt_cat_result', 'Input Data', NULL, NULL);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (23, 9, 'vi_options', '[OPTIONS]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (0, 9, 'vi_junctions', '[JUNCTIONS]', 'csv1, csv2, csv3, csv4', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (2, 9, 'vi_reservoirs', '[RESERVOIRS]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (3, 9, 'vi_tanks', '[TANKS]', 'csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (4, 9, 'vi_pipes', '[PIPES]', 'csv1, csv2, csv3, csv4, csv5, csv6, csv7, csv8', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (6, 9, 'vi_valves', '[VALVES]', 'csv1, csv2, csv3, csv4, csv5, csv6, csv7', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (7, 9, 'vi_tags', '[TAGS]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (8, 9, 'vi_demands', '[DEMANDS]', 'csv1, csv2, csv3, csv4', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (9, 9, 'vi_status', '[STATUS]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (18, 9, 'vi_reactions', '[REACTIONS]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (15, 9, 'vi_emitters', '[EMITTERS]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (16, 9, 'vi_quality', '[QUALITY]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (17, 9, 'vi_sources', '[SOURCES]', 'csv1, csv2, csv3, csv4', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (22, 9, 'vi_report', '[REPORT]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (24, 9, 'vi_coordinates', '[COORDINATES]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (26, 9, 'vi_labels', '[LABELS]', 'csv1, csv2, csv3, csv4', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (27, 9, 'vi_backdrop', '[BACKDROP]', 'csv1', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (25, 9, 'vi_vertices', '[VERTICES]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (21, 9, 'vi_times', '[TIMES]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (13, 9, 'vi_rules', '[RULES]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (12, 9, 'vi_controls', '[CONTROLS]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (5, 9, 'vi_pumps', '[PUMPS]', 'csv1, csv2, csv3, csv4', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (11, 9, 'vi_curves', '[CURVES]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (20, 9, 'vi_mixing', '[MIXING]', 'csv1, csv2, csv3', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (10, 9, 'vi_patterns', '[PATTERNS]', 'csv1, csv2', 11);
INSERT INTO sys_csv2pg_config (id, pg2csvcat_id, tablename, target, fields, reverse_pg2csvcat_id) VALUES (14, 9, 'vi_energy', '[ENERGY]', 'csv1, csv2', 11);



-----------------------
-- Records of inp_options
-----------------------
UPDATE inp_options SET quality='NONE_QUAL' WHERE quality='NONE';

--UPDATE inp_report SET status='YES_YNF' WHERE status='YES'; -- text is too long to fit into field length

UPDATE inp_times SET statistic='NONE_TIMES' WHERE statistic='NONE';
