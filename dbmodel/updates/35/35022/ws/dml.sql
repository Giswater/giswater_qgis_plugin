/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/28
INSERT INTO sys_style(id, idval, styletype, stylevalue, active) VALUES
(110, 'v_om_mincut', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" minScale="100000000" version="3.22.1-Białowieża" readOnly="0" simplifyDrawingHints="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" symbologyReferenceScale="-1" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal endField="" durationField="" fixedDuration="0" startField="" endExpression="" mode="0" durationUnit="min" enabled="0" limitMode="0" startExpression="" accumulate="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="singleSymbol" enableorderby="0" referencescale="-1" forceraster="0" symbollevels="0">
    <symbols>
      <symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="45,84,255,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="0,24,124,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2.4"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <prop v="0" k="angle"/>
          <prop v="square" k="cap_style"/>
          <prop v="45,84,255,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0,24,124,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="2.4" k="size"/>
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
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option type="QString" name="embeddedWidgets/count" value="0"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory labelPlacementMethod="XHeight" sizeType="MM" opacity="1" lineSizeType="MM" sizeScale="3x:0,0,0,0,0,0" spacing="0" penColor="#000000" showAxis="0" height="15" barWidth="5" minScaleDenominator="0" minimumSize="0" width="15" scaleBasedVisibility="0" spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" direction="1" spacingUnit="MM" penAlpha="255" penWidth="0" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" enabled="0" scaleDependency="Area" backgroundColor="#ffffff" maxScaleDenominator="1e+08">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol type="line" name="" alpha="1" clip_to_extent="1" force_rhr="0">
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" class="SimpleLine" pass="0">
            <Option type="Map">
              <Option type="QString" name="align_dash_pattern" value="0"/>
              <Option type="QString" name="capstyle" value="square"/>
              <Option type="QString" name="customdash" value="5;2"/>
              <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="customdash_unit" value="MM"/>
              <Option type="QString" name="dash_pattern_offset" value="0"/>
              <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
              <Option type="QString" name="draw_inside_polygon" value="0"/>
              <Option type="QString" name="joinstyle" value="bevel"/>
              <Option type="QString" name="line_color" value="35,35,35,255"/>
              <Option type="QString" name="line_style" value="solid"/>
              <Option type="QString" name="line_width" value="0.26"/>
              <Option type="QString" name="line_width_unit" value="MM"/>
              <Option type="QString" name="offset" value="0"/>
              <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="offset_unit" value="MM"/>
              <Option type="QString" name="ring_filter" value="0"/>
              <Option type="QString" name="trim_distance_end" value="0"/>
              <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_end_unit" value="MM"/>
              <Option type="QString" name="trim_distance_start" value="0"/>
              <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_start_unit" value="MM"/>
              <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
              <Option type="QString" name="use_custom_dash" value="0"/>
              <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            </Option>
            <prop v="0" k="align_dash_pattern"/>
            <prop v="square" k="capstyle"/>
            <prop v="5;2" k="customdash"/>
            <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
            <prop v="MM" k="customdash_unit"/>
            <prop v="0" k="dash_pattern_offset"/>
            <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
            <prop v="MM" k="dash_pattern_offset_unit"/>
            <prop v="0" k="draw_inside_polygon"/>
            <prop v="bevel" k="joinstyle"/>
            <prop v="35,35,35,255" k="line_color"/>
            <prop v="solid" k="line_style"/>
            <prop v="0.26" k="line_width"/>
            <prop v="MM" k="line_width_unit"/>
            <prop v="0" k="offset"/>
            <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
            <prop v="MM" k="offset_unit"/>
            <prop v="0" k="ring_filter"/>
            <prop v="0" k="trim_distance_end"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
            <prop v="MM" k="trim_distance_end_unit"/>
            <prop v="0" k="trim_distance_start"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
            <prop v="MM" k="trim_distance_start_unit"/>
            <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" zIndex="0" obstacle="0" placement="0" priority="0" linePlacementFlags="18" dist="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="work_order">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="state">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="class">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="mincut_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="received_date">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="expl_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="expl_name">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="macroexpl_name">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="macroexpl_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="muni_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="muni_name">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="postcode">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="streetaxis_id">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="street_name">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="postnumber">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="QString" name="IsMultiline" value="False"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="anl_cause">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="anl_tstamp">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="anl_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="anl_descript">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="anl_feature_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="anl_feature_type">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="forecast_start">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="forecast_end">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="assigned_to">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_start">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_end">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_user">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_descript">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_the_geom">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_from_plot">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_depth">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="exec_appropiate">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option type="QString" name="CheckedState" value="true"/>
            <Option type="QString" name="UncheckedState" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="notified">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="output">
      <editWidget type="KeyValue">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" index="0" name="id"/>
    <alias field="work_order" index="1" name="work_order"/>
    <alias field="state" index="2" name="state"/>
    <alias field="class" index="3" name="class"/>
    <alias field="mincut_type" index="4" name="mincut_type"/>
    <alias field="received_date" index="5" name="received_date"/>
    <alias field="expl_id" index="6" name="expl_id"/>
    <alias field="expl_name" index="7" name="expl_name"/>
    <alias field="macroexpl_name" index="8" name="macroexpl_name"/>
    <alias field="macroexpl_id" index="9" name="macroexpl_id"/>
    <alias field="muni_id" index="10" name="muni_id"/>
    <alias field="muni_name" index="11" name="muni_name"/>
    <alias field="postcode" index="12" name="postcode"/>
    <alias field="streetaxis_id" index="13" name=""/>
    <alias field="street_name" index="14" name="street_name"/>
    <alias field="postnumber" index="15" name="postnumber"/>
    <alias field="anl_cause" index="16" name="anl_cause"/>
    <alias field="anl_tstamp" index="17" name="anl_tstamp"/>
    <alias field="anl_user" index="18" name="anl_user"/>
    <alias field="anl_descript" index="19" name="anl_descript"/>
    <alias field="anl_feature_id" index="20" name="anl_feature_id"/>
    <alias field="anl_feature_type" index="21" name="anl_feature_type"/>
    <alias field="forecast_start" index="22" name="forecast_start"/>
    <alias field="forecast_end" index="23" name="forecast_end"/>
    <alias field="assigned_to" index="24" name="assigned_to"/>
    <alias field="exec_start" index="25" name="exec_start"/>
    <alias field="exec_end" index="26" name="exec_end"/>
    <alias field="exec_user" index="27" name="exec_user"/>
    <alias field="exec_descript" index="28" name="exec_descript"/>
    <alias field="exec_the_geom" index="29" name=""/>
    <alias field="exec_from_plot" index="30" name="exec_from_plot"/>
    <alias field="exec_depth" index="31" name="exec_depth"/>
    <alias field="exec_appropiate" index="32" name="exec_appropiate"/>
    <alias field="notified" index="33" name="notified"/>
    <alias field="output" index="34" name=""/>
  </aliases>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="work_order" applyOnUpdate="0" expression=""/>
    <default field="state" applyOnUpdate="0" expression=""/>
    <default field="class" applyOnUpdate="0" expression=""/>
    <default field="mincut_type" applyOnUpdate="0" expression=""/>
    <default field="received_date" applyOnUpdate="0" expression=""/>
    <default field="expl_id" applyOnUpdate="0" expression=""/>
    <default field="expl_name" applyOnUpdate="0" expression=""/>
    <default field="macroexpl_name" applyOnUpdate="0" expression=""/>
    <default field="macroexpl_id" applyOnUpdate="0" expression=""/>
    <default field="muni_id" applyOnUpdate="0" expression=""/>
    <default field="muni_name" applyOnUpdate="0" expression=""/>
    <default field="postcode" applyOnUpdate="0" expression=""/>
    <default field="streetaxis_id" applyOnUpdate="0" expression=""/>
    <default field="street_name" applyOnUpdate="0" expression=""/>
    <default field="postnumber" applyOnUpdate="0" expression=""/>
    <default field="anl_cause" applyOnUpdate="0" expression=""/>
    <default field="anl_tstamp" applyOnUpdate="0" expression=""/>
    <default field="anl_user" applyOnUpdate="0" expression=""/>
    <default field="anl_descript" applyOnUpdate="0" expression=""/>
    <default field="anl_feature_id" applyOnUpdate="0" expression=""/>
    <default field="anl_feature_type" applyOnUpdate="0" expression=""/>
    <default field="forecast_start" applyOnUpdate="0" expression=""/>
    <default field="forecast_end" applyOnUpdate="0" expression=""/>
    <default field="assigned_to" applyOnUpdate="0" expression=""/>
    <default field="exec_start" applyOnUpdate="0" expression=""/>
    <default field="exec_end" applyOnUpdate="0" expression=""/>
    <default field="exec_user" applyOnUpdate="0" expression=""/>
    <default field="exec_descript" applyOnUpdate="0" expression=""/>
    <default field="exec_the_geom" applyOnUpdate="0" expression=""/>
    <default field="exec_from_plot" applyOnUpdate="0" expression=""/>
    <default field="exec_depth" applyOnUpdate="0" expression=""/>
    <default field="exec_appropiate" applyOnUpdate="0" expression=""/>
    <default field="notified" applyOnUpdate="0" expression=""/>
    <default field="output" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="2" unique_strength="1" exp_strength="0" constraints="3"/>
    <constraint field="work_order" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="state" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="class" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="mincut_type" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="received_date" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="expl_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="expl_name" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="macroexpl_name" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="macroexpl_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="muni_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="muni_name" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="postcode" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="streetaxis_id" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
    <constraint field="street_name" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="postnumber" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="anl_cause" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="anl_tstamp" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="anl_user" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="anl_descript" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="anl_feature_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="anl_feature_type" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="forecast_start" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="forecast_end" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="assigned_to" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_start" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_end" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_user" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_descript" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_the_geom" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
    <constraint field="exec_from_plot" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_depth" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="exec_appropiate" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="notified" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="output" notnull_strength="0" unique_strength="0" exp_strength="0" constraints="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="work_order" exp="" desc=""/>
    <constraint field="state" exp="" desc=""/>
    <constraint field="class" exp="" desc=""/>
    <constraint field="mincut_type" exp="" desc=""/>
    <constraint field="received_date" exp="" desc=""/>
    <constraint field="expl_id" exp="" desc=""/>
    <constraint field="expl_name" exp="" desc=""/>
    <constraint field="macroexpl_name" exp="" desc=""/>
    <constraint field="macroexpl_id" exp="" desc=""/>
    <constraint field="muni_id" exp="" desc=""/>
    <constraint field="muni_name" exp="" desc=""/>
    <constraint field="postcode" exp="" desc=""/>
    <constraint field="streetaxis_id" exp="" desc=""/>
    <constraint field="street_name" exp="" desc=""/>
    <constraint field="postnumber" exp="" desc=""/>
    <constraint field="anl_cause" exp="" desc=""/>
    <constraint field="anl_tstamp" exp="" desc=""/>
    <constraint field="anl_user" exp="" desc=""/>
    <constraint field="anl_descript" exp="" desc=""/>
    <constraint field="anl_feature_id" exp="" desc=""/>
    <constraint field="anl_feature_type" exp="" desc=""/>
    <constraint field="forecast_start" exp="" desc=""/>
    <constraint field="forecast_end" exp="" desc=""/>
    <constraint field="assigned_to" exp="" desc=""/>
    <constraint field="exec_start" exp="" desc=""/>
    <constraint field="exec_end" exp="" desc=""/>
    <constraint field="exec_user" exp="" desc=""/>
    <constraint field="exec_descript" exp="" desc=""/>
    <constraint field="exec_the_geom" exp="" desc=""/>
    <constraint field="exec_from_plot" exp="" desc=""/>
    <constraint field="exec_depth" exp="" desc=""/>
    <constraint field="exec_appropiate" exp="" desc=""/>
    <constraint field="notified" exp="" desc=""/>
    <constraint field="output" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" width="-1" name="id" hidden="0"/>
      <column type="field" width="-1" name="work_order" hidden="0"/>
      <column type="field" width="-1" name="state" hidden="0"/>
      <column type="field" width="-1" name="class" hidden="0"/>
      <column type="field" width="-1" name="mincut_type" hidden="0"/>
      <column type="field" width="-1" name="received_date" hidden="0"/>
      <column type="field" width="-1" name="expl_id" hidden="0"/>
      <column type="field" width="-1" name="expl_name" hidden="0"/>
      <column type="field" width="-1" name="macroexpl_name" hidden="0"/>
      <column type="field" width="-1" name="macroexpl_id" hidden="0"/>
      <column type="field" width="-1" name="muni_id" hidden="0"/>
      <column type="field" width="-1" name="muni_name" hidden="0"/>
      <column type="field" width="-1" name="postcode" hidden="0"/>
      <column type="field" width="-1" name="streetaxis_id" hidden="0"/>
      <column type="field" width="-1" name="street_name" hidden="0"/>
      <column type="field" width="-1" name="postnumber" hidden="0"/>
      <column type="field" width="-1" name="anl_cause" hidden="0"/>
      <column type="field" width="-1" name="anl_tstamp" hidden="0"/>
      <column type="field" width="-1" name="anl_user" hidden="0"/>
      <column type="field" width="-1" name="anl_descript" hidden="0"/>
      <column type="field" width="-1" name="anl_feature_id" hidden="0"/>
      <column type="field" width="-1" name="anl_feature_type" hidden="0"/>
      <column type="field" width="-1" name="forecast_start" hidden="0"/>
      <column type="field" width="-1" name="forecast_end" hidden="0"/>
      <column type="field" width="-1" name="assigned_to" hidden="0"/>
      <column type="field" width="-1" name="exec_start" hidden="0"/>
      <column type="field" width="-1" name="exec_end" hidden="0"/>
      <column type="field" width="-1" name="exec_user" hidden="0"/>
      <column type="field" width="-1" name="exec_descript" hidden="0"/>
      <column type="field" width="-1" name="exec_the_geom" hidden="0"/>
      <column type="field" width="-1" name="exec_from_plot" hidden="0"/>
      <column type="field" width="-1" name="exec_depth" hidden="0"/>
      <column type="field" width="-1" name="exec_appropiate" hidden="0"/>
      <column type="field" width="-1" name="notified" hidden="0"/>
      <column type="field" width="-1" name="output" hidden="0"/>
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
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="anl_cause" editable="0"/>
    <field name="anl_descript" editable="0"/>
    <field name="anl_feature_id" editable="0"/>
    <field name="anl_feature_type" editable="0"/>
    <field name="anl_tstamp" editable="0"/>
    <field name="anl_user" editable="0"/>
    <field name="assigned_to" editable="0"/>
    <field name="class" editable="0"/>
    <field name="exec_appropiate" editable="0"/>
    <field name="exec_depth" editable="0"/>
    <field name="exec_descript" editable="0"/>
    <field name="exec_end" editable="0"/>
    <field name="exec_from_plot" editable="0"/>
    <field name="exec_start" editable="0"/>
    <field name="exec_the_geom" editable="1"/>
    <field name="exec_user" editable="0"/>
    <field name="expl_id" editable="0"/>
    <field name="expl_name" editable="0"/>
    <field name="forecast_end" editable="0"/>
    <field name="forecast_start" editable="0"/>
    <field name="id" editable="0"/>
    <field name="macroexpl_id" editable="0"/>
    <field name="macroexpl_name" editable="0"/>
    <field name="mincut_type" editable="0"/>
    <field name="muni_id" editable="0"/>
    <field name="muni_name" editable="0"/>
    <field name="notified" editable="0"/>
    <field name="output" editable="1"/>
    <field name="postcode" editable="0"/>
    <field name="postnumber" editable="0"/>
    <field name="received_date" editable="0"/>
    <field name="state" editable="0"/>
    <field name="street_name" editable="0"/>
    <field name="streetaxis_id" editable="1"/>
    <field name="work_order" editable="0"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="anl_cause"/>
    <field labelOnTop="0" name="anl_descript"/>
    <field labelOnTop="0" name="anl_feature_id"/>
    <field labelOnTop="0" name="anl_feature_type"/>
    <field labelOnTop="0" name="anl_tstamp"/>
    <field labelOnTop="0" name="anl_user"/>
    <field labelOnTop="0" name="assigned_to"/>
    <field labelOnTop="0" name="class"/>
    <field labelOnTop="0" name="exec_appropiate"/>
    <field labelOnTop="0" name="exec_depth"/>
    <field labelOnTop="0" name="exec_descript"/>
    <field labelOnTop="0" name="exec_end"/>
    <field labelOnTop="0" name="exec_from_plot"/>
    <field labelOnTop="0" name="exec_start"/>
    <field labelOnTop="0" name="exec_the_geom"/>
    <field labelOnTop="0" name="exec_user"/>
    <field labelOnTop="0" name="expl_id"/>
    <field labelOnTop="0" name="expl_name"/>
    <field labelOnTop="0" name="forecast_end"/>
    <field labelOnTop="0" name="forecast_start"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="macroexpl_id"/>
    <field labelOnTop="0" name="macroexpl_name"/>
    <field labelOnTop="0" name="mincut_type"/>
    <field labelOnTop="0" name="muni_id"/>
    <field labelOnTop="0" name="muni_name"/>
    <field labelOnTop="0" name="notified"/>
    <field labelOnTop="0" name="output"/>
    <field labelOnTop="0" name="postcode"/>
    <field labelOnTop="0" name="postnumber"/>
    <field labelOnTop="0" name="received_date"/>
    <field labelOnTop="0" name="state"/>
    <field labelOnTop="0" name="street_name"/>
    <field labelOnTop="0" name="streetaxis_id"/>
    <field labelOnTop="0" name="work_order"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="anl_cause" reuseLastValue="0"/>
    <field name="anl_descript" reuseLastValue="0"/>
    <field name="anl_feature_id" reuseLastValue="0"/>
    <field name="anl_feature_type" reuseLastValue="0"/>
    <field name="anl_tstamp" reuseLastValue="0"/>
    <field name="anl_user" reuseLastValue="0"/>
    <field name="assigned_to" reuseLastValue="0"/>
    <field name="class" reuseLastValue="0"/>
    <field name="exec_appropiate" reuseLastValue="0"/>
    <field name="exec_depth" reuseLastValue="0"/>
    <field name="exec_descript" reuseLastValue="0"/>
    <field name="exec_end" reuseLastValue="0"/>
    <field name="exec_from_plot" reuseLastValue="0"/>
    <field name="exec_start" reuseLastValue="0"/>
    <field name="exec_the_geom" reuseLastValue="0"/>
    <field name="exec_user" reuseLastValue="0"/>
    <field name="expl_id" reuseLastValue="0"/>
    <field name="expl_name" reuseLastValue="0"/>
    <field name="forecast_end" reuseLastValue="0"/>
    <field name="forecast_start" reuseLastValue="0"/>
    <field name="id" reuseLastValue="0"/>
    <field name="macroexpl_id" reuseLastValue="0"/>
    <field name="macroexpl_name" reuseLastValue="0"/>
    <field name="mincut_type" reuseLastValue="0"/>
    <field name="muni_id" reuseLastValue="0"/>
    <field name="muni_name" reuseLastValue="0"/>
    <field name="notified" reuseLastValue="0"/>
    <field name="output" reuseLastValue="0"/>
    <field name="postcode" reuseLastValue="0"/>
    <field name="postnumber" reuseLastValue="0"/>
    <field name="received_date" reuseLastValue="0"/>
    <field name="state" reuseLastValue="0"/>
    <field name="street_name" reuseLastValue="0"/>
    <field name="streetaxis_id" reuseLastValue="0"/>
    <field name="work_order" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"expl_name"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true);

INSERT INTO sys_style(id, idval, styletype, stylevalue, active) VALUES
(111, 'v_om_mincut_valve', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" minScale="100000000" version="3.22.1-Białowieża" readOnly="0" simplifyDrawingHints="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" symbologyReferenceScale="-1" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal endField="" durationField="" fixedDuration="0" startField="" endExpression="" mode="0" durationUnit="min" enabled="0" limitMode="0" startExpression="" accumulate="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="categorizedSymbol" attr="proposed" enableorderby="0" referencescale="-1" forceraster="0" symbollevels="0">
    <categories>
      <category label="Proposed to close" value="true" render="true" symbol="0"/>
      <category label="Do not operate" value="false" render="true" symbol="1"/>
    </categories>
    <symbols>
      <symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="237,55,58,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="134,13,13,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="3.4"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <prop v="0" k="angle"/>
          <prop v="square" k="cap_style"/>
          <prop v="237,55,58,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="134,13,13,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3.4" k="size"/>
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
      <symbol type="marker" name="1" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="51,160,44,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="6,94,0,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="3.4"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <prop v="0" k="angle"/>
          <prop v="square" k="cap_style"/>
          <prop v="51,160,44,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="6,94,0,255" k="outline_color"/>
          <prop v="solid" k="outline_style"/>
          <prop v="0" k="outline_width"/>
          <prop v="3x:0,0,0,0,0,0" k="outline_width_map_unit_scale"/>
          <prop v="MM" k="outline_width_unit"/>
          <prop v="diameter" k="scale_method"/>
          <prop v="3.4" k="size"/>
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
    <source-symbol>
      <symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="232,113,141,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <prop v="0" k="angle"/>
          <prop v="square" k="cap_style"/>
          <prop v="232,113,141,255" k="color"/>
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
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option type="QString" name="embeddedWidgets/count" value="0"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory labelPlacementMethod="XHeight" sizeType="MM" opacity="1" lineSizeType="MM" sizeScale="3x:0,0,0,0,0,0" spacing="0" penColor="#000000" showAxis="0" height="15" barWidth="5" minScaleDenominator="0" minimumSize="0" width="15" scaleBasedVisibility="0" spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" direction="1" spacingUnit="MM" penAlpha="255" penWidth="0" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" enabled="0" scaleDependency="Area" backgroundColor="#ffffff" maxScaleDenominator="1e+08">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol type="line" name="" alpha="1" clip_to_extent="1" force_rhr="0">
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" class="SimpleLine" pass="0">
            <Option type="Map">
              <Option type="QString" name="align_dash_pattern" value="0"/>
              <Option type="QString" name="capstyle" value="square"/>
              <Option type="QString" name="customdash" value="5;2"/>
              <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="customdash_unit" value="MM"/>
              <Option type="QString" name="dash_pattern_offset" value="0"/>
              <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
              <Option type="QString" name="draw_inside_polygon" value="0"/>
              <Option type="QString" name="joinstyle" value="bevel"/>
              <Option type="QString" name="line_color" value="35,35,35,255"/>
              <Option type="QString" name="line_style" value="solid"/>
              <Option type="QString" name="line_width" value="0.26"/>
              <Option type="QString" name="line_width_unit" value="MM"/>
              <Option type="QString" name="offset" value="0"/>
              <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="offset_unit" value="MM"/>
              <Option type="QString" name="ring_filter" value="0"/>
              <Option type="QString" name="trim_distance_end" value="0"/>
              <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_end_unit" value="MM"/>
              <Option type="QString" name="trim_distance_start" value="0"/>
              <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_start_unit" value="MM"/>
              <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
              <Option type="QString" name="use_custom_dash" value="0"/>
              <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            </Option>
            <prop v="0" k="align_dash_pattern"/>
            <prop v="square" k="capstyle"/>
            <prop v="5;2" k="customdash"/>
            <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
            <prop v="MM" k="customdash_unit"/>
            <prop v="0" k="dash_pattern_offset"/>
            <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
            <prop v="MM" k="dash_pattern_offset_unit"/>
            <prop v="0" k="draw_inside_polygon"/>
            <prop v="bevel" k="joinstyle"/>
            <prop v="35,35,35,255" k="line_color"/>
            <prop v="solid" k="line_style"/>
            <prop v="0.26" k="line_width"/>
            <prop v="MM" k="line_width_unit"/>
            <prop v="0" k="offset"/>
            <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
            <prop v="MM" k="offset_unit"/>
            <prop v="0" k="ring_filter"/>
            <prop v="0" k="trim_distance_end"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
            <prop v="MM" k="trim_distance_end_unit"/>
            <prop v="0" k="trim_distance_start"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
            <prop v="MM" k="trim_distance_start_unit"/>
            <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" zIndex="0" obstacle="0" placement="0" priority="0" linePlacementFlags="18" dist="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="result_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="work_order">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="node_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="closed">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option type="QString" name="CheckedState" value="true"/>
            <Option type="QString" name="UncheckedState" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="broken">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option type="QString" name="CheckedState" value="true"/>
            <Option type="QString" name="UncheckedState" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="unaccess">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option type="QString" name="CheckedState" value="true"/>
            <Option type="QString" name="UncheckedState" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="proposed">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option type="QString" name="CheckedState" value="true"/>
            <Option type="QString" name="UncheckedState" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" index="0" name="id"/>
    <alias field="result_id" index="1" name="result_id"/>
    <alias field="work_order" index="2" name="work_order"/>
    <alias field="node_id" index="3" name="node_id"/>
    <alias field="closed" index="4" name="closed"/>
    <alias field="broken" index="5" name="broken"/>
    <alias field="unaccess" index="6" name="unaccess"/>
    <alias field="proposed" index="7" name="proposed"/>
  </aliases>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="result_id" applyOnUpdate="0" expression=""/>
    <default field="work_order" applyOnUpdate="0" expression=""/>
    <default field="node_id" applyOnUpdate="0" expression=""/>
    <default field="closed" applyOnUpdate="0" expression=""/>
    <default field="broken" applyOnUpdate="0" expression=""/>
    <default field="unaccess" applyOnUpdate="0" expression=""/>
    <default field="proposed" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="2" unique_strength="1" exp_strength="0" constraints="3"/>
    <constraint field="result_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="work_order" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="node_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="closed" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="broken" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="unaccess" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="proposed" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="result_id" exp="" desc=""/>
    <constraint field="work_order" exp="" desc=""/>
    <constraint field="node_id" exp="" desc=""/>
    <constraint field="closed" exp="" desc=""/>
    <constraint field="broken" exp="" desc=""/>
    <constraint field="unaccess" exp="" desc=""/>
    <constraint field="proposed" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" width="-1" name="id" hidden="0"/>
      <column type="field" width="-1" name="result_id" hidden="0"/>
      <column type="field" width="-1" name="work_order" hidden="0"/>
      <column type="field" width="-1" name="node_id" hidden="0"/>
      <column type="field" width="-1" name="closed" hidden="0"/>
      <column type="field" width="-1" name="broken" hidden="0"/>
      <column type="field" width="-1" name="unaccess" hidden="0"/>
      <column type="field" width="-1" name="proposed" hidden="0"/>
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
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="broken" editable="0"/>
    <field name="closed" editable="0"/>
    <field name="id" editable="0"/>
    <field name="node_id" editable="0"/>
    <field name="proposed" editable="0"/>
    <field name="result_id" editable="0"/>
    <field name="unaccess" editable="0"/>
    <field name="work_order" editable="0"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="broken"/>
    <field labelOnTop="0" name="closed"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="node_id"/>
    <field labelOnTop="0" name="proposed"/>
    <field labelOnTop="0" name="result_id"/>
    <field labelOnTop="0" name="unaccess"/>
    <field labelOnTop="0" name="work_order"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="broken" reuseLastValue="0"/>
    <field name="closed" reuseLastValue="0"/>
    <field name="id" reuseLastValue="0"/>
    <field name="node_id" reuseLastValue="0"/>
    <field name="proposed" reuseLastValue="0"/>
    <field name="result_id" reuseLastValue="0"/>
    <field name="unaccess" reuseLastValue="0"/>
    <field name="work_order" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true);

INSERT INTO sys_style(id, idval, styletype, stylevalue, active) VALUES
(112, 'v_om_mincut_node', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" minScale="100000000" version="3.22.1-Białowieża" readOnly="0" simplifyDrawingHints="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" symbologyReferenceScale="-1" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal endField="" durationField="" fixedDuration="0" startField="" endExpression="" mode="0" durationUnit="min" enabled="0" limitMode="0" startExpression="" accumulate="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="singleSymbol" enableorderby="0" referencescale="-1" forceraster="0" symbollevels="0">
    <symbols>
      <symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="241,209,66,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="160,134,17,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <prop v="0" k="angle"/>
          <prop v="square" k="cap_style"/>
          <prop v="241,209,66,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="160,134,17,255" k="outline_color"/>
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
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option type="QString" name="embeddedWidgets/count" value="0"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory labelPlacementMethod="XHeight" sizeType="MM" opacity="1" lineSizeType="MM" sizeScale="3x:0,0,0,0,0,0" spacing="0" penColor="#000000" showAxis="0" height="15" barWidth="5" minScaleDenominator="0" minimumSize="0" width="15" scaleBasedVisibility="0" spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" direction="1" spacingUnit="MM" penAlpha="255" penWidth="0" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" enabled="0" scaleDependency="Area" backgroundColor="#ffffff" maxScaleDenominator="1e+08">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol type="line" name="" alpha="1" clip_to_extent="1" force_rhr="0">
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" class="SimpleLine" pass="0">
            <Option type="Map">
              <Option type="QString" name="align_dash_pattern" value="0"/>
              <Option type="QString" name="capstyle" value="square"/>
              <Option type="QString" name="customdash" value="5;2"/>
              <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="customdash_unit" value="MM"/>
              <Option type="QString" name="dash_pattern_offset" value="0"/>
              <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
              <Option type="QString" name="draw_inside_polygon" value="0"/>
              <Option type="QString" name="joinstyle" value="bevel"/>
              <Option type="QString" name="line_color" value="35,35,35,255"/>
              <Option type="QString" name="line_style" value="solid"/>
              <Option type="QString" name="line_width" value="0.26"/>
              <Option type="QString" name="line_width_unit" value="MM"/>
              <Option type="QString" name="offset" value="0"/>
              <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="offset_unit" value="MM"/>
              <Option type="QString" name="ring_filter" value="0"/>
              <Option type="QString" name="trim_distance_end" value="0"/>
              <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_end_unit" value="MM"/>
              <Option type="QString" name="trim_distance_start" value="0"/>
              <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_start_unit" value="MM"/>
              <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
              <Option type="QString" name="use_custom_dash" value="0"/>
              <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            </Option>
            <prop v="0" k="align_dash_pattern"/>
            <prop v="square" k="capstyle"/>
            <prop v="5;2" k="customdash"/>
            <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
            <prop v="MM" k="customdash_unit"/>
            <prop v="0" k="dash_pattern_offset"/>
            <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
            <prop v="MM" k="dash_pattern_offset_unit"/>
            <prop v="0" k="draw_inside_polygon"/>
            <prop v="bevel" k="joinstyle"/>
            <prop v="35,35,35,255" k="line_color"/>
            <prop v="solid" k="line_style"/>
            <prop v="0.26" k="line_width"/>
            <prop v="MM" k="line_width_unit"/>
            <prop v="0" k="offset"/>
            <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
            <prop v="MM" k="offset_unit"/>
            <prop v="0" k="ring_filter"/>
            <prop v="0" k="trim_distance_end"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
            <prop v="MM" k="trim_distance_end_unit"/>
            <prop v="0" k="trim_distance_start"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
            <prop v="MM" k="trim_distance_start_unit"/>
            <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" zIndex="0" obstacle="0" placement="0" priority="0" linePlacementFlags="18" dist="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="result_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="work_order">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="node_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" index="0" name="id"/>
    <alias field="result_id" index="1" name="result_id"/>
    <alias field="work_order" index="2" name="work_order"/>
    <alias field="node_id" index="3" name="node_id"/>
  </aliases>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="result_id" applyOnUpdate="0" expression=""/>
    <default field="work_order" applyOnUpdate="0" expression=""/>
    <default field="node_id" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="2" unique_strength="1" exp_strength="0" constraints="3"/>
    <constraint field="result_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="work_order" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="node_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="result_id" exp="" desc=""/>
    <constraint field="work_order" exp="" desc=""/>
    <constraint field="node_id" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" width="-1" name="id" hidden="0"/>
      <column type="field" width="-1" name="result_id" hidden="0"/>
      <column type="field" width="-1" name="work_order" hidden="0"/>
      <column type="field" width="-1" name="node_id" hidden="0"/>
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
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="id" editable="0"/>
    <field name="node_id" editable="0"/>
    <field name="result_id" editable="0"/>
    <field name="work_order" editable="0"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="node_id"/>
    <field labelOnTop="0" name="result_id"/>
    <field labelOnTop="0" name="work_order"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="id" reuseLastValue="0"/>
    <field name="node_id" reuseLastValue="0"/>
    <field name="result_id" reuseLastValue="0"/>
    <field name="work_order" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true);

INSERT INTO sys_style(id, idval, styletype, stylevalue, active) VALUES
(113, 'v_om_mincut_connec', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" minScale="100000000" version="3.22.1-Białowieża" readOnly="0" simplifyDrawingHints="0" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" symbologyReferenceScale="-1" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal endField="" durationField="" fixedDuration="0" startField="" endExpression="" mode="0" durationUnit="min" enabled="0" limitMode="0" startExpression="" accumulate="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="singleSymbol" enableorderby="0" referencescale="-1" forceraster="0" symbollevels="0">
    <symbols>
      <symbol type="marker" name="0" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleMarker" pass="0">
          <Option type="Map">
            <Option type="QString" name="angle" value="0"/>
            <Option type="QString" name="cap_style" value="square"/>
            <Option type="QString" name="color" value="176,123,103,255"/>
            <Option type="QString" name="horizontal_anchor_point" value="1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="name" value="circle"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="102,46,25,255"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0"/>
            <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="scale_method" value="diameter"/>
            <Option type="QString" name="size" value="2"/>
            <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="size_unit" value="MM"/>
            <Option type="QString" name="vertical_anchor_point" value="1"/>
          </Option>
          <prop v="0" k="angle"/>
          <prop v="square" k="cap_style"/>
          <prop v="176,123,103,255" k="color"/>
          <prop v="1" k="horizontal_anchor_point"/>
          <prop v="bevel" k="joinstyle"/>
          <prop v="circle" k="name"/>
          <prop v="0,0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="102,46,25,255" k="outline_color"/>
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
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option type="QString" name="embeddedWidgets/count" value="0"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory labelPlacementMethod="XHeight" sizeType="MM" opacity="1" lineSizeType="MM" sizeScale="3x:0,0,0,0,0,0" spacing="0" penColor="#000000" showAxis="0" height="15" barWidth="5" minScaleDenominator="0" minimumSize="0" width="15" scaleBasedVisibility="0" spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" direction="1" spacingUnit="MM" penAlpha="255" penWidth="0" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" enabled="0" scaleDependency="Area" backgroundColor="#ffffff" maxScaleDenominator="1e+08">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol type="line" name="" alpha="1" clip_to_extent="1" force_rhr="0">
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" class="SimpleLine" pass="0">
            <Option type="Map">
              <Option type="QString" name="align_dash_pattern" value="0"/>
              <Option type="QString" name="capstyle" value="square"/>
              <Option type="QString" name="customdash" value="5;2"/>
              <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="customdash_unit" value="MM"/>
              <Option type="QString" name="dash_pattern_offset" value="0"/>
              <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
              <Option type="QString" name="draw_inside_polygon" value="0"/>
              <Option type="QString" name="joinstyle" value="bevel"/>
              <Option type="QString" name="line_color" value="35,35,35,255"/>
              <Option type="QString" name="line_style" value="solid"/>
              <Option type="QString" name="line_width" value="0.26"/>
              <Option type="QString" name="line_width_unit" value="MM"/>
              <Option type="QString" name="offset" value="0"/>
              <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="offset_unit" value="MM"/>
              <Option type="QString" name="ring_filter" value="0"/>
              <Option type="QString" name="trim_distance_end" value="0"/>
              <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_end_unit" value="MM"/>
              <Option type="QString" name="trim_distance_start" value="0"/>
              <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_start_unit" value="MM"/>
              <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
              <Option type="QString" name="use_custom_dash" value="0"/>
              <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            </Option>
            <prop v="0" k="align_dash_pattern"/>
            <prop v="square" k="capstyle"/>
            <prop v="5;2" k="customdash"/>
            <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
            <prop v="MM" k="customdash_unit"/>
            <prop v="0" k="dash_pattern_offset"/>
            <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
            <prop v="MM" k="dash_pattern_offset_unit"/>
            <prop v="0" k="draw_inside_polygon"/>
            <prop v="bevel" k="joinstyle"/>
            <prop v="35,35,35,255" k="line_color"/>
            <prop v="solid" k="line_style"/>
            <prop v="0.26" k="line_width"/>
            <prop v="MM" k="line_width_unit"/>
            <prop v="0" k="offset"/>
            <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
            <prop v="MM" k="offset_unit"/>
            <prop v="0" k="ring_filter"/>
            <prop v="0" k="trim_distance_end"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
            <prop v="MM" k="trim_distance_end_unit"/>
            <prop v="0" k="trim_distance_start"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
            <prop v="MM" k="trim_distance_start_unit"/>
            <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" zIndex="0" obstacle="0" placement="0" priority="0" linePlacementFlags="18" dist="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="result_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="work_order">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="connec_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="customer_code">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" index="0" name="id"/>
    <alias field="result_id" index="1" name="result_id"/>
    <alias field="work_order" index="2" name="work_order"/>
    <alias field="connec_id" index="3" name="connec_id"/>
    <alias field="customer_code" index="4" name="customer_code"/>
  </aliases>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="result_id" applyOnUpdate="0" expression=""/>
    <default field="work_order" applyOnUpdate="0" expression=""/>
    <default field="connec_id" applyOnUpdate="0" expression=""/>
    <default field="customer_code" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="2" unique_strength="1" exp_strength="0" constraints="3"/>
    <constraint field="result_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="work_order" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="connec_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="customer_code" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="result_id" exp="" desc=""/>
    <constraint field="work_order" exp="" desc=""/>
    <constraint field="connec_id" exp="" desc=""/>
    <constraint field="customer_code" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" width="-1" name="id" hidden="0"/>
      <column type="field" width="-1" name="result_id" hidden="0"/>
      <column type="field" width="-1" name="work_order" hidden="0"/>
      <column type="field" width="-1" name="connec_id" hidden="0"/>
      <column type="field" width="-1" name="customer_code" hidden="0"/>
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
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="connec_id" editable="0"/>
    <field name="customer_code" editable="0"/>
    <field name="id" editable="0"/>
    <field name="result_id" editable="0"/>
    <field name="work_order" editable="0"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="connec_id"/>
    <field labelOnTop="0" name="customer_code"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="result_id"/>
    <field labelOnTop="0" name="work_order"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="connec_id" reuseLastValue="0"/>
    <field name="customer_code" reuseLastValue="0"/>
    <field name="id" reuseLastValue="0"/>
    <field name="result_id" reuseLastValue="0"/>
    <field name="work_order" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
$$, true);

INSERT INTO sys_style(id, idval, styletype, stylevalue, active) VALUES
(114, 'v_om_mincut_arc', 'qml', $$<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyDrawingTol="1" minScale="0" version="3.22.1-Białowieża" readOnly="0" simplifyDrawingHints="1" styleCategories="AllStyleCategories" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" symbologyReferenceScale="-1" simplifyMaxScale="1" maxScale="0" labelsEnabled="0" simplifyAlgorithm="0">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal endField="" durationField="" fixedDuration="0" startField="" endExpression="" mode="0" durationUnit="min" enabled="0" limitMode="0" startExpression="" accumulate="0">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 type="singleSymbol" enableorderby="0" referencescale="-1" forceraster="0" symbollevels="0">
    <symbols>
      <symbol type="line" name="0" alpha="1" clip_to_extent="1" force_rhr="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="round"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="round"/>
            <Option type="QString" name="line_color" value="76,38,0,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.7"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <prop v="0" k="align_dash_pattern"/>
          <prop v="round" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="dash_pattern_offset"/>
          <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
          <prop v="MM" k="dash_pattern_offset_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="round" k="joinstyle"/>
          <prop v="76,38,0,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="1.7" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="trim_distance_end"/>
          <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
          <prop v="MM" k="trim_distance_end_unit"/>
          <prop v="0" k="trim_distance_start"/>
          <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
          <prop v="MM" k="trim_distance_start_unit"/>
          <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
        <layer locked="0" enabled="1" class="SimpleLine" pass="0">
          <Option type="Map">
            <Option type="QString" name="align_dash_pattern" value="0"/>
            <Option type="QString" name="capstyle" value="round"/>
            <Option type="QString" name="customdash" value="5;2"/>
            <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="customdash_unit" value="MM"/>
            <Option type="QString" name="dash_pattern_offset" value="0"/>
            <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
            <Option type="QString" name="draw_inside_polygon" value="0"/>
            <Option type="QString" name="joinstyle" value="round"/>
            <Option type="QString" name="line_color" value="255,206,128,255"/>
            <Option type="QString" name="line_style" value="solid"/>
            <Option type="QString" name="line_width" value="1.5"/>
            <Option type="QString" name="line_width_unit" value="MM"/>
            <Option type="QString" name="offset" value="0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="ring_filter" value="0"/>
            <Option type="QString" name="trim_distance_end" value="0"/>
            <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_end_unit" value="MM"/>
            <Option type="QString" name="trim_distance_start" value="0"/>
            <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="trim_distance_start_unit" value="MM"/>
            <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
            <Option type="QString" name="use_custom_dash" value="0"/>
            <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
          </Option>
          <prop v="0" k="align_dash_pattern"/>
          <prop v="round" k="capstyle"/>
          <prop v="5;2" k="customdash"/>
          <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
          <prop v="MM" k="customdash_unit"/>
          <prop v="0" k="dash_pattern_offset"/>
          <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
          <prop v="MM" k="dash_pattern_offset_unit"/>
          <prop v="0" k="draw_inside_polygon"/>
          <prop v="round" k="joinstyle"/>
          <prop v="255,206,128,255" k="line_color"/>
          <prop v="solid" k="line_style"/>
          <prop v="1.5" k="line_width"/>
          <prop v="MM" k="line_width_unit"/>
          <prop v="0" k="offset"/>
          <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
          <prop v="MM" k="offset_unit"/>
          <prop v="0" k="ring_filter"/>
          <prop v="0" k="trim_distance_end"/>
          <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
          <prop v="MM" k="trim_distance_end_unit"/>
          <prop v="0" k="trim_distance_start"/>
          <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
          <prop v="MM" k="trim_distance_start_unit"/>
          <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option type="QString" name="embeddedWidgets/count" value="0"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory labelPlacementMethod="XHeight" sizeType="MM" opacity="1" lineSizeType="MM" sizeScale="3x:0,0,0,0,0,0" spacing="0" penColor="#000000" showAxis="0" height="15" barWidth="5" minScaleDenominator="0" minimumSize="0" width="15" scaleBasedVisibility="0" spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" direction="1" spacingUnit="MM" penAlpha="255" penWidth="0" rotationOffset="270" backgroundAlpha="255" lineSizeScale="3x:0,0,0,0,0,0" enabled="0" scaleDependency="Area" backgroundColor="#ffffff" maxScaleDenominator="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute color="#000000" field="" label=""/>
      <axisSymbol>
        <symbol type="line" name="" alpha="1" clip_to_extent="1" force_rhr="0">
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" class="SimpleLine" pass="0">
            <Option type="Map">
              <Option type="QString" name="align_dash_pattern" value="0"/>
              <Option type="QString" name="capstyle" value="square"/>
              <Option type="QString" name="customdash" value="5;2"/>
              <Option type="QString" name="customdash_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="customdash_unit" value="MM"/>
              <Option type="QString" name="dash_pattern_offset" value="0"/>
              <Option type="QString" name="dash_pattern_offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="dash_pattern_offset_unit" value="MM"/>
              <Option type="QString" name="draw_inside_polygon" value="0"/>
              <Option type="QString" name="joinstyle" value="bevel"/>
              <Option type="QString" name="line_color" value="35,35,35,255"/>
              <Option type="QString" name="line_style" value="solid"/>
              <Option type="QString" name="line_width" value="0.26"/>
              <Option type="QString" name="line_width_unit" value="MM"/>
              <Option type="QString" name="offset" value="0"/>
              <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="offset_unit" value="MM"/>
              <Option type="QString" name="ring_filter" value="0"/>
              <Option type="QString" name="trim_distance_end" value="0"/>
              <Option type="QString" name="trim_distance_end_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_end_unit" value="MM"/>
              <Option type="QString" name="trim_distance_start" value="0"/>
              <Option type="QString" name="trim_distance_start_map_unit_scale" value="3x:0,0,0,0,0,0"/>
              <Option type="QString" name="trim_distance_start_unit" value="MM"/>
              <Option type="QString" name="tweak_dash_pattern_on_corners" value="0"/>
              <Option type="QString" name="use_custom_dash" value="0"/>
              <Option type="QString" name="width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            </Option>
            <prop v="0" k="align_dash_pattern"/>
            <prop v="square" k="capstyle"/>
            <prop v="5;2" k="customdash"/>
            <prop v="3x:0,0,0,0,0,0" k="customdash_map_unit_scale"/>
            <prop v="MM" k="customdash_unit"/>
            <prop v="0" k="dash_pattern_offset"/>
            <prop v="3x:0,0,0,0,0,0" k="dash_pattern_offset_map_unit_scale"/>
            <prop v="MM" k="dash_pattern_offset_unit"/>
            <prop v="0" k="draw_inside_polygon"/>
            <prop v="bevel" k="joinstyle"/>
            <prop v="35,35,35,255" k="line_color"/>
            <prop v="solid" k="line_style"/>
            <prop v="0.26" k="line_width"/>
            <prop v="MM" k="line_width_unit"/>
            <prop v="0" k="offset"/>
            <prop v="3x:0,0,0,0,0,0" k="offset_map_unit_scale"/>
            <prop v="MM" k="offset_unit"/>
            <prop v="0" k="ring_filter"/>
            <prop v="0" k="trim_distance_end"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_end_map_unit_scale"/>
            <prop v="MM" k="trim_distance_end_unit"/>
            <prop v="0" k="trim_distance_start"/>
            <prop v="3x:0,0,0,0,0,0" k="trim_distance_start_map_unit_scale"/>
            <prop v="MM" k="trim_distance_start_unit"/>
            <prop v="0" k="tweak_dash_pattern_on_corners"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" zIndex="0" obstacle="0" placement="2" priority="0" linePlacementFlags="18" dist="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions geometryPrecision="0" removeDuplicateNodes="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field configurationFlags="None" name="id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="result_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="work_order">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field configurationFlags="None" name="arc_id">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option type="bool" name="IsMultiline" value="false"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" index="0" name="id"/>
    <alias field="result_id" index="1" name="result_id"/>
    <alias field="work_order" index="2" name="work_order"/>
    <alias field="arc_id" index="3" name="arc_id"/>
  </aliases>
  <defaults>
    <default field="id" applyOnUpdate="0" expression=""/>
    <default field="result_id" applyOnUpdate="0" expression=""/>
    <default field="work_order" applyOnUpdate="0" expression=""/>
    <default field="arc_id" applyOnUpdate="0" expression=""/>
  </defaults>
  <constraints>
    <constraint field="id" notnull_strength="2" unique_strength="1" exp_strength="0" constraints="3"/>
    <constraint field="result_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="work_order" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
    <constraint field="arc_id" notnull_strength="2" unique_strength="0" exp_strength="0" constraints="1"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
    <constraint field="result_id" exp="" desc=""/>
    <constraint field="work_order" exp="" desc=""/>
    <constraint field="arc_id" exp="" desc=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortExpression="" sortOrder="0">
    <columns>
      <column type="field" width="-1" name="id" hidden="0"/>
      <column type="field" width="-1" name="result_id" hidden="0"/>
      <column type="field" width="-1" name="work_order" hidden="0"/>
      <column type="field" width="-1" name="arc_id" hidden="0"/>
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
  <featformsuppress>2</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="arc_id" editable="0"/>
    <field name="id" editable="0"/>
    <field name="result_id" editable="0"/>
    <field name="work_order" editable="0"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="arc_id"/>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="result_id"/>
    <field labelOnTop="0" name="work_order"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="arc_id" reuseLastValue="0"/>
    <field name="id" reuseLastValue="0"/>
    <field name="result_id" reuseLastValue="0"/>
    <field name="work_order" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>COALESCE( "id", '&lt;NULL>' )</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
$$, true);
