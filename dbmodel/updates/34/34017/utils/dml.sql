/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/14

update sys_function set input_params = null, return_type = null where id = 2718;

UPDATE config_form_fields SET formtype = 'form_list_header' where formtype = 'listfilter';
DELETE FROM config_typevalue WHERE id = 'listfilter';
DELETE FROM config_typevalue WHERE id IN (select id FROM config_typevalue WHERE id = 'tabData' LIMIT 1);



UPDATE sys_table SET (addtoc) = ('{"tableName":"v_edit_arc","primaryKey":"arc_id", "geom":"the_geom","group":"GW Temporal Layers","style":"101"}')
WHERE id ='v_edit_arc';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_edit_connec","primaryKey":"connec_id", "geom":"the_geom","group":"GW Temporal Layers","style":"102"}')
WHERE id ='v_edit_connec';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_edit_gully","primaryKey":"gully_id", "geom":"the_geom","group":"GW Temporal Layers","style":"103"}')
WHERE id ='v_edit_gully';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_edit_link","primaryKey":"link_id", "geom":"the_geom","group":"GW Temporal Layers","style":"104"}')
WHERE id ='v_edit_link';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_edit_node","primaryKey":"node_id", "geom":"the_geom","group":"GW Temporal Layers","style":"105"}')
WHERE id ='v_edit_node';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_anl_flow_arc","primaryKey":"arc_id", "geom":"the_geom","group":"GW Temporal Layers","style":"106"}')
WHERE id ='v_anl_flow_arc';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_anl_flow_connec","primaryKey":"connec_id", "geom":"the_geom","group":"GW Temporal Layers","style":"107"}')
WHERE id ='v_anl_flow_connec';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_anl_flow_gully","primaryKey":"gully_id", "geom":"the_geom","group":"GW Temporal Layers","style":"108"}')
WHERE id ='v_anl_flow_gully';

UPDATE sys_table SET (addtoc) = ('{"tableName":"v_anl_flow_node","primaryKey":"node_id", "geom":"the_geom","group":"GW Temporal Layers","style":"109"}')
WHERE id ='v_anl_flow_node';



INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2431,'gw_fct_pg2epa_check_data', '{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}', NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2914,'gw_fct_anl_node_proximity', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2858,'gw_fct_pg2epa_check_result','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2860,'gw_fct_pg2epa_check_options','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2772,'gw_fct_grafanalytics_flowtrace','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2790,'gw_fct_grafanalytics_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2102,'gw_fct_anl_arc_no_startend_node','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2104,'gw_fct_anl_arc_same_startend','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2106,'gw_fct_anl_connec_duplicated','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2108,'gw_fct_anl_node_duplicated','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2110,'gw_fct_anl_node_orphan','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2112,'gw_fct_arc_fusion',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"index": ["v_edit_node" ]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2114,'gw_fct_arc_divide',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"index": ["v_edit_node" ]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2124,'gw_fct_connect_to_network',NULL,'{"visible": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_gully", "v_edit_link"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2202,'gw_fct_anl_arc_intersection','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2204,'gw_fct_anl_arc_inverted','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2206,'gw_fct_anl_node_exit_upper_intro','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2208,'gw_fct_anl_node_flowregulator','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2210,'gw_fct_anl_node_sink','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2212,'gw_fct_anl_node_topological_consistency','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2214,'gw_fct_flow_exit','{"style":{"point":{"style":"qml", "id":"2214"},  "line":{"style":"qml", "id":"2214"}}}','{"visible": ["v_anl_flow_node", "v_anl_flow_gully", "v_anl_flow_connec", "v_anl_flow_arc"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2218,'gw_fct_flow_trace','{"style":{"point":{"style":"qml", "id":"2218"},  "line":{"style":"qml", "id":"2218"}}}','{"visible": ["v_anl_flow_node", "v_anl_flow_gully", "v_anl_flow_connec", "v_anl_flow_arc"]}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2244,'gw_fct_mincut_result_overlap','{"style":{"point":{"style":"qml", "id":"2244"},  "line":{"style":"qml", "id":"2244"}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2302,'gw_fct_anl_node_topological_consistency','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2436,'gw_fct_plan_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2522,'gw_fct_import_epanet_inp',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2524,'gw_fct_import_swmm_inp',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2580,'gw_fct_getinfofromcoordinates','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2582,'gw_fct_getinfofromid','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}, "zoom":{"margin":50}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2584,'gw_fct_getinfofromlist','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2590,'gw_fct_getlayersfromcoordinates','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2618,'gw_fct_setsearch','{"style":{"ruberband":{"width":3, "color":[255,0,0], "transparency":0.5}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2620,'gw_fct_setsearchadd','{"style":{"ruberband":{"width":3, "color":[255, 0,0], "transparency":0.5}}, "zoom":{"margin":50}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2670,'gw_fct_om_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2680,'gw_fct_pg2epa_check_network','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2706,'gw_fct_grafanalytics_minsector','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2710,'gw_fct_grafanalytics_mapzones',NULL, NULL,'["style_mapzones"]');

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2734,'gw_fct_psector_duplicate','{"zoom":{"margin":20}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2776,'gw_fct_admin_check_data', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

--INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
--VALUES(2784,'gw_fct_insert_importdxf',NULL,NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2824,'',NULL,'{"visible": ["v_edit_dimensions"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2826,'gw_fct_grafanalytics_lrs','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL);

--INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
--VALUES(2870,'gw_fct_setselectors',NULL,NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2118,'gw_fct_node_builtfromarc','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2848,'gw_fct_pg2epa_check_result','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL, NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2850,'gw_fct_pg2epa_check_options','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', '{"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2430,'gw_fct_pg2epa_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', '{"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL);


INSERT INTO sys_style (idval, styletype, stylevalue, active)
VALUES('101', 'v_edit_arc',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="0" labelsEnabled="1" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1e+08" simplifyDrawingHints="1">
	<flags>
		<Identifiable>1</Identifiable>
		<Removable>1</Removable>
		<Searchable>1</Searchable>
	</flags>
	<renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="RuleRenderer">
		<rules key="{a226d791-7f55-4ca8-b7a0-6b4c8d42de02}">
			<rule filter=" &quot;sys_type&quot;  =  'CONDUIT'  AND &quot;state&quot; = 1" label="Conduit" symbol="0" key="{a249c2ea-539b-4c81-bb77-fe9bcb3d594d}"/>
			<rule filter=" &quot;sys_type&quot;  =   'SIPHON'  AND &quot;state&quot; = 1" label="Siphon" symbol="1" key="{7b6309f3-e7a2-46e1-81c1-f28acdae68cd}"/>
			<rule filter=" &quot;sys_type&quot;  =   'WACCEL'  AND &quot;state&quot; = 1" label="Waccel" symbol="2" key="{dc14f906-9233-4320-af02-4a52f0615940}"/>
			<rule filter=" &quot;sys_type&quot;  =   'VARC'  AND &quot;state&quot; = 1" label="Varc" symbol="3" key="{5eed5062-bf5c-4b54-8128-75070e29e5ea}"/>
			<rule filter="&quot;state&quot; = 0" label="Obselete" symbol="4" key="{3503f7d4-d5e0-4888-9b50-05f847f5b6ab}"/>
			<rule filter="&quot;state&quot; = 2" label="Planified" symbol="5" key="{7b2990be-f57a-4caf-b99a-308c6d4349ca}"/>
		</rules>
		<symbols>
			<symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="45,84,255,255"/>
					<prop k="line_style" v="solid"/>
					<prop k="line_width" v="0.36"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="MarkerLine" locked="0" pass="0">
					<prop k="average_angle_length" v="4"/>
					<prop k="average_angle_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="average_angle_unit" v="MM"/>
					<prop k="interval" v="3"/>
					<prop k="interval_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="interval_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_along_line" v="0"/>
					<prop k="offset_along_line_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_along_line_unit" v="MM"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="placement" v="centralpoint"/>
					<prop k="ring_filter" v="0"/>
					<prop k="rotate" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@0@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="45,84,255,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="filled_arrowhead"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="0,0,0,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="0.36"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties" type="Map">
										<Option name="size" type="Map">
											<Option value="true" name="active" type="bool"/>
											<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
											<Option value="3" name="type" type="int"/></Option>
									</Option>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
			<symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="140,0,255,255"/>
					<prop k="line_style" v="solid"/>
					<prop k="line_width" v="0.36"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="MarkerLine" locked="0" pass="0">
					<prop k="average_angle_length" v="4"/>
					<prop k="average_angle_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="average_angle_unit" v="MM"/>
					<prop k="interval" v="3"/>
					<prop k="interval_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="interval_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_along_line" v="0"/>
					<prop k="offset_along_line_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_along_line_unit" v="MM"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="placement" v="centralpoint"/>
					<prop k="ring_filter" v="0"/>
					<prop k="rotate" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@1@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="140,0,255,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="filled_arrowhead"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="0,0,0,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="0.36"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties" type="Map">
										<Option name="size" type="Map">
											<Option value="true" name="active" type="bool"/>
											<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
											<Option value="3" name="type" type="int"/></Option>
									</Option>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
			<symbol name="2" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="43,131,30,255"/>
					<prop k="line_style" v="solid"/>
					<prop k="line_width" v="0.36"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="MarkerLine" locked="0" pass="0">
					<prop k="average_angle_length" v="4"/>
					<prop k="average_angle_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="average_angle_unit" v="MM"/>
					<prop k="interval" v="3"/>
					<prop k="interval_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="interval_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_along_line" v="0"/>
					<prop k="offset_along_line_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_along_line_unit" v="MM"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="placement" v="centralpoint"/>
					<prop k="ring_filter" v="0"/>
					<prop k="rotate" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@2@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="43,131,30,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="filled_arrowhead"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="0,0,0,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="0.36"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties" type="Map">
										<Option name="size" type="Map">
											<Option value="true" name="active" type="bool"/>
											<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
											<Option value="3" name="type" type="int"/></Option>
									</Option>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
			<symbol name="3" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="229,218,93,255"/>
					<prop k="line_style" v="solid"/>
					<prop k="line_width" v="0.36"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="MarkerLine" locked="0" pass="0">
					<prop k="average_angle_length" v="4"/>
					<prop k="average_angle_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="average_angle_unit" v="MM"/>
					<prop k="interval" v="3"/>
					<prop k="interval_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="interval_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_along_line" v="0"/>
					<prop k="offset_along_line_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_along_line_unit" v="MM"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="placement" v="centralpoint"/>
					<prop k="ring_filter" v="0"/>
					<prop k="rotate" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@3@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="229,218,93,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="filled_arrowhead"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="0,0,0,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="0.36"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties" type="Map">
										<Option name="size" type="Map">
											<Option value="true" name="active" type="bool"/>
											<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
											<Option value="3" name="type" type="int"/></Option>
									</Option>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
			<symbol name="4" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="161,35,43,255"/>
					<prop k="line_style" v="solid"/>
					<prop k="line_width" v="0.36"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="MarkerLine" locked="0" pass="0">
					<prop k="average_angle_length" v="4"/>
					<prop k="average_angle_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="average_angle_unit" v="MM"/>
					<prop k="interval" v="3"/>
					<prop k="interval_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="interval_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_along_line" v="0"/>
					<prop k="offset_along_line_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_along_line_unit" v="MM"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="placement" v="centralpoint"/>
					<prop k="ring_filter" v="0"/>
					<prop k="rotate" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@4@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="161,35,43,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="filled_arrowhead"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="0,0,0,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="0.36"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties" type="Map">
										<Option name="size" type="Map">
											<Option value="true" name="active" type="bool"/>
											<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
											<Option value="3" name="type" type="int"/></Option>
									</Option>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
			<symbol name="5" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="255,127,0,255"/>
					<prop k="line_style" v="solid"/>
					<prop k="line_width" v="0.36"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="MarkerLine" locked="0" pass="0">
					<prop k="average_angle_length" v="4"/>
					<prop k="average_angle_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="average_angle_unit" v="MM"/>
					<prop k="interval" v="3"/>
					<prop k="interval_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="interval_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_along_line" v="0"/>
					<prop k="offset_along_line_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_along_line_unit" v="MM"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="placement" v="centralpoint"/>
					<prop k="ring_filter" v="0"/>
					<prop k="rotate" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties" type="Map">
								<Option name="outlineWidth" type="Map">
									<Option value="true" name="active" type="bool"/>
									<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
									<Option value="3" name="type" type="int"/></Option>
							</Option>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@5@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="255,127,0,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="filled_arrowhead"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="0,0,0,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="0.36"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties" type="Map">
										<Option name="size" type="Map">
											<Option value="true" name="active" type="bool"/>
											<Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression" type="QString"/>
											<Option value="3" name="type" type="int"/></Option>
									</Option>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
		</symbols>
	</renderer-v2>
	<labeling type="simple">
		<settings calloutType="simple">
			<text-style fontFamily="MS Shell Dlg 2" fontStrikeout="0" fontItalic="0" blendMode="0" isExpression="0" fontKerning="1" fontLetterSpacing="0" fontCapitals="0" textOrientation="horizontal" useSubstitutions="0" textColor="0,0,0,255" fontWeight="50" fontUnderline="0" fontSizeUnit="Point" fontWordSpacing="0" textOpacity="1" fontSize="8.25" previewBkgrdColor="255,255,255,255" multilineHeight="1" namedStyle="Normal" fieldName="arccat_id" fontSizeMapUnitScale="3x:0,0,0,0,0,0">
				<text-buffer bufferSizeUnits="MM" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSize="1" bufferColor="255,255,255,255" bufferDraw="0" bufferJoinStyle="128" bufferNoFill="0" bufferBlendMode="0" bufferOpacity="1"/>
				<background shapeBorderWidth="0" shapeSizeX="0" shapeSizeUnit="MM" shapeOpacity="1" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderColor="128,128,128,255" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeSVGFile="" shapeJoinStyle="64" shapeBlendMode="0" shapeRadiiX="0" shapeRadiiUnit="MM" shapeOffsetY="0" shapeRotation="0" shapeSizeY="0" shapeSizeType="0" shapeRotationType="0" shapeOffsetX="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeOffsetUnit="MM" shapeBorderWidthUnit="MM" shapeRadiiY="0">
					<symbol name="markerSymbol" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="231,113,72,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="circle"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="35,35,35,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="2"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties"/>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</background>
				<shadow shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetUnit="MM" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255" shadowBlendMode="6" shadowUnder="0" shadowOffsetDist="1" shadowOffsetGlobal="1" shadowOffsetAngle="135" shadowDraw="0" shadowOpacity="0.7" shadowRadiusUnit="MM" shadowScale="100"/>
				<dd_properties>
					<Option type="Map">
						<Option value="" name="name" type="QString"/>
						<Option name="properties"/>
						<Option value="collection" name="type" type="QString"/></Option>
				</dd_properties>
				<substitutions/>
			</text-style>
			<text-format autoWrapLength="0" rightDirectionSymbol=">" plussign="0" multilineAlign="4294967295" reverseDirectionSymbol="0" formatNumbers="0" wrapChar="" decimals="3" leftDirectionSymbol="&lt;" addDirectionSymbol="0" placeDirectionSymbol="0" useMaxLineLengthForAutoWrap="1"/>
			<placement predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" quadOffset="4" offsetUnits="MapUnit" fitInPolygonOnly="0" maxCurvedCharAngleIn="25" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" dist="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGenerator="" overrunDistanceUnit="MM" priority="5" centroidInside="0" placement="2" geometryGeneratorEnabled="0" distMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" distUnits="MM" maxCurvedCharAngleOut="-25" layerType="LineGeometry" yOffset="0" centroidWhole="0" repeatDistance="0" rotationAngle="0" overrunDistance="0" repeatDistanceUnits="MM" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorType="PointGeometry" xOffset="0" placementFlags="10" offsetType="0"/>
			<rendering limitNumLabels="0" scaleVisibility="1" obstacleFactor="1" maxNumLabels="2000" mergeLines="0" obstacle="1" labelPerPart="0" zIndex="0" fontMinPixelSize="3" obstacleType="0" displayAll="0" upsidedownLabels="0" fontMaxPixelSize="10000" scaleMin="1" minFeatureSize="0" fontLimitPixelSize="0" scaleMax="1000" drawLabels="1"/>
			<dd_properties>
				<Option type="Map">
					<Option value="" name="name" type="QString"/>
					<Option name="properties"/>
					<Option value="collection" name="type" type="QString"/></Option>
			</dd_properties>
			<callout type="simple">
				<Option type="Map">
					<Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
					<Option name="ddProperties" type="Map">
						<Option value="" name="name" type="QString"/>
						<Option name="properties"/>
						<Option value="collection" name="type" type="QString"/></Option>
					<Option value="false" name="drawToAllParts" type="bool"/>
					<Option value="0" name="enabled" type="QString"/>
					<Option value="&lt;symbol name=&quot;symbol&quot; force_rhr=&quot;0&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; type=&quot;line&quot;>&lt;layer enabled=&quot;1&quot; class=&quot;SimpleLine&quot; locked=&quot;0&quot; pass=&quot;0&quot;>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
					<Option value="0" name="minLength" type="double"/>
					<Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
					<Option value="MM" name="minLengthUnit" type="QString"/>
					<Option value="0" name="offsetFromAnchor" type="double"/>
					<Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
					<Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
					<Option value="0" name="offsetFromLabel" type="double"/>
					<Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
					<Option value="MM" name="offsetFromLabelUnit" type="QString"/></Option>
			</callout>
		</settings>
	</labeling>
	<customproperties>
		<property value="0" key="embeddedWidgets/count"/>
		<property key="variableNames"/>
		<property key="variableValues"/>
	</customproperties>
	<blendMode>0</blendMode>
	<featureBlendMode>0</featureBlendMode>
	<layerOpacity>1</layerOpacity>
	<SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
		<DiagramCategory penColor="#000000" lineSizeType="MM" height="15" scaleBasedVisibility="0" opacity="1" barWidth="5" scaleDependency="Area" penAlpha="255" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" maxScaleDenominator="1e+08" sizeScale="3x:0,0,0,0,0,0" sizeType="MM" backgroundColor="#ffffff" penWidth="0" width="15" labelPlacementMethod="XHeight" enabled="0" diagramOrientation="Up" minScaleDenominator="0">
			<fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
			<attribute label="" color="#000000" field=""/>
		</DiagramCategory>
	</SingleCategoryDiagramRenderer>
	<DiagramLayerSettings obstacle="0" showAll="1" dist="0" linePlacementFlags="18" placement="2" zIndex="0" priority="0">
		<properties>
			<Option type="Map">
				<Option value="" name="name" type="QString"/>
				<Option name="properties"/>
				<Option value="collection" name="type" type="QString"/></Option>
		</properties>
	</DiagramLayerSettings>
	<geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
		<activeChecks/>
		<checkConfiguration/>
	</geometryOptions>
	<fieldConfiguration>
		<field name="arc_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="code">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="node_1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="nodetype_1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="y1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="custom_y1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="elev1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="custom_elev1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_elev1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_y1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="r1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="z1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="node_2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="nodetype_2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="y2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="custom_y2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="elev2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="custom_elev2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_elev2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_y2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="r2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="z2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="slope">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="arc_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="arccat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="matcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="cat_shape">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="cat_geom1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="cat_geom2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="width">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="epa_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="expl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macroexpl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrosector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state_type">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="annotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="gis_length">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="custom_length">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="inverted_slope">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="observ">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="comment">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="dma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrodma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="soilcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="function_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="category_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="fluid_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="location_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="workcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="workcat_id_end">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="builtdate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="enddate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="buildercat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="ownercat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="muni_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcode">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="district_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="streetname">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postnumber">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcomplement">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="streetname2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postnumber2">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcomplement2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="descript">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="link">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="verified">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="undelete">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_x">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_y">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_rotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="publish">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="inventory">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="uncertain">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="num_value">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="tstamp">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="insert_user">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="lastupdate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="lastupdate_user">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
	</fieldConfiguration>
	<aliases>
		<alias index="0" name="" field="arc_id"/>
		<alias index="1" name="" field="code"/>
		<alias index="2" name="" field="node_1"/>
		<alias index="3" name="" field="nodetype_1"/>
		<alias index="4" name="" field="y1"/>
		<alias index="5" name="" field="custom_y1"/>
		<alias index="6" name="" field="elev1"/>
		<alias index="7" name="" field="custom_elev1"/>
		<alias index="8" name="" field="sys_elev1"/>
		<alias index="9" name="" field="sys_y1"/>
		<alias index="10" name="" field="r1"/>
		<alias index="11" name="" field="z1"/>
		<alias index="12" name="" field="node_2"/>
		<alias index="13" name="" field="nodetype_2"/>
		<alias index="14" name="" field="y2"/>
		<alias index="15" name="" field="custom_y2"/>
		<alias index="16" name="" field="elev2"/>
		<alias index="17" name="" field="custom_elev2"/>
		<alias index="18" name="" field="sys_elev2"/>
		<alias index="19" name="" field="sys_y2"/>
		<alias index="20" name="" field="r2"/>
		<alias index="21" name="" field="z2"/>
		<alias index="22" name="" field="slope"/>
		<alias index="23" name="" field="arc_type"/>
		<alias index="24" name="" field="sys_type"/>
		<alias index="25" name="" field="arccat_id"/>
		<alias index="26" name="" field="matcat_id"/>
		<alias index="27" name="" field="cat_shape"/>
		<alias index="28" name="" field="cat_geom1"/>
		<alias index="29" name="" field="cat_geom2"/>
		<alias index="30" name="" field="width"/>
		<alias index="31" name="" field="epa_type"/>
		<alias index="32" name="" field="expl_id"/>
		<alias index="33" name="" field="macroexpl_id"/>
		<alias index="34" name="" field="sector_id"/>
		<alias index="35" name="" field="macrosector_id"/>
		<alias index="36" name="" field="state"/>
		<alias index="37" name="" field="state_type"/>
		<alias index="38" name="" field="annotation"/>
		<alias index="39" name="" field="gis_length"/>
		<alias index="40" name="" field="custom_length"/>
		<alias index="41" name="" field="inverted_slope"/>
		<alias index="42" name="" field="observ"/>
		<alias index="43" name="" field="comment"/>
		<alias index="44" name="" field="dma_id"/>
		<alias index="45" name="" field="macrodma_id"/>
		<alias index="46" name="" field="soilcat_id"/>
		<alias index="47" name="" field="function_type"/>
		<alias index="48" name="" field="category_type"/>
		<alias index="49" name="" field="fluid_type"/>
		<alias index="50" name="" field="location_type"/>
		<alias index="51" name="" field="workcat_id"/>
		<alias index="52" name="" field="workcat_id_end"/>
		<alias index="53" name="" field="builtdate"/>
		<alias index="54" name="" field="enddate"/>
		<alias index="55" name="" field="buildercat_id"/>
		<alias index="56" name="" field="ownercat_id"/>
		<alias index="57" name="" field="muni_id"/>
		<alias index="58" name="" field="postcode"/>
		<alias index="59" name="" field="district_id"/>
		<alias index="60" name="" field="streetname"/>
		<alias index="61" name="" field="postnumber"/>
		<alias index="62" name="" field="postcomplement"/>
		<alias index="63" name="" field="streetname2"/>
		<alias index="64" name="" field="postnumber2"/>
		<alias index="65" name="" field="postcomplement2"/>
		<alias index="66" name="" field="descript"/>
		<alias index="67" name="" field="link"/>
		<alias index="68" name="" field="verified"/>
		<alias index="69" name="" field="undelete"/>
		<alias index="70" name="" field="label"/>
		<alias index="71" name="" field="label_x"/>
		<alias index="72" name="" field="label_y"/>
		<alias index="73" name="" field="label_rotation"/>
		<alias index="74" name="" field="publish"/>
		<alias index="75" name="" field="inventory"/>
		<alias index="76" name="" field="uncertain"/>
		<alias index="77" name="" field="num_value"/>
		<alias index="78" name="" field="tstamp"/>
		<alias index="79" name="" field="insert_user"/>
		<alias index="80" name="" field="lastupdate"/>
		<alias index="81" name="" field="lastupdate_user"/>
	</aliases>
	<excludeAttributesWMS/>
	<excludeAttributesWFS/>
	<defaults>
		<default expression="" applyOnUpdate="0" field="arc_id"/>
		<default expression="" applyOnUpdate="0" field="code"/>
		<default expression="" applyOnUpdate="0" field="node_1"/>
		<default expression="" applyOnUpdate="0" field="nodetype_1"/>
		<default expression="" applyOnUpdate="0" field="y1"/>
		<default expression="" applyOnUpdate="0" field="custom_y1"/>
		<default expression="" applyOnUpdate="0" field="elev1"/>
		<default expression="" applyOnUpdate="0" field="custom_elev1"/>
		<default expression="" applyOnUpdate="0" field="sys_elev1"/>
		<default expression="" applyOnUpdate="0" field="sys_y1"/>
		<default expression="" applyOnUpdate="0" field="r1"/>
		<default expression="" applyOnUpdate="0" field="z1"/>
		<default expression="" applyOnUpdate="0" field="node_2"/>
		<default expression="" applyOnUpdate="0" field="nodetype_2"/>
		<default expression="" applyOnUpdate="0" field="y2"/>
		<default expression="" applyOnUpdate="0" field="custom_y2"/>
		<default expression="" applyOnUpdate="0" field="elev2"/>
		<default expression="" applyOnUpdate="0" field="custom_elev2"/>
		<default expression="" applyOnUpdate="0" field="sys_elev2"/>
		<default expression="" applyOnUpdate="0" field="sys_y2"/>
		<default expression="" applyOnUpdate="0" field="r2"/>
		<default expression="" applyOnUpdate="0" field="z2"/>
		<default expression="" applyOnUpdate="0" field="slope"/>
		<default expression="" applyOnUpdate="0" field="arc_type"/>
		<default expression="" applyOnUpdate="0" field="sys_type"/>
		<default expression="" applyOnUpdate="0" field="arccat_id"/>
		<default expression="" applyOnUpdate="0" field="matcat_id"/>
		<default expression="" applyOnUpdate="0" field="cat_shape"/>
		<default expression="" applyOnUpdate="0" field="cat_geom1"/>
		<default expression="" applyOnUpdate="0" field="cat_geom2"/>
		<default expression="" applyOnUpdate="0" field="width"/>
		<default expression="" applyOnUpdate="0" field="epa_type"/>
		<default expression="" applyOnUpdate="0" field="expl_id"/>
		<default expression="" applyOnUpdate="0" field="macroexpl_id"/>
		<default expression="" applyOnUpdate="0" field="sector_id"/>
		<default expression="" applyOnUpdate="0" field="macrosector_id"/>
		<default expression="" applyOnUpdate="0" field="state"/>
		<default expression="" applyOnUpdate="0" field="state_type"/>
		<default expression="" applyOnUpdate="0" field="annotation"/>
		<default expression="" applyOnUpdate="0" field="gis_length"/>
		<default expression="" applyOnUpdate="0" field="custom_length"/>
		<default expression="" applyOnUpdate="0" field="inverted_slope"/>
		<default expression="" applyOnUpdate="0" field="observ"/>
		<default expression="" applyOnUpdate="0" field="comment"/>
		<default expression="" applyOnUpdate="0" field="dma_id"/>
		<default expression="" applyOnUpdate="0" field="macrodma_id"/>
		<default expression="" applyOnUpdate="0" field="soilcat_id"/>
		<default expression="" applyOnUpdate="0" field="function_type"/>
		<default expression="" applyOnUpdate="0" field="category_type"/>
		<default expression="" applyOnUpdate="0" field="fluid_type"/>
		<default expression="" applyOnUpdate="0" field="location_type"/>
		<default expression="" applyOnUpdate="0" field="workcat_id"/>
		<default expression="" applyOnUpdate="0" field="workcat_id_end"/>
		<default expression="" applyOnUpdate="0" field="builtdate"/>
		<default expression="" applyOnUpdate="0" field="enddate"/>
		<default expression="" applyOnUpdate="0" field="buildercat_id"/>
		<default expression="" applyOnUpdate="0" field="ownercat_id"/>
		<default expression="" applyOnUpdate="0" field="muni_id"/>
		<default expression="" applyOnUpdate="0" field="postcode"/>
		<default expression="" applyOnUpdate="0" field="district_id"/>
		<default expression="" applyOnUpdate="0" field="streetname"/>
		<default expression="" applyOnUpdate="0" field="postnumber"/>
		<default expression="" applyOnUpdate="0" field="postcomplement"/>
		<default expression="" applyOnUpdate="0" field="streetname2"/>
		<default expression="" applyOnUpdate="0" field="postnumber2"/>
		<default expression="" applyOnUpdate="0" field="postcomplement2"/>
		<default expression="" applyOnUpdate="0" field="descript"/>
		<default expression="" applyOnUpdate="0" field="link"/>
		<default expression="" applyOnUpdate="0" field="verified"/>
		<default expression="" applyOnUpdate="0" field="undelete"/>
		<default expression="" applyOnUpdate="0" field="label"/>
		<default expression="" applyOnUpdate="0" field="label_x"/>
		<default expression="" applyOnUpdate="0" field="label_y"/>
		<default expression="" applyOnUpdate="0" field="label_rotation"/>
		<default expression="" applyOnUpdate="0" field="publish"/>
		<default expression="" applyOnUpdate="0" field="inventory"/>
		<default expression="" applyOnUpdate="0" field="uncertain"/>
		<default expression="" applyOnUpdate="0" field="num_value"/>
		<default expression="" applyOnUpdate="0" field="tstamp"/>
		<default expression="" applyOnUpdate="0" field="insert_user"/>
		<default expression="" applyOnUpdate="0" field="lastupdate"/>
		<default expression="" applyOnUpdate="0" field="lastupdate_user"/>
	</defaults>
	<constraints>
		<constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="arc_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="code"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="node_1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="nodetype_1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="y1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_y1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="elev1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_elev1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_elev1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_y1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="r1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="z1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="node_2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="nodetype_2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="y2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_y2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="elev2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_elev2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_elev2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_y2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="r2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="z2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="slope"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="arc_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="arccat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="matcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="cat_shape"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="cat_geom1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="cat_geom2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="width"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="epa_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macroexpl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrosector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="annotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="gis_length"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_length"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="inverted_slope"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="observ"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="comment"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="dma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrodma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="soilcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="function_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="category_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="fluid_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="location_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id_end"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="builtdate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="enddate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="buildercat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="ownercat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="muni_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcode"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="district_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="descript"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="link"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="verified"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="undelete"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_x"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_y"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_rotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="publish"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="inventory"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="uncertain"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="num_value"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="tstamp"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="insert_user"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate_user"/>
	</constraints>
	<constraintExpressions>
		<constraint desc="" exp="" field="arc_id"/>
		<constraint desc="" exp="" field="code"/>
		<constraint desc="" exp="" field="node_1"/>
		<constraint desc="" exp="" field="nodetype_1"/>
		<constraint desc="" exp="" field="y1"/>
		<constraint desc="" exp="" field="custom_y1"/>
		<constraint desc="" exp="" field="elev1"/>
		<constraint desc="" exp="" field="custom_elev1"/>
		<constraint desc="" exp="" field="sys_elev1"/>
		<constraint desc="" exp="" field="sys_y1"/>
		<constraint desc="" exp="" field="r1"/>
		<constraint desc="" exp="" field="z1"/>
		<constraint desc="" exp="" field="node_2"/>
		<constraint desc="" exp="" field="nodetype_2"/>
		<constraint desc="" exp="" field="y2"/>
		<constraint desc="" exp="" field="custom_y2"/>
		<constraint desc="" exp="" field="elev2"/>
		<constraint desc="" exp="" field="custom_elev2"/>
		<constraint desc="" exp="" field="sys_elev2"/>
		<constraint desc="" exp="" field="sys_y2"/>
		<constraint desc="" exp="" field="r2"/>
		<constraint desc="" exp="" field="z2"/>
		<constraint desc="" exp="" field="slope"/>
		<constraint desc="" exp="" field="arc_type"/>
		<constraint desc="" exp="" field="sys_type"/>
		<constraint desc="" exp="" field="arccat_id"/>
		<constraint desc="" exp="" field="matcat_id"/>
		<constraint desc="" exp="" field="cat_shape"/>
		<constraint desc="" exp="" field="cat_geom1"/>
		<constraint desc="" exp="" field="cat_geom2"/>
		<constraint desc="" exp="" field="width"/>
		<constraint desc="" exp="" field="epa_type"/>
		<constraint desc="" exp="" field="expl_id"/>
		<constraint desc="" exp="" field="macroexpl_id"/>
		<constraint desc="" exp="" field="sector_id"/>
		<constraint desc="" exp="" field="macrosector_id"/>
		<constraint desc="" exp="" field="state"/>
		<constraint desc="" exp="" field="state_type"/>
		<constraint desc="" exp="" field="annotation"/>
		<constraint desc="" exp="" field="gis_length"/>
		<constraint desc="" exp="" field="custom_length"/>
		<constraint desc="" exp="" field="inverted_slope"/>
		<constraint desc="" exp="" field="observ"/>
		<constraint desc="" exp="" field="comment"/>
		<constraint desc="" exp="" field="dma_id"/>
		<constraint desc="" exp="" field="macrodma_id"/>
		<constraint desc="" exp="" field="soilcat_id"/>
		<constraint desc="" exp="" field="function_type"/>
		<constraint desc="" exp="" field="category_type"/>
		<constraint desc="" exp="" field="fluid_type"/>
		<constraint desc="" exp="" field="location_type"/>
		<constraint desc="" exp="" field="workcat_id"/>
		<constraint desc="" exp="" field="workcat_id_end"/>
		<constraint desc="" exp="" field="builtdate"/>
		<constraint desc="" exp="" field="enddate"/>
		<constraint desc="" exp="" field="buildercat_id"/>
		<constraint desc="" exp="" field="ownercat_id"/>
		<constraint desc="" exp="" field="muni_id"/>
		<constraint desc="" exp="" field="postcode"/>
		<constraint desc="" exp="" field="district_id"/>
		<constraint desc="" exp="" field="streetname"/>
		<constraint desc="" exp="" field="postnumber"/>
		<constraint desc="" exp="" field="postcomplement"/>
		<constraint desc="" exp="" field="streetname2"/>
		<constraint desc="" exp="" field="postnumber2"/>
		<constraint desc="" exp="" field="postcomplement2"/>
		<constraint desc="" exp="" field="descript"/>
		<constraint desc="" exp="" field="link"/>
		<constraint desc="" exp="" field="verified"/>
		<constraint desc="" exp="" field="undelete"/>
		<constraint desc="" exp="" field="label"/>
		<constraint desc="" exp="" field="label_x"/>
		<constraint desc="" exp="" field="label_y"/>
		<constraint desc="" exp="" field="label_rotation"/>
		<constraint desc="" exp="" field="publish"/>
		<constraint desc="" exp="" field="inventory"/>
		<constraint desc="" exp="" field="uncertain"/>
		<constraint desc="" exp="" field="num_value"/>
		<constraint desc="" exp="" field="tstamp"/>
		<constraint desc="" exp="" field="insert_user"/>
		<constraint desc="" exp="" field="lastupdate"/>
		<constraint desc="" exp="" field="lastupdate_user"/>
	</constraintExpressions>
	<expressionfields/>
	<attributeactions>
		<defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
	</attributeactions>
	<attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
		<columns>
			<column width="-1" name="arc_id" type="field" hidden="0"/>
			<column width="-1" name="code" type="field" hidden="0"/>
			<column width="-1" name="node_1" type="field" hidden="0"/>
			<column width="-1" name="nodetype_1" type="field" hidden="0"/>
			<column width="-1" name="y1" type="field" hidden="0"/>
			<column width="-1" name="custom_y1" type="field" hidden="0"/>
			<column width="-1" name="elev1" type="field" hidden="0"/>
			<column width="-1" name="custom_elev1" type="field" hidden="0"/>
			<column width="-1" name="sys_elev1" type="field" hidden="0"/>
			<column width="-1" name="sys_y1" type="field" hidden="0"/>
			<column width="-1" name="r1" type="field" hidden="0"/>
			<column width="-1" name="z1" type="field" hidden="0"/>
			<column width="-1" name="node_2" type="field" hidden="0"/>
			<column width="-1" name="nodetype_2" type="field" hidden="0"/>
			<column width="-1" name="y2" type="field" hidden="0"/>
			<column width="-1" name="custom_y2" type="field" hidden="0"/>
			<column width="-1" name="elev2" type="field" hidden="0"/>
			<column width="-1" name="custom_elev2" type="field" hidden="0"/>
			<column width="-1" name="sys_elev2" type="field" hidden="0"/>
			<column width="-1" name="sys_y2" type="field" hidden="0"/>
			<column width="-1" name="r2" type="field" hidden="0"/>
			<column width="-1" name="z2" type="field" hidden="0"/>
			<column width="-1" name="slope" type="field" hidden="0"/>
			<column width="-1" name="arc_type" type="field" hidden="0"/>
			<column width="-1" name="sys_type" type="field" hidden="0"/>
			<column width="-1" name="arccat_id" type="field" hidden="0"/>
			<column width="-1" name="matcat_id" type="field" hidden="0"/>
			<column width="-1" name="cat_shape" type="field" hidden="0"/>
			<column width="-1" name="cat_geom1" type="field" hidden="0"/>
			<column width="-1" name="cat_geom2" type="field" hidden="0"/>
			<column width="-1" name="width" type="field" hidden="0"/>
			<column width="-1" name="epa_type" type="field" hidden="0"/>
			<column width="-1" name="expl_id" type="field" hidden="0"/>
			<column width="-1" name="macroexpl_id" type="field" hidden="0"/>
			<column width="-1" name="sector_id" type="field" hidden="0"/>
			<column width="-1" name="macrosector_id" type="field" hidden="0"/>
			<column width="-1" name="state" type="field" hidden="0"/>
			<column width="-1" name="state_type" type="field" hidden="0"/>
			<column width="-1" name="annotation" type="field" hidden="0"/>
			<column width="-1" name="gis_length" type="field" hidden="0"/>
			<column width="-1" name="custom_length" type="field" hidden="0"/>
			<column width="-1" name="inverted_slope" type="field" hidden="0"/>
			<column width="-1" name="observ" type="field" hidden="0"/>
			<column width="-1" name="comment" type="field" hidden="0"/>
			<column width="-1" name="dma_id" type="field" hidden="0"/>
			<column width="-1" name="macrodma_id" type="field" hidden="0"/>
			<column width="-1" name="soilcat_id" type="field" hidden="0"/>
			<column width="-1" name="function_type" type="field" hidden="0"/>
			<column width="-1" name="category_type" type="field" hidden="0"/>
			<column width="-1" name="fluid_type" type="field" hidden="0"/>
			<column width="-1" name="location_type" type="field" hidden="0"/>
			<column width="-1" name="workcat_id" type="field" hidden="0"/>
			<column width="-1" name="workcat_id_end" type="field" hidden="0"/>
			<column width="-1" name="builtdate" type="field" hidden="0"/>
			<column width="-1" name="enddate" type="field" hidden="0"/>
			<column width="-1" name="buildercat_id" type="field" hidden="0"/>
			<column width="-1" name="ownercat_id" type="field" hidden="0"/>
			<column width="-1" name="muni_id" type="field" hidden="0"/>
			<column width="-1" name="postcode" type="field" hidden="0"/>
			<column width="-1" name="district_id" type="field" hidden="0"/>
			<column width="-1" name="streetname" type="field" hidden="0"/>
			<column width="-1" name="postnumber" type="field" hidden="0"/>
			<column width="-1" name="postcomplement" type="field" hidden="0"/>
			<column width="-1" name="streetname2" type="field" hidden="0"/>
			<column width="-1" name="postnumber2" type="field" hidden="0"/>
			<column width="-1" name="postcomplement2" type="field" hidden="0"/>
			<column width="-1" name="descript" type="field" hidden="0"/>
			<column width="-1" name="link" type="field" hidden="0"/>
			<column width="-1" name="verified" type="field" hidden="0"/>
			<column width="-1" name="undelete" type="field" hidden="0"/>
			<column width="-1" name="label" type="field" hidden="0"/>
			<column width="-1" name="label_x" type="field" hidden="0"/>
			<column width="-1" name="label_y" type="field" hidden="0"/>
			<column width="-1" name="label_rotation" type="field" hidden="0"/>
			<column width="-1" name="publish" type="field" hidden="0"/>
			<column width="-1" name="inventory" type="field" hidden="0"/>
			<column width="-1" name="uncertain" type="field" hidden="0"/>
			<column width="-1" name="num_value" type="field" hidden="0"/>
			<column width="-1" name="tstamp" type="field" hidden="0"/>
			<column width="-1" name="insert_user" type="field" hidden="0"/>
			<column width="-1" name="lastupdate" type="field" hidden="0"/>
			<column width="-1" name="lastupdate_user" type="field" hidden="0"/>
			<column width="-1" type="actions" hidden="1"/>
		</columns>
	</attributetableconfig>
	<conditionalstyles>
		<rowstyles/>
		<fieldstyles/>
	</conditionalstyles>
	<storedexpressions/>
	<editform tolerant="1"></editform>
	<editforminit/>
	<editforminitcodesource>0</editforminitcodesource>
	<editforminitfilepath></editforminitfilepath>
	<editforminitcode>
		<![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]>
	</editforminitcode>
	<featformsuppress>0</featformsuppress>
	<editorlayout>generatedlayout</editorlayout>
	<editable>
		<field name="annotation" editable="1"/>
		<field name="arc_id" editable="1"/>
		<field name="arc_type" editable="1"/>
		<field name="arccat_id" editable="1"/>
		<field name="buildercat_id" editable="1"/>
		<field name="builtdate" editable="1"/>
		<field name="cat_geom1" editable="1"/>
		<field name="cat_geom2" editable="1"/>
		<field name="cat_shape" editable="1"/>
		<field name="category_type" editable="1"/>
		<field name="code" editable="1"/>
		<field name="comment" editable="1"/>
		<field name="custom_elev1" editable="1"/>
		<field name="custom_elev2" editable="1"/>
		<field name="custom_length" editable="1"/>
		<field name="custom_y1" editable="1"/>
		<field name="custom_y2" editable="1"/>
		<field name="descript" editable="1"/>
		<field name="district_id" editable="1"/>
		<field name="dma_id" editable="1"/>
		<field name="elev1" editable="1"/>
		<field name="elev2" editable="1"/>
		<field name="enddate" editable="1"/>
		<field name="epa_type" editable="1"/>
		<field name="expl_id" editable="1"/>
		<field name="fluid_type" editable="1"/>
		<field name="function_type" editable="1"/>
		<field name="gis_length" editable="1"/>
		<field name="insert_user" editable="1"/>
		<field name="inventory" editable="1"/>
		<field name="inverted_slope" editable="1"/>
		<field name="label" editable="1"/>
		<field name="label_rotation" editable="1"/>
		<field name="label_x" editable="1"/>
		<field name="label_y" editable="1"/>
		<field name="lastupdate" editable="1"/>
		<field name="lastupdate_user" editable="1"/>
		<field name="link" editable="1"/>
		<field name="location_type" editable="1"/>
		<field name="macrodma_id" editable="1"/>
		<field name="macroexpl_id" editable="1"/>
		<field name="macrosector_id" editable="1"/>
		<field name="matcat_id" editable="1"/>
		<field name="muni_id" editable="1"/>
		<field name="node_1" editable="1"/>
		<field name="node_2" editable="1"/>
		<field name="nodetype_1" editable="1"/>
		<field name="nodetype_2" editable="1"/>
		<field name="num_value" editable="1"/>
		<field name="observ" editable="1"/>
		<field name="ownercat_id" editable="1"/>
		<field name="postcode" editable="1"/>
		<field name="postcomplement" editable="1"/>
		<field name="postcomplement2" editable="1"/>
		<field name="postnumber" editable="1"/>
		<field name="postnumber2" editable="1"/>
		<field name="publish" editable="1"/>
		<field name="r1" editable="1"/>
		<field name="r2" editable="1"/>
		<field name="sector_id" editable="1"/>
		<field name="slope" editable="1"/>
		<field name="soilcat_id" editable="1"/>
		<field name="state" editable="1"/>
		<field name="state_type" editable="1"/>
		<field name="streetname" editable="1"/>
		<field name="streetname2" editable="1"/>
		<field name="sys_elev1" editable="1"/>
		<field name="sys_elev2" editable="1"/>
		<field name="sys_type" editable="1"/>
		<field name="sys_y1" editable="1"/>
		<field name="sys_y2" editable="1"/>
		<field name="tstamp" editable="1"/>
		<field name="uncertain" editable="1"/>
		<field name="undelete" editable="1"/>
		<field name="verified" editable="1"/>
		<field name="width" editable="1"/>
		<field name="workcat_id" editable="1"/>
		<field name="workcat_id_end" editable="1"/>
		<field name="y1" editable="1"/>
		<field name="y2" editable="1"/>
		<field name="z1" editable="1"/>
		<field name="z2" editable="1"/>
	</editable>
	<labelOnTop>
		<field name="annotation" labelOnTop="0"/>
		<field name="arc_id" labelOnTop="0"/>
		<field name="arc_type" labelOnTop="0"/>
		<field name="arccat_id" labelOnTop="0"/>
		<field name="buildercat_id" labelOnTop="0"/>
		<field name="builtdate" labelOnTop="0"/>
		<field name="cat_geom1" labelOnTop="0"/>
		<field name="cat_geom2" labelOnTop="0"/>
		<field name="cat_shape" labelOnTop="0"/>
		<field name="category_type" labelOnTop="0"/>
		<field name="code" labelOnTop="0"/>
		<field name="comment" labelOnTop="0"/>
		<field name="custom_elev1" labelOnTop="0"/>
		<field name="custom_elev2" labelOnTop="0"/>
		<field name="custom_length" labelOnTop="0"/>
		<field name="custom_y1" labelOnTop="0"/>
		<field name="custom_y2" labelOnTop="0"/>
		<field name="descript" labelOnTop="0"/>
		<field name="district_id" labelOnTop="0"/>
		<field name="dma_id" labelOnTop="0"/>
		<field name="elev1" labelOnTop="0"/>
		<field name="elev2" labelOnTop="0"/>
		<field name="enddate" labelOnTop="0"/>
		<field name="epa_type" labelOnTop="0"/>
		<field name="expl_id" labelOnTop="0"/>
		<field name="fluid_type" labelOnTop="0"/>
		<field name="function_type" labelOnTop="0"/>
		<field name="gis_length" labelOnTop="0"/>
		<field name="insert_user" labelOnTop="0"/>
		<field name="inventory" labelOnTop="0"/>
		<field name="inverted_slope" labelOnTop="0"/>
		<field name="label" labelOnTop="0"/>
		<field name="label_rotation" labelOnTop="0"/>
		<field name="label_x" labelOnTop="0"/>
		<field name="label_y" labelOnTop="0"/>
		<field name="lastupdate" labelOnTop="0"/>
		<field name="lastupdate_user" labelOnTop="0"/>
		<field name="link" labelOnTop="0"/>
		<field name="location_type" labelOnTop="0"/>
		<field name="macrodma_id" labelOnTop="0"/>
		<field name="macroexpl_id" labelOnTop="0"/>
		<field name="macrosector_id" labelOnTop="0"/>
		<field name="matcat_id" labelOnTop="0"/>
		<field name="muni_id" labelOnTop="0"/>
		<field name="node_1" labelOnTop="0"/>
		<field name="node_2" labelOnTop="0"/>
		<field name="nodetype_1" labelOnTop="0"/>
		<field name="nodetype_2" labelOnTop="0"/>
		<field name="num_value" labelOnTop="0"/>
		<field name="observ" labelOnTop="0"/>
		<field name="ownercat_id" labelOnTop="0"/>
		<field name="postcode" labelOnTop="0"/>
		<field name="postcomplement" labelOnTop="0"/>
		<field name="postcomplement2" labelOnTop="0"/>
		<field name="postnumber" labelOnTop="0"/>
		<field name="postnumber2" labelOnTop="0"/>
		<field name="publish" labelOnTop="0"/>
		<field name="r1" labelOnTop="0"/>
		<field name="r2" labelOnTop="0"/>
		<field name="sector_id" labelOnTop="0"/>
		<field name="slope" labelOnTop="0"/>
		<field name="soilcat_id" labelOnTop="0"/>
		<field name="state" labelOnTop="0"/>
		<field name="state_type" labelOnTop="0"/>
		<field name="streetname" labelOnTop="0"/>
		<field name="streetname2" labelOnTop="0"/>
		<field name="sys_elev1" labelOnTop="0"/>
		<field name="sys_elev2" labelOnTop="0"/>
		<field name="sys_type" labelOnTop="0"/>
		<field name="sys_y1" labelOnTop="0"/>
		<field name="sys_y2" labelOnTop="0"/>
		<field name="tstamp" labelOnTop="0"/>
		<field name="uncertain" labelOnTop="0"/>
		<field name="undelete" labelOnTop="0"/>
		<field name="verified" labelOnTop="0"/>
		<field name="width" labelOnTop="0"/>
		<field name="workcat_id" labelOnTop="0"/>
		<field name="workcat_id_end" labelOnTop="0"/>
		<field name="y1" labelOnTop="0"/>
		<field name="y2" labelOnTop="0"/>
		<field name="z1" labelOnTop="0"/>
		<field name="z2" labelOnTop="0"/>
	</labelOnTop>
	<widgets/>
	<previewExpression>streetname</previewExpression>
	<mapTip></mapTip>
	<layerGeometryType>1</layerGeometryType>
</qgis>$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('102', 'v_edit_connec',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="1" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1500" simplifyDrawingHints="0">
	<flags>
		<Identifiable>1</Identifiable>
		<Removable>1</Removable>
		<Searchable>1</Searchable>
	</flags>
	<renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="singleSymbol">
		<symbols>
			<symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
				<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
					<prop k="angle" v="0"/>
					<prop k="color" v="49,180,227,255"/>
					<prop k="horizontal_anchor_point" v="1"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="name" v="circle"/>
					<prop k="offset" v="0,0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="outline_color" v="49,180,227,255"/>
					<prop k="outline_style" v="solid"/>
					<prop k="outline_width" v="0"/>
					<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="outline_width_unit" v="MM"/>
					<prop k="scale_method" v="diameter"/>
					<prop k="size" v="2"/>
					<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="size_unit" v="MM"/>
					<prop k="vertical_anchor_point" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties"/>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
					<prop k="angle" v="0"/>
					<prop k="color" v="255,0,0,255"/>
					<prop k="horizontal_anchor_point" v="1"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="name" v="cross"/>
					<prop k="offset" v="0,0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="outline_color" v="0,0,0,255"/>
					<prop k="outline_style" v="solid"/>
					<prop k="outline_width" v="0"/>
					<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="outline_width_unit" v="MM"/>
					<prop k="scale_method" v="diameter"/>
					<prop k="size" v="3"/>
					<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="size_unit" v="MM"/>
					<prop k="vertical_anchor_point" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties"/>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
			</symbol>
		</symbols>
		<rotation/>
		<sizescale/>
	</renderer-v2>
	<customproperties>
		<property value="0" key="embeddedWidgets/count"/>
		<property key="variableNames"/>
		<property key="variableValues"/>
	</customproperties>
	<blendMode>0</blendMode>
	<featureBlendMode>0</featureBlendMode>
	<layerOpacity>1</layerOpacity>
	<SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
		<DiagramCategory penColor="#000000" lineSizeType="MM" height="15" scaleBasedVisibility="0" opacity="1" barWidth="5" scaleDependency="Area" penAlpha="255" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" maxScaleDenominator="1e+08" sizeScale="3x:0,0,0,0,0,0" sizeType="MM" backgroundColor="#ffffff" penWidth="0" width="15" labelPlacementMethod="XHeight" enabled="0" diagramOrientation="Up" minScaleDenominator="0">
			<fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
			<attribute label="" color="#000000" field=""/>
		</DiagramCategory>
	</SingleCategoryDiagramRenderer>
	<DiagramLayerSettings obstacle="0" showAll="1" dist="0" linePlacementFlags="18" placement="0" zIndex="0" priority="0">
		<properties>
			<Option type="Map">
				<Option value="" name="name" type="QString"/>
				<Option name="properties"/>
				<Option value="collection" name="type" type="QString"/></Option>
		</properties>
	</DiagramLayerSettings>
	<geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
		<activeChecks/>
		<checkConfiguration/>
	</geometryOptions>
	<fieldConfiguration>
		<field name="connec_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="code">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="customer_code">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="top_elev">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="y1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="y2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connecat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connec_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="private_connecat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="matcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="expl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macroexpl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrosector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="demand">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state_type">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connec_depth">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connec_length">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="arc_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="annotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="observ">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="comment">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="dma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrodma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="soilcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="function_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="category_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="fluid_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="location_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="workcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="workcat_id_end">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="buildercat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="builtdate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="enddate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="ownercat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="muni_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcode">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="district_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="streetname">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postnumber">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcomplement">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="streetname2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postnumber2">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcomplement2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="descript">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="svg">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="rotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="link">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="verified">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="undelete">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_x">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_y">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_rotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="accessibility">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="diagonal">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="publish">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="inventory">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="uncertain">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="num_value">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="feature_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="featurecat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="pjoint_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="pjoint_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="tstamp">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="insert_user">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="lastupdate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="lastupdate_user">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
	</fieldConfiguration>
	<aliases>
		<alias index="0" name="" field="connec_id"/>
		<alias index="1" name="" field="code"/>
		<alias index="2" name="" field="customer_code"/>
		<alias index="3" name="" field="top_elev"/>
		<alias index="4" name="" field="y1"/>
		<alias index="5" name="" field="y2"/>
		<alias index="6" name="" field="connecat_id"/>
		<alias index="7" name="" field="connec_type"/>
		<alias index="8" name="" field="sys_type"/>
		<alias index="9" name="" field="private_connecat_id"/>
		<alias index="10" name="" field="matcat_id"/>
		<alias index="11" name="" field="expl_id"/>
		<alias index="12" name="" field="macroexpl_id"/>
		<alias index="13" name="" field="sector_id"/>
		<alias index="14" name="" field="macrosector_id"/>
		<alias index="15" name="" field="demand"/>
		<alias index="16" name="" field="state"/>
		<alias index="17" name="" field="state_type"/>
		<alias index="18" name="" field="connec_depth"/>
		<alias index="19" name="" field="connec_length"/>
		<alias index="20" name="" field="arc_id"/>
		<alias index="21" name="" field="annotation"/>
		<alias index="22" name="" field="observ"/>
		<alias index="23" name="" field="comment"/>
		<alias index="24" name="" field="dma_id"/>
		<alias index="25" name="" field="macrodma_id"/>
		<alias index="26" name="" field="soilcat_id"/>
		<alias index="27" name="" field="function_type"/>
		<alias index="28" name="" field="category_type"/>
		<alias index="29" name="" field="fluid_type"/>
		<alias index="30" name="" field="location_type"/>
		<alias index="31" name="" field="workcat_id"/>
		<alias index="32" name="" field="workcat_id_end"/>
		<alias index="33" name="" field="buildercat_id"/>
		<alias index="34" name="" field="builtdate"/>
		<alias index="35" name="" field="enddate"/>
		<alias index="36" name="" field="ownercat_id"/>
		<alias index="37" name="" field="muni_id"/>
		<alias index="38" name="" field="postcode"/>
		<alias index="39" name="" field="district_id"/>
		<alias index="40" name="" field="streetname"/>
		<alias index="41" name="" field="postnumber"/>
		<alias index="42" name="" field="postcomplement"/>
		<alias index="43" name="" field="streetname2"/>
		<alias index="44" name="" field="postnumber2"/>
		<alias index="45" name="" field="postcomplement2"/>
		<alias index="46" name="" field="descript"/>
		<alias index="47" name="" field="svg"/>
		<alias index="48" name="" field="rotation"/>
		<alias index="49" name="" field="link"/>
		<alias index="50" name="" field="verified"/>
		<alias index="51" name="" field="undelete"/>
		<alias index="52" name="" field="label"/>
		<alias index="53" name="" field="label_x"/>
		<alias index="54" name="" field="label_y"/>
		<alias index="55" name="" field="label_rotation"/>
		<alias index="56" name="" field="accessibility"/>
		<alias index="57" name="" field="diagonal"/>
		<alias index="58" name="" field="publish"/>
		<alias index="59" name="" field="inventory"/>
		<alias index="60" name="" field="uncertain"/>
		<alias index="61" name="" field="num_value"/>
		<alias index="62" name="" field="feature_id"/>
		<alias index="63" name="" field="featurecat_id"/>
		<alias index="64" name="" field="pjoint_id"/>
		<alias index="65" name="" field="pjoint_type"/>
		<alias index="66" name="" field="tstamp"/>
		<alias index="67" name="" field="insert_user"/>
		<alias index="68" name="" field="lastupdate"/>
		<alias index="69" name="" field="lastupdate_user"/>
	</aliases>
	<excludeAttributesWMS/>
	<excludeAttributesWFS/>
	<defaults>
		<default expression="" applyOnUpdate="0" field="connec_id"/>
		<default expression="" applyOnUpdate="0" field="code"/>
		<default expression="" applyOnUpdate="0" field="customer_code"/>
		<default expression="" applyOnUpdate="0" field="top_elev"/>
		<default expression="" applyOnUpdate="0" field="y1"/>
		<default expression="" applyOnUpdate="0" field="y2"/>
		<default expression="" applyOnUpdate="0" field="connecat_id"/>
		<default expression="" applyOnUpdate="0" field="connec_type"/>
		<default expression="" applyOnUpdate="0" field="sys_type"/>
		<default expression="" applyOnUpdate="0" field="private_connecat_id"/>
		<default expression="" applyOnUpdate="0" field="matcat_id"/>
		<default expression="" applyOnUpdate="0" field="expl_id"/>
		<default expression="" applyOnUpdate="0" field="macroexpl_id"/>
		<default expression="" applyOnUpdate="0" field="sector_id"/>
		<default expression="" applyOnUpdate="0" field="macrosector_id"/>
		<default expression="" applyOnUpdate="0" field="demand"/>
		<default expression="" applyOnUpdate="0" field="state"/>
		<default expression="" applyOnUpdate="0" field="state_type"/>
		<default expression="" applyOnUpdate="0" field="connec_depth"/>
		<default expression="" applyOnUpdate="0" field="connec_length"/>
		<default expression="" applyOnUpdate="0" field="arc_id"/>
		<default expression="" applyOnUpdate="0" field="annotation"/>
		<default expression="" applyOnUpdate="0" field="observ"/>
		<default expression="" applyOnUpdate="0" field="comment"/>
		<default expression="" applyOnUpdate="0" field="dma_id"/>
		<default expression="" applyOnUpdate="0" field="macrodma_id"/>
		<default expression="" applyOnUpdate="0" field="soilcat_id"/>
		<default expression="" applyOnUpdate="0" field="function_type"/>
		<default expression="" applyOnUpdate="0" field="category_type"/>
		<default expression="" applyOnUpdate="0" field="fluid_type"/>
		<default expression="" applyOnUpdate="0" field="location_type"/>
		<default expression="" applyOnUpdate="0" field="workcat_id"/>
		<default expression="" applyOnUpdate="0" field="workcat_id_end"/>
		<default expression="" applyOnUpdate="0" field="buildercat_id"/>
		<default expression="" applyOnUpdate="0" field="builtdate"/>
		<default expression="" applyOnUpdate="0" field="enddate"/>
		<default expression="" applyOnUpdate="0" field="ownercat_id"/>
		<default expression="" applyOnUpdate="0" field="muni_id"/>
		<default expression="" applyOnUpdate="0" field="postcode"/>
		<default expression="" applyOnUpdate="0" field="district_id"/>
		<default expression="" applyOnUpdate="0" field="streetname"/>
		<default expression="" applyOnUpdate="0" field="postnumber"/>
		<default expression="" applyOnUpdate="0" field="postcomplement"/>
		<default expression="" applyOnUpdate="0" field="streetname2"/>
		<default expression="" applyOnUpdate="0" field="postnumber2"/>
		<default expression="" applyOnUpdate="0" field="postcomplement2"/>
		<default expression="" applyOnUpdate="0" field="descript"/>
		<default expression="" applyOnUpdate="0" field="svg"/>
		<default expression="" applyOnUpdate="0" field="rotation"/>
		<default expression="" applyOnUpdate="0" field="link"/>
		<default expression="" applyOnUpdate="0" field="verified"/>
		<default expression="" applyOnUpdate="0" field="undelete"/>
		<default expression="" applyOnUpdate="0" field="label"/>
		<default expression="" applyOnUpdate="0" field="label_x"/>
		<default expression="" applyOnUpdate="0" field="label_y"/>
		<default expression="" applyOnUpdate="0" field="label_rotation"/>
		<default expression="" applyOnUpdate="0" field="accessibility"/>
		<default expression="" applyOnUpdate="0" field="diagonal"/>
		<default expression="" applyOnUpdate="0" field="publish"/>
		<default expression="" applyOnUpdate="0" field="inventory"/>
		<default expression="" applyOnUpdate="0" field="uncertain"/>
		<default expression="" applyOnUpdate="0" field="num_value"/>
		<default expression="" applyOnUpdate="0" field="feature_id"/>
		<default expression="" applyOnUpdate="0" field="featurecat_id"/>
		<default expression="" applyOnUpdate="0" field="pjoint_id"/>
		<default expression="" applyOnUpdate="0" field="pjoint_type"/>
		<default expression="" applyOnUpdate="0" field="tstamp"/>
		<default expression="" applyOnUpdate="0" field="insert_user"/>
		<default expression="" applyOnUpdate="0" field="lastupdate"/>
		<default expression="" applyOnUpdate="0" field="lastupdate_user"/>
	</defaults>
	<constraints>
		<constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="connec_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="code"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="customer_code"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="top_elev"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="y1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="y2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connecat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connec_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="private_connecat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="matcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macroexpl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrosector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="demand"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connec_depth"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connec_length"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="arc_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="annotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="observ"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="comment"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="dma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrodma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="soilcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="function_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="category_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="fluid_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="location_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id_end"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="buildercat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="builtdate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="enddate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="ownercat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="muni_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcode"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="district_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="descript"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="svg"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="rotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="link"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="verified"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="undelete"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_x"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_y"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_rotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="accessibility"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="diagonal"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="publish"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="inventory"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="uncertain"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="num_value"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="feature_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="featurecat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="pjoint_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="pjoint_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="tstamp"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="insert_user"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate_user"/>
	</constraints>
	<constraintExpressions>
		<constraint desc="" exp="" field="connec_id"/>
		<constraint desc="" exp="" field="code"/>
		<constraint desc="" exp="" field="customer_code"/>
		<constraint desc="" exp="" field="top_elev"/>
		<constraint desc="" exp="" field="y1"/>
		<constraint desc="" exp="" field="y2"/>
		<constraint desc="" exp="" field="connecat_id"/>
		<constraint desc="" exp="" field="connec_type"/>
		<constraint desc="" exp="" field="sys_type"/>
		<constraint desc="" exp="" field="private_connecat_id"/>
		<constraint desc="" exp="" field="matcat_id"/>
		<constraint desc="" exp="" field="expl_id"/>
		<constraint desc="" exp="" field="macroexpl_id"/>
		<constraint desc="" exp="" field="sector_id"/>
		<constraint desc="" exp="" field="macrosector_id"/>
		<constraint desc="" exp="" field="demand"/>
		<constraint desc="" exp="" field="state"/>
		<constraint desc="" exp="" field="state_type"/>
		<constraint desc="" exp="" field="connec_depth"/>
		<constraint desc="" exp="" field="connec_length"/>
		<constraint desc="" exp="" field="arc_id"/>
		<constraint desc="" exp="" field="annotation"/>
		<constraint desc="" exp="" field="observ"/>
		<constraint desc="" exp="" field="comment"/>
		<constraint desc="" exp="" field="dma_id"/>
		<constraint desc="" exp="" field="macrodma_id"/>
		<constraint desc="" exp="" field="soilcat_id"/>
		<constraint desc="" exp="" field="function_type"/>
		<constraint desc="" exp="" field="category_type"/>
		<constraint desc="" exp="" field="fluid_type"/>
		<constraint desc="" exp="" field="location_type"/>
		<constraint desc="" exp="" field="workcat_id"/>
		<constraint desc="" exp="" field="workcat_id_end"/>
		<constraint desc="" exp="" field="buildercat_id"/>
		<constraint desc="" exp="" field="builtdate"/>
		<constraint desc="" exp="" field="enddate"/>
		<constraint desc="" exp="" field="ownercat_id"/>
		<constraint desc="" exp="" field="muni_id"/>
		<constraint desc="" exp="" field="postcode"/>
		<constraint desc="" exp="" field="district_id"/>
		<constraint desc="" exp="" field="streetname"/>
		<constraint desc="" exp="" field="postnumber"/>
		<constraint desc="" exp="" field="postcomplement"/>
		<constraint desc="" exp="" field="streetname2"/>
		<constraint desc="" exp="" field="postnumber2"/>
		<constraint desc="" exp="" field="postcomplement2"/>
		<constraint desc="" exp="" field="descript"/>
		<constraint desc="" exp="" field="svg"/>
		<constraint desc="" exp="" field="rotation"/>
		<constraint desc="" exp="" field="link"/>
		<constraint desc="" exp="" field="verified"/>
		<constraint desc="" exp="" field="undelete"/>
		<constraint desc="" exp="" field="label"/>
		<constraint desc="" exp="" field="label_x"/>
		<constraint desc="" exp="" field="label_y"/>
		<constraint desc="" exp="" field="label_rotation"/>
		<constraint desc="" exp="" field="accessibility"/>
		<constraint desc="" exp="" field="diagonal"/>
		<constraint desc="" exp="" field="publish"/>
		<constraint desc="" exp="" field="inventory"/>
		<constraint desc="" exp="" field="uncertain"/>
		<constraint desc="" exp="" field="num_value"/>
		<constraint desc="" exp="" field="feature_id"/>
		<constraint desc="" exp="" field="featurecat_id"/>
		<constraint desc="" exp="" field="pjoint_id"/>
		<constraint desc="" exp="" field="pjoint_type"/>
		<constraint desc="" exp="" field="tstamp"/>
		<constraint desc="" exp="" field="insert_user"/>
		<constraint desc="" exp="" field="lastupdate"/>
		<constraint desc="" exp="" field="lastupdate_user"/>
	</constraintExpressions>
	<expressionfields/>
	<attributeactions>
		<defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
	</attributeactions>
	<attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
		<columns>
			<column width="-1" name="connec_id" type="field" hidden="0"/>
			<column width="-1" name="code" type="field" hidden="0"/>
			<column width="-1" name="customer_code" type="field" hidden="0"/>
			<column width="-1" name="top_elev" type="field" hidden="0"/>
			<column width="-1" name="y1" type="field" hidden="0"/>
			<column width="-1" name="y2" type="field" hidden="0"/>
			<column width="-1" name="connecat_id" type="field" hidden="0"/>
			<column width="-1" name="connec_type" type="field" hidden="0"/>
			<column width="-1" name="sys_type" type="field" hidden="0"/>
			<column width="-1" name="private_connecat_id" type="field" hidden="0"/>
			<column width="-1" name="matcat_id" type="field" hidden="0"/>
			<column width="-1" name="expl_id" type="field" hidden="0"/>
			<column width="-1" name="macroexpl_id" type="field" hidden="0"/>
			<column width="-1" name="sector_id" type="field" hidden="0"/>
			<column width="-1" name="macrosector_id" type="field" hidden="0"/>
			<column width="-1" name="demand" type="field" hidden="0"/>
			<column width="-1" name="state" type="field" hidden="0"/>
			<column width="-1" name="state_type" type="field" hidden="0"/>
			<column width="-1" name="connec_depth" type="field" hidden="0"/>
			<column width="-1" name="connec_length" type="field" hidden="0"/>
			<column width="-1" name="arc_id" type="field" hidden="0"/>
			<column width="-1" name="annotation" type="field" hidden="0"/>
			<column width="-1" name="observ" type="field" hidden="0"/>
			<column width="-1" name="comment" type="field" hidden="0"/>
			<column width="-1" name="dma_id" type="field" hidden="0"/>
			<column width="-1" name="macrodma_id" type="field" hidden="0"/>
			<column width="-1" name="soilcat_id" type="field" hidden="0"/>
			<column width="-1" name="function_type" type="field" hidden="0"/>
			<column width="-1" name="category_type" type="field" hidden="0"/>
			<column width="-1" name="fluid_type" type="field" hidden="0"/>
			<column width="-1" name="location_type" type="field" hidden="0"/>
			<column width="-1" name="workcat_id" type="field" hidden="0"/>
			<column width="-1" name="workcat_id_end" type="field" hidden="0"/>
			<column width="-1" name="buildercat_id" type="field" hidden="0"/>
			<column width="-1" name="builtdate" type="field" hidden="0"/>
			<column width="-1" name="enddate" type="field" hidden="0"/>
			<column width="-1" name="ownercat_id" type="field" hidden="0"/>
			<column width="-1" name="muni_id" type="field" hidden="0"/>
			<column width="-1" name="postcode" type="field" hidden="0"/>
			<column width="-1" name="district_id" type="field" hidden="0"/>
			<column width="-1" name="streetname" type="field" hidden="0"/>
			<column width="-1" name="postnumber" type="field" hidden="0"/>
			<column width="-1" name="postcomplement" type="field" hidden="0"/>
			<column width="-1" name="streetname2" type="field" hidden="0"/>
			<column width="-1" name="postnumber2" type="field" hidden="0"/>
			<column width="-1" name="postcomplement2" type="field" hidden="0"/>
			<column width="-1" name="descript" type="field" hidden="0"/>
			<column width="-1" name="svg" type="field" hidden="0"/>
			<column width="-1" name="rotation" type="field" hidden="0"/>
			<column width="-1" name="link" type="field" hidden="0"/>
			<column width="-1" name="verified" type="field" hidden="0"/>
			<column width="-1" name="undelete" type="field" hidden="0"/>
			<column width="-1" name="label" type="field" hidden="0"/>
			<column width="-1" name="label_x" type="field" hidden="0"/>
			<column width="-1" name="label_y" type="field" hidden="0"/>
			<column width="-1" name="label_rotation" type="field" hidden="0"/>
			<column width="-1" name="accessibility" type="field" hidden="0"/>
			<column width="-1" name="diagonal" type="field" hidden="0"/>
			<column width="-1" name="publish" type="field" hidden="0"/>
			<column width="-1" name="inventory" type="field" hidden="0"/>
			<column width="-1" name="uncertain" type="field" hidden="0"/>
			<column width="-1" name="num_value" type="field" hidden="0"/>
			<column width="-1" name="feature_id" type="field" hidden="0"/>
			<column width="-1" name="featurecat_id" type="field" hidden="0"/>
			<column width="-1" name="pjoint_id" type="field" hidden="0"/>
			<column width="-1" name="pjoint_type" type="field" hidden="0"/>
			<column width="-1" name="tstamp" type="field" hidden="0"/>
			<column width="-1" name="insert_user" type="field" hidden="0"/>
			<column width="-1" name="lastupdate" type="field" hidden="0"/>
			<column width="-1" name="lastupdate_user" type="field" hidden="0"/>
			<column width="-1" type="actions" hidden="1"/>
		</columns>
	</attributetableconfig>
	<conditionalstyles>
		<rowstyles/>
		<fieldstyles/>
	</conditionalstyles>
	<storedexpressions/>
	<editform tolerant="1"></editform>
	<editforminit/>
	<editforminitcodesource>0</editforminitcodesource>
	<editforminitfilepath></editforminitfilepath>
	<editforminitcode>
		<![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]>
	</editforminitcode>
	<featformsuppress>0</featformsuppress>
	<editorlayout>generatedlayout</editorlayout>
	<editable>
		<field name="accessibility" editable="1"/>
		<field name="annotation" editable="1"/>
		<field name="arc_id" editable="1"/>
		<field name="buildercat_id" editable="1"/>
		<field name="builtdate" editable="1"/>
		<field name="category_type" editable="1"/>
		<field name="code" editable="1"/>
		<field name="comment" editable="1"/>
		<field name="connec_depth" editable="1"/>
		<field name="connec_id" editable="1"/>
		<field name="connec_length" editable="1"/>
		<field name="connec_type" editable="1"/>
		<field name="connecat_id" editable="1"/>
		<field name="customer_code" editable="1"/>
		<field name="demand" editable="1"/>
		<field name="descript" editable="1"/>
		<field name="diagonal" editable="1"/>
		<field name="district_id" editable="1"/>
		<field name="dma_id" editable="1"/>
		<field name="enddate" editable="1"/>
		<field name="expl_id" editable="1"/>
		<field name="feature_id" editable="1"/>
		<field name="featurecat_id" editable="1"/>
		<field name="fluid_type" editable="1"/>
		<field name="function_type" editable="1"/>
		<field name="insert_user" editable="1"/>
		<field name="inventory" editable="1"/>
		<field name="label" editable="1"/>
		<field name="label_rotation" editable="1"/>
		<field name="label_x" editable="1"/>
		<field name="label_y" editable="1"/>
		<field name="lastupdate" editable="1"/>
		<field name="lastupdate_user" editable="1"/>
		<field name="link" editable="1"/>
		<field name="location_type" editable="1"/>
		<field name="macrodma_id" editable="1"/>
		<field name="macroexpl_id" editable="1"/>
		<field name="macrosector_id" editable="1"/>
		<field name="matcat_id" editable="1"/>
		<field name="muni_id" editable="1"/>
		<field name="num_value" editable="1"/>
		<field name="observ" editable="1"/>
		<field name="ownercat_id" editable="1"/>
		<field name="pjoint_id" editable="1"/>
		<field name="pjoint_type" editable="1"/>
		<field name="postcode" editable="1"/>
		<field name="postcomplement" editable="1"/>
		<field name="postcomplement2" editable="1"/>
		<field name="postnumber" editable="1"/>
		<field name="postnumber2" editable="1"/>
		<field name="private_connecat_id" editable="1"/>
		<field name="publish" editable="1"/>
		<field name="rotation" editable="1"/>
		<field name="sector_id" editable="1"/>
		<field name="soilcat_id" editable="1"/>
		<field name="state" editable="1"/>
		<field name="state_type" editable="1"/>
		<field name="streetname" editable="1"/>
		<field name="streetname2" editable="1"/>
		<field name="svg" editable="1"/>
		<field name="sys_type" editable="1"/>
		<field name="top_elev" editable="1"/>
		<field name="tstamp" editable="1"/>
		<field name="uncertain" editable="1"/>
		<field name="undelete" editable="1"/>
		<field name="verified" editable="1"/>
		<field name="workcat_id" editable="1"/>
		<field name="workcat_id_end" editable="1"/>
		<field name="y1" editable="1"/>
		<field name="y2" editable="1"/>
	</editable>
	<labelOnTop>
		<field name="accessibility" labelOnTop="0"/>
		<field name="annotation" labelOnTop="0"/>
		<field name="arc_id" labelOnTop="0"/>
		<field name="buildercat_id" labelOnTop="0"/>
		<field name="builtdate" labelOnTop="0"/>
		<field name="category_type" labelOnTop="0"/>
		<field name="code" labelOnTop="0"/>
		<field name="comment" labelOnTop="0"/>
		<field name="connec_depth" labelOnTop="0"/>
		<field name="connec_id" labelOnTop="0"/>
		<field name="connec_length" labelOnTop="0"/>
		<field name="connec_type" labelOnTop="0"/>
		<field name="connecat_id" labelOnTop="0"/>
		<field name="customer_code" labelOnTop="0"/>
		<field name="demand" labelOnTop="0"/>
		<field name="descript" labelOnTop="0"/>
		<field name="diagonal" labelOnTop="0"/>
		<field name="district_id" labelOnTop="0"/>
		<field name="dma_id" labelOnTop="0"/>
		<field name="enddate" labelOnTop="0"/>
		<field name="expl_id" labelOnTop="0"/>
		<field name="feature_id" labelOnTop="0"/>
		<field name="featurecat_id" labelOnTop="0"/>
		<field name="fluid_type" labelOnTop="0"/>
		<field name="function_type" labelOnTop="0"/>
		<field name="insert_user" labelOnTop="0"/>
		<field name="inventory" labelOnTop="0"/>
		<field name="label" labelOnTop="0"/>
		<field name="label_rotation" labelOnTop="0"/>
		<field name="label_x" labelOnTop="0"/>
		<field name="label_y" labelOnTop="0"/>
		<field name="lastupdate" labelOnTop="0"/>
		<field name="lastupdate_user" labelOnTop="0"/>
		<field name="link" labelOnTop="0"/>
		<field name="location_type" labelOnTop="0"/>
		<field name="macrodma_id" labelOnTop="0"/>
		<field name="macroexpl_id" labelOnTop="0"/>
		<field name="macrosector_id" labelOnTop="0"/>
		<field name="matcat_id" labelOnTop="0"/>
		<field name="muni_id" labelOnTop="0"/>
		<field name="num_value" labelOnTop="0"/>
		<field name="observ" labelOnTop="0"/>
		<field name="ownercat_id" labelOnTop="0"/>
		<field name="pjoint_id" labelOnTop="0"/>
		<field name="pjoint_type" labelOnTop="0"/>
		<field name="postcode" labelOnTop="0"/>
		<field name="postcomplement" labelOnTop="0"/>
		<field name="postcomplement2" labelOnTop="0"/>
		<field name="postnumber" labelOnTop="0"/>
		<field name="postnumber2" labelOnTop="0"/>
		<field name="private_connecat_id" labelOnTop="0"/>
		<field name="publish" labelOnTop="0"/>
		<field name="rotation" labelOnTop="0"/>
		<field name="sector_id" labelOnTop="0"/>
		<field name="soilcat_id" labelOnTop="0"/>
		<field name="state" labelOnTop="0"/>
		<field name="state_type" labelOnTop="0"/>
		<field name="streetname" labelOnTop="0"/>
		<field name="streetname2" labelOnTop="0"/>
		<field name="svg" labelOnTop="0"/>
		<field name="sys_type" labelOnTop="0"/>
		<field name="top_elev" labelOnTop="0"/>
		<field name="tstamp" labelOnTop="0"/>
		<field name="uncertain" labelOnTop="0"/>
		<field name="undelete" labelOnTop="0"/>
		<field name="verified" labelOnTop="0"/>
		<field name="workcat_id" labelOnTop="0"/>
		<field name="workcat_id_end" labelOnTop="0"/>
		<field name="y1" labelOnTop="0"/>
		<field name="y2" labelOnTop="0"/>
	</labelOnTop>
	<widgets/>
	<previewExpression>streetname</previewExpression>
	<mapTip></mapTip>
	<layerGeometryType>0</layerGeometryType>
</qgis>$$, true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('103', 'v_edit_gully',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="1" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1500" simplifyDrawingHints="0">
	<flags>
		<Identifiable>1</Identifiable>
		<Removable>1</Removable>
		<Searchable>1</Searchable>
	</flags>
	<renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="singleSymbol">
		<symbols>
			<symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
				<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
					<prop k="angle" v="0"/>
					<prop k="color" v="49,180,227,255"/>
					<prop k="horizontal_anchor_point" v="1"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="name" v="circle"/>
					<prop k="offset" v="0,0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="outline_color" v="49,180,227,255"/>
					<prop k="outline_style" v="solid"/>
					<prop k="outline_width" v="0"/>
					<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="outline_width_unit" v="MM"/>
					<prop k="scale_method" v="diameter"/>
					<prop k="size" v="2"/>
					<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="size_unit" v="MM"/>
					<prop k="vertical_anchor_point" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties"/>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
					<prop k="angle" v="0"/>
					<prop k="color" v="255,0,0,255"/>
					<prop k="horizontal_anchor_point" v="1"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="name" v="cross"/>
					<prop k="offset" v="0,0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="outline_color" v="0,0,0,255"/>
					<prop k="outline_style" v="solid"/>
					<prop k="outline_width" v="0"/>
					<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="outline_width_unit" v="MM"/>
					<prop k="scale_method" v="diameter"/>
					<prop k="size" v="3"/>
					<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="size_unit" v="MM"/>
					<prop k="vertical_anchor_point" v="1"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties"/>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
			</symbol>
		</symbols>
		<rotation/>
		<sizescale/>
	</renderer-v2>
	<customproperties>
		<property value="0" key="embeddedWidgets/count"/>
		<property key="variableNames"/>
		<property key="variableValues"/>
	</customproperties>
	<blendMode>0</blendMode>
	<featureBlendMode>0</featureBlendMode>
	<layerOpacity>1</layerOpacity>
	<SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
		<DiagramCategory penColor="#000000" lineSizeType="MM" height="15" scaleBasedVisibility="0" opacity="1" barWidth="5" scaleDependency="Area" penAlpha="255" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" maxScaleDenominator="1e+08" sizeScale="3x:0,0,0,0,0,0" sizeType="MM" backgroundColor="#ffffff" penWidth="0" width="15" labelPlacementMethod="XHeight" enabled="0" diagramOrientation="Up" minScaleDenominator="0">
			<fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
			<attribute label="" color="#000000" field=""/>
		</DiagramCategory>
	</SingleCategoryDiagramRenderer>
	<DiagramLayerSettings obstacle="0" showAll="1" dist="0" linePlacementFlags="18" placement="0" zIndex="0" priority="0">
		<properties>
			<Option type="Map">
				<Option value="" name="name" type="QString"/>
				<Option name="properties"/>
				<Option value="collection" name="type" type="QString"/></Option>
		</properties>
	</DiagramLayerSettings>
	<geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
		<activeChecks/>
		<checkConfiguration/>
	</geometryOptions>
	<fieldConfiguration>
		<field name="connec_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="code">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="customer_code">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="top_elev">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="y1">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="y2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connecat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connec_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sys_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="private_connecat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="matcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="expl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macroexpl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrosector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="demand">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state_type">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connec_depth">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="connec_length">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="arc_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="annotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="observ">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="comment">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="dma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrodma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="soilcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="function_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="category_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="fluid_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="location_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="workcat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="workcat_id_end">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="buildercat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="builtdate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="enddate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="ownercat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="muni_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcode">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="district_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="streetname">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postnumber">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcomplement">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="streetname2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postnumber2">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="postcomplement2">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="descript">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="svg">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="rotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="link">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="verified">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="undelete">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_x">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_y">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="label_rotation">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="accessibility">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="diagonal">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="publish">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="inventory">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="uncertain">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="num_value">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="feature_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="featurecat_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="pjoint_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="pjoint_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="tstamp">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="insert_user">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="lastupdate">
			<editWidget type="DateTime">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="lastupdate_user">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
	</fieldConfiguration>
	<aliases>
		<alias index="0" name="" field="connec_id"/>
		<alias index="1" name="" field="code"/>
		<alias index="2" name="" field="customer_code"/>
		<alias index="3" name="" field="top_elev"/>
		<alias index="4" name="" field="y1"/>
		<alias index="5" name="" field="y2"/>
		<alias index="6" name="" field="connecat_id"/>
		<alias index="7" name="" field="connec_type"/>
		<alias index="8" name="" field="sys_type"/>
		<alias index="9" name="" field="private_connecat_id"/>
		<alias index="10" name="" field="matcat_id"/>
		<alias index="11" name="" field="expl_id"/>
		<alias index="12" name="" field="macroexpl_id"/>
		<alias index="13" name="" field="sector_id"/>
		<alias index="14" name="" field="macrosector_id"/>
		<alias index="15" name="" field="demand"/>
		<alias index="16" name="" field="state"/>
		<alias index="17" name="" field="state_type"/>
		<alias index="18" name="" field="connec_depth"/>
		<alias index="19" name="" field="connec_length"/>
		<alias index="20" name="" field="arc_id"/>
		<alias index="21" name="" field="annotation"/>
		<alias index="22" name="" field="observ"/>
		<alias index="23" name="" field="comment"/>
		<alias index="24" name="" field="dma_id"/>
		<alias index="25" name="" field="macrodma_id"/>
		<alias index="26" name="" field="soilcat_id"/>
		<alias index="27" name="" field="function_type"/>
		<alias index="28" name="" field="category_type"/>
		<alias index="29" name="" field="fluid_type"/>
		<alias index="30" name="" field="location_type"/>
		<alias index="31" name="" field="workcat_id"/>
		<alias index="32" name="" field="workcat_id_end"/>
		<alias index="33" name="" field="buildercat_id"/>
		<alias index="34" name="" field="builtdate"/>
		<alias index="35" name="" field="enddate"/>
		<alias index="36" name="" field="ownercat_id"/>
		<alias index="37" name="" field="muni_id"/>
		<alias index="38" name="" field="postcode"/>
		<alias index="39" name="" field="district_id"/>
		<alias index="40" name="" field="streetname"/>
		<alias index="41" name="" field="postnumber"/>
		<alias index="42" name="" field="postcomplement"/>
		<alias index="43" name="" field="streetname2"/>
		<alias index="44" name="" field="postnumber2"/>
		<alias index="45" name="" field="postcomplement2"/>
		<alias index="46" name="" field="descript"/>
		<alias index="47" name="" field="svg"/>
		<alias index="48" name="" field="rotation"/>
		<alias index="49" name="" field="link"/>
		<alias index="50" name="" field="verified"/>
		<alias index="51" name="" field="undelete"/>
		<alias index="52" name="" field="label"/>
		<alias index="53" name="" field="label_x"/>
		<alias index="54" name="" field="label_y"/>
		<alias index="55" name="" field="label_rotation"/>
		<alias index="56" name="" field="accessibility"/>
		<alias index="57" name="" field="diagonal"/>
		<alias index="58" name="" field="publish"/>
		<alias index="59" name="" field="inventory"/>
		<alias index="60" name="" field="uncertain"/>
		<alias index="61" name="" field="num_value"/>
		<alias index="62" name="" field="feature_id"/>
		<alias index="63" name="" field="featurecat_id"/>
		<alias index="64" name="" field="pjoint_id"/>
		<alias index="65" name="" field="pjoint_type"/>
		<alias index="66" name="" field="tstamp"/>
		<alias index="67" name="" field="insert_user"/>
		<alias index="68" name="" field="lastupdate"/>
		<alias index="69" name="" field="lastupdate_user"/>
	</aliases>
	<excludeAttributesWMS/>
	<excludeAttributesWFS/>
	<defaults>
		<default expression="" applyOnUpdate="0" field="connec_id"/>
		<default expression="" applyOnUpdate="0" field="code"/>
		<default expression="" applyOnUpdate="0" field="customer_code"/>
		<default expression="" applyOnUpdate="0" field="top_elev"/>
		<default expression="" applyOnUpdate="0" field="y1"/>
		<default expression="" applyOnUpdate="0" field="y2"/>
		<default expression="" applyOnUpdate="0" field="connecat_id"/>
		<default expression="" applyOnUpdate="0" field="connec_type"/>
		<default expression="" applyOnUpdate="0" field="sys_type"/>
		<default expression="" applyOnUpdate="0" field="private_connecat_id"/>
		<default expression="" applyOnUpdate="0" field="matcat_id"/>
		<default expression="" applyOnUpdate="0" field="expl_id"/>
		<default expression="" applyOnUpdate="0" field="macroexpl_id"/>
		<default expression="" applyOnUpdate="0" field="sector_id"/>
		<default expression="" applyOnUpdate="0" field="macrosector_id"/>
		<default expression="" applyOnUpdate="0" field="demand"/>
		<default expression="" applyOnUpdate="0" field="state"/>
		<default expression="" applyOnUpdate="0" field="state_type"/>
		<default expression="" applyOnUpdate="0" field="connec_depth"/>
		<default expression="" applyOnUpdate="0" field="connec_length"/>
		<default expression="" applyOnUpdate="0" field="arc_id"/>
		<default expression="" applyOnUpdate="0" field="annotation"/>
		<default expression="" applyOnUpdate="0" field="observ"/>
		<default expression="" applyOnUpdate="0" field="comment"/>
		<default expression="" applyOnUpdate="0" field="dma_id"/>
		<default expression="" applyOnUpdate="0" field="macrodma_id"/>
		<default expression="" applyOnUpdate="0" field="soilcat_id"/>
		<default expression="" applyOnUpdate="0" field="function_type"/>
		<default expression="" applyOnUpdate="0" field="category_type"/>
		<default expression="" applyOnUpdate="0" field="fluid_type"/>
		<default expression="" applyOnUpdate="0" field="location_type"/>
		<default expression="" applyOnUpdate="0" field="workcat_id"/>
		<default expression="" applyOnUpdate="0" field="workcat_id_end"/>
		<default expression="" applyOnUpdate="0" field="buildercat_id"/>
		<default expression="" applyOnUpdate="0" field="builtdate"/>
		<default expression="" applyOnUpdate="0" field="enddate"/>
		<default expression="" applyOnUpdate="0" field="ownercat_id"/>
		<default expression="" applyOnUpdate="0" field="muni_id"/>
		<default expression="" applyOnUpdate="0" field="postcode"/>
		<default expression="" applyOnUpdate="0" field="district_id"/>
		<default expression="" applyOnUpdate="0" field="streetname"/>
		<default expression="" applyOnUpdate="0" field="postnumber"/>
		<default expression="" applyOnUpdate="0" field="postcomplement"/>
		<default expression="" applyOnUpdate="0" field="streetname2"/>
		<default expression="" applyOnUpdate="0" field="postnumber2"/>
		<default expression="" applyOnUpdate="0" field="postcomplement2"/>
		<default expression="" applyOnUpdate="0" field="descript"/>
		<default expression="" applyOnUpdate="0" field="svg"/>
		<default expression="" applyOnUpdate="0" field="rotation"/>
		<default expression="" applyOnUpdate="0" field="link"/>
		<default expression="" applyOnUpdate="0" field="verified"/>
		<default expression="" applyOnUpdate="0" field="undelete"/>
		<default expression="" applyOnUpdate="0" field="label"/>
		<default expression="" applyOnUpdate="0" field="label_x"/>
		<default expression="" applyOnUpdate="0" field="label_y"/>
		<default expression="" applyOnUpdate="0" field="label_rotation"/>
		<default expression="" applyOnUpdate="0" field="accessibility"/>
		<default expression="" applyOnUpdate="0" field="diagonal"/>
		<default expression="" applyOnUpdate="0" field="publish"/>
		<default expression="" applyOnUpdate="0" field="inventory"/>
		<default expression="" applyOnUpdate="0" field="uncertain"/>
		<default expression="" applyOnUpdate="0" field="num_value"/>
		<default expression="" applyOnUpdate="0" field="feature_id"/>
		<default expression="" applyOnUpdate="0" field="featurecat_id"/>
		<default expression="" applyOnUpdate="0" field="pjoint_id"/>
		<default expression="" applyOnUpdate="0" field="pjoint_type"/>
		<default expression="" applyOnUpdate="0" field="tstamp"/>
		<default expression="" applyOnUpdate="0" field="insert_user"/>
		<default expression="" applyOnUpdate="0" field="lastupdate"/>
		<default expression="" applyOnUpdate="0" field="lastupdate_user"/>
	</defaults>
	<constraints>
		<constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="connec_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="code"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="customer_code"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="top_elev"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="y1"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="y2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connecat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connec_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="private_connecat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="matcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macroexpl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrosector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="demand"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connec_depth"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="connec_length"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="arc_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="annotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="observ"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="comment"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="dma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrodma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="soilcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="function_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="category_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="fluid_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="location_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id_end"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="buildercat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="builtdate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="enddate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="ownercat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="muni_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcode"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="district_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement2"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="descript"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="svg"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="rotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="link"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="verified"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="undelete"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_x"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_y"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_rotation"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="accessibility"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="diagonal"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="publish"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="inventory"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="uncertain"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="num_value"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="feature_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="featurecat_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="pjoint_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="pjoint_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="tstamp"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="insert_user"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate_user"/>
	</constraints>
	<constraintExpressions>
		<constraint desc="" exp="" field="connec_id"/>
		<constraint desc="" exp="" field="code"/>
		<constraint desc="" exp="" field="customer_code"/>
		<constraint desc="" exp="" field="top_elev"/>
		<constraint desc="" exp="" field="y1"/>
		<constraint desc="" exp="" field="y2"/>
		<constraint desc="" exp="" field="connecat_id"/>
		<constraint desc="" exp="" field="connec_type"/>
		<constraint desc="" exp="" field="sys_type"/>
		<constraint desc="" exp="" field="private_connecat_id"/>
		<constraint desc="" exp="" field="matcat_id"/>
		<constraint desc="" exp="" field="expl_id"/>
		<constraint desc="" exp="" field="macroexpl_id"/>
		<constraint desc="" exp="" field="sector_id"/>
		<constraint desc="" exp="" field="macrosector_id"/>
		<constraint desc="" exp="" field="demand"/>
		<constraint desc="" exp="" field="state"/>
		<constraint desc="" exp="" field="state_type"/>
		<constraint desc="" exp="" field="connec_depth"/>
		<constraint desc="" exp="" field="connec_length"/>
		<constraint desc="" exp="" field="arc_id"/>
		<constraint desc="" exp="" field="annotation"/>
		<constraint desc="" exp="" field="observ"/>
		<constraint desc="" exp="" field="comment"/>
		<constraint desc="" exp="" field="dma_id"/>
		<constraint desc="" exp="" field="macrodma_id"/>
		<constraint desc="" exp="" field="soilcat_id"/>
		<constraint desc="" exp="" field="function_type"/>
		<constraint desc="" exp="" field="category_type"/>
		<constraint desc="" exp="" field="fluid_type"/>
		<constraint desc="" exp="" field="location_type"/>
		<constraint desc="" exp="" field="workcat_id"/>
		<constraint desc="" exp="" field="workcat_id_end"/>
		<constraint desc="" exp="" field="buildercat_id"/>
		<constraint desc="" exp="" field="builtdate"/>
		<constraint desc="" exp="" field="enddate"/>
		<constraint desc="" exp="" field="ownercat_id"/>
		<constraint desc="" exp="" field="muni_id"/>
		<constraint desc="" exp="" field="postcode"/>
		<constraint desc="" exp="" field="district_id"/>
		<constraint desc="" exp="" field="streetname"/>
		<constraint desc="" exp="" field="postnumber"/>
		<constraint desc="" exp="" field="postcomplement"/>
		<constraint desc="" exp="" field="streetname2"/>
		<constraint desc="" exp="" field="postnumber2"/>
		<constraint desc="" exp="" field="postcomplement2"/>
		<constraint desc="" exp="" field="descript"/>
		<constraint desc="" exp="" field="svg"/>
		<constraint desc="" exp="" field="rotation"/>
		<constraint desc="" exp="" field="link"/>
		<constraint desc="" exp="" field="verified"/>
		<constraint desc="" exp="" field="undelete"/>
		<constraint desc="" exp="" field="label"/>
		<constraint desc="" exp="" field="label_x"/>
		<constraint desc="" exp="" field="label_y"/>
		<constraint desc="" exp="" field="label_rotation"/>
		<constraint desc="" exp="" field="accessibility"/>
		<constraint desc="" exp="" field="diagonal"/>
		<constraint desc="" exp="" field="publish"/>
		<constraint desc="" exp="" field="inventory"/>
		<constraint desc="" exp="" field="uncertain"/>
		<constraint desc="" exp="" field="num_value"/>
		<constraint desc="" exp="" field="feature_id"/>
		<constraint desc="" exp="" field="featurecat_id"/>
		<constraint desc="" exp="" field="pjoint_id"/>
		<constraint desc="" exp="" field="pjoint_type"/>
		<constraint desc="" exp="" field="tstamp"/>
		<constraint desc="" exp="" field="insert_user"/>
		<constraint desc="" exp="" field="lastupdate"/>
		<constraint desc="" exp="" field="lastupdate_user"/>
	</constraintExpressions>
	<expressionfields/>
	<attributeactions>
		<defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
	</attributeactions>
	<attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
		<columns>
			<column width="-1" name="connec_id" type="field" hidden="0"/>
			<column width="-1" name="code" type="field" hidden="0"/>
			<column width="-1" name="customer_code" type="field" hidden="0"/>
			<column width="-1" name="top_elev" type="field" hidden="0"/>
			<column width="-1" name="y1" type="field" hidden="0"/>
			<column width="-1" name="y2" type="field" hidden="0"/>
			<column width="-1" name="connecat_id" type="field" hidden="0"/>
			<column width="-1" name="connec_type" type="field" hidden="0"/>
			<column width="-1" name="sys_type" type="field" hidden="0"/>
			<column width="-1" name="private_connecat_id" type="field" hidden="0"/>
			<column width="-1" name="matcat_id" type="field" hidden="0"/>
			<column width="-1" name="expl_id" type="field" hidden="0"/>
			<column width="-1" name="macroexpl_id" type="field" hidden="0"/>
			<column width="-1" name="sector_id" type="field" hidden="0"/>
			<column width="-1" name="macrosector_id" type="field" hidden="0"/>
			<column width="-1" name="demand" type="field" hidden="0"/>
			<column width="-1" name="state" type="field" hidden="0"/>
			<column width="-1" name="state_type" type="field" hidden="0"/>
			<column width="-1" name="connec_depth" type="field" hidden="0"/>
			<column width="-1" name="connec_length" type="field" hidden="0"/>
			<column width="-1" name="arc_id" type="field" hidden="0"/>
			<column width="-1" name="annotation" type="field" hidden="0"/>
			<column width="-1" name="observ" type="field" hidden="0"/>
			<column width="-1" name="comment" type="field" hidden="0"/>
			<column width="-1" name="dma_id" type="field" hidden="0"/>
			<column width="-1" name="macrodma_id" type="field" hidden="0"/>
			<column width="-1" name="soilcat_id" type="field" hidden="0"/>
			<column width="-1" name="function_type" type="field" hidden="0"/>
			<column width="-1" name="category_type" type="field" hidden="0"/>
			<column width="-1" name="fluid_type" type="field" hidden="0"/>
			<column width="-1" name="location_type" type="field" hidden="0"/>
			<column width="-1" name="workcat_id" type="field" hidden="0"/>
			<column width="-1" name="workcat_id_end" type="field" hidden="0"/>
			<column width="-1" name="buildercat_id" type="field" hidden="0"/>
			<column width="-1" name="builtdate" type="field" hidden="0"/>
			<column width="-1" name="enddate" type="field" hidden="0"/>
			<column width="-1" name="ownercat_id" type="field" hidden="0"/>
			<column width="-1" name="muni_id" type="field" hidden="0"/>
			<column width="-1" name="postcode" type="field" hidden="0"/>
			<column width="-1" name="district_id" type="field" hidden="0"/>
			<column width="-1" name="streetname" type="field" hidden="0"/>
			<column width="-1" name="postnumber" type="field" hidden="0"/>
			<column width="-1" name="postcomplement" type="field" hidden="0"/>
			<column width="-1" name="streetname2" type="field" hidden="0"/>
			<column width="-1" name="postnumber2" type="field" hidden="0"/>
			<column width="-1" name="postcomplement2" type="field" hidden="0"/>
			<column width="-1" name="descript" type="field" hidden="0"/>
			<column width="-1" name="svg" type="field" hidden="0"/>
			<column width="-1" name="rotation" type="field" hidden="0"/>
			<column width="-1" name="link" type="field" hidden="0"/>
			<column width="-1" name="verified" type="field" hidden="0"/>
			<column width="-1" name="undelete" type="field" hidden="0"/>
			<column width="-1" name="label" type="field" hidden="0"/>
			<column width="-1" name="label_x" type="field" hidden="0"/>
			<column width="-1" name="label_y" type="field" hidden="0"/>
			<column width="-1" name="label_rotation" type="field" hidden="0"/>
			<column width="-1" name="accessibility" type="field" hidden="0"/>
			<column width="-1" name="diagonal" type="field" hidden="0"/>
			<column width="-1" name="publish" type="field" hidden="0"/>
			<column width="-1" name="inventory" type="field" hidden="0"/>
			<column width="-1" name="uncertain" type="field" hidden="0"/>
			<column width="-1" name="num_value" type="field" hidden="0"/>
			<column width="-1" name="feature_id" type="field" hidden="0"/>
			<column width="-1" name="featurecat_id" type="field" hidden="0"/>
			<column width="-1" name="pjoint_id" type="field" hidden="0"/>
			<column width="-1" name="pjoint_type" type="field" hidden="0"/>
			<column width="-1" name="tstamp" type="field" hidden="0"/>
			<column width="-1" name="insert_user" type="field" hidden="0"/>
			<column width="-1" name="lastupdate" type="field" hidden="0"/>
			<column width="-1" name="lastupdate_user" type="field" hidden="0"/>
			<column width="-1" type="actions" hidden="1"/>
		</columns>
	</attributetableconfig>
	<conditionalstyles>
		<rowstyles/>
		<fieldstyles/>
	</conditionalstyles>
	<storedexpressions/>
	<editform tolerant="1"></editform>
	<editforminit/>
	<editforminitcodesource>0</editforminitcodesource>
	<editforminitfilepath></editforminitfilepath>
	<editforminitcode>
		<![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]>
	</editforminitcode>
	<featformsuppress>0</featformsuppress>
	<editorlayout>generatedlayout</editorlayout>
	<editable>
		<field name="accessibility" editable="1"/>
		<field name="annotation" editable="1"/>
		<field name="arc_id" editable="1"/>
		<field name="buildercat_id" editable="1"/>
		<field name="builtdate" editable="1"/>
		<field name="category_type" editable="1"/>
		<field name="code" editable="1"/>
		<field name="comment" editable="1"/>
		<field name="connec_depth" editable="1"/>
		<field name="connec_id" editable="1"/>
		<field name="connec_length" editable="1"/>
		<field name="connec_type" editable="1"/>
		<field name="connecat_id" editable="1"/>
		<field name="customer_code" editable="1"/>
		<field name="demand" editable="1"/>
		<field name="descript" editable="1"/>
		<field name="diagonal" editable="1"/>
		<field name="district_id" editable="1"/>
		<field name="dma_id" editable="1"/>
		<field name="enddate" editable="1"/>
		<field name="expl_id" editable="1"/>
		<field name="feature_id" editable="1"/>
		<field name="featurecat_id" editable="1"/>
		<field name="fluid_type" editable="1"/>
		<field name="function_type" editable="1"/>
		<field name="insert_user" editable="1"/>
		<field name="inventory" editable="1"/>
		<field name="label" editable="1"/>
		<field name="label_rotation" editable="1"/>
		<field name="label_x" editable="1"/>
		<field name="label_y" editable="1"/>
		<field name="lastupdate" editable="1"/>
		<field name="lastupdate_user" editable="1"/>
		<field name="link" editable="1"/>
		<field name="location_type" editable="1"/>
		<field name="macrodma_id" editable="1"/>
		<field name="macroexpl_id" editable="1"/>
		<field name="macrosector_id" editable="1"/>
		<field name="matcat_id" editable="1"/>
		<field name="muni_id" editable="1"/>
		<field name="num_value" editable="1"/>
		<field name="observ" editable="1"/>
		<field name="ownercat_id" editable="1"/>
		<field name="pjoint_id" editable="1"/>
		<field name="pjoint_type" editable="1"/>
		<field name="postcode" editable="1"/>
		<field name="postcomplement" editable="1"/>
		<field name="postcomplement2" editable="1"/>
		<field name="postnumber" editable="1"/>
		<field name="postnumber2" editable="1"/>
		<field name="private_connecat_id" editable="1"/>
		<field name="publish" editable="1"/>
		<field name="rotation" editable="1"/>
		<field name="sector_id" editable="1"/>
		<field name="soilcat_id" editable="1"/>
		<field name="state" editable="1"/>
		<field name="state_type" editable="1"/>
		<field name="streetname" editable="1"/>
		<field name="streetname2" editable="1"/>
		<field name="svg" editable="1"/>
		<field name="sys_type" editable="1"/>
		<field name="top_elev" editable="1"/>
		<field name="tstamp" editable="1"/>
		<field name="uncertain" editable="1"/>
		<field name="undelete" editable="1"/>
		<field name="verified" editable="1"/>
		<field name="workcat_id" editable="1"/>
		<field name="workcat_id_end" editable="1"/>
		<field name="y1" editable="1"/>
		<field name="y2" editable="1"/>
	</editable>
	<labelOnTop>
		<field name="accessibility" labelOnTop="0"/>
		<field name="annotation" labelOnTop="0"/>
		<field name="arc_id" labelOnTop="0"/>
		<field name="buildercat_id" labelOnTop="0"/>
		<field name="builtdate" labelOnTop="0"/>
		<field name="category_type" labelOnTop="0"/>
		<field name="code" labelOnTop="0"/>
		<field name="comment" labelOnTop="0"/>
		<field name="connec_depth" labelOnTop="0"/>
		<field name="connec_id" labelOnTop="0"/>
		<field name="connec_length" labelOnTop="0"/>
		<field name="connec_type" labelOnTop="0"/>
		<field name="connecat_id" labelOnTop="0"/>
		<field name="customer_code" labelOnTop="0"/>
		<field name="demand" labelOnTop="0"/>
		<field name="descript" labelOnTop="0"/>
		<field name="diagonal" labelOnTop="0"/>
		<field name="district_id" labelOnTop="0"/>
		<field name="dma_id" labelOnTop="0"/>
		<field name="enddate" labelOnTop="0"/>
		<field name="expl_id" labelOnTop="0"/>
		<field name="feature_id" labelOnTop="0"/>
		<field name="featurecat_id" labelOnTop="0"/>
		<field name="fluid_type" labelOnTop="0"/>
		<field name="function_type" labelOnTop="0"/>
		<field name="insert_user" labelOnTop="0"/>
		<field name="inventory" labelOnTop="0"/>
		<field name="label" labelOnTop="0"/>
		<field name="label_rotation" labelOnTop="0"/>
		<field name="label_x" labelOnTop="0"/>
		<field name="label_y" labelOnTop="0"/>
		<field name="lastupdate" labelOnTop="0"/>
		<field name="lastupdate_user" labelOnTop="0"/>
		<field name="link" labelOnTop="0"/>
		<field name="location_type" labelOnTop="0"/>
		<field name="macrodma_id" labelOnTop="0"/>
		<field name="macroexpl_id" labelOnTop="0"/>
		<field name="macrosector_id" labelOnTop="0"/>
		<field name="matcat_id" labelOnTop="0"/>
		<field name="muni_id" labelOnTop="0"/>
		<field name="num_value" labelOnTop="0"/>
		<field name="observ" labelOnTop="0"/>
		<field name="ownercat_id" labelOnTop="0"/>
		<field name="pjoint_id" labelOnTop="0"/>
		<field name="pjoint_type" labelOnTop="0"/>
		<field name="postcode" labelOnTop="0"/>
		<field name="postcomplement" labelOnTop="0"/>
		<field name="postcomplement2" labelOnTop="0"/>
		<field name="postnumber" labelOnTop="0"/>
		<field name="postnumber2" labelOnTop="0"/>
		<field name="private_connecat_id" labelOnTop="0"/>
		<field name="publish" labelOnTop="0"/>
		<field name="rotation" labelOnTop="0"/>
		<field name="sector_id" labelOnTop="0"/>
		<field name="soilcat_id" labelOnTop="0"/>
		<field name="state" labelOnTop="0"/>
		<field name="state_type" labelOnTop="0"/>
		<field name="streetname" labelOnTop="0"/>
		<field name="streetname2" labelOnTop="0"/>
		<field name="svg" labelOnTop="0"/>
		<field name="sys_type" labelOnTop="0"/>
		<field name="top_elev" labelOnTop="0"/>
		<field name="tstamp" labelOnTop="0"/>
		<field name="uncertain" labelOnTop="0"/>
		<field name="undelete" labelOnTop="0"/>
		<field name="verified" labelOnTop="0"/>
		<field name="workcat_id" labelOnTop="0"/>
		<field name="workcat_id_end" labelOnTop="0"/>
		<field name="y1" labelOnTop="0"/>
		<field name="y2" labelOnTop="0"/>
	</labelOnTop>
	<widgets/>
	<previewExpression>streetname</previewExpression>
	<mapTip></mapTip>
	<layerGeometryType>0</layerGeometryType>
</qgis>$$, true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('104', 'v_edit_link',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="1" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1500" simplifyDrawingHints="1">
	<flags>
		<Identifiable>1</Identifiable>
		<Removable>1</Removable>
		<Searchable>1</Searchable>
	</flags>
	<renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="singleSymbol">
		<symbols>
			<symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="line">
				<layer enabled="1" class="SimpleLine" locked="0" pass="0">
					<prop k="capstyle" v="square"/>
					<prop k="customdash" v="5;2"/>
					<prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="customdash_unit" v="MM"/>
					<prop k="draw_inside_polygon" v="0"/>
					<prop k="joinstyle" v="bevel"/>
					<prop k="line_color" v="153,80,76,255"/>
					<prop k="line_style" v="dash"/>
					<prop k="line_width" v="0.26"/>
					<prop k="line_width_unit" v="MM"/>
					<prop k="offset" v="0"/>
					<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<prop k="offset_unit" v="MM"/>
					<prop k="ring_filter" v="0"/>
					<prop k="use_custom_dash" v="0"/>
					<prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties"/>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
				</layer>
				<layer enabled="1" class="GeometryGenerator" locked="0" pass="0">
					<prop k="SymbolType" v="Marker"/>
					<prop k="geometryModifier" v="end_point($geometry)"/>
					<data_defined_properties>
						<Option type="Map">
							<Option value="" name="name" type="QString"/>
							<Option name="properties"/>
							<Option value="collection" name="type" type="QString"/></Option>
					</data_defined_properties>
					<symbol name="@0@1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
						<layer enabled="1" class="SimpleMarker" locked="0" pass="0">
							<prop k="angle" v="0"/>
							<prop k="color" v="255,0,0,255"/>
							<prop k="horizontal_anchor_point" v="1"/>
							<prop k="joinstyle" v="bevel"/>
							<prop k="name" v="cross2"/>
							<prop k="offset" v="0,0"/>
							<prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="offset_unit" v="MM"/>
							<prop k="outline_color" v="35,35,35,255"/>
							<prop k="outline_style" v="solid"/>
							<prop k="outline_width" v="0"/>
							<prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="outline_width_unit" v="MM"/>
							<prop k="scale_method" v="diameter"/>
							<prop k="size" v="1.8"/>
							<prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
							<prop k="size_unit" v="MM"/>
							<prop k="vertical_anchor_point" v="1"/>
							<data_defined_properties>
								<Option type="Map">
									<Option value="" name="name" type="QString"/>
									<Option name="properties"/>
									<Option value="collection" name="type" type="QString"/></Option>
							</data_defined_properties>
						</layer>
					</symbol>
				</layer>
			</symbol>
		</symbols>
		<rotation/>
		<sizescale/>
	</renderer-v2>
	<customproperties>
		<property value="0" key="embeddedWidgets/count"/>
		<property key="variableNames"/>
		<property key="variableValues"/>
	</customproperties>
	<blendMode>0</blendMode>
	<featureBlendMode>0</featureBlendMode>
	<layerOpacity>1</layerOpacity>
	<SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
		<DiagramCategory penColor="#000000" lineSizeType="MM" height="15" scaleBasedVisibility="0" opacity="1" barWidth="5" scaleDependency="Area" penAlpha="255" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" maxScaleDenominator="1e+08" sizeScale="3x:0,0,0,0,0,0" sizeType="MM" backgroundColor="#ffffff" penWidth="0" width="15" labelPlacementMethod="XHeight" enabled="0" diagramOrientation="Up" minScaleDenominator="0">
			<fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
			<attribute label="" color="#000000" field=""/>
		</DiagramCategory>
	</SingleCategoryDiagramRenderer>
	<DiagramLayerSettings obstacle="0" showAll="1" dist="0" linePlacementFlags="18" placement="2" zIndex="0" priority="0">
		<properties>
			<Option type="Map">
				<Option value="" name="name" type="QString"/>
				<Option name="properties"/>
				<Option value="collection" name="type" type="QString"/></Option>
		</properties>
	</DiagramLayerSettings>
	<geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
		<activeChecks/>
		<checkConfiguration/>
	</geometryOptions>
	<fieldConfiguration>
		<field name="link_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="feature_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="feature_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrosector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="macrodma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="exit_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="exit_id">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="sector_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="dma_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="expl_id">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="state">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="gis_length">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="userdefined_geom">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="ispsectorgeom">
			<editWidget type="CheckBox">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="psector_rowid">
			<editWidget type="Range">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="fluid_type">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
		<field name="vnode_topelev">
			<editWidget type="TextEdit">
				<config>
					<Option/>
				</config>
			</editWidget>
		</field>
	</fieldConfiguration>
	<aliases>
		<alias index="0" name="" field="link_id"/>
		<alias index="1" name="" field="feature_type"/>
		<alias index="2" name="" field="feature_id"/>
		<alias index="3" name="" field="macrosector_id"/>
		<alias index="4" name="" field="macrodma_id"/>
		<alias index="5" name="" field="exit_type"/>
		<alias index="6" name="" field="exit_id"/>
		<alias index="7" name="" field="sector_id"/>
		<alias index="8" name="" field="dma_id"/>
		<alias index="9" name="" field="expl_id"/>
		<alias index="10" name="" field="state"/>
		<alias index="11" name="" field="gis_length"/>
		<alias index="12" name="" field="userdefined_geom"/>
		<alias index="13" name="" field="ispsectorgeom"/>
		<alias index="14" name="" field="psector_rowid"/>
		<alias index="15" name="" field="fluid_type"/>
		<alias index="16" name="" field="vnode_topelev"/>
	</aliases>
	<excludeAttributesWMS/>
	<excludeAttributesWFS/>
	<defaults>
		<default expression="" applyOnUpdate="0" field="link_id"/>
		<default expression="" applyOnUpdate="0" field="feature_type"/>
		<default expression="" applyOnUpdate="0" field="feature_id"/>
		<default expression="" applyOnUpdate="0" field="macrosector_id"/>
		<default expression="" applyOnUpdate="0" field="macrodma_id"/>
		<default expression="" applyOnUpdate="0" field="exit_type"/>
		<default expression="" applyOnUpdate="0" field="exit_id"/>
		<default expression="" applyOnUpdate="0" field="sector_id"/>
		<default expression="" applyOnUpdate="0" field="dma_id"/>
		<default expression="" applyOnUpdate="0" field="expl_id"/>
		<default expression="" applyOnUpdate="0" field="state"/>
		<default expression="" applyOnUpdate="0" field="gis_length"/>
		<default expression="" applyOnUpdate="0" field="userdefined_geom"/>
		<default expression="" applyOnUpdate="0" field="ispsectorgeom"/>
		<default expression="" applyOnUpdate="0" field="psector_rowid"/>
		<default expression="" applyOnUpdate="0" field="fluid_type"/>
		<default expression="" applyOnUpdate="0" field="vnode_topelev"/>
	</defaults>
	<constraints>
		<constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="link_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="feature_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="feature_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrosector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrodma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="exit_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="exit_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sector_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="dma_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="gis_length"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="userdefined_geom"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="ispsectorgeom"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="psector_rowid"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="fluid_type"/>
		<constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="vnode_topelev"/>
	</constraints>
	<constraintExpressions>
		<constraint desc="" exp="" field="link_id"/>
		<constraint desc="" exp="" field="feature_type"/>
		<constraint desc="" exp="" field="feature_id"/>
		<constraint desc="" exp="" field="macrosector_id"/>
		<constraint desc="" exp="" field="macrodma_id"/>
		<constraint desc="" exp="" field="exit_type"/>
		<constraint desc="" exp="" field="exit_id"/>
		<constraint desc="" exp="" field="sector_id"/>
		<constraint desc="" exp="" field="dma_id"/>
		<constraint desc="" exp="" field="expl_id"/>
		<constraint desc="" exp="" field="state"/>
		<constraint desc="" exp="" field="gis_length"/>
		<constraint desc="" exp="" field="userdefined_geom"/>
		<constraint desc="" exp="" field="ispsectorgeom"/>
		<constraint desc="" exp="" field="psector_rowid"/>
		<constraint desc="" exp="" field="fluid_type"/>
		<constraint desc="" exp="" field="vnode_topelev"/>
	</constraintExpressions>
	<expressionfields/>
	<attributeactions>
		<defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
	</attributeactions>
	<attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
		<columns>
			<column width="-1" name="link_id" type="field" hidden="0"/>
			<column width="-1" name="feature_type" type="field" hidden="0"/>
			<column width="-1" name="feature_id" type="field" hidden="0"/>
			<column width="-1" name="macrosector_id" type="field" hidden="0"/>
			<column width="-1" name="macrodma_id" type="field" hidden="0"/>
			<column width="-1" name="exit_type" type="field" hidden="0"/>
			<column width="-1" name="exit_id" type="field" hidden="0"/>
			<column width="-1" name="sector_id" type="field" hidden="0"/>
			<column width="-1" name="dma_id" type="field" hidden="0"/>
			<column width="-1" name="expl_id" type="field" hidden="0"/>
			<column width="-1" name="state" type="field" hidden="0"/>
			<column width="-1" name="gis_length" type="field" hidden="0"/>
			<column width="-1" name="userdefined_geom" type="field" hidden="0"/>
			<column width="-1" name="ispsectorgeom" type="field" hidden="0"/>
			<column width="-1" name="psector_rowid" type="field" hidden="0"/>
			<column width="-1" name="fluid_type" type="field" hidden="0"/>
			<column width="-1" name="vnode_topelev" type="field" hidden="0"/>
			<column width="-1" type="actions" hidden="1"/>
		</columns>
	</attributetableconfig>
	<conditionalstyles>
		<rowstyles/>
		<fieldstyles/>
	</conditionalstyles>
	<storedexpressions/>
	<editform tolerant="1"></editform>
	<editforminit/>
	<editforminitcodesource>0</editforminitcodesource>
	<editforminitfilepath></editforminitfilepath>
	<editforminitcode>
		<![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]>
	</editforminitcode>
	<featformsuppress>0</featformsuppress>
	<editorlayout>generatedlayout</editorlayout>
	<editable>
		<field name="dma_id" editable="1"/>
		<field name="exit_id" editable="1"/>
		<field name="exit_type" editable="1"/>
		<field name="expl_id" editable="1"/>
		<field name="feature_id" editable="1"/>
		<field name="feature_type" editable="1"/>
		<field name="fluid_type" editable="1"/>
		<field name="gis_length" editable="1"/>
		<field name="ispsectorgeom" editable="1"/>
		<field name="link_id" editable="1"/>
		<field name="macrodma_id" editable="1"/>
		<field name="macrosector_id" editable="1"/>
		<field name="psector_rowid" editable="1"/>
		<field name="sector_id" editable="1"/>
		<field name="state" editable="1"/>
		<field name="userdefined_geom" editable="1"/>
		<field name="vnode_topelev" editable="1"/>
	</editable>
	<labelOnTop>
		<field name="dma_id" labelOnTop="0"/>
		<field name="exit_id" labelOnTop="0"/>
		<field name="exit_type" labelOnTop="0"/>
		<field name="expl_id" labelOnTop="0"/>
		<field name="feature_id" labelOnTop="0"/>
		<field name="feature_type" labelOnTop="0"/>
		<field name="fluid_type" labelOnTop="0"/>
		<field name="gis_length" labelOnTop="0"/>
		<field name="ispsectorgeom" labelOnTop="0"/>
		<field name="link_id" labelOnTop="0"/>
		<field name="macrodma_id" labelOnTop="0"/>
		<field name="macrosector_id" labelOnTop="0"/>
		<field name="psector_rowid" labelOnTop="0"/>
		<field name="sector_id" labelOnTop="0"/>
		<field name="state" labelOnTop="0"/>
		<field name="userdefined_geom" labelOnTop="0"/>
		<field name="vnode_topelev" labelOnTop="0"/>
	</labelOnTop>
	<widgets/>
	<previewExpression>link_id</previewExpression>
	<mapTip></mapTip>
	<layerGeometryType>1</layerGeometryType>
</qgis>
$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('105', 'v_edit_node',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="1" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="2500" simplifyDrawingHints="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol" attr="sys_type">
    <categories>
      <category render="true" value="STORAGE" label="Storage" symbol="0"/>
      <category render="true" value="CHAMBER" label="Chamber" symbol="1"/>
      <category render="true" value="WWTP" label="Wwtp" symbol="2"/>
      <category render="true" value="NETGULLY" label="Netgully" symbol="3"/>
      <category render="true" value="NETELEMENT" label="Netelement" symbol="4"/>
      <category render="true" value="MANHOLE" label="Manhole" symbol="5"/>
      <category render="true" value="NETINIT" label="Netinit" symbol="6"/>
      <category render="true" value="WJUMP" label="Wjump" symbol="7"/>
      <category render="true" value="JUNCTION" label="Junction" symbol="8"/>
      <category render="true" value="OUTFALL" label="Outfall" symbol="9"/>
      <category render="true" value="VALVE" label="Valve" symbol="10"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="44,67,207,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2.5"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="31,120,180,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2.5"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="10" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="0,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="255,255,255,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="2" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="50,48,55,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="3"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="0,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="3" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="106,233,255,0"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="1.8"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="4" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="129,10,78,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="5" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="106,233,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="6" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="26,115,162,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="3"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="7" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="147,218,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="147,218,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="0.5"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="8" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="45,136,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="0.5"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="9" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="227,26,28,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="filled_arrowhead"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="3.5"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="106,233,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory penColor="#000000" lineSizeType="MM" height="15" scaleBasedVisibility="0" opacity="1" barWidth="5" scaleDependency="Area" penAlpha="255" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" maxScaleDenominator="1e+08" sizeScale="3x:0,0,0,0,0,0" sizeType="MM" backgroundColor="#ffffff" penWidth="0" width="15" labelPlacementMethod="XHeight" enabled="0" diagramOrientation="Up" minScaleDenominator="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings obstacle="0" showAll="1" dist="0" linePlacementFlags="18" placement="0" zIndex="0" priority="0">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="node_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="code">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="custom_top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sys_top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="ymax">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="custom_ymax">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sys_ymax">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="elev">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="custom_elev">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sys_elev">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="node_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sys_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="nodecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="matcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="epa_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="state_type">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="annotation">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="observ">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="comment">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="function_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="category_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="location_type">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="builtdate">
      <editWidget type="DateTime">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="enddate">
      <editWidget type="DateTime">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="muni_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postcode">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="district_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="streetname">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="streetname2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="svg">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="rotation">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="link">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="verified">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="undelete">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="label">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="label_x">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="label_y">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="publish">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="inventory">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="uncertain">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="xyz_date">
      <editWidget type="DateTime">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="unconnected">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="tstamp">
      <editWidget type="DateTime">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="insert_user">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate">
      <editWidget type="DateTime">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="node_id"/>
    <alias index="1" name="" field="code"/>
    <alias index="2" name="" field="top_elev"/>
    <alias index="3" name="" field="custom_top_elev"/>
    <alias index="4" name="" field="sys_top_elev"/>
    <alias index="5" name="" field="ymax"/>
    <alias index="6" name="" field="custom_ymax"/>
    <alias index="7" name="" field="sys_ymax"/>
    <alias index="8" name="" field="elev"/>
    <alias index="9" name="" field="custom_elev"/>
    <alias index="10" name="" field="sys_elev"/>
    <alias index="11" name="" field="node_type"/>
    <alias index="12" name="" field="sys_type"/>
    <alias index="13" name="" field="nodecat_id"/>
    <alias index="14" name="" field="matcat_id"/>
    <alias index="15" name="" field="epa_type"/>
    <alias index="16" name="" field="expl_id"/>
    <alias index="17" name="" field="macroexpl_id"/>
    <alias index="18" name="" field="sector_id"/>
    <alias index="19" name="" field="macrosector_id"/>
    <alias index="20" name="" field="state"/>
    <alias index="21" name="" field="state_type"/>
    <alias index="22" name="" field="annotation"/>
    <alias index="23" name="" field="observ"/>
    <alias index="24" name="" field="comment"/>
    <alias index="25" name="" field="dma_id"/>
    <alias index="26" name="" field="macrodma_id"/>
    <alias index="27" name="" field="soilcat_id"/>
    <alias index="28" name="" field="function_type"/>
    <alias index="29" name="" field="category_type"/>
    <alias index="30" name="" field="fluid_type"/>
    <alias index="31" name="" field="location_type"/>
    <alias index="32" name="" field="workcat_id"/>
    <alias index="33" name="" field="workcat_id_end"/>
    <alias index="34" name="" field="buildercat_id"/>
    <alias index="35" name="" field="builtdate"/>
    <alias index="36" name="" field="enddate"/>
    <alias index="37" name="" field="ownercat_id"/>
    <alias index="38" name="" field="muni_id"/>
    <alias index="39" name="" field="postcode"/>
    <alias index="40" name="" field="district_id"/>
    <alias index="41" name="" field="streetname"/>
    <alias index="42" name="" field="postnumber"/>
    <alias index="43" name="" field="postcomplement"/>
    <alias index="44" name="" field="streetname2"/>
    <alias index="45" name="" field="postnumber2"/>
    <alias index="46" name="" field="postcomplement2"/>
    <alias index="47" name="" field="descript"/>
    <alias index="48" name="" field="svg"/>
    <alias index="49" name="" field="rotation"/>
    <alias index="50" name="" field="link"/>
    <alias index="51" name="" field="verified"/>
    <alias index="52" name="" field="undelete"/>
    <alias index="53" name="" field="label"/>
    <alias index="54" name="" field="label_x"/>
    <alias index="55" name="" field="label_y"/>
    <alias index="56" name="" field="label_rotation"/>
    <alias index="57" name="" field="publish"/>
    <alias index="58" name="" field="inventory"/>
    <alias index="59" name="" field="uncertain"/>
    <alias index="60" name="" field="xyz_date"/>
    <alias index="61" name="" field="unconnected"/>
    <alias index="62" name="" field="num_value"/>
    <alias index="63" name="" field="tstamp"/>
    <alias index="64" name="" field="insert_user"/>
    <alias index="65" name="" field="lastupdate"/>
    <alias index="66" name="" field="lastupdate_user"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="node_id"/>
    <default expression="" applyOnUpdate="0" field="code"/>
    <default expression="" applyOnUpdate="0" field="top_elev"/>
    <default expression="" applyOnUpdate="0" field="custom_top_elev"/>
    <default expression="" applyOnUpdate="0" field="sys_top_elev"/>
    <default expression="" applyOnUpdate="0" field="ymax"/>
    <default expression="" applyOnUpdate="0" field="custom_ymax"/>
    <default expression="" applyOnUpdate="0" field="sys_ymax"/>
    <default expression="" applyOnUpdate="0" field="elev"/>
    <default expression="" applyOnUpdate="0" field="custom_elev"/>
    <default expression="" applyOnUpdate="0" field="sys_elev"/>
    <default expression="" applyOnUpdate="0" field="node_type"/>
    <default expression="" applyOnUpdate="0" field="sys_type"/>
    <default expression="" applyOnUpdate="0" field="nodecat_id"/>
    <default expression="" applyOnUpdate="0" field="matcat_id"/>
    <default expression="" applyOnUpdate="0" field="epa_type"/>
    <default expression="" applyOnUpdate="0" field="expl_id"/>
    <default expression="" applyOnUpdate="0" field="macroexpl_id"/>
    <default expression="" applyOnUpdate="0" field="sector_id"/>
    <default expression="" applyOnUpdate="0" field="macrosector_id"/>
    <default expression="" applyOnUpdate="0" field="state"/>
    <default expression="" applyOnUpdate="0" field="state_type"/>
    <default expression="" applyOnUpdate="0" field="annotation"/>
    <default expression="" applyOnUpdate="0" field="observ"/>
    <default expression="" applyOnUpdate="0" field="comment"/>
    <default expression="" applyOnUpdate="0" field="dma_id"/>
    <default expression="" applyOnUpdate="0" field="macrodma_id"/>
    <default expression="" applyOnUpdate="0" field="soilcat_id"/>
    <default expression="" applyOnUpdate="0" field="function_type"/>
    <default expression="" applyOnUpdate="0" field="category_type"/>
    <default expression="" applyOnUpdate="0" field="fluid_type"/>
    <default expression="" applyOnUpdate="0" field="location_type"/>
    <default expression="" applyOnUpdate="0" field="workcat_id"/>
    <default expression="" applyOnUpdate="0" field="workcat_id_end"/>
    <default expression="" applyOnUpdate="0" field="buildercat_id"/>
    <default expression="" applyOnUpdate="0" field="builtdate"/>
    <default expression="" applyOnUpdate="0" field="enddate"/>
    <default expression="" applyOnUpdate="0" field="ownercat_id"/>
    <default expression="" applyOnUpdate="0" field="muni_id"/>
    <default expression="" applyOnUpdate="0" field="postcode"/>
    <default expression="" applyOnUpdate="0" field="district_id"/>
    <default expression="" applyOnUpdate="0" field="streetname"/>
    <default expression="" applyOnUpdate="0" field="postnumber"/>
    <default expression="" applyOnUpdate="0" field="postcomplement"/>
    <default expression="" applyOnUpdate="0" field="streetname2"/>
    <default expression="" applyOnUpdate="0" field="postnumber2"/>
    <default expression="" applyOnUpdate="0" field="postcomplement2"/>
    <default expression="" applyOnUpdate="0" field="descript"/>
    <default expression="" applyOnUpdate="0" field="svg"/>
    <default expression="" applyOnUpdate="0" field="rotation"/>
    <default expression="" applyOnUpdate="0" field="link"/>
    <default expression="" applyOnUpdate="0" field="verified"/>
    <default expression="" applyOnUpdate="0" field="undelete"/>
    <default expression="" applyOnUpdate="0" field="label"/>
    <default expression="" applyOnUpdate="0" field="label_x"/>
    <default expression="" applyOnUpdate="0" field="label_y"/>
    <default expression="" applyOnUpdate="0" field="label_rotation"/>
    <default expression="" applyOnUpdate="0" field="publish"/>
    <default expression="" applyOnUpdate="0" field="inventory"/>
    <default expression="" applyOnUpdate="0" field="uncertain"/>
    <default expression="" applyOnUpdate="0" field="xyz_date"/>
    <default expression="" applyOnUpdate="0" field="unconnected"/>
    <default expression="" applyOnUpdate="0" field="num_value"/>
    <default expression="" applyOnUpdate="0" field="tstamp"/>
    <default expression="" applyOnUpdate="0" field="insert_user"/>
    <default expression="" applyOnUpdate="0" field="lastupdate"/>
    <default expression="" applyOnUpdate="0" field="lastupdate_user"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="node_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="code"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="top_elev"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_top_elev"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_top_elev"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="ymax"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_ymax"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_ymax"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="elev"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="custom_elev"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_elev"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="node_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sys_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="nodecat_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="matcat_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="epa_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macroexpl_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="sector_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrosector_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="state_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="annotation"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="observ"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="comment"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="dma_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="macrodma_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="soilcat_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="function_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="category_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="fluid_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="location_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="workcat_id_end"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="buildercat_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="builtdate"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="enddate"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="ownercat_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="muni_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcode"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="district_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="streetname2"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postnumber2"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="postcomplement2"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="descript"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="svg"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="rotation"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="link"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="verified"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="undelete"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_x"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_y"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="label_rotation"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="publish"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="inventory"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="uncertain"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="xyz_date"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="unconnected"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="num_value"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="tstamp"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="insert_user"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="lastupdate_user"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="node_id"/>
    <constraint desc="" exp="" field="code"/>
    <constraint desc="" exp="" field="top_elev"/>
    <constraint desc="" exp="" field="custom_top_elev"/>
    <constraint desc="" exp="" field="sys_top_elev"/>
    <constraint desc="" exp="" field="ymax"/>
    <constraint desc="" exp="" field="custom_ymax"/>
    <constraint desc="" exp="" field="sys_ymax"/>
    <constraint desc="" exp="" field="elev"/>
    <constraint desc="" exp="" field="custom_elev"/>
    <constraint desc="" exp="" field="sys_elev"/>
    <constraint desc="" exp="" field="node_type"/>
    <constraint desc="" exp="" field="sys_type"/>
    <constraint desc="" exp="" field="nodecat_id"/>
    <constraint desc="" exp="" field="matcat_id"/>
    <constraint desc="" exp="" field="epa_type"/>
    <constraint desc="" exp="" field="expl_id"/>
    <constraint desc="" exp="" field="macroexpl_id"/>
    <constraint desc="" exp="" field="sector_id"/>
    <constraint desc="" exp="" field="macrosector_id"/>
    <constraint desc="" exp="" field="state"/>
    <constraint desc="" exp="" field="state_type"/>
    <constraint desc="" exp="" field="annotation"/>
    <constraint desc="" exp="" field="observ"/>
    <constraint desc="" exp="" field="comment"/>
    <constraint desc="" exp="" field="dma_id"/>
    <constraint desc="" exp="" field="macrodma_id"/>
    <constraint desc="" exp="" field="soilcat_id"/>
    <constraint desc="" exp="" field="function_type"/>
    <constraint desc="" exp="" field="category_type"/>
    <constraint desc="" exp="" field="fluid_type"/>
    <constraint desc="" exp="" field="location_type"/>
    <constraint desc="" exp="" field="workcat_id"/>
    <constraint desc="" exp="" field="workcat_id_end"/>
    <constraint desc="" exp="" field="buildercat_id"/>
    <constraint desc="" exp="" field="builtdate"/>
    <constraint desc="" exp="" field="enddate"/>
    <constraint desc="" exp="" field="ownercat_id"/>
    <constraint desc="" exp="" field="muni_id"/>
    <constraint desc="" exp="" field="postcode"/>
    <constraint desc="" exp="" field="district_id"/>
    <constraint desc="" exp="" field="streetname"/>
    <constraint desc="" exp="" field="postnumber"/>
    <constraint desc="" exp="" field="postcomplement"/>
    <constraint desc="" exp="" field="streetname2"/>
    <constraint desc="" exp="" field="postnumber2"/>
    <constraint desc="" exp="" field="postcomplement2"/>
    <constraint desc="" exp="" field="descript"/>
    <constraint desc="" exp="" field="svg"/>
    <constraint desc="" exp="" field="rotation"/>
    <constraint desc="" exp="" field="link"/>
    <constraint desc="" exp="" field="verified"/>
    <constraint desc="" exp="" field="undelete"/>
    <constraint desc="" exp="" field="label"/>
    <constraint desc="" exp="" field="label_x"/>
    <constraint desc="" exp="" field="label_y"/>
    <constraint desc="" exp="" field="label_rotation"/>
    <constraint desc="" exp="" field="publish"/>
    <constraint desc="" exp="" field="inventory"/>
    <constraint desc="" exp="" field="uncertain"/>
    <constraint desc="" exp="" field="xyz_date"/>
    <constraint desc="" exp="" field="unconnected"/>
    <constraint desc="" exp="" field="num_value"/>
    <constraint desc="" exp="" field="tstamp"/>
    <constraint desc="" exp="" field="insert_user"/>
    <constraint desc="" exp="" field="lastupdate"/>
    <constraint desc="" exp="" field="lastupdate_user"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
    <columns>
      <column width="-1" name="node_id" type="field" hidden="0"/>
      <column width="-1" name="code" type="field" hidden="0"/>
      <column width="-1" name="top_elev" type="field" hidden="0"/>
      <column width="-1" name="custom_top_elev" type="field" hidden="0"/>
      <column width="-1" name="sys_top_elev" type="field" hidden="0"/>
      <column width="-1" name="ymax" type="field" hidden="0"/>
      <column width="-1" name="custom_ymax" type="field" hidden="0"/>
      <column width="-1" name="sys_ymax" type="field" hidden="0"/>
      <column width="-1" name="elev" type="field" hidden="0"/>
      <column width="-1" name="custom_elev" type="field" hidden="0"/>
      <column width="-1" name="sys_elev" type="field" hidden="0"/>
      <column width="-1" name="node_type" type="field" hidden="0"/>
      <column width="-1" name="sys_type" type="field" hidden="0"/>
      <column width="-1" name="nodecat_id" type="field" hidden="0"/>
      <column width="-1" name="matcat_id" type="field" hidden="0"/>
      <column width="-1" name="epa_type" type="field" hidden="0"/>
      <column width="-1" name="expl_id" type="field" hidden="0"/>
      <column width="-1" name="macroexpl_id" type="field" hidden="0"/>
      <column width="-1" name="sector_id" type="field" hidden="0"/>
      <column width="-1" name="macrosector_id" type="field" hidden="0"/>
      <column width="-1" name="state" type="field" hidden="0"/>
      <column width="-1" name="state_type" type="field" hidden="0"/>
      <column width="-1" name="annotation" type="field" hidden="0"/>
      <column width="-1" name="observ" type="field" hidden="0"/>
      <column width="-1" name="comment" type="field" hidden="0"/>
      <column width="-1" name="dma_id" type="field" hidden="0"/>
      <column width="-1" name="macrodma_id" type="field" hidden="0"/>
      <column width="-1" name="soilcat_id" type="field" hidden="0"/>
      <column width="-1" name="function_type" type="field" hidden="0"/>
      <column width="-1" name="category_type" type="field" hidden="0"/>
      <column width="-1" name="fluid_type" type="field" hidden="0"/>
      <column width="-1" name="location_type" type="field" hidden="0"/>
      <column width="-1" name="workcat_id" type="field" hidden="0"/>
      <column width="-1" name="workcat_id_end" type="field" hidden="0"/>
      <column width="-1" name="buildercat_id" type="field" hidden="0"/>
      <column width="-1" name="builtdate" type="field" hidden="0"/>
      <column width="-1" name="enddate" type="field" hidden="0"/>
      <column width="-1" name="ownercat_id" type="field" hidden="0"/>
      <column width="-1" name="muni_id" type="field" hidden="0"/>
      <column width="-1" name="postcode" type="field" hidden="0"/>
      <column width="-1" name="district_id" type="field" hidden="0"/>
      <column width="-1" name="streetname" type="field" hidden="0"/>
      <column width="-1" name="postnumber" type="field" hidden="0"/>
      <column width="-1" name="postcomplement" type="field" hidden="0"/>
      <column width="-1" name="streetname2" type="field" hidden="0"/>
      <column width="-1" name="postnumber2" type="field" hidden="0"/>
      <column width="-1" name="postcomplement2" type="field" hidden="0"/>
      <column width="-1" name="descript" type="field" hidden="0"/>
      <column width="-1" name="svg" type="field" hidden="0"/>
      <column width="-1" name="rotation" type="field" hidden="0"/>
      <column width="-1" name="link" type="field" hidden="0"/>
      <column width="-1" name="verified" type="field" hidden="0"/>
      <column width="-1" name="undelete" type="field" hidden="0"/>
      <column width="-1" name="label" type="field" hidden="0"/>
      <column width="-1" name="label_x" type="field" hidden="0"/>
      <column width="-1" name="label_y" type="field" hidden="0"/>
      <column width="-1" name="label_rotation" type="field" hidden="0"/>
      <column width="-1" name="publish" type="field" hidden="0"/>
      <column width="-1" name="inventory" type="field" hidden="0"/>
      <column width="-1" name="uncertain" type="field" hidden="0"/>
      <column width="-1" name="xyz_date" type="field" hidden="0"/>
      <column width="-1" name="unconnected" type="field" hidden="0"/>
      <column width="-1" name="num_value" type="field" hidden="0"/>
      <column width="-1" name="tstamp" type="field" hidden="0"/>
      <column width="-1" name="insert_user" type="field" hidden="0"/>
      <column width="-1" name="lastupdate" type="field" hidden="0"/>
      <column width="-1" name="lastupdate_user" type="field" hidden="0"/>
      <column width="-1" type="actions" hidden="1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="annotation" editable="1"/>
    <field name="buildercat_id" editable="1"/>
    <field name="builtdate" editable="1"/>
    <field name="category_type" editable="1"/>
    <field name="code" editable="1"/>
    <field name="comment" editable="1"/>
    <field name="custom_elev" editable="1"/>
    <field name="custom_top_elev" editable="1"/>
    <field name="custom_ymax" editable="1"/>
    <field name="descript" editable="1"/>
    <field name="district_id" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="elev" editable="1"/>
    <field name="enddate" editable="1"/>
    <field name="epa_type" editable="1"/>
    <field name="expl_id" editable="1"/>
    <field name="fluid_type" editable="1"/>
    <field name="function_type" editable="1"/>
    <field name="insert_user" editable="1"/>
    <field name="inventory" editable="1"/>
    <field name="label" editable="1"/>
    <field name="label_rotation" editable="1"/>
    <field name="label_x" editable="1"/>
    <field name="label_y" editable="1"/>
    <field name="lastupdate" editable="1"/>
    <field name="lastupdate_user" editable="1"/>
    <field name="link" editable="1"/>
    <field name="location_type" editable="1"/>
    <field name="macrodma_id" editable="1"/>
    <field name="macroexpl_id" editable="1"/>
    <field name="macrosector_id" editable="1"/>
    <field name="matcat_id" editable="1"/>
    <field name="muni_id" editable="1"/>
    <field name="node_id" editable="1"/>
    <field name="node_type" editable="1"/>
    <field name="nodecat_id" editable="1"/>
    <field name="num_value" editable="1"/>
    <field name="observ" editable="1"/>
    <field name="ownercat_id" editable="1"/>
    <field name="postcode" editable="1"/>
    <field name="postcomplement" editable="1"/>
    <field name="postcomplement2" editable="1"/>
    <field name="postnumber" editable="1"/>
    <field name="postnumber2" editable="1"/>
    <field name="publish" editable="1"/>
    <field name="rotation" editable="1"/>
    <field name="sector_id" editable="1"/>
    <field name="soilcat_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
    <field name="streetname" editable="1"/>
    <field name="streetname2" editable="1"/>
    <field name="svg" editable="1"/>
    <field name="sys_elev" editable="1"/>
    <field name="sys_top_elev" editable="1"/>
    <field name="sys_type" editable="1"/>
    <field name="sys_ymax" editable="1"/>
    <field name="top_elev" editable="1"/>
    <field name="tstamp" editable="1"/>
    <field name="uncertain" editable="1"/>
    <field name="unconnected" editable="1"/>
    <field name="undelete" editable="1"/>
    <field name="verified" editable="1"/>
    <field name="workcat_id" editable="1"/>
    <field name="workcat_id_end" editable="1"/>
    <field name="xyz_date" editable="1"/>
    <field name="ymax" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="annotation" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="category_type" labelOnTop="0"/>
    <field name="code" labelOnTop="0"/>
    <field name="comment" labelOnTop="0"/>
    <field name="custom_elev" labelOnTop="0"/>
    <field name="custom_top_elev" labelOnTop="0"/>
    <field name="custom_ymax" labelOnTop="0"/>
    <field name="descript" labelOnTop="0"/>
    <field name="district_id" labelOnTop="0"/>
    <field name="dma_id" labelOnTop="0"/>
    <field name="elev" labelOnTop="0"/>
    <field name="enddate" labelOnTop="0"/>
    <field name="epa_type" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="fluid_type" labelOnTop="0"/>
    <field name="function_type" labelOnTop="0"/>
    <field name="insert_user" labelOnTop="0"/>
    <field name="inventory" labelOnTop="0"/>
    <field name="label" labelOnTop="0"/>
    <field name="label_rotation" labelOnTop="0"/>
    <field name="label_x" labelOnTop="0"/>
    <field name="label_y" labelOnTop="0"/>
    <field name="lastupdate" labelOnTop="0"/>
    <field name="lastupdate_user" labelOnTop="0"/>
    <field name="link" labelOnTop="0"/>
    <field name="location_type" labelOnTop="0"/>
    <field name="macrodma_id" labelOnTop="0"/>
    <field name="macroexpl_id" labelOnTop="0"/>
    <field name="macrosector_id" labelOnTop="0"/>
    <field name="matcat_id" labelOnTop="0"/>
    <field name="muni_id" labelOnTop="0"/>
    <field name="node_id" labelOnTop="0"/>
    <field name="node_type" labelOnTop="0"/>
    <field name="nodecat_id" labelOnTop="0"/>
    <field name="num_value" labelOnTop="0"/>
    <field name="observ" labelOnTop="0"/>
    <field name="ownercat_id" labelOnTop="0"/>
    <field name="postcode" labelOnTop="0"/>
    <field name="postcomplement" labelOnTop="0"/>
    <field name="postcomplement2" labelOnTop="0"/>
    <field name="postnumber" labelOnTop="0"/>
    <field name="postnumber2" labelOnTop="0"/>
    <field name="publish" labelOnTop="0"/>
    <field name="rotation" labelOnTop="0"/>
    <field name="sector_id" labelOnTop="0"/>
    <field name="soilcat_id" labelOnTop="0"/>
    <field name="state" labelOnTop="0"/>
    <field name="state_type" labelOnTop="0"/>
    <field name="streetname" labelOnTop="0"/>
    <field name="streetname2" labelOnTop="0"/>
    <field name="svg" labelOnTop="0"/>
    <field name="sys_elev" labelOnTop="0"/>
    <field name="sys_top_elev" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="sys_ymax" labelOnTop="0"/>
    <field name="top_elev" labelOnTop="0"/>
    <field name="tstamp" labelOnTop="0"/>
    <field name="uncertain" labelOnTop="0"/>
    <field name="unconnected" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
    <field name="xyz_date" labelOnTop="0"/>
    <field name="ymax" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>streetname</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('106', 'v_anl_flow_arc',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyMaxScale="1" simplifyLocal="1" hasScaleBasedVisibilityFlag="0" version="3.10.3-A Coruña" maxScale="0" simplifyDrawingTol="1" labelsEnabled="0" simplifyAlgorithm="0" simplifyDrawingHints="1" minScale="1e+08" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 enableorderby="0" symbollevels="0" attr="context" forceraster="0" type="categorizedSymbol">
    <categories>
      <category symbol="0" label="Flow exit" render="true" value="Flow exit"/>
      <category symbol="1" label="Flow trace" render="true" value="Flow trace"/>
    </categories>
    <symbols>
      <symbol force_rhr="0" clip_to_extent="1" alpha="1" name="0" type="line">
        <layer pass="0" class="SimpleLine" locked="0" enabled="1">
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="235,74,117,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.86"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" clip_to_extent="1" alpha="1" name="1" type="line">
        <layer pass="0" class="SimpleLine" locked="0" enabled="1">
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="235,167,48,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.86"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol force_rhr="0" clip_to_extent="1" alpha="1" name="0" type="line">
        <layer pass="0" class="SimpleLine" locked="0" enabled="1">
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="184,30,179,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.26"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="arc_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="arc_type">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="context">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" name="" index="0"/>
    <alias field="arc_id" name="" index="1"/>
    <alias field="arc_type" name="" index="2"/>
    <alias field="context" name="" index="3"/>
    <alias field="expl_id" name="" index="4"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" field="id" applyOnUpdate="0"/>
    <default expression="" field="arc_id" applyOnUpdate="0"/>
    <default expression="" field="arc_type" applyOnUpdate="0"/>
    <default expression="" field="context" applyOnUpdate="0"/>
    <default expression="" field="expl_id" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="1" unique_strength="1" exp_strength="0" constraints="3"/>
    <constraint field="arc_id" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
    <constraint field="arc_type" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
    <constraint field="context" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
    <constraint field="expl_id" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="arc_id" exp="" desc=""/>
    <constraint field="arc_type" exp="" desc=""/>
    <constraint field="context" exp="" desc=""/>
    <constraint field="expl_id" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortOrder="0" sortExpression="" actionWidgetStyle="dropDown">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('107', 'v_anl_flow_connec',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="0" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1e+08" simplifyDrawingHints="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol" attr="context">
    <categories>
      <category render="true" value="Flow exit" label="Flow exit" symbol="0"/>
      <category render="true" value="Flow trace" label="Flow trace" symbol="1"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="0.960784" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="45"/>
          <prop k="color" v="235,74,117,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="cross_fill"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="144,0,40,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="1.6"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="45"/>
          <prop k="color" v="235,167,48,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="cross_fill"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="159,104,9,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="1.6"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="216,199,98,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory penColor="#000000" lineSizeType="MM" height="15" scaleBasedVisibility="0" opacity="1" barWidth="5" scaleDependency="Area" penAlpha="255" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" maxScaleDenominator="1e+08" sizeScale="3x:0,0,0,0,0,0" sizeType="MM" backgroundColor="#ffffff" penWidth="0" width="15" labelPlacementMethod="XHeight" enabled="0" diagramOrientation="Up" minScaleDenominator="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings obstacle="0" showAll="1" dist="0" linePlacementFlags="18" placement="0" zIndex="0" priority="0">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="connec_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="context">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="connec_id"/>
    <alias index="1" name="" field="context"/>
    <alias index="2" name="" field="expl_id"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="connec_id"/>
    <default expression="" applyOnUpdate="0" field="context"/>
    <default expression="" applyOnUpdate="0" field="expl_id"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="connec_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="context"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="connec_id"/>
    <constraint desc="" exp="" field="context"/>
    <constraint desc="" exp="" field="expl_id"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
    <columns>
      <column width="-1" name="connec_id" type="field" hidden="0"/>
      <column width="-1" name="context" type="field" hidden="0"/>
      <column width="-1" name="expl_id" type="field" hidden="0"/>
      <column width="-1" type="actions" hidden="1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- codificación: utf-8 -*-
"""
Los formularios de QGIS pueden tener una función de Python que
es llamada cuando se abre el formulario.

Use esta función para añadir lógica extra a sus formularios.

Introduzca el nombre de la función en el campo
"Python Init function".
Sigue un ejemplo:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="connec_id" editable="1"/>
    <field name="context" editable="1"/>
    <field name="expl_id" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="connec_id" labelOnTop="0"/>
    <field name="context" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>connec_id</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('108', 'v_anl_flow_gully',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="0" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1e+08" simplifyDrawingHints="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol" attr="context">
    <categories>
      <category render="true" value="Flow exit" label="Flow exit" symbol="0"/>
      <category render="true" value="Flow trace" label="Flow trace" symbol="1"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="0.960784" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="45"/>
          <prop k="color" v="235,74,117,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="cross_fill"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="144,0,40,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="1.6"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="45"/>
          <prop k="color" v="235,167,48,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="cross_fill"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="159,104,9,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="1.6"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="216,199,98,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="gully_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="context">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="gully_id"/>
    <alias index="1" name="" field="context"/>
    <alias index="2" name="" field="expl_id"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="gully_id"/>
    <default expression="" applyOnUpdate="0" field="context"/>
    <default expression="" applyOnUpdate="0" field="expl_id"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="gully_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="context"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="gully_id"/>
    <constraint desc="" exp="" field="context"/>
    <constraint desc="" exp="" field="expl_id"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('109', 'v_anl_flow_node',$$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyLocal="1" simplifyAlgorithm="0" maxScale="0" hasScaleBasedVisibilityFlag="0" labelsEnabled="0" simplifyDrawingTol="1" readOnly="0" simplifyMaxScale="1" version="3.10.3-A Coruña" minScale="1e+08" simplifyDrawingHints="1">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol" attr="context">
    <categories>
      <category render="true" value="Flow exit" label="Flow exit" symbol="0"/>
      <category render="true" value="Flow trace" label="Flow trace" symbol="1"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="0.960784" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="235,74,117,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="235,167,48,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" clip_to_extent="1" alpha="1" type="marker">
        <layer enabled="1" class="SimpleMarker" locked="0" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="49,136,116,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="node_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="node_type">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="context">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="" field="id"/>
    <alias index="1" name="" field="node_id"/>
    <alias index="2" name="" field="node_type"/>
    <alias index="3" name="" field="context"/>
    <alias index="4" name="" field="expl_id"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="id"/>
    <default expression="" applyOnUpdate="0" field="node_id"/>
    <default expression="" applyOnUpdate="0" field="node_type"/>
    <default expression="" applyOnUpdate="0" field="context"/>
    <default expression="" applyOnUpdate="0" field="expl_id"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0" field="id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="node_id"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="node_type"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="context"/>
    <constraint unique_strength="0" constraints="0" notnull_strength="0" exp_strength="0" field="expl_id"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="id"/>
    <constraint desc="" exp="" field="node_id"/>
    <constraint desc="" exp="" field="node_type"/>
    <constraint desc="" exp="" field="context"/>
    <constraint desc="" exp="" field="expl_id"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" sortOrder="0" actionWidgetStyle="dropDown">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$ , true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('110', 'Overlap affected arcs', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis hasScaleBasedVisibilityFlag="0" simplifyLocal="1" readOnly="0" labelsEnabled="0" simplifyAlgorithm="0" simplifyMaxScale="1" minScale="1e+08" simplifyDrawingHints="1" version="3.10.4-A Coruña" styleCategories="AllStyleCategories" simplifyDrawingTol="1" maxScale="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="singleSymbol" enableorderby="0" forceraster="0" symbollevels="0">
    <symbols>
      <symbol name="0" type="fill" alpha="1" clip_to_extent="1" force_rhr="0">
        <layer pass="0" class="SimpleFill" locked="0" enabled="1">
          <prop v="3x:0,0,0,0,0,0" k="border_width_map_unit_scale"/>
          <prop v="255,112,40,125" k="color"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="35,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0.26" k="outline_width"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="solid" k="style"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="pol_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="pol_id"/>
    <alias name="" index="1" field="descript"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="pol_id"/>
    <default expression="" applyOnUpdate="0" field="descript"/>
  </defaults>
  <constraints>
    <constraint notnull_strength="0" unique_strength="0" exp_strength="0" field="pol_id" constraints="0"/>
    <constraint notnull_strength="0" unique_strength="0" exp_strength="0" field="descript" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" desc="" field="pol_id"/>
    <constraint exp="" desc="" field="descript"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
$$, true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('111', 'Overlap affected connecs' $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis hasScaleBasedVisibilityFlag="0" simplifyLocal="1" readOnly="0" labelsEnabled="0" simplifyAlgorithm="0" simplifyMaxScale="1" minScale="1e+08" simplifyDrawingHints="1" version="3.10.4-A Coruña" styleCategories="AllStyleCategories" simplifyDrawingTol="1" maxScale="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="singleSymbol" enableorderby="0" forceraster="0" symbollevels="0">
    <symbols>
      <symbol name="0" type="marker" alpha="1" clip_to_extent="1" force_rhr="0">
        <layer pass="0" class="SimpleMarker" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="255,0,0,150" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="35,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2.6" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" class="SimpleMarker" locked="0" enabled="1">
          <prop v="0" k="angle"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="cross" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="35,35,35,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="descript">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="connec_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="descript"/>
    <alias name="" index="1" field="connec_id"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="descript"/>
    <default expression="" applyOnUpdate="0" field="connec_id"/>
  </defaults>
  <constraints>
    <constraint notnull_strength="0" unique_strength="0" exp_strength="0" field="descript" constraints="0"/>
    <constraint notnull_strength="0" unique_strength="0" exp_strength="0" field="connec_id" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" desc="" field="descript"/>
    <constraint exp="" desc="" field="connec_id"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true);


INSERT INTO sys_style(idval, styletype, stylevalue, active)
VALUES('112', 'Other mincuts whichs overlaps' $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis hasScaleBasedVisibilityFlag="0" simplifyLocal="1" readOnly="0" labelsEnabled="0" simplifyAlgorithm="0" simplifyMaxScale="1" minScale="1e+08" simplifyDrawingHints="1" version="3.10.4-A Coruña" styleCategories="AllStyleCategories" simplifyDrawingTol="1" maxScale="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="singleSymbol" enableorderby="0" forceraster="0" symbollevels="0">
    <symbols>
      <symbol name="0" type="line" alpha="1" clip_to_extent="1" force_rhr="0">
        <layer pass="0" class="SimpleLine" locked="0" enabled="1">
          <prop v="round" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="round" k="joinstyle"/>
          <prop v="76,38,0,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="1.8" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" class="SimpleLine" locked="0" enabled="1">
          <prop v="round" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="round" k="joinstyle"/>
          <prop v="76,119,220,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="1.6" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option value="" type="QString"/>
    </activeChecks>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="arc_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="arc_id"/>
    <alias name="" index="1" field="descript"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" applyOnUpdate="0" field="arc_id"/>
    <default expression="" applyOnUpdate="0" field="descript"/>
  </defaults>
  <constraints>
    <constraint notnull_strength="0" unique_strength="0" exp_strength="0" field="arc_id" constraints="0"/>
    <constraint notnull_strength="0" unique_strength="0" exp_strength="0" field="descript" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" desc="" field="arc_id"/>
    <constraint exp="" desc="" field="descript"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
    <columns/>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable/>
  <labelOnTop/>
  <widgets/>
  <previewExpression></previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true);
