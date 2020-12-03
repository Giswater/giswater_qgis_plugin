/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2124,'gw_fct_connect_to_network',NULL,'{"visible": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_arc", "v_edit_link"]}',NULL) ON CONFLICT (id) DO NOTHING;


-- 2020/07/14
UPDATE sys_table SET id = 'config_valve' WHERE id = 'config_mincut_valve';

DELETE FROM sys_param_user WHERE id = 'inp_options_skipdemandpattern';

UPDATE config_toolbox SET inputparams  = 
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"forceOpen", "label":"Force Open nodes:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":false, "placeholder":"[1,2,3]", "value":""},
{"widgetname":"forceClose", "label":"Force Close nodes:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":4,"isMandatory":false, "placeholder":"[1,2,3]", "value":""},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":6,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":8, "isMandatory":false, "placeholder":"5-30", "value":""}]'
WHERE id = 2768;


SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);
 
 SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);

update config_form_fields SET columnname = 'staticpress1' where  columnname = 'staticpressure1';
update config_form_fields SET columnname = 'staticpress2' where  columnname = 'staticpressure2';


-- 2020/07/20
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_arc', 101, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_connec', 102, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_link', 103, 'GW Layers') ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style, group_layer) VALUES('v_edit_node', 104, 'GW Layers') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_table(id, style) VALUES('Overlap affected arcs', 105) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style) VALUES('Overlap affected connecs', 106) ON CONFLICT (id) DO NOTHING;
INSERT INTO config_table(id, style) VALUES('Other mincuts whichs overlaps', 107) ON CONFLICT (id) DO NOTHING;


INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2980, 'gw_fct_setmincut', 'utils', 'function', 'json', 'json', NULL, 'role_edit') ON CONFLICT (id) DO NOTHING;


INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2244,'gw_fct_mincut_result_overlap',
'{"style":{"point":{"style":"qml", "id":"106"},  "line":{"style":"qml", "id":"105"}, "polygon":{"style":"qml", "id":"107"}}}',
'{"visible": ["v_om_mincut_arc", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_initpoint"]}',NULL) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2302,'gw_fct_anl_node_topological_consistency','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL,NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2430,'gw_fct_pg2epa_check_data','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', '{"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2522,'gw_fct_import_epanet_inp',NULL,'{"visible": ["v_edit_arc", "v_edit_node"],"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2706,'gw_fct_grafanalytics_minsector','{"style":{"point":{"style":"random","field":"fid","width":2,"transparency":0.5}},
"line":{"style":"random","field":"fid","width":2,"transparency":0.5},
"polygon":{"style":"random","field":"fid","width":2,"transparency":0.5}}','{"visible": ["v_minsector"]}',NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2710,'gw_fct_grafanalytics_mapzones',NULL, NULL,'["style_mapzones"]') ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2848,'gw_fct_pg2epa_check_result','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}',NULL, NULL) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_function (id, function_name, returnmanager, layermanager, actions) 
VALUES(2850,'gw_fct_pg2epa_check_options','{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}, 
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}', '{"zoom": {"layer":"v_edit_arc", "margin":20}}',NULL) ON CONFLICT (id) DO NOTHING;



INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('101', 'v_edi_arc', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="1" simplifyDrawingTol="1" version="3.10.3-A Coruña" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" labelsEnabled="1" styleCategories="AllStyleCategories" maxScale="0" simplifyMaxScale="1" readOnly="0" minScale="1e+08">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="RuleRenderer" symbollevels="0" forceraster="0" enableorderby="0">
    <rules key="{29dced10-8911-4fe9-a8e3-e4eaa2961a4a}">
      <rule key="{d19f8c69-564f-4aca-bc02-8b8cf8cbbad7}" filter=" &quot;sys_type&quot; = 'PIPE' AND &quot;state&quot; = 0" label="Obsolete" symbol="0"/>
      <rule key="{9ba6fe8e-f0ab-40de-bd32-b3c5cea47c45}" filter=" &quot;sys_type&quot; = 'PIPE' AND &quot;state&quot; = 1" label="On service" symbol="1"/>
      <rule key="{8606d86b-78a8-46d8-af58-9f6eb6e84c5e}" filter=" &quot;sys_type&quot; = 'PIPE' AND &quot;state&quot; = 2" label="Planified" symbol="2"/>
      <rule key="{8660f1b2-6f22-49c1-9e71-6aed213976e6}" filter=" &quot;sys_type&quot; = 'VARC' " label="Varc" symbol="3"/>
    </rules>
    <symbols>
      <symbol type="line" name="0" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="227,61,39,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" name="1" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="31,120,180,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" name="2" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="230,186,68,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="0.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="line" name="3" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="129,10,78,255" k="line_color"/>
          <prop v="dash" k="line_style"/>
          <prop v="0.46" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="use_custom_dash"/>
          <prop v="3x:0,0,0,0,0,0" k="width_map_unit_scale"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style fontSizeUnit="Point" fontCapitals="0" fontUnderline="0" fontWeight="50" fontWordSpacing="0" fontItalic="0" fontKerning="1" fontFamily="MS Shell Dlg 2" multilineHeight="1" fieldName="arccat_id" fontStrikeout="0" blendMode="0" fontSize="8" previewBkgrdColor="255,255,255,255" textOrientation="horizontal" namedStyle="Normal" fontSizeMapUnitScale="3x:0,0,0,0,0,0" textColor="0,0,0,255" isExpression="0" textOpacity="1" fontLetterSpacing="0" useSubstitutions="0">
        <text-buffer bufferSize="1" bufferColor="255,255,255,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferNoFill="1" bufferJoinStyle="128" bufferBlendMode="0" bufferSizeUnits="MM" bufferDraw="0" bufferOpacity="1"/>
        <background shapeOffsetY="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeBorderWidthUnit="MM" shapeRadiiY="0" shapeBorderWidth="0" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeBorderColor="128,128,128,255" shapeSizeUnit="MM" shapeSizeX="0" shapeDraw="0" shapeBlendMode="0" shapeSizeY="0" shapeRotation="0" shapeRotationType="0" shapeJoinStyle="64" shapeOffsetX="0" shapeSizeType="0" shapeRadiiX="0" shapeOffsetUnit="MM" shapeRadiiUnit="MM" shapeSVGFile="" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeOpacity="1" shapeFillColor="255,255,255,255">
          <symbol type="marker" name="markerSymbol" alpha="1" force_rhr="0" clip_to_extent="1">
            <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
              <prop v="0" k="angle"/>
              <prop v="243,166,178,255" k="color"/>
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
              <prop v="2" k="size"/>
              <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
              <prop v="MM" k="size_unit"/>
              <prop v="1" k="vertical_anchor_point"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowColor="0,0,0,255" shadowOffsetDist="1" shadowOffsetGlobal="1" shadowBlendMode="6" shadowRadiusUnit="MM" shadowOpacity="0.7" shadowDraw="0" shadowOffsetAngle="135" shadowRadiusAlphaOnly="0" shadowOffsetUnit="MM" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowRadius="1.5" shadowScale="100" shadowUnder="0"/>
        <dd_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format wrapChar="" decimals="3" addDirectionSymbol="0" autoWrapLength="0" reverseDirectionSymbol="0" placeDirectionSymbol="0" plussign="0" useMaxLineLengthForAutoWrap="1" formatNumbers="0" multilineAlign="4294967295" leftDirectionSymbol="&lt;" rightDirectionSymbol=">"/>
      <placement quadOffset="4" xOffset="0" repeatDistanceUnits="MM" placementFlags="10" distUnits="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" layerType="LineGeometry" geometryGenerator="" distMapUnitScale="3x:0,0,0,0,0,0" fitInPolygonOnly="0" priority="5" repeatDistance="0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" rotationAngle="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" offsetUnits="MM" dist="0" centroidInside="0" offsetType="0" yOffset="0" maxCurvedCharAngleOut="-25" overrunDistance="0" geometryGeneratorEnabled="0" maxCurvedCharAngleIn="25" placement="2" geometryGeneratorType="PointGeometry" centroidWhole="0" overrunDistanceUnit="MM" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0"/>
      <rendering obstacle="1" obstacleType="0" scaleMin="0" zIndex="0" limitNumLabels="0" scaleMax="1000" fontMinPixelSize="3" displayAll="0" upsidedownLabels="0" obstacleFactor="1" minFeatureSize="0" scaleVisibility="1" fontLimitPixelSize="0" maxNumLabels="2000" fontMaxPixelSize="10000" labelPerPart="0" mergeLines="0" drawLabels="1"/>
      <dd_properties>
        <Option type="Map">
          <Option type="QString" name="name" value=""/>
          <Option name="properties"/>
          <Option type="QString" name="type" value="collection"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option type="QString" name="anchorPoint" value="pole_of_inaccessibility"/>
          <Option type="Map" name="ddProperties">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
          <Option type="bool" name="drawToAllParts" value="false"/>
          <Option type="QString" name="enabled" value="0"/>
          <Option type="QString" name="lineSymbol" value="&lt;symbol type=&quot;line&quot; name=&quot;symbol&quot; alpha=&quot;1&quot; force_rhr=&quot;0&quot; clip_to_extent=&quot;1&quot;>&lt;layer pass=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot; locked=&quot;0&quot;>&lt;prop v=&quot;square&quot; k=&quot;capstyle&quot;/>&lt;prop v=&quot;5;2&quot; k=&quot;customdash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;customdash_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;customdash_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;draw_inside_polygon&quot;/>&lt;prop v=&quot;bevel&quot; k=&quot;joinstyle&quot;/>&lt;prop v=&quot;60,60,60,255&quot; k=&quot;line_color&quot;/>&lt;prop v=&quot;solid&quot; k=&quot;line_style&quot;/>&lt;prop v=&quot;0.3&quot; k=&quot;line_width&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;line_width_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;offset&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;offset_map_unit_scale&quot;/>&lt;prop v=&quot;MM&quot; k=&quot;offset_unit&quot;/>&lt;prop v=&quot;0&quot; k=&quot;ring_filter&quot;/>&lt;prop v=&quot;0&quot; k=&quot;use_custom_dash&quot;/>&lt;prop v=&quot;3x:0,0,0,0,0,0&quot; k=&quot;width_map_unit_scale&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option type=&quot;QString&quot; name=&quot;name&quot; value=&quot;&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option type=&quot;QString&quot; name=&quot;type&quot; value=&quot;collection&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>"/>
          <Option type="double" name="minLength" value="0"/>
          <Option type="QString" name="minLengthMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="minLengthUnit" value="MM"/>
          <Option type="double" name="offsetFromAnchor" value="0"/>
          <Option type="QString" name="offsetFromAnchorMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromAnchorUnit" value="MM"/>
          <Option type="double" name="offsetFromLabel" value="0"/>
          <Option type="QString" name="offsetFromLabelMapUnitScale" value="3x:0,0,0,0,0,0"/>
          <Option type="QString" name="offsetFromLabelUnit" value="MM"/>
        </Option>
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
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" scaleBasedVisibility="0" opacity="1" sizeType="MM" backgroundColor="#ffffff" width="15" scaleDependency="Area" minScaleDenominator="0" enabled="0" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="1e+08" backgroundAlpha="255" labelPlacementMethod="XHeight" height="15" rotationOffset="270" penWidth="0" penAlpha="255" penColor="#000000" barWidth="5" diagramOrientation="Up" lineSizeType="MM" minimumSize="0">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings dist="0" placement="2" showAll="1" zIndex="0" linePlacementFlags="18" priority="0" obstacle="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
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
    <field name="node_2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="elevation1">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="depth1">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="elevation2">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="depth2">
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
    <field name="cat_matcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_pnom">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_dnom">
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
    <field name="sector_name">
      <editWidget type="">
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
    <field name="minsector_id">
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
    <field name="dma_name">
      <editWidget type="">
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
    <field name="presszone_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id">
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
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_arctype_id">
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
    <field name="staticpress1">
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
    <field name="staticpress2">
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
    <field name="depth">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="adate">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="adescript">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dma_style">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="presszone_style">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="arc_id"/>
    <alias name="" index="1" field="code"/>
    <alias name="" index="2" field="node_1"/>
    <alias name="" index="3" field="node_2"/>
    <alias name="" index="4" field="elevation1"/>
    <alias name="" index="5" field="depth1"/>
    <alias name="" index="6" field="elevation2"/>
    <alias name="" index="7" field="depth2"/>
    <alias name="" index="8" field="arccat_id"/>
    <alias name="" index="9" field="arc_type"/>
    <alias name="" index="10" field="sys_type"/>
    <alias name="" index="11" field="cat_matcat_id"/>
    <alias name="" index="12" field="cat_pnom"/>
    <alias name="" index="13" field="cat_dnom"/>
    <alias name="" index="14" field="epa_type"/>
    <alias name="" index="15" field="expl_id"/>
    <alias name="" index="16" field="macroexpl_id"/>
    <alias name="" index="17" field="sector_id"/>
    <alias name="" index="18" field="sector_name"/>
    <alias name="" index="19" field="macrosector_id"/>
    <alias name="" index="20" field="state"/>
    <alias name="" index="21" field="state_type"/>
    <alias name="" index="22" field="annotation"/>
    <alias name="" index="23" field="observ"/>
    <alias name="" index="24" field="comment"/>
    <alias name="" index="25" field="gis_length"/>
    <alias name="" index="26" field="custom_length"/>
    <alias name="" index="27" field="minsector_id"/>
    <alias name="" index="28" field="dma_id"/>
    <alias name="" index="29" field="dma_name"/>
    <alias name="" index="30" field="macrodma_id"/>
    <alias name="" index="31" field="presszone_id"/>
    <alias name="" index="32" field="presszone_name"/>
    <alias name="" index="33" field="dqa_id"/>
    <alias name="" index="34" field="dqa_name"/>
    <alias name="" index="35" field="macrodqa_id"/>
    <alias name="" index="36" field="soilcat_id"/>
    <alias name="" index="37" field="function_type"/>
    <alias name="" index="38" field="category_type"/>
    <alias name="" index="39" field="fluid_type"/>
    <alias name="" index="40" field="location_type"/>
    <alias name="" index="41" field="workcat_id"/>
    <alias name="" index="42" field="workcat_id_end"/>
    <alias name="" index="43" field="buildercat_id"/>
    <alias name="" index="44" field="builtdate"/>
    <alias name="" index="45" field="enddate"/>
    <alias name="" index="46" field="ownercat_id"/>
    <alias name="" index="47" field="muni_id"/>
    <alias name="" index="48" field="postcode"/>
    <alias name="" index="49" field="district_id"/>
    <alias name="" index="50" field="streetname"/>
    <alias name="" index="51" field="postnumber"/>
    <alias name="" index="52" field="postcomplement"/>
    <alias name="" index="53" field="streetname2"/>
    <alias name="" index="54" field="postnumber2"/>
    <alias name="" index="55" field="postcomplement2"/>
    <alias name="" index="56" field="descript"/>
    <alias name="" index="57" field="link"/>
    <alias name="" index="58" field="verified"/>
    <alias name="" index="59" field="undelete"/>
    <alias name="" index="60" field="label"/>
    <alias name="" index="61" field="label_x"/>
    <alias name="" index="62" field="label_y"/>
    <alias name="" index="63" field="label_rotation"/>
    <alias name="" index="64" field="publish"/>
    <alias name="" index="65" field="inventory"/>
    <alias name="" index="66" field="num_value"/>
    <alias name="" index="67" field="cat_arctype_id"/>
    <alias name="" index="68" field="nodetype_1"/>
    <alias name="" index="69" field="staticpress1"/>
    <alias name="" index="70" field="nodetype_2"/>
    <alias name="" index="71" field="staticpress2"/>
    <alias name="" index="72" field="tstamp"/>
    <alias name="" index="73" field="insert_user"/>
    <alias name="" index="74" field="lastupdate"/>
    <alias name="" index="75" field="lastupdate_user"/>
    <alias name="" index="76" field="depth"/>
    <alias name="" index="77" field="adate"/>
    <alias name="" index="78" field="adescript"/>
    <alias name="" index="79" field="dma_style"/>
    <alias name="" index="80" field="presszone_style"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="arc_id"/>
    <default applyOnUpdate="0" expression="" field="code"/>
    <default applyOnUpdate="0" expression="" field="node_1"/>
    <default applyOnUpdate="0" expression="" field="node_2"/>
    <default applyOnUpdate="0" expression="" field="elevation1"/>
    <default applyOnUpdate="0" expression="" field="depth1"/>
    <default applyOnUpdate="0" expression="" field="elevation2"/>
    <default applyOnUpdate="0" expression="" field="depth2"/>
    <default applyOnUpdate="0" expression="" field="arccat_id"/>
    <default applyOnUpdate="0" expression="" field="arc_type"/>
    <default applyOnUpdate="0" expression="" field="sys_type"/>
    <default applyOnUpdate="0" expression="" field="cat_matcat_id"/>
    <default applyOnUpdate="0" expression="" field="cat_pnom"/>
    <default applyOnUpdate="0" expression="" field="cat_dnom"/>
    <default applyOnUpdate="0" expression="" field="epa_type"/>
    <default applyOnUpdate="0" expression="" field="expl_id"/>
    <default applyOnUpdate="0" expression="" field="macroexpl_id"/>
    <default applyOnUpdate="0" expression="" field="sector_id"/>
    <default applyOnUpdate="0" expression="" field="sector_name"/>
    <default applyOnUpdate="0" expression="" field="macrosector_id"/>
    <default applyOnUpdate="0" expression="" field="state"/>
    <default applyOnUpdate="0" expression="" field="state_type"/>
    <default applyOnUpdate="0" expression="" field="annotation"/>
    <default applyOnUpdate="0" expression="" field="observ"/>
    <default applyOnUpdate="0" expression="" field="comment"/>
    <default applyOnUpdate="0" expression="" field="gis_length"/>
    <default applyOnUpdate="0" expression="" field="custom_length"/>
    <default applyOnUpdate="0" expression="" field="minsector_id"/>
    <default applyOnUpdate="0" expression="" field="dma_id"/>
    <default applyOnUpdate="0" expression="" field="dma_name"/>
    <default applyOnUpdate="0" expression="" field="macrodma_id"/>
    <default applyOnUpdate="0" expression="" field="presszone_id"/>
    <default applyOnUpdate="0" expression="" field="presszone_name"/>
    <default applyOnUpdate="0" expression="" field="dqa_id"/>
    <default applyOnUpdate="0" expression="" field="dqa_name"/>
    <default applyOnUpdate="0" expression="" field="macrodqa_id"/>
    <default applyOnUpdate="0" expression="" field="soilcat_id"/>
    <default applyOnUpdate="0" expression="" field="function_type"/>
    <default applyOnUpdate="0" expression="" field="category_type"/>
    <default applyOnUpdate="0" expression="" field="fluid_type"/>
    <default applyOnUpdate="0" expression="" field="location_type"/>
    <default applyOnUpdate="0" expression="" field="workcat_id"/>
    <default applyOnUpdate="0" expression="" field="workcat_id_end"/>
    <default applyOnUpdate="0" expression="" field="buildercat_id"/>
    <default applyOnUpdate="0" expression="" field="builtdate"/>
    <default applyOnUpdate="0" expression="" field="enddate"/>
    <default applyOnUpdate="0" expression="" field="ownercat_id"/>
    <default applyOnUpdate="0" expression="" field="muni_id"/>
    <default applyOnUpdate="0" expression="" field="postcode"/>
    <default applyOnUpdate="0" expression="" field="district_id"/>
    <default applyOnUpdate="0" expression="" field="streetname"/>
    <default applyOnUpdate="0" expression="" field="postnumber"/>
    <default applyOnUpdate="0" expression="" field="postcomplement"/>
    <default applyOnUpdate="0" expression="" field="streetname2"/>
    <default applyOnUpdate="0" expression="" field="postnumber2"/>
    <default applyOnUpdate="0" expression="" field="postcomplement2"/>
    <default applyOnUpdate="0" expression="" field="descript"/>
    <default applyOnUpdate="0" expression="" field="link"/>
    <default applyOnUpdate="0" expression="" field="verified"/>
    <default applyOnUpdate="0" expression="" field="undelete"/>
    <default applyOnUpdate="0" expression="" field="label"/>
    <default applyOnUpdate="0" expression="" field="label_x"/>
    <default applyOnUpdate="0" expression="" field="label_y"/>
    <default applyOnUpdate="0" expression="" field="label_rotation"/>
    <default applyOnUpdate="0" expression="" field="publish"/>
    <default applyOnUpdate="0" expression="" field="inventory"/>
    <default applyOnUpdate="0" expression="" field="num_value"/>
    <default applyOnUpdate="0" expression="" field="cat_arctype_id"/>
    <default applyOnUpdate="0" expression="" field="nodetype_1"/>
    <default applyOnUpdate="0" expression="" field="staticpress1"/>
    <default applyOnUpdate="0" expression="" field="nodetype_2"/>
    <default applyOnUpdate="0" expression="" field="staticpress2"/>
    <default applyOnUpdate="0" expression="" field="tstamp"/>
    <default applyOnUpdate="0" expression="" field="insert_user"/>
    <default applyOnUpdate="0" expression="" field="lastupdate"/>
    <default applyOnUpdate="0" expression="" field="lastupdate_user"/>
    <default applyOnUpdate="0" expression="" field="depth"/>
    <default applyOnUpdate="0" expression="" field="adate"/>
    <default applyOnUpdate="0" expression="" field="adescript"/>
    <default applyOnUpdate="0" expression="" field="dma_style"/>
    <default applyOnUpdate="0" expression="" field="presszone_style"/>
  </defaults>
  <constraints>
    <constraint constraints="3" unique_strength="1" exp_strength="0" field="arc_id" notnull_strength="1"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="code" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="node_1" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="node_2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="elevation1" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="depth1" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="elevation2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="depth2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="arccat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="arc_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sys_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_matcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_pnom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_dnom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="epa_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="expl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macroexpl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrosector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="annotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="observ" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="comment" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="gis_length" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="custom_length" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="minsector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dqa_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dqa_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodqa_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="soilcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="function_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="category_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="fluid_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="location_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="workcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="workcat_id_end" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="buildercat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="builtdate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="enddate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="ownercat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="muni_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcode" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="district_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="streetname" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postnumber" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcomplement" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="streetname2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postnumber2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcomplement2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="descript" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="link" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="verified" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="undelete" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_x" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_y" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_rotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="publish" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="inventory" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="num_value" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_arctype_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="nodetype_1" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="staticpress1" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="nodetype_2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="staticpress2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="tstamp" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="insert_user" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="lastupdate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="lastupdate_user" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="depth" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="adate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="adescript" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_style" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_style" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="arc_id"/>
    <constraint desc="" exp="" field="code"/>
    <constraint desc="" exp="" field="node_1"/>
    <constraint desc="" exp="" field="node_2"/>
    <constraint desc="" exp="" field="elevation1"/>
    <constraint desc="" exp="" field="depth1"/>
    <constraint desc="" exp="" field="elevation2"/>
    <constraint desc="" exp="" field="depth2"/>
    <constraint desc="" exp="" field="arccat_id"/>
    <constraint desc="" exp="" field="arc_type"/>
    <constraint desc="" exp="" field="sys_type"/>
    <constraint desc="" exp="" field="cat_matcat_id"/>
    <constraint desc="" exp="" field="cat_pnom"/>
    <constraint desc="" exp="" field="cat_dnom"/>
    <constraint desc="" exp="" field="epa_type"/>
    <constraint desc="" exp="" field="expl_id"/>
    <constraint desc="" exp="" field="macroexpl_id"/>
    <constraint desc="" exp="" field="sector_id"/>
    <constraint desc="" exp="" field="sector_name"/>
    <constraint desc="" exp="" field="macrosector_id"/>
    <constraint desc="" exp="" field="state"/>
    <constraint desc="" exp="" field="state_type"/>
    <constraint desc="" exp="" field="annotation"/>
    <constraint desc="" exp="" field="observ"/>
    <constraint desc="" exp="" field="comment"/>
    <constraint desc="" exp="" field="gis_length"/>
    <constraint desc="" exp="" field="custom_length"/>
    <constraint desc="" exp="" field="minsector_id"/>
    <constraint desc="" exp="" field="dma_id"/>
    <constraint desc="" exp="" field="dma_name"/>
    <constraint desc="" exp="" field="macrodma_id"/>
    <constraint desc="" exp="" field="presszone_id"/>
    <constraint desc="" exp="" field="presszone_name"/>
    <constraint desc="" exp="" field="dqa_id"/>
    <constraint desc="" exp="" field="dqa_name"/>
    <constraint desc="" exp="" field="macrodqa_id"/>
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
    <constraint desc="" exp="" field="link"/>
    <constraint desc="" exp="" field="verified"/>
    <constraint desc="" exp="" field="undelete"/>
    <constraint desc="" exp="" field="label"/>
    <constraint desc="" exp="" field="label_x"/>
    <constraint desc="" exp="" field="label_y"/>
    <constraint desc="" exp="" field="label_rotation"/>
    <constraint desc="" exp="" field="publish"/>
    <constraint desc="" exp="" field="inventory"/>
    <constraint desc="" exp="" field="num_value"/>
    <constraint desc="" exp="" field="cat_arctype_id"/>
    <constraint desc="" exp="" field="nodetype_1"/>
    <constraint desc="" exp="" field="staticpress1"/>
    <constraint desc="" exp="" field="nodetype_2"/>
    <constraint desc="" exp="" field="staticpress2"/>
    <constraint desc="" exp="" field="tstamp"/>
    <constraint desc="" exp="" field="insert_user"/>
    <constraint desc="" exp="" field="lastupdate"/>
    <constraint desc="" exp="" field="lastupdate_user"/>
    <constraint desc="" exp="" field="depth"/>
    <constraint desc="" exp="" field="adate"/>
    <constraint desc="" exp="" field="adescript"/>
    <constraint desc="" exp="" field="dma_style"/>
    <constraint desc="" exp="" field="presszone_style"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" name="arc_id" width="-1" hidden="0"/>
      <column type="field" name="code" width="-1" hidden="0"/>
      <column type="field" name="node_1" width="-1" hidden="0"/>
      <column type="field" name="node_2" width="-1" hidden="0"/>
      <column type="field" name="elevation1" width="-1" hidden="0"/>
      <column type="field" name="depth1" width="-1" hidden="0"/>
      <column type="field" name="elevation2" width="-1" hidden="0"/>
      <column type="field" name="depth2" width="-1" hidden="0"/>
      <column type="field" name="arccat_id" width="-1" hidden="0"/>
      <column type="field" name="arc_type" width="-1" hidden="0"/>
      <column type="field" name="sys_type" width="-1" hidden="0"/>
      <column type="field" name="cat_matcat_id" width="-1" hidden="0"/>
      <column type="field" name="cat_pnom" width="-1" hidden="0"/>
      <column type="field" name="cat_dnom" width="-1" hidden="0"/>
      <column type="field" name="epa_type" width="-1" hidden="0"/>
      <column type="field" name="expl_id" width="-1" hidden="0"/>
      <column type="field" name="macroexpl_id" width="-1" hidden="0"/>
      <column type="field" name="sector_id" width="-1" hidden="0"/>
      <column type="field" name="macrosector_id" width="-1" hidden="0"/>
      <column type="field" name="state" width="-1" hidden="0"/>
      <column type="field" name="state_type" width="-1" hidden="0"/>
      <column type="field" name="annotation" width="-1" hidden="0"/>
      <column type="field" name="observ" width="-1" hidden="0"/>
      <column type="field" name="comment" width="-1" hidden="0"/>
      <column type="field" name="gis_length" width="-1" hidden="0"/>
      <column type="field" name="custom_length" width="-1" hidden="0"/>
      <column type="field" name="minsector_id" width="-1" hidden="0"/>
      <column type="field" name="dma_id" width="-1" hidden="0"/>
      <column type="field" name="macrodma_id" width="-1" hidden="0"/>
      <column type="field" name="dqa_id" width="-1" hidden="0"/>
      <column type="field" name="macrodqa_id" width="-1" hidden="0"/>
      <column type="field" name="soilcat_id" width="-1" hidden="0"/>
      <column type="field" name="function_type" width="-1" hidden="0"/>
      <column type="field" name="category_type" width="-1" hidden="0"/>
      <column type="field" name="fluid_type" width="-1" hidden="0"/>
      <column type="field" name="location_type" width="-1" hidden="0"/>
      <column type="field" name="workcat_id" width="-1" hidden="0"/>
      <column type="field" name="workcat_id_end" width="-1" hidden="0"/>
      <column type="field" name="buildercat_id" width="-1" hidden="0"/>
      <column type="field" name="builtdate" width="-1" hidden="0"/>
      <column type="field" name="enddate" width="-1" hidden="0"/>
      <column type="field" name="ownercat_id" width="-1" hidden="0"/>
      <column type="field" name="muni_id" width="-1" hidden="0"/>
      <column type="field" name="postcode" width="-1" hidden="0"/>
      <column type="field" name="streetname" width="-1" hidden="0"/>
      <column type="field" name="postnumber" width="-1" hidden="0"/>
      <column type="field" name="postcomplement" width="-1" hidden="0"/>
      <column type="field" name="streetname2" width="-1" hidden="0"/>
      <column type="field" name="postnumber2" width="-1" hidden="0"/>
      <column type="field" name="postcomplement2" width="-1" hidden="0"/>
      <column type="field" name="descript" width="-1" hidden="0"/>
      <column type="field" name="link" width="-1" hidden="0"/>
      <column type="field" name="verified" width="-1" hidden="0"/>
      <column type="field" name="undelete" width="-1" hidden="0"/>
      <column type="field" name="label" width="-1" hidden="0"/>
      <column type="field" name="label_x" width="-1" hidden="0"/>
      <column type="field" name="label_y" width="-1" hidden="0"/>
      <column type="field" name="label_rotation" width="-1" hidden="0"/>
      <column type="field" name="publish" width="-1" hidden="0"/>
      <column type="field" name="inventory" width="-1" hidden="0"/>
      <column type="field" name="num_value" width="-1" hidden="0"/>
      <column type="field" name="cat_arctype_id" width="-1" hidden="0"/>
      <column type="field" name="nodetype_1" width="-1" hidden="0"/>
      <column type="field" name="staticpress1" width="-1" hidden="0"/>
      <column type="field" name="nodetype_2" width="-1" hidden="0"/>
      <column type="field" name="staticpress2" width="-1" hidden="0"/>
      <column type="field" name="tstamp" width="-1" hidden="0"/>
      <column type="field" name="insert_user" width="-1" hidden="0"/>
      <column type="field" name="lastupdate" width="-1" hidden="0"/>
      <column type="field" name="lastupdate_user" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
      <column type="field" name="presszone_id" width="-1" hidden="0"/>
      <column type="field" name="district_id" width="-1" hidden="0"/>
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
    <field name="arc_id" editable="1"/>
    <field name="arc_type" editable="1"/>
    <field name="arccat_id" editable="1"/>
    <field name="buildercat_id" editable="1"/>
    <field name="builtdate" editable="1"/>
    <field name="cat_arctype_id" editable="1"/>
    <field name="cat_dnom" editable="1"/>
    <field name="cat_matcat_id" editable="1"/>
    <field name="cat_pnom" editable="1"/>
    <field name="category_type" editable="1"/>
    <field name="code" editable="1"/>
    <field name="comment" editable="1"/>
    <field name="custom_length" editable="1"/>
    <field name="depth1" editable="1"/>
    <field name="depth2" editable="1"/>
    <field name="descript" editable="1"/>
    <field name="district_id" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="dqa_id" editable="1"/>
    <field name="elevation1" editable="1"/>
    <field name="elevation2" editable="1"/>
    <field name="enddate" editable="1"/>
    <field name="epa_type" editable="1"/>
    <field name="expl_id" editable="1"/>
    <field name="fluid_type" editable="1"/>
    <field name="function_type" editable="1"/>
    <field name="gis_length" editable="1"/>
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
    <field name="macrodqa_id" editable="1"/>
    <field name="macroexpl_id" editable="1"/>
    <field name="macrosector_id" editable="1"/>
    <field name="minsector_id" editable="1"/>
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
    <field name="presszone_id" editable="1"/>
    <field name="presszonecat_id" editable="1"/>
    <field name="publish" editable="1"/>
    <field name="sector_id" editable="1"/>
    <field name="soilcat_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
    <field name="staticpress1" editable="1"/>
    <field name="staticpress2" editable="1"/>
    <field name="streetname" editable="1"/>
    <field name="streetname2" editable="1"/>
    <field name="sys_type" editable="1"/>
    <field name="tstamp" editable="1"/>
    <field name="undelete" editable="1"/>
    <field name="verified" editable="1"/>
    <field name="workcat_id" editable="1"/>
    <field name="workcat_id_end" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="annotation" labelOnTop="0"/>
    <field name="arc_id" labelOnTop="0"/>
    <field name="arc_type" labelOnTop="0"/>
    <field name="arccat_id" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="cat_arctype_id" labelOnTop="0"/>
    <field name="cat_dnom" labelOnTop="0"/>
    <field name="cat_matcat_id" labelOnTop="0"/>
    <field name="cat_pnom" labelOnTop="0"/>
    <field name="category_type" labelOnTop="0"/>
    <field name="code" labelOnTop="0"/>
    <field name="comment" labelOnTop="0"/>
    <field name="custom_length" labelOnTop="0"/>
    <field name="depth1" labelOnTop="0"/>
    <field name="depth2" labelOnTop="0"/>
    <field name="descript" labelOnTop="0"/>
    <field name="district_id" labelOnTop="0"/>
    <field name="dma_id" labelOnTop="0"/>
    <field name="dqa_id" labelOnTop="0"/>
    <field name="elevation1" labelOnTop="0"/>
    <field name="elevation2" labelOnTop="0"/>
    <field name="enddate" labelOnTop="0"/>
    <field name="epa_type" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="fluid_type" labelOnTop="0"/>
    <field name="function_type" labelOnTop="0"/>
    <field name="gis_length" labelOnTop="0"/>
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
    <field name="macrodqa_id" labelOnTop="0"/>
    <field name="macroexpl_id" labelOnTop="0"/>
    <field name="macrosector_id" labelOnTop="0"/>
    <field name="minsector_id" labelOnTop="0"/>
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
    <field name="presszone_id" labelOnTop="0"/>
    <field name="presszonecat_id" labelOnTop="0"/>
    <field name="publish" labelOnTop="0"/>
    <field name="sector_id" labelOnTop="0"/>
    <field name="soilcat_id" labelOnTop="0"/>
    <field name="state" labelOnTop="0"/>
    <field name="state_type" labelOnTop="0"/>
    <field name="staticpress1" labelOnTop="0"/>
    <field name="staticpress2" labelOnTop="0"/>
    <field name="streetname" labelOnTop="0"/>
    <field name="streetname2" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="tstamp" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>arc_id</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('102', 'v_edit_connec', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="0" simplifyDrawingTol="1" version="3.10.3-A Coruña" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" labelsEnabled="0" styleCategories="AllStyleCategories" maxScale="0" simplifyMaxScale="1" readOnly="0" minScale="1e+08">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="RuleRenderer" symbollevels="0" forceraster="0" enableorderby="0">
    <rules key="{cd75f41e-3b1d-443c-8148-fbc4436aa9cb}">
      <rule scalemaxdenom="1500" scalemindenom="1" key="{24b63ac0-a836-4203-bd64-161a0112ee9a}" filter=" &quot;sys_type&quot; = 'GREENTAP'" label="Greentap" symbol="0"/>
      <rule scalemaxdenom="1500" scalemindenom="1" key="{abcdb374-fe6a-4d04-a466-31fdd93144e8}" filter=" &quot;sys_type&quot; ='WJOIN'" label="Wjoin" symbol="1"/>
      <rule scalemaxdenom="1500" scalemindenom="1" key="{7dc90f4d-d098-491a-b817-e7ea68fc2fd6}" filter=" &quot;sys_type&quot; ='TAP'" label="Tap" symbol="2"/>
      <rule scalemaxdenom="1500" scalemindenom="1" key="{39e4856f-0fc3-4498-8d4b-44d2851b421f}" filter=" &quot;sys_type&quot; ='FOUNTAIN'" label="Fountain" symbol="3"/>
    </rules>
    <symbols>
      <symbol type="marker" name="0" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="201,246,158,255" k="color"/>
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
          <prop v="1.6" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="1" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="2" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
          <prop v="2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="3" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="44,67,207,83" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="triangle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="22,0,148,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="F" k="chr"/>
          <prop v="22,0,148,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
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
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" scaleBasedVisibility="0" opacity="1" sizeType="MM" backgroundColor="#ffffff" width="15" scaleDependency="Area" minScaleDenominator="0" enabled="0" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="1e+08" backgroundAlpha="255" labelPlacementMethod="XHeight" height="15" rotationOffset="270" penWidth="0" penAlpha="255" penColor="#000000" barWidth="5" diagramOrientation="Up" lineSizeType="MM" minimumSize="0">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings dist="0" placement="0" showAll="1" zIndex="0" linePlacementFlags="18" priority="0" obstacle="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
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
    <field name="elevation">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="depth">
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
    <field name="connecat_id">
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
    <field name="sector_name">
      <editWidget type="">
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
    <field name="customer_code">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_matcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_pnom">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_dnom">
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
    <field name="n_hydrometer">
      <editWidget type="Range">
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
    <field name="minsector_id">
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
    <field name="dma_name">
      <editWidget type="">
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
    <field name="presszone_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="staticpressure">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id">
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
    <field name="num_value">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="connectype_id">
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
    <field name="adate">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="adescript">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="accessibility">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="connec_id"/>
    <alias name="" index="1" field="code"/>
    <alias name="" index="2" field="elevation"/>
    <alias name="" index="3" field="depth"/>
    <alias name="" index="4" field="connec_type"/>
    <alias name="" index="5" field="sys_type"/>
    <alias name="" index="6" field="connecat_id"/>
    <alias name="" index="7" field="expl_id"/>
    <alias name="" index="8" field="macroexpl_id"/>
    <alias name="" index="9" field="sector_id"/>
    <alias name="" index="10" field="sector_name"/>
    <alias name="" index="11" field="macrosector_id"/>
    <alias name="" index="12" field="customer_code"/>
    <alias name="" index="13" field="cat_matcat_id"/>
    <alias name="" index="14" field="cat_pnom"/>
    <alias name="" index="15" field="cat_dnom"/>
    <alias name="" index="16" field="connec_length"/>
    <alias name="" index="17" field="state"/>
    <alias name="" index="18" field="state_type"/>
    <alias name="" index="19" field="n_hydrometer"/>
    <alias name="" index="20" field="arc_id"/>
    <alias name="" index="21" field="annotation"/>
    <alias name="" index="22" field="observ"/>
    <alias name="" index="23" field="comment"/>
    <alias name="" index="24" field="minsector_id"/>
    <alias name="" index="25" field="dma_id"/>
    <alias name="" index="26" field="dma_name"/>
    <alias name="" index="27" field="macrodma_id"/>
    <alias name="" index="28" field="presszone_id"/>
    <alias name="" index="29" field="presszone_name"/>
    <alias name="" index="30" field="staticpressure"/>
    <alias name="" index="31" field="dqa_id"/>
    <alias name="" index="32" field="dqa_name"/>
    <alias name="" index="33" field="macrodqa_id"/>
    <alias name="" index="34" field="soilcat_id"/>
    <alias name="" index="35" field="function_type"/>
    <alias name="" index="36" field="category_type"/>
    <alias name="" index="37" field="fluid_type"/>
    <alias name="" index="38" field="location_type"/>
    <alias name="" index="39" field="workcat_id"/>
    <alias name="" index="40" field="workcat_id_end"/>
    <alias name="" index="41" field="buildercat_id"/>
    <alias name="" index="42" field="builtdate"/>
    <alias name="" index="43" field="enddate"/>
    <alias name="" index="44" field="ownercat_id"/>
    <alias name="" index="45" field="muni_id"/>
    <alias name="" index="46" field="postcode"/>
    <alias name="" index="47" field="district_id"/>
    <alias name="" index="48" field="streetname"/>
    <alias name="" index="49" field="postnumber"/>
    <alias name="" index="50" field="postcomplement"/>
    <alias name="" index="51" field="streetname2"/>
    <alias name="" index="52" field="postnumber2"/>
    <alias name="" index="53" field="postcomplement2"/>
    <alias name="" index="54" field="descript"/>
    <alias name="" index="55" field="svg"/>
    <alias name="" index="56" field="rotation"/>
    <alias name="" index="57" field="link"/>
    <alias name="" index="58" field="verified"/>
    <alias name="" index="59" field="undelete"/>
    <alias name="" index="60" field="label"/>
    <alias name="" index="61" field="label_x"/>
    <alias name="" index="62" field="label_y"/>
    <alias name="" index="63" field="label_rotation"/>
    <alias name="" index="64" field="publish"/>
    <alias name="" index="65" field="inventory"/>
    <alias name="" index="66" field="num_value"/>
    <alias name="" index="67" field="connectype_id"/>
    <alias name="" index="68" field="feature_id"/>
    <alias name="" index="69" field="featurecat_id"/>
    <alias name="" index="70" field="pjoint_id"/>
    <alias name="" index="71" field="pjoint_type"/>
    <alias name="" index="72" field="tstamp"/>
    <alias name="" index="73" field="insert_user"/>
    <alias name="" index="74" field="lastupdate"/>
    <alias name="" index="75" field="lastupdate_user"/>
    <alias name="" index="76" field="adate"/>
    <alias name="" index="77" field="adescript"/>
    <alias name="" index="78" field="accessibility"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="connec_id"/>
    <default applyOnUpdate="0" expression="" field="code"/>
    <default applyOnUpdate="0" expression="" field="elevation"/>
    <default applyOnUpdate="0" expression="" field="depth"/>
    <default applyOnUpdate="0" expression="" field="connec_type"/>
    <default applyOnUpdate="0" expression="" field="sys_type"/>
    <default applyOnUpdate="0" expression="" field="connecat_id"/>
    <default applyOnUpdate="0" expression="" field="expl_id"/>
    <default applyOnUpdate="0" expression="" field="macroexpl_id"/>
    <default applyOnUpdate="0" expression="" field="sector_id"/>
    <default applyOnUpdate="0" expression="" field="sector_name"/>
    <default applyOnUpdate="0" expression="" field="macrosector_id"/>
    <default applyOnUpdate="0" expression="" field="customer_code"/>
    <default applyOnUpdate="0" expression="" field="cat_matcat_id"/>
    <default applyOnUpdate="0" expression="" field="cat_pnom"/>
    <default applyOnUpdate="0" expression="" field="cat_dnom"/>
    <default applyOnUpdate="0" expression="" field="connec_length"/>
    <default applyOnUpdate="0" expression="" field="state"/>
    <default applyOnUpdate="0" expression="" field="state_type"/>
    <default applyOnUpdate="0" expression="" field="n_hydrometer"/>
    <default applyOnUpdate="0" expression="" field="arc_id"/>
    <default applyOnUpdate="0" expression="" field="annotation"/>
    <default applyOnUpdate="0" expression="" field="observ"/>
    <default applyOnUpdate="0" expression="" field="comment"/>
    <default applyOnUpdate="0" expression="" field="minsector_id"/>
    <default applyOnUpdate="0" expression="" field="dma_id"/>
    <default applyOnUpdate="0" expression="" field="dma_name"/>
    <default applyOnUpdate="0" expression="" field="macrodma_id"/>
    <default applyOnUpdate="0" expression="" field="presszone_id"/>
    <default applyOnUpdate="0" expression="" field="presszone_name"/>
    <default applyOnUpdate="0" expression="" field="staticpressure"/>
    <default applyOnUpdate="0" expression="" field="dqa_id"/>
    <default applyOnUpdate="0" expression="" field="dqa_name"/>
    <default applyOnUpdate="0" expression="" field="macrodqa_id"/>
    <default applyOnUpdate="0" expression="" field="soilcat_id"/>
    <default applyOnUpdate="0" expression="" field="function_type"/>
    <default applyOnUpdate="0" expression="" field="category_type"/>
    <default applyOnUpdate="0" expression="" field="fluid_type"/>
    <default applyOnUpdate="0" expression="" field="location_type"/>
    <default applyOnUpdate="0" expression="" field="workcat_id"/>
    <default applyOnUpdate="0" expression="" field="workcat_id_end"/>
    <default applyOnUpdate="0" expression="" field="buildercat_id"/>
    <default applyOnUpdate="0" expression="" field="builtdate"/>
    <default applyOnUpdate="0" expression="" field="enddate"/>
    <default applyOnUpdate="0" expression="" field="ownercat_id"/>
    <default applyOnUpdate="0" expression="" field="muni_id"/>
    <default applyOnUpdate="0" expression="" field="postcode"/>
    <default applyOnUpdate="0" expression="" field="district_id"/>
    <default applyOnUpdate="0" expression="" field="streetname"/>
    <default applyOnUpdate="0" expression="" field="postnumber"/>
    <default applyOnUpdate="0" expression="" field="postcomplement"/>
    <default applyOnUpdate="0" expression="" field="streetname2"/>
    <default applyOnUpdate="0" expression="" field="postnumber2"/>
    <default applyOnUpdate="0" expression="" field="postcomplement2"/>
    <default applyOnUpdate="0" expression="" field="descript"/>
    <default applyOnUpdate="0" expression="" field="svg"/>
    <default applyOnUpdate="0" expression="" field="rotation"/>
    <default applyOnUpdate="0" expression="" field="link"/>
    <default applyOnUpdate="0" expression="" field="verified"/>
    <default applyOnUpdate="0" expression="" field="undelete"/>
    <default applyOnUpdate="0" expression="" field="label"/>
    <default applyOnUpdate="0" expression="" field="label_x"/>
    <default applyOnUpdate="0" expression="" field="label_y"/>
    <default applyOnUpdate="0" expression="" field="label_rotation"/>
    <default applyOnUpdate="0" expression="" field="publish"/>
    <default applyOnUpdate="0" expression="" field="inventory"/>
    <default applyOnUpdate="0" expression="" field="num_value"/>
    <default applyOnUpdate="0" expression="" field="connectype_id"/>
    <default applyOnUpdate="0" expression="" field="feature_id"/>
    <default applyOnUpdate="0" expression="" field="featurecat_id"/>
    <default applyOnUpdate="0" expression="" field="pjoint_id"/>
    <default applyOnUpdate="0" expression="" field="pjoint_type"/>
    <default applyOnUpdate="0" expression="" field="tstamp"/>
    <default applyOnUpdate="0" expression="" field="insert_user"/>
    <default applyOnUpdate="0" expression="" field="lastupdate"/>
    <default applyOnUpdate="0" expression="" field="lastupdate_user"/>
    <default applyOnUpdate="0" expression="" field="adate"/>
    <default applyOnUpdate="0" expression="" field="adescript"/>
    <default applyOnUpdate="0" expression="" field="accessibility"/>
  </defaults>
  <constraints>
    <constraint constraints="3" unique_strength="1" exp_strength="0" field="connec_id" notnull_strength="1"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="code" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="elevation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="depth" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="connec_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sys_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="connecat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="expl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macroexpl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrosector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="customer_code" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_matcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_pnom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_dnom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="connec_length" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="n_hydrometer" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="arc_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="annotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="observ" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="comment" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="minsector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="staticpressure" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dqa_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dqa_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodqa_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="soilcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="function_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="category_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="fluid_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="location_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="workcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="workcat_id_end" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="buildercat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="builtdate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="enddate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="ownercat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="muni_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcode" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="district_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="streetname" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postnumber" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcomplement" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="streetname2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postnumber2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcomplement2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="descript" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="svg" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="rotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="link" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="verified" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="undelete" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_x" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_y" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_rotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="publish" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="inventory" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="num_value" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="connectype_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="feature_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="featurecat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="pjoint_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="pjoint_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="tstamp" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="insert_user" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="lastupdate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="lastupdate_user" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="adate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="adescript" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="accessibility" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="connec_id"/>
    <constraint desc="" exp="" field="code"/>
    <constraint desc="" exp="" field="elevation"/>
    <constraint desc="" exp="" field="depth"/>
    <constraint desc="" exp="" field="connec_type"/>
    <constraint desc="" exp="" field="sys_type"/>
    <constraint desc="" exp="" field="connecat_id"/>
    <constraint desc="" exp="" field="expl_id"/>
    <constraint desc="" exp="" field="macroexpl_id"/>
    <constraint desc="" exp="" field="sector_id"/>
    <constraint desc="" exp="" field="sector_name"/>
    <constraint desc="" exp="" field="macrosector_id"/>
    <constraint desc="" exp="" field="customer_code"/>
    <constraint desc="" exp="" field="cat_matcat_id"/>
    <constraint desc="" exp="" field="cat_pnom"/>
    <constraint desc="" exp="" field="cat_dnom"/>
    <constraint desc="" exp="" field="connec_length"/>
    <constraint desc="" exp="" field="state"/>
    <constraint desc="" exp="" field="state_type"/>
    <constraint desc="" exp="" field="n_hydrometer"/>
    <constraint desc="" exp="" field="arc_id"/>
    <constraint desc="" exp="" field="annotation"/>
    <constraint desc="" exp="" field="observ"/>
    <constraint desc="" exp="" field="comment"/>
    <constraint desc="" exp="" field="minsector_id"/>
    <constraint desc="" exp="" field="dma_id"/>
    <constraint desc="" exp="" field="dma_name"/>
    <constraint desc="" exp="" field="macrodma_id"/>
    <constraint desc="" exp="" field="presszone_id"/>
    <constraint desc="" exp="" field="presszone_name"/>
    <constraint desc="" exp="" field="staticpressure"/>
    <constraint desc="" exp="" field="dqa_id"/>
    <constraint desc="" exp="" field="dqa_name"/>
    <constraint desc="" exp="" field="macrodqa_id"/>
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
    <constraint desc="" exp="" field="num_value"/>
    <constraint desc="" exp="" field="connectype_id"/>
    <constraint desc="" exp="" field="feature_id"/>
    <constraint desc="" exp="" field="featurecat_id"/>
    <constraint desc="" exp="" field="pjoint_id"/>
    <constraint desc="" exp="" field="pjoint_type"/>
    <constraint desc="" exp="" field="tstamp"/>
    <constraint desc="" exp="" field="insert_user"/>
    <constraint desc="" exp="" field="lastupdate"/>
    <constraint desc="" exp="" field="lastupdate_user"/>
    <constraint desc="" exp="" field="adate"/>
    <constraint desc="" exp="" field="adescript"/>
    <constraint desc="" exp="" field="accessibility"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" name="connec_id" width="-1" hidden="0"/>
      <column type="field" name="code" width="-1" hidden="0"/>
      <column type="field" name="elevation" width="-1" hidden="0"/>
      <column type="field" name="depth" width="-1" hidden="0"/>
      <column type="field" name="connec_type" width="-1" hidden="0"/>
      <column type="field" name="sys_type" width="-1" hidden="0"/>
      <column type="field" name="connecat_id" width="-1" hidden="0"/>
      <column type="field" name="expl_id" width="-1" hidden="0"/>
      <column type="field" name="macroexpl_id" width="-1" hidden="0"/>
      <column type="field" name="sector_id" width="-1" hidden="0"/>
      <column type="field" name="macrosector_id" width="-1" hidden="0"/>
      <column type="field" name="customer_code" width="-1" hidden="0"/>
      <column type="field" name="cat_matcat_id" width="-1" hidden="0"/>
      <column type="field" name="cat_pnom" width="-1" hidden="0"/>
      <column type="field" name="cat_dnom" width="-1" hidden="0"/>
      <column type="field" name="connec_length" width="-1" hidden="0"/>
      <column type="field" name="state" width="-1" hidden="0"/>
      <column type="field" name="state_type" width="-1" hidden="0"/>
      <column type="field" name="n_hydrometer" width="-1" hidden="0"/>
      <column type="field" name="arc_id" width="-1" hidden="0"/>
      <column type="field" name="annotation" width="-1" hidden="0"/>
      <column type="field" name="observ" width="-1" hidden="0"/>
      <column type="field" name="comment" width="-1" hidden="0"/>
      <column type="field" name="minsector_id" width="-1" hidden="0"/>
      <column type="field" name="dma_id" width="-1" hidden="0"/>
      <column type="field" name="macrodma_id" width="-1" hidden="0"/>
      <column type="field" name="presszone_id" width="-1" hidden="0"/>
      <column type="field" name="staticpressure" width="-1" hidden="0"/>
      <column type="field" name="dqa_id" width="-1" hidden="0"/>
      <column type="field" name="macrodqa_id" width="-1" hidden="0"/>
      <column type="field" name="soilcat_id" width="-1" hidden="0"/>
      <column type="field" name="function_type" width="-1" hidden="0"/>
      <column type="field" name="category_type" width="-1" hidden="0"/>
      <column type="field" name="fluid_type" width="-1" hidden="0"/>
      <column type="field" name="location_type" width="-1" hidden="0"/>
      <column type="field" name="workcat_id" width="-1" hidden="0"/>
      <column type="field" name="workcat_id_end" width="-1" hidden="0"/>
      <column type="field" name="buildercat_id" width="-1" hidden="0"/>
      <column type="field" name="builtdate" width="-1" hidden="0"/>
      <column type="field" name="enddate" width="-1" hidden="0"/>
      <column type="field" name="ownercat_id" width="-1" hidden="0"/>
      <column type="field" name="muni_id" width="-1" hidden="0"/>
      <column type="field" name="postcode" width="-1" hidden="0"/>
      <column type="field" name="district_id" width="-1" hidden="0"/>
      <column type="field" name="streetname" width="-1" hidden="0"/>
      <column type="field" name="postnumber" width="-1" hidden="0"/>
      <column type="field" name="postcomplement" width="-1" hidden="0"/>
      <column type="field" name="streetname2" width="-1" hidden="0"/>
      <column type="field" name="postnumber2" width="-1" hidden="0"/>
      <column type="field" name="postcomplement2" width="-1" hidden="0"/>
      <column type="field" name="descript" width="-1" hidden="0"/>
      <column type="field" name="svg" width="-1" hidden="0"/>
      <column type="field" name="rotation" width="-1" hidden="0"/>
      <column type="field" name="link" width="-1" hidden="0"/>
      <column type="field" name="verified" width="-1" hidden="0"/>
      <column type="field" name="undelete" width="-1" hidden="0"/>
      <column type="field" name="label" width="-1" hidden="0"/>
      <column type="field" name="label_x" width="-1" hidden="0"/>
      <column type="field" name="label_y" width="-1" hidden="0"/>
      <column type="field" name="label_rotation" width="-1" hidden="0"/>
      <column type="field" name="publish" width="-1" hidden="0"/>
      <column type="field" name="inventory" width="-1" hidden="0"/>
      <column type="field" name="num_value" width="-1" hidden="0"/>
      <column type="field" name="connectype_id" width="-1" hidden="0"/>
      <column type="field" name="feature_id" width="-1" hidden="0"/>
      <column type="field" name="featurecat_id" width="-1" hidden="0"/>
      <column type="field" name="pjoint_id" width="-1" hidden="0"/>
      <column type="field" name="pjoint_type" width="-1" hidden="0"/>
      <column type="field" name="tstamp" width="-1" hidden="0"/>
      <column type="field" name="insert_user" width="-1" hidden="0"/>
      <column type="field" name="lastupdate" width="-1" hidden="0"/>
      <column type="field" name="lastupdate_user" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
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
    <field name="arc_id" editable="1"/>
    <field name="buildercat_id" editable="1"/>
    <field name="builtdate" editable="1"/>
    <field name="cat_dnom" editable="1"/>
    <field name="cat_matcat_id" editable="1"/>
    <field name="cat_pnom" editable="1"/>
    <field name="category_type" editable="1"/>
    <field name="code" editable="1"/>
    <field name="comment" editable="1"/>
    <field name="connec_id" editable="1"/>
    <field name="connec_length" editable="1"/>
    <field name="connec_type" editable="1"/>
    <field name="connecat_id" editable="1"/>
    <field name="connectype_id" editable="1"/>
    <field name="customer_code" editable="1"/>
    <field name="depth" editable="1"/>
    <field name="descript" editable="1"/>
    <field name="district_id" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="dqa_id" editable="1"/>
    <field name="elevation" editable="1"/>
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
    <field name="macrodqa_id" editable="1"/>
    <field name="macroexpl_id" editable="1"/>
    <field name="macrosector_id" editable="1"/>
    <field name="minsector_id" editable="1"/>
    <field name="muni_id" editable="1"/>
    <field name="n_hydrometer" editable="1"/>
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
    <field name="presszone_id" editable="1"/>
    <field name="publish" editable="1"/>
    <field name="rotation" editable="1"/>
    <field name="sector_id" editable="1"/>
    <field name="soilcat_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
    <field name="staticpressure" editable="1"/>
    <field name="streetname" editable="1"/>
    <field name="streetname2" editable="1"/>
    <field name="svg" editable="1"/>
    <field name="sys_type" editable="1"/>
    <field name="tstamp" editable="1"/>
    <field name="undelete" editable="1"/>
    <field name="verified" editable="1"/>
    <field name="workcat_id" editable="1"/>
    <field name="workcat_id_end" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="annotation" labelOnTop="0"/>
    <field name="arc_id" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="cat_dnom" labelOnTop="0"/>
    <field name="cat_matcat_id" labelOnTop="0"/>
    <field name="cat_pnom" labelOnTop="0"/>
    <field name="category_type" labelOnTop="0"/>
    <field name="code" labelOnTop="0"/>
    <field name="comment" labelOnTop="0"/>
    <field name="connec_id" labelOnTop="0"/>
    <field name="connec_length" labelOnTop="0"/>
    <field name="connec_type" labelOnTop="0"/>
    <field name="connecat_id" labelOnTop="0"/>
    <field name="connectype_id" labelOnTop="0"/>
    <field name="customer_code" labelOnTop="0"/>
    <field name="depth" labelOnTop="0"/>
    <field name="descript" labelOnTop="0"/>
    <field name="district_id" labelOnTop="0"/>
    <field name="dma_id" labelOnTop="0"/>
    <field name="dqa_id" labelOnTop="0"/>
    <field name="elevation" labelOnTop="0"/>
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
    <field name="macrodqa_id" labelOnTop="0"/>
    <field name="macroexpl_id" labelOnTop="0"/>
    <field name="macrosector_id" labelOnTop="0"/>
    <field name="minsector_id" labelOnTop="0"/>
    <field name="muni_id" labelOnTop="0"/>
    <field name="n_hydrometer" labelOnTop="0"/>
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
    <field name="presszone_id" labelOnTop="0"/>
    <field name="publish" labelOnTop="0"/>
    <field name="rotation" labelOnTop="0"/>
    <field name="sector_id" labelOnTop="0"/>
    <field name="soilcat_id" labelOnTop="0"/>
    <field name="state" labelOnTop="0"/>
    <field name="state_type" labelOnTop="0"/>
    <field name="staticpressure" labelOnTop="0"/>
    <field name="streetname" labelOnTop="0"/>
    <field name="streetname2" labelOnTop="0"/>
    <field name="svg" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="tstamp" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>streetname</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('103', 'v_edit_link', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="1" simplifyDrawingTol="1" version="3.10.3-A Coruña" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" labelsEnabled="0" styleCategories="AllStyleCategories" maxScale="1" simplifyMaxScale="1" readOnly="0" minScale="1500">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="singleSymbol" symbollevels="0" forceraster="0" enableorderby="0">
    <symbols>
      <symbol type="line" name="0" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleLine" locked="0">
          <prop v="square" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="253,0,93,255" k="line_color"/>
          <prop v="dot" k="line_style"/>
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="GeometryGenerator" locked="0">
          <prop v="Marker" k="SymbolType"/>
          <prop v="end_point ($geometry)" k="geometryModifier"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <symbol type="marker" name="@0@1" alpha="1" force_rhr="0" clip_to_extent="1">
            <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
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
                  <Option type="QString" name="name" value=""/>
                  <Option name="properties"/>
                  <Option type="QString" name="type" value="collection"/>
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
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Pie">
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" scaleBasedVisibility="0" opacity="1" sizeType="MM" backgroundColor="#ffffff" width="15" scaleDependency="Area" minScaleDenominator="1" enabled="0" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="1e+08" backgroundAlpha="255" labelPlacementMethod="XHeight" height="15" rotationOffset="270" penWidth="0" penAlpha="255" penColor="#000000" barWidth="5" diagramOrientation="Up" lineSizeType="MM" minimumSize="0">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings dist="0" placement="2" showAll="1" zIndex="0" linePlacementFlags="2" priority="0" obstacle="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option type="Map" name="properties">
          <Option type="Map" name="show">
            <Option type="bool" name="active" value="true"/>
            <Option type="QString" name="field" value="link_id"/>
            <Option type="int" name="type" value="2"/>
          </Option>
        </Option>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <fieldConfiguration>
    <field name="link_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
            <Option type="bool" name="UseHtml" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="ARC" value="ARC"/>
              <Option type="QString" name="CONNEC" value="CONNEC"/>
              <Option type="QString" name="ELEMENT" value="ELEMENT"/>
              <Option type="QString" name="LINK" value="LINK"/>
              <Option type="QString" name="NODE" value="NODE"/>
              <Option type="QString" name="VNODE" value="VNODE"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="QString" name="IsMultiline" value="0"/>
            <Option type="QString" name="UseHtml" value="0"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_type">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="ARC" value="ARC"/>
              <Option type="QString" name="CONNEC" value="CONNEC"/>
              <Option type="QString" name="ELEMENT" value="ELEMENT"/>
              <Option type="QString" name="LINK" value="LINK"/>
              <Option type="QString" name="NODE" value="NODE"/>
              <Option type="QString" name="VNODE" value="VNODE"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="QString" name="IsMultiline" value="0"/>
            <Option type="QString" name="UseHtml" value="0"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="Undefined" value="0"/>
              <Option type="QString" name="sector1-1d" value="3"/>
              <Option type="QString" name="sector1-1s" value="1"/>
              <Option type="QString" name="sector1-2s" value="2"/>
              <Option type="QString" name="sector2-1d" value="5"/>
              <Option type="QString" name="sector2-1s" value="4"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="Undefined" value="0"/>
              <Option type="QString" name="macrosector_01" value="1"/>
              <Option type="QString" name="macrosector_02" value="2"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="Undefined" value="0"/>
              <Option type="QString" name="dma1-1d" value="1"/>
              <Option type="QString" name="dma1-2d" value="2"/>
              <Option type="QString" name="dma2-1d" value="3"/>
              <Option type="QString" name="source-1" value="4"/>
              <Option type="QString" name="source-2" value="5"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="Undefined" value="0"/>
              <Option type="QString" name="macrodma_01" value="1"/>
              <Option type="QString" name="macrodma_02" value="2"/>
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
              <Option type="QString" name="Undefined" value="0"/>
              <Option type="QString" name="expl_01" value="1"/>
              <Option type="QString" name="expl_02" value="2"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option type="Map" name="map">
              <Option type="QString" name="OBSOLETE" value="0"/>
              <Option type="QString" name="ON_SERVICE" value="1"/>
              <Option type="QString" name="PLANIFIED" value="2"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gis_length">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="QString" name="IsMultiline" value="0"/>
            <Option type="QString" name="UseHtml" value="0"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="userdefined_geom">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="QString" name="IsMultiline" value="0"/>
            <Option type="QString" name="UseHtml" value="0"/>
          </Option>
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
    <alias name="link_id" index="0" field="link_id"/>
    <alias name="feature_type" index="1" field="feature_type"/>
    <alias name="feature_id" index="2" field="feature_id"/>
    <alias name="exit_type" index="3" field="exit_type"/>
    <alias name="exit_id" index="4" field="exit_id"/>
    <alias name="sector_id" index="5" field="sector_id"/>
    <alias name="macrosector_id" index="6" field="macrosector_id"/>
    <alias name="dma_id" index="7" field="dma_id"/>
    <alias name="macrodma_id" index="8" field="macrodma_id"/>
    <alias name="expl_id" index="9" field="expl_id"/>
    <alias name="state" index="10" field="state"/>
    <alias name="gis_length" index="11" field="gis_length"/>
    <alias name="userdefined_geom" index="12" field="userdefined_geom"/>
    <alias name="ispsectorgeom" index="13" field="ispsectorgeom"/>
    <alias name="psector_rowid" index="14" field="psector_rowid"/>
    <alias name="" index="15" field="fluid_type"/>
    <alias name="" index="16" field="vnode_topelev"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="link_id"/>
    <default applyOnUpdate="0" expression="" field="feature_type"/>
    <default applyOnUpdate="0" expression="" field="feature_id"/>
    <default applyOnUpdate="0" expression="" field="exit_type"/>
    <default applyOnUpdate="0" expression="" field="exit_id"/>
    <default applyOnUpdate="0" expression="" field="sector_id"/>
    <default applyOnUpdate="0" expression="" field="macrosector_id"/>
    <default applyOnUpdate="0" expression="" field="dma_id"/>
    <default applyOnUpdate="0" expression="" field="macrodma_id"/>
    <default applyOnUpdate="0" expression="" field="expl_id"/>
    <default applyOnUpdate="0" expression="" field="state"/>
    <default applyOnUpdate="0" expression="" field="gis_length"/>
    <default applyOnUpdate="0" expression="" field="userdefined_geom"/>
    <default applyOnUpdate="0" expression="" field="ispsectorgeom"/>
    <default applyOnUpdate="0" expression="" field="psector_rowid"/>
    <default applyOnUpdate="0" expression="" field="fluid_type"/>
    <default applyOnUpdate="0" expression="" field="vnode_topelev"/>
  </defaults>
  <constraints>
    <constraint constraints="3" unique_strength="1" exp_strength="0" field="link_id" notnull_strength="2"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="feature_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="feature_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="exit_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="exit_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrosector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="expl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="gis_length" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="userdefined_geom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="ispsectorgeom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="psector_rowid" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="fluid_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="vnode_topelev" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="link_id"/>
    <constraint desc="" exp="" field="feature_type"/>
    <constraint desc="" exp="" field="feature_id"/>
    <constraint desc="" exp="" field="exit_type"/>
    <constraint desc="" exp="" field="exit_id"/>
    <constraint desc="" exp="" field="sector_id"/>
    <constraint desc="" exp="" field="macrosector_id"/>
    <constraint desc="" exp="" field="dma_id"/>
    <constraint desc="" exp="" field="macrodma_id"/>
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
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="&quot;sector_id&quot;" sortOrder="1">
    <columns>
      <column type="field" name="link_id" width="-1" hidden="0"/>
      <column type="field" name="feature_type" width="-1" hidden="0"/>
      <column type="field" name="feature_id" width="-1" hidden="0"/>
      <column type="field" name="exit_type" width="-1" hidden="0"/>
      <column type="field" name="exit_id" width="-1" hidden="0"/>
      <column type="field" name="sector_id" width="-1" hidden="0"/>
      <column type="field" name="dma_id" width="-1" hidden="0"/>
      <column type="field" name="expl_id" width="-1" hidden="0"/>
      <column type="field" name="state" width="-1" hidden="0"/>
      <column type="field" name="gis_length" width="-1" hidden="0"/>
      <column type="field" name="userdefined_geom" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
      <column type="field" name="macrosector_id" width="-1" hidden="0"/>
      <column type="field" name="macrodma_id" width="-1" hidden="0"/>
      <column type="field" name="ispsectorgeom" width="-1" hidden="0"/>
      <column type="field" name="psector_rowid" width="-1" hidden="0"/>
      <column type="field" name="fluid_type" width="-1" hidden="0"/>
      <column type="field" name="vnode_topelev" width="-1" hidden="0"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1">C:/Users/Nestor</editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath>Program Files/QGIS 3.4</editforminitfilepath>
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
  <featformsuppress>2</featformsuppress>
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
    <field name="macrodma_id" editable="0"/>
    <field name="macrosector_id" editable="0"/>
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
  <previewExpression>COALESCE( "link_id", '&lt;NULL>' )</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_style (id, idval, styletype, stylevalue, active)
VALUES('104', 'v_edit_node', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="0" simplifyDrawingTol="1" version="3.10.3-A Coruña" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" labelsEnabled="0" styleCategories="AllStyleCategories" maxScale="0" simplifyMaxScale="1" readOnly="0" minScale="1e+08">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 type="RuleRenderer" symbollevels="0" forceraster="0" enableorderby="0">
    <rules key="{f9bd1dda-e8cb-4456-b498-a3f1312029f9}">
      <rule scalemaxdenom="25000" key="{d0729bdd-7dcb-4e5d-9962-cd92c35d405e}" filter="&quot;sys_type&quot; = 'WTP'" label="Wtp" symbol="0"/>
      <rule scalemaxdenom="25000" key="{2ecb80ea-9da6-4533-aad0-7275c5a08550}" filter="&quot;sys_type&quot; = 'WATERWELL'" label="Waterwell" symbol="1"/>
      <rule scalemaxdenom="25000" key="{88ef1cea-1727-4681-9d7e-964bcfee179f}" filter="&quot;sys_type&quot; = 'SOURCE'" label="Source" symbol="2"/>
      <rule scalemaxdenom="25000" key="{5d885b4a-fd95-42b2-8da9-717face5a272}" filter="&quot;sys_type&quot; = 'TANK'" label="Tank" symbol="3"/>
      <rule scalemaxdenom="2500" key="{eed06555-2d38-4bfe-b114-13e014b63af1}" filter="&quot;sys_type&quot; = 'EXPANSIONTANK'" label="Expantank" symbol="4"/>
      <rule scalemaxdenom="2500" key="{d2138541-5cb8-4896-b97e-494fa6df6d40}" filter="&quot;sys_type&quot; = 'FILTER'" label="Filter" symbol="5"/>
      <rule scalemaxdenom="2500" key="{9f0ffeda-84af-4676-9263-119eb6042786}" filter="&quot;sys_type&quot; = 'FLEXUNION'" label="Flexunion" symbol="6"/>
      <rule scalemaxdenom="2500" key="{bfe404fe-23c9-4c26-a91e-bc5e89b7203b}" filter="&quot;sys_type&quot; = 'HYDRANT'" label="Hydrant" symbol="7"/>
      <rule scalemaxdenom="2500" key="{70f23680-8f8d-4eb8-ad9d-b6c222b1359a}" filter="&quot;sys_type&quot; = 'METER'" label="Meter" symbol="8"/>
      <rule scalemaxdenom="2500" key="{086f2a29-0a69-4a25-9b96-9f5d9f2955c1}" filter="&quot;sys_type&quot; = 'NETELEMENT'" label="Netelement" symbol="9"/>
      <rule scalemaxdenom="2500" key="{c0f1b0c8-34ee-4ec4-a914-97824ad2c467}" filter="&quot;sys_type&quot; = 'NETSAMPLEPOINT'" label="Netsamplepoint" symbol="10"/>
      <rule scalemaxdenom="2500" key="{01479095-8f9e-40cf-b92b-6e13874561ae}" filter="&quot;sys_type&quot; = 'PUMP'" label="Pump" symbol="11"/>
      <rule scalemaxdenom="2500" key="{8e1a0afb-c274-48ae-95a9-9c35583776c7}" filter="&quot;sys_type&quot; = 'REGISTER'" label="Register" symbol="12"/>
      <rule scalemaxdenom="2500" key="{c71da5c0-8b8d-4375-839b-e3ccf0c41b56}" filter="&quot;sys_type&quot; = 'MANHOLE'" label="Manhole" symbol="13"/>
      <rule scalemaxdenom="2500" key="{94bc6268-f342-4b79-a7f0-d8ba6498eb62}" filter="&quot;sys_type&quot; = 'REDUCTION'" label="Reduction" symbol="14"/>
      <rule scalemaxdenom="2500" key="{d6c2b118-3f7e-4809-a8e8-e6857e5a3f87}" filter="&quot;sys_type&quot; = 'VALVE'" label="Valve" symbol="15"/>
      <rule scalemaxdenom="2500" key="{2bb6a916-46c5-4610-b8fa-4a7a93cfe697}" filter="&quot;sys_type&quot; = 'JUNCTION'" label="Junction" symbol="16"/>
      <rule scalemaxdenom="1500" key="{475bbd67-e8c5-496e-84cd-3f0a8b3bf35d}" filter="&quot;sys_type&quot; = 'NETWJOIN'" label="Netwjoin" symbol="17"/>
    </rules>
    <symbols>
      <symbol type="marker" name="0" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="50,48,55,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="W" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="1" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="255,127,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="W" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="10" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="0,100,200,255" k="color"/>
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="S" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="2.5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="11" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="255,127,0,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="P" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="12" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="32,10,129,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="R" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="13" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="151,234,218,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="M" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="14" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="237,183,25,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="R" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="15" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="26,115,162,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="V" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="16" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="0,242,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="50,48,55,255" k="outline_color"/>
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
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="17" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="70,151,75,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3.75" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="255,255,255,255" k="color"/>
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
          <prop v="5" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="2" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="35,200,120,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="S" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="3" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="26,115,162,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="D" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="4" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="25,237,206,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="E" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="5" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="251,154,153,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="F" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="6" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="191,246,61,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="F" k="chr"/>
          <prop v="0,0,0,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="7" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="227,26,28,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="H" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="8" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="133,133,133,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="M" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol type="marker" name="9" alpha="1" force_rhr="0" clip_to_extent="1">
        <layer pass="0" enabled="1" class="SimpleMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="129,10,78,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,0,0,0" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="4.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer pass="0" enabled="1" class="FontMarker" locked="0">
          <prop v="0" k="angle"/>
          <prop v="E" k="chr"/>
          <prop v="255,255,255,255" k="color"/>
          <prop v="Dingbats" k="font"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="0.20000000000000001,-0.20000000000000001" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="255,255,255,255" k="outline_color"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="3.2" k="size"/>
          <prop v="3x:0,0,0,0,0,0" k="size_map_unit_scale"/>
          <prop v="MM" k="size_unit"/>
          <prop v="1" k="vertical_anchor_point"/>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties>
    <property value="streetname" key="dualview/previewExpressions"/>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory lineSizeScale="3x:0,0,0,0,0,0" scaleBasedVisibility="0" opacity="1" sizeType="MM" backgroundColor="#ffffff" width="15" scaleDependency="Area" minScaleDenominator="0" enabled="0" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="1e+08" backgroundAlpha="255" labelPlacementMethod="XHeight" height="15" rotationOffset="270" penWidth="0" penAlpha="255" penColor="#000000" barWidth="5" diagramOrientation="Up" lineSizeType="MM" minimumSize="0">
      <fontProperties style="" description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0"/>
      <attribute label="" color="#000000" field=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings dist="0" placement="0" showAll="1" zIndex="0" linePlacementFlags="18" priority="0" obstacle="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
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
    <field name="elevation">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="depth">
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
    <field name="cat_matcat_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_pnom">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="cat_dnom">
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
    <field name="sector_name">
      <editWidget type="">
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
    <field name="arc_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="parent_id">
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
    <field name="minsector_id">
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
    <field name="dma_name">
      <editWidget type="">
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
    <field name="presszone_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="staticpressure">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id">
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
    <field name="hemisphere">
      <editWidget type="TextEdit">
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
    <field name="nodetype_id">
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
    <field name="adate">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="adescript">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="accessibility">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="dma_style">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="presszone_style">
      <editWidget type="">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias name="" index="0" field="node_id"/>
    <alias name="" index="1" field="code"/>
    <alias name="" index="2" field="elevation"/>
    <alias name="" index="3" field="depth"/>
    <alias name="" index="4" field="node_type"/>
    <alias name="" index="5" field="sys_type"/>
    <alias name="" index="6" field="nodecat_id"/>
    <alias name="" index="7" field="cat_matcat_id"/>
    <alias name="" index="8" field="cat_pnom"/>
    <alias name="" index="9" field="cat_dnom"/>
    <alias name="" index="10" field="epa_type"/>
    <alias name="" index="11" field="expl_id"/>
    <alias name="" index="12" field="macroexpl_id"/>
    <alias name="" index="13" field="sector_id"/>
    <alias name="" index="14" field="sector_name"/>
    <alias name="" index="15" field="macrosector_id"/>
    <alias name="" index="16" field="arc_id"/>
    <alias name="" index="17" field="parent_id"/>
    <alias name="" index="18" field="state"/>
    <alias name="" index="19" field="state_type"/>
    <alias name="" index="20" field="annotation"/>
    <alias name="" index="21" field="observ"/>
    <alias name="" index="22" field="comment"/>
    <alias name="" index="23" field="minsector_id"/>
    <alias name="" index="24" field="dma_id"/>
    <alias name="" index="25" field="dma_name"/>
    <alias name="" index="26" field="macrodma_id"/>
    <alias name="" index="27" field="presszone_id"/>
    <alias name="" index="28" field="presszone_name"/>
    <alias name="" index="29" field="staticpressure"/>
    <alias name="" index="30" field="dqa_id"/>
    <alias name="" index="31" field="dqa_name"/>
    <alias name="" index="32" field="macrodqa_id"/>
    <alias name="" index="33" field="soilcat_id"/>
    <alias name="" index="34" field="function_type"/>
    <alias name="" index="35" field="category_type"/>
    <alias name="" index="36" field="fluid_type"/>
    <alias name="" index="37" field="location_type"/>
    <alias name="" index="38" field="workcat_id"/>
    <alias name="" index="39" field="workcat_id_end"/>
    <alias name="" index="40" field="builtdate"/>
    <alias name="" index="41" field="enddate"/>
    <alias name="" index="42" field="buildercat_id"/>
    <alias name="" index="43" field="ownercat_id"/>
    <alias name="" index="44" field="muni_id"/>
    <alias name="" index="45" field="postcode"/>
    <alias name="" index="46" field="district_id"/>
    <alias name="" index="47" field="streetname"/>
    <alias name="" index="48" field="postnumber"/>
    <alias name="" index="49" field="postcomplement"/>
    <alias name="" index="50" field="streetname2"/>
    <alias name="" index="51" field="postnumber2"/>
    <alias name="" index="52" field="postcomplement2"/>
    <alias name="" index="53" field="descript"/>
    <alias name="" index="54" field="svg"/>
    <alias name="" index="55" field="rotation"/>
    <alias name="" index="56" field="link"/>
    <alias name="" index="57" field="verified"/>
    <alias name="" index="58" field="undelete"/>
    <alias name="" index="59" field="label"/>
    <alias name="" index="60" field="label_x"/>
    <alias name="" index="61" field="label_y"/>
    <alias name="" index="62" field="label_rotation"/>
    <alias name="" index="63" field="publish"/>
    <alias name="" index="64" field="inventory"/>
    <alias name="" index="65" field="hemisphere"/>
    <alias name="" index="66" field="num_value"/>
    <alias name="" index="67" field="nodetype_id"/>
    <alias name="" index="68" field="tstamp"/>
    <alias name="" index="69" field="insert_user"/>
    <alias name="" index="70" field="lastupdate"/>
    <alias name="" index="71" field="lastupdate_user"/>
    <alias name="" index="72" field="adate"/>
    <alias name="" index="73" field="adescript"/>
    <alias name="" index="74" field="accessibility"/>
    <alias name="" index="75" field="dma_style"/>
    <alias name="" index="76" field="presszone_style"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="node_id"/>
    <default applyOnUpdate="0" expression="" field="code"/>
    <default applyOnUpdate="0" expression="" field="elevation"/>
    <default applyOnUpdate="0" expression="" field="depth"/>
    <default applyOnUpdate="0" expression="" field="node_type"/>
    <default applyOnUpdate="0" expression="" field="sys_type"/>
    <default applyOnUpdate="0" expression="" field="nodecat_id"/>
    <default applyOnUpdate="0" expression="" field="cat_matcat_id"/>
    <default applyOnUpdate="0" expression="" field="cat_pnom"/>
    <default applyOnUpdate="0" expression="" field="cat_dnom"/>
    <default applyOnUpdate="0" expression="" field="epa_type"/>
    <default applyOnUpdate="0" expression="" field="expl_id"/>
    <default applyOnUpdate="0" expression="" field="macroexpl_id"/>
    <default applyOnUpdate="0" expression="" field="sector_id"/>
    <default applyOnUpdate="0" expression="" field="sector_name"/>
    <default applyOnUpdate="0" expression="" field="macrosector_id"/>
    <default applyOnUpdate="0" expression="" field="arc_id"/>
    <default applyOnUpdate="0" expression="" field="parent_id"/>
    <default applyOnUpdate="0" expression="" field="state"/>
    <default applyOnUpdate="0" expression="" field="state_type"/>
    <default applyOnUpdate="0" expression="" field="annotation"/>
    <default applyOnUpdate="0" expression="" field="observ"/>
    <default applyOnUpdate="0" expression="" field="comment"/>
    <default applyOnUpdate="0" expression="" field="minsector_id"/>
    <default applyOnUpdate="0" expression="" field="dma_id"/>
    <default applyOnUpdate="0" expression="" field="dma_name"/>
    <default applyOnUpdate="0" expression="" field="macrodma_id"/>
    <default applyOnUpdate="0" expression="" field="presszone_id"/>
    <default applyOnUpdate="0" expression="" field="presszone_name"/>
    <default applyOnUpdate="0" expression="" field="staticpressure"/>
    <default applyOnUpdate="0" expression="" field="dqa_id"/>
    <default applyOnUpdate="0" expression="" field="dqa_name"/>
    <default applyOnUpdate="0" expression="" field="macrodqa_id"/>
    <default applyOnUpdate="0" expression="" field="soilcat_id"/>
    <default applyOnUpdate="0" expression="" field="function_type"/>
    <default applyOnUpdate="0" expression="" field="category_type"/>
    <default applyOnUpdate="0" expression="" field="fluid_type"/>
    <default applyOnUpdate="0" expression="" field="location_type"/>
    <default applyOnUpdate="0" expression="" field="workcat_id"/>
    <default applyOnUpdate="0" expression="" field="workcat_id_end"/>
    <default applyOnUpdate="0" expression="" field="builtdate"/>
    <default applyOnUpdate="0" expression="" field="enddate"/>
    <default applyOnUpdate="0" expression="" field="buildercat_id"/>
    <default applyOnUpdate="0" expression="" field="ownercat_id"/>
    <default applyOnUpdate="0" expression="" field="muni_id"/>
    <default applyOnUpdate="0" expression="" field="postcode"/>
    <default applyOnUpdate="0" expression="" field="district_id"/>
    <default applyOnUpdate="0" expression="" field="streetname"/>
    <default applyOnUpdate="0" expression="" field="postnumber"/>
    <default applyOnUpdate="0" expression="" field="postcomplement"/>
    <default applyOnUpdate="0" expression="" field="streetname2"/>
    <default applyOnUpdate="0" expression="" field="postnumber2"/>
    <default applyOnUpdate="0" expression="" field="postcomplement2"/>
    <default applyOnUpdate="0" expression="" field="descript"/>
    <default applyOnUpdate="0" expression="" field="svg"/>
    <default applyOnUpdate="0" expression="" field="rotation"/>
    <default applyOnUpdate="0" expression="" field="link"/>
    <default applyOnUpdate="0" expression="" field="verified"/>
    <default applyOnUpdate="0" expression="" field="undelete"/>
    <default applyOnUpdate="0" expression="" field="label"/>
    <default applyOnUpdate="0" expression="" field="label_x"/>
    <default applyOnUpdate="0" expression="" field="label_y"/>
    <default applyOnUpdate="0" expression="" field="label_rotation"/>
    <default applyOnUpdate="0" expression="" field="publish"/>
    <default applyOnUpdate="0" expression="" field="inventory"/>
    <default applyOnUpdate="0" expression="" field="hemisphere"/>
    <default applyOnUpdate="0" expression="" field="num_value"/>
    <default applyOnUpdate="0" expression="" field="nodetype_id"/>
    <default applyOnUpdate="0" expression="" field="tstamp"/>
    <default applyOnUpdate="0" expression="" field="insert_user"/>
    <default applyOnUpdate="0" expression="" field="lastupdate"/>
    <default applyOnUpdate="0" expression="" field="lastupdate_user"/>
    <default applyOnUpdate="0" expression="" field="adate"/>
    <default applyOnUpdate="0" expression="" field="adescript"/>
    <default applyOnUpdate="0" expression="" field="accessibility"/>
    <default applyOnUpdate="0" expression="" field="dma_style"/>
    <default applyOnUpdate="0" expression="" field="presszone_style"/>
  </defaults>
  <constraints>
    <constraint constraints="3" unique_strength="1" exp_strength="0" field="node_id" notnull_strength="1"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="code" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="elevation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="depth" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="node_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sys_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="nodecat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_matcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_pnom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="cat_dnom" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="epa_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="expl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macroexpl_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="sector_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrosector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="arc_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="parent_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="state_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="annotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="observ" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="comment" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="minsector_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodma_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="staticpressure" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dqa_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dqa_name" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="macrodqa_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="soilcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="function_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="category_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="fluid_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="location_type" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="workcat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="workcat_id_end" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="builtdate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="enddate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="buildercat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="ownercat_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="muni_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcode" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="district_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="streetname" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postnumber" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcomplement" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="streetname2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postnumber2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="postcomplement2" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="descript" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="svg" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="rotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="link" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="verified" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="undelete" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_x" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_y" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="label_rotation" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="publish" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="inventory" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="hemisphere" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="num_value" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="nodetype_id" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="tstamp" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="insert_user" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="lastupdate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="lastupdate_user" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="adate" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="adescript" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="accessibility" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="dma_style" notnull_strength="0"/>
    <constraint constraints="0" unique_strength="0" exp_strength="0" field="presszone_style" notnull_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" exp="" field="node_id"/>
    <constraint desc="" exp="" field="code"/>
    <constraint desc="" exp="" field="elevation"/>
    <constraint desc="" exp="" field="depth"/>
    <constraint desc="" exp="" field="node_type"/>
    <constraint desc="" exp="" field="sys_type"/>
    <constraint desc="" exp="" field="nodecat_id"/>
    <constraint desc="" exp="" field="cat_matcat_id"/>
    <constraint desc="" exp="" field="cat_pnom"/>
    <constraint desc="" exp="" field="cat_dnom"/>
    <constraint desc="" exp="" field="epa_type"/>
    <constraint desc="" exp="" field="expl_id"/>
    <constraint desc="" exp="" field="macroexpl_id"/>
    <constraint desc="" exp="" field="sector_id"/>
    <constraint desc="" exp="" field="sector_name"/>
    <constraint desc="" exp="" field="macrosector_id"/>
    <constraint desc="" exp="" field="arc_id"/>
    <constraint desc="" exp="" field="parent_id"/>
    <constraint desc="" exp="" field="state"/>
    <constraint desc="" exp="" field="state_type"/>
    <constraint desc="" exp="" field="annotation"/>
    <constraint desc="" exp="" field="observ"/>
    <constraint desc="" exp="" field="comment"/>
    <constraint desc="" exp="" field="minsector_id"/>
    <constraint desc="" exp="" field="dma_id"/>
    <constraint desc="" exp="" field="dma_name"/>
    <constraint desc="" exp="" field="macrodma_id"/>
    <constraint desc="" exp="" field="presszone_id"/>
    <constraint desc="" exp="" field="presszone_name"/>
    <constraint desc="" exp="" field="staticpressure"/>
    <constraint desc="" exp="" field="dqa_id"/>
    <constraint desc="" exp="" field="dqa_name"/>
    <constraint desc="" exp="" field="macrodqa_id"/>
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
    <constraint desc="" exp="" field="hemisphere"/>
    <constraint desc="" exp="" field="num_value"/>
    <constraint desc="" exp="" field="nodetype_id"/>
    <constraint desc="" exp="" field="tstamp"/>
    <constraint desc="" exp="" field="insert_user"/>
    <constraint desc="" exp="" field="lastupdate"/>
    <constraint desc="" exp="" field="lastupdate_user"/>
    <constraint desc="" exp="" field="adate"/>
    <constraint desc="" exp="" field="adescript"/>
    <constraint desc="" exp="" field="accessibility"/>
    <constraint desc="" exp="" field="dma_style"/>
    <constraint desc="" exp="" field="presszone_style"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" name="node_id" width="-1" hidden="0"/>
      <column type="field" name="code" width="-1" hidden="0"/>
      <column type="field" name="elevation" width="-1" hidden="0"/>
      <column type="field" name="depth" width="-1" hidden="0"/>
      <column type="field" name="node_type" width="-1" hidden="0"/>
      <column type="field" name="sys_type" width="-1" hidden="0"/>
      <column type="field" name="nodecat_id" width="-1" hidden="0"/>
      <column type="field" name="cat_matcat_id" width="-1" hidden="0"/>
      <column type="field" name="cat_pnom" width="-1" hidden="0"/>
      <column type="field" name="cat_dnom" width="-1" hidden="0"/>
      <column type="field" name="epa_type" width="-1" hidden="0"/>
      <column type="field" name="expl_id" width="-1" hidden="0"/>
      <column type="field" name="macroexpl_id" width="-1" hidden="0"/>
      <column type="field" name="sector_id" width="-1" hidden="0"/>
      <column type="field" name="macrosector_id" width="-1" hidden="0"/>
      <column type="field" name="arc_id" width="-1" hidden="0"/>
      <column type="field" name="parent_id" width="-1" hidden="0"/>
      <column type="field" name="state" width="-1" hidden="0"/>
      <column type="field" name="state_type" width="-1" hidden="0"/>
      <column type="field" name="annotation" width="-1" hidden="0"/>
      <column type="field" name="observ" width="-1" hidden="0"/>
      <column type="field" name="comment" width="-1" hidden="0"/>
      <column type="field" name="minsector_id" width="-1" hidden="0"/>
      <column type="field" name="dma_id" width="-1" hidden="0"/>
      <column type="field" name="macrodma_id" width="-1" hidden="0"/>
      <column type="field" name="presszone_id" width="-1" hidden="0"/>
      <column type="field" name="staticpressure" width="-1" hidden="0"/>
      <column type="field" name="dqa_id" width="-1" hidden="0"/>
      <column type="field" name="macrodqa_id" width="-1" hidden="0"/>
      <column type="field" name="soilcat_id" width="-1" hidden="0"/>
      <column type="field" name="function_type" width="-1" hidden="0"/>
      <column type="field" name="category_type" width="-1" hidden="0"/>
      <column type="field" name="fluid_type" width="-1" hidden="0"/>
      <column type="field" name="location_type" width="-1" hidden="0"/>
      <column type="field" name="workcat_id" width="-1" hidden="0"/>
      <column type="field" name="workcat_id_end" width="-1" hidden="0"/>
      <column type="field" name="builtdate" width="-1" hidden="0"/>
      <column type="field" name="enddate" width="-1" hidden="0"/>
      <column type="field" name="buildercat_id" width="-1" hidden="0"/>
      <column type="field" name="ownercat_id" width="-1" hidden="0"/>
      <column type="field" name="muni_id" width="-1" hidden="0"/>
      <column type="field" name="postcode" width="-1" hidden="0"/>
      <column type="field" name="district_id" width="-1" hidden="0"/>
      <column type="field" name="streetname" width="-1" hidden="0"/>
      <column type="field" name="postnumber" width="-1" hidden="0"/>
      <column type="field" name="postcomplement" width="-1" hidden="0"/>
      <column type="field" name="streetname2" width="-1" hidden="0"/>
      <column type="field" name="postnumber2" width="-1" hidden="0"/>
      <column type="field" name="postcomplement2" width="-1" hidden="0"/>
      <column type="field" name="descript" width="-1" hidden="0"/>
      <column type="field" name="svg" width="-1" hidden="0"/>
      <column type="field" name="rotation" width="-1" hidden="0"/>
      <column type="field" name="link" width="-1" hidden="0"/>
      <column type="field" name="verified" width="-1" hidden="0"/>
      <column type="field" name="undelete" width="-1" hidden="0"/>
      <column type="field" name="label" width="-1" hidden="0"/>
      <column type="field" name="label_x" width="-1" hidden="0"/>
      <column type="field" name="label_y" width="-1" hidden="0"/>
      <column type="field" name="label_rotation" width="-1" hidden="0"/>
      <column type="field" name="publish" width="-1" hidden="0"/>
      <column type="field" name="inventory" width="-1" hidden="0"/>
      <column type="field" name="hemisphere" width="-1" hidden="0"/>
      <column type="field" name="num_value" width="-1" hidden="0"/>
      <column type="field" name="nodetype_id" width="-1" hidden="0"/>
      <column type="field" name="tstamp" width="-1" hidden="0"/>
      <column type="field" name="insert_user" width="-1" hidden="0"/>
      <column type="field" name="lastupdate" width="-1" hidden="0"/>
      <column type="field" name="lastupdate_user" width="-1" hidden="0"/>
      <column type="actions" width="-1" hidden="1"/>
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
    <field name="arc_id" editable="1"/>
    <field name="buildercat_id" editable="1"/>
    <field name="builtdate" editable="1"/>
    <field name="cat_dnom" editable="1"/>
    <field name="cat_matcat_id" editable="1"/>
    <field name="cat_pnom" editable="1"/>
    <field name="category_type" editable="1"/>
    <field name="code" editable="1"/>
    <field name="comment" editable="1"/>
    <field name="depth" editable="1"/>
    <field name="descript" editable="1"/>
    <field name="district_id" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="dqa_id" editable="1"/>
    <field name="elevation" editable="1"/>
    <field name="enddate" editable="1"/>
    <field name="epa_type" editable="1"/>
    <field name="expl_id" editable="1"/>
    <field name="fluid_type" editable="1"/>
    <field name="function_type" editable="1"/>
    <field name="hemisphere" editable="1"/>
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
    <field name="macrodqa_id" editable="1"/>
    <field name="macroexpl_id" editable="1"/>
    <field name="macrosector_id" editable="1"/>
    <field name="minsector_id" editable="1"/>
    <field name="muni_id" editable="1"/>
    <field name="node_id" editable="1"/>
    <field name="node_type" editable="1"/>
    <field name="nodecat_id" editable="1"/>
    <field name="nodetype_id" editable="1"/>
    <field name="num_value" editable="1"/>
    <field name="observ" editable="1"/>
    <field name="ownercat_id" editable="1"/>
    <field name="parent_id" editable="1"/>
    <field name="postcode" editable="1"/>
    <field name="postcomplement" editable="1"/>
    <field name="postcomplement2" editable="1"/>
    <field name="postnumber" editable="1"/>
    <field name="postnumber2" editable="1"/>
    <field name="presszone_id" editable="1"/>
    <field name="publish" editable="1"/>
    <field name="rotation" editable="1"/>
    <field name="sector_id" editable="1"/>
    <field name="soilcat_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
    <field name="staticpressure" editable="1"/>
    <field name="streetname" editable="1"/>
    <field name="streetname2" editable="1"/>
    <field name="svg" editable="1"/>
    <field name="sys_type" editable="1"/>
    <field name="tstamp" editable="1"/>
    <field name="undelete" editable="1"/>
    <field name="verified" editable="1"/>
    <field name="workcat_id" editable="1"/>
    <field name="workcat_id_end" editable="1"/>
  </editable>
  <labelOnTop>
    <field name="annotation" labelOnTop="0"/>
    <field name="arc_id" labelOnTop="0"/>
    <field name="buildercat_id" labelOnTop="0"/>
    <field name="builtdate" labelOnTop="0"/>
    <field name="cat_dnom" labelOnTop="0"/>
    <field name="cat_matcat_id" labelOnTop="0"/>
    <field name="cat_pnom" labelOnTop="0"/>
    <field name="category_type" labelOnTop="0"/>
    <field name="code" labelOnTop="0"/>
    <field name="comment" labelOnTop="0"/>
    <field name="depth" labelOnTop="0"/>
    <field name="descript" labelOnTop="0"/>
    <field name="district_id" labelOnTop="0"/>
    <field name="dma_id" labelOnTop="0"/>
    <field name="dqa_id" labelOnTop="0"/>
    <field name="elevation" labelOnTop="0"/>
    <field name="enddate" labelOnTop="0"/>
    <field name="epa_type" labelOnTop="0"/>
    <field name="expl_id" labelOnTop="0"/>
    <field name="fluid_type" labelOnTop="0"/>
    <field name="function_type" labelOnTop="0"/>
    <field name="hemisphere" labelOnTop="0"/>
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
    <field name="macrodqa_id" labelOnTop="0"/>
    <field name="macroexpl_id" labelOnTop="0"/>
    <field name="macrosector_id" labelOnTop="0"/>
    <field name="minsector_id" labelOnTop="0"/>
    <field name="muni_id" labelOnTop="0"/>
    <field name="node_id" labelOnTop="0"/>
    <field name="node_type" labelOnTop="0"/>
    <field name="nodecat_id" labelOnTop="0"/>
    <field name="nodetype_id" labelOnTop="0"/>
    <field name="num_value" labelOnTop="0"/>
    <field name="observ" labelOnTop="0"/>
    <field name="ownercat_id" labelOnTop="0"/>
    <field name="parent_id" labelOnTop="0"/>
    <field name="postcode" labelOnTop="0"/>
    <field name="postcomplement" labelOnTop="0"/>
    <field name="postcomplement2" labelOnTop="0"/>
    <field name="postnumber" labelOnTop="0"/>
    <field name="postnumber2" labelOnTop="0"/>
    <field name="presszone_id" labelOnTop="0"/>
    <field name="publish" labelOnTop="0"/>
    <field name="rotation" labelOnTop="0"/>
    <field name="sector_id" labelOnTop="0"/>
    <field name="soilcat_id" labelOnTop="0"/>
    <field name="state" labelOnTop="0"/>
    <field name="state_type" labelOnTop="0"/>
    <field name="staticpressure" labelOnTop="0"/>
    <field name="streetname" labelOnTop="0"/>
    <field name="streetname2" labelOnTop="0"/>
    <field name="svg" labelOnTop="0"/>
    <field name="sys_type" labelOnTop="0"/>
    <field name="tstamp" labelOnTop="0"/>
    <field name="undelete" labelOnTop="0"/>
    <field name="verified" labelOnTop="0"/>
    <field name="workcat_id" labelOnTop="0"/>
    <field name="workcat_id_end" labelOnTop="0"/>
  </labelOnTop>
  <widgets/>
  <previewExpression>streetname</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('105', 'Overlap affected arcs', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="1" hasScaleBasedVisibilityFlag="0" labelsEnabled="0" version="3.10.3-A Coruña" styleCategories="AllStyleCategories" simplifyDrawingTol="1" simplifyMaxScale="1" minScale="1e+08" simplifyAlgorithm="0" maxScale="0" simplifyLocal="1" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" enableorderby="0" type="singleSymbol" symbollevels="0">
    <symbols>
      <symbol force_rhr="0" type="line" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
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
              <Option type="QString" value="" name="name"/>
              <Option name="properties"/>
              <Option type="QString" value="collection" name="type"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
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
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option type="QString" value=""/>
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
    <alias field="arc_id" index="0" name=""/>
    <alias field="descript" index="1" name=""/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" field="arc_id" applyOnUpdate="0"/>
    <default expression="" field="descript" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" field="arc_id" unique_strength="0" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" field="descript" unique_strength="0" notnull_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="arc_id" desc=""/>
    <constraint exp="" field="descript" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
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
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('106', 'Overlap affected connecs', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis styleCategories="AllStyleCategories" simplifyDrawingTol="1" version="3.10.3-A Coruña" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" simplifyLocal="1" minScale="1e+08" simplifyDrawingHints="1" simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 enableorderby="0" symbollevels="0" type="singleSymbol" forceraster="0">
    <symbols>
      <symbol clip_to_extent="1" alpha="1" name="0" force_rhr="0" type="marker">
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,0,0,150"/>
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
          <prop k="size" v="2.6"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="0,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="cross"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="4"/>
          <prop k="size_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="size_unit" v="MM"/>
          <prop k="vertical_anchor_point" v="1"/>
          <data_defined_properties>
            <Option type="Map">
              <Option name="name" value="" type="QString"/>
              <Option name="properties"/>
              <Option name="type" value="collection" type="QString"/>
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
    <alias name="" field="descript" index="0"/>
    <alias name="" field="connec_id" index="1"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default applyOnUpdate="0" expression="" field="descript"/>
    <default applyOnUpdate="0" expression="" field="connec_id"/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" field="descript" unique_strength="0"/>
    <constraint exp_strength="0" notnull_strength="0" constraints="0" field="connec_id" unique_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" desc="" field="descript"/>
    <constraint exp="" desc="" field="connec_id"/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
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
$$, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_style(id, idval, styletype, stylevalue, active)
VALUES('107', 'Other mincuts whichs overlaps', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingHints="1" hasScaleBasedVisibilityFlag="0" labelsEnabled="0" version="3.10.3-A Coruña" styleCategories="AllStyleCategories" simplifyDrawingTol="1" simplifyMaxScale="1" minScale="1e+08" simplifyAlgorithm="0" maxScale="0" simplifyLocal="1" readOnly="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
  </flags>
  <renderer-v2 forceraster="0" enableorderby="0" type="singleSymbol" symbollevels="0">
    <symbols>
      <symbol force_rhr="0" type="fill" clip_to_extent="1" alpha="1" name="0">
        <layer locked="0" enabled="1" pass="0" class="SimpleFill">
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
  <customproperties/>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks type="StringList">
      <Option type="QString" value=""/>
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
    <alias field="pol_id" index="0" name=""/>
    <alias field="descript" index="1" name=""/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default expression="" field="pol_id" applyOnUpdate="0"/>
    <default expression="" field="descript" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint exp_strength="0" field="pol_id" unique_strength="0" notnull_strength="0" constraints="0"/>
    <constraint exp_strength="0" field="descript" unique_strength="0" notnull_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint exp="" field="pol_id" desc=""/>
    <constraint exp="" field="descript" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
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
  <layerGeometryType>2</layerGeometryType>
</qgis>
$$, true) ON CONFLICT (id) DO NOTHING;



--24/07/2020
UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_arc"]}]'
WHERE id = 'cat_mat_arc';

UPDATE sys_table SET notify_action = '[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_node", "cat_connec"]}]'
WHERE id = 'cat_mat_node';

--2020/07/28
UPDATE config_toolbox SET inputparams = '
[{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"},
{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":2,"value":0.01},
{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"stateType", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":4, 
"dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by state, id", "selectedId":"2","isparent":"true"},{"widgetname":"workcatId", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5, "dvQueryText":"select id as id, id as idval from cat_work where id is not null order by id", "selectedId":"1"},{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":6, "value":null },
{"widgetname":"nodeType", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null", "selectedId":"$userNodetype", "iseditable":false},
{"widgetname":"nodeCat", "label":"Node catalog:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8, "dvQueryText":"select distinct id as id, id as idval from cat_node where nodetype_id = $userNodetype  OR nodetype_id is null order by id", "selectedId":"$userNodecat"}]'
WHERE id =2118;


UPDATE sys_function SET function_type = 'gw_trg_ui_mincut' WHERE id = 2962;

UPDATE config_checkvalve SET active = TRUE;
UPDATE config_mincut_inlet SET active = TRUE;
UPDATE config_valve SET active = TRUE;