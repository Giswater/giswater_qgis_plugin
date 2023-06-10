/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2023/06/23
INSERT INTO sys_style (id, idval, styletype, active) VALUES (201, 'v_edit_arc EPANET point of view', 'qml', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_style (id, idval, styletype, active) VALUES (202, 'v_edit_connec EPANET point of view', 'qml', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_style (id, idval, styletype, active) VALUES (203, 'v_edit_link EPANET point of view', 'qml', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO sys_style (id, idval, styletype, active) VALUES (204, 'v_edit_node EPANET point of view', 'qml', true) ON CONFLICT (id) DO NOTHING;

UPDATE sys_style SET stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis minScale="100000000" simplifyMaxScale="1" styleCategories="AllStyleCategories" readOnly="0" simplifyAlgorithm="0" symbologyReferenceScale="-1" maxScale="0" labelsEnabled="1" simplifyDrawingTol="1" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" simplifyDrawingHints="1" version="3.22.4-Białowieża">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal mode="0" enabled="0" fixedDuration="0" startField="" startExpression="" accumulate="0" limitMode="0" endField="" endExpression="" durationUnit="min" durationField="">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 referencescale="-1" attr="epa_type" symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol">
    <categories>
      <category value="PIPE" render="true" label="PIPE" symbol="0"/>
      <category value="VIRTUALPUMP" render="true" label="VIRTUALPUMP" symbol="1"/>
      <category value="VIRTUALVALVE" render="true" label="VIRTUALVALVE" symbol="2"/>
    </categories>
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="line" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.5" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <prop k="align_dash_pattern" v="0"/>
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="dash_pattern_offset" v="0"/>
          <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="dash_pattern_offset_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="5,163,242,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.5"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="trim_distance_end" v="0"/>
          <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_end_unit" v="MM"/>
          <prop k="trim_distance_start" v="0"/>
          <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_start_unit" v="MM"/>
          <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
      <symbol force_rhr="0" name="1" clip_to_extent="1" type="line" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.535714" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <prop k="align_dash_pattern" v="0"/>
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="dash_pattern_offset" v="0"/>
          <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="dash_pattern_offset_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="5,163,242,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.535714"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="trim_distance_end" v="0"/>
          <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_end_unit" v="MM"/>
          <prop k="trim_distance_start" v="0"/>
          <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_start_unit" v="MM"/>
          <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="centralpoint" name="placement" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
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
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" name="@1@1" clip_to_extent="1" type="marker" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="0,106,253,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.2" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="3" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="cap_style" v="square"/>
              <prop k="color" v="0,106,253,255"/>
              <prop k="horizontal_anchor_point" v="1"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="name" v="circle"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="0,0,0,255"/>
              <prop k="outline_style" v="solid"/>
              <prop k="outline_width" v="0.2"/>
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
            <layer locked="0" enabled="1" pass="0" class="FontMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="P" name="chr" type="QString"/>
                <Option value="255,255,255,255" name="color" type="QString"/>
                <Option value="Dingbats" name="font" type="QString"/>
                <Option value="" name="font_style" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="2.5" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="chr" v="P"/>
              <prop k="color" v="255,255,255,255"/>
              <prop k="font" v="Dingbats"/>
              <prop k="font_style" v=""/>
              <prop k="horizontal_anchor_point" v="1"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="35,35,35,255"/>
              <prop k="outline_width" v="0"/>
              <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="outline_width_unit" v="MM"/>
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
        </layer>
      </symbol>
      <symbol force_rhr="0" name="2" clip_to_extent="1" type="line" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.541667" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <prop k="align_dash_pattern" v="0"/>
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="dash_pattern_offset" v="0"/>
          <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="dash_pattern_offset_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="5,163,242,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.541667"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="trim_distance_end" v="0"/>
          <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_end_unit" v="MM"/>
          <prop k="trim_distance_start" v="0"/>
          <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_start_unit" v="MM"/>
          <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
        <layer locked="0" enabled="1" pass="0" class="MarkerLine">
          <Option type="Map">
            <Option value="4" name="average_angle_length" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="average_angle_map_unit_scale" type="QString"/>
            <Option value="MM" name="average_angle_unit" type="QString"/>
            <Option value="3" name="interval" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="interval_map_unit_scale" type="QString"/>
            <Option value="MM" name="interval_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="0" name="offset_along_line" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_along_line_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_along_line_unit" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="centralpoint" name="placement" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="1" name="rotate" type="QString"/>
          </Option>
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
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" name="@2@1" clip_to_extent="1" type="marker" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="255,255,255,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="0,0,0,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2.6" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="cap_style" v="square"/>
              <prop k="color" v="255,255,255,255"/>
              <prop k="horizontal_anchor_point" v="1"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="name" v="circle"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="0,0,0,255"/>
              <prop k="outline_style" v="solid"/>
              <prop k="outline_width" v="0.4"/>
              <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="outline_width_unit" v="MM"/>
              <prop k="scale_method" v="diameter"/>
              <prop k="size" v="2.6"/>
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
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="0,0,0,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="0.433333" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="cap_style" v="square"/>
              <prop k="color" v="0,0,0,255"/>
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
              <prop k="size" v="0.433333"/>
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
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="line" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="227,61,39,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.5" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <prop k="align_dash_pattern" v="0"/>
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="dash_pattern_offset" v="0"/>
          <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="dash_pattern_offset_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="227,61,39,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.5"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="trim_distance_end" v="0"/>
          <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_end_unit" v="MM"/>
          <prop k="trim_distance_start" v="0"/>
          <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_start_unit" v="MM"/>
          <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
    <colorramp name="[source]" type="randomcolors">
      <Option/>
    </colorramp>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <labeling type="simple">
    <settings calloutType="simple">
      <text-style blendMode="0" fontLetterSpacing="0" namedStyle="Normal" capitalization="0" textOrientation="horizontal" multilineHeight="1" textOpacity="1" fieldName="arccat_id" fontItalic="0" fontWordSpacing="0" allowHtml="0" fontStrikeout="0" fontSizeUnit="Point" fontWeight="50" fontUnderline="0" fontFamily="MS Shell Dlg 2" legendString="Aa" isExpression="0" previewBkgrdColor="255,255,255,255" useSubstitutions="0" fontKerning="1" fontSize="8" textColor="0,0,0,255" fontSizeMapUnitScale="3x:0,0,0,0,0,0">
        <families/>
        <text-buffer bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferNoFill="1" bufferJoinStyle="128" bufferBlendMode="0" bufferDraw="0" bufferSizeUnits="MM" bufferColor="255,255,255,255" bufferSize="1" bufferOpacity="1"/>
        <text-mask maskedSymbolLayers="" maskEnabled="0" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskJoinStyle="128" maskSize="0" maskSizeUnits="MM" maskOpacity="1" maskType="0"/>
        <background shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeSizeX="0" shapeBorderColor="128,128,128,255" shapeRadiiUnit="MM" shapeRotation="0" shapeSizeY="0" shapeOffsetUnit="MM" shapeOffsetY="0" shapeDraw="0" shapeRotationType="0" shapeBorderWidth="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeType="0" shapeBlendMode="0" shapeRadiiX="0" shapeSizeUnit="MM" shapeOpacity="1" shapeSVGFile="" shapeBorderWidthUnit="MM" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeOffsetX="0" shapeRadiiY="0" shapeJoinStyle="64" shapeSizeType="0" shapeFillColor="255,255,255,255">
          <symbol force_rhr="0" name="markerSymbol" clip_to_extent="1" type="marker" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="243,166,178,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="35,35,35,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="2" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="cap_style" v="square"/>
              <prop k="color" v="243,166,178,255"/>
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
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
          <symbol force_rhr="0" name="fillSymbol" clip_to_extent="1" type="fill" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleFill">
              <Option type="Map">
                <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
                <Option value="255,255,255,255" name="color" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="128,128,128,255" name="outline_color" type="QString"/>
                <Option value="no" name="outline_style" type="QString"/>
                <Option value="0" name="outline_width" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="solid" name="style" type="QString"/>
              </Option>
              <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="color" v="255,255,255,255"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="128,128,128,255"/>
              <prop k="outline_style" v="no"/>
              <prop k="outline_width" v="0"/>
              <prop k="outline_width_unit" v="MM"/>
              <prop k="style" v="solid"/>
              <data_defined_properties>
                <Option type="Map">
                  <Option value="" name="name" type="QString"/>
                  <Option name="properties"/>
                  <Option value="collection" name="type" type="QString"/>
                </Option>
              </data_defined_properties>
            </layer>
          </symbol>
        </background>
        <shadow shadowDraw="0" shadowRadius="1.5" shadowOffsetAngle="135" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100" shadowColor="0,0,0,255" shadowOffsetDist="1" shadowRadiusUnit="MM" shadowRadiusAlphaOnly="0" shadowOffsetUnit="MM" shadowOpacity="0.69999999999999996" shadowBlendMode="6" shadowUnder="0" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowOffsetGlobal="1"/>
        <dd_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </dd_properties>
        <substitutions/>
      </text-style>
      <text-format wrapChar="" rightDirectionSymbol=">" autoWrapLength="0" useMaxLineLengthForAutoWrap="1" reverseDirectionSymbol="0" formatNumbers="0" multilineAlign="0" placeDirectionSymbol="0" plussign="0" addDirectionSymbol="0" decimals="3" leftDirectionSymbol="&lt;"/>
      <placement preserveRotation="1" layerType="LineGeometry" rotationAngle="0" lineAnchorType="0" lineAnchorClipping="0" distMapUnitScale="3x:0,0,0,0,0,0" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" xOffset="0" centroidWhole="0" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" fitInPolygonOnly="0" yOffset="0" placementFlags="10" maxCurvedCharAngleIn="25" repeatDistanceUnits="MM" quadOffset="4" distUnits="MM" geometryGeneratorType="PointGeometry" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" geometryGeneratorEnabled="0" dist="0" overrunDistance="0" geometryGenerator="" maxCurvedCharAngleOut="-25" overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" repeatDistance="0" placement="2" lineAnchorPercent="0.5" priority="5" centroidInside="0" overrunDistanceUnit="MM" offsetUnits="MM" polygonPlacementFlags="2" rotationUnit="AngleDegrees" offsetType="0"/>
      <rendering upsidedownLabels="0" fontLimitPixelSize="0" labelPerPart="0" scaleMin="0" maxNumLabels="2000" obstacleType="0" minFeatureSize="0" fontMaxPixelSize="10000" scaleMax="1000" obstacleFactor="1" displayAll="0" obstacle="1" zIndex="0" fontMinPixelSize="3" limitNumLabels="0" unplacedVisibility="0" mergeLines="0" scaleVisibility="1" drawLabels="1"/>
      <dd_properties>
        <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
        </Option>
      </dd_properties>
      <callout type="simple">
        <Option type="Map">
          <Option value="pole_of_inaccessibility" name="anchorPoint" type="QString"/>
          <Option value="0" name="blendMode" type="int"/>
          <Option name="ddProperties" type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
          <Option value="false" name="drawToAllParts" type="bool"/>
          <Option value="0" name="enabled" type="QString"/>
          <Option value="point_on_exterior" name="labelAnchorPoint" type="QString"/>
          <Option value="&lt;symbol force_rhr=&quot;0&quot; name=&quot;symbol&quot; clip_to_extent=&quot;1&quot; type=&quot;line&quot; alpha=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer locked=&quot;0&quot; enabled=&quot;1&quot; pass=&quot;0&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;prop k=&quot;align_dash_pattern&quot; v=&quot;0&quot;/>&lt;prop k=&quot;capstyle&quot; v=&quot;square&quot;/>&lt;prop k=&quot;customdash&quot; v=&quot;5;2&quot;/>&lt;prop k=&quot;customdash_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;customdash_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;dash_pattern_offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;dash_pattern_offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;dash_pattern_offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;draw_inside_polygon&quot; v=&quot;0&quot;/>&lt;prop k=&quot;joinstyle&quot; v=&quot;bevel&quot;/>&lt;prop k=&quot;line_color&quot; v=&quot;60,60,60,255&quot;/>&lt;prop k=&quot;line_style&quot; v=&quot;solid&quot;/>&lt;prop k=&quot;line_width&quot; v=&quot;0.3&quot;/>&lt;prop k=&quot;line_width_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;offset&quot; v=&quot;0&quot;/>&lt;prop k=&quot;offset_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;offset_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;ring_filter&quot; v=&quot;0&quot;/>&lt;prop k=&quot;trim_distance_end&quot; v=&quot;0&quot;/>&lt;prop k=&quot;trim_distance_end_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;trim_distance_end_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;trim_distance_start&quot; v=&quot;0&quot;/>&lt;prop k=&quot;trim_distance_start_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;prop k=&quot;trim_distance_start_unit&quot; v=&quot;MM&quot;/>&lt;prop k=&quot;tweak_dash_pattern_on_corners&quot; v=&quot;0&quot;/>&lt;prop k=&quot;use_custom_dash&quot; v=&quot;0&quot;/>&lt;prop k=&quot;width_map_unit_scale&quot; v=&quot;3x:0,0,0,0,0,0&quot;/>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
          <Option value="0" name="minLength" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="minLengthMapUnitScale" type="QString"/>
          <Option value="MM" name="minLengthUnit" type="QString"/>
          <Option value="0" name="offsetFromAnchor" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromAnchorMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromAnchorUnit" type="QString"/>
          <Option value="0" name="offsetFromLabel" type="double"/>
          <Option value="3x:0,0,0,0,0,0" name="offsetFromLabelMapUnitScale" type="QString"/>
          <Option value="MM" name="offsetFromLabelUnit" type="QString"/>
        </Option>
      </callout>
    </settings>
  </labeling>
  <customproperties>
    <Option type="Map">
      <Option value="0" name="embeddedWidgets/count" type="QString"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory lineSizeType="MM" spacing="0" penColor="#000000" diagramOrientation="Up" penAlpha="255" opacity="1" scaleDependency="Area" direction="1" barWidth="5" labelPlacementMethod="XHeight" minScaleDenominator="0" backgroundColor="#ffffff" width="15" rotationOffset="270" lineSizeScale="3x:0,0,0,0,0,0" backgroundAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" sizeScale="3x:0,0,0,0,0,0" showAxis="0" maxScaleDenominator="1e+08" enabled="0" minimumSize="0" height="15" sizeType="MM" spacingUnit="MM" penWidth="0" scaleBasedVisibility="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute field="" color="#000000" label=""/>
      <axisSymbol>
        <symbol force_rhr="0" name="" clip_to_extent="1" type="line" alpha="1">
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" pass="0" class="SimpleLine">
            <Option type="Map">
              <Option value="0" name="align_dash_pattern" type="QString"/>
              <Option value="square" name="capstyle" type="QString"/>
              <Option value="5;2" name="customdash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
              <Option value="MM" name="customdash_unit" type="QString"/>
              <Option value="0" name="dash_pattern_offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
              <Option value="0" name="draw_inside_polygon" type="QString"/>
              <Option value="bevel" name="joinstyle" type="QString"/>
              <Option value="35,35,35,255" name="line_color" type="QString"/>
              <Option value="solid" name="line_style" type="QString"/>
              <Option value="0.26" name="line_width" type="QString"/>
              <Option value="MM" name="line_width_unit" type="QString"/>
              <Option value="0" name="offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="offset_unit" type="QString"/>
              <Option value="0" name="ring_filter" type="QString"/>
              <Option value="0" name="trim_distance_end" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_end_unit" type="QString"/>
              <Option value="0" name="trim_distance_start" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_start_unit" type="QString"/>
              <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
              <Option value="0" name="use_custom_dash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
            </Option>
            <prop k="align_dash_pattern" v="0"/>
            <prop k="capstyle" v="square"/>
            <prop k="customdash" v="5;2"/>
            <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="customdash_unit" v="MM"/>
            <prop k="dash_pattern_offset" v="0"/>
            <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="dash_pattern_offset_unit" v="MM"/>
            <prop k="draw_inside_polygon" v="0"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="line_color" v="35,35,35,255"/>
            <prop k="line_style" v="solid"/>
            <prop k="line_width" v="0.26"/>
            <prop k="line_width_unit" v="MM"/>
            <prop k="offset" v="0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="ring_filter" v="0"/>
            <prop k="trim_distance_end" v="0"/>
            <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_end_unit" v="MM"/>
            <prop k="trim_distance_start" v="0"/>
            <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_start_unit" v="MM"/>
            <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" priority="0" obstacle="0" zIndex="0" dist="0" linePlacementFlags="18" placement="2">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field name="arc_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="node_1" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="node_2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elevation1" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="depth1" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elevation2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="depth2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arccat_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="id" name="Key" type="QString"/>
            <Option value="cat_arc20151120192002466" name="Layer" type="QString"/>
            <Option value="id" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arc_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_matcat_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_pnom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_dnom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="epa_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="PIPE" name="PIPE" type="QString"/>
              <Option value="UNDEFINED" name="UNDEFINED" type="QString"/>
              <Option value="VIRTUALPUMP" name="VIRTUALPUMP" type="QString"/>
              <Option value="VIRTUALVALVE" name="VIRTUALVALVE" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="expl_id" name="Key" type="QString"/>
            <Option value="v_edit_exploitation_fd06cc08_9e9d_4a22_bfca_586b3919d086" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="sector_id" name="Key" type="QString"/>
            <Option value="v_edit_sector20171204170540567" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
              <Option value="1" name="macrosector_01" type="QString"/>
              <Option value="2" name="macrosector_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="OBSOLETE" type="QString"/>
              <Option value="1" name="OPERATIVE" type="QString"/>
              <Option value="2" name="PLANIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="99" name="FICTICIUS" type="QString"/>
              <Option value="1" name="OBSOLETE" type="QString"/>
              <Option value="2" name="OPERATIVE" type="QString"/>
              <Option value="3" name="PLANIFIED" type="QString"/>
              <Option value="5" name="PROVISIONAL" type="QString"/>
              <Option value="4" name="RECONSTRUCT" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gis_length" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="custom_length" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="minsector_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dma_id" name="Key" type="QString"/>
            <Option value="v_edit_dma20190515092620863" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="presszone_id" name="Key" type="QString"/>
            <Option value="v_edit_presszone_d6c14d1a_a691_4ec8_a373_97438e05f219" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dqa_id" name="Key" type="QString"/>
            <Option value="v_edit_dqa_4e695ade_c45c_4562_afb6_1d3c41532a1b" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="soil1" name="soil1" type="QString"/>
              <Option value="soil2" name="soil2" type="QString"/>
              <Option value="soil3" name="soil3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Function" name="St. Function" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Category" name="St. Category" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Fluid" name="St. Fluid" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Location" name="St. Location" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="builder1" name="builder1" type="QString"/>
              <Option value="builder2" name="builder2" type="QString"/>
              <Option value="builder3" name="builder3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate" configurationFlags="None">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option value="true" name="allow_null" type="bool"/>
            <Option value="true" name="calendar_popup" type="bool"/>
            <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
            <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
            <Option value="false" name="field_iso_format" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate" configurationFlags="None">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option value="true" name="allow_null" type="bool"/>
            <Option value="true" name="calendar_popup" type="bool"/>
            <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
            <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
            <Option value="false" name="field_iso_format" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="owner1" name="owner1" type="QString"/>
              <Option value="owner2" name="owner2" type="QString"/>
              <Option value="owner3" name="owner3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Sant Boi del Llobregat" type="QString"/>
              <Option value="2" name="Sant Esteve de les Roures" type="QString"/>
              <Option value="0" name="Undefined" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Camps Blancs" type="QString"/>
              <Option value="2" name="Marianao" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postnumber" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="TO REVIEW" name="TO REVIEW" type="QString"/>
              <Option value="VERIFIED" name="VERIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_x" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_arctype_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodetype_1" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="staticpress1" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodetype_2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="staticpress2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="insert_user" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="depth" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="adate" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="adescript" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_style" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_style" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_plan" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="asset_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pavcat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="Asphalt" name="Asphalt" type="QString"/>
              <Option value="Concrete" name="Concrete" type="QString"/>
              <Option value="Slab" name="Slab" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="om_state" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="conserv_state" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="flow_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="flow_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="flow_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="vel_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="vel_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="vel_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="parent_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id2" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="expl_01" type="QString"/>
              <Option value="2" name="expl_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="is_operative" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="region_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Baix Llobregat" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="province_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Barcelona" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="arc_id" field="arc_id"/>
    <alias index="1" name="code" field="code"/>
    <alias index="2" name="node_1" field="node_1"/>
    <alias index="3" name="node_2" field="node_2"/>
    <alias index="4" name="elevation1" field="elevation1"/>
    <alias index="5" name="depth1" field="depth1"/>
    <alias index="6" name="elevation2" field="elevation2"/>
    <alias index="7" name="depth2" field="depth2"/>
    <alias index="8" name="arccat_id" field="arccat_id"/>
    <alias index="9" name="arc_type" field="arc_type"/>
    <alias index="10" name="sys_type" field="sys_type"/>
    <alias index="11" name="cat_matcat_id" field="cat_matcat_id"/>
    <alias index="12" name="cat_pnom" field="cat_pnom"/>
    <alias index="13" name="cat_dnom" field="cat_dnom"/>
    <alias index="14" name="epa type" field="epa_type"/>
    <alias index="15" name="exploitation" field="expl_id"/>
    <alias index="16" name="Macroexploitation" field="macroexpl_id"/>
    <alias index="17" name="sector" field="sector_id"/>
    <alias index="18" name="Sector name" field="sector_name"/>
    <alias index="19" name="macrosector" field="macrosector_id"/>
    <alias index="20" name="state" field="state"/>
    <alias index="21" name="state type" field="state_type"/>
    <alias index="22" name="annotation" field="annotation"/>
    <alias index="23" name="observ" field="observ"/>
    <alias index="24" name="comment" field="comment"/>
    <alias index="25" name="gis_length" field="gis_length"/>
    <alias index="26" name="custom_length" field="custom_length"/>
    <alias index="27" name="minsector_id" field="minsector_id"/>
    <alias index="28" name="dma" field="dma_id"/>
    <alias index="29" name="Dma name" field="dma_name"/>
    <alias index="30" name="macrodma_id" field="macrodma_id"/>
    <alias index="31" name="Presszone" field="presszone_id"/>
    <alias index="32" name="Presszone name" field="presszone_name"/>
    <alias index="33" name="Dqa" field="dqa_id"/>
    <alias index="34" name="Dqa name" field="dqa_name"/>
    <alias index="35" name="macrodqa_id" field="macrodqa_id"/>
    <alias index="36" name="soilcat_id" field="soilcat_id"/>
    <alias index="37" name="function_type" field="function_type"/>
    <alias index="38" name="category_type" field="category_type"/>
    <alias index="39" name="fluid_type" field="fluid_type"/>
    <alias index="40" name="location_type" field="location_type"/>
    <alias index="41" name="work_id" field="workcat_id"/>
    <alias index="42" name="Work id end" field="workcat_id_end"/>
    <alias index="43" name="builder" field="buildercat_id"/>
    <alias index="44" name="builtdate" field="builtdate"/>
    <alias index="45" name="enddate" field="enddate"/>
    <alias index="46" name="owner" field="ownercat_id"/>
    <alias index="47" name="municipality" field="muni_id"/>
    <alias index="48" name="postcode" field="postcode"/>
    <alias index="49" name="district" field="district_id"/>
    <alias index="50" name="streetname" field="streetname"/>
    <alias index="51" name="postnumber" field="postnumber"/>
    <alias index="52" name="postcomplement" field="postcomplement"/>
    <alias index="53" name="streetname2" field="streetname2"/>
    <alias index="54" name="postnumber2" field="postnumber2"/>
    <alias index="55" name="postcomplement2" field="postcomplement2"/>
    <alias index="56" name="descript" field="descript"/>
    <alias index="57" name="link" field="link"/>
    <alias index="58" name="verified" field="verified"/>
    <alias index="59" name="undelete" field="undelete"/>
    <alias index="60" name="Catalog label" field="label"/>
    <alias index="61" name="label_x" field="label_x"/>
    <alias index="62" name="label_y" field="label_y"/>
    <alias index="63" name="label_rotation" field="label_rotation"/>
    <alias index="64" name="publish" field="publish"/>
    <alias index="65" name="inventory" field="inventory"/>
    <alias index="66" name="num_value" field="num_value"/>
    <alias index="67" name="arc_type" field="cat_arctype_id"/>
    <alias index="68" name="nodetype_1" field="nodetype_1"/>
    <alias index="69" name="staticpressure1" field="staticpress1"/>
    <alias index="70" name="nodetype_2" field="nodetype_2"/>
    <alias index="71" name="staticpressure2" field="staticpress2"/>
    <alias index="72" name="Insert tstamp" field="tstamp"/>
    <alias index="73" name="" field="insert_user"/>
    <alias index="74" name="Last update" field="lastupdate"/>
    <alias index="75" name="Last update user" field="lastupdate_user"/>
    <alias index="76" name="Depth" field="depth"/>
    <alias index="77" name="Adate" field="adate"/>
    <alias index="78" name="A descript" field="adescript"/>
    <alias index="79" name="Dma color" field="dma_style"/>
    <alias index="80" name="Presszone color" field="presszone_style"/>
    <alias index="81" name="workcat_id_plan" field="workcat_id_plan"/>
    <alias index="82" name="asset_id" field="asset_id"/>
    <alias index="83" name="pavcat_id" field="pavcat_id"/>
    <alias index="84" name="om_state" field="om_state"/>
    <alias index="85" name="conserv_state" field="conserv_state"/>
    <alias index="86" name="" field="flow_max"/>
    <alias index="87" name="" field="flow_min"/>
    <alias index="88" name="" field="flow_avg"/>
    <alias index="89" name="" field="vel_max"/>
    <alias index="90" name="" field="vel_min"/>
    <alias index="91" name="" field="vel_avg"/>
    <alias index="92" name="parent_id" field="parent_id"/>
    <alias index="93" name="Exploitation 2" field="expl_id2"/>
    <alias index="94" name="" field="is_operative"/>
    <alias index="95" name="Region" field="region_id"/>
    <alias index="96" name="Province" field="province_id"/>
  </aliases>
  <defaults>
    <default expression="" field="arc_id" applyOnUpdate="0"/>
    <default expression="" field="code" applyOnUpdate="0"/>
    <default expression="" field="node_1" applyOnUpdate="0"/>
    <default expression="" field="node_2" applyOnUpdate="0"/>
    <default expression="" field="elevation1" applyOnUpdate="0"/>
    <default expression="" field="depth1" applyOnUpdate="0"/>
    <default expression="" field="elevation2" applyOnUpdate="0"/>
    <default expression="" field="depth2" applyOnUpdate="0"/>
    <default expression="" field="arccat_id" applyOnUpdate="0"/>
    <default expression="" field="arc_type" applyOnUpdate="0"/>
    <default expression="" field="sys_type" applyOnUpdate="0"/>
    <default expression="" field="cat_matcat_id" applyOnUpdate="0"/>
    <default expression="" field="cat_pnom" applyOnUpdate="0"/>
    <default expression="" field="cat_dnom" applyOnUpdate="0"/>
    <default expression="" field="epa_type" applyOnUpdate="0"/>
    <default expression="" field="expl_id" applyOnUpdate="0"/>
    <default expression="" field="macroexpl_id" applyOnUpdate="0"/>
    <default expression="" field="sector_id" applyOnUpdate="0"/>
    <default expression="" field="sector_name" applyOnUpdate="0"/>
    <default expression="" field="macrosector_id" applyOnUpdate="0"/>
    <default expression="" field="state" applyOnUpdate="0"/>
    <default expression="" field="state_type" applyOnUpdate="0"/>
    <default expression="" field="annotation" applyOnUpdate="0"/>
    <default expression="" field="observ" applyOnUpdate="0"/>
    <default expression="" field="comment" applyOnUpdate="0"/>
    <default expression="" field="gis_length" applyOnUpdate="0"/>
    <default expression="" field="custom_length" applyOnUpdate="0"/>
    <default expression="" field="minsector_id" applyOnUpdate="0"/>
    <default expression="" field="dma_id" applyOnUpdate="0"/>
    <default expression="" field="dma_name" applyOnUpdate="0"/>
    <default expression="" field="macrodma_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_name" applyOnUpdate="0"/>
    <default expression="" field="dqa_id" applyOnUpdate="0"/>
    <default expression="" field="dqa_name" applyOnUpdate="0"/>
    <default expression="" field="macrodqa_id" applyOnUpdate="0"/>
    <default expression="" field="soilcat_id" applyOnUpdate="0"/>
    <default expression="" field="function_type" applyOnUpdate="0"/>
    <default expression="" field="category_type" applyOnUpdate="0"/>
    <default expression="" field="fluid_type" applyOnUpdate="0"/>
    <default expression="" field="location_type" applyOnUpdate="0"/>
    <default expression="" field="workcat_id" applyOnUpdate="0"/>
    <default expression="" field="workcat_id_end" applyOnUpdate="0"/>
    <default expression="" field="buildercat_id" applyOnUpdate="0"/>
    <default expression="" field="builtdate" applyOnUpdate="0"/>
    <default expression="" field="enddate" applyOnUpdate="0"/>
    <default expression="" field="ownercat_id" applyOnUpdate="0"/>
    <default expression="" field="muni_id" applyOnUpdate="0"/>
    <default expression="" field="postcode" applyOnUpdate="0"/>
    <default expression="" field="district_id" applyOnUpdate="0"/>
    <default expression="" field="streetname" applyOnUpdate="0"/>
    <default expression="" field="postnumber" applyOnUpdate="0"/>
    <default expression="" field="postcomplement" applyOnUpdate="0"/>
    <default expression="" field="streetname2" applyOnUpdate="0"/>
    <default expression="" field="postnumber2" applyOnUpdate="0"/>
    <default expression="" field="postcomplement2" applyOnUpdate="0"/>
    <default expression="" field="descript" applyOnUpdate="0"/>
    <default expression="" field="link" applyOnUpdate="0"/>
    <default expression="" field="verified" applyOnUpdate="0"/>
    <default expression="" field="undelete" applyOnUpdate="0"/>
    <default expression="" field="label" applyOnUpdate="0"/>
    <default expression="" field="label_x" applyOnUpdate="0"/>
    <default expression="" field="label_y" applyOnUpdate="0"/>
    <default expression="" field="label_rotation" applyOnUpdate="0"/>
    <default expression="" field="publish" applyOnUpdate="0"/>
    <default expression="" field="inventory" applyOnUpdate="0"/>
    <default expression="" field="num_value" applyOnUpdate="0"/>
    <default expression="" field="cat_arctype_id" applyOnUpdate="0"/>
    <default expression="" field="nodetype_1" applyOnUpdate="0"/>
    <default expression="" field="staticpress1" applyOnUpdate="0"/>
    <default expression="" field="nodetype_2" applyOnUpdate="0"/>
    <default expression="" field="staticpress2" applyOnUpdate="0"/>
    <default expression="" field="tstamp" applyOnUpdate="0"/>
    <default expression="" field="insert_user" applyOnUpdate="0"/>
    <default expression="" field="lastupdate" applyOnUpdate="0"/>
    <default expression="" field="lastupdate_user" applyOnUpdate="0"/>
    <default expression="" field="depth" applyOnUpdate="0"/>
    <default expression="" field="adate" applyOnUpdate="0"/>
    <default expression="" field="adescript" applyOnUpdate="0"/>
    <default expression="" field="dma_style" applyOnUpdate="0"/>
    <default expression="" field="presszone_style" applyOnUpdate="0"/>
    <default expression="" field="workcat_id_plan" applyOnUpdate="0"/>
    <default expression="" field="asset_id" applyOnUpdate="0"/>
    <default expression="" field="pavcat_id" applyOnUpdate="0"/>
    <default expression="" field="om_state" applyOnUpdate="0"/>
    <default expression="" field="conserv_state" applyOnUpdate="0"/>
    <default expression="" field="flow_max" applyOnUpdate="0"/>
    <default expression="" field="flow_min" applyOnUpdate="0"/>
    <default expression="" field="flow_avg" applyOnUpdate="0"/>
    <default expression="" field="vel_max" applyOnUpdate="0"/>
    <default expression="" field="vel_min" applyOnUpdate="0"/>
    <default expression="" field="vel_avg" applyOnUpdate="0"/>
    <default expression="" field="parent_id" applyOnUpdate="0"/>
    <default expression="" field="expl_id2" applyOnUpdate="0"/>
    <default expression="" field="is_operative" applyOnUpdate="0"/>
    <default expression="" field="region_id" applyOnUpdate="0"/>
    <default expression="" field="province_id" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" notnull_strength="2" field="arc_id" constraints="3" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="code" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="node_1" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="node_2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="elevation1" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="depth1" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="elevation2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="depth2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="arccat_id" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="arc_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sys_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_matcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_pnom" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_dnom" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="epa_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="macroexpl_id" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrosector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="annotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="observ" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="comment" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="gis_length" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="custom_length" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="minsector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="soilcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="function_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="category_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="fluid_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="location_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id_end" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="buildercat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="builtdate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="enddate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="ownercat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="muni_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcode" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="district_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="streetname" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postnumber" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcomplement" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="streetname2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postnumber2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcomplement2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="descript" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="link" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="verified" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="undelete" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_x" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_y" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_rotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="publish" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="inventory" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="num_value" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_arctype_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="nodetype_1" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="staticpress1" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="nodetype_2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="staticpress2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="tstamp" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="insert_user" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="lastupdate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="lastupdate_user" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="depth" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="adate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="adescript" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_style" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_style" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id_plan" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="asset_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="pavcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="om_state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="conserv_state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="flow_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="flow_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="flow_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="vel_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="vel_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="vel_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="parent_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="is_operative" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="region_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="province_id" constraints="1" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" field="arc_id" exp=""/>
    <constraint desc="" field="code" exp=""/>
    <constraint desc="" field="node_1" exp=""/>
    <constraint desc="" field="node_2" exp=""/>
    <constraint desc="" field="elevation1" exp=""/>
    <constraint desc="" field="depth1" exp=""/>
    <constraint desc="" field="elevation2" exp=""/>
    <constraint desc="" field="depth2" exp=""/>
    <constraint desc="" field="arccat_id" exp=""/>
    <constraint desc="" field="arc_type" exp=""/>
    <constraint desc="" field="sys_type" exp=""/>
    <constraint desc="" field="cat_matcat_id" exp=""/>
    <constraint desc="" field="cat_pnom" exp=""/>
    <constraint desc="" field="cat_dnom" exp=""/>
    <constraint desc="" field="epa_type" exp=""/>
    <constraint desc="" field="expl_id" exp=""/>
    <constraint desc="" field="macroexpl_id" exp=""/>
    <constraint desc="" field="sector_id" exp=""/>
    <constraint desc="" field="sector_name" exp=""/>
    <constraint desc="" field="macrosector_id" exp=""/>
    <constraint desc="" field="state" exp=""/>
    <constraint desc="" field="state_type" exp=""/>
    <constraint desc="" field="annotation" exp=""/>
    <constraint desc="" field="observ" exp=""/>
    <constraint desc="" field="comment" exp=""/>
    <constraint desc="" field="gis_length" exp=""/>
    <constraint desc="" field="custom_length" exp=""/>
    <constraint desc="" field="minsector_id" exp=""/>
    <constraint desc="" field="dma_id" exp=""/>
    <constraint desc="" field="dma_name" exp=""/>
    <constraint desc="" field="macrodma_id" exp=""/>
    <constraint desc="" field="presszone_id" exp=""/>
    <constraint desc="" field="presszone_name" exp=""/>
    <constraint desc="" field="dqa_id" exp=""/>
    <constraint desc="" field="dqa_name" exp=""/>
    <constraint desc="" field="macrodqa_id" exp=""/>
    <constraint desc="" field="soilcat_id" exp=""/>
    <constraint desc="" field="function_type" exp=""/>
    <constraint desc="" field="category_type" exp=""/>
    <constraint desc="" field="fluid_type" exp=""/>
    <constraint desc="" field="location_type" exp=""/>
    <constraint desc="" field="workcat_id" exp=""/>
    <constraint desc="" field="workcat_id_end" exp=""/>
    <constraint desc="" field="buildercat_id" exp=""/>
    <constraint desc="" field="builtdate" exp=""/>
    <constraint desc="" field="enddate" exp=""/>
    <constraint desc="" field="ownercat_id" exp=""/>
    <constraint desc="" field="muni_id" exp=""/>
    <constraint desc="" field="postcode" exp=""/>
    <constraint desc="" field="district_id" exp=""/>
    <constraint desc="" field="streetname" exp=""/>
    <constraint desc="" field="postnumber" exp=""/>
    <constraint desc="" field="postcomplement" exp=""/>
    <constraint desc="" field="streetname2" exp=""/>
    <constraint desc="" field="postnumber2" exp=""/>
    <constraint desc="" field="postcomplement2" exp=""/>
    <constraint desc="" field="descript" exp=""/>
    <constraint desc="" field="link" exp=""/>
    <constraint desc="" field="verified" exp=""/>
    <constraint desc="" field="undelete" exp=""/>
    <constraint desc="" field="label" exp=""/>
    <constraint desc="" field="label_x" exp=""/>
    <constraint desc="" field="label_y" exp=""/>
    <constraint desc="" field="label_rotation" exp=""/>
    <constraint desc="" field="publish" exp=""/>
    <constraint desc="" field="inventory" exp=""/>
    <constraint desc="" field="num_value" exp=""/>
    <constraint desc="" field="cat_arctype_id" exp=""/>
    <constraint desc="" field="nodetype_1" exp=""/>
    <constraint desc="" field="staticpress1" exp=""/>
    <constraint desc="" field="nodetype_2" exp=""/>
    <constraint desc="" field="staticpress2" exp=""/>
    <constraint desc="" field="tstamp" exp=""/>
    <constraint desc="" field="insert_user" exp=""/>
    <constraint desc="" field="lastupdate" exp=""/>
    <constraint desc="" field="lastupdate_user" exp=""/>
    <constraint desc="" field="depth" exp=""/>
    <constraint desc="" field="adate" exp=""/>
    <constraint desc="" field="adescript" exp=""/>
    <constraint desc="" field="dma_style" exp=""/>
    <constraint desc="" field="presszone_style" exp=""/>
    <constraint desc="" field="workcat_id_plan" exp=""/>
    <constraint desc="" field="asset_id" exp=""/>
    <constraint desc="" field="pavcat_id" exp=""/>
    <constraint desc="" field="om_state" exp=""/>
    <constraint desc="" field="conserv_state" exp=""/>
    <constraint desc="" field="flow_max" exp=""/>
    <constraint desc="" field="flow_min" exp=""/>
    <constraint desc="" field="flow_avg" exp=""/>
    <constraint desc="" field="vel_max" exp=""/>
    <constraint desc="" field="vel_min" exp=""/>
    <constraint desc="" field="vel_avg" exp=""/>
    <constraint desc="" field="parent_id" exp=""/>
    <constraint desc="" field="expl_id2" exp=""/>
    <constraint desc="" field="is_operative" exp=""/>
    <constraint desc="" field="region_id" exp=""/>
    <constraint desc="" field="province_id" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="">
    <columns>
      <column hidden="0" name="arc_id" width="-1" type="field"/>
      <column hidden="0" name="code" width="-1" type="field"/>
      <column hidden="0" name="node_1" width="-1" type="field"/>
      <column hidden="0" name="node_2" width="-1" type="field"/>
      <column hidden="0" name="elevation1" width="-1" type="field"/>
      <column hidden="0" name="depth1" width="-1" type="field"/>
      <column hidden="0" name="elevation2" width="-1" type="field"/>
      <column hidden="0" name="depth2" width="-1" type="field"/>
      <column hidden="0" name="arccat_id" width="-1" type="field"/>
      <column hidden="0" name="arc_type" width="-1" type="field"/>
      <column hidden="0" name="sys_type" width="-1" type="field"/>
      <column hidden="0" name="cat_matcat_id" width="-1" type="field"/>
      <column hidden="0" name="cat_pnom" width="-1" type="field"/>
      <column hidden="0" name="cat_dnom" width="-1" type="field"/>
      <column hidden="0" name="epa_type" width="-1" type="field"/>
      <column hidden="0" name="expl_id" width="-1" type="field"/>
      <column hidden="1" name="macroexpl_id" width="-1" type="field"/>
      <column hidden="0" name="sector_id" width="-1" type="field"/>
      <column hidden="0" name="macrosector_id" width="-1" type="field"/>
      <column hidden="0" name="state" width="-1" type="field"/>
      <column hidden="0" name="state_type" width="-1" type="field"/>
      <column hidden="0" name="annotation" width="-1" type="field"/>
      <column hidden="0" name="observ" width="-1" type="field"/>
      <column hidden="0" name="comment" width="-1" type="field"/>
      <column hidden="0" name="gis_length" width="-1" type="field"/>
      <column hidden="0" name="custom_length" width="-1" type="field"/>
      <column hidden="0" name="minsector_id" width="-1" type="field"/>
      <column hidden="0" name="dma_id" width="-1" type="field"/>
      <column hidden="1" name="macrodma_id" width="-1" type="field"/>
      <column hidden="0" name="dqa_id" width="-1" type="field"/>
      <column hidden="0" name="macrodqa_id" width="-1" type="field"/>
      <column hidden="0" name="soilcat_id" width="-1" type="field"/>
      <column hidden="0" name="function_type" width="-1" type="field"/>
      <column hidden="0" name="category_type" width="-1" type="field"/>
      <column hidden="0" name="fluid_type" width="-1" type="field"/>
      <column hidden="0" name="location_type" width="-1" type="field"/>
      <column hidden="0" name="workcat_id" width="-1" type="field"/>
      <column hidden="0" name="workcat_id_end" width="-1" type="field"/>
      <column hidden="0" name="buildercat_id" width="-1" type="field"/>
      <column hidden="0" name="builtdate" width="-1" type="field"/>
      <column hidden="0" name="enddate" width="-1" type="field"/>
      <column hidden="0" name="ownercat_id" width="-1" type="field"/>
      <column hidden="0" name="muni_id" width="-1" type="field"/>
      <column hidden="0" name="postcode" width="-1" type="field"/>
      <column hidden="0" name="streetname" width="-1" type="field"/>
      <column hidden="0" name="postnumber" width="-1" type="field"/>
      <column hidden="0" name="postcomplement" width="-1" type="field"/>
      <column hidden="0" name="streetname2" width="-1" type="field"/>
      <column hidden="0" name="postnumber2" width="-1" type="field"/>
      <column hidden="0" name="postcomplement2" width="-1" type="field"/>
      <column hidden="0" name="descript" width="-1" type="field"/>
      <column hidden="0" name="link" width="-1" type="field"/>
      <column hidden="0" name="verified" width="-1" type="field"/>
      <column hidden="0" name="undelete" width="-1" type="field"/>
      <column hidden="0" name="label" width="-1" type="field"/>
      <column hidden="0" name="label_x" width="-1" type="field"/>
      <column hidden="0" name="label_y" width="-1" type="field"/>
      <column hidden="0" name="label_rotation" width="-1" type="field"/>
      <column hidden="1" name="publish" width="-1" type="field"/>
      <column hidden="1" name="inventory" width="-1" type="field"/>
      <column hidden="0" name="num_value" width="-1" type="field"/>
      <column hidden="1" name="cat_arctype_id" width="-1" type="field"/>
      <column hidden="0" name="nodetype_1" width="-1" type="field"/>
      <column hidden="0" name="staticpress1" width="-1" type="field"/>
      <column hidden="0" name="nodetype_2" width="-1" type="field"/>
      <column hidden="0" name="staticpress2" width="-1" type="field"/>
      <column hidden="1" name="tstamp" width="-1" type="field"/>
      <column hidden="0" name="insert_user" width="-1" type="field"/>
      <column hidden="1" name="lastupdate" width="-1" type="field"/>
      <column hidden="1" name="lastupdate_user" width="-1" type="field"/>
      <column hidden="1" width="-1" type="actions"/>
      <column hidden="0" name="presszone_id" width="-1" type="field"/>
      <column hidden="1" name="sector_name" width="-1" type="field"/>
      <column hidden="1" name="dma_name" width="-1" type="field"/>
      <column hidden="1" name="presszone_name" width="-1" type="field"/>
      <column hidden="1" name="dqa_name" width="-1" type="field"/>
      <column hidden="1" name="depth" width="-1" type="field"/>
      <column hidden="1" name="adate" width="-1" type="field"/>
      <column hidden="1" name="adescript" width="-1" type="field"/>
      <column hidden="1" name="dma_style" width="-1" type="field"/>
      <column hidden="1" name="presszone_style" width="-1" type="field"/>
      <column hidden="0" name="workcat_id_plan" width="-1" type="field"/>
      <column hidden="0" name="asset_id" width="-1" type="field"/>
      <column hidden="0" name="pavcat_id" width="-1" type="field"/>
      <column hidden="0" name="om_state" width="-1" type="field"/>
      <column hidden="0" name="conserv_state" width="-1" type="field"/>
      <column hidden="0" name="flow_max" width="-1" type="field"/>
      <column hidden="0" name="flow_min" width="-1" type="field"/>
      <column hidden="0" name="flow_avg" width="-1" type="field"/>
      <column hidden="0" name="vel_max" width="-1" type="field"/>
      <column hidden="0" name="vel_min" width="-1" type="field"/>
      <column hidden="0" name="vel_avg" width="-1" type="field"/>
      <column hidden="0" name="parent_id" width="-1" type="field"/>
      <column hidden="0" name="expl_id2" width="-1" type="field"/>
      <column hidden="0" name="is_operative" width="-1" type="field"/>
      <column hidden="0" name="region_id" width="-1" type="field"/>
      <column hidden="0" name="province_id" width="-1" type="field"/>
      <column hidden="1" name="district_id" width="-1" type="field"/>
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
    <field name="adate" editable="0"/>
    <field name="adescript" editable="0"/>
    <field name="annotation" editable="1"/>
    <field name="arc_id" editable="0"/>
    <field name="arc_type" editable="0"/>
    <field name="arccat_id" editable="1"/>
    <field name="asset_id" editable="1"/>
    <field name="buildercat_id" editable="1"/>
    <field name="builtdate" editable="1"/>
    <field name="cat_arctype_id" editable="0"/>
    <field name="cat_dnom" editable="0"/>
    <field name="cat_matcat_id" editable="0"/>
    <field name="cat_pnom" editable="0"/>
    <field name="category_type" editable="1"/>
    <field name="code" editable="1"/>
    <field name="comment" editable="1"/>
    <field name="conserv_state" editable="1"/>
    <field name="custom_length" editable="1"/>
    <field name="depth" editable="0"/>
    <field name="depth1" editable="1"/>
    <field name="depth2" editable="1"/>
    <field name="descript" editable="1"/>
    <field name="district_id" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="dma_name" editable="0"/>
    <field name="dma_style" editable="0"/>
    <field name="dqa_id" editable="0"/>
    <field name="dqa_name" editable="0"/>
    <field name="elevation1" editable="1"/>
    <field name="elevation2" editable="1"/>
    <field name="enddate" editable="1"/>
    <field name="epa_type" editable="1"/>
    <field name="expl_id" editable="1"/>
    <field name="expl_id2" editable="1"/>
    <field name="flow_avg" editable="1"/>
    <field name="flow_max" editable="1"/>
    <field name="flow_min" editable="1"/>
    <field name="fluid_type" editable="1"/>
    <field name="function_type" editable="1"/>
    <field name="gis_length" editable="0"/>
    <field name="insert_user" editable="1"/>
    <field name="inventory" editable="1"/>
    <field name="is_operative" editable="1"/>
    <field name="label" editable="0"/>
    <field name="label_rotation" editable="1"/>
    <field name="label_x" editable="1"/>
    <field name="label_y" editable="1"/>
    <field name="lastupdate" editable="0"/>
    <field name="lastupdate_user" editable="0"/>
    <field name="link" editable="0"/>
    <field name="location_type" editable="1"/>
    <field name="macrodma_id" editable="0"/>
    <field name="macrodqa_id" editable="0"/>
    <field name="macroexpl_id" editable="1"/>
    <field name="macrosector_id" editable="0"/>
    <field name="minsector_id" editable="0"/>
    <field name="muni_id" editable="1"/>
    <field name="node_1" editable="1"/>
    <field name="node_2" editable="1"/>
    <field name="nodetype_1" editable="1"/>
    <field name="nodetype_2" editable="1"/>
    <field name="num_value" editable="1"/>
    <field name="observ" editable="1"/>
    <field name="om_state" editable="1"/>
    <field name="ownercat_id" editable="1"/>
    <field name="parent_id" editable="1"/>
    <field name="pavcat_id" editable="1"/>
    <field name="postcode" editable="1"/>
    <field name="postcomplement" editable="1"/>
    <field name="postcomplement2" editable="1"/>
    <field name="postnumber" editable="1"/>
    <field name="postnumber2" editable="1"/>
    <field name="presszone_id" editable="1"/>
    <field name="presszone_name" editable="0"/>
    <field name="presszone_style" editable="0"/>
    <field name="presszonecat_id" editable="1"/>
    <field name="province_id" editable="0"/>
    <field name="publish" editable="1"/>
    <field name="region_id" editable="0"/>
    <field name="sector_id" editable="1"/>
    <field name="sector_name" editable="0"/>
    <field name="soilcat_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
    <field name="staticpress1" editable="0"/>
    <field name="staticpress2" editable="0"/>
    <field name="streetname" editable="1"/>
    <field name="streetname2" editable="1"/>
    <field name="sys_type" editable="0"/>
    <field name="tstamp" editable="1"/>
    <field name="undelete" editable="1"/>
    <field name="vel_avg" editable="1"/>
    <field name="vel_max" editable="1"/>
    <field name="vel_min" editable="1"/>
    <field name="verified" editable="1"/>
    <field name="workcat_id" editable="1"/>
    <field name="workcat_id_end" editable="1"/>
    <field name="workcat_id_plan" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="adate"/>
    <field labelOnTop="0" name="adescript"/>
    <field labelOnTop="0" name="annotation"/>
    <field labelOnTop="0" name="arc_id"/>
    <field labelOnTop="0" name="arc_type"/>
    <field labelOnTop="0" name="arccat_id"/>
    <field labelOnTop="0" name="asset_id"/>
    <field labelOnTop="0" name="buildercat_id"/>
    <field labelOnTop="0" name="builtdate"/>
    <field labelOnTop="0" name="cat_arctype_id"/>
    <field labelOnTop="0" name="cat_dnom"/>
    <field labelOnTop="0" name="cat_matcat_id"/>
    <field labelOnTop="0" name="cat_pnom"/>
    <field labelOnTop="0" name="category_type"/>
    <field labelOnTop="0" name="code"/>
    <field labelOnTop="0" name="comment"/>
    <field labelOnTop="0" name="conserv_state"/>
    <field labelOnTop="0" name="custom_length"/>
    <field labelOnTop="0" name="depth"/>
    <field labelOnTop="0" name="depth1"/>
    <field labelOnTop="0" name="depth2"/>
    <field labelOnTop="0" name="descript"/>
    <field labelOnTop="0" name="district_id"/>
    <field labelOnTop="0" name="dma_id"/>
    <field labelOnTop="0" name="dma_name"/>
    <field labelOnTop="0" name="dma_style"/>
    <field labelOnTop="0" name="dqa_id"/>
    <field labelOnTop="0" name="dqa_name"/>
    <field labelOnTop="0" name="elevation1"/>
    <field labelOnTop="0" name="elevation2"/>
    <field labelOnTop="0" name="enddate"/>
    <field labelOnTop="0" name="epa_type"/>
    <field labelOnTop="0" name="expl_id"/>
    <field labelOnTop="0" name="expl_id2"/>
    <field labelOnTop="0" name="flow_avg"/>
    <field labelOnTop="0" name="flow_max"/>
    <field labelOnTop="0" name="flow_min"/>
    <field labelOnTop="0" name="fluid_type"/>
    <field labelOnTop="0" name="function_type"/>
    <field labelOnTop="0" name="gis_length"/>
    <field labelOnTop="0" name="insert_user"/>
    <field labelOnTop="0" name="inventory"/>
    <field labelOnTop="0" name="is_operative"/>
    <field labelOnTop="0" name="label"/>
    <field labelOnTop="0" name="label_rotation"/>
    <field labelOnTop="0" name="label_x"/>
    <field labelOnTop="0" name="label_y"/>
    <field labelOnTop="0" name="lastupdate"/>
    <field labelOnTop="0" name="lastupdate_user"/>
    <field labelOnTop="0" name="link"/>
    <field labelOnTop="0" name="location_type"/>
    <field labelOnTop="0" name="macrodma_id"/>
    <field labelOnTop="0" name="macrodqa_id"/>
    <field labelOnTop="0" name="macroexpl_id"/>
    <field labelOnTop="0" name="macrosector_id"/>
    <field labelOnTop="0" name="minsector_id"/>
    <field labelOnTop="0" name="muni_id"/>
    <field labelOnTop="0" name="node_1"/>
    <field labelOnTop="0" name="node_2"/>
    <field labelOnTop="0" name="nodetype_1"/>
    <field labelOnTop="0" name="nodetype_2"/>
    <field labelOnTop="0" name="num_value"/>
    <field labelOnTop="0" name="observ"/>
    <field labelOnTop="0" name="om_state"/>
    <field labelOnTop="0" name="ownercat_id"/>
    <field labelOnTop="0" name="parent_id"/>
    <field labelOnTop="0" name="pavcat_id"/>
    <field labelOnTop="0" name="postcode"/>
    <field labelOnTop="0" name="postcomplement"/>
    <field labelOnTop="0" name="postcomplement2"/>
    <field labelOnTop="0" name="postnumber"/>
    <field labelOnTop="0" name="postnumber2"/>
    <field labelOnTop="0" name="presszone_id"/>
    <field labelOnTop="0" name="presszone_name"/>
    <field labelOnTop="0" name="presszone_style"/>
    <field labelOnTop="0" name="presszonecat_id"/>
    <field labelOnTop="0" name="province_id"/>
    <field labelOnTop="0" name="publish"/>
    <field labelOnTop="0" name="region_id"/>
    <field labelOnTop="0" name="sector_id"/>
    <field labelOnTop="0" name="sector_name"/>
    <field labelOnTop="0" name="soilcat_id"/>
    <field labelOnTop="0" name="state"/>
    <field labelOnTop="0" name="state_type"/>
    <field labelOnTop="0" name="staticpress1"/>
    <field labelOnTop="0" name="staticpress2"/>
    <field labelOnTop="0" name="streetname"/>
    <field labelOnTop="0" name="streetname2"/>
    <field labelOnTop="0" name="sys_type"/>
    <field labelOnTop="0" name="tstamp"/>
    <field labelOnTop="0" name="undelete"/>
    <field labelOnTop="0" name="vel_avg"/>
    <field labelOnTop="0" name="vel_max"/>
    <field labelOnTop="0" name="vel_min"/>
    <field labelOnTop="0" name="verified"/>
    <field labelOnTop="0" name="workcat_id"/>
    <field labelOnTop="0" name="workcat_id_end"/>
    <field labelOnTop="0" name="workcat_id_plan"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="adate" reuseLastValue="0"/>
    <field name="adescript" reuseLastValue="0"/>
    <field name="annotation" reuseLastValue="0"/>
    <field name="arc_id" reuseLastValue="0"/>
    <field name="arc_type" reuseLastValue="0"/>
    <field name="arccat_id" reuseLastValue="0"/>
    <field name="asset_id" reuseLastValue="0"/>
    <field name="buildercat_id" reuseLastValue="0"/>
    <field name="builtdate" reuseLastValue="0"/>
    <field name="cat_arctype_id" reuseLastValue="0"/>
    <field name="cat_dnom" reuseLastValue="0"/>
    <field name="cat_matcat_id" reuseLastValue="0"/>
    <field name="cat_pnom" reuseLastValue="0"/>
    <field name="category_type" reuseLastValue="0"/>
    <field name="code" reuseLastValue="0"/>
    <field name="comment" reuseLastValue="0"/>
    <field name="conserv_state" reuseLastValue="0"/>
    <field name="custom_length" reuseLastValue="0"/>
    <field name="depth" reuseLastValue="0"/>
    <field name="depth1" reuseLastValue="0"/>
    <field name="depth2" reuseLastValue="0"/>
    <field name="descript" reuseLastValue="0"/>
    <field name="district_id" reuseLastValue="0"/>
    <field name="dma_id" reuseLastValue="0"/>
    <field name="dma_name" reuseLastValue="0"/>
    <field name="dma_style" reuseLastValue="0"/>
    <field name="dqa_id" reuseLastValue="0"/>
    <field name="dqa_name" reuseLastValue="0"/>
    <field name="elevation1" reuseLastValue="0"/>
    <field name="elevation2" reuseLastValue="0"/>
    <field name="enddate" reuseLastValue="0"/>
    <field name="epa_type" reuseLastValue="0"/>
    <field name="expl_id" reuseLastValue="0"/>
    <field name="expl_id2" reuseLastValue="0"/>
    <field name="flow_avg" reuseLastValue="0"/>
    <field name="flow_max" reuseLastValue="0"/>
    <field name="flow_min" reuseLastValue="0"/>
    <field name="fluid_type" reuseLastValue="0"/>
    <field name="function_type" reuseLastValue="0"/>
    <field name="gis_length" reuseLastValue="0"/>
    <field name="insert_user" reuseLastValue="0"/>
    <field name="inventory" reuseLastValue="0"/>
    <field name="is_operative" reuseLastValue="0"/>
    <field name="label" reuseLastValue="0"/>
    <field name="label_rotation" reuseLastValue="0"/>
    <field name="label_x" reuseLastValue="0"/>
    <field name="label_y" reuseLastValue="0"/>
    <field name="lastupdate" reuseLastValue="0"/>
    <field name="lastupdate_user" reuseLastValue="0"/>
    <field name="link" reuseLastValue="0"/>
    <field name="location_type" reuseLastValue="0"/>
    <field name="macrodma_id" reuseLastValue="0"/>
    <field name="macrodqa_id" reuseLastValue="0"/>
    <field name="macroexpl_id" reuseLastValue="0"/>
    <field name="macrosector_id" reuseLastValue="0"/>
    <field name="minsector_id" reuseLastValue="0"/>
    <field name="muni_id" reuseLastValue="0"/>
    <field name="node_1" reuseLastValue="0"/>
    <field name="node_2" reuseLastValue="0"/>
    <field name="nodetype_1" reuseLastValue="0"/>
    <field name="nodetype_2" reuseLastValue="0"/>
    <field name="num_value" reuseLastValue="0"/>
    <field name="observ" reuseLastValue="0"/>
    <field name="om_state" reuseLastValue="0"/>
    <field name="ownercat_id" reuseLastValue="0"/>
    <field name="parent_id" reuseLastValue="0"/>
    <field name="pavcat_id" reuseLastValue="0"/>
    <field name="postcode" reuseLastValue="0"/>
    <field name="postcomplement" reuseLastValue="0"/>
    <field name="postcomplement2" reuseLastValue="0"/>
    <field name="postnumber" reuseLastValue="0"/>
    <field name="postnumber2" reuseLastValue="0"/>
    <field name="presszone_id" reuseLastValue="0"/>
    <field name="presszone_name" reuseLastValue="0"/>
    <field name="presszone_style" reuseLastValue="0"/>
    <field name="province_id" reuseLastValue="0"/>
    <field name="publish" reuseLastValue="0"/>
    <field name="region_id" reuseLastValue="0"/>
    <field name="sector_id" reuseLastValue="0"/>
    <field name="sector_name" reuseLastValue="0"/>
    <field name="soilcat_id" reuseLastValue="0"/>
    <field name="state" reuseLastValue="0"/>
    <field name="state_type" reuseLastValue="0"/>
    <field name="staticpress1" reuseLastValue="0"/>
    <field name="staticpress2" reuseLastValue="0"/>
    <field name="streetname" reuseLastValue="0"/>
    <field name="streetname2" reuseLastValue="0"/>
    <field name="sys_type" reuseLastValue="0"/>
    <field name="tstamp" reuseLastValue="0"/>
    <field name="undelete" reuseLastValue="0"/>
    <field name="vel_avg" reuseLastValue="0"/>
    <field name="vel_max" reuseLastValue="0"/>
    <field name="vel_min" reuseLastValue="0"/>
    <field name="verified" reuseLastValue="0"/>
    <field name="workcat_id" reuseLastValue="0"/>
    <field name="workcat_id_end" reuseLastValue="0"/>
    <field name="workcat_id_plan" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"arc_id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
'
WHERE id = 201;

UPDATE sys_style SET stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis minScale="2500" simplifyMaxScale="1" styleCategories="AllStyleCategories" readOnly="0" simplifyAlgorithm="0" symbologyReferenceScale="-1" maxScale="0" labelsEnabled="0" simplifyDrawingTol="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" simplifyDrawingHints="0" version="3.22.4-Białowieża">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal mode="0" enabled="0" fixedDuration="0" startField="" startExpression="" accumulate="0" limitMode="0" endField="" endExpression="" durationUnit="min" durationField="">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 referencescale="-1" attr="epa_type" symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol">
    <categories>
      <category value="JUNCTION" render="true" label="JUNCTION" symbol="0"/>
    </categories>
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="5,163,242,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,87,128,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="5,163,242,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="50,87,128,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
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
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="5,163,242,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,87,128,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="5,163,242,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="50,87,128,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
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
    <colorramp name="[source]" type="randomcolors">
      <Option/>
    </colorramp>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option value="0" name="embeddedWidgets/count" type="QString"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory lineSizeType="MM" spacing="0" penColor="#000000" diagramOrientation="Up" penAlpha="255" opacity="1" scaleDependency="Area" direction="1" barWidth="5" labelPlacementMethod="XHeight" minScaleDenominator="0" backgroundColor="#ffffff" width="15" rotationOffset="270" lineSizeScale="3x:0,0,0,0,0,0" backgroundAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" sizeScale="3x:0,0,0,0,0,0" showAxis="0" maxScaleDenominator="1e+08" enabled="0" minimumSize="0" height="15" sizeType="MM" spacingUnit="MM" penWidth="0" scaleBasedVisibility="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute field="" color="#000000" label=""/>
      <axisSymbol>
        <symbol force_rhr="0" name="" clip_to_extent="1" type="line" alpha="1">
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" pass="0" class="SimpleLine">
            <Option type="Map">
              <Option value="0" name="align_dash_pattern" type="QString"/>
              <Option value="square" name="capstyle" type="QString"/>
              <Option value="5;2" name="customdash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
              <Option value="MM" name="customdash_unit" type="QString"/>
              <Option value="0" name="dash_pattern_offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
              <Option value="0" name="draw_inside_polygon" type="QString"/>
              <Option value="bevel" name="joinstyle" type="QString"/>
              <Option value="35,35,35,255" name="line_color" type="QString"/>
              <Option value="solid" name="line_style" type="QString"/>
              <Option value="0.26" name="line_width" type="QString"/>
              <Option value="MM" name="line_width_unit" type="QString"/>
              <Option value="0" name="offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="offset_unit" type="QString"/>
              <Option value="0" name="ring_filter" type="QString"/>
              <Option value="0" name="trim_distance_end" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_end_unit" type="QString"/>
              <Option value="0" name="trim_distance_start" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_start_unit" type="QString"/>
              <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
              <Option value="0" name="use_custom_dash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
            </Option>
            <prop k="align_dash_pattern" v="0"/>
            <prop k="capstyle" v="square"/>
            <prop k="customdash" v="5;2"/>
            <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="customdash_unit" v="MM"/>
            <prop k="dash_pattern_offset" v="0"/>
            <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="dash_pattern_offset_unit" v="MM"/>
            <prop k="draw_inside_polygon" v="0"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="line_color" v="35,35,35,255"/>
            <prop k="line_style" v="solid"/>
            <prop k="line_width" v="0.26"/>
            <prop k="line_width_unit" v="MM"/>
            <prop k="offset" v="0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="ring_filter" v="0"/>
            <prop k="trim_distance_end" v="0"/>
            <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_end_unit" v="MM"/>
            <prop k="trim_distance_start" v="0"/>
            <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_start_unit" v="MM"/>
            <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" priority="0" obstacle="0" zIndex="0" dist="0" linePlacementFlags="18" placement="0">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field name="connec_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elevation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="depth" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connecat_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="id" name="Key" type="QString"/>
            <Option value="cat_connec20160216122620764" name="Layer" type="QString"/>
            <Option value="id" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="expl_id" name="Key" type="QString"/>
            <Option value="v_edit_exploitation_fd06cc08_9e9d_4a22_bfca_586b3919d086" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="sector_id" name="Key" type="QString"/>
            <Option value="v_edit_sector20171204170540567" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
              <Option value="1" name="macrosector_01" type="QString"/>
              <Option value="2" name="macrosector_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="customer_code" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_matcat_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_pnom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_dnom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connec_length" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="OBSOLETE" type="QString"/>
              <Option value="1" name="OPERATIVE" type="QString"/>
              <Option value="2" name="PLANIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="99" name="FICTICIUS" type="QString"/>
              <Option value="1" name="OBSOLETE" type="QString"/>
              <Option value="2" name="OPERATIVE" type="QString"/>
              <Option value="3" name="PLANIFIED" type="QString"/>
              <Option value="5" name="PROVISIONAL" type="QString"/>
              <Option value="4" name="RECONSTRUCT" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="n_hydrometer" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arc_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="minsector_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dma_id" name="Key" type="QString"/>
            <Option value="v_edit_dma20190515092620863" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="presszone_id" name="Key" type="QString"/>
            <Option value="v_edit_presszone_d6c14d1a_a691_4ec8_a373_97438e05f219" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="staticpressure" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dqa_id" name="Key" type="QString"/>
            <Option value="v_edit_dqa_4e695ade_c45c_4562_afb6_1d3c41532a1b" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="soil1" name="soil1" type="QString"/>
              <Option value="soil2" name="soil2" type="QString"/>
              <Option value="soil3" name="soil3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Function" name="St. Function" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Category" name="St. Category" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Fluid" name="St. Fluid" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Location" name="St. Location" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="builder1" name="builder1" type="QString"/>
              <Option value="builder2" name="builder2" type="QString"/>
              <Option value="builder3" name="builder3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate" configurationFlags="None">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option value="true" name="allow_null" type="bool"/>
            <Option value="true" name="calendar_popup" type="bool"/>
            <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
            <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
            <Option value="false" name="field_iso_format" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate" configurationFlags="None">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option value="true" name="allow_null" type="bool"/>
            <Option value="true" name="calendar_popup" type="bool"/>
            <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
            <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
            <Option value="false" name="field_iso_format" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="owner1" name="owner1" type="QString"/>
              <Option value="owner2" name="owner2" type="QString"/>
              <Option value="owner3" name="owner3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Sant Boi del Llobregat" type="QString"/>
              <Option value="2" name="Sant Esteve de les Roures" type="QString"/>
              <Option value="0" name="Undefined" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Camps Blancs" type="QString"/>
              <Option value="2" name="Marianao" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postnumber" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="svg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="rotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="TO REVIEW" name="TO REVIEW" type="QString"/>
              <Option value="VERIFIED" name="VERIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_x" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="connectype_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pjoint_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="pjoint_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="insert_user" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="adate" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="adescript" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="accessibility" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_plan" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="asset_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_style" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_style" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="epa_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="priority" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="valve_location" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="valve_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="shutoff_valve" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="access_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="placement_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="press_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="press_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="press_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="demand" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="om_state" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="conserv_state" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="crmzone_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="crmzone_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id2" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="expl_01" type="QString"/>
              <Option value="2" name="expl_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="quality_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="quality_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="quality_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="is_operative" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="region_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Baix Llobregat" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="province_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Barcelona" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="connec_id" field="connec_id"/>
    <alias index="1" name="code" field="code"/>
    <alias index="2" name="elevation" field="elevation"/>
    <alias index="3" name="depth" field="depth"/>
    <alias index="4" name="connec_type" field="connec_type"/>
    <alias index="5" name="sys_type" field="sys_type"/>
    <alias index="6" name="connecat_id" field="connecat_id"/>
    <alias index="7" name="exploitation" field="expl_id"/>
    <alias index="8" name="Macroexploitation" field="macroexpl_id"/>
    <alias index="9" name="sector" field="sector_id"/>
    <alias index="10" name="Sector name" field="sector_name"/>
    <alias index="11" name="macrosector" field="macrosector_id"/>
    <alias index="12" name="customer_code" field="customer_code"/>
    <alias index="13" name="cat_matcat_id" field="cat_matcat_id"/>
    <alias index="14" name="cat_pnom" field="cat_pnom"/>
    <alias index="15" name="cat_dnom" field="cat_dnom"/>
    <alias index="16" name="connec_length" field="connec_length"/>
    <alias index="17" name="state" field="state"/>
    <alias index="18" name="state_type" field="state_type"/>
    <alias index="19" name="n_hydrometer" field="n_hydrometer"/>
    <alias index="20" name="arc_id" field="arc_id"/>
    <alias index="21" name="annotation" field="annotation"/>
    <alias index="22" name="observ" field="observ"/>
    <alias index="23" name="comment" field="comment"/>
    <alias index="24" name="minsector_id" field="minsector_id"/>
    <alias index="25" name="dma" field="dma_id"/>
    <alias index="26" name="Dma name" field="dma_name"/>
    <alias index="27" name="macrodma_id" field="macrodma_id"/>
    <alias index="28" name="Presszone" field="presszone_id"/>
    <alias index="29" name="Presszone name" field="presszone_name"/>
    <alias index="30" name="staticpressure" field="staticpressure"/>
    <alias index="31" name="Dqa" field="dqa_id"/>
    <alias index="32" name="Dqa name" field="dqa_name"/>
    <alias index="33" name="macrodqa_id" field="macrodqa_id"/>
    <alias index="34" name="soilcat_id" field="soilcat_id"/>
    <alias index="35" name="function_type" field="function_type"/>
    <alias index="36" name="category_type" field="category_type"/>
    <alias index="37" name="fluid_type" field="fluid_type"/>
    <alias index="38" name="location_type" field="location_type"/>
    <alias index="39" name="work_id" field="workcat_id"/>
    <alias index="40" name="work_id_end" field="workcat_id_end"/>
    <alias index="41" name="builder" field="buildercat_id"/>
    <alias index="42" name="builtdate" field="builtdate"/>
    <alias index="43" name="enddate" field="enddate"/>
    <alias index="44" name="owner" field="ownercat_id"/>
    <alias index="45" name="municipality" field="muni_id"/>
    <alias index="46" name="postcode" field="postcode"/>
    <alias index="47" name="district" field="district_id"/>
    <alias index="48" name="streetname" field="streetname"/>
    <alias index="49" name="postnumber" field="postnumber"/>
    <alias index="50" name="postcomplement" field="postcomplement"/>
    <alias index="51" name="streetname2" field="streetname2"/>
    <alias index="52" name="postnumber2" field="postnumber2"/>
    <alias index="53" name="postcomplement2" field="postcomplement2"/>
    <alias index="54" name="descript" field="descript"/>
    <alias index="55" name="svg" field="svg"/>
    <alias index="56" name="rotation" field="rotation"/>
    <alias index="57" name="link" field="link"/>
    <alias index="58" name="verified" field="verified"/>
    <alias index="59" name="undelete" field="undelete"/>
    <alias index="60" name="Catalog label" field="label"/>
    <alias index="61" name="label_x" field="label_x"/>
    <alias index="62" name="label_y" field="label_y"/>
    <alias index="63" name="label_rotation" field="label_rotation"/>
    <alias index="64" name="publish" field="publish"/>
    <alias index="65" name="inventory" field="inventory"/>
    <alias index="66" name="num_value" field="num_value"/>
    <alias index="67" name="connec_type" field="connectype_id"/>
    <alias index="68" name="pjoint_id" field="pjoint_id"/>
    <alias index="69" name="pjoint_type" field="pjoint_type"/>
    <alias index="70" name="Insert tstamp" field="tstamp"/>
    <alias index="71" name="" field="insert_user"/>
    <alias index="72" name="Last update" field="lastupdate"/>
    <alias index="73" name="Last update user" field="lastupdate_user"/>
    <alias index="74" name="Adate" field="adate"/>
    <alias index="75" name="A descript" field="adescript"/>
    <alias index="76" name="Accessibility" field="accessibility"/>
    <alias index="77" name="workcat_id_plan" field="workcat_id_plan"/>
    <alias index="78" name="asset_id" field="asset_id"/>
    <alias index="79" name="Dma color" field="dma_style"/>
    <alias index="80" name="Presszone color" field="presszone_style"/>
    <alias index="81" name="" field="epa_type"/>
    <alias index="82" name="priority" field="priority"/>
    <alias index="83" name="valve_location" field="valve_location"/>
    <alias index="84" name="valve_type" field="valve_type"/>
    <alias index="85" name="shutoff_valve" field="shutoff_valve"/>
    <alias index="86" name="access_type" field="access_type"/>
    <alias index="87" name="placement_type" field="placement_type"/>
    <alias index="88" name="" field="press_max"/>
    <alias index="89" name="" field="press_min"/>
    <alias index="90" name="" field="press_avg"/>
    <alias index="91" name="" field="demand"/>
    <alias index="92" name="om_state" field="om_state"/>
    <alias index="93" name="conserv_state" field="conserv_state"/>
    <alias index="94" name="crmzone_id" field="crmzone_id"/>
    <alias index="95" name="crmzone_name" field="crmzone_name"/>
    <alias index="96" name="Exploitation 2" field="expl_id2"/>
    <alias index="97" name="" field="quality_max"/>
    <alias index="98" name="" field="quality_min"/>
    <alias index="99" name="" field="quality_avg"/>
    <alias index="100" name="" field="is_operative"/>
    <alias index="101" name="Region" field="region_id"/>
    <alias index="102" name="Province" field="province_id"/>
  </aliases>
  <defaults>
    <default expression="" field="connec_id" applyOnUpdate="0"/>
    <default expression="" field="code" applyOnUpdate="0"/>
    <default expression="" field="elevation" applyOnUpdate="0"/>
    <default expression="" field="depth" applyOnUpdate="0"/>
    <default expression="" field="connec_type" applyOnUpdate="0"/>
    <default expression="" field="sys_type" applyOnUpdate="0"/>
    <default expression="" field="connecat_id" applyOnUpdate="0"/>
    <default expression="" field="expl_id" applyOnUpdate="0"/>
    <default expression="" field="macroexpl_id" applyOnUpdate="0"/>
    <default expression="" field="sector_id" applyOnUpdate="0"/>
    <default expression="" field="sector_name" applyOnUpdate="0"/>
    <default expression="" field="macrosector_id" applyOnUpdate="0"/>
    <default expression="" field="customer_code" applyOnUpdate="0"/>
    <default expression="" field="cat_matcat_id" applyOnUpdate="0"/>
    <default expression="" field="cat_pnom" applyOnUpdate="0"/>
    <default expression="" field="cat_dnom" applyOnUpdate="0"/>
    <default expression="" field="connec_length" applyOnUpdate="0"/>
    <default expression="" field="state" applyOnUpdate="0"/>
    <default expression="" field="state_type" applyOnUpdate="0"/>
    <default expression="" field="n_hydrometer" applyOnUpdate="0"/>
    <default expression="" field="arc_id" applyOnUpdate="0"/>
    <default expression="" field="annotation" applyOnUpdate="0"/>
    <default expression="" field="observ" applyOnUpdate="0"/>
    <default expression="" field="comment" applyOnUpdate="0"/>
    <default expression="" field="minsector_id" applyOnUpdate="0"/>
    <default expression="" field="dma_id" applyOnUpdate="0"/>
    <default expression="" field="dma_name" applyOnUpdate="0"/>
    <default expression="" field="macrodma_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_name" applyOnUpdate="0"/>
    <default expression="" field="staticpressure" applyOnUpdate="0"/>
    <default expression="" field="dqa_id" applyOnUpdate="0"/>
    <default expression="" field="dqa_name" applyOnUpdate="0"/>
    <default expression="" field="macrodqa_id" applyOnUpdate="0"/>
    <default expression="" field="soilcat_id" applyOnUpdate="0"/>
    <default expression="" field="function_type" applyOnUpdate="0"/>
    <default expression="" field="category_type" applyOnUpdate="0"/>
    <default expression="" field="fluid_type" applyOnUpdate="0"/>
    <default expression="" field="location_type" applyOnUpdate="0"/>
    <default expression="" field="workcat_id" applyOnUpdate="0"/>
    <default expression="" field="workcat_id_end" applyOnUpdate="0"/>
    <default expression="" field="buildercat_id" applyOnUpdate="0"/>
    <default expression="" field="builtdate" applyOnUpdate="0"/>
    <default expression="" field="enddate" applyOnUpdate="0"/>
    <default expression="" field="ownercat_id" applyOnUpdate="0"/>
    <default expression="" field="muni_id" applyOnUpdate="0"/>
    <default expression="" field="postcode" applyOnUpdate="0"/>
    <default expression="" field="district_id" applyOnUpdate="0"/>
    <default expression="" field="streetname" applyOnUpdate="0"/>
    <default expression="" field="postnumber" applyOnUpdate="0"/>
    <default expression="" field="postcomplement" applyOnUpdate="0"/>
    <default expression="" field="streetname2" applyOnUpdate="0"/>
    <default expression="" field="postnumber2" applyOnUpdate="0"/>
    <default expression="" field="postcomplement2" applyOnUpdate="0"/>
    <default expression="" field="descript" applyOnUpdate="0"/>
    <default expression="" field="svg" applyOnUpdate="0"/>
    <default expression="" field="rotation" applyOnUpdate="0"/>
    <default expression="" field="link" applyOnUpdate="0"/>
    <default expression="" field="verified" applyOnUpdate="0"/>
    <default expression="" field="undelete" applyOnUpdate="0"/>
    <default expression="" field="label" applyOnUpdate="0"/>
    <default expression="" field="label_x" applyOnUpdate="0"/>
    <default expression="" field="label_y" applyOnUpdate="0"/>
    <default expression="" field="label_rotation" applyOnUpdate="0"/>
    <default expression="" field="publish" applyOnUpdate="0"/>
    <default expression="" field="inventory" applyOnUpdate="0"/>
    <default expression="" field="num_value" applyOnUpdate="0"/>
    <default expression="" field="connectype_id" applyOnUpdate="0"/>
    <default expression="" field="pjoint_id" applyOnUpdate="0"/>
    <default expression="" field="pjoint_type" applyOnUpdate="0"/>
    <default expression="" field="tstamp" applyOnUpdate="0"/>
    <default expression="" field="insert_user" applyOnUpdate="0"/>
    <default expression="" field="lastupdate" applyOnUpdate="0"/>
    <default expression="" field="lastupdate_user" applyOnUpdate="0"/>
    <default expression="" field="adate" applyOnUpdate="0"/>
    <default expression="" field="adescript" applyOnUpdate="0"/>
    <default expression="" field="accessibility" applyOnUpdate="0"/>
    <default expression="" field="workcat_id_plan" applyOnUpdate="0"/>
    <default expression="" field="asset_id" applyOnUpdate="0"/>
    <default expression="" field="dma_style" applyOnUpdate="0"/>
    <default expression="" field="presszone_style" applyOnUpdate="0"/>
    <default expression="" field="epa_type" applyOnUpdate="0"/>
    <default expression="" field="priority" applyOnUpdate="0"/>
    <default expression="" field="valve_location" applyOnUpdate="0"/>
    <default expression="" field="valve_type" applyOnUpdate="0"/>
    <default expression="" field="shutoff_valve" applyOnUpdate="0"/>
    <default expression="" field="access_type" applyOnUpdate="0"/>
    <default expression="" field="placement_type" applyOnUpdate="0"/>
    <default expression="" field="press_max" applyOnUpdate="0"/>
    <default expression="" field="press_min" applyOnUpdate="0"/>
    <default expression="" field="press_avg" applyOnUpdate="0"/>
    <default expression="" field="demand" applyOnUpdate="0"/>
    <default expression="" field="om_state" applyOnUpdate="0"/>
    <default expression="" field="conserv_state" applyOnUpdate="0"/>
    <default expression="" field="crmzone_id" applyOnUpdate="0"/>
    <default expression="" field="crmzone_name" applyOnUpdate="0"/>
    <default expression="" field="expl_id2" applyOnUpdate="0"/>
    <default expression="" field="quality_max" applyOnUpdate="0"/>
    <default expression="" field="quality_min" applyOnUpdate="0"/>
    <default expression="" field="quality_avg" applyOnUpdate="0"/>
    <default expression="" field="is_operative" applyOnUpdate="0"/>
    <default expression="" field="region_id" applyOnUpdate="0"/>
    <default expression="" field="province_id" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" notnull_strength="2" field="connec_id" constraints="3" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="code" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="elevation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="depth" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="connec_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sys_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="connecat_id" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="macroexpl_id" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrosector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="customer_code" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_matcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_pnom" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_dnom" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="connec_length" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="n_hydrometer" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="arc_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="annotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="observ" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="comment" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="minsector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="staticpressure" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="soilcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="function_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="category_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="fluid_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="location_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id_end" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="buildercat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="builtdate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="enddate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="ownercat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="muni_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcode" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="district_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="streetname" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postnumber" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcomplement" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="streetname2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postnumber2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcomplement2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="descript" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="svg" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="rotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="link" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="verified" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="undelete" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_x" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_y" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_rotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="publish" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="inventory" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="num_value" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="connectype_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="pjoint_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="pjoint_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="tstamp" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="insert_user" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="lastupdate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="lastupdate_user" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="adate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="adescript" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="accessibility" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id_plan" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="asset_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_style" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_style" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="epa_type" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="priority" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="valve_location" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="valve_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="shutoff_valve" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="access_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="placement_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="press_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="press_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="press_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="demand" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="om_state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="conserv_state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="crmzone_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="crmzone_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="quality_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="quality_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="quality_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="is_operative" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="region_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="province_id" constraints="1" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" field="connec_id" exp=""/>
    <constraint desc="" field="code" exp=""/>
    <constraint desc="" field="elevation" exp=""/>
    <constraint desc="" field="depth" exp=""/>
    <constraint desc="" field="connec_type" exp=""/>
    <constraint desc="" field="sys_type" exp=""/>
    <constraint desc="" field="connecat_id" exp=""/>
    <constraint desc="" field="expl_id" exp=""/>
    <constraint desc="" field="macroexpl_id" exp=""/>
    <constraint desc="" field="sector_id" exp=""/>
    <constraint desc="" field="sector_name" exp=""/>
    <constraint desc="" field="macrosector_id" exp=""/>
    <constraint desc="" field="customer_code" exp=""/>
    <constraint desc="" field="cat_matcat_id" exp=""/>
    <constraint desc="" field="cat_pnom" exp=""/>
    <constraint desc="" field="cat_dnom" exp=""/>
    <constraint desc="" field="connec_length" exp=""/>
    <constraint desc="" field="state" exp=""/>
    <constraint desc="" field="state_type" exp=""/>
    <constraint desc="" field="n_hydrometer" exp=""/>
    <constraint desc="" field="arc_id" exp=""/>
    <constraint desc="" field="annotation" exp=""/>
    <constraint desc="" field="observ" exp=""/>
    <constraint desc="" field="comment" exp=""/>
    <constraint desc="" field="minsector_id" exp=""/>
    <constraint desc="" field="dma_id" exp=""/>
    <constraint desc="" field="dma_name" exp=""/>
    <constraint desc="" field="macrodma_id" exp=""/>
    <constraint desc="" field="presszone_id" exp=""/>
    <constraint desc="" field="presszone_name" exp=""/>
    <constraint desc="" field="staticpressure" exp=""/>
    <constraint desc="" field="dqa_id" exp=""/>
    <constraint desc="" field="dqa_name" exp=""/>
    <constraint desc="" field="macrodqa_id" exp=""/>
    <constraint desc="" field="soilcat_id" exp=""/>
    <constraint desc="" field="function_type" exp=""/>
    <constraint desc="" field="category_type" exp=""/>
    <constraint desc="" field="fluid_type" exp=""/>
    <constraint desc="" field="location_type" exp=""/>
    <constraint desc="" field="workcat_id" exp=""/>
    <constraint desc="" field="workcat_id_end" exp=""/>
    <constraint desc="" field="buildercat_id" exp=""/>
    <constraint desc="" field="builtdate" exp=""/>
    <constraint desc="" field="enddate" exp=""/>
    <constraint desc="" field="ownercat_id" exp=""/>
    <constraint desc="" field="muni_id" exp=""/>
    <constraint desc="" field="postcode" exp=""/>
    <constraint desc="" field="district_id" exp=""/>
    <constraint desc="" field="streetname" exp=""/>
    <constraint desc="" field="postnumber" exp=""/>
    <constraint desc="" field="postcomplement" exp=""/>
    <constraint desc="" field="streetname2" exp=""/>
    <constraint desc="" field="postnumber2" exp=""/>
    <constraint desc="" field="postcomplement2" exp=""/>
    <constraint desc="" field="descript" exp=""/>
    <constraint desc="" field="svg" exp=""/>
    <constraint desc="" field="rotation" exp=""/>
    <constraint desc="" field="link" exp=""/>
    <constraint desc="" field="verified" exp=""/>
    <constraint desc="" field="undelete" exp=""/>
    <constraint desc="" field="label" exp=""/>
    <constraint desc="" field="label_x" exp=""/>
    <constraint desc="" field="label_y" exp=""/>
    <constraint desc="" field="label_rotation" exp=""/>
    <constraint desc="" field="publish" exp=""/>
    <constraint desc="" field="inventory" exp=""/>
    <constraint desc="" field="num_value" exp=""/>
    <constraint desc="" field="connectype_id" exp=""/>
    <constraint desc="" field="pjoint_id" exp=""/>
    <constraint desc="" field="pjoint_type" exp=""/>
    <constraint desc="" field="tstamp" exp=""/>
    <constraint desc="" field="insert_user" exp=""/>
    <constraint desc="" field="lastupdate" exp=""/>
    <constraint desc="" field="lastupdate_user" exp=""/>
    <constraint desc="" field="adate" exp=""/>
    <constraint desc="" field="adescript" exp=""/>
    <constraint desc="" field="accessibility" exp=""/>
    <constraint desc="" field="workcat_id_plan" exp=""/>
    <constraint desc="" field="asset_id" exp=""/>
    <constraint desc="" field="dma_style" exp=""/>
    <constraint desc="" field="presszone_style" exp=""/>
    <constraint desc="" field="epa_type" exp=""/>
    <constraint desc="" field="priority" exp=""/>
    <constraint desc="" field="valve_location" exp=""/>
    <constraint desc="" field="valve_type" exp=""/>
    <constraint desc="" field="shutoff_valve" exp=""/>
    <constraint desc="" field="access_type" exp=""/>
    <constraint desc="" field="placement_type" exp=""/>
    <constraint desc="" field="press_max" exp=""/>
    <constraint desc="" field="press_min" exp=""/>
    <constraint desc="" field="press_avg" exp=""/>
    <constraint desc="" field="demand" exp=""/>
    <constraint desc="" field="om_state" exp=""/>
    <constraint desc="" field="conserv_state" exp=""/>
    <constraint desc="" field="crmzone_id" exp=""/>
    <constraint desc="" field="crmzone_name" exp=""/>
    <constraint desc="" field="expl_id2" exp=""/>
    <constraint desc="" field="quality_max" exp=""/>
    <constraint desc="" field="quality_min" exp=""/>
    <constraint desc="" field="quality_avg" exp=""/>
    <constraint desc="" field="is_operative" exp=""/>
    <constraint desc="" field="region_id" exp=""/>
    <constraint desc="" field="province_id" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="">
    <columns>
      <column hidden="0" name="connec_id" width="-1" type="field"/>
      <column hidden="0" name="code" width="-1" type="field"/>
      <column hidden="0" name="elevation" width="-1" type="field"/>
      <column hidden="0" name="depth" width="-1" type="field"/>
      <column hidden="0" name="connec_type" width="-1" type="field"/>
      <column hidden="0" name="sys_type" width="-1" type="field"/>
      <column hidden="0" name="connecat_id" width="-1" type="field"/>
      <column hidden="0" name="expl_id" width="-1" type="field"/>
      <column hidden="1" name="macroexpl_id" width="-1" type="field"/>
      <column hidden="0" name="sector_id" width="-1" type="field"/>
      <column hidden="0" name="macrosector_id" width="-1" type="field"/>
      <column hidden="0" name="customer_code" width="-1" type="field"/>
      <column hidden="0" name="cat_matcat_id" width="-1" type="field"/>
      <column hidden="0" name="cat_pnom" width="-1" type="field"/>
      <column hidden="0" name="cat_dnom" width="-1" type="field"/>
      <column hidden="1" name="connec_length" width="-1" type="field"/>
      <column hidden="0" name="state" width="-1" type="field"/>
      <column hidden="0" name="state_type" width="-1" type="field"/>
      <column hidden="0" name="n_hydrometer" width="-1" type="field"/>
      <column hidden="0" name="arc_id" width="-1" type="field"/>
      <column hidden="0" name="annotation" width="-1" type="field"/>
      <column hidden="0" name="observ" width="-1" type="field"/>
      <column hidden="0" name="comment" width="-1" type="field"/>
      <column hidden="0" name="minsector_id" width="-1" type="field"/>
      <column hidden="0" name="dma_id" width="-1" type="field"/>
      <column hidden="1" name="macrodma_id" width="-1" type="field"/>
      <column hidden="0" name="presszone_id" width="-1" type="field"/>
      <column hidden="0" name="staticpressure" width="-1" type="field"/>
      <column hidden="0" name="dqa_id" width="-1" type="field"/>
      <column hidden="0" name="macrodqa_id" width="-1" type="field"/>
      <column hidden="0" name="soilcat_id" width="-1" type="field"/>
      <column hidden="0" name="function_type" width="-1" type="field"/>
      <column hidden="0" name="category_type" width="-1" type="field"/>
      <column hidden="0" name="fluid_type" width="-1" type="field"/>
      <column hidden="0" name="location_type" width="-1" type="field"/>
      <column hidden="0" name="workcat_id" width="-1" type="field"/>
      <column hidden="0" name="workcat_id_end" width="-1" type="field"/>
      <column hidden="0" name="buildercat_id" width="-1" type="field"/>
      <column hidden="0" name="builtdate" width="-1" type="field"/>
      <column hidden="0" name="enddate" width="-1" type="field"/>
      <column hidden="0" name="ownercat_id" width="-1" type="field"/>
      <column hidden="0" name="muni_id" width="-1" type="field"/>
      <column hidden="0" name="postcode" width="-1" type="field"/>
      <column hidden="1" name="district_id" width="-1" type="field"/>
      <column hidden="0" name="streetname" width="-1" type="field"/>
      <column hidden="0" name="postnumber" width="-1" type="field"/>
      <column hidden="0" name="postcomplement" width="-1" type="field"/>
      <column hidden="0" name="streetname2" width="-1" type="field"/>
      <column hidden="0" name="postnumber2" width="-1" type="field"/>
      <column hidden="0" name="postcomplement2" width="-1" type="field"/>
      <column hidden="0" name="descript" width="-1" type="field"/>
      <column hidden="0" name="svg" width="-1" type="field"/>
      <column hidden="0" name="rotation" width="-1" type="field"/>
      <column hidden="0" name="link" width="-1" type="field"/>
      <column hidden="0" name="verified" width="-1" type="field"/>
      <column hidden="0" name="undelete" width="-1" type="field"/>
      <column hidden="0" name="label" width="-1" type="field"/>
      <column hidden="0" name="label_x" width="-1" type="field"/>
      <column hidden="0" name="label_y" width="-1" type="field"/>
      <column hidden="0" name="label_rotation" width="-1" type="field"/>
      <column hidden="1" name="publish" width="-1" type="field"/>
      <column hidden="1" name="inventory" width="-1" type="field"/>
      <column hidden="0" name="num_value" width="-1" type="field"/>
      <column hidden="1" name="connectype_id" width="-1" type="field"/>
      <column hidden="0" name="pjoint_id" width="-1" type="field"/>
      <column hidden="0" name="pjoint_type" width="-1" type="field"/>
      <column hidden="1" name="tstamp" width="-1" type="field"/>
      <column hidden="0" name="insert_user" width="-1" type="field"/>
      <column hidden="1" name="lastupdate" width="-1" type="field"/>
      <column hidden="1" name="lastupdate_user" width="-1" type="field"/>
      <column hidden="1" width="-1" type="actions"/>
      <column hidden="1" name="sector_name" width="-1" type="field"/>
      <column hidden="1" name="dma_name" width="-1" type="field"/>
      <column hidden="1" name="presszone_name" width="-1" type="field"/>
      <column hidden="1" name="dqa_name" width="-1" type="field"/>
      <column hidden="1" name="adate" width="-1" type="field"/>
      <column hidden="1" name="adescript" width="-1" type="field"/>
      <column hidden="1" name="accessibility" width="-1" type="field"/>
      <column hidden="0" name="workcat_id_plan" width="-1" type="field"/>
      <column hidden="0" name="asset_id" width="-1" type="field"/>
      <column hidden="1" name="dma_style" width="-1" type="field"/>
      <column hidden="1" name="presszone_style" width="-1" type="field"/>
      <column hidden="0" name="priority" width="-1" type="field"/>
      <column hidden="0" name="valve_location" width="-1" type="field"/>
      <column hidden="0" name="valve_type" width="-1" type="field"/>
      <column hidden="0" name="shutoff_valve" width="-1" type="field"/>
      <column hidden="0" name="access_type" width="-1" type="field"/>
      <column hidden="0" name="placement_type" width="-1" type="field"/>
      <column hidden="0" name="press_max" width="-1" type="field"/>
      <column hidden="0" name="press_min" width="-1" type="field"/>
      <column hidden="0" name="press_avg" width="-1" type="field"/>
      <column hidden="0" name="demand" width="-1" type="field"/>
      <column hidden="0" name="om_state" width="-1" type="field"/>
      <column hidden="0" name="conserv_state" width="-1" type="field"/>
      <column hidden="0" name="crmzone_id" width="-1" type="field"/>
      <column hidden="0" name="crmzone_name" width="-1" type="field"/>
      <column hidden="0" name="expl_id2" width="-1" type="field"/>
      <column hidden="0" name="quality_max" width="-1" type="field"/>
      <column hidden="0" name="quality_min" width="-1" type="field"/>
      <column hidden="0" name="quality_avg" width="-1" type="field"/>
      <column hidden="0" name="is_operative" width="-1" type="field"/>
      <column hidden="0" name="region_id" width="-1" type="field"/>
      <column hidden="0" name="province_id" width="-1" type="field"/>
      <column hidden="0" name="epa_type" width="-1" type="field"/>
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
    <field name="access_type" editable="1"/>
    <field name="accessibility" editable="0"/>
    <field name="adate" editable="0"/>
    <field name="adescript" editable="0"/>
    <field name="annotation" editable="0"/>
    <field name="arc_id" editable="0"/>
    <field name="asset_id" editable="0"/>
    <field name="buildercat_id" editable="0"/>
    <field name="builtdate" editable="0"/>
    <field name="cat_dnom" editable="0"/>
    <field name="cat_matcat_id" editable="0"/>
    <field name="cat_pnom" editable="0"/>
    <field name="category_type" editable="0"/>
    <field name="code" editable="0"/>
    <field name="comment" editable="0"/>
    <field name="connec_id" editable="0"/>
    <field name="connec_length" editable="0"/>
    <field name="connec_type" editable="0"/>
    <field name="connecat_id" editable="0"/>
    <field name="connectype_id" editable="0"/>
    <field name="conserv_state" editable="1"/>
    <field name="crmzone_id" editable="1"/>
    <field name="crmzone_name" editable="1"/>
    <field name="customer_code" editable="0"/>
    <field name="demand" editable="1"/>
    <field name="depth" editable="0"/>
    <field name="descript" editable="0"/>
    <field name="district_id" editable="0"/>
    <field name="dma_id" editable="0"/>
    <field name="dma_name" editable="0"/>
    <field name="dma_style" editable="0"/>
    <field name="dqa_id" editable="0"/>
    <field name="dqa_name" editable="0"/>
    <field name="elevation" editable="0"/>
    <field name="enddate" editable="0"/>
    <field name="epa_type" editable="1"/>
    <field name="expl_id" editable="0"/>
    <field name="expl_id2" editable="0"/>
    <field name="feature_id" editable="1"/>
    <field name="featurecat_id" editable="1"/>
    <field name="fluid_type" editable="0"/>
    <field name="function_type" editable="0"/>
    <field name="insert_user" editable="1"/>
    <field name="inventory" editable="0"/>
    <field name="is_operative" editable="1"/>
    <field name="label" editable="0"/>
    <field name="label_rotation" editable="0"/>
    <field name="label_x" editable="0"/>
    <field name="label_y" editable="0"/>
    <field name="lastupdate" editable="0"/>
    <field name="lastupdate_user" editable="0"/>
    <field name="link" editable="0"/>
    <field name="location_type" editable="0"/>
    <field name="macrodma_id" editable="0"/>
    <field name="macrodqa_id" editable="0"/>
    <field name="macroexpl_id" editable="0"/>
    <field name="macrosector_id" editable="0"/>
    <field name="minsector_id" editable="0"/>
    <field name="muni_id" editable="0"/>
    <field name="n_hydrometer" editable="0"/>
    <field name="num_value" editable="0"/>
    <field name="observ" editable="0"/>
    <field name="om_state" editable="1"/>
    <field name="ownercat_id" editable="0"/>
    <field name="pjoint_id" editable="0"/>
    <field name="pjoint_type" editable="0"/>
    <field name="placement_type" editable="1"/>
    <field name="postcode" editable="0"/>
    <field name="postcomplement" editable="0"/>
    <field name="postcomplement2" editable="0"/>
    <field name="postnumber" editable="0"/>
    <field name="postnumber2" editable="0"/>
    <field name="press_avg" editable="1"/>
    <field name="press_max" editable="1"/>
    <field name="press_min" editable="1"/>
    <field name="presszone_id" editable="0"/>
    <field name="presszone_name" editable="0"/>
    <field name="presszone_style" editable="0"/>
    <field name="priority" editable="1"/>
    <field name="province_id" editable="0"/>
    <field name="publish" editable="0"/>
    <field name="quality_avg" editable="1"/>
    <field name="quality_max" editable="1"/>
    <field name="quality_min" editable="1"/>
    <field name="region_id" editable="0"/>
    <field name="rotation" editable="0"/>
    <field name="sector_id" editable="0"/>
    <field name="sector_name" editable="0"/>
    <field name="shutoff_valve" editable="1"/>
    <field name="soilcat_id" editable="0"/>
    <field name="state" editable="0"/>
    <field name="state_type" editable="0"/>
    <field name="staticpressure" editable="0"/>
    <field name="streetname" editable="0"/>
    <field name="streetname2" editable="0"/>
    <field name="svg" editable="0"/>
    <field name="sys_type" editable="0"/>
    <field name="tstamp" editable="0"/>
    <field name="undelete" editable="0"/>
    <field name="valve_location" editable="1"/>
    <field name="valve_type" editable="1"/>
    <field name="verified" editable="0"/>
    <field name="workcat_id" editable="0"/>
    <field name="workcat_id_end" editable="0"/>
    <field name="workcat_id_plan" editable="0"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="access_type"/>
    <field labelOnTop="0" name="accessibility"/>
    <field labelOnTop="0" name="adate"/>
    <field labelOnTop="0" name="adescript"/>
    <field labelOnTop="0" name="annotation"/>
    <field labelOnTop="0" name="arc_id"/>
    <field labelOnTop="0" name="asset_id"/>
    <field labelOnTop="0" name="buildercat_id"/>
    <field labelOnTop="0" name="builtdate"/>
    <field labelOnTop="0" name="cat_dnom"/>
    <field labelOnTop="0" name="cat_matcat_id"/>
    <field labelOnTop="0" name="cat_pnom"/>
    <field labelOnTop="0" name="category_type"/>
    <field labelOnTop="0" name="code"/>
    <field labelOnTop="0" name="comment"/>
    <field labelOnTop="0" name="connec_id"/>
    <field labelOnTop="0" name="connec_length"/>
    <field labelOnTop="0" name="connec_type"/>
    <field labelOnTop="0" name="connecat_id"/>
    <field labelOnTop="0" name="connectype_id"/>
    <field labelOnTop="0" name="conserv_state"/>
    <field labelOnTop="0" name="crmzone_id"/>
    <field labelOnTop="0" name="crmzone_name"/>
    <field labelOnTop="0" name="customer_code"/>
    <field labelOnTop="0" name="demand"/>
    <field labelOnTop="0" name="depth"/>
    <field labelOnTop="0" name="descript"/>
    <field labelOnTop="0" name="district_id"/>
    <field labelOnTop="0" name="dma_id"/>
    <field labelOnTop="0" name="dma_name"/>
    <field labelOnTop="0" name="dma_style"/>
    <field labelOnTop="0" name="dqa_id"/>
    <field labelOnTop="0" name="dqa_name"/>
    <field labelOnTop="0" name="elevation"/>
    <field labelOnTop="0" name="enddate"/>
    <field labelOnTop="0" name="epa_type"/>
    <field labelOnTop="0" name="expl_id"/>
    <field labelOnTop="0" name="expl_id2"/>
    <field labelOnTop="0" name="feature_id"/>
    <field labelOnTop="0" name="featurecat_id"/>
    <field labelOnTop="0" name="fluid_type"/>
    <field labelOnTop="0" name="function_type"/>
    <field labelOnTop="0" name="insert_user"/>
    <field labelOnTop="0" name="inventory"/>
    <field labelOnTop="0" name="is_operative"/>
    <field labelOnTop="0" name="label"/>
    <field labelOnTop="0" name="label_rotation"/>
    <field labelOnTop="0" name="label_x"/>
    <field labelOnTop="0" name="label_y"/>
    <field labelOnTop="0" name="lastupdate"/>
    <field labelOnTop="0" name="lastupdate_user"/>
    <field labelOnTop="0" name="link"/>
    <field labelOnTop="0" name="location_type"/>
    <field labelOnTop="0" name="macrodma_id"/>
    <field labelOnTop="0" name="macrodqa_id"/>
    <field labelOnTop="0" name="macroexpl_id"/>
    <field labelOnTop="0" name="macrosector_id"/>
    <field labelOnTop="0" name="minsector_id"/>
    <field labelOnTop="0" name="muni_id"/>
    <field labelOnTop="0" name="n_hydrometer"/>
    <field labelOnTop="0" name="num_value"/>
    <field labelOnTop="0" name="observ"/>
    <field labelOnTop="0" name="om_state"/>
    <field labelOnTop="0" name="ownercat_id"/>
    <field labelOnTop="0" name="pjoint_id"/>
    <field labelOnTop="0" name="pjoint_type"/>
    <field labelOnTop="0" name="placement_type"/>
    <field labelOnTop="0" name="postcode"/>
    <field labelOnTop="0" name="postcomplement"/>
    <field labelOnTop="0" name="postcomplement2"/>
    <field labelOnTop="0" name="postnumber"/>
    <field labelOnTop="0" name="postnumber2"/>
    <field labelOnTop="0" name="press_avg"/>
    <field labelOnTop="0" name="press_max"/>
    <field labelOnTop="0" name="press_min"/>
    <field labelOnTop="0" name="presszone_id"/>
    <field labelOnTop="0" name="presszone_name"/>
    <field labelOnTop="0" name="presszone_style"/>
    <field labelOnTop="0" name="priority"/>
    <field labelOnTop="0" name="province_id"/>
    <field labelOnTop="0" name="publish"/>
    <field labelOnTop="0" name="quality_avg"/>
    <field labelOnTop="0" name="quality_max"/>
    <field labelOnTop="0" name="quality_min"/>
    <field labelOnTop="0" name="region_id"/>
    <field labelOnTop="0" name="rotation"/>
    <field labelOnTop="0" name="sector_id"/>
    <field labelOnTop="0" name="sector_name"/>
    <field labelOnTop="0" name="shutoff_valve"/>
    <field labelOnTop="0" name="soilcat_id"/>
    <field labelOnTop="0" name="state"/>
    <field labelOnTop="0" name="state_type"/>
    <field labelOnTop="0" name="staticpressure"/>
    <field labelOnTop="0" name="streetname"/>
    <field labelOnTop="0" name="streetname2"/>
    <field labelOnTop="0" name="svg"/>
    <field labelOnTop="0" name="sys_type"/>
    <field labelOnTop="0" name="tstamp"/>
    <field labelOnTop="0" name="undelete"/>
    <field labelOnTop="0" name="valve_location"/>
    <field labelOnTop="0" name="valve_type"/>
    <field labelOnTop="0" name="verified"/>
    <field labelOnTop="0" name="workcat_id"/>
    <field labelOnTop="0" name="workcat_id_end"/>
    <field labelOnTop="0" name="workcat_id_plan"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="access_type" reuseLastValue="0"/>
    <field name="accessibility" reuseLastValue="0"/>
    <field name="adate" reuseLastValue="0"/>
    <field name="adescript" reuseLastValue="0"/>
    <field name="annotation" reuseLastValue="0"/>
    <field name="arc_id" reuseLastValue="0"/>
    <field name="asset_id" reuseLastValue="0"/>
    <field name="buildercat_id" reuseLastValue="0"/>
    <field name="builtdate" reuseLastValue="0"/>
    <field name="cat_dnom" reuseLastValue="0"/>
    <field name="cat_matcat_id" reuseLastValue="0"/>
    <field name="cat_pnom" reuseLastValue="0"/>
    <field name="category_type" reuseLastValue="0"/>
    <field name="code" reuseLastValue="0"/>
    <field name="comment" reuseLastValue="0"/>
    <field name="connec_id" reuseLastValue="0"/>
    <field name="connec_length" reuseLastValue="0"/>
    <field name="connec_type" reuseLastValue="0"/>
    <field name="connecat_id" reuseLastValue="0"/>
    <field name="connectype_id" reuseLastValue="0"/>
    <field name="conserv_state" reuseLastValue="0"/>
    <field name="crmzone_id" reuseLastValue="0"/>
    <field name="crmzone_name" reuseLastValue="0"/>
    <field name="customer_code" reuseLastValue="0"/>
    <field name="demand" reuseLastValue="0"/>
    <field name="depth" reuseLastValue="0"/>
    <field name="descript" reuseLastValue="0"/>
    <field name="district_id" reuseLastValue="0"/>
    <field name="dma_id" reuseLastValue="0"/>
    <field name="dma_name" reuseLastValue="0"/>
    <field name="dma_style" reuseLastValue="0"/>
    <field name="dqa_id" reuseLastValue="0"/>
    <field name="dqa_name" reuseLastValue="0"/>
    <field name="elevation" reuseLastValue="0"/>
    <field name="enddate" reuseLastValue="0"/>
    <field name="epa_type" reuseLastValue="0"/>
    <field name="expl_id" reuseLastValue="0"/>
    <field name="expl_id2" reuseLastValue="0"/>
    <field name="fluid_type" reuseLastValue="0"/>
    <field name="function_type" reuseLastValue="0"/>
    <field name="insert_user" reuseLastValue="0"/>
    <field name="inventory" reuseLastValue="0"/>
    <field name="is_operative" reuseLastValue="0"/>
    <field name="label" reuseLastValue="0"/>
    <field name="label_rotation" reuseLastValue="0"/>
    <field name="label_x" reuseLastValue="0"/>
    <field name="label_y" reuseLastValue="0"/>
    <field name="lastupdate" reuseLastValue="0"/>
    <field name="lastupdate_user" reuseLastValue="0"/>
    <field name="link" reuseLastValue="0"/>
    <field name="location_type" reuseLastValue="0"/>
    <field name="macrodma_id" reuseLastValue="0"/>
    <field name="macrodqa_id" reuseLastValue="0"/>
    <field name="macroexpl_id" reuseLastValue="0"/>
    <field name="macrosector_id" reuseLastValue="0"/>
    <field name="minsector_id" reuseLastValue="0"/>
    <field name="muni_id" reuseLastValue="0"/>
    <field name="n_hydrometer" reuseLastValue="0"/>
    <field name="num_value" reuseLastValue="0"/>
    <field name="observ" reuseLastValue="0"/>
    <field name="om_state" reuseLastValue="0"/>
    <field name="ownercat_id" reuseLastValue="0"/>
    <field name="pjoint_id" reuseLastValue="0"/>
    <field name="pjoint_type" reuseLastValue="0"/>
    <field name="placement_type" reuseLastValue="0"/>
    <field name="postcode" reuseLastValue="0"/>
    <field name="postcomplement" reuseLastValue="0"/>
    <field name="postcomplement2" reuseLastValue="0"/>
    <field name="postnumber" reuseLastValue="0"/>
    <field name="postnumber2" reuseLastValue="0"/>
    <field name="press_avg" reuseLastValue="0"/>
    <field name="press_max" reuseLastValue="0"/>
    <field name="press_min" reuseLastValue="0"/>
    <field name="presszone_id" reuseLastValue="0"/>
    <field name="presszone_name" reuseLastValue="0"/>
    <field name="presszone_style" reuseLastValue="0"/>
    <field name="priority" reuseLastValue="0"/>
    <field name="province_id" reuseLastValue="0"/>
    <field name="publish" reuseLastValue="0"/>
    <field name="quality_avg" reuseLastValue="0"/>
    <field name="quality_max" reuseLastValue="0"/>
    <field name="quality_min" reuseLastValue="0"/>
    <field name="region_id" reuseLastValue="0"/>
    <field name="rotation" reuseLastValue="0"/>
    <field name="sector_id" reuseLastValue="0"/>
    <field name="sector_name" reuseLastValue="0"/>
    <field name="shutoff_valve" reuseLastValue="0"/>
    <field name="soilcat_id" reuseLastValue="0"/>
    <field name="state" reuseLastValue="0"/>
    <field name="state_type" reuseLastValue="0"/>
    <field name="staticpressure" reuseLastValue="0"/>
    <field name="streetname" reuseLastValue="0"/>
    <field name="streetname2" reuseLastValue="0"/>
    <field name="svg" reuseLastValue="0"/>
    <field name="sys_type" reuseLastValue="0"/>
    <field name="tstamp" reuseLastValue="0"/>
    <field name="undelete" reuseLastValue="0"/>
    <field name="valve_location" reuseLastValue="0"/>
    <field name="valve_type" reuseLastValue="0"/>
    <field name="verified" reuseLastValue="0"/>
    <field name="workcat_id" reuseLastValue="0"/>
    <field name="workcat_id_end" reuseLastValue="0"/>
    <field name="workcat_id_plan" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"connec_id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
'
WHERE id = 202;

UPDATE sys_style SET stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis minScale="2500" simplifyMaxScale="1" styleCategories="AllStyleCategories" readOnly="0" simplifyAlgorithm="0" symbologyReferenceScale="-1" maxScale="1" labelsEnabled="0" simplifyDrawingTol="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" simplifyDrawingHints="1" version="3.22.4-Białowieża">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal mode="0" enabled="0" fixedDuration="0" startField="" startExpression="" accumulate="0" limitMode="0" endField="" endExpression="" durationUnit="min" durationField="">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 referencescale="-1" symbollevels="0" forceraster="0" enableorderby="0" type="singleSymbol">
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="line" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleLine">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="5,163,242,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.46" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <prop k="align_dash_pattern" v="0"/>
          <prop k="capstyle" v="square"/>
          <prop k="customdash" v="5;2"/>
          <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="customdash_unit" v="MM"/>
          <prop k="dash_pattern_offset" v="0"/>
          <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="dash_pattern_offset_unit" v="MM"/>
          <prop k="draw_inside_polygon" v="0"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="line_color" v="5,163,242,255"/>
          <prop k="line_style" v="solid"/>
          <prop k="line_width" v="0.46"/>
          <prop k="line_width_unit" v="MM"/>
          <prop k="offset" v="0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="ring_filter" v="0"/>
          <prop k="trim_distance_end" v="0"/>
          <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_end_unit" v="MM"/>
          <prop k="trim_distance_start" v="0"/>
          <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="trim_distance_start_unit" v="MM"/>
          <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
        <layer locked="0" enabled="1" pass="0" class="GeometryGenerator">
          <Option type="Map">
            <Option value="Marker" name="SymbolType" type="QString"/>
            <Option value="end_point ($geometry)" name="geometryModifier" type="QString"/>
            <Option value="MapUnit" name="units" type="QString"/>
          </Option>
          <prop k="SymbolType" v="Marker"/>
          <prop k="geometryModifier" v="end_point ($geometry)"/>
          <prop k="units" v="MapUnit"/>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <symbol force_rhr="0" name="@0@1" clip_to_extent="1" type="marker" alpha="1">
            <data_defined_properties>
              <Option type="Map">
                <Option value="" name="name" type="QString"/>
                <Option name="properties"/>
                <Option value="collection" name="type" type="QString"/>
              </Option>
            </data_defined_properties>
            <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
              <Option type="Map">
                <Option value="0" name="angle" type="QString"/>
                <Option value="square" name="cap_style" type="QString"/>
                <Option value="5,163,242,255" name="color" type="QString"/>
                <Option value="1" name="horizontal_anchor_point" type="QString"/>
                <Option value="bevel" name="joinstyle" type="QString"/>
                <Option value="circle" name="name" type="QString"/>
                <Option value="0,0" name="offset" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
                <Option value="MM" name="offset_unit" type="QString"/>
                <Option value="50,87,128,255" name="outline_color" type="QString"/>
                <Option value="solid" name="outline_style" type="QString"/>
                <Option value="0.4" name="outline_width" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
                <Option value="MM" name="outline_width_unit" type="QString"/>
                <Option value="diameter" name="scale_method" type="QString"/>
                <Option value="1" name="size" type="QString"/>
                <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
                <Option value="MM" name="size_unit" type="QString"/>
                <Option value="1" name="vertical_anchor_point" type="QString"/>
              </Option>
              <prop k="angle" v="0"/>
              <prop k="cap_style" v="square"/>
              <prop k="color" v="5,163,242,255"/>
              <prop k="horizontal_anchor_point" v="1"/>
              <prop k="joinstyle" v="bevel"/>
              <prop k="name" v="circle"/>
              <prop k="offset" v="0,0"/>
              <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="offset_unit" v="MM"/>
              <prop k="outline_color" v="50,87,128,255"/>
              <prop k="outline_style" v="solid"/>
              <prop k="outline_width" v="0.4"/>
              <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
              <prop k="outline_width_unit" v="MM"/>
              <prop k="scale_method" v="diameter"/>
              <prop k="size" v="1"/>
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
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <customproperties>
    <Option type="Map">
      <Option value="0" name="embeddedWidgets/count" type="QString"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Pie">
    <DiagramCategory lineSizeType="MM" spacing="0" penColor="#000000" diagramOrientation="Up" penAlpha="255" opacity="1" scaleDependency="Area" direction="1" barWidth="5" labelPlacementMethod="XHeight" minScaleDenominator="1" backgroundColor="#ffffff" width="15" rotationOffset="270" lineSizeScale="3x:0,0,0,0,0,0" backgroundAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" sizeScale="3x:0,0,0,0,0,0" showAxis="0" maxScaleDenominator="1e+08" enabled="0" minimumSize="0" height="15" sizeType="MM" spacingUnit="MM" penWidth="0" scaleBasedVisibility="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute field="" color="#000000" label=""/>
      <axisSymbol>
        <symbol force_rhr="0" name="" clip_to_extent="1" type="line" alpha="1">
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" pass="0" class="SimpleLine">
            <Option type="Map">
              <Option value="0" name="align_dash_pattern" type="QString"/>
              <Option value="square" name="capstyle" type="QString"/>
              <Option value="5;2" name="customdash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
              <Option value="MM" name="customdash_unit" type="QString"/>
              <Option value="0" name="dash_pattern_offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
              <Option value="0" name="draw_inside_polygon" type="QString"/>
              <Option value="bevel" name="joinstyle" type="QString"/>
              <Option value="35,35,35,255" name="line_color" type="QString"/>
              <Option value="solid" name="line_style" type="QString"/>
              <Option value="0.26" name="line_width" type="QString"/>
              <Option value="MM" name="line_width_unit" type="QString"/>
              <Option value="0" name="offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="offset_unit" type="QString"/>
              <Option value="0" name="ring_filter" type="QString"/>
              <Option value="0" name="trim_distance_end" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_end_unit" type="QString"/>
              <Option value="0" name="trim_distance_start" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_start_unit" type="QString"/>
              <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
              <Option value="0" name="use_custom_dash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
            </Option>
            <prop k="align_dash_pattern" v="0"/>
            <prop k="capstyle" v="square"/>
            <prop k="customdash" v="5;2"/>
            <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="customdash_unit" v="MM"/>
            <prop k="dash_pattern_offset" v="0"/>
            <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="dash_pattern_offset_unit" v="MM"/>
            <prop k="draw_inside_polygon" v="0"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="line_color" v="35,35,35,255"/>
            <prop k="line_style" v="solid"/>
            <prop k="line_width" v="0.26"/>
            <prop k="line_width_unit" v="MM"/>
            <prop k="offset" v="0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="ring_filter" v="0"/>
            <prop k="trim_distance_end" v="0"/>
            <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_end_unit" v="MM"/>
            <prop k="trim_distance_start" v="0"/>
            <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_start_unit" v="MM"/>
            <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" priority="0" obstacle="0" zIndex="0" dist="0" linePlacementFlags="2" placement="2">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties" type="Map">
          <Option name="show" type="Map">
            <Option value="true" name="active" type="bool"/>
            <Option value="link_id" name="field" type="QString"/>
            <Option value="2" name="type" type="int"/>
          </Option>
        </Option>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field name="link_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="ARC" name="ARC" type="QString"/>
              <Option value="CONNEC" name="CONNEC" type="QString"/>
              <Option value="ELEMENT" name="ELEMENT" type="QString"/>
              <Option value="LINK" name="LINK" type="QString"/>
              <Option value="NODE" name="NODE" type="QString"/>
              <Option value="VNODE" name="VNODE" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="feature_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="ARC" name="ARC" type="QString"/>
              <Option value="CONNEC" name="CONNEC" type="QString"/>
              <Option value="NODE" name="NODE" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="OBSOLETE" type="QString"/>
              <Option value="1" name="OPERATIVE" type="QString"/>
              <Option value="2" name="PLANIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="expl_id" name="Key" type="QString"/>
            <Option value="v_edit_exploitation_fd06cc08_9e9d_4a22_bfca_586b3919d086" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="sector_id" name="Key" type="QString"/>
            <Option value="v_edit_sector20171204170540567" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dma_id" name="Key" type="QString"/>
            <Option value="v_edit_dma20190515092620863" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="minsector_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_topelev" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="exit_elev" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="gis_length" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
              <Option value="1" name="macrosector_01" type="QString"/>
              <Option value="2" name="macrosector_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id2" configurationFlags="None">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="epa_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="is_operative" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="link_id" field="link_id"/>
    <alias index="1" name="feature_type" field="feature_type"/>
    <alias index="2" name="feature_id" field="feature_id"/>
    <alias index="3" name="exit_type" field="exit_type"/>
    <alias index="4" name="exit_id" field="exit_id"/>
    <alias index="5" name="state" field="state"/>
    <alias index="6" name="expl_id" field="expl_id"/>
    <alias index="7" name="sector_id" field="sector_id"/>
    <alias index="8" name="dma_id" field="dma_id"/>
    <alias index="9" name="Presszone" field="presszone_id"/>
    <alias index="10" name="Dqa" field="dqa_id"/>
    <alias index="11" name="minsector_id" field="minsector_id"/>
    <alias index="12" name="exit_topelev" field="exit_topelev"/>
    <alias index="13" name="exit_elev" field="exit_elev"/>
    <alias index="14" name="fluid_type" field="fluid_type"/>
    <alias index="15" name="gis_length" field="gis_length"/>
    <alias index="16" name="sector_name" field="sector_name"/>
    <alias index="17" name="dma_name" field="dma_name"/>
    <alias index="18" name="dqa_name" field="dqa_name"/>
    <alias index="19" name="presszone_name" field="presszone_name"/>
    <alias index="20" name="macrosector_id" field="macrosector_id"/>
    <alias index="21" name="macrodma_id" field="macrodma_id"/>
    <alias index="22" name="macrodqa_id" field="macrodqa_id"/>
    <alias index="23" name="" field="expl_id2"/>
    <alias index="24" name="epa_type" field="epa_type"/>
    <alias index="25" name="is_operative" field="is_operative"/>
  </aliases>
  <defaults>
    <default expression="" field="link_id" applyOnUpdate="0"/>
    <default expression="" field="feature_type" applyOnUpdate="0"/>
    <default expression="" field="feature_id" applyOnUpdate="0"/>
    <default expression="" field="exit_type" applyOnUpdate="0"/>
    <default expression="" field="exit_id" applyOnUpdate="0"/>
    <default expression="" field="state" applyOnUpdate="0"/>
    <default expression="" field="expl_id" applyOnUpdate="0"/>
    <default expression="" field="sector_id" applyOnUpdate="0"/>
    <default expression="" field="dma_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_id" applyOnUpdate="0"/>
    <default expression="" field="dqa_id" applyOnUpdate="0"/>
    <default expression="" field="minsector_id" applyOnUpdate="0"/>
    <default expression="" field="exit_topelev" applyOnUpdate="0"/>
    <default expression="" field="exit_elev" applyOnUpdate="0"/>
    <default expression="" field="fluid_type" applyOnUpdate="0"/>
    <default expression="" field="gis_length" applyOnUpdate="0"/>
    <default expression="" field="sector_name" applyOnUpdate="0"/>
    <default expression="" field="dma_name" applyOnUpdate="0"/>
    <default expression="" field="dqa_name" applyOnUpdate="0"/>
    <default expression="" field="presszone_name" applyOnUpdate="0"/>
    <default expression="" field="macrosector_id" applyOnUpdate="0"/>
    <default expression="" field="macrodma_id" applyOnUpdate="0"/>
    <default expression="" field="macrodqa_id" applyOnUpdate="0"/>
    <default expression="" field="expl_id2" applyOnUpdate="0"/>
    <default expression="" field="epa_type" applyOnUpdate="0"/>
    <default expression="" field="is_operative" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" notnull_strength="2" field="link_id" constraints="3" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="feature_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="feature_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="exit_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="exit_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="minsector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="exit_topelev" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="exit_elev" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="fluid_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="gis_length" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrosector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="expl_id2" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="epa_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="is_operative" constraints="1" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" field="link_id" exp=""/>
    <constraint desc="" field="feature_type" exp=""/>
    <constraint desc="" field="feature_id" exp=""/>
    <constraint desc="" field="exit_type" exp=""/>
    <constraint desc="" field="exit_id" exp=""/>
    <constraint desc="" field="state" exp=""/>
    <constraint desc="" field="expl_id" exp=""/>
    <constraint desc="" field="sector_id" exp=""/>
    <constraint desc="" field="dma_id" exp=""/>
    <constraint desc="" field="presszone_id" exp=""/>
    <constraint desc="" field="dqa_id" exp=""/>
    <constraint desc="" field="minsector_id" exp=""/>
    <constraint desc="" field="exit_topelev" exp=""/>
    <constraint desc="" field="exit_elev" exp=""/>
    <constraint desc="" field="fluid_type" exp=""/>
    <constraint desc="" field="gis_length" exp=""/>
    <constraint desc="" field="sector_name" exp=""/>
    <constraint desc="" field="dma_name" exp=""/>
    <constraint desc="" field="dqa_name" exp=""/>
    <constraint desc="" field="presszone_name" exp=""/>
    <constraint desc="" field="macrosector_id" exp=""/>
    <constraint desc="" field="macrodma_id" exp=""/>
    <constraint desc="" field="macrodqa_id" exp=""/>
    <constraint desc="" field="expl_id2" exp=""/>
    <constraint desc="" field="epa_type" exp=""/>
    <constraint desc="" field="is_operative" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="1" sortExpression="&quot;sector_id&quot;">
    <columns>
      <column hidden="0" name="link_id" width="-1" type="field"/>
      <column hidden="0" name="feature_type" width="-1" type="field"/>
      <column hidden="0" name="feature_id" width="-1" type="field"/>
      <column hidden="0" name="exit_type" width="-1" type="field"/>
      <column hidden="0" name="exit_id" width="-1" type="field"/>
      <column hidden="0" name="sector_id" width="-1" type="field"/>
      <column hidden="0" name="dma_id" width="-1" type="field"/>
      <column hidden="0" name="expl_id" width="-1" type="field"/>
      <column hidden="0" name="state" width="-1" type="field"/>
      <column hidden="0" name="gis_length" width="-1" type="field"/>
      <column hidden="1" width="-1" type="actions"/>
      <column hidden="0" name="macrosector_id" width="-1" type="field"/>
      <column hidden="1" name="macrodma_id" width="-1" type="field"/>
      <column hidden="0" name="presszone_id" width="-1" type="field"/>
      <column hidden="0" name="dqa_id" width="-1" type="field"/>
      <column hidden="0" name="minsector_id" width="-1" type="field"/>
      <column hidden="0" name="exit_topelev" width="-1" type="field"/>
      <column hidden="0" name="exit_elev" width="-1" type="field"/>
      <column hidden="0" name="sector_name" width="-1" type="field"/>
      <column hidden="0" name="dma_name" width="-1" type="field"/>
      <column hidden="0" name="dqa_name" width="-1" type="field"/>
      <column hidden="0" name="presszone_name" width="-1" type="field"/>
      <column hidden="0" name="macrodqa_id" width="-1" type="field"/>
      <column hidden="0" name="expl_id2" width="-1" type="field"/>
      <column hidden="0" name="epa_type" width="-1" type="field"/>
      <column hidden="0" name="is_operative" width="-1" type="field"/>
      <column hidden="0" name="fluid_type" width="-1" type="field"/>
    </columns>
  </attributetableconfig>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <storedexpressions/>
  <editform tolerant="1">C:/Users/user</editform>
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
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field name="dma_id" editable="0"/>
    <field name="dma_name" editable="0"/>
    <field name="dqa_id" editable="0"/>
    <field name="dqa_name" editable="0"/>
    <field name="epa_type" editable="0"/>
    <field name="exit_elev" editable="0"/>
    <field name="exit_id" editable="0"/>
    <field name="exit_topelev" editable="0"/>
    <field name="exit_type" editable="0"/>
    <field name="expl_id" editable="0"/>
    <field name="expl_id2" editable="1"/>
    <field name="feature_id" editable="0"/>
    <field name="feature_type" editable="0"/>
    <field name="fluid_type" editable="0"/>
    <field name="gis_length" editable="0"/>
    <field name="is_operative" editable="0"/>
    <field name="ispsectorgeom" editable="1"/>
    <field name="link_class" editable="1"/>
    <field name="link_id" editable="0"/>
    <field name="macrodma_id" editable="0"/>
    <field name="macrodqa_id" editable="0"/>
    <field name="macrosector_id" editable="0"/>
    <field name="minsector_id" editable="0"/>
    <field name="presszone_id" editable="0"/>
    <field name="presszone_name" editable="0"/>
    <field name="psector_rowid" editable="1"/>
    <field name="sector_id" editable="0"/>
    <field name="sector_name" editable="0"/>
    <field name="state" editable="1"/>
    <field name="userdefined_geom" editable="1"/>
    <field name="vnode_topelev" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="dma_id"/>
    <field labelOnTop="0" name="dma_name"/>
    <field labelOnTop="0" name="dqa_id"/>
    <field labelOnTop="0" name="dqa_name"/>
    <field labelOnTop="0" name="epa_type"/>
    <field labelOnTop="0" name="exit_elev"/>
    <field labelOnTop="0" name="exit_id"/>
    <field labelOnTop="0" name="exit_topelev"/>
    <field labelOnTop="0" name="exit_type"/>
    <field labelOnTop="0" name="expl_id"/>
    <field labelOnTop="0" name="expl_id2"/>
    <field labelOnTop="0" name="feature_id"/>
    <field labelOnTop="0" name="feature_type"/>
    <field labelOnTop="0" name="fluid_type"/>
    <field labelOnTop="0" name="gis_length"/>
    <field labelOnTop="0" name="is_operative"/>
    <field labelOnTop="0" name="ispsectorgeom"/>
    <field labelOnTop="0" name="link_class"/>
    <field labelOnTop="0" name="link_id"/>
    <field labelOnTop="0" name="macrodma_id"/>
    <field labelOnTop="0" name="macrodqa_id"/>
    <field labelOnTop="0" name="macrosector_id"/>
    <field labelOnTop="0" name="minsector_id"/>
    <field labelOnTop="0" name="presszone_id"/>
    <field labelOnTop="0" name="presszone_name"/>
    <field labelOnTop="0" name="psector_rowid"/>
    <field labelOnTop="0" name="sector_id"/>
    <field labelOnTop="0" name="sector_name"/>
    <field labelOnTop="0" name="state"/>
    <field labelOnTop="0" name="userdefined_geom"/>
    <field labelOnTop="0" name="vnode_topelev"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="dma_id" reuseLastValue="0"/>
    <field name="dma_name" reuseLastValue="0"/>
    <field name="dqa_id" reuseLastValue="0"/>
    <field name="dqa_name" reuseLastValue="0"/>
    <field name="epa_type" reuseLastValue="0"/>
    <field name="exit_elev" reuseLastValue="0"/>
    <field name="exit_id" reuseLastValue="0"/>
    <field name="exit_topelev" reuseLastValue="0"/>
    <field name="exit_type" reuseLastValue="0"/>
    <field name="expl_id" reuseLastValue="0"/>
    <field name="expl_id2" reuseLastValue="0"/>
    <field name="feature_id" reuseLastValue="0"/>
    <field name="feature_type" reuseLastValue="0"/>
    <field name="fluid_type" reuseLastValue="0"/>
    <field name="gis_length" reuseLastValue="0"/>
    <field name="is_operative" reuseLastValue="0"/>
    <field name="link_class" reuseLastValue="0"/>
    <field name="link_id" reuseLastValue="0"/>
    <field name="macrodma_id" reuseLastValue="0"/>
    <field name="macrodqa_id" reuseLastValue="0"/>
    <field name="macrosector_id" reuseLastValue="0"/>
    <field name="minsector_id" reuseLastValue="0"/>
    <field name="presszone_id" reuseLastValue="0"/>
    <field name="presszone_name" reuseLastValue="0"/>
    <field name="psector_rowid" reuseLastValue="0"/>
    <field name="sector_id" reuseLastValue="0"/>
    <field name="sector_name" reuseLastValue="0"/>
    <field name="state" reuseLastValue="0"/>
    <field name="userdefined_geom" reuseLastValue="0"/>
    <field name="vnode_topelev" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"link_id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>1</layerGeometryType>
</qgis>
'
WHERE id = 203;

UPDATE sys_style SET stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis minScale="100000000" simplifyMaxScale="1" styleCategories="AllStyleCategories" readOnly="0" simplifyAlgorithm="0" symbologyReferenceScale="-1" maxScale="0" labelsEnabled="0" simplifyDrawingTol="1" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" simplifyDrawingHints="0" version="3.22.4-Białowieża">
  <flags>
    <Identifiable>1</Identifiable>
    <Removable>1</Removable>
    <Searchable>1</Searchable>
    <Private>0</Private>
  </flags>
  <temporal mode="0" enabled="0" fixedDuration="0" startField="" startExpression="" accumulate="0" limitMode="0" endField="" endExpression="" durationUnit="min" durationField="">
    <fixedRange>
      <start></start>
      <end></end>
    </fixedRange>
  </temporal>
  <renderer-v2 referencescale="-1" attr="epa_type" symbollevels="0" forceraster="0" enableorderby="0" type="categorizedSymbol">
    <categories>
      <category value="INLET" render="true" label="INLET" symbol="0"/>
      <category value="JUNCTION" render="true" label="JUNCTION" symbol="1"/>
      <category value="PUMP" render="true" label="PUMP" symbol="2"/>
      <category value="RESERVOIR" render="true" label="RESERVOIR" symbol="3"/>
      <category value="SHORTPIPE" render="true" label="SHORTPIPE" symbol="4"/>
      <category value="VALVE" render="true" label="VALVE" symbol="5"/>
      <category value="TANK" render="true" label="TANK" symbol="6"/>
    </categories>
    <symbols>
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,106,253,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="square" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="0,106,253,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2.8"/>
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
      <symbol force_rhr="0" name="1" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="5,163,242,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="5,163,242,255"/>
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
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol force_rhr="0" name="2" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,106,253,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="83,83,83,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="0,106,253,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="83,83,83,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="3.2"/>
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
        <layer locked="0" enabled="1" pass="0" class="FontMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="P" name="chr" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="Dingbats" name="font" type="QString"/>
            <Option value="" name="font_style" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="2.88" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="chr" v="P"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="font" v="Dingbats"/>
          <prop k="font_style" v=""/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="size" v="2.88"/>
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
      <symbol force_rhr="0" name="3" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="44,171,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="square" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="44,171,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="square"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="35,35,35,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2.8"/>
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
      <symbol force_rhr="0" name="4" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="2.4"/>
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
      <symbol force_rhr="0" name="5" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,255,255,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.2" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="area" name="scale_method" type="QString"/>
            <Option value="2.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.2"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="2.6"/>
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
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,0,0,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="area" name="scale_method" type="QString"/>
            <Option value="0.56875" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="0,0,0,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="0,0,0,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="area"/>
          <prop k="size" v="0.56875"/>
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
      <symbol force_rhr="0" name="6" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="0,106,253,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="50,87,128,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0.4" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="0,106,253,255"/>
          <prop k="horizontal_anchor_point" v="1"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="name" v="circle"/>
          <prop k="offset" v="0,0"/>
          <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="offset_unit" v="MM"/>
          <prop k="outline_color" v="50,87,128,255"/>
          <prop k="outline_style" v="solid"/>
          <prop k="outline_width" v="0.4"/>
          <prop k="outline_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
          <prop k="outline_width_unit" v="MM"/>
          <prop k="scale_method" v="diameter"/>
          <prop k="size" v="3.2"/>
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
      <symbol force_rhr="0" name="0" clip_to_extent="1" type="marker" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer locked="0" enabled="1" pass="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="141,90,153,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <prop k="angle" v="0"/>
          <prop k="cap_style" v="square"/>
          <prop k="color" v="141,90,153,255"/>
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
    <Option type="Map">
      <Option name="dualview/previewExpressions" type="List">
        <Option value="&quot;node_id&quot;" type="QString"/>
      </Option>
      <Option value="0" name="embeddedWidgets/count" type="QString"/>
      <Option name="variableNames"/>
      <Option name="variableValues"/>
    </Option>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer attributeLegend="1" diagramType="Histogram">
    <DiagramCategory lineSizeType="MM" spacing="0" penColor="#000000" diagramOrientation="Up" penAlpha="255" opacity="1" scaleDependency="Area" direction="1" barWidth="5" labelPlacementMethod="XHeight" minScaleDenominator="0" backgroundColor="#ffffff" width="15" rotationOffset="270" lineSizeScale="3x:0,0,0,0,0,0" backgroundAlpha="255" spacingUnitScale="3x:0,0,0,0,0,0" sizeScale="3x:0,0,0,0,0,0" showAxis="0" maxScaleDenominator="1e+08" enabled="0" minimumSize="0" height="15" sizeType="MM" spacingUnit="MM" penWidth="0" scaleBasedVisibility="0">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute field="" color="#000000" label=""/>
      <axisSymbol>
        <symbol force_rhr="0" name="" clip_to_extent="1" type="line" alpha="1">
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
          <layer locked="0" enabled="1" pass="0" class="SimpleLine">
            <Option type="Map">
              <Option value="0" name="align_dash_pattern" type="QString"/>
              <Option value="square" name="capstyle" type="QString"/>
              <Option value="5;2" name="customdash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
              <Option value="MM" name="customdash_unit" type="QString"/>
              <Option value="0" name="dash_pattern_offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
              <Option value="0" name="draw_inside_polygon" type="QString"/>
              <Option value="bevel" name="joinstyle" type="QString"/>
              <Option value="35,35,35,255" name="line_color" type="QString"/>
              <Option value="solid" name="line_style" type="QString"/>
              <Option value="0.26" name="line_width" type="QString"/>
              <Option value="MM" name="line_width_unit" type="QString"/>
              <Option value="0" name="offset" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
              <Option value="MM" name="offset_unit" type="QString"/>
              <Option value="0" name="ring_filter" type="QString"/>
              <Option value="0" name="trim_distance_end" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_end_unit" type="QString"/>
              <Option value="0" name="trim_distance_start" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
              <Option value="MM" name="trim_distance_start_unit" type="QString"/>
              <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
              <Option value="0" name="use_custom_dash" type="QString"/>
              <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
            </Option>
            <prop k="align_dash_pattern" v="0"/>
            <prop k="capstyle" v="square"/>
            <prop k="customdash" v="5;2"/>
            <prop k="customdash_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="customdash_unit" v="MM"/>
            <prop k="dash_pattern_offset" v="0"/>
            <prop k="dash_pattern_offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="dash_pattern_offset_unit" v="MM"/>
            <prop k="draw_inside_polygon" v="0"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="line_color" v="35,35,35,255"/>
            <prop k="line_style" v="solid"/>
            <prop k="line_width" v="0.26"/>
            <prop k="line_width_unit" v="MM"/>
            <prop k="offset" v="0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="ring_filter" v="0"/>
            <prop k="trim_distance_end" v="0"/>
            <prop k="trim_distance_end_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_end_unit" v="MM"/>
            <prop k="trim_distance_start" v="0"/>
            <prop k="trim_distance_start_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="trim_distance_start_unit" v="MM"/>
            <prop k="tweak_dash_pattern_on_corners" v="0"/>
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
      </axisSymbol>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings showAll="1" priority="0" obstacle="0" zIndex="0" dist="0" linePlacementFlags="18" placement="0">
    <properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <geometryOptions removeDuplicateNodes="0" geometryPrecision="0">
    <activeChecks/>
    <checkConfiguration/>
  </geometryOptions>
  <legend type="default-vector" showLabelLegend="0"/>
  <referencedLayers/>
  <fieldConfiguration>
    <field name="node_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="code" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="elevation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="depth" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="node_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sys_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodecat_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="id" name="Key" type="QString"/>
            <Option value="cat_node20151105202206790" name="Layer" type="QString"/>
            <Option value="id" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_matcat_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_pnom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="cat_dnom" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="epa_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="INLET" name="INLET" type="QString"/>
              <Option value="JUNCTION" name="JUNCTION" type="QString"/>
              <Option value="PUMP" name="PUMP" type="QString"/>
              <Option value="RESERVOIR" name="RESERVOIR" type="QString"/>
              <Option value="SHORTPIPE" name="SHORTPIPE" type="QString"/>
              <Option value="TANK" name="TANK" type="QString"/>
              <Option value="UNDEFINED" name="UNDEFINED" type="QString"/>
              <Option value="VALVE" name="VALVE" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="expl_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="expl_id" name="Key" type="QString"/>
            <Option value="v_edit_exploitation_fd06cc08_9e9d_4a22_bfca_586b3919d086" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macroexpl_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="sector_id" name="Key" type="QString"/>
            <Option value="v_edit_sector20171204170540567" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="sector_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrosector_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
              <Option value="1" name="macrosector_01" type="QString"/>
              <Option value="2" name="macrosector_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="arc_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="parent_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="OBSOLETE" type="QString"/>
              <Option value="1" name="OPERATIVE" type="QString"/>
              <Option value="2" name="PLANIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="state_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="99" name="FICTICIUS" type="QString"/>
              <Option value="1" name="OBSOLETE" type="QString"/>
              <Option value="2" name="OPERATIVE" type="QString"/>
              <Option value="3" name="PLANIFIED" type="QString"/>
              <Option value="5" name="PROVISIONAL" type="QString"/>
              <Option value="4" name="RECONSTRUCT" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="annotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="observ" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="comment" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="minsector_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dma_id" name="Key" type="QString"/>
            <Option value="v_edit_dma20190515092620863" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodma_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="presszone_id" name="Key" type="QString"/>
            <Option value="v_edit_presszone_d6c14d1a_a691_4ec8_a373_97438e05f219" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="staticpressure" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_id" configurationFlags="None">
      <editWidget type="ValueRelation">
        <config>
          <Option type="Map">
            <Option value="False" name="AllowNull" type="QString"/>
            <Option value="" name="FilterExpression" type="QString"/>
            <Option value="dqa_id" name="Key" type="QString"/>
            <Option value="v_edit_dqa_4e695ade_c45c_4562_afb6_1d3c41532a1b" name="Layer" type="QString"/>
            <Option value="name" name="Value" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dqa_name" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="macrodqa_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="0" name="Undefined" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="soilcat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="soil1" name="soil1" type="QString"/>
              <Option value="soil2" name="soil2" type="QString"/>
              <Option value="soil3" name="soil3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="function_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Function" name="St. Function" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="category_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Category" name="St. Category" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="fluid_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Fluid" name="St. Fluid" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="location_type" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="St. Location" name="St. Location" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_end" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="builtdate" configurationFlags="None">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option value="true" name="allow_null" type="bool"/>
            <Option value="true" name="calendar_popup" type="bool"/>
            <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
            <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
            <Option value="false" name="field_iso_format" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="enddate" configurationFlags="None">
      <editWidget type="DateTime">
        <config>
          <Option type="Map">
            <Option value="true" name="allow_null" type="bool"/>
            <Option value="true" name="calendar_popup" type="bool"/>
            <Option value="yyyy-MM-dd" name="display_format" type="QString"/>
            <Option value="yyyy-MM-dd" name="field_format" type="QString"/>
            <Option value="false" name="field_iso_format" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="buildercat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="builder1" name="builder1" type="QString"/>
              <Option value="builder2" name="builder2" type="QString"/>
              <Option value="builder3" name="builder3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="ownercat_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="owner1" name="owner1" type="QString"/>
              <Option value="owner2" name="owner2" type="QString"/>
              <Option value="owner3" name="owner3" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="muni_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Sant Boi del Llobregat" type="QString"/>
              <Option value="2" name="Sant Esteve de les Roures" type="QString"/>
              <Option value="0" name="Undefined" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcode" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="district_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Camps Blancs" type="QString"/>
              <Option value="2" name="Marianao" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postnumber" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="streetname2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postnumber2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="postcomplement2" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="descript" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="svg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="rotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="link" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="verified" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="TO REVIEW" name="TO REVIEW" type="QString"/>
              <Option value="VERIFIED" name="VERIFIED" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="undelete" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_x" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_y" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="label_rotation" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="publish" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="inventory" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option type="Map">
            <Option value="true" name="CheckedState" type="QString"/>
            <Option value="false" name="UncheckedState" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="hemisphere" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="num_value" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="nodetype_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="tstamp" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="insert_user" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="lastupdate_user" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="adate" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="adescript" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="accessibility" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="dma_style" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="presszone_style" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="closed_valve" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="broken_valve" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="workcat_id_plan" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="False" name="IsMultiline" type="QString"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="asset_id" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="om_state" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="conserv_state" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="access_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="placement_type" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option type="Map">
            <Option value="false" name="IsMultiline" type="bool"/>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="demand_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="demand_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="demand_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="press_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="press_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="press_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="head_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="head_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="head_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="quality_max" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="quality_min" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="quality_avg" configurationFlags="None">
      <editWidget type="TextEdit">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="expl_id2" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="expl_01" type="QString"/>
              <Option value="2" name="expl_02" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="is_operative" configurationFlags="None">
      <editWidget type="CheckBox">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
    <field name="region_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Baix Llobregat" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
    <field name="province_id" configurationFlags="None">
      <editWidget type="ValueMap">
        <config>
          <Option type="Map">
            <Option name="map" type="Map">
              <Option value="1" name="Barcelona" type="QString"/>
            </Option>
          </Option>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias index="0" name="node_id" field="node_id"/>
    <alias index="1" name="code" field="code"/>
    <alias index="2" name="elevation" field="elevation"/>
    <alias index="3" name="depth" field="depth"/>
    <alias index="4" name="node_type" field="node_type"/>
    <alias index="5" name="sys_type" field="sys_type"/>
    <alias index="6" name="nodecat_id" field="nodecat_id"/>
    <alias index="7" name="cat_matcat_id" field="cat_matcat_id"/>
    <alias index="8" name="cat_pnom" field="cat_pnom"/>
    <alias index="9" name="cat_dnom" field="cat_dnom"/>
    <alias index="10" name="epa type" field="epa_type"/>
    <alias index="11" name="exploitation" field="expl_id"/>
    <alias index="12" name="Macroexploitation" field="macroexpl_id"/>
    <alias index="13" name="sector" field="sector_id"/>
    <alias index="14" name="Sector name" field="sector_name"/>
    <alias index="15" name="macrosector" field="macrosector_id"/>
    <alias index="16" name="arc_id" field="arc_id"/>
    <alias index="17" name="parent_id" field="parent_id"/>
    <alias index="18" name="state" field="state"/>
    <alias index="19" name="state_type" field="state_type"/>
    <alias index="20" name="annotation" field="annotation"/>
    <alias index="21" name="observ" field="observ"/>
    <alias index="22" name="comment" field="comment"/>
    <alias index="23" name="minsector_id" field="minsector_id"/>
    <alias index="24" name="dma" field="dma_id"/>
    <alias index="25" name="Dma name" field="dma_name"/>
    <alias index="26" name="macrodma_id" field="macrodma_id"/>
    <alias index="27" name="Presszone" field="presszone_id"/>
    <alias index="28" name="Presszone name" field="presszone_name"/>
    <alias index="29" name="staticpressure" field="staticpressure"/>
    <alias index="30" name="Dqa" field="dqa_id"/>
    <alias index="31" name="Dqa name" field="dqa_name"/>
    <alias index="32" name="macrodqa_id" field="macrodqa_id"/>
    <alias index="33" name="soilcat_id" field="soilcat_id"/>
    <alias index="34" name="function_type" field="function_type"/>
    <alias index="35" name="category_type" field="category_type"/>
    <alias index="36" name="fluid_type" field="fluid_type"/>
    <alias index="37" name="location_type" field="location_type"/>
    <alias index="38" name="work_id" field="workcat_id"/>
    <alias index="39" name="work_id_end" field="workcat_id_end"/>
    <alias index="40" name="builtdate" field="builtdate"/>
    <alias index="41" name="enddate" field="enddate"/>
    <alias index="42" name="builder" field="buildercat_id"/>
    <alias index="43" name="owner" field="ownercat_id"/>
    <alias index="44" name="municipality" field="muni_id"/>
    <alias index="45" name="postcode" field="postcode"/>
    <alias index="46" name="district" field="district_id"/>
    <alias index="47" name="streetname" field="streetname"/>
    <alias index="48" name="postnumber" field="postnumber"/>
    <alias index="49" name="postcomplement" field="postcomplement"/>
    <alias index="50" name="streetname2" field="streetname2"/>
    <alias index="51" name="postnumber2" field="postnumber2"/>
    <alias index="52" name="postcomplement2" field="postcomplement2"/>
    <alias index="53" name="descript" field="descript"/>
    <alias index="54" name="svg" field="svg"/>
    <alias index="55" name="rotation" field="rotation"/>
    <alias index="56" name="link" field="link"/>
    <alias index="57" name="verified" field="verified"/>
    <alias index="58" name="undelete" field="undelete"/>
    <alias index="59" name="Catalog label" field="label"/>
    <alias index="60" name="label_x" field="label_x"/>
    <alias index="61" name="label_y" field="label_y"/>
    <alias index="62" name="label_rotation" field="label_rotation"/>
    <alias index="63" name="publish" field="publish"/>
    <alias index="64" name="inventory" field="inventory"/>
    <alias index="65" name="hemisphere" field="hemisphere"/>
    <alias index="66" name="num_value" field="num_value"/>
    <alias index="67" name="node_type" field="nodetype_id"/>
    <alias index="68" name="Insert tstamp" field="tstamp"/>
    <alias index="69" name="" field="insert_user"/>
    <alias index="70" name="Last update" field="lastupdate"/>
    <alias index="71" name="Last update user" field="lastupdate_user"/>
    <alias index="72" name="Adate" field="adate"/>
    <alias index="73" name="A descript" field="adescript"/>
    <alias index="74" name="Accessibility" field="accessibility"/>
    <alias index="75" name="Dma color" field="dma_style"/>
    <alias index="76" name="Presszone color" field="presszone_style"/>
    <alias index="77" name="" field="closed_valve"/>
    <alias index="78" name="" field="broken_valve"/>
    <alias index="79" name="workcat_id_plan" field="workcat_id_plan"/>
    <alias index="80" name="asset_id" field="asset_id"/>
    <alias index="81" name="om_state" field="om_state"/>
    <alias index="82" name="conserv_state" field="conserv_state"/>
    <alias index="83" name="access_type" field="access_type"/>
    <alias index="84" name="placement_type" field="placement_type"/>
    <alias index="85" name="" field="demand_max"/>
    <alias index="86" name="" field="demand_min"/>
    <alias index="87" name="" field="demand_avg"/>
    <alias index="88" name="" field="press_max"/>
    <alias index="89" name="" field="press_min"/>
    <alias index="90" name="" field="press_avg"/>
    <alias index="91" name="" field="head_max"/>
    <alias index="92" name="" field="head_min"/>
    <alias index="93" name="" field="head_avg"/>
    <alias index="94" name="" field="quality_max"/>
    <alias index="95" name="" field="quality_min"/>
    <alias index="96" name="" field="quality_avg"/>
    <alias index="97" name="Exploitation 2" field="expl_id2"/>
    <alias index="98" name="" field="is_operative"/>
    <alias index="99" name="Region" field="region_id"/>
    <alias index="100" name="Province" field="province_id"/>
  </aliases>
  <defaults>
    <default expression="" field="node_id" applyOnUpdate="0"/>
    <default expression="" field="code" applyOnUpdate="0"/>
    <default expression="" field="elevation" applyOnUpdate="0"/>
    <default expression="" field="depth" applyOnUpdate="0"/>
    <default expression="" field="node_type" applyOnUpdate="0"/>
    <default expression="" field="sys_type" applyOnUpdate="0"/>
    <default expression="" field="nodecat_id" applyOnUpdate="0"/>
    <default expression="" field="cat_matcat_id" applyOnUpdate="0"/>
    <default expression="" field="cat_pnom" applyOnUpdate="0"/>
    <default expression="" field="cat_dnom" applyOnUpdate="0"/>
    <default expression="" field="epa_type" applyOnUpdate="0"/>
    <default expression="" field="expl_id" applyOnUpdate="0"/>
    <default expression="" field="macroexpl_id" applyOnUpdate="0"/>
    <default expression="" field="sector_id" applyOnUpdate="0"/>
    <default expression="" field="sector_name" applyOnUpdate="0"/>
    <default expression="" field="macrosector_id" applyOnUpdate="0"/>
    <default expression="" field="arc_id" applyOnUpdate="0"/>
    <default expression="" field="parent_id" applyOnUpdate="0"/>
    <default expression="" field="state" applyOnUpdate="0"/>
    <default expression="" field="state_type" applyOnUpdate="0"/>
    <default expression="" field="annotation" applyOnUpdate="0"/>
    <default expression="" field="observ" applyOnUpdate="0"/>
    <default expression="" field="comment" applyOnUpdate="0"/>
    <default expression="" field="minsector_id" applyOnUpdate="0"/>
    <default expression="" field="dma_id" applyOnUpdate="0"/>
    <default expression="" field="dma_name" applyOnUpdate="0"/>
    <default expression="" field="macrodma_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_id" applyOnUpdate="0"/>
    <default expression="" field="presszone_name" applyOnUpdate="0"/>
    <default expression="" field="staticpressure" applyOnUpdate="0"/>
    <default expression="" field="dqa_id" applyOnUpdate="0"/>
    <default expression="" field="dqa_name" applyOnUpdate="0"/>
    <default expression="" field="macrodqa_id" applyOnUpdate="0"/>
    <default expression="" field="soilcat_id" applyOnUpdate="0"/>
    <default expression="" field="function_type" applyOnUpdate="0"/>
    <default expression="" field="category_type" applyOnUpdate="0"/>
    <default expression="" field="fluid_type" applyOnUpdate="0"/>
    <default expression="" field="location_type" applyOnUpdate="0"/>
    <default expression="" field="workcat_id" applyOnUpdate="0"/>
    <default expression="" field="workcat_id_end" applyOnUpdate="0"/>
    <default expression="" field="builtdate" applyOnUpdate="0"/>
    <default expression="" field="enddate" applyOnUpdate="0"/>
    <default expression="" field="buildercat_id" applyOnUpdate="0"/>
    <default expression="" field="ownercat_id" applyOnUpdate="0"/>
    <default expression="" field="muni_id" applyOnUpdate="0"/>
    <default expression="" field="postcode" applyOnUpdate="0"/>
    <default expression="" field="district_id" applyOnUpdate="0"/>
    <default expression="" field="streetname" applyOnUpdate="0"/>
    <default expression="" field="postnumber" applyOnUpdate="0"/>
    <default expression="" field="postcomplement" applyOnUpdate="0"/>
    <default expression="" field="streetname2" applyOnUpdate="0"/>
    <default expression="" field="postnumber2" applyOnUpdate="0"/>
    <default expression="" field="postcomplement2" applyOnUpdate="0"/>
    <default expression="" field="descript" applyOnUpdate="0"/>
    <default expression="" field="svg" applyOnUpdate="0"/>
    <default expression="" field="rotation" applyOnUpdate="0"/>
    <default expression="" field="link" applyOnUpdate="0"/>
    <default expression="" field="verified" applyOnUpdate="0"/>
    <default expression="" field="undelete" applyOnUpdate="0"/>
    <default expression="" field="label" applyOnUpdate="0"/>
    <default expression="" field="label_x" applyOnUpdate="0"/>
    <default expression="" field="label_y" applyOnUpdate="0"/>
    <default expression="" field="label_rotation" applyOnUpdate="0"/>
    <default expression="" field="publish" applyOnUpdate="0"/>
    <default expression="" field="inventory" applyOnUpdate="0"/>
    <default expression="" field="hemisphere" applyOnUpdate="0"/>
    <default expression="" field="num_value" applyOnUpdate="0"/>
    <default expression="" field="nodetype_id" applyOnUpdate="0"/>
    <default expression="" field="tstamp" applyOnUpdate="0"/>
    <default expression="" field="insert_user" applyOnUpdate="0"/>
    <default expression="" field="lastupdate" applyOnUpdate="0"/>
    <default expression="" field="lastupdate_user" applyOnUpdate="0"/>
    <default expression="" field="adate" applyOnUpdate="0"/>
    <default expression="" field="adescript" applyOnUpdate="0"/>
    <default expression="" field="accessibility" applyOnUpdate="0"/>
    <default expression="" field="dma_style" applyOnUpdate="0"/>
    <default expression="" field="presszone_style" applyOnUpdate="0"/>
    <default expression="" field="closed_valve" applyOnUpdate="0"/>
    <default expression="" field="broken_valve" applyOnUpdate="0"/>
    <default expression="" field="workcat_id_plan" applyOnUpdate="0"/>
    <default expression="" field="asset_id" applyOnUpdate="0"/>
    <default expression="" field="om_state" applyOnUpdate="0"/>
    <default expression="" field="conserv_state" applyOnUpdate="0"/>
    <default expression="" field="access_type" applyOnUpdate="0"/>
    <default expression="" field="placement_type" applyOnUpdate="0"/>
    <default expression="" field="demand_max" applyOnUpdate="0"/>
    <default expression="" field="demand_min" applyOnUpdate="0"/>
    <default expression="" field="demand_avg" applyOnUpdate="0"/>
    <default expression="" field="press_max" applyOnUpdate="0"/>
    <default expression="" field="press_min" applyOnUpdate="0"/>
    <default expression="" field="press_avg" applyOnUpdate="0"/>
    <default expression="" field="head_max" applyOnUpdate="0"/>
    <default expression="" field="head_min" applyOnUpdate="0"/>
    <default expression="" field="head_avg" applyOnUpdate="0"/>
    <default expression="" field="quality_max" applyOnUpdate="0"/>
    <default expression="" field="quality_min" applyOnUpdate="0"/>
    <default expression="" field="quality_avg" applyOnUpdate="0"/>
    <default expression="" field="expl_id2" applyOnUpdate="0"/>
    <default expression="" field="is_operative" applyOnUpdate="0"/>
    <default expression="" field="region_id" applyOnUpdate="0"/>
    <default expression="" field="province_id" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint unique_strength="1" notnull_strength="2" field="node_id" constraints="3" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="code" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="elevation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="depth" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="node_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sys_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="nodecat_id" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_matcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_pnom" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="cat_dnom" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="epa_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="macroexpl_id" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="sector_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrosector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="arc_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="parent_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="state_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="annotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="observ" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="comment" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="minsector_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodma_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="staticpressure" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dqa_name" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="macrodqa_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="soilcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="function_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="category_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="fluid_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="location_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id_end" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="builtdate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="enddate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="buildercat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="ownercat_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="muni_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcode" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="district_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="streetname" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postnumber" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcomplement" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="streetname2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postnumber2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="postcomplement2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="descript" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="svg" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="rotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="link" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="verified" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="undelete" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_x" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_y" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="label_rotation" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="publish" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="inventory" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="hemisphere" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="num_value" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="nodetype_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="tstamp" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="insert_user" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="lastupdate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="lastupdate_user" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="adate" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="adescript" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="accessibility" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="dma_style" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="presszone_style" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="closed_valve" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="broken_valve" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="workcat_id_plan" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="asset_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="om_state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="conserv_state" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="access_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="placement_type" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="demand_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="demand_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="demand_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="press_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="press_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="press_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="head_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="head_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="head_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="quality_max" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="quality_min" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="quality_avg" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="expl_id2" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="0" field="is_operative" constraints="0" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="region_id" constraints="1" exp_strength="0"/>
    <constraint unique_strength="0" notnull_strength="2" field="province_id" constraints="1" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint desc="" field="node_id" exp=""/>
    <constraint desc="" field="code" exp=""/>
    <constraint desc="" field="elevation" exp=""/>
    <constraint desc="" field="depth" exp=""/>
    <constraint desc="" field="node_type" exp=""/>
    <constraint desc="" field="sys_type" exp=""/>
    <constraint desc="" field="nodecat_id" exp=""/>
    <constraint desc="" field="cat_matcat_id" exp=""/>
    <constraint desc="" field="cat_pnom" exp=""/>
    <constraint desc="" field="cat_dnom" exp=""/>
    <constraint desc="" field="epa_type" exp=""/>
    <constraint desc="" field="expl_id" exp=""/>
    <constraint desc="" field="macroexpl_id" exp=""/>
    <constraint desc="" field="sector_id" exp=""/>
    <constraint desc="" field="sector_name" exp=""/>
    <constraint desc="" field="macrosector_id" exp=""/>
    <constraint desc="" field="arc_id" exp=""/>
    <constraint desc="" field="parent_id" exp=""/>
    <constraint desc="" field="state" exp=""/>
    <constraint desc="" field="state_type" exp=""/>
    <constraint desc="" field="annotation" exp=""/>
    <constraint desc="" field="observ" exp=""/>
    <constraint desc="" field="comment" exp=""/>
    <constraint desc="" field="minsector_id" exp=""/>
    <constraint desc="" field="dma_id" exp=""/>
    <constraint desc="" field="dma_name" exp=""/>
    <constraint desc="" field="macrodma_id" exp=""/>
    <constraint desc="" field="presszone_id" exp=""/>
    <constraint desc="" field="presszone_name" exp=""/>
    <constraint desc="" field="staticpressure" exp=""/>
    <constraint desc="" field="dqa_id" exp=""/>
    <constraint desc="" field="dqa_name" exp=""/>
    <constraint desc="" field="macrodqa_id" exp=""/>
    <constraint desc="" field="soilcat_id" exp=""/>
    <constraint desc="" field="function_type" exp=""/>
    <constraint desc="" field="category_type" exp=""/>
    <constraint desc="" field="fluid_type" exp=""/>
    <constraint desc="" field="location_type" exp=""/>
    <constraint desc="" field="workcat_id" exp=""/>
    <constraint desc="" field="workcat_id_end" exp=""/>
    <constraint desc="" field="builtdate" exp=""/>
    <constraint desc="" field="enddate" exp=""/>
    <constraint desc="" field="buildercat_id" exp=""/>
    <constraint desc="" field="ownercat_id" exp=""/>
    <constraint desc="" field="muni_id" exp=""/>
    <constraint desc="" field="postcode" exp=""/>
    <constraint desc="" field="district_id" exp=""/>
    <constraint desc="" field="streetname" exp=""/>
    <constraint desc="" field="postnumber" exp=""/>
    <constraint desc="" field="postcomplement" exp=""/>
    <constraint desc="" field="streetname2" exp=""/>
    <constraint desc="" field="postnumber2" exp=""/>
    <constraint desc="" field="postcomplement2" exp=""/>
    <constraint desc="" field="descript" exp=""/>
    <constraint desc="" field="svg" exp=""/>
    <constraint desc="" field="rotation" exp=""/>
    <constraint desc="" field="link" exp=""/>
    <constraint desc="" field="verified" exp=""/>
    <constraint desc="" field="undelete" exp=""/>
    <constraint desc="" field="label" exp=""/>
    <constraint desc="" field="label_x" exp=""/>
    <constraint desc="" field="label_y" exp=""/>
    <constraint desc="" field="label_rotation" exp=""/>
    <constraint desc="" field="publish" exp=""/>
    <constraint desc="" field="inventory" exp=""/>
    <constraint desc="" field="hemisphere" exp=""/>
    <constraint desc="" field="num_value" exp=""/>
    <constraint desc="" field="nodetype_id" exp=""/>
    <constraint desc="" field="tstamp" exp=""/>
    <constraint desc="" field="insert_user" exp=""/>
    <constraint desc="" field="lastupdate" exp=""/>
    <constraint desc="" field="lastupdate_user" exp=""/>
    <constraint desc="" field="adate" exp=""/>
    <constraint desc="" field="adescript" exp=""/>
    <constraint desc="" field="accessibility" exp=""/>
    <constraint desc="" field="dma_style" exp=""/>
    <constraint desc="" field="presszone_style" exp=""/>
    <constraint desc="" field="closed_valve" exp=""/>
    <constraint desc="" field="broken_valve" exp=""/>
    <constraint desc="" field="workcat_id_plan" exp=""/>
    <constraint desc="" field="asset_id" exp=""/>
    <constraint desc="" field="om_state" exp=""/>
    <constraint desc="" field="conserv_state" exp=""/>
    <constraint desc="" field="access_type" exp=""/>
    <constraint desc="" field="placement_type" exp=""/>
    <constraint desc="" field="demand_max" exp=""/>
    <constraint desc="" field="demand_min" exp=""/>
    <constraint desc="" field="demand_avg" exp=""/>
    <constraint desc="" field="press_max" exp=""/>
    <constraint desc="" field="press_min" exp=""/>
    <constraint desc="" field="press_avg" exp=""/>
    <constraint desc="" field="head_max" exp=""/>
    <constraint desc="" field="head_min" exp=""/>
    <constraint desc="" field="head_avg" exp=""/>
    <constraint desc="" field="quality_max" exp=""/>
    <constraint desc="" field="quality_min" exp=""/>
    <constraint desc="" field="quality_avg" exp=""/>
    <constraint desc="" field="expl_id2" exp=""/>
    <constraint desc="" field="is_operative" exp=""/>
    <constraint desc="" field="region_id" exp=""/>
    <constraint desc="" field="province_id" exp=""/>
  </constraintExpressions>
  <expressionfields/>
  <attributeactions>
    <defaultAction key="Canvas" value="{00000000-0000-0000-0000-000000000000}"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="&quot;epa_type&quot;">
    <columns>
      <column hidden="0" name="node_id" width="-1" type="field"/>
      <column hidden="0" name="code" width="-1" type="field"/>
      <column hidden="0" name="elevation" width="-1" type="field"/>
      <column hidden="0" name="depth" width="-1" type="field"/>
      <column hidden="0" name="node_type" width="-1" type="field"/>
      <column hidden="0" name="sys_type" width="-1" type="field"/>
      <column hidden="0" name="nodecat_id" width="-1" type="field"/>
      <column hidden="0" name="cat_matcat_id" width="-1" type="field"/>
      <column hidden="0" name="cat_pnom" width="-1" type="field"/>
      <column hidden="0" name="cat_dnom" width="-1" type="field"/>
      <column hidden="0" name="epa_type" width="-1" type="field"/>
      <column hidden="0" name="expl_id" width="-1" type="field"/>
      <column hidden="1" name="macroexpl_id" width="-1" type="field"/>
      <column hidden="0" name="sector_id" width="-1" type="field"/>
      <column hidden="0" name="macrosector_id" width="-1" type="field"/>
      <column hidden="0" name="arc_id" width="-1" type="field"/>
      <column hidden="0" name="parent_id" width="-1" type="field"/>
      <column hidden="0" name="state" width="-1" type="field"/>
      <column hidden="0" name="state_type" width="-1" type="field"/>
      <column hidden="0" name="annotation" width="-1" type="field"/>
      <column hidden="0" name="observ" width="-1" type="field"/>
      <column hidden="0" name="comment" width="-1" type="field"/>
      <column hidden="0" name="minsector_id" width="-1" type="field"/>
      <column hidden="0" name="dma_id" width="-1" type="field"/>
      <column hidden="1" name="macrodma_id" width="-1" type="field"/>
      <column hidden="0" name="presszone_id" width="-1" type="field"/>
      <column hidden="0" name="staticpressure" width="-1" type="field"/>
      <column hidden="0" name="dqa_id" width="-1" type="field"/>
      <column hidden="0" name="macrodqa_id" width="-1" type="field"/>
      <column hidden="0" name="soilcat_id" width="-1" type="field"/>
      <column hidden="0" name="function_type" width="-1" type="field"/>
      <column hidden="0" name="category_type" width="-1" type="field"/>
      <column hidden="0" name="fluid_type" width="-1" type="field"/>
      <column hidden="0" name="location_type" width="-1" type="field"/>
      <column hidden="0" name="workcat_id" width="-1" type="field"/>
      <column hidden="0" name="workcat_id_end" width="-1" type="field"/>
      <column hidden="0" name="builtdate" width="-1" type="field"/>
      <column hidden="0" name="enddate" width="-1" type="field"/>
      <column hidden="0" name="buildercat_id" width="-1" type="field"/>
      <column hidden="0" name="ownercat_id" width="-1" type="field"/>
      <column hidden="0" name="muni_id" width="-1" type="field"/>
      <column hidden="0" name="postcode" width="-1" type="field"/>
      <column hidden="1" name="district_id" width="-1" type="field"/>
      <column hidden="0" name="streetname" width="-1" type="field"/>
      <column hidden="0" name="postnumber" width="-1" type="field"/>
      <column hidden="0" name="postcomplement" width="-1" type="field"/>
      <column hidden="0" name="streetname2" width="-1" type="field"/>
      <column hidden="0" name="postnumber2" width="-1" type="field"/>
      <column hidden="0" name="postcomplement2" width="-1" type="field"/>
      <column hidden="0" name="descript" width="-1" type="field"/>
      <column hidden="0" name="svg" width="-1" type="field"/>
      <column hidden="0" name="rotation" width="-1" type="field"/>
      <column hidden="0" name="link" width="-1" type="field"/>
      <column hidden="0" name="verified" width="-1" type="field"/>
      <column hidden="0" name="undelete" width="-1" type="field"/>
      <column hidden="0" name="label" width="-1" type="field"/>
      <column hidden="0" name="label_x" width="-1" type="field"/>
      <column hidden="0" name="label_y" width="-1" type="field"/>
      <column hidden="0" name="label_rotation" width="-1" type="field"/>
      <column hidden="1" name="publish" width="-1" type="field"/>
      <column hidden="1" name="inventory" width="-1" type="field"/>
      <column hidden="0" name="hemisphere" width="-1" type="field"/>
      <column hidden="0" name="num_value" width="-1" type="field"/>
      <column hidden="1" name="nodetype_id" width="-1" type="field"/>
      <column hidden="1" name="tstamp" width="-1" type="field"/>
      <column hidden="0" name="insert_user" width="-1" type="field"/>
      <column hidden="1" name="lastupdate" width="-1" type="field"/>
      <column hidden="1" name="lastupdate_user" width="-1" type="field"/>
      <column hidden="1" width="-1" type="actions"/>
      <column hidden="1" name="sector_name" width="-1" type="field"/>
      <column hidden="1" name="dma_name" width="-1" type="field"/>
      <column hidden="1" name="presszone_name" width="-1" type="field"/>
      <column hidden="1" name="dqa_name" width="-1" type="field"/>
      <column hidden="1" name="adate" width="-1" type="field"/>
      <column hidden="1" name="adescript" width="-1" type="field"/>
      <column hidden="1" name="accessibility" width="-1" type="field"/>
      <column hidden="1" name="dma_style" width="-1" type="field"/>
      <column hidden="1" name="presszone_style" width="-1" type="field"/>
      <column hidden="0" name="closed_valve" width="-1" type="field"/>
      <column hidden="0" name="broken_valve" width="-1" type="field"/>
      <column hidden="0" name="workcat_id_plan" width="-1" type="field"/>
      <column hidden="1" name="om_state" width="-1" type="field"/>
      <column hidden="1" name="conserv_state" width="-1" type="field"/>
      <column hidden="1" name="access_type" width="-1" type="field"/>
      <column hidden="1" name="placement_type" width="-1" type="field"/>
      <column hidden="0" name="demand_max" width="-1" type="field"/>
      <column hidden="0" name="demand_min" width="-1" type="field"/>
      <column hidden="0" name="demand_avg" width="-1" type="field"/>
      <column hidden="0" name="press_max" width="-1" type="field"/>
      <column hidden="0" name="press_min" width="-1" type="field"/>
      <column hidden="0" name="press_avg" width="-1" type="field"/>
      <column hidden="0" name="head_max" width="-1" type="field"/>
      <column hidden="0" name="head_min" width="-1" type="field"/>
      <column hidden="0" name="head_avg" width="-1" type="field"/>
      <column hidden="0" name="quality_max" width="-1" type="field"/>
      <column hidden="0" name="quality_min" width="-1" type="field"/>
      <column hidden="0" name="quality_avg" width="-1" type="field"/>
      <column hidden="1" name="expl_id2" width="-1" type="field"/>
      <column hidden="0" name="is_operative" width="-1" type="field"/>
      <column hidden="1" name="region_id" width="-1" type="field"/>
      <column hidden="1" name="province_id" width="-1" type="field"/>
      <column hidden="0" name="asset_id" width="-1" type="field"/>
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
    <field name="access_type" editable="1"/>
    <field name="accessibility" editable="0"/>
    <field name="adate" editable="0"/>
    <field name="adescript" editable="0"/>
    <field name="annotation" editable="1"/>
    <field name="arc_id" editable="0"/>
    <field name="asset_id" editable="1"/>
    <field name="broken_valve" editable="1"/>
    <field name="buildercat_id" editable="1"/>
    <field name="builtdate" editable="1"/>
    <field name="cat_dnom" editable="0"/>
    <field name="cat_matcat_id" editable="0"/>
    <field name="cat_pnom" editable="0"/>
    <field name="category_type" editable="1"/>
    <field name="closed_valve" editable="1"/>
    <field name="code" editable="1"/>
    <field name="comment" editable="1"/>
    <field name="conserv_state" editable="1"/>
    <field name="demand_avg" editable="1"/>
    <field name="demand_max" editable="1"/>
    <field name="demand_min" editable="1"/>
    <field name="depth" editable="1"/>
    <field name="descript" editable="1"/>
    <field name="district_id" editable="1"/>
    <field name="dma_id" editable="1"/>
    <field name="dma_name" editable="0"/>
    <field name="dma_style" editable="0"/>
    <field name="dqa_id" editable="0"/>
    <field name="dqa_name" editable="0"/>
    <field name="elevation" editable="1"/>
    <field name="enddate" editable="1"/>
    <field name="epa_type" editable="1"/>
    <field name="expl_id" editable="1"/>
    <field name="expl_id2" editable="1"/>
    <field name="fluid_type" editable="1"/>
    <field name="function_type" editable="1"/>
    <field name="head_avg" editable="1"/>
    <field name="head_max" editable="1"/>
    <field name="head_min" editable="1"/>
    <field name="hemisphere" editable="1"/>
    <field name="insert_user" editable="1"/>
    <field name="inventory" editable="1"/>
    <field name="is_operative" editable="1"/>
    <field name="label" editable="0"/>
    <field name="label_rotation" editable="1"/>
    <field name="label_x" editable="1"/>
    <field name="label_y" editable="1"/>
    <field name="lastupdate" editable="0"/>
    <field name="lastupdate_user" editable="0"/>
    <field name="link" editable="0"/>
    <field name="location_type" editable="1"/>
    <field name="macrodma_id" editable="0"/>
    <field name="macrodqa_id" editable="0"/>
    <field name="macroexpl_id" editable="1"/>
    <field name="macrosector_id" editable="0"/>
    <field name="minsector_id" editable="0"/>
    <field name="muni_id" editable="1"/>
    <field name="node_id" editable="0"/>
    <field name="node_type" editable="0"/>
    <field name="nodecat_id" editable="1"/>
    <field name="nodetype_id" editable="0"/>
    <field name="num_value" editable="1"/>
    <field name="observ" editable="1"/>
    <field name="om_state" editable="1"/>
    <field name="ownercat_id" editable="1"/>
    <field name="parent_id" editable="1"/>
    <field name="placement_type" editable="1"/>
    <field name="postcode" editable="1"/>
    <field name="postcomplement" editable="1"/>
    <field name="postcomplement2" editable="1"/>
    <field name="postnumber" editable="1"/>
    <field name="postnumber2" editable="1"/>
    <field name="press_avg" editable="1"/>
    <field name="press_max" editable="1"/>
    <field name="press_min" editable="1"/>
    <field name="presszone_id" editable="1"/>
    <field name="presszone_name" editable="0"/>
    <field name="presszone_style" editable="0"/>
    <field name="province_id" editable="0"/>
    <field name="publish" editable="1"/>
    <field name="quality_avg" editable="1"/>
    <field name="quality_max" editable="1"/>
    <field name="quality_min" editable="1"/>
    <field name="region_id" editable="0"/>
    <field name="rotation" editable="1"/>
    <field name="sector_id" editable="1"/>
    <field name="sector_name" editable="0"/>
    <field name="soilcat_id" editable="1"/>
    <field name="state" editable="1"/>
    <field name="state_type" editable="1"/>
    <field name="staticpressure" editable="0"/>
    <field name="streetname" editable="1"/>
    <field name="streetname2" editable="1"/>
    <field name="svg" editable="1"/>
    <field name="sys_type" editable="0"/>
    <field name="tstamp" editable="1"/>
    <field name="undelete" editable="1"/>
    <field name="verified" editable="1"/>
    <field name="workcat_id" editable="1"/>
    <field name="workcat_id_end" editable="1"/>
    <field name="workcat_id_plan" editable="1"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="access_type"/>
    <field labelOnTop="0" name="accessibility"/>
    <field labelOnTop="0" name="adate"/>
    <field labelOnTop="0" name="adescript"/>
    <field labelOnTop="0" name="annotation"/>
    <field labelOnTop="0" name="arc_id"/>
    <field labelOnTop="0" name="asset_id"/>
    <field labelOnTop="0" name="broken_valve"/>
    <field labelOnTop="0" name="buildercat_id"/>
    <field labelOnTop="0" name="builtdate"/>
    <field labelOnTop="0" name="cat_dnom"/>
    <field labelOnTop="0" name="cat_matcat_id"/>
    <field labelOnTop="0" name="cat_pnom"/>
    <field labelOnTop="0" name="category_type"/>
    <field labelOnTop="0" name="closed_valve"/>
    <field labelOnTop="0" name="code"/>
    <field labelOnTop="0" name="comment"/>
    <field labelOnTop="0" name="conserv_state"/>
    <field labelOnTop="0" name="demand_avg"/>
    <field labelOnTop="0" name="demand_max"/>
    <field labelOnTop="0" name="demand_min"/>
    <field labelOnTop="0" name="depth"/>
    <field labelOnTop="0" name="descript"/>
    <field labelOnTop="0" name="district_id"/>
    <field labelOnTop="0" name="dma_id"/>
    <field labelOnTop="0" name="dma_name"/>
    <field labelOnTop="0" name="dma_style"/>
    <field labelOnTop="0" name="dqa_id"/>
    <field labelOnTop="0" name="dqa_name"/>
    <field labelOnTop="0" name="elevation"/>
    <field labelOnTop="0" name="enddate"/>
    <field labelOnTop="0" name="epa_type"/>
    <field labelOnTop="0" name="expl_id"/>
    <field labelOnTop="0" name="expl_id2"/>
    <field labelOnTop="0" name="fluid_type"/>
    <field labelOnTop="0" name="function_type"/>
    <field labelOnTop="0" name="head_avg"/>
    <field labelOnTop="0" name="head_max"/>
    <field labelOnTop="0" name="head_min"/>
    <field labelOnTop="0" name="hemisphere"/>
    <field labelOnTop="0" name="insert_user"/>
    <field labelOnTop="0" name="inventory"/>
    <field labelOnTop="0" name="is_operative"/>
    <field labelOnTop="0" name="label"/>
    <field labelOnTop="0" name="label_rotation"/>
    <field labelOnTop="0" name="label_x"/>
    <field labelOnTop="0" name="label_y"/>
    <field labelOnTop="0" name="lastupdate"/>
    <field labelOnTop="0" name="lastupdate_user"/>
    <field labelOnTop="0" name="link"/>
    <field labelOnTop="0" name="location_type"/>
    <field labelOnTop="0" name="macrodma_id"/>
    <field labelOnTop="0" name="macrodqa_id"/>
    <field labelOnTop="0" name="macroexpl_id"/>
    <field labelOnTop="0" name="macrosector_id"/>
    <field labelOnTop="0" name="minsector_id"/>
    <field labelOnTop="0" name="muni_id"/>
    <field labelOnTop="0" name="node_id"/>
    <field labelOnTop="0" name="node_type"/>
    <field labelOnTop="0" name="nodecat_id"/>
    <field labelOnTop="0" name="nodetype_id"/>
    <field labelOnTop="0" name="num_value"/>
    <field labelOnTop="0" name="observ"/>
    <field labelOnTop="0" name="om_state"/>
    <field labelOnTop="0" name="ownercat_id"/>
    <field labelOnTop="0" name="parent_id"/>
    <field labelOnTop="0" name="placement_type"/>
    <field labelOnTop="0" name="postcode"/>
    <field labelOnTop="0" name="postcomplement"/>
    <field labelOnTop="0" name="postcomplement2"/>
    <field labelOnTop="0" name="postnumber"/>
    <field labelOnTop="0" name="postnumber2"/>
    <field labelOnTop="0" name="press_avg"/>
    <field labelOnTop="0" name="press_max"/>
    <field labelOnTop="0" name="press_min"/>
    <field labelOnTop="0" name="presszone_id"/>
    <field labelOnTop="0" name="presszone_name"/>
    <field labelOnTop="0" name="presszone_style"/>
    <field labelOnTop="0" name="province_id"/>
    <field labelOnTop="0" name="publish"/>
    <field labelOnTop="0" name="quality_avg"/>
    <field labelOnTop="0" name="quality_max"/>
    <field labelOnTop="0" name="quality_min"/>
    <field labelOnTop="0" name="region_id"/>
    <field labelOnTop="0" name="rotation"/>
    <field labelOnTop="0" name="sector_id"/>
    <field labelOnTop="0" name="sector_name"/>
    <field labelOnTop="0" name="soilcat_id"/>
    <field labelOnTop="0" name="state"/>
    <field labelOnTop="0" name="state_type"/>
    <field labelOnTop="0" name="staticpressure"/>
    <field labelOnTop="0" name="streetname"/>
    <field labelOnTop="0" name="streetname2"/>
    <field labelOnTop="0" name="svg"/>
    <field labelOnTop="0" name="sys_type"/>
    <field labelOnTop="0" name="tstamp"/>
    <field labelOnTop="0" name="undelete"/>
    <field labelOnTop="0" name="verified"/>
    <field labelOnTop="0" name="workcat_id"/>
    <field labelOnTop="0" name="workcat_id_end"/>
    <field labelOnTop="0" name="workcat_id_plan"/>
  </labelOnTop>
  <reuseLastValue>
    <field name="access_type" reuseLastValue="0"/>
    <field name="accessibility" reuseLastValue="0"/>
    <field name="adate" reuseLastValue="0"/>
    <field name="adescript" reuseLastValue="0"/>
    <field name="annotation" reuseLastValue="0"/>
    <field name="arc_id" reuseLastValue="0"/>
    <field name="asset_id" reuseLastValue="0"/>
    <field name="broken_valve" reuseLastValue="0"/>
    <field name="buildercat_id" reuseLastValue="0"/>
    <field name="builtdate" reuseLastValue="0"/>
    <field name="cat_dnom" reuseLastValue="0"/>
    <field name="cat_matcat_id" reuseLastValue="0"/>
    <field name="cat_pnom" reuseLastValue="0"/>
    <field name="category_type" reuseLastValue="0"/>
    <field name="closed_valve" reuseLastValue="0"/>
    <field name="code" reuseLastValue="0"/>
    <field name="comment" reuseLastValue="0"/>
    <field name="conserv_state" reuseLastValue="0"/>
    <field name="demand_avg" reuseLastValue="0"/>
    <field name="demand_max" reuseLastValue="0"/>
    <field name="demand_min" reuseLastValue="0"/>
    <field name="depth" reuseLastValue="0"/>
    <field name="descript" reuseLastValue="0"/>
    <field name="district_id" reuseLastValue="0"/>
    <field name="dma_id" reuseLastValue="0"/>
    <field name="dma_name" reuseLastValue="0"/>
    <field name="dma_style" reuseLastValue="0"/>
    <field name="dqa_id" reuseLastValue="0"/>
    <field name="dqa_name" reuseLastValue="0"/>
    <field name="elevation" reuseLastValue="0"/>
    <field name="enddate" reuseLastValue="0"/>
    <field name="epa_type" reuseLastValue="0"/>
    <field name="expl_id" reuseLastValue="0"/>
    <field name="expl_id2" reuseLastValue="0"/>
    <field name="fluid_type" reuseLastValue="0"/>
    <field name="function_type" reuseLastValue="0"/>
    <field name="head_avg" reuseLastValue="0"/>
    <field name="head_max" reuseLastValue="0"/>
    <field name="head_min" reuseLastValue="0"/>
    <field name="hemisphere" reuseLastValue="0"/>
    <field name="insert_user" reuseLastValue="0"/>
    <field name="inventory" reuseLastValue="0"/>
    <field name="is_operative" reuseLastValue="0"/>
    <field name="label" reuseLastValue="0"/>
    <field name="label_rotation" reuseLastValue="0"/>
    <field name="label_x" reuseLastValue="0"/>
    <field name="label_y" reuseLastValue="0"/>
    <field name="lastupdate" reuseLastValue="0"/>
    <field name="lastupdate_user" reuseLastValue="0"/>
    <field name="link" reuseLastValue="0"/>
    <field name="location_type" reuseLastValue="0"/>
    <field name="macrodma_id" reuseLastValue="0"/>
    <field name="macrodqa_id" reuseLastValue="0"/>
    <field name="macroexpl_id" reuseLastValue="0"/>
    <field name="macrosector_id" reuseLastValue="0"/>
    <field name="minsector_id" reuseLastValue="0"/>
    <field name="muni_id" reuseLastValue="0"/>
    <field name="node_id" reuseLastValue="0"/>
    <field name="node_type" reuseLastValue="0"/>
    <field name="nodecat_id" reuseLastValue="0"/>
    <field name="nodetype_id" reuseLastValue="0"/>
    <field name="num_value" reuseLastValue="0"/>
    <field name="observ" reuseLastValue="0"/>
    <field name="om_state" reuseLastValue="0"/>
    <field name="ownercat_id" reuseLastValue="0"/>
    <field name="parent_id" reuseLastValue="0"/>
    <field name="placement_type" reuseLastValue="0"/>
    <field name="postcode" reuseLastValue="0"/>
    <field name="postcomplement" reuseLastValue="0"/>
    <field name="postcomplement2" reuseLastValue="0"/>
    <field name="postnumber" reuseLastValue="0"/>
    <field name="postnumber2" reuseLastValue="0"/>
    <field name="press_avg" reuseLastValue="0"/>
    <field name="press_max" reuseLastValue="0"/>
    <field name="press_min" reuseLastValue="0"/>
    <field name="presszone_id" reuseLastValue="0"/>
    <field name="presszone_name" reuseLastValue="0"/>
    <field name="presszone_style" reuseLastValue="0"/>
    <field name="province_id" reuseLastValue="0"/>
    <field name="publish" reuseLastValue="0"/>
    <field name="quality_avg" reuseLastValue="0"/>
    <field name="quality_max" reuseLastValue="0"/>
    <field name="quality_min" reuseLastValue="0"/>
    <field name="region_id" reuseLastValue="0"/>
    <field name="rotation" reuseLastValue="0"/>
    <field name="sector_id" reuseLastValue="0"/>
    <field name="sector_name" reuseLastValue="0"/>
    <field name="soilcat_id" reuseLastValue="0"/>
    <field name="state" reuseLastValue="0"/>
    <field name="state_type" reuseLastValue="0"/>
    <field name="staticpressure" reuseLastValue="0"/>
    <field name="streetname" reuseLastValue="0"/>
    <field name="streetname2" reuseLastValue="0"/>
    <field name="svg" reuseLastValue="0"/>
    <field name="sys_type" reuseLastValue="0"/>
    <field name="tstamp" reuseLastValue="0"/>
    <field name="undelete" reuseLastValue="0"/>
    <field name="verified" reuseLastValue="0"/>
    <field name="workcat_id" reuseLastValue="0"/>
    <field name="workcat_id_end" reuseLastValue="0"/>
    <field name="workcat_id_plan" reuseLastValue="0"/>
  </reuseLastValue>
  <dataDefinedFieldProperties/>
  <widgets/>
  <previewExpression>"node_id"</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>0</layerGeometryType>
</qgis>
'
WHERE id = 204;