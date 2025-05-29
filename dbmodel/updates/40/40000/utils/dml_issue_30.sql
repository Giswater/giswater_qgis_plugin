/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

UPDATE sys_fprocess SET fprocess_name='Arc without start-end nodes', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='arcs with state=1 and without node_1 or node_2.', query_text='SELECT arc_id,arccat_id,the_geom, expl_id FROM v_prefix_arc WHERE state = 1 AND node_1 IS NULL UNION 
SELECT arc_id, arccat_id, the_geom, expl_id FROM v_prefix_arc WHERE state = 1 AND node_2 IS NULL', info_msg='No arc''''s with state=1 and without node_1 or node_2 nodes found.', function_name='[gw_fct_om_check_data]' WHERE fid=103;
UPDATE sys_fprocess SET fprocess_name='Node duplicated', "source"='core', fprocess_type='Check epa-topology', project_type='utils', except_level=3, except_msg='nodes duplicated with state 1.', query_text='SELECT * FROM 
(SELECT DISTINCT t1.node_id AS node_1, t1.nodecat_id AS nodecat_1, t1.state as state1, 
t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 106, t1.the_geom 
FROM v_prefix_node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 1 AND a.state2 = 1', info_msg='There are no nodes duplicated with state 1', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=106;
UPDATE sys_fprocess SET fprocess_name='Node orphan (EPA)', "source"='core', fprocess_type='Check epa-topology', project_type='utils', except_level=2, except_msg='nodes orphans ready-to-export (epa_type & state_type). If they are actually orphan, you could change the epa_type to fix it''', query_text='SELECT node_id, nodecat_id, the_geom, expl_id FROM 
(SELECT node_id FROM v_edit_node EXCEPT (SELECT node_1 as node_id FROM v_edit_arc UNION SELECT node_2 FROM v_edit_arc))a 
JOIN node USING (node_id)   JOIN selector_sector USING (sector_id) JOIN value_state_type v ON state_type = v.id 
WHERE epa_type != ''UNDEFINED'' and is_operative = true and cur_user = current_user and arc_id IS NULL', info_msg='No nodes orphan found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=107;
UPDATE sys_fprocess SET fprocess_name='Node exit upper intro', "source"='core', fprocess_type='Function process', project_type='ud', except_level=2, except_msg='junctions with exits upper intro', query_text='SELECT node_id, nodecat_id, expl_id, a.the_geom 
	FROM ( SELECT node_id, max(sys_elev1) AS max_exit, nodecat_id, node.expl_id, node.the_geom FROM v_edit_arc JOIN node ON node_1 = node_id JOIN cat_feature_node ON node_type = id
	WHERE isexitupperintro = 0 GROUP BY node_id, node.expl_id )a
	JOIN ( SELECT node_id, max(sys_elev2) AS max_entry FROM v_edit_arc JOIN node ON node_2 = node_id JOIN cat_feature_node ON node_type = id WHERE isexitupperintro = 0 GROUP BY node_id )b USING (node_id)
	JOIN selector_expl USING (expl_id) 
	WHERE max_entry < max_exit AND cur_user = current_user', info_msg='Any junction have been detected with exits upper intro.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=111;
UPDATE sys_fprocess SET fprocess_name='Node sink', "source"='core', fprocess_type='Function process', project_type='ud', except_level=2, except_msg='junctions type sink which means that junction only have entry arcs without any exit arc (FORCE_MAIN is not valid).', query_text='SELECT node_id, nodecat_id, expl_id, v_edit_node.the_geom, ''Node sink'' FROM v_edit_node WHERE epa_type !=''UNDEFINED'' AND node_id IN
	(SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope < 0 AND s.epa != ''FORCE_MAIN'')a
	EXCEPT 
	SELECT node_1 FROM (SELECT arc_id, node_1, node_2 FROM v_edit_arc JOIN cat_arc c ON c.id = arccat_id 
	JOIN selector_sector USING (sector_id) JOIN cat_arc_shape s ON c.shape = s.id WHERE slope > 0)a)', info_msg='Any junction have been swiched on the fly to OUTFALL.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=113;
UPDATE sys_fprocess SET fprocess_name='Check dint value for cat_node acting as [SHORTPIPE or VALVE or PUMP]', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=2, except_msg='registers on node''s catalog acting as [SHORTPIPE or VALVE] with dint not defined.''', query_text='SELECT * FROM cat_node WHERE dint IS NULL AND id IN 
(SELECT DISTINCT(nodecat_id) from v_edit_node WHERE epa_type IN (''SHORTPIPE'', ''VALVE''))', info_msg='Dint for node''''s catalog checked. No values missed for SHORTPIPES OR VALVES', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=142;
UPDATE sys_fprocess SET fprocess_name='Inlets with null mandatory values', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='inlets with null values at least on mandatory columns for inlets (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details.', query_text='SELECT * FROM temp_anl_node WHERE fid=153 AND cur_user=current_user', info_msg='Inlets checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=153;
UPDATE sys_fprocess SET fprocess_name='Nodes without top_elev', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='nodes without top_elev. Take a look on temporal table for details.', query_text='SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE top_elev IS NULL AND cur_user = current_user', info_msg='No nodes with null values on field top_elev have been found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=164;
UPDATE sys_fprocess SET fprocess_name='Nodes with top_elev=0', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='nodes with top_elev=0.', query_text='SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE top_elev = 0 AND cur_user = current_user', info_msg='No nodes with ''''0'''' on field top_elev have been found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=165;
UPDATE sys_fprocess SET fprocess_name='Node2arc with more than two arcs', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='node2arcs with more than two arcs. It''''s impossible to continue''', query_text='SELECT * FROM (
SELECT node_id, nodecat_id, node.the_geom, node.expl_id FROM node  JOIN selector_sector USING (sector_id) 
JOIN v_edit_arc a1 ON node_id=a1.node_1  AND node.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user 
UNION ALL SELECT node_id, nodecat_id, node.the_geom, node.expl_id FROM node  JOIN selector_sector USING (sector_id) 
JOIN v_edit_arc a1 ON node_id=a1.node_2  AND node.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user)a 
GROUP by node_id, nodecat_id, the_geom, expl_id HAVING count(*) > 2', info_msg='No results found looking for node2arcs with more than two arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=166;
UPDATE sys_fprocess SET fprocess_name='Node2arc with less than two arcs', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='mandatory node2arcs with less than two arcs.''', query_text='SELECT *FROM (
SELECT node_id, nodecat_id, v_edit_node.the_geom, v_edit_node.expl_id FROM v_edit_node 
JOIN selector_sector USING (sector_id)   JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user 
AND v_edit_node.epa_type IN (''VALVE'', ''PUMP'') AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) UNION ALL
SELECT node_id, nodecat_id, v_edit_node.the_geom, v_edit_node.expl_id FROM v_edit_node  JOIN selector_sector USING (sector_id) 
JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user  AND v_edit_node.epa_type IN (''VALVE'', ''PUMP'') 
AND a1.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user))a 
GROUP by node_id, nodecat_id, the_geom, expl_id HAVING count(*) < 2', info_msg='No results found for mandatory node2arcs with less than two arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=167;
UPDATE sys_fprocess SET fprocess_name='Check pipes with status CV', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='CV pipes. Be carefull with the sense of pipe and check that node_1 and node_2 are on the right direction to prevent reverse flow.', query_text='SELECT * FROM temp_anl_arc WHERE fid = 169 AND cur_user=current_user', info_msg='No results found for CV pipes', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=169;
UPDATE sys_fprocess SET fprocess_name='Check concordance of to_arc valves', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=2, except_msg='valves with wrong to_arc value according to the current closest arcs.', query_text='SELECT * FROM temp_anl_node WHERE fid = 170 AND cur_user=current_user', info_msg='Valve to_arc wrong values checked. No inconsistencies have been detected according to the current closest arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=170;
UPDATE sys_fprocess SET fprocess_name='Check concordance of to_arc pumps', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with wrong to_arc value according to the current closest arcs.', query_text='SELECT * FROM temp_anl_node WHERE fid = 171 AND cur_user=current_user', info_msg='Pump to_arc wrong values checked. No inconsistencies have been detected according with the current closest arcs.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=171;
UPDATE sys_fprocess SET fprocess_name='Null values on state_type column', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='topologic features (arc, node) with state_type with NULL values. Please, check your data before continue', query_text='SELECT arc_id FROM v_prefix_arc WHERE state > 0 AND state_type IS NULL UNION SELECT node_id FROM v_prefix_node WHERE state > 0 AND state_type IS NULL', info_msg='No topologic features (arc, node) with state_type NULL values found.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=175;
UPDATE sys_fprocess SET fprocess_name='Null values on closed/broken values for valves', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=3, except_msg='valves (state=1) with broken or closed with NULL values.', query_text='SELECT n.node_id, n.nodecat_id, n.the_geom, expl_id FROM man_valve JOIN v_prefix_node n USING (node_id) 
WHERE n.state = 1 AND (broken IS NULL OR closed IS NULL)', info_msg='There are not operative valves with null values on closed/broken fields.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=176;
UPDATE sys_fprocess SET fprocess_name='inlet_x_exploitation with null/wrong values', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=3, except_msg='rows with exploitation bad configured on the config_graph_mincut table. Please check your data before continue.', query_text='SELECT * FROM config_graph_mincut cgi INNER JOIN node n ON cgi.node_id = n.node_id  WHERE n.expl_id NOT IN 
(SELECT expl_id FROM exploitation WHERE active IS TRUE)', info_msg='It seems config_graph_mincut table is well configured. At least, table is filled with nodes from all exploitations. All tanks are defined in config_graph_mincut.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=177;
UPDATE sys_fprocess SET fprocess_name='dma-nodeparent acording with graph_delimiter', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=2, except_msg='nodes with ''DMA'' on cat_feature_node.graph_delimiter array not configured on the dma table.', query_text='SELECT node_id, nodecat_id, the_geom, a.active, t_node.expl_id FROM t_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type
LEFT JOIN (SELECT node_id, a.active FROM t_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer AS node_id, 
active FROM dma WHERE graphconfig IS NOT NULL )a USING (node_id)) a USING (node_id) WHERE ''DMA'' = ANY(graph_delimiter) AND (a.node_id IS NULL
OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM dma WHERE active IS TRUE)) AND t_node.state > 0 and verified <> 2 and a.active is false', info_msg='All nodes with cat_feature_node.graph_delimiter=''DMA'' are defined as nodeParent on dma.graphconfig', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=180;
UPDATE sys_fprocess SET fprocess_name='dqa-nodeparent acording with graph_delimiter', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes with ''DQA'' on cat_feature_node.graph_delimiter array not configured on the dqa table. nodes with ''DQA'' on cat_feature_node.graph_delimiter array configured for unactive mapzone.', query_text='SELECT node_id, nodecat_id, the_geom,  v_prefix_node.expl_id FROM v_prefix_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type  LEFT JOIN (SELECT node_id FROM v_prefix_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer as node_id FROM v_prefix_dqa WHERE graphconfig IS NOT NULL ) a USING (node_id)) a USING (node_id) WHERE ''DQA'' = ANY(graph_delimiter) AND (a.node_id IS NULL  OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM v_prefix_dqa))  AND v_prefix_node.state > 0 and verified <> 2', info_msg='All nodes with cat_feature_node.graph_delimiter=''DMA'' are defined as nodeParent on dma.graphconfig', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=181;
UPDATE sys_fprocess SET fprocess_name='presszone-nodeparent acording with graph_delimiter', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes with ''PRESSZONE'' on cat_feature_node.graph_delimiter array not configured on the presszone table. ''PRESSZONE'' on cat_feature_node.graph_delimiter array configured for unactive mapzone.', query_text='SELECT node_id, nodecat_id, the_geom, v_prefix_node.expl_id FROM v_prefix_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type  LEFT JOIN (SELECT node_id FROM v_prefix_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer as node_id FROM v_prefix_presszone WHERE graphconfig IS NOT NULL )a USING (node_id)) a USING (node_id) WHERE''PRESSZONE'' = ANY(graph_delimiter) AND (a.node_id IS NULL  OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM v_prefix_presszone))  AND v_prefix_node.state > 0 and verified <> 2', info_msg='All nodes with cat_feature_node.graph_delimiter=''PRESSZONE'' are defined as nodeParent on presszone.graphconfig', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=182;
UPDATE sys_fprocess SET fprocess_name='Nodes with state_type is_operative false', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='nodes with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue', query_text='SELECT node_id, nodecat_id, the_geom, n.expl_id FROM node n JOIN value_state_type s ON id=state_type WHERE n.state > 0 AND s.is_operative IS FALSE AND verified <> 2', info_msg='No nodes with state > 0 AND state_type.is_operative on FALSE found.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=187;
UPDATE sys_fprocess SET fprocess_name='Arcs with state_type is_operative false', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='arcs with state > 0 and state_type.is_operative on FALSE. Please, check your data before continue', query_text='SELECT arc_id, arccat_id, the_geom, a.expl_id FROM v_prefix_arc a JOIN value_state_type s ON id=state_type  
WHERE a.state > 0 AND s.is_operative IS FALSE AND verified <> 2', info_msg='No arcs with state > 0 AND state_type.is_operative on FALSE found.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=188;
UPDATE sys_fprocess SET fprocess_name='Arcs with state=1 using nodes on state=0', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='arcs with state=1 using extremals nodes with state = 0. Please, check your data before continue', query_text='SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a 
JOIN v_prefix_node n ON node_1=node_id WHERE a.state =1 AND n.state=0 UNION 
SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a 
JOIN v_prefix_node n ON node_2=node_id WHERE a.state =1 AND n.state=0', info_msg='No arcs with state=1 using nodes with state=0 found.', function_name='[gw_fct_om_check_data]' WHERE fid=196;
UPDATE sys_fprocess SET fprocess_name='Arcs with state=1 using nodes on state=2', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='arcs with state=1 using extremals nodes with state = 2. Please, check your data before continue', query_text='SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a JOIN v_prefix_node n ON node_1=node_id 
WHERE a.state =1 AND n.state=2 UNION   SELECT a.arc_id, arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a 
JOIN v_prefix_node n ON node_2=node_id WHERE a.state =1 AND n.state=2', info_msg='No arcs with state=1 using nodes with state=0 found.', function_name='[gw_fct_om_check_data]' WHERE fid=197;
UPDATE sys_fprocess SET fprocess_name='Tanks with null mandatory values', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='tanks with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details', query_text='SELECT * FROM temp_anl_node WHERE fid=198 AND cur_user=current_user', info_msg='Tanks checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=198;
UPDATE sys_fprocess SET fprocess_name='Connecs with duplicated customer_code', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='connecs customer code duplicated. Please, check your data before continue', query_text='SELECT customer_code FROM v_prefix_connec WHERE state=1 and customer_code IS NOT NULL group by customer_code, expl_id having count(*) > 1', info_msg='No connecs with customer code duplicated.', function_name='[gw_fct_om_check_data]' WHERE fid=201;
UPDATE sys_fprocess SET fprocess_name='Feature which id is not an integer', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='which id is not an integer. Please, check your data before continue', query_text='SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)  ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat, expl_id FROM v_prefix_arc UNION 
SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER) ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat, expl_id FROM v_prefix_node UNION 
SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER) ELSE 0 END as feature_id, ''CONNEC'' as type, conneccat_id as featurecat, expl_id FROM v_prefix_connec', info_msg='All features with id integer.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=202;
UPDATE sys_fprocess SET fprocess_name='Connec without link', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='connecs without links or connecs over arc without arc_id.', query_text='SELECT connec_id, conneccat_id, c.the_geom, c.expl_id from v_prefix_connec c WHERE c.state= 1 
AND connec_id NOT IN (SELECT feature_id FROM link) EXCEPT  
SELECT connec_id, conneccat_id, c.the_geom, c.expl_id FROM v_prefix_connec c 
LEFT JOIN arc a USING (arc_id) WHERE c.state= 1 
AND arc_id IS NOT NULL AND st_dwithin(c.the_geom, a.the_geom, 0.1)', info_msg='All connecs have links or are over arc with arc_id.', function_name='[gw_fct_om_check_data]' WHERE fid=204;
UPDATE sys_fprocess SET fprocess_name='Connec or gully chain with different arc_id ', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='chained connecs or gullies with different arc_id. chained connecs with different arc_id.', query_text='with c as 
(select v_prefix_connec.connec_id as id, arc_id as arc, 
v_prefix_connec.conneccat_id as feature_catalog, the_geom, v_prefix_connec.expl_id from v_prefix_connec)     
select c1.id, c1.feature_catalog, c1.the_geom, c1.expl_id from link a 
left join c c1 on a.feature_id = c1.id 
left join c c2 on a.exit_id = c2.id 
where (a.exit_type =''CONNEC'') and c1.arc <> c2.arc ', info_msg='All chained connecs and gullies have the same arc_id All chained connecs have the same arc_id', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=205;
UPDATE sys_fprocess SET fprocess_name='Nodes ischange without change of dn/pn/material', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes with ischange on 1 (true) without any variation of arcs in terms of diameter, pn or material. Please, check your data before continue.', query_text='SELECT n.node_id, count(*), nodecat_id, the_geom, a.expl_id FROM (SELECT node_1 as node_id, arccat_id, v_edit_arc.expl_id FROM v_edit_arc WHERE node_1 IN (SELECT node_id FROM v_edit_node JOIN cat_node ON id=nodecat_id WHERE ischange=1) UNION SELECT node_2, arccat_id, v_edit_arc.expl_id FROM v_edit_arc WHERE node_2 IN (SELECT node_id FROM v_edit_node JOIN cat_node ON id=nodecat_id WHERE ischange=1) GROUP BY 1,2,3) a	JOIN node n USING (node_id) GROUP BY 1,3,4,5 HAVING count(*) <> 2', info_msg='No nodes ''ischange'' without real change have been found.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=208;
UPDATE sys_fprocess SET fprocess_name='Change of dn/pn/material without node ischange', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='nodes where arc catalog changes without nodecat with ischange on 0 or 2 (false or maybe). Please, check your data before continue.', query_text='SELECT node_id, nodecat_id, array_agg(arccat_id) as arccat_id, the_geom, node.expl_id FROM ( SELECT count(*), node_id, arccat_id FROM   (SELECT node_1 as node_id, arccat_id FROM v_prefix_arc UNION ALL SELECT node_2, arccat_id FROM v_prefix_arc)a GROUP BY 2,3 HAVING count(*) <> 2 ORDER BY 2) b   JOIN node USING (node_id) JOIN cat_node ON id=nodecat_id WHERE ischange=0 GROUP By 1,2,4,5 HAVING count(*)=2', info_msg='No nodes without ''ischange'' where arc changes have been found', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=209;
UPDATE sys_fprocess SET fprocess_name='Connecs with customer code null', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='connecs with customer code null. Please, check your data before continue', query_text='SELECT connec_id FROM v_prefix_connec WHERE state=1 and customer_code IS NULL', info_msg='No connecs with null customer code.', function_name='[gw_fct_om_check_data]' WHERE fid=210;
UPDATE sys_fprocess SET fprocess_name='Check arc drawing direction', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='arcs with drawing direction different than definition of node_1, node_2', query_text='SELECT a.arc_id , arccat_id, a.the_geom, a.expl_id FROM v_prefix_arc a, v_prefix_node n WHERE st_dwithin(st_startpoint(a.the_geom), n.the_geom, 0.0001) and node_2 = node_id   UNION   SELECT a.arc_id , arccat_id, a.the_geom, a.expl_id  FROM v_prefix_arc a, v_prefix_node n WHERE st_dwithin(st_endpoint(a.the_geom), n.the_geom, 0.0001) and node_1 = node_id', info_msg='No arcs with drawing direction different than definition of node_1, node_2', function_name='[gw_fct_om_check_data]' WHERE fid=223;
UPDATE sys_fprocess SET fprocess_name='arcs less than 20 cm.', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='pipes with length less than node proximity distance configured.', query_text='SELECT * FROM v_edit_inp_pipe WHERE st_length(the_geom) < (SELECT value::json->>''value'' FROM config_param_system WHERE parameter = ''edit_node_proximity'')::float', info_msg='Standard minimun length checked. No values less than node proximity distance configured.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=229;
UPDATE sys_fprocess SET fprocess_name='arcs less than 5 cm.', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=3, except_msg='pipes with length less than configured minimum length.', query_text='SELECT the_geom, st_length(the_geom) AS length FROM v_edit_inp_pipe WHERE st_length(the_geom) < (SELECT value FROM config_param_system WHERE parameter = ''epa_arc_minlength'')::float', info_msg='Critical minimun length checked. No values less than configured minimum length found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=230;
UPDATE sys_fprocess SET fprocess_name='Conduits with negative slope and inverted slope', "source"='core', fprocess_type='Check om-topology', project_type='ud', except_level=3, except_msg='arcs with inverted slope false and slope negative values. Please, check your data before continue', query_text='SELECT a.arc_id, arccat_id, a.the_geom, expl_id FROM arc a WHERE sys_slope < 0 AND state > 0 AND inverted_slope IS FALSE', info_msg='No arcs with inverted slope checked found.', function_name='[gw_fct_om_check_data]' WHERE fid=251;
UPDATE sys_fprocess SET fprocess_name='Features state=2 are involved in psector', "source"='core', fprocess_type='Check plan-config', project_type='ws', except_level=3, except_msg='planified arcs without psector. planified nodes without psector. planified connecs without psector. planified gullys without psector. features with state=2 without psector assigned. Please, check your data before continue', query_text='SELECT a.feature_id, a.feature, a.catalog, a.the_geom, count(*) FROM (
SELECT node_id as feature_id, ''NODE'' as feature, nodecat_id as catalog, 
the_geom FROM v_edit_node WHERE state=2 AND node_id NOT IN 
(select node_id FROM plan_psector_x_node) UNION 
SELECT arc_id as feature_id, ''ARC'' as feature, arccat_id as catalog, the_geom  
FROM v_edit_arc WHERE state=2 AND arc_id NOT IN 
(select arc_id FROM plan_psector_x_arc) UNION 
SELECT connec_id as feature_id, ''CONNEC'' as feature, conneccat_id  as catalog, 
the_geom  FROM v_edit_connec WHERE state=2 AND connec_id NOT IN 
(select connec_id FROM plan_psector_x_connec)) a  
GROUP BY a.feature_id, a.feature , a.catalog, a.the_geom', info_msg='There are no features with state=2 without psector.', function_name='[gw_fct_plan_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=252;
UPDATE sys_fprocess SET fprocess_name='State not according with state_type', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with state without concordance with state_type. Please, check your data before continue features with state without concordance with state_type. Please, check your data before continue', query_text='SELECT arc_id as id, a.state, state_type FROM v_prefix_arc a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state UNION 
SELECT node_id as id, a.state, state_type FROM v_prefix_node a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state UNION 
SELECT connec_id as id, a.state, state_type FROM v_prefix_connec a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state UNION 
SELECT element_id as id, a.state, state_type FROM v_prefix_element a 
JOIN value_state_type b ON id=state_type WHERE a.state <> b.state', info_msg='No features without concordance against state and state_type.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=253;
UPDATE sys_fprocess SET fprocess_name='Features with code null', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with code with NULL values. Please, check your data before continue with code with NULL values. Please, check your data before continue', query_text='SELECT arc_id, arccat_id FROM v_prefix_arc WHERE code IS NULL UNION 
SELECT node_id, nodecat_id FROM v_prefix_node WHERE code IS NULL UNION 
SELECT connec_id, conneccat_id FROM v_prefix_connec WHERE code IS NULL UNION 
SELECT element_id, elementcat_id FROM v_prefix_element WHERE code IS NULL', info_msg='No features (arc, node, connec, element) with NULL values on code found.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=254;
UPDATE sys_fprocess SET fprocess_name='Connec or gully without or with wrong arc_id', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs without or with incorrect arc_id. gullies without or with incorrect arc_id.', query_text='SELECT c.connec_id, c.conneccat_id, c.the_geom, c.expl_id, l.feature_type, link_id FROM arc a, link l 
JOIN connec c ON l.feature_id = c.connec_id WHERE st_dwithin(a.the_geom, st_endpoint(l.the_geom), 0.01) AND exit_type = ''ARC'' 
AND (a.arc_id <> c.arc_id or c.arc_id is null)   AND l.feature_type = ''CONNEC'' AND a.state=1 and c.state = 1 and l.state=1 EXCEPT 
SELECT c.connec_id, c.conneccat_id, c.the_geom, c.expl_id, l.feature_type, link_id  FROM node n, link l JOIN connec c ON l.feature_id = c.connec_id 
WHERE st_dwithin(n.the_geom, st_endpoint(l.the_geom), 0.01) AND exit_type IN (''NODE'', ''ARC'')  AND l.feature_type = ''CONNEC'' AND n.state=1 and c.state = 1 
and l.state=1 ORDER BY feature_type, link_id', info_msg='All connecs have correct arc_id. All gullies have correct arc_id.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=257;
UPDATE sys_fprocess SET fprocess_name='Link without feature_id', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='links with state > 0 without feature_id.', query_text='SELECT link_id, the_geom FROM v_prefix_link where feature_id is null and state > 0', info_msg='All links state > 0 have feature_id.', function_name='[gw_fct_om_check_data]' WHERE fid=260;
UPDATE sys_fprocess SET fprocess_name='Link without exit_id', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='links with state > 0 without exit_id.', query_text='SELECT link_id, the_geom FROM v_prefix_link where exit_id is null and state > 0', info_msg='All links state > 0 have exit_id.', function_name='[gw_fct_om_check_data]' WHERE fid=261;
UPDATE sys_fprocess SET fprocess_name='Features state=1 and end date', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features on service with value of end date.', query_text='SELECT arc_id as feature_id  from v_prefix_arc where state = 1 and enddate is not null UNION 
SELECT node_id from v_prefix_node where state = 1 and enddate is not null UNION 
SELECT connec_id from v_prefix_connec where state = 1 and enddate is not null', info_msg='No features on service have value of end date', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=262;
UPDATE sys_fprocess SET fprocess_name='Features state=0 without end date', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features with state 0 without value of end date.', query_text='SELECT arc_id as feature_id  from v_prefix_arc where state = 0 and enddate is null UNION 
SELECT node_id from v_prefix_node where state = 0 and enddate is null UNION 
SELECT connec_id from v_prefix_connec where state = 0 and enddate is null ', info_msg='No features with state 0 are missing the end date', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=263;
UPDATE sys_fprocess SET fprocess_name='Features state=1 and end date before start date', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features with end date earlier than built date.', query_text='SELECT arc_id as feature_id  from v_prefix_arc where enddate < builtdate and state = 1 UNION 
SELECT node_id from v_prefix_node where enddate < builtdate and state = 1 UNION 
SELECT connec_id from v_prefix_connec where enddate < builtdate and state = 1', info_msg='No features with end date earlier than built date', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=264;
UPDATE sys_fprocess SET fprocess_name='Automatic links with more than 100m', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='automatic links with longitude out-of-range found.', query_text='SELECT * FROM v_prefix_link where st_length(the_geom) > 100', info_msg='No automatic links with out-of-range Longitude found.', function_name='[gw_fct_om_check_data]' WHERE fid=265;
UPDATE sys_fprocess SET fprocess_name='Duplicated ID between arc, node, connec, gully', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with duplicated ID value between arc, node, connec, gully features with duplicated ID values between arc, node, connec, gully', query_text='SELECT node_id AS feature_id FROM v_prefix_node n JOIN v_prefix_arc a ON a.arc_id=n.node_id UNION
SELECT node_id FROM v_prefix_node n JOIN v_prefix_connec c ON c.connec_id=n.node_id UNION 
SELECT a.arc_id FROM v_prefix_arc a JOIN v_prefix_connec c ON c.connec_id=a.arc_id', info_msg='All features have a diferent ID to be correctly identified', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=266;
UPDATE sys_fprocess SET fprocess_name='Sectors without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='sectors on sector table with graphconfig not configured.', query_text='SELECT * FROM v_edit_sector WHERE graphconfig IS NULL and sector_id > 0', info_msg='All sectors has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=268;
UPDATE sys_fprocess SET fprocess_name='DMA without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='dmas on dma table with graphconfig not configured.', query_text='SELECT * FROM v_edit_dma WHERE graphconfig IS NULL and dma_id > 0', info_msg='All dma has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=269;
UPDATE sys_fprocess SET fprocess_name='DQA without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='dqas on dqa table with graphconfig not configured.', query_text='SELECT * FROM v_edit_dqa WHERE graphconfig IS NULL and dqa_id > 0', info_msg='All dqa has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=270;
UPDATE sys_fprocess SET fprocess_name='Presszone without graphconfig', "source"='core', fprocess_type='Check graph-config', project_type='ws', except_level=3, except_msg='presszones on presszone table with graphconfig not configured.', query_text='SELECT * FROM v_edit_presszone WHERE graphconfig IS NULL and presszone_id > 0', info_msg='All presszones has graphconfig values not null.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=271;
UPDATE sys_fprocess SET fprocess_name='Missing data on inp tables', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='missed features on inp tables. Please, check your data before continue', query_text='SELECT arc_id, ''arc'' FROM v_edit_arc LEFT JOIN    
(SELECT arc_id from inp_pipe UNION SELECT arc_id FROM inp_virtualpump) b using (arc_id)   
WHERE b.arc_id IS NULL AND state > 0 AND epa_type !=''UNDEFINED'' 
UNION 
SELECT node_id, ''node'' FROM v_edit_node LEFT JOIN
(select node_id from inp_shortpipe UNION select node_id from inp_valve ç
UNION select node_id from inp_tank 
UNION select node_id FROM inp_reservoir 
UNION select node_id FROM inp_pump
UNION SELECT node_id from inp_inlet
UNION SELECT node_id from inp_junction) b USING (node_id)
WHERE b.node_id IS NULL AND state >0 AND epa_type !=''UNDEFINED''', info_msg='No features missed on inp_tables found.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=272;
UPDATE sys_fprocess SET fprocess_name='Null values on valve_type table', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='valves with null values on valve_type column.', query_text='SELECT * FROM v_edit_inp_valve WHERE valve_type IS NULL', info_msg='Valve valve_type checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=273;
UPDATE sys_fprocess SET fprocess_name='Null values on valve status', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='valves with null values on mandatory column status.', query_text='SELECT * FROM v_edit_inp_valve WHERE status IS NULL AND state > 0', info_msg='Valve status checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=274;
UPDATE sys_fprocess SET fprocess_name='Null values on valve pressure', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='PBV-PRV-PSV valves with null values on the mandatory column for Pressure valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))', info_msg='PBC-PRV-PSV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=275;
UPDATE sys_fprocess SET fprocess_name='Null values on GPV valve config', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='GPV valves with null values on mandatory column for General purpose valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))', info_msg='GPV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=276;
UPDATE sys_fprocess SET fprocess_name='Null values on TCV valve config', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='TCV valves with null values on mandatory column for Losses Valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE valve_type=''TCV'' AND setting IS NULL', info_msg='TCV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=277;
UPDATE sys_fprocess SET fprocess_name='Null values on FCV valve config', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='FCV valves with null values on mandatory column for Flow Control Valves.', query_text='SELECT * FROM v_edit_inp_valve WHERE ((valve_type=''FCV'') AND (setting IS NULL))', info_msg='FCV valves checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=278;
UPDATE sys_fprocess SET fprocess_name='Null values on pump type', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with null values on pump_type column. virtualpump''''s with null values on pump_type column.', query_text='SELECT * FROM v_edit_inp_pump WHERE pump_type IS NULL', info_msg='Pumps checked. No mandatory values for pump_type missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=279;
UPDATE sys_fprocess SET fprocess_name='Null values on pump curve_id ', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with null values at least on mandatory column curve_id. virtualpumps with null values at least on mandatory column curve_id.', query_text='SELECT * FROM v_edit_inp_pump WHERE curve_id IS NULL', info_msg='Pumps checked. No mandatory values for curve_id missed. Virtualpumps checked. No mandatory values for curve_id missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=280;
UPDATE sys_fprocess SET fprocess_name='Null values on additional pump curve_id ', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='additional pumps with null values at least on mandatory column curve_id.', query_text='SELECT * FROM inp_pump_additional JOIN v_edit_inp_pump USING (node_id) WHERE inp_pump_additional.curve_id IS NULL', info_msg='Additional pumps checked. No mandatory values for curve_id missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=281;
UPDATE sys_fprocess SET fprocess_name='Null values on roughness catalog ', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='pipes with null values for roughness. Check roughness catalog columns (init_age,end_age,roughness) before continue.''', query_text='SELECT * FROM v_edit_inp_pipe JOIN cat_arc ON id = arccat_id JOIN cat_mat_roughness USING  (matcat_id) WHERE init_age IS NULL OR end_age IS NULL OR roughness IS NULL', info_msg='Roughness catalog checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=282;
UPDATE sys_fprocess SET fprocess_name='Null values on arc catalog - dint', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='registers on arc''''s catalog with null values on dint column.''', query_text='SELECT * FROM cat_arc WHERE dint IS NULL', info_msg='Dint for arc''''s catalog checked. No values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=283;
UPDATE sys_fprocess SET fprocess_name='Arcs without elevation', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='arcs without values on sys_elev1 or sys_elev2.', query_text='SELECT * FROM v_edit_arc JOIN selector_sector USING (sector_id) WHERE cur_user = current_user AND sys_elev1 = NULL OR sys_elev2 = NULL', info_msg='No arcs with null values on field elevation (sys_elev1 or sys_elev2) have been found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=284;
UPDATE sys_fprocess SET fprocess_name='Null values on raingage', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='raingages with null values at least on mandatory columns for rain type (form_type, intvl, rgage_type).', query_text='SELECT * FROM v_edit_raingage where (form_type is null) OR (intvl is null) OR (rgage_type is null)', info_msg='Mandatory colums for raingage (form_type, intvl, rgage_type) have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=285;
UPDATE sys_fprocess SET fprocess_name='Null values on raingage timeseries', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='raingages with null values on the mandatory column for ''TIMESERIES'' raingage type', query_text='SELECT * FROM v_edit_raingage where rgage_type=''TIMESERIES'' AND timser_id IS NULL', info_msg='Mandatory colums for ''TIMESERIES'' raingage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=286;
UPDATE sys_fprocess SET fprocess_name='Null values on raingage file', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='raingages with null values at least on mandatory columns for ''FILE'' raingage type (fname, sta, units).', query_text='SELECT * FROM v_edit_raingage where rgage_type=''FILE'' AND (fname IS NULL or sta IS NULL or units IS NULL)', info_msg='Mandatory colums (fname, sta, units) for ''FILE'' raingage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=287;
UPDATE sys_fprocess SET fprocess_name='Connec or gully with different expl_id than arc', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='connecs with exploitation different than the exploitation of the related arc', query_text='SELECT DISTINCT connec_id, conneccat_id, c.the_geom, c.expl_id 
FROM v_prefix_connec c JOIN v_prefix_arc b using (arc_id) WHERE b.expl_id::text != c.expl_id::text', info_msg='All connecs or gullys have the same exploitation as the related arc', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=291;
UPDATE sys_fprocess SET fprocess_name='Check for inp_node tables and epa_type consistency', "source"='core', fprocess_type='Check epa-data', project_type='utils', except_level=3, except_msg='node features with epa_type not according with epa table. Check your data before continue', query_text='SELECT * FROM t_anl_node WHERE fid=294 AND cur_user=current_user', info_msg='Epa type for node features checked. No inconsistencies aganints epa table found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=294;
UPDATE sys_fprocess SET fprocess_name='Check for inp_arc tables and epa_type consistency', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='arcs features with epa_type not according with epa table. Check your data before continue.', query_text='SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_pump table'') AS epa_table, a.the_geom FROM v_edit_inp_pump JOIN arc a USING (arc_id) WHERE epa_type !=''PUMP''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_conduit table'') AS epa_table, a.the_geom FROM v_edit_inp_conduit JOIN arc a USING (arc_id) WHERE epa_type !=''CONDUIT''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_outlet table'') AS epa_table, a.the_geom FROM v_edit_inp_outlet JOIN arc a USING (arc_id) WHERE epa_type !=''OUTLET''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_orifice table'') AS epa_table, a.the_geom FROM v_edit_inp_orifice JOIN arc a USING (arc_id) WHERE epa_type !=''ORIFICE''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_weir table'') AS epa_table, a.the_geom FROM v_edit_inp_weir JOIN arc a USING (arc_id) WHERE epa_type !=''WEIR''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_virtual table'') AS epa_table, a.the_geom FROM v_edit_inp_virtual JOIN arc a USING (arc_id) WHERE epa_type !=''VIRTUAL''', info_msg='Epa type for arcs features checked. No inconsistencies aganints epa table found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=295;
UPDATE sys_fprocess SET fprocess_name='Check values of system variables', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='system variables with out-of-standard values.', query_text='SELECT parameter FROM config_param_system WHERE lower(value) != lower(standardvalue) AND standardvalue IS NOT NULL  AND  standardvalue NOT ILIKE ''{%}'' UNION 
SELECT parameter FROM config_param_system  WHERE lower(json_extract_path_text(value::json,''activated'')) != lower(json_extract_path_text(standardvalue::json,''activated'')) AND standardvalue IS NOT NULL AND standardvalue ILIKE ''{%}''', info_msg='No system variables with values out-of-standars found.', function_name='[gw_fct_om_check_data]' WHERE fid=302;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature field active', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features without value on field "active" from cat_feature.', query_text='SELECT * FROM cat_feature WHERE active IS NULL', info_msg='All features have value on field "active"', function_name='[gw_fct_admin_check_data]' WHERE fid=303;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature field code_autofill', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features without value on field "code_autofill" from cat_feature.', query_text='SELECT * FROM cat_feature WHERE code_autofill IS NULL', info_msg='All features have value on field "code_autofill"', function_name='[gw_fct_admin_check_data]' WHERE fid=304;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field num_arcs', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "num_arcs" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE num_arcs IS NULL', info_msg='All nodes have value on field "num_arcs"', function_name='[gw_fct_admin_check_data]' WHERE fid=305;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isarcdivide', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "isarcdivide" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE isarcdivide IS NULL', info_msg='All nodes have value on field "isarcdivide"', function_name='[gw_fct_admin_check_data]' WHERE fid=306;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field graph_delimiter', "source"='core', fprocess_type='Check admin', project_type='ws', except_level=3, except_msg='nodes without value on field "graph_delimiter" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE graph_delimiter IS NULL', info_msg='All nodes have value on field "graph_delimiter"', function_name='[gw_fct_admin_check_data]' WHERE fid=307;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isexitupperintro', "source"='core', fprocess_type='Check admin', project_type='ud', except_level=3, except_msg='nodes without value on field "isexitupperintro" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE isexitupperintro IS NULL', info_msg='All nodes have value on field "isexitupperintro"', function_name='[gw_fct_admin_check_data]' WHERE fid=308;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field choose_hemisphere', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "choose_hemisphere" from cat_feature_node.', query_text='SELECT * FROM cat_feature_node WHERE choose_hemisphere IS NULL', info_msg='All nodes have value on field "choose_hemisphere"', function_name='[gw_fct_admin_check_data]' WHERE fid=309;
UPDATE sys_fprocess SET fprocess_name='Check cat_feature_node field isprofilesurface', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='nodes without value on field "isprofilesurface" from cat_feature_node. Features - '',v_feature_list::text,''.''', query_text='SELECT * FROM cat_feature_node WHERE isprofilesurface IS NULL', info_msg='All nodes have value on field "isprofilesurface"', function_name='[gw_fct_admin_check_data]' WHERE fid=310;
UPDATE sys_fprocess SET fprocess_name='Check child view man table definition', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='view wrongly defined man_table', query_text='WITH subq_1 as (
SELECT id, feature_class, feature_type, child_layer from cat_feature
), subq_2 as (
select*from information_schema.views a join subq_1 m on m.child_layer = a.table_name
where a.table_schema = current_schema
), subq_3 as (
select position(concat(''man_'',lower(feature_type)) in view_definition) from subq_2
)
select*from subq_3 where position = 0', info_msg='All views are well defined in man_table', function_name='[gw_fct_admin_check_data]' WHERE fid=311;
UPDATE sys_fprocess SET fprocess_name='Check child view addfields', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=2, except_msg='active addfields that may not be present on its corresponding child view:', query_text='WITH subq AS (
    SELECT s.param_name, s.cat_feature_id FROM sys_addfields s
    LEFT JOIN cat_feature f ON s.cat_feature_id = f.id
    WHERE s.feature_type = ''CHILD'' AND s.active IS TRUE AND s.cat_feature_id IS NULL
)
SELECT string_agg(concat(key, '': '', value), ''; '') AS "string_agg"
FROM (SELECT key, value 
        FROM subq, json_each_text(json_build_object(''addfield'', COALESCE(param_name, ''null''), ''cat_feature'', COALESCE(cat_feature_id::text, ''null'')
             )
         )
) AS pairs', info_msg='All active addfields exist on its corresponing view.', function_name='[gw_fct_admin_check_data]' WHERE fid=312;
UPDATE sys_fprocess SET fprocess_name='Find not existing child views', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='views defined in cat_feature table but is not created in a DB.', query_text='SELECT c.child_layer FROM cat_feature c
left join information_schema.views a on a.table_name= c.child_layer
where a.table_schema = current_schema and a.view_definition is null', info_msg='All child views are created and defined in cat_feature and', function_name='[gw_fct_admin_check_data]' WHERE fid=313;
UPDATE sys_fprocess SET fprocess_name='Find active features without child views', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='active features which views names are not present in cat_feature table.', query_text='SELECT string_agg(id,'','') FROM cat_feature WHERE active IS TRUE AND child_layer IS NULL', info_msg='All active features have child view name in cat_feature table', function_name='[gw_fct_admin_check_data]' WHERE fid=314;
UPDATE sys_fprocess SET fprocess_name='Check definition on config_info_layer_x_type', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='active features which views are not defined in config_info_layer_x_type.', query_text='SELECT string_agg(id, ''; '') FROM cat_feature WHERE active IS TRUE AND child_layer not in (select tableinfo_id FROM config_info_layer_x_type)', info_msg='All active features have child view defined in config_info_layer_x_type', function_name='[gw_fct_admin_check_data]' WHERE fid=315;
UPDATE sys_fprocess SET fprocess_name='Check definition on config_form_fields', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='active features which views are not defined in config_form_fields.', query_text='SELECT string_agg(concat(cat_feature_id, '': '', param_name), ''; '') FROM sys_addfields 
JOIN cat_feature ON cat_feature.id=sys_addfields.cat_feature_id WHERE sys_addfields.active IS TRUE AND param_name not IN 
(SELECT columnname FROM config_form_fields JOIN cat_feature ON cat_feature.child_layer=formname)', info_msg='All active features have child view defined in config_form_fields', function_name='[gw_fct_admin_check_data]' WHERE fid=316;
UPDATE sys_fprocess SET fprocess_name='Find ve_* views not defined in cat_feature', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=2, except_msg='views defined in a DB but is not related to any feature in cat_feature.', query_text='select string_agg(child_layer,'','') FROM cat_feature where child_layer IS NOT NULL', info_msg='All views in DB are related to features in cat_feature', function_name='[gw_fct_admin_check_data]' WHERE fid=317;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields field datatype', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features form fields in config_form_fields that don''''t have data type.', query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE datatype IS NULL AND formtype=''form_feature''', info_msg='All feature form fields have defined data type.', function_name='[gw_fct_admin_check_data]' WHERE fid=318;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields field widgettype', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features form fields in config_form_fields that don''''t have widget type.', query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE widgettype IS NULL AND formtype=''form_feature''', info_msg='All feature form fields have defined widget type.', function_name='[gw_fct_admin_check_data]' WHERE fid=319;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields field dv_querytext', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='features form fields in config_form_fields that are combo or typeahead but don''''t have dv_querytext defined.', query_text='SELECT string_agg(concat(formname, '': '', columnname), ''; '') FROM config_form_fields WHERE (widgettype = ''combo'' or widgettype =''typeahead'') and dv_querytext is null and columnname !=''composer''
', info_msg='All feature form fields with widget type combo or typeahead have dv_querytext defined.', function_name='[gw_fct_admin_check_data]' WHERE fid=320;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields for addfields definition', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='addfields that are not defined in config_form_fields.', query_text='SELECT string_agg(param_name, ''; '') FROM sys_addfields 
JOIN cat_feature ON cat_feature.id=sys_addfields.cat_feature_id WHERE sys_addfields.active IS TRUE AND param_name not IN 
(SELECT columnname FROM config_form_fields JOIN cat_feature ON cat_feature.child_layer=formname)', info_msg='All addfields are defined in config_form_fields.', function_name='[gw_fct_admin_check_data]' WHERE fid=321;
UPDATE sys_fprocess SET fprocess_name='Check config_form_fields layoutorder duplicated', "source"='core', fprocess_type='Check admin', project_type='utils', except_level=3, except_msg='form names with duplicated layout order defined in config_form_fields: ''', query_text='SELECT array_agg(a.list::text) FROM (SELECT concat(''Formname: '',formname, '', layoutname: '',layoutname, '', layoutorder: '',layoutorder) as list FROM config_form_fields WHERE formtype = ''feature'' AND hidden is false 
group by layoutorder,formname,layoutname having count(*)>1)a', info_msg='All fields defined in config_form_fields have unduplicated order.', function_name='[gw_fct_admin_check_data]' WHERE fid=322;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field active', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=3, except_msg='rows without values on cat_arc.active column.', query_text='SELECT * FROM cat_arc WHERE active IS NULL', info_msg='There is/are no rows without values on cat_arc.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=323;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_arc.cost column.', query_text='SELECT * FROM cat_arc WHERE cost IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_arc.cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=324;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field m2bottom_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_arc.m2bottom_cost column.', query_text='SELECT * FROM cat_arc WHERE m2bottom_cost IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_arc.m2bottom_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=325;
UPDATE sys_fprocess SET fprocess_name='Check cat_arc field m3protec_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_arc.m3protec_cost column.', query_text='SELECT * FROM cat_arc WHERE m3protec_cost IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_arc.m3protec_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=326;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field active', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=3, except_msg='rows without values on cat_node.active column.', query_text='SELECT * FROM cat_node WHERE active IS NULL', info_msg='There is/are no rows without values on cat_node.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=327;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_node.cost column.', query_text='SELECT * FROM cat_node WHERE cost IS NULL and active=TRUE', info_msg='There is/are no rows rows without values on cat_node.cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=328;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field cost_column', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_node.cost_unit column.', query_text='SELECT * FROM cat_node WHERE cost_unit IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.cost_unit column.', function_name='[gw_fct_plan_check_data]' WHERE fid=329;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field estimated_depth', "source"='core', fprocess_type='Check plan-config', project_type='ws', except_level=2, except_msg='rows without values on cat_node.estimated_depth column.', query_text='SELECT * FROM cat_node WHERE estimated_depth IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.estimated_depth column.', function_name='[gw_fct_plan_check_data, gw_fct_admin_check_data]' WHERE fid=330;
UPDATE sys_fprocess SET fprocess_name='Check cat_node field estimated_y', "source"='core', fprocess_type='Check plan-config', project_type='ud', except_level=2, except_msg='rows without values on cat_node.estimated_y column.', query_text='SELECT * FROM cat_node WHERE estimated_y IS NULL and active=TRUE', info_msg='There is/are no rows without values on cat_node.estimated_y column.', function_name='[gw_fct_plan_check_data]' WHERE fid=331;
UPDATE sys_fprocess SET fprocess_name='Check cat_connec field active', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=3, except_msg='rows without values on cat_connec.active column.', query_text='SELECT * FROM cat_connec WHERE active IS NULL', info_msg='There is/are no rows without values on cat_connec.active column column.', function_name='[gw_fct_plan_check_data]' WHERE fid=332;
UPDATE sys_fprocess SET fprocess_name='Check cat_pavement field thickness', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_pavement.thickness column.', query_text='SELECT * FROM cat_pavement WHERE thickness IS NULL', info_msg='There is/are no rows without values on cat_pavement.thickness column.', function_name='[gw_fct_plan_check_data]' WHERE fid=336;
UPDATE sys_fprocess SET fprocess_name='Check cat_pavement field m2cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_pavement.m2_cost column.', query_text='SELECT * FROM cat_pavement WHERE m2_cost IS NULL', info_msg='There is/are no rows without values on cat_pavement.m2_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=337;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field y_param', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.y_param column.', query_text='SELECT * FROM cat_soil WHERE y_param IS NULL', info_msg='There is/are no rows without values on cat_soil.y_param column.', function_name='[gw_fct_plan_check_data]' WHERE fid=338;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field b', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.b column.', query_text='SELECT * FROM cat_soil WHERE b IS NULL', info_msg='There is/are no rows without values on cat_soil.b column.', function_name='[gw_fct_plan_check_data]' WHERE fid=339;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m3exc_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m3exc_cost column.', query_text='SELECT * FROM cat_soil WHERE m3exc_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m3exc_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=340;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m3fill_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m3fill_cost column.', query_text='SELECT * FROM cat_soil WHERE m3fill_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m3fill_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=341;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m3excess_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m3excess_cost column.', query_text='SELECT * FROM cat_soil WHERE m3excess_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m3excess_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=342;
UPDATE sys_fprocess SET fprocess_name='Check cat_soil field m2trenchl_cost', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on cat_soil.m2trenchl_cost column.', query_text='SELECT * FROM cat_soil WHERE m2trenchl_cost IS NULL', info_msg='There is/are no rows without values on cat_soil.m2trenchl_cost column.', function_name='[gw_fct_plan_check_data]' WHERE fid=343;
UPDATE sys_fprocess SET fprocess_name='Check cat_grate field active', "source"='core', fprocess_type='Check plan-config', project_type='ud', except_level=3, except_msg='rows without values on cat_gully.active column.', query_text='SELECT * FROM cat_gully WHERE active IS NULL', info_msg='There is/are no rows without values on cat_gully.active column.', function_name='[gw_fct_plan_check_data]' WHERE fid=344;
UPDATE sys_fprocess SET fprocess_name='Check plan_arc_x_pavement rows number', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=1, except_msg='rows more in arc than in table plan_arc_x_pavement', query_text='with arcs as (SELECT count(*) as a FROM arc WHERE state>0),
pavs as (SELECT count(*) as b FROM plan_arc_x_pavement)
select case when b < a then a-b else 0 end from arcs, pavs', info_msg='The number of rows of the plan_arc_x_pavement table is same than the arc table.', function_name='[gw_fct_plan_check_data]' WHERE fid=346;
UPDATE sys_fprocess SET fprocess_name='Check plan_arc_x_pavement field pavcat_id', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows without values on plan_arc_x_pavement.pavcat_id column.', query_text='SELECT * FROM plan_arc_x_pavement WHERE pavcat_id IS NOT NULL', info_msg='There is/are no rows without values on rows without values on plan_arc_x_pavement.pavcat_id column.', function_name='[gw_fct_plan_check_data]' WHERE fid=347;
UPDATE sys_fprocess SET fprocess_name='Check arc state=2 with final nodes in psector', "source"='core', fprocess_type='Check plan-data', project_type='utils', except_level=3, except_msg='operative arcs without final nodes in some psector.', query_text='SELECT DISTINCT ON (arc_id) * FROM (SELECT a.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM v_edit_arc a  JOIN plan_psector_x_node pn1 ON pn1.node_id = a.node_1  left JOIN plan_psector_x_arc pa using (arc_id)  WHERE a.state = 1 AND pn1.state = 0 and pa.psector_id is null  UNION  SELECT a.arc_id, a.arccat_id, pa.psector_id, node_2, a.the_geom FROM v_edit_arc a  JOIN plan_psector_x_node pn2 ON pn2.node_id = a.node_2  left JOIN plan_psector_x_arc pa using (arc_id)  WHERE a.state = 1 AND pn2.state = 0 and pa.psector_id is null  ) b', info_msg='There are no arcs with state=1 with final nodes obsolete in psector.', function_name='[gw_fct_plan_check_data]' WHERE fid=354;
UPDATE sys_fprocess SET fprocess_name='Check arc state=2 with operative nodes in psector', "source"='core', fprocess_type='Check plan-data', project_type='utils', except_level=3, except_msg='planified arcs without final in some psector.', query_text='SELECT * FROM ( SELECT pa.arc_id, a.arccat_id, pa.psector_id , node_1 as node, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id) JOIN plan_psector_x_node pn1 ON pn1.node_id = a.node_1 WHERE pa.psector_id = pn1.psector_id AND pa.state = 1 AND pn1.state = 0 UNION SELECT pa.arc_id, a.arccat_id, pa.psector_id, node_2, a.the_geom FROM plan_psector_x_arc pa JOIN v_edit_arc a USING (arc_id) JOIN plan_psector_x_node pn2 ON pn2.node_id = a.node_2 WHERE pa.psector_id = pn2.psector_id AND pa.state = 1 AND pn2.state = 0) b', info_msg='There are no arcs with state=2 with final nodes obsolete in psector.', function_name='[gw_fct_plan_check_data]' WHERE fid=355;
UPDATE sys_fprocess SET fprocess_name='Planned connecs without reference link', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='planned connecs without reference link planned connecs or gullys without reference link', query_text='SELECT * FROM plan_psector_x_connec WHERE link_id IS NULL ', info_msg='All planned connecs or gullys have a reference link', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=356;
UPDATE sys_fprocess SET fprocess_name='Check if defined nodes and arcs exist in a database', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=2, except_msg='arcs that are configured as toArc for v_prefix_v_graphClass but is not operative on arc table.', query_text='SELECT b.arc_id, b.v_graphClass_id as zone_id FROM ( SELECT v_graphClass_id, json_array_elements_text(((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''toArc'')::json)::integer as arc_id FROM v_prefix_v_graphClass)b 
WHERE arc_id not in (select arc_id FROM arc WHERE state=1)', info_msg='All arcs defined as toArc on v_prefix_v_graphClass exists on DB.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=367;
UPDATE sys_fprocess SET fprocess_name='Null values on to_arc valves', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='valves with missed values on mandatory column to_arc.', query_text='SELECT * FROM v_edit_inp_valve WHERE to_arc IS NULL', info_msg='Valve to_arc missed values checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=368;
UPDATE sys_fprocess SET fprocess_name='Check arc catalog with matcat_id null', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='rows with missed matcat_id on cat_arc table. Fix it before continue''', query_text='SELECT * FROM cat_arc WHERE matcat_id IS NULL', info_msg='No registers found without material on cat_arc table.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=371;
UPDATE sys_fprocess SET fprocess_name='Check operative arcs with wrong topology', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='operative arcs with wrong topology.', query_text='with mec as (SELECT arc_id, node_1, node_2, expl_id,state, the_geom
			 FROM arc WHERE state = 1),
	n1 as (SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_startpoint(arc.the_geom))) as d FROM node, arc 
	WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_startpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
	), n2 as (
	SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_endpoint(arc.the_geom))) as d FROM node, arc 
	WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_endpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
	)
	select*from mec m 
		left join n1 on m.arc_id = n1.arc_id
		left join n2 on m.arc_id = n2.arc_id 
		  where (m.node_1 != n1.node_id) or (m.node_1 != n1.node_id)', info_msg='All arcs has well-defined topology', function_name='[gw_fct_om_check_data]' WHERE fid=372;
UPDATE sys_fprocess SET fprocess_name='Check undefined nodes as topological nodes', "source"='core', fprocess_type='Check epa-topology', project_type='utils', except_level=2, except_msg='nodes with epa_type UNDEFINED acting as node_1 or node_2 of arcs. Please, check your data before continue.''', query_text='SELECT n.node_id, nodecat_id, the_geom, n.expl_id FROM 
(SELECT node_1 node_id, sector_id FROM v_edit_arc WHERE epa_type !=''UNDEFINED'' UNION 
SELECT node_2, sector_id FROM arc WHERE epa_type !=''UNDEFINED'' )a JOIN  
(SELECT node_id, nodecat_id, the_geom, expl_id FROM v_edit_node WHERE epa_type = ''UNDEFINED'') n USING (node_id) 
JOIN selector_sector USING (sector_id) WHERE n.node_id IS NOT NULL AND cur_user = current_user', info_msg='No nodes with epa_type UNDEFINED acting as node_1 or node_2 of arcs found.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=379;
UPDATE sys_fprocess SET fprocess_name='Check missed values for storage volume', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='storages with null values at least on mandatory columns to define volume parameters (a1,a2,a0 for FUNCTIONAL or curve_id for TABULAR).', query_text='SELECT * FROM v_edit_inp_storage where (a1 is null and a2 is null and a0 is null AND storage_type=''FUNCTIONAL'') OR (curve_id IS NULL AND storage_type=''TABULAR'')', info_msg='Mandatory colums for volume values used on storage type have been checked without any values missed.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=382;
UPDATE sys_fprocess SET fprocess_name='Check missed values for cat_mat.arc n used on real arcs', "source"='core', fprocess_type='Check epa-config', project_type='ud', except_level=3, except_msg='materials with null values on manning coefficient column used on a real arc where manning is needed.', query_text='SELECT DISTINCT cat_material.* FROM cat_material JOIN v_edit_arc ON matcat_id = id where sys_type !=''VARC'' AND n is null', info_msg='Manning coefficient on cat_material is filled for those materials used on real arcs (not varcs).', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=383;
UPDATE sys_fprocess SET fprocess_name='Arcs shorter than value set as node proximity', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=2, except_msg='arcs with length shorter than value set as node proximity. Please, check your data before continue', query_text='SELECT arc_id,arccat_id,st_length(the_geom), the_geom, expl_id, json_extract_path_text(value::json,''value'')::numeric as nprox 
FROM v_prefix_arc, config_param_system where parameter = ''edit_node_proximity'' 
and  st_length(the_geom) < json_extract_path_text(value::json,''value'')::numeric ', info_msg='No arcs shorter than value set as node proximity.', function_name='[gw_fct_om_check_data]' WHERE fid=391;
UPDATE sys_fprocess SET fprocess_name='Check to_arc missed VALUES for pumps', "source"='core', fprocess_type='Check epa-data', project_type='ws', except_level=3, except_msg='pumps with missed values on mandatory column to_arc.', query_text='SELECT * FROM v_edit_inp_pump WHERE to_arc IS NULL', info_msg='Pump to_arc missed values checked. No mandatory values missed.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=395;
UPDATE sys_fprocess SET fprocess_name='Builddate before 1900', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='features with built date before 1900.', query_text='SELECT arc_id, ''ARC''::text FROM v_prefix_arc WHERE builtdate < ''1900/01/01''::date UNION 
SELECT  node_id, ''NODE''::text FROM v_prefix_node WHERE builtdate < ''1900/01/01''::date UNION 
SELECT  connec_id, ''CONNEC''::text FROM v_prefix_connec WHERE builtdate < ''1900/01/01''::date', info_msg='No feature with builtdate before 1900.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=406;
UPDATE sys_fprocess SET fprocess_name='Links without connec on startpoint', "source"='core', fprocess_type='Check om-topology', project_type='utils', except_level=3, except_msg='links related to connecs with wrong topology, startpoint does not fit connec', query_text='	with mec as ( -- links cuyo startpoint estigui al tocar d''un connec
	SELECT l.link_id, c.connec_id, l.the_geom, l.expl_id FROM connec c, link l
	WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC
	), moc as ( -- links connectats a un connec
		SELECT link_id, feature_id, ''417'', l.state, l.the_geom 
		FROM link l JOIN connec c ON feature_id = connec_id WHERE l.state = 1 and l.feature_type = ''CONNEC''
	) -- si el link cuyo startpoint està tocant un connec, no està informat com que està connectat a un connec, mal
	select * from mec where link_id not in (select link_id from moc)', info_msg='All connec links has connec on startpoint', function_name='[gw_fct_om_check_data]' WHERE fid=417;
UPDATE sys_fprocess SET fprocess_name='Links without gully on startpoint', "source"='core', fprocess_type='Check om-data', project_type='ud', except_level=3, except_msg='links with wrong topology. Startpoint does not fit with connec.', query_text='with subq1 as (SELECT l.link_id, c.connec_id, c.the_geom FROM connec c, link l
WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC)
select connec_id, the_geom From subq1 where connec_id not in (select connec_id from connec)', info_msg='All connec links has connec on startpoint', function_name='[gw_fct_om_check_data]' WHERE fid=418;
UPDATE sys_fprocess SET fprocess_name='Duplicated hydrometer related to more than one connec', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='hydrometer related to more than one connec. HINT-419: Type ''''SELECT hydrometer_id, count(*) FROM v_rtc_hydrometer  group by hydrometer_id having count(*)> 1''''''', query_text='SELECT hydrometer_id, count(*) FROM v_rtc_hydrometer  group by hydrometer_id having count(*)> 1 ', info_msg='All hydrometeres are related to a unique connec', function_name='[gw_fct_om_check_data]' WHERE fid=419;
UPDATE sys_fprocess SET fprocess_name='Check category_type values exists on man_ table', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with category_type does not exists on man_type_category table.', query_text='SELECT ''ARC'', arc_id, category_type FROM v_prefix_arc WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, category_type FROM v_prefix_node WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, category_type FROM v_prefix_connec WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL', info_msg='All features has category_type informed on man_type_category table', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=421;
UPDATE sys_fprocess SET fprocess_name='Check function_type values exists on man_ table', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with function_type does not exists on man_type_function table.', query_text='SELECT ''ARC'', arc_id, function_type FROM v_prefix_arc WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, function_type FROM v_prefix_node WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, function_type FROM v_prefix_connec WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL', info_msg='All features has function_type informed on man_type_function table', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=422;
UPDATE sys_fprocess SET fprocess_name='Check fluid_type values exists on om_typevalue domain fluid_type values', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with fluid_type does not exists on om_typevalue domain.', query_text='SELECT ''ARC'', arc_id, fluid_type FROM v_prefix_arc WHERE fluid_type NOT IN (SELECT fluid_type FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, fluid_type FROM v_prefix_node WHERE fluid_type NOT IN (SELECT fluid_type FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, fluid_type FROM v_prefix_connec WHERE fluid_type NOT IN (SELECT fluid_type FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL', info_msg='All features has fluid_type informed', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=423;
UPDATE sys_fprocess SET fprocess_name='Check location_type values exists on man_ table', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=3, except_msg='features with location_type does not exists on man_type_location table.', query_text='SELECT ''ARC'', arc_id, location_type FROM v_prefix_arc WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, location_type FROM v_prefix_node WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, location_type FROM v_prefix_connec WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL', info_msg='All features has location_type informed on man_type_location table', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=424;
UPDATE sys_fprocess SET fprocess_name='Check expl.geom is not null when raster DEM is enabled', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=2, except_msg='exploitations without geometry. Capturing values from DEM is enabled, but it will fail on exploitation: '',string_agg(name,'', '')', query_text='SELECT * FROM exploitation WHERE the_geom IS NULL AND active IS TRUE and expl_id > 0 ', info_msg='Capturing values from DEM is enabled and will work correctly as all exploitations have geometry.', function_name='[gw_fct_om_check_data]' WHERE fid=428;
UPDATE sys_fprocess SET fprocess_name='Check that EPA OBJECTS (curves and others) name do not contain spaces', "source"='core', fprocess_type='Check epa-config', project_type='utils', except_level=3, except_msg='curves name with spaces. Please fix it!', query_text='SELECT * FROM inp_curve WHERE id like''% %''', info_msg='All curves checked have names without spaces.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=429;
UPDATE sys_fprocess SET fprocess_name='Check matcat null for arcs', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='arcs without matcat_id informed.''', query_text='SELECT * FROM selector_sector s, v_edit_arc a JOIN cat_arc c ON c.id = a.cat_matcat_id  
WHERE a.sector_id = s.sector_id and cur_user=current_user 
AND a.cat_matcat_id IS NULL AND sys_type !=''VARC''', info_msg='All arcs have matcat_id filled.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=430;
UPDATE sys_fprocess SET fprocess_name='Check node ''T candidate'' with wrong topology', "source"='core', fprocess_type='Function process', project_type='utils', except_level=3, except_msg='Nodes ''''T candidate'''' with wrong topology', query_text='with q_arc as (
select * from arc JOIN v_state_arc USING (arc_id))
SELECT b.* FROM (
	SELECT n1.node_id, n1.nodecat_id, n1.sector_id, n1.expl_id, n1.state, n1.the_geom  FROM q_arc, 
		(select * from node JOIN v_state_node USING (node_id)) n1 
	JOIN (SELECT node_1 node_id from q_arc UNION 
	select node_2 FROM q_arc) b USING (node_id) 
	WHERE st_dwithin(q_arc.the_geom, n1.the_geom,0.01) AND n1.node_id NOT IN 
	(node_1, node_2)
)b, selector_expl e 
where e.expl_id= b.expl_id AND cur_user=current_user', info_msg='All Nodes T has right topology.', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data]' WHERE fid=432;
UPDATE sys_fprocess SET fprocess_name='Arc materials not defined in cat_mat_roughness table', "source"='core', fprocess_type='Check epa-config', project_type='ws', except_level=3, except_msg='arc materials that are not defined in cat_mat_rougnhess table. Please, check your data before continue.''', query_text='SELECT id FROM cat_material WHERE id NOT IN (SELECT matcat_id FROM cat_mat_roughness)', info_msg='All arc materials are defined on cat_mat_rougnhess table.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=433;
UPDATE sys_fprocess SET fprocess_name='Check outlet_id assigned to subcatchments', "source"='core', fprocess_type='Check epa-config', project_type='ud', except_level=3, except_msg='outlets defined on subcatchments view, that are not present on junction, outfall, storage, divider or subcatchment view.', query_text='WITH query AS (SELECT * FROM 
(SELECT subc_id, outlet_id, st_centroid(the_geom) as the_geom from v_edit_inp_subcatchment where left(outlet_id::text, 1) != ''{''::text 
	UNION
	SELECT subc_id, unnest(outlet_id::text[]), st_centroid(the_geom) from v_edit_inp_subcatchment where left(outlet_id::text, 1) = ''{''::text
	)a WHERE outlet_id not in (
		select node_id::text FROM v_edit_inp_junction UNION 
		select node_id::text FROM v_edit_inp_outfall UNION
		select node_id::text FROM v_edit_inp_storage UNION 
		select node_id::text FROM v_edit_inp_divider UNION
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
		left join node u on q1.outlet_id = u.node_id::text
		WHERE b.subc_id IS NULL', info_msg='All outlets set on subcatchments are correctly defined.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=440;
UPDATE sys_fprocess SET fprocess_name='Node orphan with isarcdivide=TRUE (OM)', "source"='core', fprocess_type='Check om-topology', project_type='ws', except_level=2, except_msg='orphan nodes with isarcdivide=TRUE.', query_text='SELECT * FROM v_prefix_node a JOIN cat_node nc ON nodecat_id=id JOIN cat_feature_node nt ON nt.id=nc.node_type WHERE a.state>0 AND isarcdivide = true
	AND (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0', info_msg='There are no orphan nodes with isarcdivide=TRUE', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=442;
UPDATE sys_fprocess SET fprocess_name='Node orphan with isarcdivide=FALSE (OM)', "source"='core', fprocess_type='Check om-topology', project_type='ws', except_level=2, except_msg='orphan nodes with isarcdivide=FALSE.', query_text='SELECT  * FROM node a JOIN cat_node nc ON nodecat_id=id JOIN cat_feature_node nt ON nt.id=nc.node_type WHERE a.state>0 AND isarcdivide=false AND arc_id IS NULL', info_msg='There are no orphan nodes with isarcdivide=FALSE', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=443;
UPDATE sys_fprocess SET fprocess_name='Node planified duplicated', "source"='core', fprocess_type='Check plan-data', project_type='utils', except_level=3, except_msg='nodes duplicated with state 2.', query_text='SELECT * FROM (SELECT DISTINCT t1.node_id AS node_1, t1.nodecat_id AS nodecat_1, t1.state as state1, t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 453, t1.the_geom FROM v_prefix_node AS t1 JOIN v_prefix_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 2 AND a.state2 = 2', info_msg='There are no nodes duplicated with state 2', function_name='[gw_fct_plan_check_data, gw_fct_om_check_data]' WHERE fid=453;
UPDATE sys_fprocess SET fprocess_name='Check redundant values on y-top_elev-elev', "source"='core', fprocess_type='Check om-topology', project_type='ud', except_level=3, except_msg='nodes with redundancy on ymax, top_elev & elev values.', query_text='SELECT node_id, nodecat_id, the_geom, expl_id FROM v_prefix_node WHERE (ymax is not null or custom_ymax is not null) 
and (top_elev is not null or custom_top_elev is not null) and (elev is not null or custom_elev is not null)', info_msg='There are no nodes with redundancy on ymax, top_elev & elev values.', function_name='[gw_fct_om_check_data]' WHERE fid=461;
UPDATE sys_fprocess SET fprocess_name='Check number of rows in a plan_price table', "source"='core', fprocess_type='Check plan-config', project_type='utils', except_level=2, except_msg='rows on plan_price table. Revise the data and remove unnecessary rows.', query_text='with c as (SELECT row_number() over() as rowid, * FROM plan_price) select*from c where rowid > 300', info_msg='The number of rows on plan price is acceptable.', function_name='[gw_fct_plan_check_data]' WHERE fid=465;
UPDATE sys_fprocess SET fprocess_name='Planified EPANET pumps with more than two acs', "source"='core', fprocess_type='Check plan-data', project_type='ws', except_level=3, except_msg='pumpss with more than two arcs .Take a look on temporal table to details', query_text='SELECT * FROM t_anl_node WHERE fid=467 AND cur_user=current_user', info_msg='EPA pumps checked. No pumps with more than two arcs detected.', function_name='[gw_fct_plan_check_data, gw_fct_admin_check_data]' WHERE fid=467;
UPDATE sys_fprocess SET fprocess_name='Check consistency between cat_manager and config_user_x_expl', "source"='core', fprocess_type='Function process', project_type='utils', except_level=3, except_msg='inconsistent configurations on cat_manager and config_user_x_expl for user: '''',string_agg(DISTINCT usern,'''', '''')),''||v_count||'' FROM ''||v_querytext||'';''"', query_text='WITH exploit AS (
SELECT COALESCE(m.rolname, s.rolname) AS usern, id FROM (
SELECT id, unnest(rolename) AS role FROM cat_manager WHERE expl_id IS NOT NULL) q 
LEFT JOIN pg_roles r ON q.role = r.rolname LEFT JOIN pg_auth_members am ON r.oid = am.roleid 
LEFT JOIN pg_roles m ON am.member = m.oid AND m.rolcanlogin = TRUE  LEFT JOIN pg_roles s ON q.role = s.rolname AND s.rolcanlogin = TRUE 
WHERE (m.rolcanlogin IS TRUE OR s.rolcanlogin IS TRUE)
) 
SELECT *, CONCAT(explots, ''-'', usern, ''-'', id) FROM (SELECT id, unnest(expl_id) explots, usern FROM cat_manager   JOIN exploit using(id)) a 
WHERE CONCAT(explots, ''-'', usern, ''-'', id) NOT IN (SELECT CONCAT(expl_id, ''-'', username, ''-'', manager_id) FROM config_user_x_expl cuxe) AND explots != 0', info_msg='Configuration of cat_manager and config_user_x_expl is consistent.', function_name='[gw_fct_admin_check_data]', active = false WHERE fid=472;
UPDATE sys_fprocess SET fprocess_name='Check features without defined sector_id', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs with sector_id 0 or -1.', query_text='SELECT connec_id, conneccat_id, the_geom, expl_id FROM connec WHERE state > 0 
AND (sector_id=0 OR sector_id=-1)', info_msg='No connecs with 0 or -1 value on sector_id.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=478;
UPDATE sys_fprocess SET fprocess_name='Check duplicated arcs', "source"='core', fprocess_type='Check om-data', project_type='utils', except_level=3, except_msg='arcs with duplicated geometry.', query_text='SELECT arc_id, arccat_id, state1, arc_id_aux, node_1, node_2, expl_id, the_geom FROM        
 (WITH q_arc AS (SELECT * FROM arc JOIN v_state_arc using (arc_id)) 
 SELECT DISTINCT t1.arc_id, t1.arccat_id, t1.state as state1, t2.arc_id as arc_id_aux,
 t2.state as state2, t1.node_1, t1.node_2, t1.expl_id, t1.the_geom 
 FROM q_arc AS t1 JOIN q_arc AS t2 USING(the_geom) JOIN arc v ON t1.arc_id = v.arc_id
 WHERE t1.arc_id != t2.arc_id ORDER BY t1.arc_id )a
 where a.state1 > 0 AND a.state2 > 0', info_msg='No arcs with duplicated geometry.', function_name='[gw_fct_om_check_data]' WHERE fid=479;
UPDATE sys_fprocess SET fprocess_name='Check connects with more than 1 link on service', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs with more than 1 link on service', query_text='SELECT connec_id, conneccat_id, the_geom, expl_id FROM connec WHERE connec_id IN 
(SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)', info_msg='No connects with more than 1 link on service', function_name='[gw_fct_om_check_data, gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=480;
UPDATE sys_fprocess SET fprocess_name='Check arcs with value of custom length', "source"='core', fprocess_type='Check epa-data', project_type='utils', except_level=2, except_msg='percent of arcs have value on custom_length.', query_text='WITH cust_len AS (SELECT count(*) FROM v_edit_arc WHERE custom_length IS NOT NULL), 
		arcs AS (SELECT count(*) FROM v_edit_arc),
		thres as (SELECT json_extract_path_text(value::json,''customLength'',''maxPercent'')::NUMERIC as t FROM config_param_system WHERE parameter = ''epa_outlayer_values'')
		SELECT round(cust_len.count::numeric / arcs.count::numeric *100, 2) FROM arcs, cust_len, thres
		where round(cust_len.count::numeric / arcs.count::numeric *100, 2) > t', info_msg='No arcs have value on custom_length.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=482;
UPDATE sys_fprocess SET fprocess_name='Check orphan documents', "source"='core', fprocess_type='Function process', project_type='ws', except_level=2, except_msg='documents not related to any feature.', query_text='select id from doc where id not in 
(select distinct  doc_id from doc_x_arc UNION 
select distinct  doc_id from doc_x_connec UNION 
select distinct  doc_id from doc_x_node)', info_msg='All documents are related to the features.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=497;
UPDATE sys_fprocess SET fprocess_name='Check orphan visits', "source"='core', fprocess_type='Function process', project_type='ws', except_level=2, except_msg='visits not related to any feature and without geometry.', query_text='select id, the_geom from om_visit where the_geom is null and id not in (
with mec as (
select distinct visit_id from om_visit_x_arc UNION
select distinct visit_id from om_visit_x_connec UNION
select distinct visit_id from om_visit_x_node UNION
select distinct visit_id from om_visit_x_link)
select a.visit_id from mec a left join om_visit b on a.visit_id = id
)', info_msg='All visits are related to the features or have geometry.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=498;
UPDATE sys_fprocess SET fprocess_name='Check orphan elements', "source"='core', fprocess_type='Function process', project_type='ws', except_level=2, except_msg='elements not related to any feature and without geometry.', query_text='select element_id, the_geom from element where the_geom is null and element_id not in (
with mec as (select distinct element_id from element_x_arc UNION
select distinct element_id from element_x_connec UNION
select distinct element_id from element_x_node)
select a.element_id from mec a left join "element" b using (element_id))', info_msg='All elements are related to the features or have geometry.', function_name='[gw_fct_om_check_data, gw_fct_admin_check_data]' WHERE fid=499;
UPDATE sys_fprocess SET fprocess_name='Check outfalls with more than 1 arc', "source"='core', fprocess_type='Function process', project_type='ud', except_level=3, except_msg='outfalls with more than 1 arc.', query_text='select node.node_id, node.the_geom, node.expl_id, node.nodecat_id 
from node, arc where node.epa_type=''OUTFALL'' and st_dwithin(node.the_geom, arc.the_geom, 0.01) 
group by node.node_id having count(node.node_id)>1', info_msg='All outfalls have a valid number of connected arcs.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=522;
UPDATE sys_fprocess SET fprocess_name='Check outlet_id existance in inp_subcatchment and inp_junction', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='non-existing outlet_id related to subcatchment.', query_text='select outlet_id from v_edit_inp_subc2outlet
LEFT JOIN (
select node_id from v_edit_inp_junction 
UNION select node_id from v_edit_inp_outfall
UNION select node_id from v_edit_inp_storage 
UNION select node_id from v_edit_inp_netgully
) a on outlet_id = node_id
where outlet_type in (''JUNCTION'') and node_id is null
union
select a.outlet_id from v_edit_inp_subc2outlet a LEFT JOIN v_edit_inp_subcatchment s on a.outlet_id::text = s.subc_id
where outlet_type = ''SUBCATCHMENT'' and s.subc_id is null', info_msg='All subcatchments have an existing outlet_id', function_name='[gw_fct_pg2epa_check_data]', active = false WHERE fid=528; -- TODO: revise if this is needed
UPDATE sys_fprocess SET fprocess_name='Check missing data in Inp Weir', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='values missing on some data of Inp Weir (weir_type, cd, geom1, geom2, offsetval)', query_text='SELECT  arc_id,  the_geom from v_edit_inp_weir 
		where weir_type is null or cd is null or geom1 is null or geom2 is null or offsetval is null', info_msg='No missing data on Inp Weir.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=529;
UPDATE sys_fprocess SET fprocess_name='Check missing data in Inp Orifice', "source"='core', fprocess_type='Check epa-data', project_type='ud', except_level=3, except_msg='values missing on some data of Inp Orifice (ori_type, geom1, offsetval)', query_text='SELECT arc_id, the_geom from v_edit_inp_orifice
where ori_type is null or geom1 is null or offsetval is null', info_msg='No missing data on Inp Orifice.', function_name='[gw_fct_pg2epa_check_data]' WHERE fid=530;

UPDATE sys_fprocess SET fprocess_name='Mandatory nodarc over other EPA node', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=3, except_msg='mandatory nodarcs (VALVE & PUMP) over other EPA nodes.'' ', query_text='SELECT a.* FROM (SELECT DISTINCT t1.node_id as n1, t1.nodecat_id as n1cat, t1.state as state1, t2.node_id as n2, 
t2.nodecat_id as n2cat, t2.state as state2, t1.expl_id, 411, 
t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, t1.sector_id  
FROM node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id AND ((t1.epa_type IN (''PUMP'', ''VALVE'') AND t2.epa_type !=''UNDEFINED'') OR 
(t2.epa_type IN (''PUMP'', ''VALVE'') AND t1.epa_type !=''UNDEFINED''))  ORDER BY t1.node_id) a, selector_expl e, selector_sector s  
WHERE e.expl_id = a.expl_id AND e.cur_user = current_user   AND s.sector_id = a.sector_id 
AND s.cur_user = current_user  AND a.state1 > 0 AND a.state2 > 0 ORDER BY dist', info_msg=' All mandatory nodarc (PUMP & VALVE) are not on the same position than other EPA nodes.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=411;
UPDATE sys_fprocess SET fprocess_name='Shortpipe nodarc over other EPA node', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=2, except_msg='shortpipe nodarcs over other EPA nodes.''', query_text='SELECT * FROM (  SELECT DISTINCT t1.node_id as n1, t1.nodecat_id as n1cat, t1.state as state1, t2.node_id as n2, t2.nodecat_id as n2cat, t2.state as state2, t1.expl_id, 412,   t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, ''Shortpipe nodarc over other EPA node'' as descript  FROM selector_expl e, selector_sector s, node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01)   WHERE t1.node_id != t2.node_id   AND s.sector_id = t1.sector_id AND s.cur_user = current_user  AND e.expl_id = t1.expl_id AND e.cur_user = current_user   AND ((t1.epa_type = ''SHORTPIPE'' AND t2.epa_type =''JUNCTION'') OR (t2.epa_type = ''SHORTPIPE'' AND t1.epa_type !=''JUNCTION''))  AND t1.node_id =''SHORTPIPE''  ORDER BY t1.node_id) a where a.state1 > 0 AND a.state2 > 0 ORDER BY dist', info_msg='All shortpipe nodarcs are not on the same position than other EPA nodes.', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=412;
UPDATE sys_fprocess SET fprocess_name='Check minlength less than 0.01 or more than node proximity', "source"='core', fprocess_type='Check epa-topology', project_type='ws', except_level=3, except_msg='minlength value is bad configured (more than node proximity or less than 0.01).', query_text='WITH subq_1 AS (
SELECT value::numeric as v_minlength FROM config_param_system WHERE parameter = ''epa_arc_minlength''
), subq_2 as (
SELECT (value::json->>''value'')::numeric as v_nodeproximity FROM config_param_system WHERE parameter = ''edit_node_proximity''
), mec as (
select v_minlength < 0.01 or v_minlength >= v_nodeproximity as results from subq_1, subq_2
) select * from mec where results is true', info_msg='Minlength value ('',v_minlength,'') is well configured.''', function_name='[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]' WHERE fid=425;
UPDATE sys_fprocess SET fprocess_name='Check zones without numeric id', "source"='core', fprocess_type='Check graph-data', project_type='ws', except_level=3, except_msg='presszones with id that is not a numeric value.', query_text='SELECT presszone_id FROM presszone WHERE presszone_id=''-1'' AND (presszone_id::text ~''^\d+(\.\d+)?$'') is false', info_msg='All presszone_ids are numeric values.', function_name='[gw_fct_graphanalytics_check_data, gw_fct_admin_check_data]' WHERE fid=460;
UPDATE sys_fprocess SET fprocess_name='Check connecs related to arcs with diameter bigger than defined value', "source"='core', fprocess_type='Check om-data', project_type='ws', except_level=2, except_msg='connecs related to arcs with diameter bigger than defined value.', query_text='WITH subq_1 AS (
SELECT (value::json->>''status'')::boolean as status FROM config_param_system WHERE parameter = ''edit_link_check_arcdnom''
), subq_2 as (
select (value::json->>''diameter'')::numeric as v_check_arcdnom FROM config_param_system, subq_1 
WHERE parameter = ''edit_link_check_arcdnom'' and status is true)
SELECT connec_id, conneccat_id, the_geom, expl_id 
FROM v_prefix_connec, subq_2 WHERE state>0 AND arc_id IN 
(SELECT arc_id FROM v_prefix_arc JOIN cat_arc ON arccat_id=id WHERE dnom::integer>subq_2.v_check_arcdnom)', info_msg='No connecs related to arcs with diameter bigger than defined value', function_name='[gw_fct_om_check_data]' WHERE fid=488;


INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(533, 'Non-mandatory nodarc with less than two arcs', 'core', 'Check epa-topology', 'ws', 2, 'NON-mandatory node2arcs with less than two arcs. It will be transformed on the fly using only one arc''', 'SELECT * FROM t_anl_node WHERE fid = 292', 'No results found for NON-mandatory node2arcs with less than two arcs.', '[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(534, 'Check if defined nodes (nodeParent) exist in a database', 'core', 'Check graph-data', 'ws', 2, 'nodes that are configured as nodeParent for v_prefix_v_graphClass but is not operative on node table.', 'SELECT b.node_id, b.v_graphClass_id as zone_id FROM (
SELECT v_graphClass_id, graphconfig::json->''use''->0->>''nodeParent''::integer as node_id FROM v_prefix_v_graphClass)b 
WHERE node_id::text not in (select node_id FROM node WHERE state=1)', 'All nodes defined as nodeParent on v_prefix_v_graphClass exists on DB.', '[gw_fct_graphanalytics_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(541, 'Gully without link', 'core', 'Check om-data', 'ud', NULL, 'gullys without links or gullies over arc without arc_id.', 'SELECT gully_id, gullycat_id, c.the_geom, c.expl_id from v_prefix_gully c WHERE c.state= 1 
AND gully_id NOT IN (SELECT feature_id FROM link)
EXCEPT 
SELECT gully_id, gullycat_id, c.the_geom, c.expl_id FROM v_prefix_gully c
LEFT JOIN v_prefix_arc a USING (arc_id) WHERE c.state= 1 
AND arc_id IS NOT NULL AND st_dwithin(c.the_geom, a.the_geom, 0.1)', 'All gullies have links or are over arc with arc_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(542, 'feature which id is not an integer', 'core', 'Check om-data', 'ud', 3, 'which id is not an integer. Please, check your data before continue', 'SELECT CASE WHEN arc_id~E''^\\d+$'' THEN CAST (arc_id AS INTEGER)
ELSE 0 END  as feature_id, ''ARC'' as type, arccat_id as featurecat,the_geom, expl_id  FROM arc
UNION SELECT CASE WHEN node_id~E''^\\d+$'' THEN CAST (node_id AS INTEGER)
ELSE 0 END as feature_id, ''NODE'' as type, nodecat_id as featurecat,the_geom, expl_id FROM node
UNION SELECT CASE WHEN connec_id~E''^\\d+$'' THEN CAST (connec_id AS INTEGER)
ELSE 0 END as feature_id, ''CONNEC'' as type, conneccat_id as featurecat,the_geom, expl_id FROM connec
UNION SELECT CASE WHEN gully_id~E''^\\d+$'' THEN CAST (gully_id AS INTEGER)
ELSE 0 END as feature_id, ''GULLY'' as type, gullycat_id as featurecat,the_geom, expl_id FROM gully', 'All features with id integer.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(543, 'Gully chain with different arc_id than the final connec/gully', 'core', 'Check om-data', 'ud', NULL, 'chained connecs/gullys without links or gullies over arc without arc_id.', 'with c as (
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
and c1.arc <> c2.arc', 'All chained connecs and gullies have the same arc_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(545, 'State not according with state_type', 'core', 'Check om-data', 'ud', 3, 'features with state without concordance with state_type. Please, check your data before continue features with state without concordance with state_type. Please, check your data before continue', 'SELECT arc_id as id, a.state, state_type FROM v_prefix_arc a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT node_id as id, a.state, state_type FROM v_prefix_node a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT connec_id as id, a.state, state_type FROM v_prefix_connec a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state
UNION SELECT gully_id as id, a.state, state_type FROM v_prefix_gully a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state	
UNION SELECT element_id as id, a.state, state_type FROM v_prefix_element a JOIN value_state_type b ON id=state_type WHERE a.state <> b.state', 'No features without concordance against state and state_type.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(547, 'Check fluid_type values exists on om_typevalue domain values', 'core', 'Check om-data', 'ud', 3, 'features with fluid_type does not exists on om_typevalue domain.', 'SELECT ''ARC'', arc_id, fluid_type FROM v_prefix_arc WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, fluid_type FROM v_prefix_node WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, fluid_type FROM v_prefix_connec WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, fluid_type FROM v_prefix_gully WHERE fluid_type NOT IN (SELECT id FROM om_typevalue WHERE typevalue = ''fluid_type'') AND fluid_type IS NOT NULL', 'All features has fluid_type informed on om_typevalue domain', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(548, 'Check orphan elements', 'core', 'Function process', 'ud', 2, 'elements not related to any feature and without geometry.', 'select element_id, the_geom from element where the_geom is null and element_id not in (
with mec as (select distinct element_id from element_x_arc UNION
select distinct element_id from element_x_connec UNION
select distinct element_id from element_x_node UNION
select distinct element_id from element_x_gully)
select a.element_id from mec a left join "element" b using (element_id))', 'All elements are related to the features or have geometry.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(549, 'Node orphan with isarcdivide=TRUE (OM)', 'core', 'Check om-topology', 'ud', 2, 'orphan nodes with isarcdivide=TRUE.', 'SELECT * FROM v_prefix_node a JOIN cat_feature_node ON id = a.node_type WHERE a.state>0 AND isarcdivide= ''true'' 
AND (SELECT COUNT(*) FROM arc WHERE node_1 = a.node_id OR node_2 = a.node_id and arc.state>0) = 0', 'There are no orphan nodes with isarcdivide=TRUE', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(550, 'Check function_type values exists on man_ table', 'core', 'Check om-data', 'ud', 3, 'features with function_type does not exists on man_type_function table.', 'SELECT ''ARC'', arc_id, function_type FROM v_prefix_arc WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, function_type FROM v_prefix_node WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, function_type FROM v_prefix_connec WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, function_type FROM v_prefix_gully WHERE function_type NOT IN (SELECT function_type FROM man_type_function WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND function_type IS NOT NULL', 'All features has function_type informed on man_type_function table', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(551, 'Features state=1 and end date', 'core', 'Check om-data', 'ud', 2, 'features on service with value of end date.', 'SELECT arc_id as feature_id from v_prefix_arc where state = 1 and enddate is not null
UNION SELECT node_id as feature_id from v_prefix_node where state = 1 and enddate is not null
UNION SELECT connec_id as feature_id from v_prefix_connec where state = 1 and enddate is not null
UNION SELECT gully_id as feature_id from v_prefix_gully where state = 1 and enddate is not null', 'No features on service have value of end date', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(552, 'Gully without or with wrong arc_id', 'core', 'Check om-data', 'ud', 2, 'gullies without or with incorrect arc_id.', 'SELECT c.gully_id, c.gullycat_id, c.the_geom, c.expl_id, l.feature_type, link_id 
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
ORDER BY feature_type, link_id', 'All gullies have correct arc_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(553, 'Features with code null', 'core', 'Check om-data', 'ud', 3, 'features with code with NULL values. Please, check your data before continue with code with NULL values. Please, check your data before continue', 'SELECT arc_id, arccat_id, the_geom FROM v_prefix_arc WHERE code IS NULL 
UNION SELECT node_id, nodecat_id, the_geom FROM v_prefix_node WHERE code IS NULL
UNION SELECT connec_id, conneccat_id, the_geom FROM v_prefix_connec WHERE code IS NULL
UNION SELECT gully_id, gullycat_id, the_geom FROM v_prefix_gully WHERE code IS NULL
UNION SELECT element_id, elementcat_id, the_geom FROM v_prefix_element WHERE code IS NULL', 'No features (arc, node, connec, element, gully) with NULL values on code found.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(554, 'Features state=0 without end date', 'core', 'Check om-data', 'ud', 2, 'features with state 0 without value of end date.', 'SELECT arc_id as feature_id from v_prefix_arc where state = 0 and enddate is null
UNION SELECT node_id from v_prefix_node where state = 0 and enddate is null
UNION SELECT connec_id from v_prefix_connec where state = 0 and enddate is null
UNION SELECT gully_id from v_prefix_gully where state = 0 and enddate is null', 'No features with state 0 are missing the end date', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(555, 'Check connecs with more than 1 link on service', 'core', 'Check om-data', 'ud', 2, 'connecs with more than 1 link on service', 'SELECT connec_id, conneccat_id, the_geom, expl_id FROM v_prefix_connec WHERE connec_id 
IN (SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)
UNION SELECT gully_id, gullycat_id, the_geom, expl_id FROM v_prefix_gully WHERE gully_id 
IN (SELECT feature_id FROM link WHERE state=1 GROUP BY feature_id HAVING count(*) > 1)', 'No connects with more than 1 link on service', '[gw_fct_om_check_data, gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(556, 'Check orphan visits', 'core', 'Function process', 'ud', 2, 'visits not related to any feature and without geometry.', 'select id, the_geom from om_visit where the_geom is null and id not in (
with mec as (
select distinct visit_id from om_visit_x_arc UNION
select distinct visit_id from om_visit_x_connec UNION
select distinct visit_id from om_visit_x_node UNION
select distinct visit_id from om_visit_x_gully UNION
select distinct visit_id from om_visit_x_link)
select a.visit_id from mec a left join om_visit b on a.visit_id = id
)', 'All visits are related to the features or have geometry.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(557, 'Builddate before 1900', 'core', 'Check om-data', 'ud', 2, 'features with built date before 1900.', 'SELECT arc_id, ''ARC''::text FROM v_prefix_arc WHERE builtdate < ''1900/01/01''::date
UNION 
SELECT  node_id, ''NODE''::text FROM v_prefix_node WHERE builtdate < ''1900/01/01''::date
UNION  
SELECT  connec_id, ''CONNEC''::text FROM v_prefix_connec WHERE builtdate < ''1900/01/01''::date
UNION 
SELECT  gully_id, ''GULLY''::text FROM v_prefix_gully WHERE builtdate < ''1900/01/01''::date', 'No feature with builtdate before 1900.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(558, 'Check location_type values exists on man_ table', 'core', 'Check om-data', 'ud', 3, 'features with location_type does not exists on man_type_location table.', 'SELECT ''ARC'', arc_id, location_type FROM v_prefix_arc WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, location_type FROM v_prefix_node WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, location_type FROM v_prefix_connec WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, location_type FROM v_prefix_gully WHERE location_type NOT IN (SELECT location_type FROM man_type_location WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND location_type IS NOT NULL', 'All features has location_type informed on man_type_location table', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(559, 'Planned connecs without reference link', 'core', 'Check om-data', 'ud', 3, 'planned connecs without reference link planned connecs or gullys without reference link', 'SELECT * FROM plan_psector_x_connec WHERE link_id IS NULL
UNION SELECT * FROM plan_psector_x_gully WHERE link_id IS NULL', 'All planned connecs or gullys have a reference link', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(561, 'Duplicated ID between arc, node, connec, gully', 'core', 'Check om-data', 'ud', 3, 'features with duplicated ID value between arc, node, connec, gully features with duplicated ID values between arc, node, connec, gully', 'SELECT * FROM (SELECT node_id FROM node UNION ALL SELECT arc_id FROM arc UNION ALL SELECT connec_id FROM connec UNION ALL SELECT gully_id FROM gully)a 
group by node_id having count(*) > 1', 'All features have a diferent ID to be correctly identified', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(562, 'Features state=2 are involved in psector', 'core', 'Check plan-config', 'ud', 3, 'planified arcs without psector. planified nodes without psector. planified connecs without psector. planified gullys without psector. features with state=2 without psector assigned. Please, check your data before continue', 'SELECT a.arc_id FROM v_prefix_arc a RIGHT JOIN plan_psector_x_arc USING (arc_id) WHERE a.state = 2 AND a.arc_id IS NULL
UNION
SELECT a.node_id FROM v_prefix_node a RIGHT JOIN plan_psector_x_node USING (node_id) WHERE a.state = 2 AND a.node_id IS NULL
UNION
SELECT a.connec_id FROM v_prefix_connec a RIGHT JOIN plan_psector_x_connec USING (connec_id) WHERE a.state = 2 AND a.connec_id IS NULL
UNION 
SELECT a.gully_id FROM v_prefix_gully a RIGHT JOIN plan_psector_x_gully USING (gully_id) WHERE a.state = 2 AND a.gully_id IS NULL', 'There are no features with state=2 without psector.', '[gw_fct_plan_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(563, 'Connec or gully with different expl_id than arc', 'core', 'Check om-data', 'ud', 3, 'connecs with exploitation different than the exploitation of the related arc', 'SELECT DISTINCT connec_id, conneccat_id, c.the_geom, c.expl_id FROM v_prefix_connec c JOIN v_prefix_arc b using (arc_id) 
WHERE b.expl_id::text != c.expl_id::text
UNION 
SELECT DISTINCT  gully_id, gullycat_id, g.the_geom gully_id, g.expl_id FROM v_prefix_gully g JOIN v_prefix_arc d using (arc_id) WHERE d.expl_id::text != g.expl_id::text', 'All connecs or gullys have the same exploitation as the related arc', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(564, 'Check orphan documents', 'core', 'Function process', 'ud', 2, 'documents not related to any feature.', 'select id from doc where id not in (
select distinct  doc_id from doc_x_arc UNION
select distinct  doc_id from doc_x_connec UNION
select distinct  doc_id from doc_x_node UNION
select distinct  doc_id from doc_x_gully)', 'All documents are related to the features.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(565, 'Node orphan with isarcdivide=FALSE (OM)', 'core', 'Check om-topology', 'ud', 2, 'orphan nodes with isarcdivide=FALSE.', 'SELECT * FROM v_prefix_node a JOIN cat_feature_node ON id = a.node_type WHERE a.state>0 AND isarcdivide=''false''', 'There are no orphan nodes with isarcdivide=FALSE', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(566, 'Features state=1 and end date before start date', 'core', 'Check om-data', 'ud', 2, 'features with end date earlier than built date.', 'SELECT arc_id as feature_id from v_prefix_arc where enddate < builtdate and state = 1
UNION SELECT node_id from v_prefix_node where enddate < builtdate and state = 1
UNION SELECT connec_id from v_prefix_connec where enddate < builtdate and state = 1
UNION SELECT gully_id from v_prefix_gully where enddate < builtdate and state = 1', 'No features with end date earlier than built date', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(567, 'Check features without defined sector_id', 'core', 'Check om-data', 'ud', 2, 'connecs with sector_id 0 or -1.', 'SELECT connec_id, conneccat_id, the_geom, expl_id FROM v_prefix_connec WHERE state > 0 AND (sector_id=0 OR sector_id=-1)
UNION SELECT gully_id, gullycat_id, the_geom, expl_id FROM v_prefix_gully WHERE state > 0 AND (sector_id=0 OR sector_id=-1)', 'No connecs with 0 or -1 value on sector_id.', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(568, 'Check category_type values exists on man_ table', 'core', 'Check om-data', 'ud', 3, 'features with category_type does not exists on man_type_category table.', 'SELECT ''ARC'', arc_id, category_type FROM v_prefix_arc WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''ARC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, category_type FROM v_prefix_node WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''NODE'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, category_type FROM v_prefix_connec WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''CONNEC'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, category_type FROM v_prefix_gully WHERE category_type NOT IN (SELECT category_type FROM man_type_category WHERE feature_type is null or feature_type = ''GULLY'' or featurecat_id IS NOT NULL) AND category_type IS NOT NULL', 'All features has category_type informed on man_type_category table', '[gw_fct_om_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(569, 'Check matcat null for arcs', 'core', 'Check epa-config', 'ud', 3, 'arcs without matcat_id informed.', 'SELECT * FROM selector_sector s, v_edit_arc a JOIN cat_arc c ON c.id = a.matcat_id  
WHERE a.sector_id = s.sector_id and cur_user=current_user 
AND a.matcat_id IS NULL AND sys_type !=''VARC''', 'All arcs have matcat_id filled.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(571, 'Arcs less than 20 cm.', 'core', 'Check epa-topology', 'ud', 2, 'pipes with length less than node proximity distance configured.', 'SELECT * FROM v_edit_inp_conduit WHERE st_length(the_geom) < (SELECT value::json->>''value'' FROM config_param_system WHERE parameter = ''edit_node_proximity'')::float', 'Standard minimun length checked. No values less than node proximity distance configured.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(572, 'arcs less than 5 cm.', 'core', 'Check epa-topology', 'ud', 3, 'conduits with length less than configured minimum length.', 'SELECT the_geom, st_length(the_geom) AS length FROM v_edit_inp_conduit WHERE st_length(the_geom) < (SELECT value FROM config_param_system WHERE parameter = ''epa_arc_minlength'')::float', 'Critical minimun length checked. No values less than configured minimum length found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(573, 'y0 on storage data', 'core', 'Check epa-data', 'ud', 3, 'storages with null values at least on mandatory columns for initial status (y0).', 'SELECT * FROM v_edit_inp_storage where (y0 is null)', 'No y0 column without values for storages.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(576, 'Check flow regulator length fits on destination arc (orifice)', 'core', 'Check epa-data', 'ud', 3, 'orifice flow regulator which has length that do not respect the minimum length for target arc.', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frorifice f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id 
AND cur_user=current_user AND 
flwreg_length + (SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All orifice flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(577, 'Check flow regulator length fits on destination arc (weir)', 'core', 'Check epa-data', 'ud', 3, 'weir flow regulator length do not respect the minimum length for target arc', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frweir f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All weir flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(578, 'Check flow regulator length fits on destination arc (outlet)', 'core', 'Check epa-data', 'ud', 3, 'outlet flow regulator length do not respect the minimum length for target arc', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frpump f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All outlet flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(579, 'Check flow regulator length fits on destination arc (pump)', 'core', 'Check epa-data', 'ud', 3, 'pump flow regulator length do not respect the minimum length for target arc.', 'SELECT nodarc_id, f.the_geom FROM selector_sector s, v_edit_inp_frpump f
JOIN node n USING (node_id) JOIN arc a ON a.arc_id = to_arc 
WHERE n.sector_id = s.sector_id AND cur_user=current_user AND flwreg_length + 
(SELECT value::numeric FROM config_param_user WHERE parameter = ''inp_options_minlength'' AND cur_user = current_user) > st_length(a.the_geom)', 'All pump flow regulators have length which fits target arc.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(580, 'Check valid relative timeseries', 'core', 'Check epa-data', 'ud', 3, 'columns on relative timeserires related to this exploitation with errors.', 'SELECT id, a.timser_id, case when a.time is not null then a.time end as time FROM v_edit_inp_timeseries_value a 
JOIN (SELECT id-1 as id, timser_id, case when time is not null then time end as time FROM v_edit_inp_timeseries_value)b USING (id) where a.time::time - b.time::time > ''0 seconds'' AND a.timser_id = b.timser_id', 'All relative timeseries related ot this exploitation are correctly defined.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(581, 'Check shape with null values on arc catalog', 'core', 'Check epa-data', 'utils', 3, 'ows on arc catalog without values on shape column.', 'SELECT * FROM cat_arc WHERE shape is null', 'No rows on arc catalog without values on shape column.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(582, 'Check geom1 with null values on arc catalog', 'core', 'Check epa-data', 'ud', 3, 'rows on arc catalog without values on shape column.', 'SELECT * FROM cat_arc WHERE geom1 is null', 'No rows on arc catalog without values on geom1 column.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(583, 'Missing data on inp tables', 'core', 'Check epa-data', 'ud', 3, 'missed features on inp tables. Please, check your data before continue', 'SELECT arc_id, ''arc'' as feature_tpe FROM arc JOIN
(select arc_id from inp_conduit UNION select arc_id from inp_virtual UNION select arc_id from inp_weir UNION select arc_id from inp_pump UNION select arc_id from inp_outlet UNION select arc_id from inp_orifice) a
USING (arc_id) 
WHERE state > 0 AND epa_type !=''UNDEFINED'' AND a.arc_id IS NULL
UNION
SELECT node_id, ''node'' FROM node JOIN
(select node_id from inp_junction UNION select node_id from inp_storage UNION select node_id from inp_outfall UNION select node_id from inp_divider) a
USING (node_id) 
WHERE state > 0 AND epa_type !=''UNDEFINED'' AND a.node_id IS NULL', 'No features missed on inp_tables found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(584, 'Nodes without elevation', 'core', 'Check epa-data', 'ud', 3, 'EPA nodes without sys_elevation values.', 'SELECT * FROM v_edit_node JOIN selector_sector USING (sector_id) WHERE epa_type !=''UNDEFINED'' AND sys_elev IS NULL AND cur_user = current_user', 'No nodes with null values on field elevation have been found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(585, 'Check that EPA OBJECTS (pollutants) do not contain spaces', 'core', 'Check epa-data', 'ud', 3, 'pollutants have name with spaces. Please fix it!', 'SELECT * FROM inp_pollutant WHERE poll_id like''% %''', 'All pollutants checked have names without spaces.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(586, 'Check that EPA OBJECTS (snowpacks) do not contain spaces', 'core', 'Check epa-data', 'ud', 3, 'snowpacks have name with spaces. Please fix it!', 'SELECT * FROM inp_snowpack WHERE snow_id like''% %''', 'All snowpacks checked have names without spaces.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(587, 'Check that EPA OBJECTS (lids) do not contain spaces', 'core', 'Check epa-data', 'ud', 3, 'lids have name with spaces. Please fix it!', 'SELECT * FROM inp_lid WHERE lidco_id like''% %''', 'All lids checked have names without spaces.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(591, 'Check for inp_connec tables and epa_type consistency', 'core', 'Check epa-data', 'ws', 3, 'connecs features with epa_type not according with epa table. Check your data before continue.', 'SELECT * FROM (SELECT count(*) as c1, null AS c2 FROM connec UNION SELECT null, count(*) FROM inp_connec)a1 WHERE c1 > c2', 'Epa type for arc features checked. No inconsistencies aganints epa table found.Epa type for connec features checked. No inconsistencies aganints epa table found.', '[gw_fct_pg2epa_check_data, gw_fct_admin_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name, addparam) VALUES(592, 'Control null values on crm.hydrometer.code', 'core', 'Function process', 'utils', 3, 'hydrometers in crm schema without code.', 'SELECT id FROM crm.hydrometer WHERE code IS NULL', 'All hydrometers on crm schema have code', '[gw_fct_om_check_data]', '{"addschema":"crm"}');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(593, 'Check estimated depth', 'core', 'Function process', 'utils', 2, 'rows without values on cat_arc.estimated_depth column.', 'SELECT * FROM cat_arc WHERE estimated_depth IS NOT NULL and active=TRUE', 'There is/are no rows without values on cat_arc.estimated_depth column.', '[gw_fct_plan_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(594, 'Null values on valve_type of virtualvalve', 'core', 'Check epa-data', 'ws', 1, 'virtualvalves with null values on valve_type column.', 'SELECT n.node_id, n.nodecat_id, n.the_geom, expl_id FROM man_valve JOIN v_prefix_node n USING (node_id) 
WHERE n.state = 1 AND (broken IS NULL OR closed IS NULL)', 'Virtualvalve valve_type checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(595, 'Null values on valve status of virtualvalves', 'core', 'Check epa-data', 'ws', 3, 'virtualvalves with null values on mandatory column status.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE status IS NULL AND state > 0', 'Virtualvalve status checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(596, 'Null values on virtualvalve pressure', 'core', 'Check epa-data', 'ws', 3, 'PBV-PRV-PSV virtualvalves with null values on the mandatory column for Pressure valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE ((valve_type=''PBV'' OR valve_type=''PRV'' OR valve_type=''PSV'') AND (setting IS NULL))', 'PBC-PRV-PSV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(597, 'Null values on GPV virtualvalve config', 'core', 'Check epa-data', 'ws', 3, 'GPV virtualvalves with null values on mandatory column for General purpose valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE ((valve_type=''GPV'') AND (curve_id IS NULL))', 'GPV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(598, 'Null values on TCV virtualvalve config', 'core', 'Check epa-data', 'ws', 3, 'TCV virtualvalves with null values on mandatory column for Losses Valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE valve_type=''TCV'' AND setting IS NULL', 'TCV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(599, 'Null values on FCV virtualvalve config', 'core', 'Check epa-data', 'ws', 3, 'FCV virtualvalves with null values on mandatory column for Flow Control Valves.', 'SELECT * FROM v_edit_inp_virtualvalve WHERE ((valve_type=''FCV'') AND (setting IS NULL))', 'FCV virtualvalves checked. No mandatory values missed.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(600, 'Null values on virtualpumps type', 'core', 'Check epa-data', 'ws', 3, 'virtualpumps with null values on pump_type column. virtualpump''''s with null values on pump_type column.', 'SELECT * FROM v_edit_inp_virtualpump WHERE pump_type IS NULL', 'Virtualpumps checked. No mandatory values for pump_type missed. Virtualpumps checked. No mandatory values for pump_type missed.', '[gw_fct_plan_check_data, gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(601, 'Null values on virtualpump curve_id ', 'core', 'Check epa-data', 'ws', 3, 'virtualpumps with null values at least on mandatory column curve_id. virtualpumps with null values at least on mandatory column curve_id.', 'SELECT * FROM v_edit_inp_virtualpump WHERE curve_id IS NULL', 'Virtualpumps checked. No mandatory values for curve_id missed. Virtualpumps checked. No mandatory values for curve_id missed.', '[gw_fct_plan_check_data, gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(602, 'Check for inp_arc tables and epa_type consistency', 'core', 'Check epa-data', 'ws', 3, 'arcs features with epa_type not according with epa table. Check your data before continue.', 'with sub1 as (SELECT a.arc_id, a.arccat_id, concat(epa_type, '' using inp_pipe table'') AS epa_table, a.the_geom, a.sector_id FROM v_edit_inp_virtualvalve JOIN arc a USING (arc_id) WHERE epa_type !=''VIRTUAL''
		UNION
		SELECT a.arc_id, a.arccat_id,  concat(epa_type, '' using inp_virtualvalve table'') AS epa_table, a.the_geom, a.sector_id FROM v_edit_inp_pipe JOIN arc a USING (arc_id) WHERE epa_type !=''PIPE''
) select*from sub1', 'Epa type for arcs features checked. No inconsistencies aganints epa table found.Epa type for connec features checked. No inconsistencies aganints epa table found.', '[gw_fct_pg2epa_check_data]');
INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type, except_level, except_msg, query_text, info_msg, function_name) VALUES(603, 'Check that EPA OBJECTS (patterns) name do not contain spaces', 'core', 'Check epa-config', 'utils', 3, 'patterns name with spaces. Please fix it!', 'SELECT * FROM inp_pattern WHERE pattern_id like''% %''', 'All patterns checked have names without spaces.', '[gw_fct_pg2epa_check_data]');


-- xtr (from 26/12/2024)
------------------------

-- pending
-- UPDATE sys_fprocess SET except_table = 'anl_loquesea' from discord
-- UPDATE sys_fprocess SET fprocess_name ='name normalizado' from discord


update sys_fprocess set query_text = replace(query_text,'v_prefix_', 't_');

UPDATE sys_fprocess set query_text = 'SELECT * FROM 
(SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state as state1, 
t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 106, t1.the_geom 
FROM t_node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 1 AND a.state2 = 1' WHERE fid = 106;

UPDATE sys_fprocess set query_text = 'with c as 
(select t_connec.connec_id, arc_id as arc, 
t_connec.conneccat_id, the_geom, t_connec.expl_id from t_connec)     
select c1.connec_id, c1.conneccat_id, c1.the_geom, c1.expl_id from link a 
left join c c1 on a.feature_id = c1.connec_id
left join c c2 on a.exit_id = c2.connec_id
where (a.exit_type =''CONNEC'') and c1.arc <> c2.arc'  WHERE fid = 205;

UPDATE sys_fprocess set query_text =
'with a as (SELECT arc_id, node_1, node_2, arccat_id, expl_id, state, the_geom FROM arc WHERE state = 1),
n1 as (SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_startpoint(arc.the_geom))) as d FROM node, arc 
WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_startpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
), 
n2 as (	SELECT arc.arc_id, node.node_id, min(ST_Distance(node.the_geom, ST_endpoint(arc.the_geom))) as d FROM node, arc 
WHERE arc.state = 1 and node.state = 1 and ST_DWithin(ST_endpoint(arc.the_geom), node.the_geom, 0.02) group by 1,2 ORDER BY 1 DESC,3 DESC
)
select a.* from a 
left join n1 on a.arc_id = n1.arc_id
left join n2 on a.arc_id = n2.arc_id 
where (a.node_1 != n1.node_id) or (a.node_2 != n2.node_id)' WHERE fid = 372;

UPDATE sys_fprocess set query_text =
'with
mec as ( -- links with startpoint close to connec
SELECT l.link_id as arc_id, c.conneccat_id as arccat_id, l.the_geom, l.expl_id FROM connec c, link l
WHERE l.state = 1 and c.state = 1 and ST_DWithin(ST_startpoint(l.the_geom), c.the_geom, 0.01) group by 1,2 ORDER BY 1 DESC
), 
moc as ( -- links connected to connec
SELECT link_id, feature_id, ''417'', l.state, l.the_geom 
FROM link l JOIN connec c ON feature_id = connec_id WHERE l.state = 1 and l.feature_type = ''CONNEC'') 
select * from mec where arc_id not in (select link_id from moc)'  WHERE fid = 417;

UPDATE sys_fprocess set query_text =
'SELECT * FROM (SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state as state1, 
t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 453, t1.the_geom 
FROM t_node AS t1 JOIN t_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 2 AND a.state2 = 2' WHERE fid = 453;

INSERT INTO sys_fprocess (fid, fprocess_name, "source", fprocess_type, project_type)
VALUES (604, 'Check DB data', 'core', 'Function process', 'utils');

UPDATE config_param_system SET value= '{"omCheck":true, "graphCheck":true, "epaCheck":true, "planCheck":true, "adminCheck":true, "ignoreVerifiedExceptions":false}'
WHERE parameter = 'admin_checkproject';

update sys_fprocess set query_text = replace(query_text,'v_edit_', 't_');

update sys_fprocess set query_text = 'SELECT * FROM t_inp_inlet WHERE initlevel is null or minlevel is null or maxlevel is null or diameter is null or minvol is null'
where fid  =153;

update sys_fprocess set query_text = '
SELECT * FROM (
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n JOIN selector_sector USING (sector_id) 
JOIN t_arc a1 ON node_id=a1.node_1  AND n.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user 
UNION ALL 
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n JOIN selector_sector USING (sector_id) 
JOIN t_arc a1 ON node_id=a1.node_2  AND n.epa_type IN (''SHORTPIPE'', ''VALVE'', ''PUMP'') WHERE current_user=cur_user)a 
GROUP by node_id, nodecat_id, the_geom, expl_id HAVING count(*) > 2'
where fid = 166;

update sys_fprocess set query_text = 'SELECT arc_id, arccat_id, the_geom, expl_id FROM t_inp_pipe WHERE status =''CV'''
where fid = 169;

update sys_fprocess set query_text = '
select node_id, nodecat_id, n.the_geom,  n.expl_id
from man_valve join t_node n using (node_id) JOIN t_arc v on v.arc_id = to_arc
where node_id not in (node_1, node_2)'
where fid = 170;

update sys_fprocess set query_text = '
select node_id, nodecat_id, n.the_geom,  n.expl_id
from man_pump join t_node n using (node_id) JOIN t_arc v on v.arc_id = to_arc
where node_id not in (node_1, node_2)'
where fid = 171;

update sys_fprocess set query_text = 'SELECT * FROM t_inp_tank WHERE initlevel is null or minlevel is null or maxlevel is null or diameter is null or minvol is null'
where fid = 198;

update sys_fprocess set query_text = '
SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.the_geom, t1.expl_id,  st_distance(t1.the_geom, t2.the_geom) as dist
FROM t_node AS t1 JOIN t_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id AND ((t1.epa_type IN (''PUMP'', ''VALVE'') AND t2.epa_type !=''UNDEFINED'') OR 
(t2.epa_type IN (''PUMP'', ''VALVE'') AND t1.epa_type !=''UNDEFINED''))  ORDER BY dist'
where fid = 411;

update sys_fprocess set query_text = '
SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.the_geom, t1.expl_id,  st_distance(t1.the_geom, t2.the_geom) as dist
FROM t_node AS t1 JOIN t_node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) 
WHERE t1.node_id != t2.node_id AND ((t1.epa_type IN (''SHORTPIPE'') AND t2.epa_type !=''UNDEFINED'') OR 
(t2.epa_type IN (''SHORTPIPE'') AND t1.epa_type !=''UNDEFINED''))  ORDER BY dist'
where fid = 412;

update sys_fprocess set function_name ='[gw_fct_pg2epa_check_data]', query_text = '
SELECT  count(*), node_id, nodecat_id, the_geom, expl_id FROM (
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n
JOIN arc ON node_id=node_1 WHERE n.epa_type IN (''SHORTPIPE'')
UNION all
SELECT node_id, nodecat_id, n.the_geom, n.expl_id FROM t_node n
JOIN arc ON node_id=node_2 WHERE n.epa_type IN (''SHORTPIPE''))a
GROUP by node_id, nodecat_id, the_geom, expl_id
HAVING count(*) < 2'
WHERE fid = 292;

UPDATE sys_fprocess SET
fprocess_name = 'Arc without node_1/node_2 (go2epa)',
except_level = 3,
except_msg = 'arcs without some node_1 or node_2 (go2epa)',
query_text = 'SELECT arc_id, arccat_id, the_geom, expl_id FROM temp_t_arc WHERE node_1 IS NULL UNION SELECT arc_id,	arccat_id, the_geom, expl_id FROM temp_t_arc WHERE node_2 IS NULL',
info_msg = 'No arcs without node_1 / node_2 found (goepa)',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 454;

UPDATE sys_fprocess SET
fprocess_name = 'Duplicated nodes (go2epa)',
except_level = 3,
except_msg = 'nodes duplicated (go2epa)',
query_text = 'SELECT DISTINCT ON(the_geom) n1.node_id as n1, n1.node_id as node_id, n2.node_id as n2, n1.the_geom, n1.nodecat_id, n1.expl_id FROM temp_t_node n1, temp_t_node n2 WHERE st_dwithin(n1.the_geom, n2.the_geom, 0.00001) AND n1.node_id != n2.node_id',
info_msg = 'No nodes duplicated found (goepa)',
except_table = 'anl_node',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 290;


UPDATE sys_fprocess SET
fprocess_name = 'Link over nodarc (go2epa)',
except_level = 3,
except_msg = 'links over nodarc (go2epa)',
query_text = 'select link_id as arc_id, conneccat_id as arccat_id, a.expl_id, l.the_geom FROM t_link l, temp_t_arc a WHERE st_dwithin(st_endpoint(l.the_geom), a.the_geom, 0.001) AND a.epa_type NOT IN (''CONDUIT'', ''PIPE'', ''VIRTUALVALVE'', ''VIRTUALPUMP'')',
info_msg = 'No links over nodarc found',
project_type = 'ud',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 404;


UPDATE sys_fprocess SET
fprocess_name = 'Arc disconnected from any inlet (go2epa)',
except_level = 3,
project_type = 'ws',
except_msg = 'arcs disconnected from any inlet which have been removed on the go2epa process. The reason may be: state_type, epa_type, sector_id, init age material of cat_roughness, or expl_id or some node not connected',
query_text = 'SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc where sector_id = 0',
info_msg = 'No arcs disconnected from any inlet found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 139;


UPDATE sys_fprocess SET
fprocess_name = 'Arc disconnected from any outfall (go2epa)',
except_level = 3,
project_type = 'ud',
except_msg = 'arcs disconnected from any outfall which have been removed on the go2epa process',
query_text = 'SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc where sector_id = 0',
info_msg = 'No arcs disconnected from any outfall found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 231;

UPDATE sys_fprocess SET
fprocess_name = 'Dry arc because closed elements (go2epa)',
except_level = 2,
project_type = 'ws',
except_msg = 'dry arcs because closed elements (go2epa)',
query_text = 'SELECT arc_id, arccat_id, expl_id, the_geom FROM temp_t_pgr_go2epa_arc WHERE dma_id = 0 and sector_id > 0',
info_msg = 'No arcs dry because closed elements found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 232;


UPDATE sys_fprocess SET
fprocess_name = 'Dry node/connec with associated demand (go2epa)',
except_level = 3,
project_type = 'ws',
except_msg = 'dry nodes/connecs with demand which have been set to cero on the go2epa process',
query_text = 'SELECT node_id, nodecat_id, expl_id, the_geom FROM temp_t_node WHERE demand > 0 and dma_id = 0',
info_msg = 'No connecs dry with associated demand found',
except_table = 'anl_node',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 233;


UPDATE sys_fprocess SET
fprocess_name = 'Arc with less length than minimum configured (go2epa)',
except_level = 2,
project_type = 'ud',
except_msg = 'arcs with less length than minimum configured (go2epa)',
query_text = '
	WITH 
	minlength AS (SELECT value::numeric FROM config_param_system WHERE parameter = ''epa_arc_minlength'')
	SELECT * FROM temp_t_arc, minlength WHERE st_length(the_geom) < value',
info_msg = 'No arcs with less length than minimum configured found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_network]',
active = true
WHERE fid = 431;


UPDATE sys_fprocess SET
fprocess_name = 'Check pumps with 3-point curves',
except_level = 2,
project_type = 'ud',
except_msg = 'pumps with curve defined by 3 points found. Check if this 3-points has thresholds defined (133%) acording EPANET user''s manual',
query_text = ' SELECT count(*) FROM (select curve_id, count(*) as ct from (select * from inp_curve_value 
			   join (select distinct curve_id FROM t_inp_pump)a using (curve_id)) b group by curve_id having count(*)=3)c',
info_msg = 'No curves with 3-points found',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 172;


UPDATE sys_fprocess SET
fprocess_name = 'Nodarc length control (go2epa)',
except_level = 2,
project_type = 'ud',
except_msg = 'arcs with less length than minimum configured (go2epa)',
query_text = '
	WITH 
	minlength AS (SELECT value::numeric FROM config_param_system WHERE parameter = ''epa_arc_minlength'')
	SELECT * FROM temp_t_arc, minlength WHERE st_length(the_geom) < value',
info_msg = 'No arcs with less length than minimum configured found',
except_table = 'anl_arc',
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 375;


UPDATE sys_fprocess SET
fprocess_name = 'Arc with less length than minimum configured (go2epa)',
except_level = 3,
except_msg = 'value of roughness out of range acording headloss formula used',
query_text = '
	SELECT * FROM (WITH 
		rgh as (SELECT min(roughness), max(roughness) FROM cat_mat_roughness),
		hdl as (SELECT value FROM config_param_user WHERE cur_user=current_user AND parameter=''inp_options_headloss'')
		SELECT 
			case when value = ''D-W'' and min < 0.0025 or max > 0.15 then 1 
				 when value = ''H-W'' and min < 110 or max > 150 then 1
				 when value = ''C-M'' and min < 0.011 or max > 0.017 then 1
				 else 0 END roughness
		 from rgh, hdl) a WHERE roughness = 1',
info_msg = 'Roughness values have been checked against head-loss formula using the minimum and maximum EPANET user''s manual values. Any out-of-range values have been detected.',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 377;

-- TODO: Activate this process once 'top_elev' is added to 'ws.node'.
UPDATE sys_fprocess SET
fprocess_name = 'Connec/node with outlayer value on elevation',
except_level = 3,
except_msg = ' connecs/nodes found with outlayer values on elevation',
info_msg = 'All connec/nodes with elevation values according system tresholds',
query_text = '
	WITH 
	outlayer AS (SELECT ((value::json->>''elevation'')::json->>''max'')::numeric as max_elev, 
    ((value::json->>''elevation'')::json->>''min'')::numeric as min_elev FROM config_param_system WHERE parameter = ''epa_outlayer_values'')
	select node_id, nodecat_id from outlayer, node where top_elev < min_elev or top_elev > max_elev
	union
	select connec_id, conneccat_id from outlayer, connec where top_elev < min_elev or top_elev > max_elev',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = false
WHERE fid = 407;


insert into sys_fprocess (fid, fprocess_name, except_level, except_msg, info_msg, query_text, function_name, active) values
(605, 'Check EPA outlayer depth', 3, 'nodes/connecs found with outlayers values for depth', 'All nodes/connecs has depth values according system tresholds',
	'WITH 
	outlayer AS (SELECT ((value::json->>''depth'')::json->>''max'')::numeric as max_depth, 
    ((value::json->>''depth'')::json->>''min'')::numeric as min_depth FROM config_param_system WHERE parameter = ''epa_outlayer_values'')
	select node_id, nodecat_id from outlayer, node where coalesce(depth,0) < min_depth or coalesce(depth,0) > max_depth
	union
	select connec_id, conneccat_id from outlayer, connec where coalesce(depth,0) < min_depth or coalesce(depth,0) > max_depth',
	'[gw_fct_pg2epa_check_result]', true) on conflict (fid) do NOTHING;


-- TODO
--- NO SE COM RESOLDRE: networkmode AS (SELECT value::integer FROM config_param_user WHERE parameter = ''inp_options_networkmode'' AND cur_user = current_user)
--> es podria crear una funció nova que fos gw_fct_pg2epa_check_networkmode_connec
----------------------
UPDATE sys_fprocess SET
fprocess_name = 'EPA connec over EPA node (goe2pa)',
except_level = 3,
except_msg = 'EPA connecs over EPA nodes',
query_text = ' 
	SELECT connec_id, conneccat_id, expl_id, the_geom FROM (
	SELECT DISTINCT t2.connec_id, t2.conneccat_id , t2.expl_id, t1.the_geom, st_distance(t1.the_geom, t2.the_geom) as dist, t1.state as state1, t2.state as state2 
	FROM temp_t_node AS t1 JOIN temp_t_connec AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.1) 
	WHERE t1.epa_type != ''UNDEFINED''
	AND t2.epa_type = ''JUNCTION'') a 
    WHERE a.state1 > 0 AND a.state2 > 0 AND value = 4 ORDER BY dist',
except_table = 'anl_connec',
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
info_msg = 'No EPA connecs over EPA node have been detected.',
active = false
WHERE fid = 413;

UPDATE sys_fprocess SET
fprocess_name = 'Check pjoint_id/ pjoint_type on connec',
except_level = 3,
except_msg = 'Connec without pjoint_id/pjoint_type',
query_text = 'SELECT connec_id, conneccat_id, expl_id, the_geom FROM t_connec WHERE pjoint_id IS NULL OR pjoint_type IS NULL',
except_table = 'anl_connec',
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
active = true
WHERE fid = 415;

UPDATE sys_fprocess SET
fprocess_name = 'Check dint on connec catalog',
except_level = 3,
except_msg = 'Connec catalog without dint defined',
info_msg = 'All connec catalog registers has dint defined',
query_text = 'SELECT * FROM cat_connec WHERE dint is null',
except_table = null,
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
active = true
WHERE fid = 400;

-- TODO
UPDATE sys_fprocess SET
fprocess_name = 'Check material on connec catalog',
except_level = 3,
except_msg = 'Connec catalog without material defined',
info_msg = 'All connec catalog registers has material defined',
query_text = 'SELECT * FROM cat_connec, networkmode n WHERE matcat_id IS NULL',
except_table = null,
function_name = '[gw_fct_pg2epa_check_networkmode_connec]',
active = false
WHERE fid = 414;


UPDATE sys_fprocess SET
fprocess_name = 'Check controls for ARC',
except_level = 3,
except_msg = 'Controls with links (arc o nodarc) are not present on this result',
info_msg = 'All Controls has correct link id (arc or nodarc) values.',
query_text = '
		SELECT * FROM (SELECT a.id, a.code as controls, b.code as templayer FROM 
		(SELECT substring(split_part(text,''LINK '', 2) FROM ''[^ ]+''::text) code, id, sector_id FROM inp_controls WHERE active is true)a
		LEFT JOIN temp_t_arc b USING (code)
		WHERE b.code IS NULL AND a.code IS NOT NULL 
		AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
		OR a.sector_id::text != b.sector_id::text) a',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 402;


insert into sys_fprocess values (606, 'Check controls for NODE');

UPDATE sys_fprocess SET
fprocess_name = 'Check controls for NODE',
except_level = 3,
except_msg = 'Controls with nodes are not present on this result',
info_msg = 'All Controls has correct node id values.',
query_text = '
SELECT * FROM (SELECT a.id, a.code as controls, b.code as templayer FROM 
(SELECT substring(split_part(text,''NODE '', 2) FROM ''[^ ]+''::text) code, id, sector_id FROM inp_controls WHERE active is true)a
LEFT JOIN temp_t_node b USING (code)
WHERE b.code IS NULL AND a.code IS NOT NULL 
AND a.sector_id IN (SELECT sector_id FROM selector_sector WHERE cur_user=current_user) AND a.sector_id IS NOT NULL
OR a.sector_id::text != b.sector_id::text) a',
except_table = null,
function_name = '[gw_fct_pg2epa_check_result]',
active = true
WHERE fid = 406;

insert into sys_fprocess values (607, 'Check rules for NODE','ws');
insert into sys_fprocess values (608, 'Check rules for JUNCTION','ws');
insert into sys_fprocess values (609, 'Check rules for RESERVOIR','ws');
insert into sys_fprocess values (610, 'Check rules for TANK','ws');
insert into sys_fprocess values (611, 'Check rules for LINK','ws');
insert into sys_fprocess values (612, 'Check rules for PIPE','ws');
insert into sys_fprocess values (613, 'Check rules for VALVE','ws');
insert into sys_fprocess values (614, 'Check rules for PUMP','ws');

insert into sys_fprocess values (615, 'Tank present in more than one enabled scenario','ws');
insert into sys_fprocess values (616, 'Reservoir present in more than one enabled scenario','ws');
insert into sys_fprocess values (617, 'Junction present in more than one enabled scenario','ws');
insert into sys_fprocess values (618, 'Pipe present in more than one enabled scenario','ws');
insert into sys_fprocess values (619, 'Pump present in more than one enabled scenario','ws');
insert into sys_fprocess values (620, 'Pump additional present in more than one enabled scenario','ws');
insert into sys_fprocess values (621, 'Valve present in more than one enabled scenario','ws');
insert into sys_fprocess values (622, 'Virtualvalve present in more than one enabled scenario','ws');
insert into sys_fprocess values (623, 'Virtualpump present in more than one enabled scenario','ws');
insert into sys_fprocess values (624, 'Inlet present in more than one enabled scenario','ws');
insert into sys_fprocess values (625, 'Connec present in more than one enabled scenario','ws');

insert into sys_fprocess values (626, 'Outfall present in more than one enabled scenario','ud');
insert into sys_fprocess values (627, 'Outlet present in more than one enabled scenario','ud');
insert into sys_fprocess values (628, 'Storage present in more than one enabled scenario','ud');
insert into sys_fprocess values (629, 'Rainage present in more than one enabled scenario','ud');
insert into sys_fprocess values (630, 'Conduit present in more than one enabled scenario','ud');
insert into sys_fprocess values (631, 'Pump additional present in more than one enabled scenario','ud');
insert into sys_fprocess values (632, 'Orifice present in more than one enabled scenario','ud');
insert into sys_fprocess values (633, 'Pump present in more than one enabled scenario','ud');
insert into sys_fprocess values (634, 'Weir present in more than one enabled scenario','ud');
insert into sys_fprocess values (635, 'Junction present in more than one enabled scenario','ud');
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(636, 'dma-nodeparent acording with graph_delimiter (unactive dma)', 'ws', NULL, 'core', true, 'Check graph-config', NULL, 2, 'nodes with ''DMA''  is on cat_feature_node.graph_delimiter array configured for unactive mapzone.', NULL, NULL, 'SELECT node_id, nodecat_id, the_geom, t_node.expl_id FROM t_node JOIN cat_node c ON id=nodecat_id JOIN cat_feature_node n ON n.id=c.node_type LEFT JOIN (SELECT node_id FROM t_node JOIN (SELECT ((json_array_elements_text((graphconfig::json->>''use'')::json))::json->>''nodeParent'')::integer as node_id FROM t_dma WHERE graphconfig IS NOT NULL )a USING (node_id)) a USING (node_id) WHERE ''DMA'' = ANY(graph_delimiter) AND (a.node_id IS NULL  OR node_id NOT IN (SELECT (json_array_elements_text((graphconfig::json->>''ignore'')::json))::integer FROM t_dma)) AND t_node.state > 0 and verified <> 2', 'All nodes with cat_feature_node.graph_delimiter=''DMA'' are defined as nodeParent on dma.graphconfig', '[gw_fct_graphanalytics_check_data, gw_fct_om_check_data, gw_fct_admin_check_data]', true) ON CONFLICT (fid) DO NOTHING;

UPDATE sys_fprocess SET except_table='anl_arc' WHERE fid=103;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=106;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=107;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=111;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=113;
UPDATE sys_fprocess SET fprocess_name='Inlet with null mandatory values', except_table='anl_node' WHERE fid=153;
UPDATE sys_fprocess SET fprocess_name='Node without elevation', except_table='anl_node' WHERE fid=164;
UPDATE sys_fprocess SET fprocess_name='Node with elevation=0', except_table='anl_node' WHERE fid=165;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=166;
UPDATE sys_fprocess SET except_table='anl_node' WHERE fid=167;
UPDATE sys_fprocess SET fprocess_name='Pipe with status CV', except_table='anl_arc' WHERE fid=169;
UPDATE sys_fprocess SET fprocess_name='Valve with wrong to_arc', except_table='anl_node' WHERE fid=170;
UPDATE sys_fprocess SET fprocess_name='Pump with wrong to_arc', except_table='anl_node' WHERE fid=171;
UPDATE sys_fprocess SET fprocess_name='Valve with null values closed/broken', except_table='anl_node' WHERE fid=176;