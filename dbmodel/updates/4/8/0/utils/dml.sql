/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 03/02/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4540, 'The specified path is already in use on another document: %repeated_paths%', 'Use a different path or change it in the other document', 2, true, 'utils', 'core', 'UI');

UPDATE sys_fprocess SET query_text='SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc WHERE dma_id = -2 and sector_id > 0' WHERE fid=232;
UPDATE sys_fprocess SET query_text='SELECT node_id, nodecat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_node WHERE dma_id = -2 and sector_id > 0' WHERE fid=233;

-- 06/02/2026
INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4542,'Commit changes is not allowed using psectors','Unselect commit changes or use psectors option',2,true,'utils','core','UI');

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4544,'Commit changes must be enabled when Execute massive mincut is enabled','Enable commit changes or disable execute massive mincut',2,true,'utils','core','UI');

-- 10/02/2026
UPDATE config_param_system
	SET value='{"sys_display_name":"concat(name,'' ('',text2,'')'')","sys_tablename":"ve_plan_psector","sys_pk":"psector_id","sys_fct":"gw_fct_getinfofromid","sys_filter":"","sys_geom":"the_geom"}',
    "parameter"='basic_search_v2_tab_psector'
	WHERE "parameter"='basic_search_v2_tab_psector ';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4546, 'The following fields are configured but not in the table/view: %wrong_columns%', 'Check config_form_fields configuration', 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(708, 'Check subcatchment(s) with null values on mandatory column outlet_id column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'Column oulet_id on subcatchment table have been checked without any values missed.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment WHERE outlet_id is null', 'Column oulet_id on subcatchment table have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(706, 'Check area (subcatchments)', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'Total area informed has big differences from total shape area.', NULL, NULL, 'WITH sum as (SELECT (sum(st_area(the_geom)/10000))::integer as v_count, (sum(area))::integer as v_count_2
FROM ve_inp_subcatchment
WHERE area IS NOT NULL)
SELECT *
FROM sum
WHERE (v_count > v_count_2*2 AND v_count < v_count_2*10 OR (v_count_2 > v_count*2 AND v_count_2 < v_count*10))
OR (v_count > v_count_2*10 OR v_count_2 > v_count*10)', 'Total area informed is similar to total shape area.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(704, 'Check subcatchment(s) with null values on mandatory column rg_id column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column rg_id column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where rg_id is null', 'Column rg_id on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(702, 'Check subcatchment(s) with null values on mandatory column area column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column area column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where area is null', 'Column area on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(700, 'Check subcatchment(s) with null values on mandatory column width column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column width column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where width is null', 'Column width on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(698, 'Check subcatchment(s) with null values on mandatory column slope column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column slope column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where slope is null', 'Column slope on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(696, 'Check subcatchment(s) with null values on mandatory column clength column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column clength column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where clength is null', 'Column clength on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(694, 'Check subcatchment(s) with null values on mandatory column nimp column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column nimp column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where nimp is null', 'Column nimp on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(692, 'Check subcatchment(s) with null values on mandatory column nperv column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column nperv column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where nperv is null', 'Column nperv on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(690, 'Check subcatchment(s) with null values on mandatory column simp column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column simp column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where simp is null', 'Column simp on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(688, 'Check subcatchment(s) with null values on mandatory column sperv column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column sperv column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where sperv is null', 'Column sperv on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(686, 'Check subcatchment(s) with null values on mandatory column zero column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column zero column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where zero is null', 'Column zero on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(684, 'Check subcatchment(s) with null values on mandatory column routeto column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column routeto column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where routeto is null', 'Column routeto on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(682, 'Check subcatchment(s) with null values on mandatory column rted column.', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory column rted column.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where rted is null', 'Column rted on scenario subcatchments have been checked without any values missed.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(680, 'Check subcatchment(s) with null values on mandatory columns of Horton/Horton modified infiltartion method (maxrate, minrate, decay, drytime, maxinfil).', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory columns of Horton/Horton modified infiltartion method (maxrate, minrate, decay, drytime, maxinfil).', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where (maxrate is null) OR (minrate is null) OR (decay is null) OR (drytime is null) OR (maxinfil is null)', 'Mandatory columns for ''MODIFIED_HORTON'' infitration method (maxrate, minrate, decay, drytime, maxinfil) have been checked without any values missed.', '[gw_fct_pg2epa_check_result_horton,gw_fct_pg2epa_check_result_modified_horton]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(678, 'Check subcatchment(s) with null values on mandatory columns of Green-Apt infiltartion method (suction, conduct, initdef).', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory columns of Green-Apt infiltartion method (suction, conduct, initdef).', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where (suction is null) OR (conduct_2 is null) OR (initdef is null)', 'Mandatory columns for ''GREEN_AMPT'' infitration method (suction, conduct, initdef) have been checked without any values missed.', '[gw_fct_pg2epa_check_result_green_ampt]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(676, 'Check subcatchments with null values on mandatory columns of curve number infiltartion method (curveno, conduct_2, drytime_2)', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'subcatchment(s) with null values on mandatory columns of curve number infiltartion method (curveno, conduct_2, drytime_2).Acording EPA SWMM user''s manual, conduct_2 is deprecated, but is mandatory to fill it. Any value is valid because it will be ignored by SWMM.', NULL, NULL, 'SELECT * FROM ve_inp_subcatchment where (curveno is null) OR (conduct_2 is null) OR (drytime_2 is null)', 'Mandatory columns for ''CURVE_NUMBER'' infitration method (curveno, drytime_2) have been checked without any values missed.', '[gw_fct_pg2epa_check_result_curve_number]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(674, 'Check nodes with sector_id 0', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'node that didn''t take part of the simulation', NULL, NULL, 'SELECT node_id FROM ve_node WHERE sector_id = 0', 'All nodes have sector_id different than 0.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(672, 'Check arcs with sector_id 0', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'arc that didn''t take part of the simulation', NULL, NULL, 'SELECT arc_id FROM ve_arc WHERE sector_id = 0', 'All arcs have sector_id different than 0.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(670, 'Check LIDS conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'lids with conflict on enabled dscenarios', 'anl_polygon', NULL, 'WITH dscenario as (
SELECT subc_id as pol_id, lidco_id as pol_type, the_geom, count(*) as count FROM ve_inp_dscenario_lids GROUP BY subc_id, lidco_id, the_geom having count(*) > 1)
select pol_id, pol_type, NULL::int as expl_id, the_geom, count
FROM dscenario', 'There is not conflict on enabled dscenarios for outfalls.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(668, 'Check TREATMENT conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'treatment with conflict on enabled dscenarios', 'anl_node', NULL, 'WITH dscenario as (
SELECT node_id, count(*) FROM ve_inp_dscenario_treatment GROUP BY node_id having count(*) > 1)
select d.node_id, n.nodecat_id, n.expl_id, n.the_geom, d.count
FROM dscenario d
	JOIN node n ON n.node_id=d.node_id', 'There is not conflict on enabled dscenarios for treatments.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(666, 'Check OUTFALL conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'outfall with conflict on enabled dscenarios', 'anl_node', NULL, 'WITH dscenario as (
SELECT node_id, the_geom, count(*) FROM ve_inp_dscenario_outfall GROUP BY node_id, the_geom having count(*) > 1)
select d.node_id, n.nodecat_id, n.expl_id, d.the_geom, d.count
FROM dscenario d
	JOIN node n ON n.node_id=d.node_id', 'There is not conflict on enabled dscenarios for outfalls.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(664, 'Check STORAGE conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'storage with conflict on enabled dscenarios', 'anl_node', NULL, 'WITH dscenario as (
SELECT node_id, the_geom, count(*) as count FROM ve_inp_dscenario_storage GROUP BY node_id, the_geom having count(*) > 1)
select d.node_id, n.nodecat_id, n.expl_id, d.the_geom, d.count
FROM dscenario d
	JOIN node n ON n.node_id=d.node_id', 'There is not conflict on enabled dscenarios for storages.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(662, 'Check FROUTLET conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'froutlet with conflict on enabled dscenarios', 'anl_arc', NULL, 'WITH dscenario as (
SELECT element_id as arc_id, the_geom, count(*) FROM ve_inp_dscenario_froutlet GROUP BY element_id, the_geom having count(*) > 1)
SELECT d.arc_id, d.the_geom, d.count, a.arccat_id, a.expl_id
FROM dscenario d
	JOIN arc a ON a.arc_id=d.arc_id', 'There is not conflict on enabled dscenarios for froutlets.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(660, 'Check FRWEIR conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'frweir with conflict on enabled dscenarios', 'anl_arc', NULL, 'WITH dscenario as (
SELECT element_id as arc_id, the_geom, count(*) FROM ve_inp_dscenario_frweir GROUP BY element_id, the_geom having count(*) > 1)
SELECT d.arc_id, d.the_geom, d.count, a.arccat_id, a.expl_id
FROM dscenario d
	JOIN arc a ON a.arc_id=d.arc_id', 'There is not conflict on enabled dscenarios for frweirs.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(658, 'Check FRORIFICE conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'frorifice with conflict on enabled dscenarios', 'anl_arc', NULL, 'WITH dscenario as (
SELECT element_id as arc_id, the_geom, count(*) FROM ve_inp_dscenario_frorifice GROUP BY element_id, the_geom having count(*) > 1)
SELECT d.arc_id, d.the_geom, d.count, a.arccat_id, a.expl_id
FROM dscenario d
	JOIN arc a ON a.arc_id=d.arc_id', 'There is not conflict on enabled dscenarios for frorifices.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(656, 'Check RAINGAGE conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'raingage with conflict on dscenarios', NULL, NULL, 'SELECT count(*) FROM ve_inp_dscenario_raingage GROUP BY rg_id HAVING count(*) > 1', 'There is not conflict on enabled dscenarios for raingages.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(654, 'Check CONDUIT conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'conduit with conflict on enabled dscenarios', 'anl_arc', NULL, 'WITH dscenario as (
SELECT arc_id, the_geom, count(*) as count FROM ve_inp_dscenario_conduit GROUP BY arc_id, the_geom having count(*) > 1)
SELECT d.arc_id, d.the_geom, d.count, a.arccat_id, a.expl_id
FROM dscenario d
	JOIN arc a ON a.arc_id=d.arc_id', 'There is not conflict on enabled dscenarios for conduits.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(652, 'Check JUNCTION conflict on enabled dscenarios', 'ud', NULL, 'core', NULL, 'Check epa-result', NULL, 3, 'junction with conflict on enabled dscenarios', 'anl_node', NULL, 'WITH dscenario as (
SELECT node_id, the_geom, count(*) as count FROM ve_inp_dscenario_junction GROUP BY node_id, the_geom having count(*) > 1)
SELECT d.node_id, d.the_geom, d.count, n.nodecat_id, n.expl_id
FROM dscenario d
	JOIN node n ON n.node_id=d.node_id', 'There is not conflict on enabled dscenarios for junctions.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(650, 'Check controls for WEIR', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'Controls with weir are not present on this result.', NULL, NULL, 'SELECT * FROM (SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
(SELECT substring(split_part(text,''WEIR'', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_arc b USING (arc_id)
WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a', 'All Controls has correct WEIR id values.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(648, 'Check controls for ORIFICE', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'Controls with orifice are not present on this result.', NULL, NULL, 'SELECT * FROM (SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
(SELECT substring(split_part(text,''ORIFICE'', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_arc b USING (arc_id)
WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a', 'All Controls has correct ORIFICE id values.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(646, 'Check controls for PUMP', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'Controls with pumps are not present on this result.', NULL, NULL, 'SELECT * FROM (SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
(SELECT substring(split_part(text,''PUMP'', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_arc b USING (arc_id)
WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a', 'All Controls has correct PUMP id values.', '[gw_fct_pg2epa_check_result]', true);

DELETE FROM sys_fprocess WHERE fid IN (458, 457, 456, 455, 402, 401, 396, 406);

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(458, 'Check gullies with null values on (custom)length', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'gullies with null values on length/custom_length columns.', NULL, NULL, 'SELECT * FROM temp_t_gully WHERE length IS NULL', 'No gullies found with null values on length.', '[gw_fct_pg2epa_check_result_swmm]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(457, 'Check gullies with null values on (custom)width', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'gullies with null values on width/custom_width columns.', NULL, NULL, 'SELECT * FROM temp_t_gully WHERE width IS NULL', 'No gullies found with null values on width.', '[gw_fct_pg2epa_check_result_swmm]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(456, 'Check gullies with null values on (custom)top_elev', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'gullies with null values on top_elev/custom_top_elev columns.', NULL, NULL, 'SELECT * FROM temp_t_gully WHERE top_elev IS NULL', 'No gullies found with null values on top_elev.', '[gw_fct_pg2epa_check_result_swmm]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(455, 'Check arc_id null for gully', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'gullies with missed information on arc_id (outlet) values.', NULL, NULL, 'SELECT * FROM ve_gully g,  selector_sector s
		WHERE g.sector_id = s.sector_id AND cur_user=current_user AND arc_id IS NULL', 'No gullies found without arc_id (outlet) values.', '[gw_fct_pg2epa_check_result_swmm]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(402, 'Check controls for ARC', 'utils', NULL, 'core', true, 'Check epa-result', NULL, 3, 'Controls with links (arc o nodarc) are not present on this result.', NULL, NULL, 'SELECT * FROM (SELECT a.id, a.arc_id as controls, b.arc_id as templayer FROM 
(SELECT substring(split_part(text,''LINK'', 2) FROM ''[^ ]+''::text) arc_id, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_arc b USING (arc_id)
WHERE b.arc_id IS NULL AND a.arc_id IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a', 'All Controls has correct LINK id values.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(401, 'Y0 higger than ymax on nodes)', 'ud', NULL, 'core', true, 'Check epa-result', NULL, 3, 'nodes with y0 higger then ymax.', NULL, NULL, 'SELECT * FROM temp_t_node WHERE y0 > ymax', 'All nodes has y0 lower than ymax.', '[gw_fct_pg2epa_check_result]', true);
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(406, 'Check controls for NODE', 'utils', NULL, 'core', true, 'Check om-data', NULL, 3, 'Controls with nodes are not present on this result.', NULL, NULL, '
SELECT * FROM (SELECT a.id, a.node_id as controls, b.node_id as templayer FROM 
(SELECT substring(split_part(text,''NODE '', 2) FROM ''[^ ]+''::text) node_id, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_node b USING (node_id)
WHERE b.node_id IS NULL AND a.node_id IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a', 'All Controls has correct node id values.', '[gw_fct_pg2epa_check_result]', true);

-- 10/02/2026
UPDATE sys_fprocess SET query_text='WITH intervals AS (
    SELECT DISTINCT ON (timser_id)
        timser_id,
        date_trunc(
		    ''minute'',
		    COALESCE(
		        "time"::time - LAG("time"::time) OVER (
		            PARTITION BY timser_id
		            ORDER BY "time"::time
		        ),
		        INTERVAL ''0 minute''
		    )
		) AS interval_time
    FROM inp_timeseries_value
    WHERE "time" IS NOT NULL
    ORDER BY timser_id, interval_time DESC
)
SELECT *
FROM intervals i
JOIN raingage r
    ON i.timser_id = r.timser_id
WHERE r.intvl::time > i.interval_time' WHERE fid=644;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4548, 'Default values: %v_defaultval%', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4550, 'Default values: No default values used', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4552, 'Advanced settings: %v_advancedval%', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4554, 'Advanced settings: No advanced settings used', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4556, 'Debug: %v_defaultval%', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4558, 'Enabled set all raingages with ONLY ONE timeseries: %v_setallraingages%', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4560,'Created by: %v_createdby% on %v_date%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4562,'Export mode: %v_exportmodeval%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4564,'Hidrology scenario: %v_hydroscenarioval%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4566,'DWF scenario: %v_dwfscenarioval%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4568,'Dump subcatchments: %v_dumpsubc%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4570,'Active Workspace: %v_workspace%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4572,'Number of dscenarios used: %v_dscenarioused%',0,'utils','core','AUDIT');
INSERT INTO sys_message (id,error_message,log_level,project_type,"source",message_type)
VALUES (4574,'Number of psectors used: %v_psectorused%',0,'utils','core','AUDIT');
