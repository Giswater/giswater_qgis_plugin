/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.7-Bratislava" styleCategories="Symbology">
 <renderer-v2 enableorderby="0" symbollevels="0" type="categorizedSymbol" forceraster="0" referencescale="-1" attr="state">
  <categories>
   <category symbol="0" uuid="{80823eb1-ba4e-4517-8d07-82b656725f9b}" type="double" value="0" label="OBSOLETE" render="true"/>
   <category symbol="1" uuid="{718813e6-c212-4d14-b2d5-b98922743e2c}" type="string" value="1" label="OPERATIVE" render="true"/>
   <category symbol="2" uuid="{f2a68c83-ffba-48c2-9142-acb8ab246deb}" type="double" value="2" label="PLANIFIED" render="true"/>
  </categories>
  <symbols>
   <symbol alpha="1" is_animated="0" type="line" name="0" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@0@1" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="0.36"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol alpha="1" is_animated="0" type="line" name="1" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{7684a725-426f-47d3-859a-9e4bb0b9a024}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="219,219,219,0,hsv:0,0,0.86047150377660797,0"/>
      <Option type="QString" name="line_style" value="dot"/>
      <Option type="QString" name="line_width" value="0.3"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineColor">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when initoverflowpath = true then color_rgba(255,255,255,200) else color_rgba(100,100,100,0) end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.1 + 0.415 * ln((cat_geom1*cat_geom2) + 0.10)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.1 + 0.415 * ln((3.14*cat_geom1*cat_geom1/2) + 0.10)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@1@2" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="2.56"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1500 THEN 3.0 &#xd;&#xa;WHEN @map_scale  > 1500 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol alpha="1" is_animated="0" type="line" name="2" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="case when cat_geom2 > 0.5 and cat_geom <50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@2@1" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="255,127,0,255,rgb:1,0.49803921568627452,0,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="0.36"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol alpha="1" is_animated="0" type="line" name="0" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{3803a869-1bdf-438a-bb5c-37d3f352e512}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
      <Option type="QString" name="line_style" value="solid"/>
      <Option type="QString" name="line_width" value="0.36"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer locked="0" pass="0" id="{737b3486-832c-473a-a370-2cfc286e6e75}" enabled="1" class="MarkerLine">
     <Option type="Map">
      <Option type="QString" name="average_angle_length" value="4"/>
      <Option type="QString" name="average_angle_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="average_angle_unit" value="MM"/>
      <Option type="QString" name="interval" value="3"/>
      <Option type="QString" name="interval_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="interval_unit" value="MM"/>
      <Option type="QString" name="offset" value="0"/>
      <Option type="QString" name="offset_along_line" value="0"/>
      <Option type="QString" name="offset_along_line_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_along_line_unit" value="MM"/>
      <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
      <Option type="QString" name="offset_unit" value="MM"/>
      <Option type="bool" name="place_on_every_part" value="true"/>
      <Option type="QString" name="placements" value="CentralPoint"/>
      <Option type="QString" name="ring_filter" value="0"/>
      <Option type="QString" name="rotate" value="1"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option type="bool" name="active" value="true"/>
         <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END"/>
         <Option type="int" name="type" value="3"/>
        </Option>
       </Option>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" is_animated="0" type="marker" name="@0@1" clip_to_extent="1" force_rhr="0" frame_rate="10">
      <data_defined_properties>
       <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
       </Option>
      </data_defined_properties>
      <layer locked="0" pass="0" id="{48a00b63-2aee-4e04-a1cf-ef06d7691b80}" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option type="QString" name="angle" value="0"/>
        <Option type="QString" name="cap_style" value="square"/>
        <Option type="QString" name="color" value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1"/>
        <Option type="QString" name="horizontal_anchor_point" value="1"/>
        <Option type="QString" name="joinstyle" value="bevel"/>
        <Option type="QString" name="name" value="filled_arrowhead"/>
        <Option type="QString" name="offset" value="0,0"/>
        <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="offset_unit" value="MM"/>
        <Option type="QString" name="outline_color" value="0,0,0,255,rgb:0,0,0,1"/>
        <Option type="QString" name="outline_style" value="solid"/>
        <Option type="QString" name="outline_width" value="0"/>
        <Option type="QString" name="outline_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="outline_width_unit" value="MM"/>
        <Option type="QString" name="scale_method" value="diameter"/>
        <Option type="QString" name="size" value="0.36"/>
        <Option type="QString" name="size_map_unit_scale" value="3x:0,0,0,0,0,0"/>
        <Option type="QString" name="size_unit" value="MM"/>
        <Option type="QString" name="vertical_anchor_point" value="1"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option type="QString" name="name" value=""/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option type="bool" name="active" value="true"/>
           <Option type="QString" name="expression" value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END"/>
           <Option type="int" name="type" value="3"/>
          </Option>
         </Option>
         <Option type="QString" name="type" value="collection"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </source-symbol>
  <rotation/>
  <sizescale/>
  <data-defined-properties>
   <Option type="Map">
    <Option type="QString" name="name" value=""/>
    <Option name="properties"/>
    <Option type="QString" name="type" value="collection"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol alpha="1" is_animated="0" type="line" name="" clip_to_extent="1" force_rhr="0" frame_rate="10">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" name="name" value=""/>
      <Option name="properties"/>
      <Option type="QString" name="type" value="collection"/>
     </Option>
    </data_defined_properties>
    <layer locked="0" pass="0" id="{3eade21d-240a-43fc-8947-ccec8cc9a73f}" enabled="1" class="SimpleLine">
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
      <Option type="QString" name="line_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" name="name" value=""/>
       <Option name="properties"/>
       <Option type="QString" name="type" value="collection"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE layername = 've_arc' AND styleconfig_id=101;