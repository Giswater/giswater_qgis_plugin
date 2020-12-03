/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2124,'gw_fct_connect_to_network',NULL,'{"visible": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_gully", "v_edit_link"]}',NULL)
ON CONFLICT (id) DO NOTHING;


-- 2020/07/20
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_arc', 101, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_connec', 102, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_link', 103, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_node', 104, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_gully', 105, 'GW Layers') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_table(id, style) VALUES('v_anl_flow_arc', 106) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style) VALUES('v_anl_flow_connec', 107) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style) VALUES('v_anl_flow_gully', 108) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style) VALUES('v_anl_flow_node', 109) ON CONFLICT (id) DO NOTHING;


INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2202,'gw_fct_anl_arc_intersection','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2204,'gw_fct_anl_arc_inverted','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2206,'gw_fct_anl_node_exit_upper_intro','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2208,'gw_fct_anl_node_flowregulator','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2210,'gw_fct_anl_node_sink','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2212,'gw_fct_anl_node_topological_consistency','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2214,'gw_fct_flow_exit','{"style":{"point":{"style":"qml", "id":"2214"},  "line":{"style":"qml", "id":"2214"}}}','{"visible": ["v_anl_flow_node", "v_anl_flow_gully", "v_anl_flow_connec", "v_anl_flow_arc"]}',NULL)
 ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2218,'gw_fct_flow_trace','{"style":{"point":{"style":"qml", "id":"2218"},  "line":{"style":"qml", "id":"2218"}}}','{"visible": ["v_anl_flow_node", "v_anl_flow_gully", "v_anl_flow_connec", "v_anl_flow_arc"]}',NULL) 
 ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2431,'gw_fct_pg2epa_check_data', '{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}', NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2524,'gw_fct_import_swmm_inp',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2858,'gw_fct_pg2epa_check_result','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2860,'gw_fct_pg2epa_check_options','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('101', 'v_edit_Arc', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" labelsEnabled="1" simplifyDrawingHints="1" minScale="1e+08" simplifyLocal="1" simplifyMaxScale="1" maxScale="100000" readOnly="0" version="3.10.3-A Coruña" hasScaleBasedVisibilityFlag="0" simplifyAlgorithm="0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" type="RuleRenderer" symbollevels="0" enableorderby="0">
    <rules key="{a226d791-7f55-4ca8-b7a0-6b4c8d42de02}">
      <rule filter=" &quot;sys_type&quot;  =  'CONDUIT'  AND &quot;state&quot; = 1" key="{a249c2ea-539b-4c81-bb77-fe9bcb3d594d}" symbol="0" label="Conduit"/>
      <rule filter=" &quot;sys_type&quot;  =   'SIPHON'  AND &quot;state&quot; = 1" key="{7b6309f3-e7a2-46e1-81c1-f28acdae68cd}" symbol="1" label="Siphon"/>
      <rule filter=" &quot;sys_type&quot;  =   'WACCEL'  AND &quot;state&quot; = 1" key="{dc14f906-9233-4320-af02-4a52f0615940}" symbol="2" label="Waccel"/>
      <rule filter=" &quot;sys_type&quot;  =   'VARC'  AND &quot;state&quot; = 1" key="{5eed5062-bf5c-4b54-8128-75070e29e5ea}" symbol="3" label="Varc"/>
      <rule filter="&quot;state&quot; = 0" key="{3503f7d4-d5e0-4888-9b50-05f847f5b6ab}" symbol="4" label="Obselete"/>
      <rule filter="&quot;state&quot; = 2" key="{7b2990be-f57a-4caf-b99a-308c6d4349ca}" symbol="5" label="Planified"/>
    </rules>
    <symbols>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="45,84,255,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.36" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="MarkerLine" pass="0">
          <prop v="4" k="average_angle_length"/>
          <prop v="3x:0,0,0,0,0,0" k="average_angle_map_unit_scale"/>
          <prop v="MM" k="average_angle_unit"/>
          <prop v="3" k="interval"/>
          <prop v="3x:0,0,0,0,0,0" k="interval_map_unit_scale"/>
          <prop v="MM" k="interval_unit"/>
          <prop v="0" k="offset"/>
          <prop v="0" k="offset_along_line"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_along_line_map_unit_scale"/>
          <prop v="MM" k="offset_along_line_unit"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="centralpoint" k="placement"/>
          <prop v="0" k="ring_filter"/>
          <prop v="1" k="rotate"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@0@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="45,84,255,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="filled_arrowhead" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0,0,0,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="0.36" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="size">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="1">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="140,0,255,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.36" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="MarkerLine" pass="0">
          <prop v="4" k="average_angle_length"/>
          <prop v="3x:0,0,0,0,0,0" k="average_angle_map_unit_scale"/>
          <prop v="MM" k="average_angle_unit"/>
          <prop v="3" k="interval"/>
          <prop v="3x:0,0,0,0,0,0" k="interval_map_unit_scale"/>
          <prop v="MM" k="interval_unit"/>
          <prop v="0" k="offset"/>
          <prop v="0" k="offset_along_line"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_along_line_map_unit_scale"/>
          <prop v="MM" k="offset_along_line_unit"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="centralpoint" k="placement"/>
          <prop v="0" k="ring_filter"/>
          <prop v="1" k="rotate"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@1@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="140,0,255,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="filled_arrowhead" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0,0,0,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="0.36" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="size">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="2">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="43,131,30,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.36" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="MarkerLine" pass="0">
          <prop v="4" k="average_angle_length"/>
          <prop v="3x:0,0,0,0,0,0" k="average_angle_map_unit_scale"/>
          <prop v="MM" k="average_angle_unit"/>
          <prop v="3" k="interval"/>
          <prop v="3x:0,0,0,0,0,0" k="interval_map_unit_scale"/>
          <prop v="MM" k="interval_unit"/>
          <prop v="0" k="offset"/>
          <prop v="0" k="offset_along_line"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_along_line_map_unit_scale"/>
          <prop v="MM" k="offset_along_line_unit"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="centralpoint" k="placement"/>
          <prop v="0" k="ring_filter"/>
          <prop v="1" k="rotate"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@2@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="43,131,30,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="filled_arrowhead" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0,0,0,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="0.36" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="size">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="3">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="229,218,93,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.36" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="MarkerLine" pass="0">
          <prop v="4" k="average_angle_length"/>
          <prop v="3x:0,0,0,0,0,0" k="average_angle_map_unit_scale"/>
          <prop v="MM" k="average_angle_unit"/>
          <prop v="3" k="interval"/>
          <prop v="3x:0,0,0,0,0,0" k="interval_map_unit_scale"/>
          <prop v="MM" k="interval_unit"/>
          <prop v="0" k="offset"/>
          <prop v="0" k="offset_along_line"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_along_line_map_unit_scale"/>
          <prop v="MM" k="offset_along_line_unit"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="centralpoint" k="placement"/>
          <prop v="0" k="ring_filter"/>
          <prop v="1" k="rotate"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@3@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="229,218,93,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="filled_arrowhead" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0,0,0,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="0.36" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="size">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="4">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="161,35,43,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.36" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="MarkerLine" pass="0">
          <prop v="4" k="average_angle_length"/>
          <prop v="3x:0,0,0,0,0,0" k="average_angle_map_unit_scale"/>
          <prop v="MM" k="average_angle_unit"/>
          <prop v="3" k="interval"/>
          <prop v="3x:0,0,0,0,0,0" k="interval_map_unit_scale"/>
          <prop v="MM" k="interval_unit"/>
          <prop v="0" k="offset"/>
          <prop v="0" k="offset_along_line"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_along_line_map_unit_scale"/>
          <prop v="MM" k="offset_along_line_unit"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="centralpoint" k="placement"/>
          <prop v="0" k="ring_filter"/>
          <prop v="1" k="rotate"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@4@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="161,35,43,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="filled_arrowhead" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0,0,0,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="0.36" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="size">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="5">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="255,127,0,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.36" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="MarkerLine" pass="0">
          <prop v="4" k="average_angle_length"/>
          <prop v="3x:0,0,0,0,0,0" k="average_angle_map_unit_scale"/>
          <prop v="MM" k="average_angle_unit"/>
          <prop v="3" k="interval"/>
          <prop v="3x:0,0,0,0,0,0" k="interval_map_unit_scale"/>
          <prop v="MM" k="interval_unit"/>
          <prop v="0" k="offset"/>
          <prop v="0" k="offset_along_line"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_along_line_map_unit_scale"/>
          <prop v="MM" k="offset_along_line_unit"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="centralpoint" k="placement"/>
          <prop v="0" k="ring_filter"/>
          <prop v="1" k="rotate"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option type="Map" name="properties">
                <Option type="Map" name="outlineWidth">
                  <Option type="bool" value="true" name="active"/>
                  <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                  <Option type="int" value="3" name="type"/>
                </Option>
              </Option>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@5@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="255,127,0,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="filled_arrowhead" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="0,0,0,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="0.36" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option type="Map" name="properties">
                    <Option type="Map" name="size">
                      <Option type="bool" value="true" name="active"/>
                      <Option type="QString" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" name="expression"/>
                      <Option type="int" value="3" name="type"/>
                    </Option>
                  </Option>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fontCapitals="0" textColor="0,0,0,255" fontItalic="0" fontStrikeout="0" fontWordSpacing="0" fontSize="8.25" fontWeight="50" fontSizeMapUnitScale="3x:0,0,0,0,0,0" useSubstitutions="0" fontUnderline="0" textOrientation="horizontal" fontKerning="1" textOpacity="1" fontLetterSpacing="0" isExpression="0" namedStyle="Normal" fontSizeUnit="Point" multilineHeight="1" fontFamily="MS Shell Dlg 2" fieldName="arccat_id" previewBkgrdColor="255,255,255,255" blendMode="0">
        <text-buffer bufferSize="1" bufferOpacity="1" bufferNoFill="0" bufferDraw="0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferJoinStyle="128"/>
        <background shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeSizeY="0" shapeOpacity="1" shapeRotation="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeOffsetX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeRadiiY="0" shapeSizeX="0" shapeRadiiUnit="MM" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderWidth="0" shapeSizeUnit="MM" shapeSizeType="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeRotationType="0" shapeSVGFile="" shapeOffsetUnit="MM" shapeType="0" shapeBorderWidthUnit="MM"/>
        <shadow shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowUnder="0" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255" shadowRadius="1.5" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowRadiusUnit="MM" shadowOpacity="0.7" shadowScale="100" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowDraw="0" shadowBlendMode="6"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format autoWrapLength="0" rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0" decimals="3" wrapChar="" reverseDirectionSymbol="0" plussign="0" leftDirectionSymbol="&lt;" multilineAlign="4294967295" addDirectionSymbol="0" formatNumbers="0"/>
      <placement centroidWhole="0" offsetType="0" layerType="UnknownGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" preserveRotation="1" maxCurvedCharAngleIn="25" placementFlags="10" centroidInside="0" distUnits="MM" priority="5" overrunDistanceUnit="MM" yOffset="0" maxCurvedCharAngleOut="-25" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MapUnit" geometryGenerator="" overrunDistance="0" rotationAngle="0" geometryGeneratorEnabled="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" dist="0" placement="2" fitInPolygonOnly="0" repeatDistanceUnits="MM" distMapUnitScale="3x:0,0,0,0,0,0" xOffset="0" repeatDistance="0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" geometryGeneratorType="PointGeometry"/>
      <rendering obstacleFactor="1" obstacleType="0" obstacle="1" drawLabels="1" scaleVisibility="1" zIndex="0" limitNumLabels="0" maxNumLabels="2000" scaleMax="1000" labelPerPart="0" fontMinPixelSize="3" minFeatureSize="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" scaleMin="1" displayAll="0" mergeLines="0" upsidedownLabels="0"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" value="" name="name"/>
          <Option name="properties"/>
          <Option type="QString" value="collection" name="type"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
          <Option type="bool" value="false" name="drawToAllParts"/>
          <Option type="QString" value="0" name="enabled"/>
          <Option type="QString" value="&lt;symbol force_rhr=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; name=&quot;symbol&quot;>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;prop v=&quot;square&quot; k=&quot;capstyle&quot;/>&lt;prop v=&quot;5;2&quot; k=&quot;customdash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;customdash_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;customdash_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;draw_inside_polygon&quot;/>&lt;prop v=&quot;bevel&quot; k=&quot;joinstyle&quot;/>&lt;prop v=&quot;60,60,60,255&quot; k=&quot;line_color&quot;/>&lt;prop v=&quot;solid&quot; k=&quot;line_style&quot;/>&lt;prop v=&quot;0.3&quot; k=&quot;line_width&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;line_width_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;offset&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;offset_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;offset_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;ring_filter&quot;/>&lt;prop v=&quot;0&quot; k=&quot;use_custom_dash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;width_map_unit_scale&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
          <Option type="double" value="0" name="minLength"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
          <Option type="QString" value="MM" name="minLengthUnit"/>
          <Option type="double" value="0" name="offsetFromAnchor"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
          <Option type="double" value="0" name="offsetFromLabel"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <customproperties>
    <property value="COALESCE( &quot;descript&quot;, '&lt;NULL>' )" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Pie">
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" rotationOffset="270" height="15" barWidth="5" minimumSize="0" minScaleDenominator="100000" sizeScale="3x:0,0,0,0,0,0" backgroundColor="#ffffff" diagramOrientation="Up" maxScaleDenominator="1e+08" lineSizeType="MM" penWidth="0" penAlpha="255" width="15" scaleBasedVisibility="0" backgroundAlpha="255" sizeType="MM" penColor="#000000" enabled="0" opacity="1" scaleDependency="Area" labelPlacementMethod="XHeight">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute field="" color="#000000" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings priority="0" obstacle="0" dist="0" linePlacementFlags="2" zIndex="0" showAll="1" placement="2">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option type="Map" name="properties">
          <Option type="Map" name="show">
            <Option type="bool" value="true" name="active"/>
            <Option type="QString" value="arc_id" name="field"/>
            <Option type="int" value="2" name="type"/>
          </Option>
        </Option>
        <Option type="QString" value="collection" name="type"/>
      </Option>
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
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="node_1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodetype_1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="y1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_y1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elev1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_elev1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_elev1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_y1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="r1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="z1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="node_2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodetype_2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="y2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_y2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elev2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_elev2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_elev2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_y2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="r2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="z2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="slope">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arc_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="CONDUIT" name="CONDUIT"/>
              <Option type="QString" value="PUMP_PIPE" name="PUMP_PIPE"/>
              <Option type="QString" value="SIPHON" name="SIPHON"/>
              <Option type="QString" value="VARC" name="VARC"/>
              <Option type="QString" value="WACCEL" name="WACCEL"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arccat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="matcat_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_shape">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_geom1">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_geom2">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="width">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="epa_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="CONDUIT" name="CONDUIT"/>
              <Option type="QString" value="NOT DEFINED" name="NOT DEFINED"/>
              <Option type="QString" value="ORIFICE" name="ORIFICE"/>
              <Option type="QString" value="OUTLET" name="OUTLET"/>
              <Option type="QString" value="PUMP" name="PUMP"/>
              <Option type="QString" value="VIRTUAL" name="VIRTUAL"/>
              <Option type="QString" value="WEIR" name="WEIR"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="expl_01"/>
              <Option type="QString" value="2" name="expl_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="sector_01"/>
              <Option type="QString" value="2" name="sector_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="0" name="OBSOLETE"/>
              <Option type="QString" value="1" name="ON_SERVICE"/>
              <Option type="QString" value="2" name="PLANIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="95" name="CANCELED FICTICIOUS"/>
              <Option type="QString" value="96" name="CANCELED PLANIFIED"/>
              <Option type="QString" value="97" name="DONE FICTICIOUS"/>
              <Option type="QString" value="98" name="DONE PLANIFIED"/>
              <Option type="QString" value="99" name="FICTICIUS"/>
              <Option type="QString" value="1" name="OBSOLETE"/>
              <Option type="QString" value="2" name="ON_SERVICE"/>
              <Option type="QString" value="3" name="PLANIFIED"/>
              <Option type="QString" value="5" name="PROVISIONAL"/>
              <Option type="QString" value="4" name="RECONSTRUCT"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gis_length">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_length">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inverted_slope">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="dma_01"/>
              <Option type="QString" value="3" name="dma_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="soil1" name="soil1"/>
              <Option type="QString" value="soil2" name="soil2"/>
              <Option type="QString" value="soil3" name="soil3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Function" name="St. Function"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Category" name="St. Category"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Fluid" name="St. Fluid"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Location" name="St. Location"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="builder1" name="builder1"/>
              <Option type="QString" value="builder2" name="builder2"/>
              <Option type="QString" value="builder3" name="builder3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="owner1" name="owner1"/>
              <Option type="QString" value="owner2" name="owner2"/>
              <Option type="QString" value="owner3" name="owner3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="Sant Boi del Llobregat"/>
              <Option type="QString" value="2" name="Sant Esteve de les Roures"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="streetname">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="TO REVIEW" name="TO REVIEW"/>
              <Option type="QString" value="VERIFIED" name="VERIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_x">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="uncertain">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="insert_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="arc_id" index="0" name="arc_id"/>
    <alias field="code" index="1" name="code"/>
    <alias field="node_1" index="2" name="node_1"/>
    <alias field="nodetype_1" index="3" name=""/>
    <alias field="y1" index="4" name="y1"/>
    <alias field="custom_y1" index="5" name="custom_y1"/>
    <alias field="elev1" index="6" name="elev1"/>
    <alias field="custom_elev1" index="7" name="custom_elev1"/>
    <alias field="sys_elev1" index="8" name="sys_elev1"/>
    <alias field="sys_y1" index="9" name="sys_y1"/>
    <alias field="r1" index="10" name="r1"/>
    <alias field="z1" index="11" name="z1"/>
    <alias field="node_2" index="12" name="node_2"/>
    <alias field="nodetype_2" index="13" name=""/>
    <alias field="y2" index="14" name="y2"/>
    <alias field="custom_y2" index="15" name="custom_y2"/>
    <alias field="elev2" index="16" name="elev2"/>
    <alias field="custom_elev2" index="17" name="custom_elev2"/>
    <alias field="sys_elev2" index="18" name="sys_elev2"/>
    <alias field="sys_y2" index="19" name="sys_y2"/>
    <alias field="r2" index="20" name="r2"/>
    <alias field="z2" index="21" name="z2"/>
    <alias field="slope" index="22" name="slope"/>
    <alias field="arc_type" index="23" name="arc_type"/>
    <alias field="sys_type" index="24" name=""/>
    <alias field="arccat_id" index="25" name="arccat_id"/>
    <alias field="matcat_id" index="26" name="matcat_id"/>
    <alias field="cat_shape" index="27" name="cat_shape"/>
    <alias field="cat_geom1" index="28" name="cat_geom1"/>
    <alias field="cat_geom2" index="29" name="cat_geom2"/>
    <alias field="width" index="30" name=""/>
    <alias field="epa_type" index="31" name="epa_type"/>
    <alias field="expl_id" index="32" name="expl_id"/>
    <alias field="macroexpl_id" index="33" name="Macroexploitation"/>
    <alias field="sector_id" index="34" name="sector_id"/>
    <alias field="macrosector_id" index="35" name="macrosector_id"/>
    <alias field="state" index="36" name="state"/>
    <alias field="state_type" index="37" name="state_type"/>
    <alias field="annotation" index="38" name="annotation"/>
    <alias field="gis_length" index="39" name="gis_length"/>
    <alias field="custom_length" index="40" name="custom_length"/>
    <alias field="inverted_slope" index="41" name="inverted_slope"/>
    <alias field="observ" index="42" name="observ"/>
    <alias field="comment" index="43" name="comment"/>
    <alias field="dma_id" index="44" name="dma_id"/>
    <alias field="macrodma_id" index="45" name="macrodma_id"/>
    <alias field="soilcat_id" index="46" name="soilcat_id"/>
    <alias field="function_type" index="47" name="function_type"/>
    <alias field="category_type" index="48" name="category_type"/>
    <alias field="fluid_type" index="49" name="fluid_type"/>
    <alias field="location_type" index="50" name="location_type"/>
    <alias field="workcat_id" index="51" name="workcat_id"/>
    <alias field="workcat_id_end" index="52" name="workcat_id_end"/>
    <alias field="builtdate" index="53" name="builtdate"/>
    <alias field="enddate" index="54" name="enddate"/>
    <alias field="buildercat_id" index="55" name="buildercat_id"/>
    <alias field="ownercat_id" index="56" name="ownercat_id"/>
    <alias field="muni_id" index="57" name="muni_id"/>
    <alias field="postcode" index="58" name="postcode"/>
    <alias field="district_id" index="59" name=""/>
    <alias field="streetname" index="60" name="streetname"/>
    <alias field="postnumber" index="61" name="postnumber"/>
    <alias field="postcomplement" index="62" name="postcomplement"/>
    <alias field="streetname2" index="63" name="streetname2"/>
    <alias field="postnumber2" index="64" name="postnumber2"/>
    <alias field="postcomplement2" index="65" name="postcomplement2"/>
    <alias field="descript" index="66" name="descript"/>
    <alias field="link" index="67" name="link"/>
    <alias field="verified" index="68" name="verified"/>
    <alias field="undelete" index="69" name="undelete"/>
    <alias field="label" index="70" name="Catalog label"/>
    <alias field="label_x" index="71" name="label_x"/>
    <alias field="label_y" index="72" name="label_y"/>
    <alias field="label_rotation" index="73" name="label_rotation"/>
    <alias field="publish" index="74" name="publish"/>
    <alias field="inventory" index="75" name="inventory"/>
    <alias field="uncertain" index="76" name="uncertain"/>
    <alias field="num_value" index="77" name="num_value"/>
    <alias field="tstamp" index="78" name="Insert tstamp"/>
    <alias field="insert_user" index="79" name=""/>
    <alias field="lastupdate" index="80" name="Last update"/>
    <alias field="lastupdate_user" index="81" name="Last update user"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="arc_id" expression="" applyOnUpdate="0"/>
    <default field="code" expression="" applyOnUpdate="0"/>
    <default field="node_1" expression="" applyOnUpdate="0"/>
    <default field="nodetype_1" expression="" applyOnUpdate="0"/>
    <default field="y1" expression="" applyOnUpdate="0"/>
    <default field="custom_y1" expression="" applyOnUpdate="0"/>
    <default field="elev1" expression="" applyOnUpdate="0"/>
    <default field="custom_elev1" expression="" applyOnUpdate="0"/>
    <default field="sys_elev1" expression="" applyOnUpdate="0"/>
    <default field="sys_y1" expression="" applyOnUpdate="0"/>
    <default field="r1" expression="" applyOnUpdate="0"/>
    <default field="z1" expression="" applyOnUpdate="0"/>
    <default field="node_2" expression="" applyOnUpdate="0"/>
    <default field="nodetype_2" expression="" applyOnUpdate="0"/>
    <default field="y2" expression="" applyOnUpdate="0"/>
    <default field="custom_y2" expression="" applyOnUpdate="0"/>
    <default field="elev2" expression="" applyOnUpdate="0"/>
    <default field="custom_elev2" expression="" applyOnUpdate="0"/>
    <default field="sys_elev2" expression="" applyOnUpdate="0"/>
    <default field="sys_y2" expression="" applyOnUpdate="0"/>
    <default field="r2" expression="" applyOnUpdate="0"/>
    <default field="z2" expression="" applyOnUpdate="0"/>
    <default field="slope" expression="" applyOnUpdate="0"/>
    <default field="arc_type" expression="" applyOnUpdate="0"/>
    <default field="sys_type" expression="" applyOnUpdate="0"/>
    <default field="arccat_id" expression="" applyOnUpdate="0"/>
    <default field="matcat_id" expression="" applyOnUpdate="0"/>
    <default field="cat_shape" expression="" applyOnUpdate="0"/>
    <default field="cat_geom1" expression="" applyOnUpdate="0"/>
    <default field="cat_geom2" expression="" applyOnUpdate="0"/>
    <default field="width" expression="" applyOnUpdate="0"/>
    <default field="epa_type" expression="" applyOnUpdate="0"/>
    <default field="expl_id" expression="" applyOnUpdate="0"/>
    <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
    <default field="sector_id" expression="" applyOnUpdate="0"/>
    <default field="macrosector_id" expression="" applyOnUpdate="0"/>
    <default field="state" expression="" applyOnUpdate="0"/>
    <default field="state_type" expression="" applyOnUpdate="0"/>
    <default field="annotation" expression="" applyOnUpdate="0"/>
    <default field="gis_length" expression="" applyOnUpdate="0"/>
    <default field="custom_length" expression="" applyOnUpdate="0"/>
    <default field="inverted_slope" expression="" applyOnUpdate="0"/>
    <default field="observ" expression="" applyOnUpdate="0"/>
    <default field="comment" expression="" applyOnUpdate="0"/>
    <default field="dma_id" expression="" applyOnUpdate="0"/>
    <default field="macrodma_id" expression="" applyOnUpdate="0"/>
    <default field="soilcat_id" expression="" applyOnUpdate="0"/>
    <default field="function_type" expression="" applyOnUpdate="0"/>
    <default field="category_type" expression="" applyOnUpdate="0"/>
    <default field="fluid_type" expression="" applyOnUpdate="0"/>
    <default field="location_type" expression="" applyOnUpdate="0"/>
    <default field="workcat_id" expression="" applyOnUpdate="0"/>
    <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
    <default field="builtdate" expression="" applyOnUpdate="0"/>
    <default field="enddate" expression="" applyOnUpdate="0"/>
    <default field="buildercat_id" expression="" applyOnUpdate="0"/>
    <default field="ownercat_id" expression="" applyOnUpdate="0"/>
    <default field="muni_id" expression="" applyOnUpdate="0"/>
    <default field="postcode" expression="" applyOnUpdate="0"/>
    <default field="district_id" expression="" applyOnUpdate="0"/>
    <default field="streetname" expression="" applyOnUpdate="0"/>
    <default field="postnumber" expression="" applyOnUpdate="0"/>
    <default field="postcomplement" expression="" applyOnUpdate="0"/>
    <default field="streetname2" expression="" applyOnUpdate="0"/>
    <default field="postnumber2" expression="" applyOnUpdate="0"/>
    <default field="postcomplement2" expression="" applyOnUpdate="0"/>
    <default field="descript" expression="" applyOnUpdate="0"/>
    <default field="link" expression="" applyOnUpdate="0"/>
    <default field="verified" expression="" applyOnUpdate="0"/>
    <default field="undelete" expression="" applyOnUpdate="0"/>
    <default field="label" expression="" applyOnUpdate="0"/>
    <default field="label_x" expression="" applyOnUpdate="0"/>
    <default field="label_y" expression="" applyOnUpdate="0"/>
    <default field="label_rotation" expression="" applyOnUpdate="0"/>
    <default field="publish" expression="" applyOnUpdate="0"/>
    <default field="inventory" expression="" applyOnUpdate="0"/>
    <default field="uncertain" expression="" applyOnUpdate="0"/>
    <default field="num_value" expression="" applyOnUpdate="0"/>
    <default field="tstamp" expression="" applyOnUpdate="0"/>
    <default field="insert_user" expression="" applyOnUpdate="0"/>
    <default field="lastupdate" expression="" applyOnUpdate="0"/>
    <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" field="arc_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="code" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="node_1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="nodetype_1" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="y1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_y1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="elev1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_elev1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_elev1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_y1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="r1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="z1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="node_2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="nodetype_2" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="y2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_y2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="elev2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_elev2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_elev2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_y2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="r2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="z2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="slope" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="arc_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="sys_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="arccat_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="matcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="cat_shape" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="cat_geom1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="cat_geom2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="width" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="epa_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="expl_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="macroexpl_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrosector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="annotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="gis_length" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_length" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="inverted_slope" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="observ" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="comment" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="dma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrodma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="soilcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="function_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="category_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="fluid_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="location_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id_end" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="builtdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="enddate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="buildercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="ownercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="muni_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcode" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="district_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="descript" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="link" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="verified" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="undelete" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_x" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_y" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="publish" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="inventory" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="uncertain" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="num_value" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="tstamp" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="insert_user" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate_user" notnull_strength="2" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="arc_id" desc="" exp=""/>
    <constraint field="code" desc="" exp=""/>
    <constraint field="node_1" desc="" exp=""/>
    <constraint field="nodetype_1" desc="" exp=""/>
    <constraint field="y1" desc="" exp=""/>
    <constraint field="custom_y1" desc="" exp=""/>
    <constraint field="elev1" desc="" exp=""/>
    <constraint field="custom_elev1" desc="" exp=""/>
    <constraint field="sys_elev1" desc="" exp=""/>
    <constraint field="sys_y1" desc="" exp=""/>
    <constraint field="r1" desc="" exp=""/>
    <constraint field="z1" desc="" exp=""/>
    <constraint field="node_2" desc="" exp=""/>
    <constraint field="nodetype_2" desc="" exp=""/>
    <constraint field="y2" desc="" exp=""/>
    <constraint field="custom_y2" desc="" exp=""/>
    <constraint field="elev2" desc="" exp=""/>
    <constraint field="custom_elev2" desc="" exp=""/>
    <constraint field="sys_elev2" desc="" exp=""/>
    <constraint field="sys_y2" desc="" exp=""/>
    <constraint field="r2" desc="" exp=""/>
    <constraint field="z2" desc="" exp=""/>
    <constraint field="slope" desc="" exp=""/>
    <constraint field="arc_type" desc="" exp=""/>
    <constraint field="sys_type" desc="" exp=""/>
    <constraint field="arccat_id" desc="" exp=""/>
    <constraint field="matcat_id" desc="" exp=""/>
    <constraint field="cat_shape" desc="" exp=""/>
    <constraint field="cat_geom1" desc="" exp=""/>
    <constraint field="cat_geom2" desc="" exp=""/>
    <constraint field="width" desc="" exp=""/>
    <constraint field="epa_type" desc="" exp=""/>
    <constraint field="expl_id" desc="" exp=""/>
    <constraint field="macroexpl_id" desc="" exp=""/>
    <constraint field="sector_id" desc="" exp=""/>
    <constraint field="macrosector_id" desc="" exp=""/>
    <constraint field="state" desc="" exp=""/>
    <constraint field="state_type" desc="" exp=""/>
    <constraint field="annotation" desc="" exp=""/>
    <constraint field="gis_length" desc="" exp=""/>
    <constraint field="custom_length" desc="" exp=""/>
    <constraint field="inverted_slope" desc="" exp=""/>
    <constraint field="observ" desc="" exp=""/>
    <constraint field="comment" desc="" exp=""/>
    <constraint field="dma_id" desc="" exp=""/>
    <constraint field="macrodma_id" desc="" exp=""/>
    <constraint field="soilcat_id" desc="" exp=""/>
    <constraint field="function_type" desc="" exp=""/>
    <constraint field="category_type" desc="" exp=""/>
    <constraint field="fluid_type" desc="" exp=""/>
    <constraint field="location_type" desc="" exp=""/>
    <constraint field="workcat_id" desc="" exp=""/>
    <constraint field="workcat_id_end" desc="" exp=""/>
    <constraint field="builtdate" desc="" exp=""/>
    <constraint field="enddate" desc="" exp=""/>
    <constraint field="buildercat_id" desc="" exp=""/>
    <constraint field="ownercat_id" desc="" exp=""/>
    <constraint field="muni_id" desc="" exp=""/>
    <constraint field="postcode" desc="" exp=""/>
    <constraint field="district_id" desc="" exp=""/>
    <constraint field="streetname" desc="" exp=""/>
    <constraint field="postnumber" desc="" exp=""/>
    <constraint field="postcomplement" desc="" exp=""/>
    <constraint field="streetname2" desc="" exp=""/>
    <constraint field="postnumber2" desc="" exp=""/>
    <constraint field="postcomplement2" desc="" exp=""/>
    <constraint field="descript" desc="" exp=""/>
    <constraint field="link" desc="" exp=""/>
    <constraint field="verified" desc="" exp=""/>
    <constraint field="undelete" desc="" exp=""/>
    <constraint field="label" desc="" exp=""/>
    <constraint field="label_x" desc="" exp=""/>
    <constraint field="label_y" desc="" exp=""/>
    <constraint field="label_rotation" desc="" exp=""/>
    <constraint field="publish" desc="" exp=""/>
    <constraint field="inventory" desc="" exp=""/>
    <constraint field="uncertain" desc="" exp=""/>
    <constraint field="num_value" desc="" exp=""/>
    <constraint field="tstamp" desc="" exp=""/>
    <constraint field="insert_user" desc="" exp=""/>
    <constraint field="lastupdate" desc="" exp=""/>
    <constraint field="lastupdate_user" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="1" sortExpression="&quot;arc_type&quot;">
    <columns>
      <column type="field" hidden="0" name="arc_id" width="-1"/>
      <column type="field" hidden="0" name="code" width="-1"/>
      <column type="field" hidden="0" name="node_1" width="-1"/>
      <column type="field" hidden="0" name="node_2" width="-1"/>
      <column type="field" hidden="0" name="y1" width="-1"/>
      <column type="field" hidden="0" name="custom_y1" width="-1"/>
      <column type="field" hidden="1" name="elev1" width="-1"/>
      <column type="field" hidden="0" name="custom_elev1" width="-1"/>
      <column type="field" hidden="0" name="sys_elev1" width="-1"/>
      <column type="field" hidden="0" name="y2" width="-1"/>
      <column type="field" hidden="1" name="elev2" width="-1"/>
      <column type="field" hidden="0" name="custom_y2" width="-1"/>
      <column type="field" hidden="0" name="custom_elev2" width="-1"/>
      <column type="field" hidden="0" name="sys_elev2" width="-1"/>
      <column type="field" hidden="1" name="z1" width="-1"/>
      <column type="field" hidden="1" name="z2" width="-1"/>
      <column type="field" hidden="0" name="r1" width="-1"/>
      <column type="field" hidden="0" name="r2" width="-1"/>
      <column type="field" hidden="0" name="slope" width="-1"/>
      <column type="field" hidden="0" name="arc_type" width="-1"/>
      <column type="field" hidden="0" name="arccat_id" width="-1"/>
      <column type="field" hidden="0" name="gis_length" width="-1"/>
      <column type="field" hidden="0" name="epa_type" width="-1"/>
      <column type="field" hidden="0" name="sector_id" width="-1"/>
      <column type="field" hidden="1" name="macrosector_id" width="-1"/>
      <column type="field" hidden="0" name="state" width="-1"/>
      <column type="field" hidden="0" name="state_type" width="-1"/>
      <column type="field" hidden="0" name="annotation" width="-1"/>
      <column type="field" hidden="0" name="observ" width="-1"/>
      <column type="field" hidden="1" name="comment" width="-1"/>
      <column type="field" hidden="0" name="inverted_slope" width="-1"/>
      <column type="field" hidden="1" name="custom_length" width="-1"/>
      <column type="field" hidden="0" name="dma_id" width="-1"/>
      <column type="field" hidden="0" name="soilcat_id" width="-1"/>
      <column type="field" hidden="0" name="function_type" width="-1"/>
      <column type="field" hidden="0" name="category_type" width="149"/>
      <column type="field" hidden="0" name="fluid_type" width="-1"/>
      <column type="field" hidden="0" name="location_type" width="147"/>
      <column type="field" hidden="0" name="workcat_id" width="-1"/>
      <column type="field" hidden="0" name="workcat_id_end" width="-1"/>
      <column type="field" hidden="1" name="buildercat_id" width="-1"/>
      <column type="field" hidden="0" name="builtdate" width="-1"/>
      <column type="field" hidden="0" name="enddate" width="-1"/>
      <column type="field" hidden="0" name="ownercat_id" width="-1"/>
      <column type="field" hidden="0" name="muni_id" width="-1"/>
      <column type="field" hidden="0" name="postcode" width="-1"/>
      <column type="field" hidden="0" name="streetaxis_id" width="206"/>
      <column type="field" hidden="0" name="postnumber" width="-1"/>
      <column type="field" hidden="0" name="postcomplement" width="-1"/>
      <column type="field" hidden="0" name="postcomplement2" width="-1"/>
      <column type="field" hidden="0" name="streetaxis2_id" width="-1"/>
      <column type="field" hidden="0" name="postnumber2" width="-1"/>
      <column type="field" hidden="0" name="descript" width="-1"/>
      <column type="field" hidden="0" name="link" width="-1"/>
      <column type="field" hidden="0" name="verified" width="-1"/>
      <column type="field" hidden="1" name="undelete" width="-1"/>
      <column type="field" hidden="0" name="label_x" width="-1"/>
      <column type="field" hidden="0" name="label_y" width="-1"/>
      <column type="field" hidden="0" name="label_rotation" width="-1"/>
      <column type="field" hidden="1" name="publish" width="-1"/>
      <column type="field" hidden="1" name="inventory" width="-1"/>
      <column type="field" hidden="0" name="uncertain" width="-1"/>
      <column type="field" hidden="1" name="macrodma_id" width="-1"/>
      <column type="field" hidden="0" name="expl_id" width="-1"/>
      <column type="field" hidden="1" name="num_value" width="-1"/>
      <column type="actions" hidden="1" width="-1"/>
      <column type="field" hidden="0" name="cat_geom1" width="-1"/>
      <column type="field" hidden="0" name="cat_geom2" width="-1"/>
      <column type="field" hidden="0" name="sys_y1" width="-1"/>
      <column type="field" hidden="0" name="sys_y2" width="-1"/>
      <column type="field" hidden="0" name="sys_type" width="-1"/>
      <column type="field" hidden="1" name="cat_matcat_id" width="-1"/>
      <column type="field" hidden="0" name="cat_shape" width="-1"/>
      <column type="field" hidden="0" name="label" width="-1"/>
      <column type="field" hidden="0" name="nodetype_1" width="-1"/>
      <column type="field" hidden="0" name="nodetype_2" width="-1"/>
      <column type="field" hidden="0" name="lastupdate" width="-1"/>
      <column type="field" hidden="0" name="lastupdate_user" width="-1"/>
      <column type="field" hidden="0" name="insert_user" width="-1"/>
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
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from PyQt4.QtGui import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="annotation"/>
    <field editable="1" name="arc_id"/>
    <field editable="0" name="arc_type"/>
    <field editable="1" name="arccat_id"/>
    <field editable="1" name="buildercat_id"/>
    <field editable="1" name="builtdate"/>
    <field editable="0" name="cat_geom1"/>
    <field editable="0" name="cat_geom2"/>
    <field editable="0" name="cat_matcat_id"/>
    <field editable="0" name="cat_shape"/>
    <field editable="1" name="category_type"/>
    <field editable="1" name="code"/>
    <field editable="1" name="comment"/>
    <field editable="1" name="custom_elev1"/>
    <field editable="1" name="custom_elev2"/>
    <field editable="1" name="custom_length"/>
    <field editable="1" name="custom_y1"/>
    <field editable="1" name="custom_y2"/>
    <field editable="1" name="descript"/>
    <field editable="1" name="dma_id"/>
    <field editable="1" name="elev1"/>
    <field editable="1" name="elev2"/>
    <field editable="1" name="enddate"/>
    <field editable="1" name="epa_type"/>
    <field editable="1" name="expl_id"/>
    <field editable="1" name="fluid_type"/>
    <field editable="1" name="function_type"/>
    <field editable="0" name="gis_length"/>
    <field editable="1" name="insert_user"/>
    <field editable="1" name="inventory"/>
    <field editable="1" name="inverted_slope"/>
    <field editable="0" name="label"/>
    <field editable="1" name="label_rotation"/>
    <field editable="1" name="label_x"/>
    <field editable="1" name="label_y"/>
    <field editable="0" name="lastupdate"/>
    <field editable="0" name="lastupdate_user"/>
    <field editable="0" name="link"/>
    <field editable="1" name="location_type"/>
    <field editable="1" name="macrodma_id"/>
    <field editable="1" name="macroexpl_id"/>
    <field editable="0" name="macrosector_id"/>
    <field editable="0" name="matcat_id"/>
    <field editable="1" name="muni_id"/>
    <field editable="1" name="node_1"/>
    <field editable="1" name="node_2"/>
    <field editable="1" name="nodetype_1"/>
    <field editable="1" name="nodetype_2"/>
    <field editable="1" name="num_value"/>
    <field editable="1" name="observ"/>
    <field editable="1" name="ownercat_id"/>
    <field editable="1" name="postcode"/>
    <field editable="1" name="postcomplement"/>
    <field editable="1" name="postcomplement2"/>
    <field editable="1" name="postnumber"/>
    <field editable="1" name="postnumber2"/>
    <field editable="1" name="publish"/>
    <field editable="0" name="r1"/>
    <field editable="0" name="r2"/>
    <field editable="1" name="sector_id"/>
    <field editable="0" name="slope"/>
    <field editable="1" name="soilcat_id"/>
    <field editable="1" name="state"/>
    <field editable="1" name="state_type"/>
    <field editable="1" name="streetaxis2_id"/>
    <field editable="1" name="streetaxis_id"/>
    <field editable="1" name="streetname"/>
    <field editable="1" name="streetname2"/>
    <field editable="0" name="sys_elev1"/>
    <field editable="0" name="sys_elev2"/>
    <field editable="1" name="sys_type"/>
    <field editable="0" name="sys_y1"/>
    <field editable="0" name="sys_y2"/>
    <field editable="1" name="tstamp"/>
    <field editable="1" name="uncertain"/>
    <field editable="1" name="undelete"/>
    <field editable="1" name="verified"/>
    <field editable="1" name="workcat_id"/>
    <field editable="1" name="workcat_id_end"/>
    <field editable="1" name="y1"/>
    <field editable="1" name="y2"/>
    <field editable="0" name="z1"/>
    <field editable="0" name="z2"/>
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
    <field name="cat_matcat_id" labelOnTop="0"/>
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
    <field name="macrosector_id" labelOnTop="0"/>
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
    <field name="streetaxis2_id" labelOnTop="0"/>
    <field name="streetaxis_id" labelOnTop="0"/>
    <field name="sys_elev1" labelOnTop="0"/>
    <field name="sys_elev2" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="sys_y1" labelOnTop="0"/>
    <field name="sys_y2" labelOnTop="0"/>
    <field name="uncertain" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
    <field name="y1" labelOnTop="0"/>
    <field name="y2" labelOnTop="0"/>
    <field name="z1" labelOnTop="0"/>
    <field name="z2" labelOnTop="0"/>
  </labelOnTop>
  <widgets>
    <widget name="arc_shape_ok_z1">
      <config/>
    </widget>
    <widget name="arc_shape_ok_z2">
      <config/>
    </widget>
    <widget name="tram_89_angle_rota">
      <config/>
    </widget>
    <widget name="tram_89_arc_id">
      <config/>
    </widget>
    <widget name="tram_89_arc_type">
      <config/>
    </widget>
    <widget name="tram_89_arccat_id">
      <config/>
    </widget>
    <widget name="tram_89_carrer">
      <config/>
    </widget>
    <widget name="tram_89_carrer2">
      <config/>
    </widget>
    <widget name="tram_89_codi_mat">
      <config/>
    </widget>
    <widget name="tram_89_conca">
      <config/>
    </widget>
    <widget name="tram_89_confirmat">
      <config/>
    </widget>
    <widget name="tram_89_cota_1">
      <config/>
    </widget>
    <widget name="tram_89_cota_2">
      <config/>
    </widget>
    <widget name="tram_89_data_alta">
      <config/>
    </widget>
    <widget name="tram_89_data_baixa">
      <config/>
    </widget>
    <widget name="tram_89_data_rev">
      <config/>
    </widget>
    <widget name="tram_89_dim1">
      <config/>
    </widget>
    <widget name="tram_89_dim1b">
      <config/>
    </widget>
    <widget name="tram_89_dim2">
      <config/>
    </widget>
    <widget name="tram_89_dim2b">
      <config/>
    </widget>
    <widget name="tram_89_dim3">
      <config/>
    </widget>
    <widget name="tram_89_dim3b">
      <config/>
    </widget>
    <widget name="tram_89_dim4">
      <config/>
    </widget>
    <widget name="tram_89_dim4b">
      <config/>
    </widget>
    <widget name="tram_89_dma_id">
      <config/>
    </widget>
    <widget name="tram_89_estat">
      <config/>
    </widget>
    <widget name="tram_89_expbaixa">
      <config/>
    </widget>
    <widget name="tram_89_expedient">
      <config/>
    </widget>
    <widget name="tram_89_funcio">
      <config/>
    </widget>
    <widget name="tram_89_id_tram_ad">
      <config/>
    </widget>
    <widget name="tram_89_longitud">
      <config/>
    </widget>
    <widget name="tram_89_material">
      <config/>
    </widget>
    <widget name="tram_89_node_1">
      <config/>
    </widget>
    <widget name="tram_89_node_2">
      <config/>
    </widget>
    <widget name="tram_89_ns_project">
      <config/>
    </widget>
    <widget name="tram_89_obs">
      <config/>
    </widget>
    <widget name="tram_89_ordre">
      <config/>
    </widget>
    <widget name="tram_89_ot_baixa_p">
      <config/>
    </widget>
    <widget name="tram_89_ot_part">
      <config/>
    </widget>
    <widget name="tram_89_pendent">
      <config/>
    </widget>
    <widget name="tram_89_seccio">
      <config/>
    </widget>
    <widget name="tram_89_sectipus">
      <config/>
    </widget>
    <widget name="tram_89_sector">
      <config/>
    </widget>
    <widget name="tram_89_sector_id">
      <config/>
    </widget>
    <widget name="tram_89_subsector">
      <config/>
    </widget>
    <widget name="tram_89_x_etiqueta">
      <config/>
    </widget>
    <widget name="tram_89_y1">
      <config/>
    </widget>
    <widget name="tram_89_y2">
      <config/>
    </widget>
    <widget name="tram_89_y_etiqueta">
      <config/>
    </widget>
  </widgets>
  <previewExpression>COALESCE( "descript", '&lt;NULL>' )</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('102', 'v_edit_connec', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" labelsEnabled="1" simplifyDrawingHints="0" minScale="1500" simplifyLocal="1" simplifyMaxScale="1" maxScale="1" readOnly="0" version="3.10.3-A Coruña" hasScaleBasedVisibilityFlag="1" simplifyAlgorithm="0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" type="singleSymbol" symbollevels="0" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="49,180,227,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="49,180,227,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="255,0,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="cross" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fontCapitals="0" textColor="90,90,90,255" fontItalic="0" fontStrikeout="0" fontWordSpacing="0" fontSize="8" fontWeight="50" fontSizeMapUnitScale="3x:0,0,0,0,0,0" useSubstitutions="0" fontUnderline="0" textOrientation="horizontal" fontKerning="1" textOpacity="1" fontLetterSpacing="0" isExpression="1" namedStyle="Normal" fontSizeUnit="Point" multilineHeight="1" fontFamily="Arial" fieldName="CASE WHEN  label_x =  5 THEN '    ' ||   &quot;connec_id&quot;   &#xa;ELSE   &quot;connec_id&quot;   || '    '  END" previewBkgrdColor="255,255,255,255" blendMode="0">
        <text-buffer bufferSize="1" bufferOpacity="1" bufferNoFill="1" bufferDraw="0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferJoinStyle="128"/>
        <background shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeSizeY="0" shapeOpacity="1" shapeRotation="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeOffsetX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeRadiiY="0" shapeSizeX="0" shapeRadiiUnit="MM" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderWidth="0" shapeSizeUnit="MM" shapeSizeType="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeRotationType="0" shapeSVGFile="" shapeOffsetUnit="MM" shapeType="0" shapeBorderWidthUnit="MM"/>
        <shadow shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowUnder="0" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255" shadowRadius="1.5" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowRadiusUnit="MM" shadowOpacity="0.7" shadowScale="100" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowDraw="0" shadowBlendMode="6"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option type="Map" name="properties">
              <Option type="Map" name="LabelRotation">
                <Option type="bool" value="true" name="active"/>
                <Option type="QString" value="label_rotation" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
              <Option type="Map" name="OffsetQuad">
                <Option type="bool" value="true" name="active"/>
                <Option type="QString" value="label_x" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
              <Option type="Map" name="PositionX">
                <Option type="bool" value="false" name="active"/>
                <Option type="QString" value="num_value" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
              <Option type="Map" name="PositionY">
                <Option type="bool" value="false" name="active"/>
                <Option type="QString" value="num_value" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
            </Option>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format autoWrapLength="0" rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0" decimals="3" wrapChar="" reverseDirectionSymbol="0" plussign="0" leftDirectionSymbol="&lt;" multilineAlign="3" addDirectionSymbol="0" formatNumbers="0"/>
      <placement centroidWhole="0" offsetType="0" layerType="UnknownGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" preserveRotation="0" maxCurvedCharAngleIn="25" placementFlags="10" centroidInside="0" distUnits="MM" priority="5" overrunDistanceUnit="MM" yOffset="0" maxCurvedCharAngleOut="-25" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MM" geometryGenerator="" overrunDistance="0" rotationAngle="0" geometryGeneratorEnabled="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" dist="0" placement="1" fitInPolygonOnly="0" repeatDistanceUnits="MM" distMapUnitScale="3x:0,0,0,0,0,0" xOffset="0" repeatDistance="0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" geometryGeneratorType="PointGeometry"/>
      <rendering obstacleFactor="1" obstacleType="0" obstacle="1" drawLabels="1" scaleVisibility="1" zIndex="0" limitNumLabels="0" maxNumLabels="2000" scaleMax="250" labelPerPart="0" fontMinPixelSize="3" minFeatureSize="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" scaleMin="0" displayAll="0" mergeLines="0" upsidedownLabels="0"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" value="" name="name"/>
          <Option type="Map" name="properties">
            <Option type="Map" name="LabelRotation">
              <Option type="bool" value="true" name="active"/>
              <Option type="QString" value="label_rotation" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
            <Option type="Map" name="OffsetQuad">
              <Option type="bool" value="true" name="active"/>
              <Option type="QString" value="label_x" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
            <Option type="Map" name="PositionX">
              <Option type="bool" value="false" name="active"/>
              <Option type="QString" value="num_value" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
            <Option type="Map" name="PositionY">
              <Option type="bool" value="false" name="active"/>
              <Option type="QString" value="num_value" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
          </Option>
          <Option type="QString" value="collection" name="type"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
          <Option type="bool" value="false" name="drawToAllParts"/>
          <Option type="QString" value="0" name="enabled"/>
          <Option type="QString" value="&lt;symbol force_rhr=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; name=&quot;symbol&quot;>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;prop v=&quot;square&quot; k=&quot;capstyle&quot;/>&lt;prop v=&quot;5;2&quot; k=&quot;customdash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;customdash_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;customdash_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;draw_inside_polygon&quot;/>&lt;prop v=&quot;bevel&quot; k=&quot;joinstyle&quot;/>&lt;prop v=&quot;60,60,60,255&quot; k=&quot;line_color&quot;/>&lt;prop v=&quot;solid&quot; k=&quot;line_style&quot;/>&lt;prop v=&quot;0.3&quot; k=&quot;line_width&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;line_width_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;offset&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;offset_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;offset_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;ring_filter&quot;/>&lt;prop v=&quot;0&quot; k=&quot;use_custom_dash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;width_map_unit_scale&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
          <Option type="double" value="0" name="minLength"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
          <Option type="QString" value="MM" name="minLengthUnit"/>
          <Option type="double" value="0" name="offsetFromAnchor"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
          <Option type="double" value="0" name="offsetFromLabel"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <customproperties>
    <property value="" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <LinearlyInterpolatedDiagramRenderer lowerWidth="0" lowerHeight="0" classificationAttributeExpression="" upperWidth="50" attributeLegend="1" upperValue="0" upperHeight="50" lowerValue="0" diagramType="Histogram">
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" rotationOffset="270" height="15" barWidth="5" minimumSize="0" minScaleDenominator="100000" sizeScale="3x:0,0,0,0,0,0" backgroundColor="#ffffff" diagramOrientation="Up" maxScaleDenominator="1e+08" lineSizeType="MM" penWidth="0" penAlpha="255" width="15" scaleBasedVisibility="0" backgroundAlpha="255" sizeType="MM" penColor="#000000" enabled="0" opacity="1" scaleDependency="Area" labelPlacementMethod="XHeight">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute field="" color="#000000" label=""/>
    </DiagramCategory>
  </LinearlyInterpolatedDiagramRenderer>
  <DiagramLayerSettings priority="0" obstacle="0" dist="0" linePlacementFlags="2" zIndex="0" showAll="1" placement="0">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option type="Map" name="properties">
          <Option type="Map" name="show">
            <Option type="bool" value="true" name="active"/>
            <Option type="QString" value="connec_id" name="field"/>
            <Option type="int" value="2" name="type"/>
          </Option>
        </Option>
        <Option type="QString" value="collection" name="type"/>
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
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="customer_code">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="y1">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="y2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="CONNEC" name="CONNEC"/>
              <Option type="QString" value="VCONNEC" name="VCONNEC"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="private_connecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="matcat_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="expl_01"/>
              <Option type="QString" value="2" name="expl_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="sector_01"/>
              <Option type="QString" value="2" name="sector_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="demand">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="0" name="OBSOLETE"/>
              <Option type="QString" value="1" name="ON_SERVICE"/>
              <Option type="QString" value="2" name="PLANIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="95" name="CANCELED FICTICIOUS"/>
              <Option type="QString" value="96" name="CANCELED PLANIFIED"/>
              <Option type="QString" value="97" name="DONE FICTICIOUS"/>
              <Option type="QString" value="98" name="DONE PLANIFIED"/>
              <Option type="QString" value="99" name="FICTICIUS"/>
              <Option type="QString" value="1" name="OBSOLETE"/>
              <Option type="QString" value="2" name="ON_SERVICE"/>
              <Option type="QString" value="3" name="PLANIFIED"/>
              <Option type="QString" value="5" name="PROVISIONAL"/>
              <Option type="QString" value="4" name="RECONSTRUCT"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_depth">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_length">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arc_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="dma_01"/>
              <Option type="QString" value="3" name="dma_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="soil1" name="soil1"/>
              <Option type="QString" value="soil2" name="soil2"/>
              <Option type="QString" value="soil3" name="soil3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Function" name="St. Function"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Category" name="St. Category"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Fluid" name="St. Fluid"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Location" name="St. Location"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="builder1" name="builder1"/>
              <Option type="QString" value="builder2" name="builder2"/>
              <Option type="QString" value="builder3" name="builder3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="owner1" name="owner1"/>
              <Option type="QString" value="owner2" name="owner2"/>
              <Option type="QString" value="owner3" name="owner3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="Sant Boi del Llobregat"/>
              <Option type="QString" value="2" name="Sant Esteve de les Roures"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="streetname">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="svg">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="TO REVIEW" name="TO REVIEW"/>
              <Option type="QString" value="VERIFIED" name="VERIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_x">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="accessibility">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="diagonal">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="uncertain">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="featurecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pjoint_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pjoint_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="insert_user">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="connec_id" index="0" name="connec_id"/>
    <alias field="code" index="1" name="code"/>
    <alias field="customer_code" index="2" name="customer_code"/>
    <alias field="top_elev" index="3" name="top_elev"/>
    <alias field="y1" index="4" name="y1"/>
    <alias field="y2" index="5" name="y2"/>
    <alias field="connecat_id" index="6" name="connecat_id"/>
    <alias field="connec_type" index="7" name="connec_type"/>
    <alias field="sys_type" index="8" name=""/>
    <alias field="private_connecat_id" index="9" name="private_connecat_id"/>
    <alias field="matcat_id" index="10" name="matcat_id"/>
    <alias field="expl_id" index="11" name="expl_id"/>
    <alias field="macroexpl_id" index="12" name="Macroexploitation"/>
    <alias field="sector_id" index="13" name="sector_id"/>
    <alias field="macrosector_id" index="14" name="macrosector_id"/>
    <alias field="demand" index="15" name="demand"/>
    <alias field="state" index="16" name="state"/>
    <alias field="state_type" index="17" name="state_type"/>
    <alias field="connec_depth" index="18" name="connec_depth"/>
    <alias field="connec_length" index="19" name="connec_length"/>
    <alias field="arc_id" index="20" name="arc_id"/>
    <alias field="annotation" index="21" name="annotation"/>
    <alias field="observ" index="22" name="observ"/>
    <alias field="comment" index="23" name="comment"/>
    <alias field="dma_id" index="24" name="dma_id"/>
    <alias field="macrodma_id" index="25" name="macrodma_id"/>
    <alias field="soilcat_id" index="26" name="soilcat_id"/>
    <alias field="function_type" index="27" name="function_type"/>
    <alias field="category_type" index="28" name="category_type"/>
    <alias field="fluid_type" index="29" name="fluid_type"/>
    <alias field="location_type" index="30" name="location_type"/>
    <alias field="workcat_id" index="31" name="workcat_id"/>
    <alias field="workcat_id_end" index="32" name="workcat_id_end"/>
    <alias field="buildercat_id" index="33" name="buildercat_id"/>
    <alias field="builtdate" index="34" name="builtdate"/>
    <alias field="enddate" index="35" name="enddate"/>
    <alias field="ownercat_id" index="36" name="ownercat_id"/>
    <alias field="muni_id" index="37" name="muni_id"/>
    <alias field="postcode" index="38" name="postcode"/>
    <alias field="district_id" index="39" name=""/>
    <alias field="streetname" index="40" name="streetname"/>
    <alias field="postnumber" index="41" name="postnumber"/>
    <alias field="postcomplement" index="42" name="postcomplement"/>
    <alias field="streetname2" index="43" name="streetname2"/>
    <alias field="postnumber2" index="44" name="postnumber2"/>
    <alias field="postcomplement2" index="45" name="postcomplement2"/>
    <alias field="descript" index="46" name="descript"/>
    <alias field="svg" index="47" name="svg"/>
    <alias field="rotation" index="48" name="rotation"/>
    <alias field="link" index="49" name="link"/>
    <alias field="verified" index="50" name="verified"/>
    <alias field="undelete" index="51" name="undelete"/>
    <alias field="label" index="52" name="Catalog label"/>
    <alias field="label_x" index="53" name="label_x"/>
    <alias field="label_y" index="54" name="label_y"/>
    <alias field="label_rotation" index="55" name="label_rotation"/>
    <alias field="accessibility" index="56" name="accessibility"/>
    <alias field="diagonal" index="57" name="diagonal"/>
    <alias field="publish" index="58" name="publish"/>
    <alias field="inventory" index="59" name="inventory"/>
    <alias field="uncertain" index="60" name="uncertain"/>
    <alias field="num_value" index="61" name="num_value"/>
    <alias field="feature_id" index="62" name="feature_id"/>
    <alias field="featurecat_id" index="63" name="featurecat_id"/>
    <alias field="pjoint_id" index="64" name="pjoint_id"/>
    <alias field="pjoint_type" index="65" name="pjoint_type"/>
    <alias field="tstamp" index="66" name="Insert tstamp"/>
    <alias field="insert_user" index="67" name=""/>
    <alias field="lastupdate" index="68" name="Last update"/>
    <alias field="lastupdate_user" index="69" name="Last update user"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="connec_id" expression="" applyOnUpdate="0"/>
    <default field="code" expression="" applyOnUpdate="0"/>
    <default field="customer_code" expression="" applyOnUpdate="0"/>
    <default field="top_elev" expression="" applyOnUpdate="0"/>
    <default field="y1" expression="" applyOnUpdate="0"/>
    <default field="y2" expression="" applyOnUpdate="0"/>
    <default field="connecat_id" expression="" applyOnUpdate="0"/>
    <default field="connec_type" expression="" applyOnUpdate="0"/>
    <default field="sys_type" expression="" applyOnUpdate="0"/>
    <default field="private_connecat_id" expression="" applyOnUpdate="0"/>
    <default field="matcat_id" expression="" applyOnUpdate="0"/>
    <default field="expl_id" expression="" applyOnUpdate="0"/>
    <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
    <default field="sector_id" expression="" applyOnUpdate="0"/>
    <default field="macrosector_id" expression="" applyOnUpdate="0"/>
    <default field="demand" expression="" applyOnUpdate="0"/>
    <default field="state" expression="" applyOnUpdate="0"/>
    <default field="state_type" expression="" applyOnUpdate="0"/>
    <default field="connec_depth" expression="" applyOnUpdate="0"/>
    <default field="connec_length" expression="" applyOnUpdate="0"/>
    <default field="arc_id" expression="" applyOnUpdate="0"/>
    <default field="annotation" expression="" applyOnUpdate="0"/>
    <default field="observ" expression="" applyOnUpdate="0"/>
    <default field="comment" expression="" applyOnUpdate="0"/>
    <default field="dma_id" expression="" applyOnUpdate="0"/>
    <default field="macrodma_id" expression="" applyOnUpdate="0"/>
    <default field="soilcat_id" expression="" applyOnUpdate="0"/>
    <default field="function_type" expression="" applyOnUpdate="0"/>
    <default field="category_type" expression="" applyOnUpdate="0"/>
    <default field="fluid_type" expression="" applyOnUpdate="0"/>
    <default field="location_type" expression="" applyOnUpdate="0"/>
    <default field="workcat_id" expression="" applyOnUpdate="0"/>
    <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
    <default field="buildercat_id" expression="" applyOnUpdate="0"/>
    <default field="builtdate" expression="" applyOnUpdate="0"/>
    <default field="enddate" expression="" applyOnUpdate="0"/>
    <default field="ownercat_id" expression="" applyOnUpdate="0"/>
    <default field="muni_id" expression="" applyOnUpdate="0"/>
    <default field="postcode" expression="" applyOnUpdate="0"/>
    <default field="district_id" expression="" applyOnUpdate="0"/>
    <default field="streetname" expression="" applyOnUpdate="0"/>
    <default field="postnumber" expression="" applyOnUpdate="0"/>
    <default field="postcomplement" expression="" applyOnUpdate="0"/>
    <default field="streetname2" expression="" applyOnUpdate="0"/>
    <default field="postnumber2" expression="" applyOnUpdate="0"/>
    <default field="postcomplement2" expression="" applyOnUpdate="0"/>
    <default field="descript" expression="" applyOnUpdate="0"/>
    <default field="svg" expression="" applyOnUpdate="0"/>
    <default field="rotation" expression="" applyOnUpdate="0"/>
    <default field="link" expression="" applyOnUpdate="0"/>
    <default field="verified" expression="" applyOnUpdate="0"/>
    <default field="undelete" expression="" applyOnUpdate="0"/>
    <default field="label" expression="" applyOnUpdate="0"/>
    <default field="label_x" expression="" applyOnUpdate="0"/>
    <default field="label_y" expression="" applyOnUpdate="0"/>
    <default field="label_rotation" expression="" applyOnUpdate="0"/>
    <default field="accessibility" expression="" applyOnUpdate="0"/>
    <default field="diagonal" expression="" applyOnUpdate="0"/>
    <default field="publish" expression="" applyOnUpdate="0"/>
    <default field="inventory" expression="" applyOnUpdate="0"/>
    <default field="uncertain" expression="" applyOnUpdate="0"/>
    <default field="num_value" expression="" applyOnUpdate="0"/>
    <default field="feature_id" expression="" applyOnUpdate="0"/>
    <default field="featurecat_id" expression="" applyOnUpdate="0"/>
    <default field="pjoint_id" expression="" applyOnUpdate="0"/>
    <default field="pjoint_type" expression="" applyOnUpdate="0"/>
    <default field="tstamp" expression="" applyOnUpdate="0"/>
    <default field="insert_user" expression="" applyOnUpdate="0"/>
    <default field="lastupdate" expression="" applyOnUpdate="0"/>
    <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" field="connec_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="code" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="customer_code" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="top_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="y1" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="y2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="connecat_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="connec_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="sys_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="private_connecat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="matcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="expl_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="macroexpl_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrosector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="demand" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="connec_depth" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="connec_length" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="arc_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="annotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="observ" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="comment" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="dma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrodma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="soilcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="function_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="category_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="fluid_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="location_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id_end" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="buildercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="builtdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="enddate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="ownercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="muni_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcode" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="district_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="descript" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="svg" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="link" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="verified" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="undelete" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_x" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_y" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="accessibility" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="diagonal" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="publish" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="inventory" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="uncertain" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="num_value" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="feature_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="featurecat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="pjoint_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="pjoint_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="tstamp" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="insert_user" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate_user" notnull_strength="2" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="connec_id" desc="" exp=""/>
    <constraint field="code" desc="" exp=""/>
    <constraint field="customer_code" desc="" exp=""/>
    <constraint field="top_elev" desc="" exp=""/>
    <constraint field="y1" desc="" exp=""/>
    <constraint field="y2" desc="" exp=""/>
    <constraint field="connecat_id" desc="" exp=""/>
    <constraint field="connec_type" desc="" exp=""/>
    <constraint field="sys_type" desc="" exp=""/>
    <constraint field="private_connecat_id" desc="" exp=""/>
    <constraint field="matcat_id" desc="" exp=""/>
    <constraint field="expl_id" desc="" exp=""/>
    <constraint field="macroexpl_id" desc="" exp=""/>
    <constraint field="sector_id" desc="" exp=""/>
    <constraint field="macrosector_id" desc="" exp=""/>
    <constraint field="demand" desc="" exp=""/>
    <constraint field="state" desc="" exp=""/>
    <constraint field="state_type" desc="" exp=""/>
    <constraint field="connec_depth" desc="" exp=""/>
    <constraint field="connec_length" desc="" exp=""/>
    <constraint field="arc_id" desc="" exp=""/>
    <constraint field="annotation" desc="" exp=""/>
    <constraint field="observ" desc="" exp=""/>
    <constraint field="comment" desc="" exp=""/>
    <constraint field="dma_id" desc="" exp=""/>
    <constraint field="macrodma_id" desc="" exp=""/>
    <constraint field="soilcat_id" desc="" exp=""/>
    <constraint field="function_type" desc="" exp=""/>
    <constraint field="category_type" desc="" exp=""/>
    <constraint field="fluid_type" desc="" exp=""/>
    <constraint field="location_type" desc="" exp=""/>
    <constraint field="workcat_id" desc="" exp=""/>
    <constraint field="workcat_id_end" desc="" exp=""/>
    <constraint field="buildercat_id" desc="" exp=""/>
    <constraint field="builtdate" desc="" exp=""/>
    <constraint field="enddate" desc="" exp=""/>
    <constraint field="ownercat_id" desc="" exp=""/>
    <constraint field="muni_id" desc="" exp=""/>
    <constraint field="postcode" desc="" exp=""/>
    <constraint field="district_id" desc="" exp=""/>
    <constraint field="streetname" desc="" exp=""/>
    <constraint field="postnumber" desc="" exp=""/>
    <constraint field="postcomplement" desc="" exp=""/>
    <constraint field="streetname2" desc="" exp=""/>
    <constraint field="postnumber2" desc="" exp=""/>
    <constraint field="postcomplement2" desc="" exp=""/>
    <constraint field="descript" desc="" exp=""/>
    <constraint field="svg" desc="" exp=""/>
    <constraint field="rotation" desc="" exp=""/>
    <constraint field="link" desc="" exp=""/>
    <constraint field="verified" desc="" exp=""/>
    <constraint field="undelete" desc="" exp=""/>
    <constraint field="label" desc="" exp=""/>
    <constraint field="label_x" desc="" exp=""/>
    <constraint field="label_y" desc="" exp=""/>
    <constraint field="label_rotation" desc="" exp=""/>
    <constraint field="accessibility" desc="" exp=""/>
    <constraint field="diagonal" desc="" exp=""/>
    <constraint field="publish" desc="" exp=""/>
    <constraint field="inventory" desc="" exp=""/>
    <constraint field="uncertain" desc="" exp=""/>
    <constraint field="num_value" desc="" exp=""/>
    <constraint field="feature_id" desc="" exp=""/>
    <constraint field="featurecat_id" desc="" exp=""/>
    <constraint field="pjoint_id" desc="" exp=""/>
    <constraint field="pjoint_type" desc="" exp=""/>
    <constraint field="tstamp" desc="" exp=""/>
    <constraint field="insert_user" desc="" exp=""/>
    <constraint field="lastupdate" desc="" exp=""/>
    <constraint field="lastupdate_user" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="1" sortExpression="&quot;enddate&quot;">
    <columns>
      <column type="field" hidden="0" name="connec_id" width="-1"/>
      <column type="field" hidden="0" name="code" width="-1"/>
      <column type="field" hidden="0" name="connecat_id" width="-1"/>
      <column type="field" hidden="0" name="sector_id" width="-1"/>
      <column type="field" hidden="0" name="customer_code" width="-1"/>
      <column type="field" hidden="0" name="state" width="-1"/>
      <column type="field" hidden="0" name="state_type" width="-1"/>
      <column type="field" hidden="0" name="annotation" width="-1"/>
      <column type="field" hidden="0" name="observ" width="-1"/>
      <column type="field" hidden="1" name="comment" width="-1"/>
      <column type="field" hidden="0" name="dma_id" width="-1"/>
      <column type="field" hidden="0" name="soilcat_id" width="-1"/>
      <column type="field" hidden="0" name="function_type" width="116"/>
      <column type="field" hidden="0" name="category_type" width="119"/>
      <column type="field" hidden="0" name="fluid_type" width="-1"/>
      <column type="field" hidden="0" name="location_type" width="-1"/>
      <column type="field" hidden="0" name="workcat_id" width="-1"/>
      <column type="field" hidden="0" name="workcat_id_end" width="-1"/>
      <column type="field" hidden="1" name="buildercat_id" width="-1"/>
      <column type="field" hidden="0" name="builtdate" width="-1"/>
      <column type="field" hidden="0" name="enddate" width="-1"/>
      <column type="field" hidden="0" name="ownercat_id" width="-1"/>
      <column type="field" hidden="0" name="muni_id" width="-1"/>
      <column type="field" hidden="0" name="postcode" width="-1"/>
      <column type="field" hidden="0" name="streetaxis_id" width="243"/>
      <column type="field" hidden="0" name="postnumber" width="-1"/>
      <column type="field" hidden="0" name="streetaxis2_id" width="-1"/>
      <column type="field" hidden="0" name="postnumber2" width="-1"/>
      <column type="field" hidden="0" name="descript" width="-1"/>
      <column type="field" hidden="0" name="arc_id" width="-1"/>
      <column type="field" hidden="1" name="svg" width="-1"/>
      <column type="field" hidden="0" name="rotation" width="-1"/>
      <column type="field" hidden="0" name="label_x" width="-1"/>
      <column type="field" hidden="0" name="label_y" width="-1"/>
      <column type="field" hidden="0" name="label_rotation" width="-1"/>
      <column type="field" hidden="0" name="link" width="-1"/>
      <column type="field" hidden="1" name="connec_length" width="-1"/>
      <column type="field" hidden="0" name="verified" width="-1"/>
      <column type="field" hidden="1" name="undelete" width="-1"/>
      <column type="field" hidden="1" name="publish" width="-1"/>
      <column type="field" hidden="1" name="inventory" width="-1"/>
      <column type="field" hidden="1" name="macrodma_id" width="-1"/>
      <column type="field" hidden="0" name="expl_id" width="-1"/>
      <column type="field" hidden="1" name="num_value" width="-1"/>
      <column type="actions" hidden="1" width="-1"/>
      <column type="field" hidden="0" name="top_elev" width="-1"/>
      <column type="field" hidden="0" name="y1" width="-1"/>
      <column type="field" hidden="0" name="y2" width="-1"/>
      <column type="field" hidden="0" name="connec_type" width="-1"/>
      <column type="field" hidden="0" name="sys_type" width="-1"/>
      <column type="field" hidden="0" name="private_connecat_id" width="-1"/>
      <column type="field" hidden="1" name="cat_matcat_id" width="-1"/>
      <column type="field" hidden="1" name="macrosector_id" width="-1"/>
      <column type="field" hidden="0" name="demand" width="-1"/>
      <column type="field" hidden="0" name="connec_depth" width="-1"/>
      <column type="field" hidden="0" name="postcomplement" width="-1"/>
      <column type="field" hidden="0" name="postcomplement2" width="-1"/>
      <column type="field" hidden="1" name="featurecat_id" width="-1"/>
      <column type="field" hidden="1" name="feature_id" width="-1"/>
      <column type="field" hidden="1" name="accessibility" width="-1"/>
      <column type="field" hidden="0" name="diagonal" width="-1"/>
      <column type="field" hidden="0" name="uncertain" width="-1"/>
      <column type="field" hidden="0" name="label" width="-1"/>
      <column type="field" hidden="0" name="pjoint_type" width="-1"/>
      <column type="field" hidden="0" name="pjoint_id" width="-1"/>
      <column type="field" hidden="0" name="lastupdate" width="-1"/>
      <column type="field" hidden="0" name="lastupdate_user" width="-1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit>formOpen</editforminit>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="accessibility"/>
    <field editable="1" name="annotation"/>
    <field editable="1" name="arc_id"/>
    <field editable="1" name="buildercat_id"/>
    <field editable="1" name="builtdate"/>
    <field editable="0" name="cat_matcat_id"/>
    <field editable="1" name="category_type"/>
    <field editable="1" name="code"/>
    <field editable="1" name="comment"/>
    <field editable="1" name="connec_depth"/>
    <field editable="1" name="connec_id"/>
    <field editable="1" name="connec_length"/>
    <field editable="0" name="connec_type"/>
    <field editable="1" name="connecat_id"/>
    <field editable="1" name="customer_code"/>
    <field editable="1" name="demand"/>
    <field editable="1" name="descript"/>
    <field editable="1" name="diagonal"/>
    <field editable="1" name="dma_id"/>
    <field editable="1" name="enddate"/>
    <field editable="1" name="expl_id"/>
    <field editable="0" name="feature_id"/>
    <field editable="0" name="featurecat_id"/>
    <field editable="1" name="fluid_type"/>
    <field editable="1" name="function_type"/>
    <field editable="1" name="inventory"/>
    <field editable="0" name="label"/>
    <field editable="1" name="label_rotation"/>
    <field editable="1" name="label_x"/>
    <field editable="1" name="label_y"/>
    <field editable="0" name="lastupdate"/>
    <field editable="0" name="lastupdate_user"/>
    <field editable="0" name="link"/>
    <field editable="1" name="location_type"/>
    <field editable="1" name="macrodma_id"/>
    <field editable="1" name="macroexpl_id"/>
    <field editable="0" name="macrosector_id"/>
    <field editable="0" name="matcat_id"/>
    <field editable="1" name="muni_id"/>
    <field editable="1" name="num_value"/>
    <field editable="1" name="observ"/>
    <field editable="1" name="ownercat_id"/>
    <field editable="0" name="pjoint_id"/>
    <field editable="0" name="pjoint_type"/>
    <field editable="1" name="postcode"/>
    <field editable="1" name="postcomplement"/>
    <field editable="1" name="postcomplement2"/>
    <field editable="1" name="postnumber"/>
    <field editable="1" name="postnumber2"/>
    <field editable="1" name="private_connecat_id"/>
    <field editable="1" name="publish"/>
    <field editable="1" name="rotation"/>
    <field editable="1" name="sector_id"/>
    <field editable="1" name="soilcat_id"/>
    <field editable="1" name="state"/>
    <field editable="1" name="state_type"/>
    <field editable="1" name="streetaxis2_id"/>
    <field editable="1" name="streetaxis_id"/>
    <field editable="1" name="streetname"/>
    <field editable="1" name="streetname2"/>
    <field editable="1" name="svg"/>
    <field editable="1" name="sys_type"/>
    <field editable="1" name="top_elev"/>
    <field editable="1" name="tstamp"/>
    <field editable="1" name="uncertain"/>
    <field editable="1" name="undelete"/>
    <field editable="1" name="verified"/>
    <field editable="1" name="workcat_id"/>
    <field editable="1" name="workcat_id_end"/>
    <field editable="1" name="y1"/>
    <field editable="1" name="y2"/>
  </editable>
  <labelOnTop>
    <field name="accessibility" labelOnTop="0"/>
    <field name="annotation" labelOnTop="0"/>
    <field name="arc_id" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="cat_matcat_id" labelOnTop="0"/>
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
    <field name="dma_id" labelOnTop="0"/>
    <field name="enddate" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="feature_id" labelOnTop="0"/>
    <field name="featurecat_id" labelOnTop="0"/>
    <field name="fluid_type" labelOnTop="0"/>
    <field name="function_type" labelOnTop="0"/>
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
    <field name="macrosector_id" labelOnTop="0"/>
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
    <field name="streetaxis2_id" labelOnTop="0"/>
    <field name="streetaxis_id" labelOnTop="0"/>
    <field name="svg" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="top_elev" labelOnTop="0"/>
    <field name="uncertain" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
    <field name="y1" labelOnTop="0"/>
    <field name="y2" labelOnTop="0"/>
  </labelOnTop>
  <widgets>
    <widget name="Arc_streetaxis_id">
      <config/>
    </widget>
    <widget name="Capa unida_postcode_1">
      <config/>
    </widget>
    <widget name="Capa unida_postnumb_1">
      <config/>
    </widget>
  </widgets>
  <previewExpression>depth : [% "connec_depth" %]</previewExpression>
  <mapTip>depth : [% "connec_depth" %]</mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true)  ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('103', 'v_edit_link', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" labelsEnabled="0" simplifyDrawingHints="1" minScale="1500" simplifyLocal="1" simplifyMaxScale="1" maxScale="0" readOnly="0" version="3.10.3-A Coruña" hasScaleBasedVisibilityFlag="1" simplifyAlgorithm="0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" type="singleSymbol" symbollevels="0" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="153,80,76,255" k="line_color"/>
          <prop v="dash" k="line_style"/>
          <prop v="0.26" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="GeometryGenerator" pass="0">
          <prop v="Marker" k="SymbolType"/>
          <prop v="end_point($geometry)" k="geometryModifier"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="@0@1">
            <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
              <prop v="0" k="angle"/>
              <prop v="255,0,0,255" k="color"/>
              <prop v="1" k="horizontal_anchor_point"/>
              <prop v="bevel" k="joinstyle"/>
              <prop v="cross2" k="name"/>
              <prop v="0,0" k="offset"/>
              <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
              <prop v="MM" k="offset_unit"/>
              <prop v="35,35,35,255" k="outline_color"/>
              <prop v="solid" k="outline_style"/>
              <prop v="0" k="outline_width"/>
              <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
              <prop v="MM" k="outline_width_unit"/>
              <prop v="diameter" k="scale_method"/>
              <prop v="1.8" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" value="" name="name"/>
                  <Option name="properties"/>
                  <Option type="QString" value="collection" name="type"/>
                </Option>
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
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" rotationOffset="270" height="15" barWidth="5" minimumSize="0" minScaleDenominator="0" sizeScale="3x:0,0,0,0,0,0" backgroundColor="#ffffff" diagramOrientation="Up" maxScaleDenominator="1e+08" lineSizeType="MM" penWidth="0" penAlpha="255" width="15" scaleBasedVisibility="0" backgroundAlpha="255" sizeType="MM" penColor="#000000" enabled="0" opacity="1" scaleDependency="Area" labelPlacementMethod="XHeight">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute field="" color="#000000" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings priority="0" obstacle="0" dist="0" linePlacementFlags="2" zIndex="0" showAll="1" placement="2">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="link_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gis_length">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="userdefined_geom">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ispsectorgeom">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="psector_rowid">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="vnode_topelev">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="link_id" index="0" name="link_id"/>
    <alias field="feature_type" index="1" name="feature_type"/>
    <alias field="feature_id" index="2" name="feature_id"/>
    <alias field="macrosector_id" index="3" name="macrosector_id"/>
    <alias field="macrodma_id" index="4" name="macrodma_id"/>
    <alias field="exit_type" index="5" name="exit_type"/>
    <alias field="exit_id" index="6" name="exit_id"/>
    <alias field="sector_id" index="7" name="sector_id"/>
    <alias field="dma_id" index="8" name="dma_id"/>
    <alias field="expl_id" index="9" name="expl_id"/>
    <alias field="state" index="10" name="state"/>
    <alias field="gis_length" index="11" name="gis_length"/>
    <alias field="userdefined_geom" index="12" name="userdefined_geom"/>
    <alias field="ispsectorgeom" index="13" name="ispsectorgeom"/>
    <alias field="psector_rowid" index="14" name="psector_rowid"/>
    <alias field="fluid_type" index="15" name=""/>
    <alias field="vnode_topelev" index="16" name=""/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="link_id" expression="" applyOnUpdate="0"/>
    <default field="feature_type" expression="" applyOnUpdate="0"/>
    <default field="feature_id" expression="" applyOnUpdate="0"/>
    <default field="macrosector_id" expression="" applyOnUpdate="0"/>
    <default field="macrodma_id" expression="" applyOnUpdate="0"/>
    <default field="exit_type" expression="" applyOnUpdate="0"/>
    <default field="exit_id" expression="" applyOnUpdate="0"/>
    <default field="sector_id" expression="" applyOnUpdate="0"/>
    <default field="dma_id" expression="" applyOnUpdate="0"/>
    <default field="expl_id" expression="" applyOnUpdate="0"/>
    <default field="state" expression="" applyOnUpdate="0"/>
    <default field="gis_length" expression="" applyOnUpdate="0"/>
    <default field="userdefined_geom" expression="" applyOnUpdate="0"/>
    <default field="ispsectorgeom" expression="" applyOnUpdate="0"/>
    <default field="psector_rowid" expression="" applyOnUpdate="0"/>
    <default field="fluid_type" expression="" applyOnUpdate="0"/>
    <default field="vnode_topelev" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" field="link_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="feature_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="feature_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="macrosector_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="macrodma_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="exit_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="exit_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="sector_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="dma_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="expl_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="state" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="gis_length" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="userdefined_geom" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="ispsectorgeom" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="psector_rowid" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="fluid_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="vnode_topelev" notnull_strength="0" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="link_id" desc="" exp=""/>
    <constraint field="feature_type" desc="" exp=""/>
    <constraint field="feature_id" desc="" exp=""/>
    <constraint field="macrosector_id" desc="" exp=""/>
    <constraint field="macrodma_id" desc="" exp=""/>
    <constraint field="exit_type" desc="" exp=""/>
    <constraint field="exit_id" desc="" exp=""/>
    <constraint field="sector_id" desc="" exp=""/>
    <constraint field="dma_id" desc="" exp=""/>
    <constraint field="expl_id" desc="" exp=""/>
    <constraint field="state" desc="" exp=""/>
    <constraint field="gis_length" desc="" exp=""/>
    <constraint field="userdefined_geom" desc="" exp=""/>
    <constraint field="ispsectorgeom" desc="" exp=""/>
    <constraint field="psector_rowid" desc="" exp=""/>
    <constraint field="fluid_type" desc="" exp=""/>
    <constraint field="vnode_topelev" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="&quot;link_id&quot;">
    <columns>
      <column type="field" hidden="0" name="link_id" width="-1"/>
      <column type="field" hidden="0" name="feature_type" width="110"/>
      <column type="field" hidden="0" name="feature_id" width="-1"/>
      <column type="field" hidden="0" name="exit_type" width="-1"/>
      <column type="field" hidden="0" name="exit_id" width="-1"/>
      <column type="field" hidden="0" name="sector_id" width="-1"/>
      <column type="field" hidden="0" name="dma_id" width="-1"/>
      <column type="field" hidden="0" name="expl_id" width="-1"/>
      <column type="field" hidden="0" name="state" width="-1"/>
      <column type="field" hidden="0" name="gis_length" width="109"/>
      <column type="field" hidden="0" name="userdefined_geom" width="-1"/>
      <column type="actions" hidden="1" width="-1"/>
      <column type="field" hidden="0" name="macrosector_id" width="-1"/>
      <column type="field" hidden="0" name="macrodma_id" width="-1"/>
      <column type="field" hidden="0" name="ispsectorgeom" width="-1"/>
      <column type="field" hidden="0" name="psector_rowid" width="-1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1">C:/Users/Nestor/AppData/Roaming/QGIS/QGIS3/profiles/default/python/plugins/giswater/templates/qgisproject/en</editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="dma_id"/>
    <field editable="1" name="exit_id"/>
    <field editable="1" name="exit_type"/>
    <field editable="1" name="expl_id"/>
    <field editable="1" name="feature_id"/>
    <field editable="1" name="feature_type"/>
    <field editable="1" name="gis_length"/>
    <field editable="1" name="ispsectorgeom"/>
    <field editable="1" name="link_id"/>
    <field editable="0" name="macrodma_id"/>
    <field editable="0" name="macrosector_id"/>
    <field editable="1" name="psector_rowid"/>
    <field editable="1" name="sector_id"/>
    <field editable="1" name="state"/>
    <field editable="1" name="userdefined_geom"/>
  </editable>
  <labelOnTop>
    <field name="dma_id" labelOnTop="0"/>
    <field name="exit_id" labelOnTop="0"/>
    <field name="exit_type" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="feature_id" labelOnTop="0"/>
    <field name="feature_type" labelOnTop="0"/>
    <field name="gis_length" labelOnTop="0"/>
    <field name="ispsectorgeom" labelOnTop="0"/>
    <field name="link_id" labelOnTop="0"/>
    <field name="macrodma_id" labelOnTop="0"/>
    <field name="macrosector_id" labelOnTop="0"/>
    <field name="psector_rowid" labelOnTop="0"/>
    <field name="sector_id" labelOnTop="0"/>
    <field name="state" labelOnTop="0"/>
    <field name="userdefined_geom" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>COALESCE( "link_id", '&lt;NULL>' )</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true)  ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('104', 'v_edit_node', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" labelsEnabled="0" simplifyDrawingHints="0" minScale="2500" simplifyLocal="1" simplifyMaxScale="1" maxScale="1" readOnly="0" version="3.10.3-A Coruña" hasScaleBasedVisibilityFlag="1" simplifyAlgorithm="0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 attr="sys_type" forceraster="0" type="categorizedSymbol" symbollevels="0" enableorderby="0">
    <categories>
      <category value="STORAGE" render="true" symbol="0" label="Storage"/>
      <category value="CHAMBER" render="true" symbol="1" label="Chamber"/>
      <category value="WWTP" render="true" symbol="2" label="Wwtp"/>
      <category value="NETGULLY" render="true" symbol="3" label="Netgully"/>
      <category value="NETELEMENT" render="true" symbol="4" label="Netelement"/>
      <category value="MANHOLE" render="true" symbol="5" label="Manhole"/>
      <category value="NETINIT" render="true" symbol="6" label="Netinit"/>
      <category value="WJUMP" render="true" symbol="7" label="Wjump"/>
      <category value="JUNCTION" render="true" symbol="8" label="Junction"/>
      <category value="OUTFALL" render="true" symbol="9" label="Outfall"/>
      <category value="VALVE" render="true" symbol="10" label="Valve"/>
    </categories>
    <symbols>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="44,67,207,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="square" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2.5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="1">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="31,120,180,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="square" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2.5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="10">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="2">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="50,48,55,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="square" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="3">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="106,233,255,0" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="1.8" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="4">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="129,10,78,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="5">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="106,233,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="6">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="26,115,162,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="7">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="147,218,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="147,218,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="0.5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="8">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="45,136,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="255,0,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="0.5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="9">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="227,26,28,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="filled_arrowhead" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3.5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="106,233,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <property value="" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" rotationOffset="270" height="15" barWidth="5" minimumSize="0" minScaleDenominator="1" sizeScale="3x:0,0,0,0,0,0" backgroundColor="#ffffff" diagramOrientation="Up" maxScaleDenominator="1e+08" lineSizeType="MM" penWidth="0" penAlpha="255" width="15" scaleBasedVisibility="0" backgroundAlpha="255" sizeType="MM" penColor="#000000" enabled="0" opacity="1" scaleDependency="Area" labelPlacementMethod="XHeight">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute field="" color="#000000" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings priority="0" obstacle="0" dist="0" linePlacementFlags="2" zIndex="0" showAll="1" placement="0">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
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
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ymax">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_ymax">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_ymax">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="node_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="CHAMBER" name="CHAMBER"/>
              <Option type="QString" value="CHANGE" name="CHANGE"/>
              <Option type="QString" value="CIRC_MANHOLE" name="CIRC_MANHOLE"/>
              <Option type="QString" value="HIGHPOINT" name="HIGHPOINT"/>
              <Option type="QString" value="JUMP" name="JUMP"/>
              <Option type="QString" value="JUNCTION" name="JUNCTION"/>
              <Option type="QString" value="NETELEMENT" name="NETELEMENT"/>
              <Option type="QString" value="NETGULLY" name="NETGULLY"/>
              <Option type="QString" value="NETINIT" name="NETINIT"/>
              <Option type="QString" value="OUTFALL" name="OUTFALL"/>
              <Option type="QString" value="OWERFLOW_STORAGE" name="OWERFLOW_STORAGE"/>
              <Option type="QString" value="PUMP_STATION" name="PUMP_STATION"/>
              <Option type="QString" value="RECT_MANHOLE" name="RECT_MANHOLE"/>
              <Option type="QString" value="REGISTER" name="REGISTER"/>
              <Option type="QString" value="SANDBOX" name="SANDBOX"/>
              <Option type="QString" value="SEWER_STORAGE" name="SEWER_STORAGE"/>
              <Option type="QString" value="VALVE" name="VALVE"/>
              <Option type="QString" value="VIRTUAL_NODE" name="VIRTUAL_NODE"/>
              <Option type="QString" value="WEIR" name="WEIR"/>
              <Option type="QString" value="WWTP" name="WWTP"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="matcat_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="epa_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="DIVIDER" name="DIVIDER"/>
              <Option type="QString" value="JUNCTION" name="JUNCTION"/>
              <Option type="QString" value="NOT DEFINED" name="NOT DEFINED"/>
              <Option type="QString" value="OUTFALL" name="OUTFALL"/>
              <Option type="QString" value="STORAGE" name="STORAGE"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="expl_01"/>
              <Option type="QString" value="2" name="expl_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="sector_01"/>
              <Option type="QString" value="2" name="sector_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="0" name="OBSOLETE"/>
              <Option type="QString" value="1" name="ON_SERVICE"/>
              <Option type="QString" value="2" name="PLANIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="95" name="CANCELED FICTICIOUS"/>
              <Option type="QString" value="96" name="CANCELED PLANIFIED"/>
              <Option type="QString" value="97" name="DONE FICTICIOUS"/>
              <Option type="QString" value="98" name="DONE PLANIFIED"/>
              <Option type="QString" value="99" name="FICTICIUS"/>
              <Option type="QString" value="1" name="OBSOLETE"/>
              <Option type="QString" value="2" name="ON_SERVICE"/>
              <Option type="QString" value="3" name="PLANIFIED"/>
              <Option type="QString" value="5" name="PROVISIONAL"/>
              <Option type="QString" value="4" name="RECONSTRUCT"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="dma_01"/>
              <Option type="QString" value="3" name="dma_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="soil1" name="soil1"/>
              <Option type="QString" value="soil2" name="soil2"/>
              <Option type="QString" value="soil3" name="soil3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Function" name="St. Function"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Category" name="St. Category"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Fluid" name="St. Fluid"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Location" name="St. Location"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="builder1" name="builder1"/>
              <Option type="QString" value="builder2" name="builder2"/>
              <Option type="QString" value="builder3" name="builder3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="owner1" name="owner1"/>
              <Option type="QString" value="owner2" name="owner2"/>
              <Option type="QString" value="owner3" name="owner3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="Sant Boi del Llobregat"/>
              <Option type="QString" value="2" name="Sant Esteve de les Roures"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="streetname">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="svg">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="TO REVIEW" name="TO REVIEW"/>
              <Option type="QString" value="VERIFIED" name="VERIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="label_x">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="uncertain">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="xyz_date">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="unconnected">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="insert_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="node_id" index="0" name="node_id"/>
    <alias field="code" index="1" name="code"/>
    <alias field="top_elev" index="2" name="top_elev"/>
    <alias field="custom_top_elev" index="3" name="custom_top_elev"/>
    <alias field="sys_top_elev" index="4" name="sys_top_elev"/>
    <alias field="ymax" index="5" name="ymax"/>
    <alias field="custom_ymax" index="6" name="custom_ymax"/>
    <alias field="sys_ymax" index="7" name="sys_ymax"/>
    <alias field="elev" index="8" name="elev"/>
    <alias field="custom_elev" index="9" name="custom_elev"/>
    <alias field="sys_elev" index="10" name="sys_elev"/>
    <alias field="node_type" index="11" name="node_type"/>
    <alias field="sys_type" index="12" name=""/>
    <alias field="nodecat_id" index="13" name="nodecat_id"/>
    <alias field="matcat_id" index="14" name="matcat_id"/>
    <alias field="epa_type" index="15" name="epa_type"/>
    <alias field="expl_id" index="16" name="expl_id"/>
    <alias field="macroexpl_id" index="17" name="Macroexploitation"/>
    <alias field="sector_id" index="18" name="sector_id"/>
    <alias field="macrosector_id" index="19" name="macrosector_id"/>
    <alias field="state" index="20" name="state"/>
    <alias field="state_type" index="21" name="state_type"/>
    <alias field="annotation" index="22" name="annotation"/>
    <alias field="observ" index="23" name="observ"/>
    <alias field="comment" index="24" name="comment"/>
    <alias field="dma_id" index="25" name="dma_id"/>
    <alias field="macrodma_id" index="26" name="macrodma_id"/>
    <alias field="soilcat_id" index="27" name="soilcat_id"/>
    <alias field="function_type" index="28" name="function_type"/>
    <alias field="category_type" index="29" name="category_type"/>
    <alias field="fluid_type" index="30" name="fluid_type"/>
    <alias field="location_type" index="31" name="location_type"/>
    <alias field="workcat_id" index="32" name="workcat_id"/>
    <alias field="workcat_id_end" index="33" name="workcat_id_end"/>
    <alias field="buildercat_id" index="34" name="buildercat_id"/>
    <alias field="builtdate" index="35" name="builtdate"/>
    <alias field="enddate" index="36" name="enddate"/>
    <alias field="ownercat_id" index="37" name="ownercat_id"/>
    <alias field="muni_id" index="38" name="muni_id"/>
    <alias field="postcode" index="39" name="postcode"/>
    <alias field="district_id" index="40" name=""/>
    <alias field="streetname" index="41" name="streetname"/>
    <alias field="postnumber" index="42" name="postnumber"/>
    <alias field="postcomplement" index="43" name="postcomplement"/>
    <alias field="streetname2" index="44" name="streetname2"/>
    <alias field="postnumber2" index="45" name="postnumber2"/>
    <alias field="postcomplement2" index="46" name="postcomplement2"/>
    <alias field="descript" index="47" name="descript"/>
    <alias field="svg" index="48" name="svg"/>
    <alias field="rotation" index="49" name="rotation"/>
    <alias field="link" index="50" name="link"/>
    <alias field="verified" index="51" name="verified"/>
    <alias field="undelete" index="52" name="undelete"/>
    <alias field="label" index="53" name="Catalog label"/>
    <alias field="label_x" index="54" name="label_x"/>
    <alias field="label_y" index="55" name="label_y"/>
    <alias field="label_rotation" index="56" name="label_rotation"/>
    <alias field="publish" index="57" name="publish"/>
    <alias field="inventory" index="58" name="inventory"/>
    <alias field="uncertain" index="59" name="uncertain"/>
    <alias field="xyz_date" index="60" name="xyz_date"/>
    <alias field="unconnected" index="61" name="unconnected"/>
    <alias field="num_value" index="62" name="num_value"/>
    <alias field="tstamp" index="63" name="Insert tstamp"/>
    <alias field="insert_user" index="64" name=""/>
    <alias field="lastupdate" index="65" name="Last update"/>
    <alias field="lastupdate_user" index="66" name="Last update user"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="node_id" expression="" applyOnUpdate="0"/>
    <default field="code" expression="" applyOnUpdate="0"/>
    <default field="top_elev" expression="" applyOnUpdate="0"/>
    <default field="custom_top_elev" expression="" applyOnUpdate="0"/>
    <default field="sys_top_elev" expression="" applyOnUpdate="0"/>
    <default field="ymax" expression="" applyOnUpdate="0"/>
    <default field="custom_ymax" expression="" applyOnUpdate="0"/>
    <default field="sys_ymax" expression="" applyOnUpdate="0"/>
    <default field="elev" expression="" applyOnUpdate="0"/>
    <default field="custom_elev" expression="" applyOnUpdate="0"/>
    <default field="sys_elev" expression="" applyOnUpdate="0"/>
    <default field="node_type" expression="" applyOnUpdate="0"/>
    <default field="sys_type" expression="" applyOnUpdate="0"/>
    <default field="nodecat_id" expression="" applyOnUpdate="0"/>
    <default field="matcat_id" expression="" applyOnUpdate="0"/>
    <default field="epa_type" expression="" applyOnUpdate="0"/>
    <default field="expl_id" expression="" applyOnUpdate="0"/>
    <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
    <default field="sector_id" expression="" applyOnUpdate="0"/>
    <default field="macrosector_id" expression="" applyOnUpdate="0"/>
    <default field="state" expression="" applyOnUpdate="0"/>
    <default field="state_type" expression="" applyOnUpdate="0"/>
    <default field="annotation" expression="" applyOnUpdate="0"/>
    <default field="observ" expression="" applyOnUpdate="0"/>
    <default field="comment" expression="" applyOnUpdate="0"/>
    <default field="dma_id" expression="" applyOnUpdate="0"/>
    <default field="macrodma_id" expression="" applyOnUpdate="0"/>
    <default field="soilcat_id" expression="" applyOnUpdate="0"/>
    <default field="function_type" expression="" applyOnUpdate="0"/>
    <default field="category_type" expression="" applyOnUpdate="0"/>
    <default field="fluid_type" expression="" applyOnUpdate="0"/>
    <default field="location_type" expression="" applyOnUpdate="0"/>
    <default field="workcat_id" expression="" applyOnUpdate="0"/>
    <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
    <default field="buildercat_id" expression="" applyOnUpdate="0"/>
    <default field="builtdate" expression="" applyOnUpdate="0"/>
    <default field="enddate" expression="" applyOnUpdate="0"/>
    <default field="ownercat_id" expression="" applyOnUpdate="0"/>
    <default field="muni_id" expression="" applyOnUpdate="0"/>
    <default field="postcode" expression="" applyOnUpdate="0"/>
    <default field="district_id" expression="" applyOnUpdate="0"/>
    <default field="streetname" expression="" applyOnUpdate="0"/>
    <default field="postnumber" expression="" applyOnUpdate="0"/>
    <default field="postcomplement" expression="" applyOnUpdate="0"/>
    <default field="streetname2" expression="" applyOnUpdate="0"/>
    <default field="postnumber2" expression="" applyOnUpdate="0"/>
    <default field="postcomplement2" expression="" applyOnUpdate="0"/>
    <default field="descript" expression="" applyOnUpdate="0"/>
    <default field="svg" expression="" applyOnUpdate="0"/>
    <default field="rotation" expression="" applyOnUpdate="0"/>
    <default field="link" expression="" applyOnUpdate="0"/>
    <default field="verified" expression="" applyOnUpdate="0"/>
    <default field="undelete" expression="" applyOnUpdate="0"/>
    <default field="label" expression="" applyOnUpdate="0"/>
    <default field="label_x" expression="" applyOnUpdate="0"/>
    <default field="label_y" expression="" applyOnUpdate="0"/>
    <default field="label_rotation" expression="" applyOnUpdate="0"/>
    <default field="publish" expression="" applyOnUpdate="0"/>
    <default field="inventory" expression="" applyOnUpdate="0"/>
    <default field="uncertain" expression="" applyOnUpdate="0"/>
    <default field="xyz_date" expression="" applyOnUpdate="0"/>
    <default field="unconnected" expression="" applyOnUpdate="0"/>
    <default field="num_value" expression="" applyOnUpdate="0"/>
    <default field="tstamp" expression="" applyOnUpdate="0"/>
    <default field="insert_user" expression="" applyOnUpdate="0"/>
    <default field="lastupdate" expression="" applyOnUpdate="0"/>
    <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" field="node_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="code" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="top_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_top_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_top_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="ymax" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_ymax" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_ymax" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="custom_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sys_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="node_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="sys_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="nodecat_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="matcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="epa_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="expl_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="macroexpl_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrosector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="annotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="observ" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="comment" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="dma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrodma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="soilcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="function_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="category_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="fluid_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="location_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id_end" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="buildercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="builtdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="enddate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="ownercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="muni_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcode" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="district_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="descript" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="svg" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="link" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="verified" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="undelete" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_x" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_y" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="publish" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="inventory" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="uncertain" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="xyz_date" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="unconnected" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="num_value" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="tstamp" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="insert_user" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate_user" notnull_strength="2" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="node_id" desc="" exp=""/>
    <constraint field="code" desc="" exp=""/>
    <constraint field="top_elev" desc="" exp=""/>
    <constraint field="custom_top_elev" desc="" exp=""/>
    <constraint field="sys_top_elev" desc="" exp=""/>
    <constraint field="ymax" desc="" exp=""/>
    <constraint field="custom_ymax" desc="" exp=""/>
    <constraint field="sys_ymax" desc="" exp=""/>
    <constraint field="elev" desc="" exp=""/>
    <constraint field="custom_elev" desc="" exp=""/>
    <constraint field="sys_elev" desc="" exp=""/>
    <constraint field="node_type" desc="" exp=""/>
    <constraint field="sys_type" desc="" exp=""/>
    <constraint field="nodecat_id" desc="" exp=""/>
    <constraint field="matcat_id" desc="" exp=""/>
    <constraint field="epa_type" desc="" exp=""/>
    <constraint field="expl_id" desc="" exp=""/>
    <constraint field="macroexpl_id" desc="" exp=""/>
    <constraint field="sector_id" desc="" exp=""/>
    <constraint field="macrosector_id" desc="" exp=""/>
    <constraint field="state" desc="" exp=""/>
    <constraint field="state_type" desc="" exp=""/>
    <constraint field="annotation" desc="" exp=""/>
    <constraint field="observ" desc="" exp=""/>
    <constraint field="comment" desc="" exp=""/>
    <constraint field="dma_id" desc="" exp=""/>
    <constraint field="macrodma_id" desc="" exp=""/>
    <constraint field="soilcat_id" desc="" exp=""/>
    <constraint field="function_type" desc="" exp=""/>
    <constraint field="category_type" desc="" exp=""/>
    <constraint field="fluid_type" desc="" exp=""/>
    <constraint field="location_type" desc="" exp=""/>
    <constraint field="workcat_id" desc="" exp=""/>
    <constraint field="workcat_id_end" desc="" exp=""/>
    <constraint field="buildercat_id" desc="" exp=""/>
    <constraint field="builtdate" desc="" exp=""/>
    <constraint field="enddate" desc="" exp=""/>
    <constraint field="ownercat_id" desc="" exp=""/>
    <constraint field="muni_id" desc="" exp=""/>
    <constraint field="postcode" desc="" exp=""/>
    <constraint field="district_id" desc="" exp=""/>
    <constraint field="streetname" desc="" exp=""/>
    <constraint field="postnumber" desc="" exp=""/>
    <constraint field="postcomplement" desc="" exp=""/>
    <constraint field="streetname2" desc="" exp=""/>
    <constraint field="postnumber2" desc="" exp=""/>
    <constraint field="postcomplement2" desc="" exp=""/>
    <constraint field="descript" desc="" exp=""/>
    <constraint field="svg" desc="" exp=""/>
    <constraint field="rotation" desc="" exp=""/>
    <constraint field="link" desc="" exp=""/>
    <constraint field="verified" desc="" exp=""/>
    <constraint field="undelete" desc="" exp=""/>
    <constraint field="label" desc="" exp=""/>
    <constraint field="label_x" desc="" exp=""/>
    <constraint field="label_y" desc="" exp=""/>
    <constraint field="label_rotation" desc="" exp=""/>
    <constraint field="publish" desc="" exp=""/>
    <constraint field="inventory" desc="" exp=""/>
    <constraint field="uncertain" desc="" exp=""/>
    <constraint field="xyz_date" desc="" exp=""/>
    <constraint field="unconnected" desc="" exp=""/>
    <constraint field="num_value" desc="" exp=""/>
    <constraint field="tstamp" desc="" exp=""/>
    <constraint field="insert_user" desc="" exp=""/>
    <constraint field="lastupdate" desc="" exp=""/>
    <constraint field="lastupdate_user" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="&quot;node_id&quot;">
    <columns>
      <column type="field" hidden="0" name="node_id" width="-1"/>
      <column type="field" hidden="0" name="code" width="-1"/>
      <column type="field" hidden="0" name="top_elev" width="-1"/>
      <column type="field" hidden="0" name="custom_top_elev" width="-1"/>
      <column type="field" hidden="0" name="ymax" width="-1"/>
      <column type="field" hidden="0" name="custom_ymax" width="-1"/>
      <column type="field" hidden="1" name="elev" width="-1"/>
      <column type="field" hidden="0" name="custom_elev" width="-1"/>
      <column type="field" hidden="0" name="sys_elev" width="-1"/>
      <column type="field" hidden="0" name="node_type" width="-1"/>
      <column type="field" hidden="0" name="sys_type" width="-1"/>
      <column type="field" hidden="0" name="nodecat_id" width="142"/>
      <column type="field" hidden="1" name="cat_matcat_id" width="-1"/>
      <column type="field" hidden="0" name="epa_type" width="-1"/>
      <column type="field" hidden="0" name="sector_id" width="-1"/>
      <column type="field" hidden="1" name="macrosector_id" width="-1"/>
      <column type="field" hidden="0" name="state" width="-1"/>
      <column type="field" hidden="0" name="state_type" width="-1"/>
      <column type="field" hidden="0" name="annotation" width="-1"/>
      <column type="field" hidden="0" name="observ" width="-1"/>
      <column type="field" hidden="1" name="comment" width="-1"/>
      <column type="field" hidden="0" name="dma_id" width="-1"/>
      <column type="field" hidden="0" name="soilcat_id" width="-1"/>
      <column type="field" hidden="0" name="function_type" width="-1"/>
      <column type="field" hidden="0" name="category_type" width="-1"/>
      <column type="field" hidden="0" name="fluid_type" width="-1"/>
      <column type="field" hidden="0" name="location_type" width="-1"/>
      <column type="field" hidden="0" name="workcat_id" width="-1"/>
      <column type="field" hidden="0" name="workcat_id_end" width="-1"/>
      <column type="field" hidden="1" name="buildercat_id" width="-1"/>
      <column type="field" hidden="0" name="builtdate" width="-1"/>
      <column type="field" hidden="0" name="enddate" width="-1"/>
      <column type="field" hidden="0" name="ownercat_id" width="-1"/>
      <column type="field" hidden="0" name="muni_id" width="139"/>
      <column type="field" hidden="0" name="postcode" width="-1"/>
      <column type="field" hidden="0" name="streetaxis_id" width="264"/>
      <column type="field" hidden="0" name="postnumber" width="-1"/>
      <column type="field" hidden="0" name="postcomplement" width="-1"/>
      <column type="field" hidden="0" name="postcomplement2" width="-1"/>
      <column type="field" hidden="0" name="streetaxis2_id" width="-1"/>
      <column type="field" hidden="0" name="postnumber2" width="-1"/>
      <column type="field" hidden="0" name="descript" width="-1"/>
      <column type="field" hidden="1" name="svg" width="-1"/>
      <column type="field" hidden="0" name="rotation" width="-1"/>
      <column type="field" hidden="0" name="link" width="-1"/>
      <column type="field" hidden="0" name="verified" width="-1"/>
      <column type="field" hidden="1" name="undelete" width="-1"/>
      <column type="field" hidden="0" name="label_x" width="-1"/>
      <column type="field" hidden="0" name="label_y" width="-1"/>
      <column type="field" hidden="0" name="label_rotation" width="-1"/>
      <column type="field" hidden="1" name="publish" width="-1"/>
      <column type="field" hidden="1" name="inventory" width="-1"/>
      <column type="field" hidden="0" name="uncertain" width="-1"/>
      <column type="field" hidden="0" name="xyz_date" width="-1"/>
      <column type="field" hidden="0" name="unconnected" width="-1"/>
      <column type="field" hidden="1" name="macrodma_id" width="-1"/>
      <column type="field" hidden="0" name="expl_id" width="-1"/>
      <column type="field" hidden="1" name="num_value" width="-1"/>
      <column type="actions" hidden="1" width="-1"/>
      <column type="field" hidden="0" name="sys_top_elev" width="-1"/>
      <column type="field" hidden="0" name="sys_ymax" width="-1"/>
      <column type="field" hidden="0" name="lastupdate" width="-1"/>
      <column type="field" hidden="0" name="lastupdate_user" width="-1"/>
      <column type="field" hidden="0" name="insert_user" width="-1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit>formOpen</editforminit>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="annotation"/>
    <field editable="1" name="buildercat_id"/>
    <field editable="1" name="builtdate"/>
    <field editable="0" name="cat_matcat_id"/>
    <field editable="1" name="category_type"/>
    <field editable="1" name="code"/>
    <field editable="1" name="comment"/>
    <field editable="1" name="custom_elev"/>
    <field editable="1" name="custom_top_elev"/>
    <field editable="1" name="custom_ymax"/>
    <field editable="1" name="descript"/>
    <field editable="1" name="dma_id"/>
    <field editable="1" name="elev"/>
    <field editable="1" name="enddate"/>
    <field editable="1" name="epa_type"/>
    <field editable="1" name="expl_id"/>
    <field editable="1" name="fluid_type"/>
    <field editable="1" name="function_type"/>
    <field editable="1" name="insert_user"/>
    <field editable="1" name="inventory"/>
    <field editable="0" name="label"/>
    <field editable="1" name="label_rotation"/>
    <field editable="1" name="label_x"/>
    <field editable="1" name="label_y"/>
    <field editable="0" name="lastupdate"/>
    <field editable="0" name="lastupdate_user"/>
    <field editable="0" name="link"/>
    <field editable="1" name="location_type"/>
    <field editable="0" name="macrodma_id"/>
    <field editable="1" name="macroexpl_id"/>
    <field editable="0" name="macrosector_id"/>
    <field editable="0" name="matcat_id"/>
    <field editable="1" name="muni_id"/>
    <field editable="0" name="node_id"/>
    <field editable="0" name="node_type"/>
    <field editable="1" name="nodecat_id"/>
    <field editable="1" name="num_value"/>
    <field editable="1" name="observ"/>
    <field editable="1" name="ownercat_id"/>
    <field editable="1" name="postcode"/>
    <field editable="1" name="postcomplement"/>
    <field editable="1" name="postcomplement2"/>
    <field editable="1" name="postnumber"/>
    <field editable="1" name="postnumber2"/>
    <field editable="1" name="publish"/>
    <field editable="1" name="rotation"/>
    <field editable="1" name="sector_id"/>
    <field editable="1" name="soilcat_id"/>
    <field editable="1" name="state"/>
    <field editable="1" name="state_type"/>
    <field editable="1" name="streetaxis2_id"/>
    <field editable="1" name="streetaxis_id"/>
    <field editable="1" name="streetname"/>
    <field editable="1" name="streetname2"/>
    <field editable="1" name="svg"/>
    <field editable="0" name="sys_elev"/>
    <field editable="0" name="sys_top_elev"/>
    <field editable="1" name="sys_type"/>
    <field editable="0" name="sys_ymax"/>
    <field editable="1" name="top_elev"/>
    <field editable="1" name="tstamp"/>
    <field editable="1" name="uncertain"/>
    <field editable="1" name="unconnected"/>
    <field editable="1" name="undelete"/>
    <field editable="1" name="verified"/>
    <field editable="1" name="workcat_id"/>
    <field editable="1" name="workcat_id_end"/>
    <field editable="1" name="xyz_date"/>
    <field editable="1" name="ymax"/>
  </editable>
  <labelOnTop>
    <field name="annotation" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="cat_matcat_id" labelOnTop="0"/>
    <field name="category_type" labelOnTop="0"/>
    <field name="code" labelOnTop="0"/>
    <field name="comment" labelOnTop="0"/>
    <field name="custom_elev" labelOnTop="0"/>
    <field name="custom_top_elev" labelOnTop="0"/>
    <field name="custom_ymax" labelOnTop="0"/>
    <field name="descript" labelOnTop="0"/>
    <field name="dma_id" labelOnTop="0"/>
    <field name="elev" labelOnTop="0"/>
    <field name="enddate" labelOnTop="0"/>
    <field name="epa_type" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="fluid_type" labelOnTop="0"/>
    <field name="function_type" labelOnTop="0"/>
    <field name="insert_user" labelOnTop="0"/>
    <field name="inventory" labelOnTop="0"/>
    <field name="label_rotation" labelOnTop="0"/>
    <field name="label_x" labelOnTop="0"/>
    <field name="label_y" labelOnTop="0"/>
    <field name="lastupdate" labelOnTop="0"/>
    <field name="lastupdate_user" labelOnTop="0"/>
    <field name="link" labelOnTop="0"/>
    <field name="location_type" labelOnTop="0"/>
    <field name="macrodma_id" labelOnTop="0"/>
    <field name="macrosector_id" labelOnTop="0"/>
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
    <field name="streetaxis2_id" labelOnTop="0"/>
    <field name="streetaxis_id" labelOnTop="0"/>
    <field name="svg" labelOnTop="0"/>
    <field name="sys_elev" labelOnTop="0"/>
    <field name="sys_top_elev" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="sys_ymax" labelOnTop="0"/>
    <field name="top_elev" labelOnTop="0"/>
    <field name="uncertain" labelOnTop="0"/>
    <field name="unconnected" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
    <field name="xyz_date" labelOnTop="0"/>
    <field name="ymax" labelOnTop="0"/>
  </labelOnTop>
  <widgets>
    <widget name="Capa unida_name">
      <config/>
    </widget>
    <widget name="Capa unida_postnumb_1">
      <config/>
    </widget>
  </widgets>
  <previewExpression>depth : [% "ymax" %]</previewExpression>
  <mapTip>depth : [% "ymax" %]</mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('105', 'v_edit_gully', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" labelsEnabled="1" simplifyDrawingHints="0" minScale="1500" simplifyLocal="1" simplifyMaxScale="1" maxScale="1" readOnly="0" version="3.10.3-A Coruña" hasScaleBasedVisibilityFlag="1" simplifyAlgorithm="0" styleCategories="AllStyleCategories">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" type="singleSymbol" symbollevels="0" enableorderby="0">
    <symbols>
      <symbol force_rhr="0" type="marker" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,0" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="65,62,62,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="1.6" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fontCapitals="0" textColor="90,90,90,255" fontItalic="0" fontStrikeout="0" fontWordSpacing="0" fontSize="8" fontWeight="50" fontSizeMapUnitScale="3x:0,0,0,0,0,0" useSubstitutions="0" fontUnderline="0" textOrientation="horizontal" fontKerning="1" textOpacity="1" fontLetterSpacing="0" isExpression="1" namedStyle="Normal" fontSizeUnit="Point" multilineHeight="1" fontFamily="Arial" fieldName="CASE WHEN  label_x =  5 THEN '    ' ||   &quot;gully_id&quot;   &#xa;ELSE   &quot;gully_id&quot;   || '    '  END" previewBkgrdColor="255,255,255,255" blendMode="0">
        <text-buffer bufferSize="1" bufferOpacity="1" bufferNoFill="1" bufferDraw="0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferBlendMode="0" bufferJoinStyle="128"/>
        <background shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeJoinStyle="64" shapeSizeY="0" shapeOpacity="1" shapeRotation="0" shapeBorderColor="128,128,128,255" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetY="0" shapeOffsetX="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiX="0" shapeRadiiY="0" shapeSizeX="0" shapeRadiiUnit="MM" shapeDraw="0" shapeFillColor="255,255,255,255" shapeBorderWidth="0" shapeSizeUnit="MM" shapeSizeType="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBlendMode="0" shapeRotationType="0" shapeSVGFile="" shapeOffsetUnit="MM" shapeType="0" shapeBorderWidthUnit="MM"/>
        <shadow shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1" shadowUnder="0" shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255" shadowRadius="1.5" shadowOffsetUnit="MM" shadowOffsetDist="1" shadowRadiusUnit="MM" shadowOpacity="0.7" shadowScale="100" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetAngle="135" shadowDraw="0" shadowBlendMode="6"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" value="" name="name"/>
            <Option type="Map" name="properties">
              <Option type="Map" name="LabelRotation">
                <Option type="bool" value="true" name="active"/>
                <Option type="QString" value="label_rotation" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
              <Option type="Map" name="OffsetQuad">
                <Option type="bool" value="true" name="active"/>
                <Option type="QString" value="label_x" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
              <Option type="Map" name="PositionX">
                <Option type="bool" value="false" name="active"/>
                <Option type="QString" value="num_value" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
              <Option type="Map" name="PositionY">
                <Option type="bool" value="false" name="active"/>
                <Option type="QString" value="num_value" name="field"/>
                <Option type="int" value="2" name="type"/>
              </Option>
            </Option>
            <Option type="QString" value="collection" name="type"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format autoWrapLength="0" rightDirectionSymbol=">" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0" decimals="3" wrapChar="" reverseDirectionSymbol="0" plussign="0" leftDirectionSymbol="&lt;" multilineAlign="3" addDirectionSymbol="0" formatNumbers="0"/>
      <placement centroidWhole="0" offsetType="0" layerType="UnknownGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" preserveRotation="0" maxCurvedCharAngleIn="25" placementFlags="10" centroidInside="0" distUnits="MM" priority="5" overrunDistanceUnit="MM" yOffset="0" maxCurvedCharAngleOut="-25" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" offsetUnits="MM" geometryGenerator="" overrunDistance="0" rotationAngle="0" geometryGeneratorEnabled="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" dist="0" placement="1" fitInPolygonOnly="0" repeatDistanceUnits="MM" distMapUnitScale="3x:0,0,0,0,0,0" xOffset="0" repeatDistance="0" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" quadOffset="4" geometryGeneratorType="PointGeometry"/>
      <rendering obstacleFactor="1" obstacleType="0" obstacle="1" drawLabels="1" scaleVisibility="1" zIndex="0" limitNumLabels="0" maxNumLabels="2000" scaleMax="250" labelPerPart="0" fontMinPixelSize="3" minFeatureSize="0" fontLimitPixelSize="0" fontMaxPixelSize="10000" scaleMin="0" displayAll="0" mergeLines="0" upsidedownLabels="0"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" value="" name="name"/>
          <Option type="Map" name="properties">
            <Option type="Map" name="LabelRotation">
              <Option type="bool" value="true" name="active"/>
              <Option type="QString" value="label_rotation" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
            <Option type="Map" name="OffsetQuad">
              <Option type="bool" value="true" name="active"/>
              <Option type="QString" value="label_x" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
            <Option type="Map" name="PositionX">
              <Option type="bool" value="false" name="active"/>
              <Option type="QString" value="num_value" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
            <Option type="Map" name="PositionY">
              <Option type="bool" value="false" name="active"/>
              <Option type="QString" value="num_value" name="field"/>
              <Option type="int" value="2" name="type"/>
            </Option>
          </Option>
          <Option type="QString" value="collection" name="type"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" value="pole_of_inaccessibility" name="anchorPoint"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" value="" name="name"/>
            <Option name="properties"/>
            <Option type="QString" value="collection" name="type"/>
          </Option>
          <Option type="bool" value="false" name="drawToAllParts"/>
          <Option type="QString" value="0" name="enabled"/>
          <Option type="QString" value="&lt;symbol force_rhr=&quot;0&quot; type=&quot;line&quot; clip_to_extent=&quot;1&quot; alpha=&quot;1&quot; name=&quot;symbol&quot;>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; pass=&quot;0&quot;>&lt;prop v=&quot;square&quot; k=&quot;capstyle&quot;/>&lt;prop v=&quot;5;2&quot; k=&quot;customdash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;customdash_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;customdash_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;draw_inside_polygon&quot;/>&lt;prop v=&quot;bevel&quot; k=&quot;joinstyle&quot;/>&lt;prop v=&quot;60,60,60,255&quot; k=&quot;line_color&quot;/>&lt;prop v=&quot;solid&quot; k=&quot;line_style&quot;/>&lt;prop v=&quot;0.3&quot; k=&quot;line_width&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;line_width_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;offset&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;offset_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;offset_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;ring_filter&quot;/>&lt;prop v=&quot;0&quot; k=&quot;use_custom_dash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;width_map_unit_scale&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; value=&quot;&quot; name=&quot;name&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; value=&quot;collection&quot; name=&quot;type&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol"/>
          <Option type="double" value="0" name="minLength"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale"/>
          <Option type="QString" value="MM" name="minLengthUnit"/>
          <Option type="double" value="0" name="offsetFromAnchor"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromAnchorUnit"/>
          <Option type="double" value="0" name="offsetFromLabel"/>
          <Option type="QString" value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale"/>
          <Option type="QString" value="MM" name="offsetFromLabelUnit"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <customproperties>
    <property value="COALESCE(&quot;netel_descript&quot;, '&lt;NULL>')" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" rotationOffset="270" height="15" barWidth="5" minimumSize="0" minScaleDenominator="1" sizeScale="3x:0,0,0,0,0,0" backgroundColor="#ffffff" diagramOrientation="Up" maxScaleDenominator="1e+08" lineSizeType="MM" penWidth="0" penAlpha="255" width="15" scaleBasedVisibility="0" backgroundAlpha="255" sizeType="MM" penColor="#000000" enabled="0" opacity="1" scaleDependency="Area" labelPlacementMethod="XHeight">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute field="" color="#000000" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings priority="0" obstacle="0" dist="0" linePlacementFlags="2" zIndex="0" showAll="1" placement="0">
    <properties>
      <Option type="Map">
        <Option type="QString" value="" name="name"/>
        <Option name="properties"/>
        <Option type="QString" value="collection" name="type"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="gully_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="top_elev">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ymax">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sandbox">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="matcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gully_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="GULLY" name="GULLY"/>
              <Option type="QString" value="PGULLY" name="PGULLY"/>
              <Option type="QString" value="VGULLY" name="VGULLY"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gratecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_grate_matcat">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="units">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="groove">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="siphon">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_arccat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_length">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_depth">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arc_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="expl_01"/>
              <Option type="QString" value="2" name="expl_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="sector_01"/>
              <Option type="QString" value="2" name="sector_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="0" name="OBSOLETE"/>
              <Option type="QString" value="1" name="ON_SERVICE"/>
              <Option type="QString" value="2" name="PLANIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="95" name="CANCELED FICTICIOUS"/>
              <Option type="QString" value="96" name="CANCELED PLANIFIED"/>
              <Option type="QString" value="97" name="DONE FICTICIOUS"/>
              <Option type="QString" value="98" name="DONE PLANIFIED"/>
              <Option type="QString" value="99" name="FICTICIUS"/>
              <Option type="QString" value="1" name="OBSOLETE"/>
              <Option type="QString" value="2" name="ON_SERVICE"/>
              <Option type="QString" value="3" name="PLANIFIED"/>
              <Option type="QString" value="5" name="PROVISIONAL"/>
              <Option type="QString" value="4" name="RECONSTRUCT"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="dma_01"/>
              <Option type="QString" value="3" name="dma_02"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="soil1" name="soil1"/>
              <Option type="QString" value="soil2" name="soil2"/>
              <Option type="QString" value="soil3" name="soil3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Function" name="St. Function"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Category" name="St. Category"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Fluid" name="St. Fluid"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="St. Location" name="St. Location"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="builder1" name="builder1"/>
              <Option type="QString" value="builder2" name="builder2"/>
              <Option type="QString" value="builder3" name="builder3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="owner1" name="owner1"/>
              <Option type="QString" value="owner2" name="owner2"/>
              <Option type="QString" value="owner3" name="owner3"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="1" name="Sant Boi del Llobregat"/>
              <Option type="QString" value="2" name="Sant Esteve de les Roures"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="streetname">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="svg">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" value="" name=""/>
              <Option type="QString" value="TO REVIEW" name="TO REVIEW"/>
              <Option type="QString" value="VERIFIED" name="VERIFIED"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_x">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="uncertain">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="featurecat_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pjoint_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pjoint_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="insert_user">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" value="false" name="IsMultiline"/>
            <Option type="bool" value="false" name="UseHtml"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="gully_id" index="0" name="gully_id"/>
    <alias field="code" index="1" name="code"/>
    <alias field="top_elev" index="2" name="top_elev"/>
    <alias field="ymax" index="3" name="ymax"/>
    <alias field="sandbox" index="4" name="sandbox"/>
    <alias field="matcat_id" index="5" name="matcat_id"/>
    <alias field="gully_type" index="6" name="gully_type"/>
    <alias field="sys_type" index="7" name=""/>
    <alias field="gratecat_id" index="8" name="gratecat_id"/>
    <alias field="cat_grate_matcat" index="9" name="cat_grate_matcat"/>
    <alias field="units" index="10" name="units"/>
    <alias field="groove" index="11" name="groove"/>
    <alias field="siphon" index="12" name="siphon"/>
    <alias field="connec_arccat_id" index="13" name="connec_arccat_id"/>
    <alias field="connec_length" index="14" name="connec_length"/>
    <alias field="connec_depth" index="15" name="connec_depth"/>
    <alias field="arc_id" index="16" name="arc_id"/>
    <alias field="expl_id" index="17" name="expl_id"/>
    <alias field="macroexpl_id" index="18" name="Macroexploitation"/>
    <alias field="sector_id" index="19" name="sector_id"/>
    <alias field="macrosector_id" index="20" name="macrosector_id"/>
    <alias field="state" index="21" name="state"/>
    <alias field="state_type" index="22" name="state_type"/>
    <alias field="annotation" index="23" name="annotation"/>
    <alias field="observ" index="24" name="observ"/>
    <alias field="comment" index="25" name="comment"/>
    <alias field="dma_id" index="26" name="dma_id"/>
    <alias field="macrodma_id" index="27" name="macrodma_id"/>
    <alias field="soilcat_id" index="28" name="soilcat_id"/>
    <alias field="function_type" index="29" name="function_type"/>
    <alias field="category_type" index="30" name="category_type"/>
    <alias field="fluid_type" index="31" name="fluid_type"/>
    <alias field="location_type" index="32" name="location_type"/>
    <alias field="workcat_id" index="33" name="workcat_id"/>
    <alias field="workcat_id_end" index="34" name="workcat_id_end"/>
    <alias field="buildercat_id" index="35" name="buildercat_id"/>
    <alias field="builtdate" index="36" name="builtdate"/>
    <alias field="enddate" index="37" name="enddate"/>
    <alias field="ownercat_id" index="38" name="ownercat_id"/>
    <alias field="muni_id" index="39" name="muni_id"/>
    <alias field="postcode" index="40" name="postcode"/>
    <alias field="district_id" index="41" name=""/>
    <alias field="streetname" index="42" name="streetname"/>
    <alias field="postnumber" index="43" name="postnumber"/>
    <alias field="postcomplement" index="44" name="postcomplement"/>
    <alias field="streetname2" index="45" name="streetname2"/>
    <alias field="postnumber2" index="46" name="postnumber2"/>
    <alias field="postcomplement2" index="47" name="postcomplement2"/>
    <alias field="descript" index="48" name="descript"/>
    <alias field="svg" index="49" name="svg"/>
    <alias field="rotation" index="50" name="rotation"/>
    <alias field="link" index="51" name="link"/>
    <alias field="verified" index="52" name="verified"/>
    <alias field="undelete" index="53" name="undelete"/>
    <alias field="label" index="54" name="Catalog label"/>
    <alias field="label_x" index="55" name="label_x"/>
    <alias field="label_y" index="56" name="label_y"/>
    <alias field="label_rotation" index="57" name="label_rotation"/>
    <alias field="publish" index="58" name="publish"/>
    <alias field="inventory" index="59" name="inventory"/>
    <alias field="uncertain" index="60" name="uncertain"/>
    <alias field="num_value" index="61" name="num_value"/>
    <alias field="feature_id" index="62" name="feature_id"/>
    <alias field="featurecat_id" index="63" name="featurecat_id"/>
    <alias field="pjoint_id" index="64" name="pjoint_id"/>
    <alias field="pjoint_type" index="65" name="pjoint_type"/>
    <alias field="tstamp" index="66" name="Insert tstamp"/>
    <alias field="insert_user" index="67" name=""/>
    <alias field="lastupdate" index="68" name="Last update"/>
    <alias field="lastupdate_user" index="69" name="Last update user"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="gully_id" expression="" applyOnUpdate="0"/>
    <default field="code" expression="" applyOnUpdate="0"/>
    <default field="top_elev" expression="" applyOnUpdate="0"/>
    <default field="ymax" expression="" applyOnUpdate="0"/>
    <default field="sandbox" expression="" applyOnUpdate="0"/>
    <default field="matcat_id" expression="" applyOnUpdate="0"/>
    <default field="gully_type" expression="" applyOnUpdate="0"/>
    <default field="sys_type" expression="" applyOnUpdate="0"/>
    <default field="gratecat_id" expression="" applyOnUpdate="0"/>
    <default field="cat_grate_matcat" expression="" applyOnUpdate="0"/>
    <default field="units" expression="" applyOnUpdate="0"/>
    <default field="groove" expression="" applyOnUpdate="0"/>
    <default field="siphon" expression="" applyOnUpdate="0"/>
    <default field="connec_arccat_id" expression="" applyOnUpdate="0"/>
    <default field="connec_length" expression="" applyOnUpdate="0"/>
    <default field="connec_depth" expression="" applyOnUpdate="0"/>
    <default field="arc_id" expression="" applyOnUpdate="0"/>
    <default field="expl_id" expression="" applyOnUpdate="0"/>
    <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
    <default field="sector_id" expression="" applyOnUpdate="0"/>
    <default field="macrosector_id" expression="" applyOnUpdate="0"/>
    <default field="state" expression="" applyOnUpdate="0"/>
    <default field="state_type" expression="" applyOnUpdate="0"/>
    <default field="annotation" expression="" applyOnUpdate="0"/>
    <default field="observ" expression="" applyOnUpdate="0"/>
    <default field="comment" expression="" applyOnUpdate="0"/>
    <default field="dma_id" expression="" applyOnUpdate="0"/>
    <default field="macrodma_id" expression="" applyOnUpdate="0"/>
    <default field="soilcat_id" expression="" applyOnUpdate="0"/>
    <default field="function_type" expression="" applyOnUpdate="0"/>
    <default field="category_type" expression="" applyOnUpdate="0"/>
    <default field="fluid_type" expression="" applyOnUpdate="0"/>
    <default field="location_type" expression="" applyOnUpdate="0"/>
    <default field="workcat_id" expression="" applyOnUpdate="0"/>
    <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
    <default field="buildercat_id" expression="" applyOnUpdate="0"/>
    <default field="builtdate" expression="" applyOnUpdate="0"/>
    <default field="enddate" expression="" applyOnUpdate="0"/>
    <default field="ownercat_id" expression="" applyOnUpdate="0"/>
    <default field="muni_id" expression="" applyOnUpdate="0"/>
    <default field="postcode" expression="" applyOnUpdate="0"/>
    <default field="district_id" expression="" applyOnUpdate="0"/>
    <default field="streetname" expression="" applyOnUpdate="0"/>
    <default field="postnumber" expression="" applyOnUpdate="0"/>
    <default field="postcomplement" expression="" applyOnUpdate="0"/>
    <default field="streetname2" expression="" applyOnUpdate="0"/>
    <default field="postnumber2" expression="" applyOnUpdate="0"/>
    <default field="postcomplement2" expression="" applyOnUpdate="0"/>
    <default field="descript" expression="" applyOnUpdate="0"/>
    <default field="svg" expression="" applyOnUpdate="0"/>
    <default field="rotation" expression="" applyOnUpdate="0"/>
    <default field="link" expression="" applyOnUpdate="0"/>
    <default field="verified" expression="" applyOnUpdate="0"/>
    <default field="undelete" expression="" applyOnUpdate="0"/>
    <default field="label" expression="" applyOnUpdate="0"/>
    <default field="label_x" expression="" applyOnUpdate="0"/>
    <default field="label_y" expression="" applyOnUpdate="0"/>
    <default field="label_rotation" expression="" applyOnUpdate="0"/>
    <default field="publish" expression="" applyOnUpdate="0"/>
    <default field="inventory" expression="" applyOnUpdate="0"/>
    <default field="uncertain" expression="" applyOnUpdate="0"/>
    <default field="num_value" expression="" applyOnUpdate="0"/>
    <default field="feature_id" expression="" applyOnUpdate="0"/>
    <default field="featurecat_id" expression="" applyOnUpdate="0"/>
    <default field="pjoint_id" expression="" applyOnUpdate="0"/>
    <default field="pjoint_type" expression="" applyOnUpdate="0"/>
    <default field="tstamp" expression="" applyOnUpdate="0"/>
    <default field="insert_user" expression="" applyOnUpdate="0"/>
    <default field="lastupdate" expression="" applyOnUpdate="0"/>
    <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" constraints="3" field="gully_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="code" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="top_elev" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="ymax" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sandbox" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="matcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="gully_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="sys_type" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="gratecat_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="cat_grate_matcat" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="units" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="groove" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="siphon" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="connec_arccat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="connec_length" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="connec_depth" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="arc_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="expl_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="macroexpl_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="sector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrosector_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="state_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="annotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="observ" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="comment" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="dma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="macrodma_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="soilcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="function_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="category_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="fluid_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="location_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="workcat_id_end" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="buildercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="builtdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="enddate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="ownercat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="muni_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcode" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="district_id" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="streetname2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postnumber2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="postcomplement2" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="descript" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="svg" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="link" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="verified" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="undelete" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_x" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_y" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="label_rotation" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="publish" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="inventory" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="uncertain" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="num_value" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="feature_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="featurecat_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="pjoint_id" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="pjoint_type" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="tstamp" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="0" field="insert_user" notnull_strength="0" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate" notnull_strength="2" exp_strength="0"/>
    <constraint unique_strength="0" constraints="1" field="lastupdate_user" notnull_strength="2" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="gully_id" desc="" exp=""/>
    <constraint field="code" desc="" exp=""/>
    <constraint field="top_elev" desc="" exp=""/>
    <constraint field="ymax" desc="" exp=""/>
    <constraint field="sandbox" desc="" exp=""/>
    <constraint field="matcat_id" desc="" exp=""/>
    <constraint field="gully_type" desc="" exp=""/>
    <constraint field="sys_type" desc="" exp=""/>
    <constraint field="gratecat_id" desc="" exp=""/>
    <constraint field="cat_grate_matcat" desc="" exp=""/>
    <constraint field="units" desc="" exp=""/>
    <constraint field="groove" desc="" exp=""/>
    <constraint field="siphon" desc="" exp=""/>
    <constraint field="connec_arccat_id" desc="" exp=""/>
    <constraint field="connec_length" desc="" exp=""/>
    <constraint field="connec_depth" desc="" exp=""/>
    <constraint field="arc_id" desc="" exp=""/>
    <constraint field="expl_id" desc="" exp=""/>
    <constraint field="macroexpl_id" desc="" exp=""/>
    <constraint field="sector_id" desc="" exp=""/>
    <constraint field="macrosector_id" desc="" exp=""/>
    <constraint field="state" desc="" exp=""/>
    <constraint field="state_type" desc="" exp=""/>
    <constraint field="annotation" desc="" exp=""/>
    <constraint field="observ" desc="" exp=""/>
    <constraint field="comment" desc="" exp=""/>
    <constraint field="dma_id" desc="" exp=""/>
    <constraint field="macrodma_id" desc="" exp=""/>
    <constraint field="soilcat_id" desc="" exp=""/>
    <constraint field="function_type" desc="" exp=""/>
    <constraint field="category_type" desc="" exp=""/>
    <constraint field="fluid_type" desc="" exp=""/>
    <constraint field="location_type" desc="" exp=""/>
    <constraint field="workcat_id" desc="" exp=""/>
    <constraint field="workcat_id_end" desc="" exp=""/>
    <constraint field="buildercat_id" desc="" exp=""/>
    <constraint field="builtdate" desc="" exp=""/>
    <constraint field="enddate" desc="" exp=""/>
    <constraint field="ownercat_id" desc="" exp=""/>
    <constraint field="muni_id" desc="" exp=""/>
    <constraint field="postcode" desc="" exp=""/>
    <constraint field="district_id" desc="" exp=""/>
    <constraint field="streetname" desc="" exp=""/>
    <constraint field="postnumber" desc="" exp=""/>
    <constraint field="postcomplement" desc="" exp=""/>
    <constraint field="streetname2" desc="" exp=""/>
    <constraint field="postnumber2" desc="" exp=""/>
    <constraint field="postcomplement2" desc="" exp=""/>
    <constraint field="descript" desc="" exp=""/>
    <constraint field="svg" desc="" exp=""/>
    <constraint field="rotation" desc="" exp=""/>
    <constraint field="link" desc="" exp=""/>
    <constraint field="verified" desc="" exp=""/>
    <constraint field="undelete" desc="" exp=""/>
    <constraint field="label" desc="" exp=""/>
    <constraint field="label_x" desc="" exp=""/>
    <constraint field="label_y" desc="" exp=""/>
    <constraint field="label_rotation" desc="" exp=""/>
    <constraint field="publish" desc="" exp=""/>
    <constraint field="inventory" desc="" exp=""/>
    <constraint field="uncertain" desc="" exp=""/>
    <constraint field="num_value" desc="" exp=""/>
    <constraint field="feature_id" desc="" exp=""/>
    <constraint field="featurecat_id" desc="" exp=""/>
    <constraint field="pjoint_id" desc="" exp=""/>
    <constraint field="pjoint_type" desc="" exp=""/>
    <constraint field="tstamp" desc="" exp=""/>
    <constraint field="insert_user" desc="" exp=""/>
    <constraint field="lastupdate" desc="" exp=""/>
    <constraint field="lastupdate_user" desc="" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="&quot;gratecat_id&quot;">
    <columns>
      <column type="field" hidden="0" name="gully_id" width="-1"/>
      <column type="field" hidden="0" name="code" width="-1"/>
      <column type="field" hidden="0" name="top_elev" width="-1"/>
      <column type="field" hidden="0" name="ymax" width="-1"/>
      <column type="field" hidden="0" name="sandbox" width="-1"/>
      <column type="field" hidden="0" name="matcat_id" width="-1"/>
      <column type="field" hidden="0" name="gully_type" width="-1"/>
      <column type="field" hidden="0" name="sys_type" width="-1"/>
      <column type="field" hidden="0" name="gratecat_id" width="-1"/>
      <column type="field" hidden="0" name="cat_grate_matcat" width="-1"/>
      <column type="field" hidden="0" name="units" width="-1"/>
      <column type="field" hidden="0" name="groove" width="-1"/>
      <column type="field" hidden="0" name="siphon" width="-1"/>
      <column type="field" hidden="0" name="connec_arccat_id" width="-1"/>
      <column type="field" hidden="1" name="connec_length" width="-1"/>
      <column type="field" hidden="0" name="connec_depth" width="-1"/>
      <column type="field" hidden="0" name="arc_id" width="-1"/>
      <column type="field" hidden="0" name="sector_id" width="-1"/>
      <column type="field" hidden="1" name="macrosector_id" width="-1"/>
      <column type="field" hidden="0" name="state" width="-1"/>
      <column type="field" hidden="0" name="state_type" width="-1"/>
      <column type="field" hidden="0" name="annotation" width="-1"/>
      <column type="field" hidden="0" name="observ" width="-1"/>
      <column type="field" hidden="1" name="comment" width="-1"/>
      <column type="field" hidden="0" name="dma_id" width="-1"/>
      <column type="field" hidden="0" name="soilcat_id" width="-1"/>
      <column type="field" hidden="0" name="function_type" width="-1"/>
      <column type="field" hidden="0" name="category_type" width="-1"/>
      <column type="field" hidden="0" name="fluid_type" width="-1"/>
      <column type="field" hidden="0" name="location_type" width="-1"/>
      <column type="field" hidden="0" name="workcat_id" width="-1"/>
      <column type="field" hidden="0" name="workcat_id_end" width="-1"/>
      <column type="field" hidden="1" name="buildercat_id" width="-1"/>
      <column type="field" hidden="0" name="builtdate" width="-1"/>
      <column type="field" hidden="0" name="enddate" width="-1"/>
      <column type="field" hidden="0" name="ownercat_id" width="-1"/>
      <column type="field" hidden="0" name="muni_id" width="-1"/>
      <column type="field" hidden="0" name="postcode" width="-1"/>
      <column type="field" hidden="0" name="streetaxis_id" width="215"/>
      <column type="field" hidden="0" name="postnumber" width="-1"/>
      <column type="field" hidden="0" name="postcomplement" width="-1"/>
      <column type="field" hidden="0" name="postcomplement2" width="-1"/>
      <column type="field" hidden="0" name="streetaxis2_id" width="-1"/>
      <column type="field" hidden="0" name="postnumber2" width="-1"/>
      <column type="field" hidden="0" name="descript" width="-1"/>
      <column type="field" hidden="1" name="svg" width="-1"/>
      <column type="field" hidden="0" name="rotation" width="-1"/>
      <column type="field" hidden="0" name="link" width="-1"/>
      <column type="field" hidden="0" name="verified" width="-1"/>
      <column type="field" hidden="1" name="undelete" width="-1"/>
      <column type="field" hidden="1" name="featurecat_id" width="-1"/>
      <column type="field" hidden="1" name="feature_id" width="-1"/>
      <column type="field" hidden="0" name="label_x" width="-1"/>
      <column type="field" hidden="0" name="label_y" width="-1"/>
      <column type="field" hidden="0" name="label_rotation" width="-1"/>
      <column type="field" hidden="1" name="publish" width="-1"/>
      <column type="field" hidden="1" name="inventory" width="-1"/>
      <column type="field" hidden="0" name="expl_id" width="-1"/>
      <column type="field" hidden="1" name="macrodma_id" width="-1"/>
      <column type="field" hidden="0" name="uncertain" width="-1"/>
      <column type="field" hidden="1" name="num_value" width="-1"/>
      <column type="actions" hidden="1" width="-1"/>
      <column type="field" hidden="0" name="label" width="-1"/>
      <column type="field" hidden="0" name="pjoint_type" width="-1"/>
      <column type="field" hidden="0" name="pjoint_id" width="-1"/>
      <column type="field" hidden="0" name="lastupdate" width="138"/>
      <column type="field" hidden="0" name="lastupdate_user" width="-1"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1"></editform>
  <editforminit>formOpen</editforminit>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="annotation"/>
    <field editable="1" name="arc_id"/>
    <field editable="1" name="buildercat_id"/>
    <field editable="1" name="builtdate"/>
    <field editable="0" name="cat_grate_matcat"/>
    <field editable="1" name="category_type"/>
    <field editable="1" name="code"/>
    <field editable="1" name="comment"/>
    <field editable="1" name="connec_arccat_id"/>
    <field editable="1" name="connec_depth"/>
    <field editable="1" name="connec_length"/>
    <field editable="1" name="descript"/>
    <field editable="1" name="dma_id"/>
    <field editable="1" name="enddate"/>
    <field editable="1" name="expl_id"/>
    <field editable="0" name="feature_id"/>
    <field editable="0" name="featurecat_id"/>
    <field editable="1" name="fluid_type"/>
    <field editable="1" name="function_type"/>
    <field editable="1" name="gratecat_id"/>
    <field editable="1" name="groove"/>
    <field editable="1" name="gully_id"/>
    <field editable="0" name="gully_type"/>
    <field editable="1" name="inventory"/>
    <field editable="0" name="label"/>
    <field editable="1" name="label_rotation"/>
    <field editable="1" name="label_x"/>
    <field editable="1" name="label_y"/>
    <field editable="0" name="lastupdate"/>
    <field editable="0" name="lastupdate_user"/>
    <field editable="0" name="link"/>
    <field editable="1" name="location_type"/>
    <field editable="1" name="macrodma_id"/>
    <field editable="1" name="macroexpl_id"/>
    <field editable="0" name="macrosector_id"/>
    <field editable="0" name="matcat_id"/>
    <field editable="1" name="muni_id"/>
    <field editable="1" name="num_value"/>
    <field editable="1" name="observ"/>
    <field editable="1" name="ownercat_id"/>
    <field editable="0" name="pjoint_id"/>
    <field editable="0" name="pjoint_type"/>
    <field editable="1" name="postcode"/>
    <field editable="1" name="postcomplement"/>
    <field editable="1" name="postcomplement2"/>
    <field editable="1" name="postnumber"/>
    <field editable="1" name="postnumber2"/>
    <field editable="1" name="publish"/>
    <field editable="1" name="rotation"/>
    <field editable="1" name="sandbox"/>
    <field editable="1" name="sector_id"/>
    <field editable="1" name="siphon"/>
    <field editable="1" name="soilcat_id"/>
    <field editable="1" name="state"/>
    <field editable="1" name="state_type"/>
    <field editable="1" name="streetaxis2_id"/>
    <field editable="1" name="streetaxis_id"/>
    <field editable="1" name="streetname"/>
    <field editable="1" name="streetname2"/>
    <field editable="1" name="svg"/>
    <field editable="1" name="sys_type"/>
    <field editable="1" name="top_elev"/>
    <field editable="1" name="tstamp"/>
    <field editable="1" name="uncertain"/>
    <field editable="1" name="undelete"/>
    <field editable="1" name="units"/>
    <field editable="1" name="verified"/>
    <field editable="1" name="workcat_id"/>
    <field editable="1" name="workcat_id_end"/>
    <field editable="1" name="ymax"/>
  </editable>
  <labelOnTop>
    <field name="annotation" labelOnTop="0"/>
    <field name="arc_id" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="cat_grate_matcat" labelOnTop="0"/>
    <field name="category_type" labelOnTop="0"/>
    <field name="code" labelOnTop="0"/>
    <field name="comment" labelOnTop="0"/>
    <field name="connec_arccat_id" labelOnTop="0"/>
    <field name="connec_depth" labelOnTop="0"/>
    <field name="connec_length" labelOnTop="0"/>
    <field name="descript" labelOnTop="0"/>
    <field name="dma_id" labelOnTop="0"/>
    <field name="enddate" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="feature_id" labelOnTop="0"/>
    <field name="featurecat_id" labelOnTop="0"/>
    <field name="fluid_type" labelOnTop="0"/>
    <field name="function_type" labelOnTop="0"/>
    <field name="gratecat_id" labelOnTop="0"/>
    <field name="groove" labelOnTop="0"/>
    <field name="gully_id" labelOnTop="0"/>
    <field name="gully_type" labelOnTop="0"/>
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
    <field name="publish" labelOnTop="0"/>
    <field name="rotation" labelOnTop="0"/>
    <field name="sandbox" labelOnTop="0"/>
    <field name="sector_id" labelOnTop="0"/>
    <field name="siphon" labelOnTop="0"/>
    <field name="soilcat_id" labelOnTop="0"/>
    <field name="state" labelOnTop="0"/>
    <field name="state_type" labelOnTop="0"/>
    <field name="streetaxis2_id" labelOnTop="0"/>
    <field name="streetaxis_id" labelOnTop="0"/>
    <field name="svg" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="top_elev" labelOnTop="0"/>
    <field name="uncertain" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="units" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
    <field name="ymax" labelOnTop="0"/>
  </labelOnTop>
  <widgets>
    <widget name="Arc_builtdate">
      <config/>
    </widget>
    <widget name="Arc_streetaxis_id">
      <config/>
    </widget>
    <widget name="Arc_workcat_id">
      <config/>
    </widget>
    <widget name="adresy_ANG_GRA">
      <config/>
    </widget>
    <widget name="adresy_ANG_RAD">
      <config/>
    </widget>
    <widget name="adresy_CODI_CALLE">
      <config/>
    </widget>
    <widget name="adresy_CODI_POLI">
      <config/>
    </widget>
    <widget name="adresy_CODI_PORT">
      <config/>
    </widget>
    <widget name="adresy_NUM_PORTAL">
      <config/>
    </widget>
    <widget name="claveguero_89_acces">
      <config/>
    </widget>
    <widget name="claveguero_89_aigues_plu">
      <config/>
    </widget>
    <widget name="claveguero_89_clabis">
      <config/>
    </widget>
    <widget name="claveguero_89_clacar">
      <config/>
    </widget>
    <widget name="claveguero_89_clanum">
      <config/>
    </widget>
    <widget name="claveguero_89_codi_admi">
      <config/>
    </widget>
    <widget name="claveguero_89_conca">
      <config/>
    </widget>
    <widget name="claveguero_89_connec_end">
      <config/>
    </widget>
    <widget name="claveguero_89_connec_id">
      <config/>
    </widget>
    <widget name="claveguero_89_connecat_i">
      <config/>
    </widget>
    <widget name="claveguero_89_data_alta">
      <config/>
    </widget>
    <widget name="claveguero_89_data_baixa">
      <config/>
    </widget>
    <widget name="claveguero_89_data_modif">
      <config/>
    </widget>
    <widget name="claveguero_89_data_rev">
      <config/>
    </widget>
    <widget name="claveguero_89_diag">
      <config/>
    </widget>
    <widget name="claveguero_89_dma_id">
      <config/>
    </widget>
    <widget name="claveguero_89_estat">
      <config/>
    </widget>
    <widget name="claveguero_89_expbaixa">
      <config/>
    </widget>
    <widget name="claveguero_89_expedient">
      <config/>
    </widget>
    <widget name="claveguero_89_feature_id">
      <config/>
    </widget>
    <widget name="claveguero_89_featurecat">
      <config/>
    </widget>
    <widget name="claveguero_89_id_node">
      <config/>
    </widget>
    <widget name="claveguero_89_id_tram">
      <config/>
    </widget>
    <widget name="claveguero_89_longitud_c">
      <config/>
    </widget>
    <widget name="claveguero_89_mat_codi_1">
      <config/>
    </widget>
    <widget name="claveguero_89_mat_codi_c">
      <config/>
    </widget>
    <widget name="claveguero_89_material_1">
      <config/>
    </widget>
    <widget name="claveguero_89_material_c">
      <config/>
    </widget>
    <widget name="claveguero_89_ns_project">
      <config/>
    </widget>
    <widget name="claveguero_89_num_conn">
      <config/>
    </widget>
    <widget name="claveguero_89_obs">
      <config/>
    </widget>
    <widget name="claveguero_89_origen_des">
      <config/>
    </widget>
    <widget name="claveguero_89_ot_baixa_p">
      <config/>
    </widget>
    <widget name="claveguero_89_ot_part">
      <config/>
    </widget>
    <widget name="claveguero_89_seccio_c_1">
      <config/>
    </widget>
    <widget name="claveguero_89_seccio_con">
      <config/>
    </widget>
    <widget name="claveguero_89_sector_id">
      <config/>
    </widget>
    <widget name="claveguero_89_sonda_conn">
      <config/>
    </widget>
    <widget name="claveguero_89_sonda_finc">
      <config/>
    </widget>
    <widget name="claveguero_89_state">
      <config/>
    </widget>
    <widget name="claveguero_89_tipus_conn">
      <config/>
    </widget>
    <widget name="claveguero_89_type">
      <config/>
    </widget>
    <widget name="claveguero_89_xgraf">
      <config/>
    </widget>
    <widget name="claveguero_89_y1">
      <config/>
    </widget>
    <widget name="claveguero_89_y2">
      <config/>
    </widget>
    <widget name="claveguero_89_ygraf">
      <config/>
    </widget>
    <widget name="claveguero_89_zgraf">
      <config/>
    </widget>
    <widget name="embornal_89_conca">
      <config/>
    </widget>
    <widget name="embornal_89_data_alta">
      <config/>
    </widget>
    <widget name="embornal_89_data_baixa">
      <config/>
    </widget>
    <widget name="embornal_89_data_rev">
      <config/>
    </widget>
    <widget name="embornal_89_dma_id">
      <config/>
    </widget>
    <widget name="embornal_89_embcar">
      <config/>
    </widget>
    <widget name="embornal_89_embnum">
      <config/>
    </widget>
    <widget name="embornal_89_estat">
      <config/>
    </widget>
    <widget name="embornal_89_expbaixa">
      <config/>
    </widget>
    <widget name="embornal_89_expedient">
      <config/>
    </widget>
    <widget name="embornal_89_extern">
      <config/>
    </widget>
    <widget name="embornal_89_feature_id">
      <config/>
    </widget>
    <widget name="embornal_89_featurecat">
      <config/>
    </widget>
    <widget name="embornal_89_gratecat_i">
      <config/>
    </widget>
    <widget name="embornal_89_gully_id">
      <config/>
    </widget>
    <widget name="embornal_89_id_node">
      <config/>
    </widget>
    <widget name="embornal_89_id_tram">
      <config/>
    </widget>
    <widget name="embornal_89_longitud_c">
      <config/>
    </widget>
    <widget name="embornal_89_material_c">
      <config/>
    </widget>
    <widget name="embornal_89_ns_project">
      <config/>
    </widget>
    <widget name="embornal_89_obs">
      <config/>
    </widget>
    <widget name="embornal_89_ot_baixa_p">
      <config/>
    </widget>
    <widget name="embornal_89_ot_part">
      <config/>
    </widget>
    <widget name="embornal_89_prof_emb">
      <config/>
    </widget>
    <widget name="embornal_89_prof_sor">
      <config/>
    </widget>
    <widget name="embornal_89_rei_alt">
      <config/>
    </widget>
    <widget name="embornal_89_rei_amp">
      <config/>
    </widget>
    <widget name="embornal_89_rei_fab">
      <config/>
    </widget>
    <widget name="embornal_89_rei_mat">
      <config/>
    </widget>
    <widget name="embornal_89_rei_tip">
      <config/>
    </widget>
    <widget name="embornal_89_rotacio">
      <config/>
    </widget>
    <widget name="embornal_89_rotation">
      <config/>
    </widget>
    <widget name="embornal_89_seccio_con">
      <config/>
    </widget>
    <widget name="embornal_89_sector">
      <config/>
    </widget>
    <widget name="embornal_89_sector_id">
      <config/>
    </widget>
    <widget name="embornal_89_sonda_conn">
      <config/>
    </widget>
    <widget name="embornal_89_state">
      <config/>
    </widget>
    <widget name="embornal_89_tip_cai">
      <config/>
    </widget>
    <widget name="embornal_89_tipus">
      <config/>
    </widget>
    <widget name="embornal_89_xgraf">
      <config/>
    </widget>
    <widget name="embornal_89_ygraf">
      <config/>
    </widget>
    <widget name="embornal_89_zgraf">
      <config/>
    </widget>
    <widget name="reixa_89_alt">
      <config/>
    </widget>
    <widget name="reixa_89_ample">
      <config/>
    </widget>
    <widget name="reixa_89_ample_cata">
      <config/>
    </widget>
    <widget name="reixa_89_conca">
      <config/>
    </widget>
    <widget name="reixa_89_data_alta">
      <config/>
    </widget>
    <widget name="reixa_89_data_baixa">
      <config/>
    </widget>
    <widget name="reixa_89_data_rev">
      <config/>
    </widget>
    <widget name="reixa_89_dma_id">
      <config/>
    </widget>
    <widget name="reixa_89_estat">
      <config/>
    </widget>
    <widget name="reixa_89_expbaixa">
      <config/>
    </widget>
    <widget name="reixa_89_expedient">
      <config/>
    </widget>
    <widget name="reixa_89_extern">
      <config/>
    </widget>
    <widget name="reixa_89_feature_id">
      <config/>
    </widget>
    <widget name="reixa_89_featurecat">
      <config/>
    </widget>
    <widget name="reixa_89_gratecat_i">
      <config/>
    </widget>
    <widget name="reixa_89_gully_id">
      <config/>
    </widget>
    <widget name="reixa_89_id_node">
      <config/>
    </widget>
    <widget name="reixa_89_id_tram">
      <config/>
    </widget>
    <widget name="reixa_89_llargada">
      <config/>
    </widget>
    <widget name="reixa_89_longitud_c">
      <config/>
    </widget>
    <widget name="reixa_89_material_c">
      <config/>
    </widget>
    <widget name="reixa_89_ns_project">
      <config/>
    </widget>
    <widget name="reixa_89_numrep">
      <config/>
    </widget>
    <widget name="reixa_89_obs">
      <config/>
    </widget>
    <widget name="reixa_89_ot_baixa_p">
      <config/>
    </widget>
    <widget name="reixa_89_ot_part">
      <config/>
    </widget>
    <widget name="reixa_89_prof_rei">
      <config/>
    </widget>
    <widget name="reixa_89_prof_sor">
      <config/>
    </widget>
    <widget name="reixa_89_rei_fab">
      <config/>
    </widget>
    <widget name="reixa_89_rei_mat">
      <config/>
    </widget>
    <widget name="reixa_89_rei_tip">
      <config/>
    </widget>
    <widget name="reixa_89_reicar">
      <config/>
    </widget>
    <widget name="reixa_89_reinum">
      <config/>
    </widget>
    <widget name="reixa_89_roptation">
      <config/>
    </widget>
    <widget name="reixa_89_rotacio">
      <config/>
    </widget>
    <widget name="reixa_89_rotation">
      <config/>
    </widget>
    <widget name="reixa_89_seccio_con">
      <config/>
    </widget>
    <widget name="reixa_89_sector">
      <config/>
    </widget>
    <widget name="reixa_89_sector_id">
      <config/>
    </widget>
    <widget name="reixa_89_sonda_conn">
      <config/>
    </widget>
    <widget name="reixa_89_state">
      <config/>
    </widget>
    <widget name="reixa_89_tipus">
      <config/>
    </widget>
    <widget name="reixa_89_xgraf">
      <config/>
    </widget>
    <widget name="reixa_89_ygraf">
      <config/>
    </widget>
    <widget name="reixa_89_zgraf">
      <config/>
    </widget>
  </widgets>
  <previewExpression>COALESCE("netel_descript", '&lt;NULL>')</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('106', 'v_anl_flow_arc', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
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
$$ , true) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('107', 'v_anl_flow_connec', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
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
$$ , true) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('108', 'v_anl_flow_gully', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
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
$$ , true) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('109', 'v_anl_flow_node', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
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
$$ , true) ON CONFLICT (id) DO NOTHING;


--2020/07/24

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_grate"]}]'
WHERE id = 'cat_mat_grate';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["gully"]}]'
WHERE id = 'cat_mat_gully';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_arc", "arc"]}]'
WHERE id = 'cat_mat_arc';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_node", "node", "connec"]}]'
WHERE id = 'cat_mat_node';

--2020/07/27
UPDATE config_form_tabs SET orderby = 1 WHERE formname ='v_edit_gully' AND tabname='tab_data';
UPDATE config_form_tabs SET orderby = 2 WHERE formname ='v_edit_gully' AND tabname='tab_elements';
UPDATE config_form_tabs SET orderby = 3 WHERE formname ='v_edit_gully' AND tabname='tab_om';
UPDATE config_form_tabs SET orderby = 4 WHERE formname ='v_edit_gully' AND tabname='tab_visit';
UPDATE config_form_tabs SET orderby = 5 WHERE formname ='v_edit_gully' AND tabname='tab_documents';


INSERT INTO config_toolbox(id, alias, isparametric, functionparams,  active)
VALUES (2986, 'Slope consistency', true, '{"featureType":["arc"]}', true) ON CONFLICT (id) DO NOTHING;

--2020/07/28
UPDATE config_toolbox SET inputparams = '[{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"},
{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":2,"value":0.01},
{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},{"widgetname":"stateType", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":4, 
"dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by state, id", "selectedId":"2","isparent":"true"},{"widgetname":"workcatId", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5, "dvQueryText":"select id as id, id as idval from cat_work where id is not null order by id", "selectedId":"1"},{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":6, "value":null },
{"widgetname":"nodeType", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null", "selectedId":"$userNodetype"},
{"widgetname":"nodeCat", "label":"Node catalog:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8, "dvQueryText":"select distinct id as id, id as idval from cat_node where node_type = $userNodetype  OR node_type is null order by id", "selectedId":"$userNodecat"}]'
WHERE id =2118;

--2020/07/29
UPDATE sys_param_user SET ismandatory=FALSE WHERE id='edit_gully_doublegeom';