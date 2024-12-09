/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

UPDATE sys_fprocess SET fprocess_name='Gully without link', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=NULL, except_msg='gullys without links or gullies over arc without arc_id.', except_msg_feature=NULL, query_text='SELECT gully_id, gullycat_id, c.the_geom, c.expl_id from v_prefix_gully c WHERE c.state= 1 
AND gully_id NOT IN (SELECT feature_id FROM link)
EXCEPT 
SELECT gully_id, gullycat_id, c.the_geom, c.expl_id FROM v_prefix_gully c
LEFT JOIN v_prefix_arc a USING (arc_id) WHERE c.state= 1 
AND arc_id IS NOT NULL AND st_dwithin(c.the_geom, a.the_geom, 0.1)', info_msg='All gullies have links or are over arc with arc_id.', function_name='[gw_fct_om_check_data]' where fid=541;

UPDATE sys_fprocess SET  fprocess_name='feature which id is not an integer', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='which id is not an integer. Please, check your data before continue', except_msg_feature=NULL, query_text='SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)
ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat,the_geom, expl_id  FROM arc
UNION SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)
ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat,the_geom, expl_id FROM node
UNION SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)
ELSE 0 END as feature_id, ''CONNEC'' as type, conneccat_id as featurecat,the_geom, expl_id FROM connec
UNION SELECT CASE WHEN gully_id~E''^\\d+$'' THEN CAST (gully_id AS INTEGER)
ELSE 0 END as feature_id, ''GULLY'' as type, gullycat_id as featurecat,the_geom, expl_id FROM gully', info_msg='All features with id integer.', function_name='[gw_fct_om_check_data]' WHERE fid=542;

UPDATE sys_fprocess SET fprocess_name='Gully chain with different arc_id than the final connec/gully', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=NULL, except_msg='chained connecs/gullys without links or gullies over arc without arc_id.', except_msg_feature=NULL, query_text='with c as (
Select v_prefix_connec.connec_id as id, arc_id as arc, v_prefix_connec.conneccat_id as 
feature_catalog, the_geom, v_prefix_connec.expl_id from v_prefix_connec
UNION select v_prefix_gully.gully_id as id, arc_id as arc, v_prefix_gully.gullycat_id, 
the_geom, v_prefix_gully.expl_id  from v_prefix_gully
)
select c1.id, c1.feature_catalog, c1.the_geom,  c1.expl_id
from link a
left join c c1 on a.feature_id = c1.id
left join c c2 on a.exit_id = c2.id
where (a.exit_type =''CONNEC'' OR a.exit_type =''GULLY'')
and c1.arc <> c2.arc', info_msg='All chained connecs and gullies have the same arc_id.', function_name='[gw_fct_om_check_data]' WHERE fid=543;

UPDATE sys_fprocess SET fprocess_name='State not according with state_type', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with state without concordance with state_type. Please, check your data before continue features with state without concordance with state_type. Please, check your data before continue', except_msg_feature=NULL, query_text='SELECT arc_id as id, a.state, state_type FROM v_prefix_arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT node_id as id, a.state, state_type FROM v_prefix_node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT connec_id as id, a.state, state_type FROM v_prefix_connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT gully_id as id, a.state, state_type FROM v_prefix_gully a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
UNION SELECT element_id as id, a.state, state_type FROM v_prefix_element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state', info_msg='No features without concordance against state and state_type.', function_name='[gw_fct_om_check_data]' WHERE fid=545;

UPDATE sys_fprocess SET fprocess_name='Check fluid_type values exists on man_ table', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with fluid_type does not exists on man_type_fluid table.', except_msg_feature=NULL, query_text='SELECT ''ARC'', arc_id, fluid_type FROM v_prefix_arc WHERE fluid_type NOT IN (SELECT fluid_type FROM man_type_fluid WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND fluid_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, fluid_type FROM v_prefix_node WHERE fluid_type NOT IN (SELECT fluid_type FROM man_type_fluid WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND fluid_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, fluid_type FROM v_prefix_connec WHERE fluid_type NOT IN (SELECT fluid_type FROM man_type_fluid WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND fluid_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, fluid_type FROM v_prefix_gully WHERE fluid_type NOT IN (SELECT fluid_type FROM man_type_fluid WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND fluid_type IS NOT NULL', info_msg='All features has fluid_type informed on man_type_fluid table', function_name='[gw_fct_om_check_data]' WHERE fid=547;

UPDATE sys_fprocess SET fprocess_name='Check orphan elements', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Function process', addparam=NULL, except_level=2, except_msg='elements not related to any feature and without geometry.', except_msg_feature=NULL, query_text='select element_id, the_geom from element where the_geom is null and element_id not in (
with mec as (select distinct element_id from element_x_arc UNION
select distinct element_id from element_x_connec UNION
select distinct element_id from element_x_node UNION
select distinct element_id from element_x_gully)
select a.element_id from mec a left join "element" b using (element_id))', info_msg='All elements are related to the features or have geometry.', function_name='[gw_fct_om_check_data]' WHERE fid=548;

UPDATE sys_fprocess SET fprocess_name='Node orphan with isarcdivide=TRUE (OM)', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-topology', addparam=NULL, except_level=2, except_msg='orphan nodes with isarcdivide=TRUE.', except_msg_feature=NULL, query_text='SELECT * FROM v_prefix_node a JOIN cat_feature_node ON id = a.node_type WHERE a.state>0 AND isarcdivide= ''true'' 
AND (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0', info_msg='There are no orphan nodes with isarcdivide=TRUE', function_name='[gw_fct_om_check_data]' WHERE fid=549;

UPDATE sys_fprocess SET fprocess_name='Check function_type values exists on man_ table', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with function_type does not exists on man_type_function table.', except_msg_feature=NULL, query_text='SELECT ''ARC'', arc_id, function_type FROM v_prefix_arc WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, function_type FROM v_prefix_node WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, function_type FROM v_prefix_connec WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, function_type FROM v_prefix_gully WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL', info_msg='All features has function_type informed on man_type_function table', function_name='[gw_fct_om_check_data]' WHERE fid=550;

UPDATE sys_fprocess SET fprocess_name='Features state=1 and end date', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='features on service with value of end date.', except_msg_feature=NULL, query_text='SELECT arc_id as feature_id from v_prefix_arc where state = 1 and enddate is not null
UNION SELECT node_id as feature_id from v_prefix_node where state = 1 and enddate is not null
UNION SELECT connec_id as feature_id from v_prefix_connec where state = 1 and enddate is not null
UNION SELECT gully_id as feature_id from v_prefix_gully where state = 1 and enddate is not null', info_msg='No features on service have value of end date', function_name='[gw_fct_om_check_data]' WHERE fid=551;

UPDATE sys_fprocess SET fprocess_name='Check orphan documents', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Function process', addparam=NULL, except_level=2, except_msg='documents not related to any feature.', except_msg_feature=NULL, query_text='select id from doc where id not in (
select distinct  doc_id from doc_x_arc UNION
select distinct  doc_id from doc_x_connec UNION
select distinct  doc_id from doc_x_node UNION
select distinct  doc_id from doc_x_gully)', info_msg='All documents are related to the features.', function_name='[gw_fct_om_check_data]' WHERE fid=564;

UPDATE sys_fprocess SET fprocess_name='Gully without or with wrong arc_id', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='gullies without or with incorrect arc_id.', except_msg_feature=NULL, query_text='SELECT c.gully_id, c.gullycat_id, c.the_geom, c.expl_id, l.feature_type, link_id 
FROM arc a, link l
JOIN v_prefix_gully c ON l.feature_id = c.gully_id 
WHERE st_dwithin(a.the_geom, st_endpoint(l.the_geom), 0.01)
AND exit_type = ''ARC''
AND (a.arc_id <> c.arc_id or c.arc_id is null) 
AND l.feature_type = ''GULLY'' AND a.state=1 and c.state = 1 and l.state=1
EXCEPT
SELECT c.gully_id, c.gullycat_id, c.the_geom, c.expl_id, l.feature_type, link_id
FROM node n, link l
JOIN v_prefix_gully c ON l.feature_id = c.gully_id 
WHERE st_dwithin(n.the_geom, st_endpoint(l.the_geom), 0.01)
AND exit_type IN (''NODE'', ''ARC'')
AND l.feature_type = ''GULLY'' AND n.state=1 and c.state = 1 and l.state=1
ORDER BY feature_type, link_id', info_msg='All gullies have correct arc_id.', function_name='[gw_fct_om_check_data]' WHERE fid=552;

UPDATE sys_fprocess SET fprocess_name='Features with code null', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with code with NULL values. Please, check your data before continue with code with NULL values. Please, check your data before continue', except_msg_feature=NULL, query_text='SELECT arc_id, arccat_id, the_geom FROM v_prefix_arc WHERE code IS NULL 
UNION SELECT node_id, nodecat_id, the_geom FROM v_prefix_node WHERE code IS NULL
UNION SELECT connec_id, conneccat_id, the_geom FROM v_prefix_connec WHERE code IS NULL
UNION SELECT gully_id, gullycat_id, the_geom FROM v_prefix_gully WHERE code IS NULL
UNION SELECT element_id, elementcat_id, the_geom FROM v_prefix_element WHERE code IS NULL', info_msg='No features (arc, node, connec, element, gully) with NULL values on code found.', function_name='[gw_fct_om_check_data]' WHERE fid=553;

UPDATE sys_fprocess SET fprocess_name='Features state=0 without end date', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='features with state 0 without value of end date.', except_msg_feature=NULL, query_text='SELECT arc_id as feature_id from v_prefix_arc where state = 0 and enddate is null
UNION SELECT node_id from v_prefix_node where state = 0 and enddate is null
UNION SELECT connec_id from v_prefix_connec where state = 0 and enddate is null
UNION SELECT gully_id from v_prefix_gully where state = 0 and enddate is null', info_msg='No features with state 0 are missing the end date', function_name='[gw_fct_om_check_data]' WHERE fid=554;

UPDATE sys_fprocess SET fprocess_name='Check connecs with more than 1 link on service', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='connecs with more than 1 link on service', except_msg_feature=NULL, query_text='SELECT connec_id, conneccat_id, the_geom, expl_id FROM v_prefix_connec WHERE connec_id 
IN (SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)
UNION SELECT gully_id, gullycat_id, the_geom, expl_id FROM v_prefix_gully WHERE gully_id 
IN (SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)', info_msg='No connects with more than 1 link on service', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=555;

UPDATE sys_fprocess SET  fprocess_name='Check orphan visits', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Function process', addparam=NULL, except_level=2, except_msg='visits not related to any feature and without geometry.', except_msg_feature=NULL, query_text='select id, the_geom from om_visit where the_geom is null and id not in (
with mec as (
select distinct visit_id from om_visit_x_arc UNION
select distinct visit_id from om_visit_x_connec UNION
select distinct visit_id from om_visit_x_node UNION
select distinct visit_id from om_visit_x_gully)
select a.visit_id from mec a left join om_visit b on a.visit_id = id
)', info_msg='All visits are related to the features or have geometry.', function_name='[gw_fct_om_check_data]' WHERE fid=556;

UPDATE sys_fprocess SET fprocess_name='Builddate before 1900', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='features with built date before 1900.', except_msg_feature=NULL, query_text='SELECT arc_id, ''ARC''::text FROM v_prefix_arc WHERE builtdate < ''1900/01/01''::date
UNION 
SELECT  node_id, ''NODE''::text FROM v_prefix_node WHERE builtdate < ''1900/01/01''::date
UNION  
SELECT  connec_id, ''CONNEC''::text FROM v_prefix_connec WHERE builtdate < ''1900/01/01''::date
UNION 
SELECT  gully_id, ''GULLY''::text FROM v_prefix_gully WHERE builtdate < ''1900/01/01''::date', info_msg='No feature with builtdate before 1900.', function_name='[gw_fct_om_check_data]' WHERE fid=557;

UPDATE sys_fprocess SET fprocess_name='Check location_type values exists on man_ table', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with location_type does not exists on man_type_location table.', except_msg_feature=NULL, query_text='SELECT ''ARC'', arc_id, location_type FROM v_prefix_arc WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, location_type FROM v_prefix_node WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, location_type FROM v_prefix_connec WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, location_type FROM v_prefix_gully WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL', info_msg='All features has location_type informed on man_type_location table', function_name='[gw_fct_om_check_data]' WHERE fid=558;

UPDATE sys_fprocess SET fprocess_name='Planned connecs without reference link', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='planned connecs without reference link planned connecs or gullys without reference link', except_msg_feature=NULL, query_text='SELECT * FROM plan_psector_x_connec WHERE link_id IS NULL
UNION SELECT * FROM plan_psector_x_gully WHERE link_id IS NULL', info_msg='All planned connecs or gullys have a reference link', function_name='[gw_fct_om_check_data]' WHERE fid=559;

UPDATE sys_fprocess SET fprocess_name='Duplicated ID between arc, node, connec, gully', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with duplicated ID value between arc, node, connec, gully features with duplicated ID values between arc, node, connec, gully', except_msg_feature=NULL, query_text='SELECT * FROM (SELECT node_id FROM node UNION ALL SELECT arc_id FROM arc UNION ALL SELECT connec_id FROM connec UNION ALL SELECT gully_id FROM gully)a 
group by node_id having count(*) > 1', info_msg='All features have a diferent ID to be correctly identified', function_name='[gw_fct_om_check_data]' WHERE fid=561;

UPDATE sys_fprocess SET fprocess_name='Features state=2 are involved in psector', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check plan-config', addparam=NULL, except_level=3, except_msg='planified arcs without psector. planified nodes without psector. planified connecs without psector. planified gullys without psector. features with state=2 without psector assigned. Please, check your data before continue', except_msg_feature=NULL, query_text='SELECT a.arc_id FROM v_prefix_arc a RIGHT JOIN plan_psector_x_arc USING (arc_id) WHERE a.state = 2 AND a.arc_id IS NULL
UNION
SELECT a.node_id FROM v_prefix_node a RIGHT JOIN plan_psector_x_node USING (node_id) WHERE a.state = 2 AND a.node_id IS NULL
UNION
SELECT a.connec_id FROM v_prefix_connec a RIGHT JOIN plan_psector_x_connec USING (connec_id) WHERE a.state = 2 AND a.connec_id IS NULL
UNION 
SELECT a.gully_id FROM v_prefix_gully a RIGHT JOIN plan_psector_x_gully USING (gully_id) WHERE a.state = 2 AND a.gully_id IS NULL', info_msg='There are no features with state=2 without psector.', function_name='[gw_fct_plan_check_data]' WHERE fid=562;

UPDATE sys_fprocess SET fprocess_name='Connec or gully with different expl_id than arc', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='connecs with exploitation different than the exploitation of the related arc', except_msg_feature=NULL, query_text='SELECT DISTINCT connec_id, conneccat_id, c.the_geom, c.expl_id FROM v_prefix_connec c JOIN v_prefix_arc b using (arc_id) 
WHERE b.expl_id::text != c.expl_id::text
UNION 
SELECT DISTINCT  gully_id, gullycat_id, g.the_geom gully_id, g.expl_id FROM v_prefix_gully g JOIN v_prefix_arc d using (arc_id) WHERE d.expl_id::text != g.expl_id::text', info_msg='All connecs or gullys have the same exploitation as the related arc', function_name='[gw_fct_om_check_data]' WHERE fid=563;

UPDATE sys_fprocess SET fprocess_name='Node orphan with isarcdivide=FALSE (OM)', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-topology', addparam=NULL, except_level=2, except_msg='orphan nodes with isarcdivide=FALSE.', except_msg_feature=NULL, query_text='SELECT * FROM v_prefix_node a JOIN cat_feature_node ON id = a.node_type WHERE a.state>0 AND isarcdivide=''false''', info_msg='There are no orphan nodes with isarcdivide=FALSE', function_name='[gw_fct_om_check_data]' WHERE fid=565;

UPDATE sys_fprocess SET fprocess_name='Features state=1 and end date before start date', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='features with end date earlier than built date.', except_msg_feature=NULL, query_text='SELECT arc_id as feature_id from v_prefix_arc where enddate < builtdate and state = 1
UNION SELECT node_id from v_prefix_node where enddate < builtdate and state = 1
UNION SELECT connec_id from v_prefix_connec where enddate < builtdate and state = 1
UNION SELECT gully_id from v_prefix_gully where enddate < builtdate and state = 1', info_msg='No features with end date earlier than built date', function_name='[gw_fct_om_check_data]' WHERE fid=566;

UPDATE sys_fprocess SET fprocess_name='Check features without defined sector_id', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=2, except_msg='connecs with sector_id 0 or -1.', except_msg_feature=NULL, query_text='SELECT connec_id, conneccat_id, the_geom, expl_id FROM v_prefix_connec WHERE state > 0 AND (sector_id=0 OR sector_id=-1)
UNION SELECT gully_id, gullycat_id, the_geom, expl_id FROM v_prefix_gully WHERE state > 0 AND (sector_id=0 OR sector_id=-1)', info_msg='No connecs with 0 or -1 value on sector_id.', function_name='[gw_fct_om_check_data]' WHERE fid=567;

UPDATE sys_fprocess SET fprocess_name='Check category_type values exists on man_ table', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=3, except_msg='features with category_type does not exists on man_type_category table.', except_msg_feature=NULL, query_text='SELECT ''ARC'', arc_id, category_type FROM v_prefix_arc WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, category_type FROM v_prefix_node WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, category_type FROM v_prefix_connec WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, category_type FROM v_prefix_gully WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL', info_msg='All features has category_type informed on man_type_category table', function_name='[gw_fct_om_check_data]' WHERE fid=568;

UPDATE sys_fprocess SET fprocess_name='Check matcat null for arcs', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-config', addparam=NULL, except_level=3, except_msg='arcs without matcat_id informed.', except_msg_feature=NULL, query_text='SELECT * FROM selector_sector s, v_edit_arc a JOIN cat_arc c ON c.id = a.matcat_id  
WHERE a.sector_id = s.sector_id and cur_user=current_user 
AND a.matcat_id IS NULL AND sys_type !=''VARC''', info_msg='All arcs have matcat_id filled.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=569;

UPDATE sys_fprocess SET fprocess_name='Check for inp_arc tables and epa_type consistency', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='arcs features with epa_type not according with epa table. Check your data before continue.', except_msg_feature=NULL, query_text='SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_pump table'') AS epa_table, a.the_geom FROM v_edit_inp_pump JOIN arc a USING (arc_id) WHERE epa_type !=''PUMP''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_conduit table'') AS epa_table, a.the_geom FROM v_edit_inp_conduit JOIN arc a USING (arc_id) WHERE epa_type !=''CONDUIT''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_outlet table'') AS epa_table, a.the_geom FROM v_edit_inp_outlet JOIN arc a USING (arc_id) WHERE epa_type !=''OUTLET''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_orifice table'') AS epa_table, a.the_geom FROM v_edit_inp_orifice JOIN arc a USING (arc_id) WHERE epa_type !=''ORIFICE''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_weir table'') AS epa_table, a.the_geom FROM v_edit_inp_weir JOIN arc a USING (arc_id) WHERE epa_type !=''WEIR''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_virtual table'') AS epa_table, a.the_geom FROM v_edit_inp_virtual JOIN arc a USING (arc_id) WHERE epa_type !=''VIRTUAL''', info_msg='Epa type for arcs features checked. No inconsistencies aganints epa table found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=570;

UPDATE sys_fprocess SET fprocess_name='Arcs less than 20 cm.', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-topology', addparam=NULL, except_level=2, except_msg='pipes with length less than node proximity distance configured.', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_inp_conduit WHERE st_length(the_geom) < (SELECT value::json->>''value'' FROM config_param_system WHERE parameter = ''edit_node_proximity'')::float', info_msg='Standard minimun length checked. No values less than node proximity distance configured.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=571;

UPDATE sys_fprocess SET fprocess_name='arcs less than 5 cm.', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-topology', addparam=NULL, except_level=3, except_msg='conduits with length less than configured minimum length.', except_msg_feature=NULL, query_text='SELECT the_geom, st_length(the_geom) AS length FROM v_edit_inp_conduit WHERE st_length(the_geom) < (SELECT value FROM config_param_system WHERE parameter = ''epa_arc_minlength'')::float', info_msg='Critical minimun length checked. No values less than configured minimum length found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=572;

UPDATE sys_fprocess SET fprocess_name='Check outlet_id existance in inp_subcatchment and inp_junction', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='non-existing outlet_id related to subcatchment.', except_msg_feature=NULL, query_text='select outlet_id from v_edit_inp_subc2outlet
LEFT JOIN (
select node_id from v_edit_inp_junction 
UNION select node_id from v_edit_inp_outfall
UNION select node_id from v_edit_inp_storage 
UNION select node_id from v_edit_inp_netgully
) a on outlet_id = node_id
where outlet_type in (''JUNCTION'') and node_id is null
union
select a.outlet_id from v_edit_inp_subc2outlet a LEFT JOIN v_edit_inp_subcatchment s on a.outlet_id = s.subc_id
where outlet_type = ''SUBCATCHMENT'' and s.subc_id is null', info_msg='All subcatchments have an existing outlet_id', function_name='[gw_fct_pg2epa_check_data]' WHERE  fid=528;

UPDATE sys_fprocess SET fprocess_name='Check geom1 with null values on arc catalog', project_type='utils', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='rows on arc catalog without values on shape column.', except_msg_feature=NULL, query_text='SELECT * FROM cat_arc WHERE geom1 is null', info_msg='No rows on arc catalog without values on geom1 column.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=582;

UPDATE sys_fprocess SET fprocess_name='Missing data on inp tables', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='missed features on inp tables. Please, check your data before continue', except_msg_feature=NULL, query_text='SELECT arc_id, ''arc'' as feature_tpe FROM arc JOIN
(select arc_id from inp_conduit UNION select arc_id from inp_virtual UNION select arc_id from inp_weir UNION select arc_id from inp_pump UNION select arc_id from inp_outlet UNION select arc_id from inp_orifice) a
USING (arc_id) 
WHERE state > 0 AND epa_type !=''UNDEFINED'' AND a.arc_id IS NULL
UNION
SELECT node_id, ''node'' FROM node JOIN
(select node_id from inp_junction UNION select node_id from inp_storage UNION select node_id from inp_outfall UNION select node_id from inp_divider) a
USING (node_id) 
WHERE state > 0 AND epa_type !=''UNDEFINED'' AND a.node_id IS NULL', info_msg='No features missed on inp_tables found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=583;

UPDATE sys_fprocess SET fprocess_name='y0 on storage data', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='storages with null values at least on mandatory columns for initial status (y0).', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_inp_storage where (y0 is null)', info_msg='No y0 column without values for storages.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=573;

UPDATE sys_fprocess SET fprocess_name='Check missed values for storage volume', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='storages with null values at least on mandatory columns to define volume parameters (a1,a2,a0 for FUNCTIONAL or curve_id for TABULAR).', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_inp_storage where (a1 is null and a2 is null and a0 is null AND storage_type=''FUNCTIONAL'') OR (curve_id IS NULL AND storage_type=''TABULAR'')', info_msg='Mandatory colums for volume values used on storage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=574;

UPDATE sys_fprocess SET fprocess_name='Check missed values for cat_mat.arc n used on real arcs', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-config', addparam=NULL, except_level=3, except_msg='materials with null values on manning coefficient column used on a real arc wich manning is needed.', except_msg_feature=NULL, query_text='SELECT DISTINCT cat_mat_arc.* FROM cat_mat_arc JOIN v_edit_arc ON matcat_id = id where sys_type !=''VARC'' AND n is null', info_msg='Manning coefficient on cat_mat_arc is filled for those materials used on real arcs (not varcs).', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=575;

UPDATE sys_fprocess SET fprocess_name='Check flow regulator length fits on destination arc (orifice)', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='orifice flow regulator wich his length do not respect the minimum length for target arc.', except_msg_feature=NULL, query_text='SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_flwreg_orifice f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id 
AND cur_user=current_user AND 
flwreg_length + (SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', info_msg='All orifice flow regulators has lengh wich fits target arc.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=576;

UPDATE sys_fprocess SET fprocess_name='Check flow regulator length fits on destination arc (weir)', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='weir flow regulator length do not respect the minimum length for target arc', except_msg_feature=NULL, query_text='SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_flwreg_weir f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', info_msg='All weir flow regulators has lengh wich fits target arc.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=577;

UPDATE sys_fprocess SET fprocess_name='Check flow regulator length fits on destination arc (outlet)', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='outlet flow regulator length do not respect the minimum length for target arc', except_msg_feature=NULL, query_text='SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_flwreg_pump f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', info_msg='All outlet flow regulators has lengh wich fits target arc.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=578;

UPDATE sys_fprocess SET fprocess_name='Check flow regulator length fits on destination arc (pump)', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='pump flow regulator length do not respect the minimum length for target arc.', except_msg_feature=NULL, query_text='SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_flwreg_pump f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', info_msg='All pump flow regulators has lengh wich fits target arc.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=579;

UPDATE sys_fprocess SET fprocess_name='Check valid relative timeseries', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='columns on relative timeserires related to this exploitation with errors.', except_msg_feature=NULL, query_text='SELECT id, a.timser_id, case when a.time is not null then a.time end as time FROM v_edit_inp_timeseries_value a 
JOIN (SELECT id-1 as id, timser_id, case when time is not null then time end as time FROM v_edit_inp_timeseries_value)b USING (id) where a.time::time - b.time::time > ''0 seconds'' AND a.timser_id = b.timser_id', info_msg='All relative timeseries related ot this exploitation are correctly defined.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=580;

UPDATE sys_fprocess SET fprocess_name='Node exit upper intro', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Function process', addparam=NULL, except_level=2, except_msg='junctions with exits upper intro', except_msg_feature=NULL, query_text='SELECT node_id, nodecat_id, expl_id, a.the_geom 
	FROM ( SELECT node_id, max(sys_elev1) AS max_exit, nodecat_id, node.expl_id, node.the_geom FROM v_edit_arc JOIN node ON node_1 = node_id JOIN cat_feature_node ON node_type = id
	WHERE isexitupperintro = 0 GROUP BY node_id, node.expl_id )a
	JOIN ( SELECT node_id, max(sys_elev2) AS max_entry FROM v_edit_arc JOIN node ON node_2 = node_id JOIN cat_feature_node ON node_type = id WHERE isexitupperintro = 0 GROUP BY node_id )b USING (node_id)
	JOIN selector_expl USING (expl_id) 
	WHERE max_entry < max_exit AND cur_user = current_user', info_msg='Any junction have been detected with exits upper intro.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=111;

UPDATE sys_fprocess SET fprocess_name='Node sink', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Function process', addparam=NULL, except_level=2, except_msg='junctions type sink which means that junction only have entry arcs without any exit arc (FORCE_MAIN is not valid).', except_msg_feature=NULL, query_text='SELECT node_id, nodecat_id, expl_id, v_edit_node.the_geom, ''Node sink'' FROM v_edit_node WHERE epa_type !=''UNDEFINED'' AND node_id IN
	(SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope < 0 AND s.epa != ''FORCE_MAIN'')a
	EXCEPT 
	SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope > 0)a)', info_msg='Any junction have been swiched on the fly to OUTFALL.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=113;

UPDATE sys_fprocess SET fprocess_name='Conduits with negative slope and inverted slope', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-topology', addparam=NULL, except_level=3, except_msg='arcs with inverted slope false and slope negative values. Please, check your data before continue', except_msg_feature=NULL, query_text='SELECT a.arc_id, arccat_id, a.the_geom, expl_id FROM arc a WHERE sys_slope < 0 AND state > 0 AND inverted_slope IS FALSE', info_msg='No arcs with inverted slope checked found.', function_name='[gw_fct_om_check_data]' WHERE fid=251;


UPDATE sys_fprocess SET fprocess_name='Orphan polygons', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-topology', addparam=NULL, except_level=2, except_msg='polygons without parent. Check your data before continue. polygons without parent. Check your data before continue.', except_msg_feature=NULL, query_text='SELECT pol_id FROM polygon WHERE feature_id IS NULL OR feature_id NOT IN (SELECT gully_id FROM gully UNION
SELECT node_id FROM node UNION SELECT connec_id FROM connec)', info_msg='No polygons without parent feature found.', function_name='[gw_fct_om_check_data]' WHERE fid=255;

UPDATE sys_fprocess SET fprocess_name='Arcs without elevation', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='arcs without values on sys_elev1 or sys_elev2.', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE cur_user = current_user AND sys_elev1 = NULL OR sys_elev2 = NULL', info_msg='No arcs with null values on field elevation (sys_elev1 or sys_elev2) have been found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=284;

UPDATE sys_fprocess SET fprocess_name='Null values on raingage', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='raingages with null values at least on mandatory columns for rain type (form_type, intvl, rgage_type).', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_raingage where (form_type is null) OR (intvl is null) OR (rgage_type is null)', info_msg='Mandatory colums for raingage (form_type, intvl, rgage_type) have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=285;

UPDATE sys_fprocess SET fprocess_name='Null values on raingage timeseries', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='raingages with null values on the mandatory column for ''TIMESERIES'' raingage type', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_raingage where rgage_type=''TIMESERIES'' AND timser_id IS NULL', info_msg='Mandatory colums for ''TIMESERIES'' raingage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=286;

UPDATE sys_fprocess SET fprocess_name='Null values on raingage file', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='raingages with null values at least on mandatory columns for ''FILE'' raingage type (fname, sta, units).', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_raingage where rgage_type=''FILE'' AND (fname IS NULL or sta IS NULL or units IS NULL)', info_msg='Mandatory colums (fname, sta, units) for ''FILE'' raingage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=287;

UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isexitupperintro', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check admin', addparam=NULL, except_level=3, except_msg='nodes without value on field "isexitupperintro" from cat_feature_node.', except_msg_feature=NULL, query_text='SELECT * FROM cat_feature_node WHERE isexitupperintro IS NULL', info_msg='All nodes have value on field "isexitupperintro"', function_name='[gw_fct_admin_check_data]' WHERE fid=308;

UPDATE sys_fprocess SET fprocess_name='Check cat_node field estimated_y', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check plan-config', addparam=NULL, except_level=2, except_msg='rows without values on cat_node.estimated_y column.', except_msg_feature=NULL, query_text='SELECT * FROM cat_node WHERE estimated_y IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.estimated_y column.', function_name='[gw_fct_plan_check_data]' WHERE fid=331;

UPDATE sys_fprocess SET fprocess_name='Check cat_gully field active', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check plan-config', addparam=NULL, except_level=3, except_msg='rows without values on cat_gully.active column.', except_msg_feature=NULL, query_text='SELECT * FROM cat_gully WHERE active IS NULL', info_msg='There is/are no rows without values on cat_gully.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=344;

UPDATE sys_fprocess SET fprocess_name='Check outlet_id assigned to subcatchments', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-config', addparam=NULL, except_level=3, except_msg='outlets defined on subcatchments view, that are not present on junction, outfall, storage, divider or subcatchment view.', except_msg_feature=NULL, query_text='WITH query AS (SELECT * FROM 
(SELECT subc_id, outlet_id, st_centroid(the_geom) as the_geom from v_edit_inp_subcatchment where left(outlet_id::text, 1) != ''{''::text 
	UNION
	SELECT subc_id, unnest(outlet_id::text[]), st_centroid(the_geom) from v_edit_inp_subcatchment where left(outlet_id::text, 1) = ''{''::text
	)a WHERE outlet_id not in (
		select node_id FROM v_edit_inp_junction UNION 
		select node_id FROM v_edit_inp_outfall UNION
		select node_id FROM v_edit_inp_storage UNION 
		select node_id FROM v_edit_inp_divider UNION
		select subc_id FROM v_edit_inp_subcatchment
	))
	SELECT q1.*, u.expl_id FROM query q1 
		LEFT JOIN 
		(SELECT * FROM (
		SELECT 440, subc_id, outlet_id, the_geom from v_edit_inp_subcatchment where left(outlet_id::text, 1) != ''{''::text 
		UNION
		SELECT 440, subc_id, unnest(outlet_id::text[]), the_geom AS outlet_id from v_edit_inp_subcatchment 
		where left(outlet_id::text, 1) = ''{''::text)a)b
		USING (outlet_id) 
		left join node u on q1.outlet_id = u.node_id
		WHERE b.subc_id IS NULL', info_msg='All outlets set on subcatchments are correctly defined.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=440;

UPDATE sys_fprocess SET fprocess_name='Check redundant values on y-top_elev-elev', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-topology', addparam=NULL, except_level=NULL, except_msg='nodes with redundancy on ymax, top_elev & elev values.', except_msg_feature=NULL, query_text='SELECT node_id, nodecat_id, the_geom, expl_id FROM v_prefix_node WHERE (ymax is not null or custom_ymax is not null) 
and (top_elev is not null or custom_top_elev is not null) and (elev is not null or custom_elev is not null)', info_msg='There are no nodes with redundancy on ymax, top_elev & elev values.', function_name='[gw_fct_om_check_data]' WHERE fid=461;

UPDATE sys_fprocess SET fprocess_name='Links without gully on startpoint', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check om-data', addparam=NULL, except_level=NULL, except_msg='links with wrong topology. Startpoint does not fit with connec.', except_msg_feature=NULL, query_text='with subq1 as (SELECT l.link_id, c.connec_id, c.the_geom FROM connec c, link l
WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC)
select connec_id, the_geom From subq1 where connec_id not in (select connec_id from connec)', info_msg='All connec links has connec on startpoint', function_name='[gw_fct_om_check_data]' WHERE fid=418;

UPDATE sys_fprocess SET fprocess_name='Check outfalls with more than 1 arc', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Function process', addparam=NULL, except_level=NULL, except_msg='outfalls with more than 1 arc.', except_msg_feature=NULL, query_text='select node.node_id, node.the_geom, node.expl_id, node.nodecat_id 
from node, arc where node.epa_type=''OUTFALL'' and st_dwithin(node.the_geom, arc.the_geom, 0.01) 
group by node.node_id having count(node.node_id)>1', info_msg='All outfalls have a valid number of connected arcs.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=522;

UPDATE sys_fprocess SET fprocess_name='Check missing data in Inp Weir', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='values missing on some data of Inp Weir (weir_type, cd, geom1, geom2, offsetval)', except_msg_feature=NULL, query_text='SELECT  arc_id,  the_geom from v_edit_inp_weir 
		where weir_type is null or cd is null or geom1 is null or geom2 is null or offsetval is null', info_msg='No missing data on Inp Weir.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=529;

UPDATE sys_fprocess SET fprocess_name='Check missing data in Inp Orifice', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='values missing on some data of Inp Orifice (ori_type, geom1, offsetval)', except_msg_feature=NULL, query_text='SELECT arc_id, the_geom from v_edit_inp_orifice
where ori_type is null or geom1 is null or offsetval is null', info_msg='No missing data on Inp Orifice.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=530;

UPDATE sys_fprocess SET fprocess_name='Check outlet_id existance in inp_subcatchment and inp_junction', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='non-existing outlet_id related to subcatchment.', except_msg_feature=NULL, query_text='select outlet_id from v_edit_inp_subc2outlet
LEFT JOIN (
select node_id from v_edit_inp_junction 
UNION select node_id from v_edit_inp_outfall
UNION select node_id from v_edit_inp_storage 
UNION select node_id from v_edit_inp_netgully
) a on outlet_id = node_id
where outlet_type in (''JUNCTION'') and node_id is null
union
select a.outlet_id from v_edit_inp_subc2outlet a LEFT JOIN v_edit_inp_subcatchment s on a.outlet_id = s.subc_id
where outlet_type = ''SUBCATCHMENT'' and s.subc_id is null', info_msg='All subcatchments have an existing outlet_id', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=528;

UPDATE sys_fprocess SET fprocess_name='Nodes without elevation', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='EPA nodes without sys_elevation values.', except_msg_feature=NULL, query_text='SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE epa_type !=''UNDEFINED'' AND sys_elev IS NULL AND cur_user = current_user', info_msg='No nodes with null values on field elevation have been found.', function_name='[gw_fct_pg2epa_check_data]' WHERE  fid=584;

UPDATE sys_fprocess SET fprocess_name='Check that EPA OBJECTS (pollutants) do not contain spaces', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='pollutants have name with spaces. Please fix it!', except_msg_feature=NULL, query_text='SELECT * FROM inp_pollutant WHERE poll_id like''% %''', info_msg='All pollutants checked have names without spaces.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=585;

UPDATE sys_fprocess SET fprocess_name='Check that EPA OBJECTS (snowpacks) do not contain spaces', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='snowpacks have name with spaces. Please fix it!', except_msg_feature=NULL, query_text='SELECT * FROM inp_snowpack WHERE snow_id like''% %''', info_msg='All snowpacks checked have names without spaces.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=586;

UPDATE sys_fprocess SET fprocess_name='Check that EPA OBJECTS (lids) do not contain spaces', project_type='ud', parameters=NULL, "source"='core', isaudit=true, fprocess_type='Check epa-data', addparam=NULL, except_level=3, except_msg='lids have name with spaces. Please fix it!', except_msg_feature=NULL, query_text='SELECT * FROM inp_lid WHERE lidco_id like''% %''', info_msg='All lids checked have names without spaces.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=587;

-- end
delete from sys_fprocess where "source" = 'flag_update';