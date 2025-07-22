/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



update sys_style set stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" readOnly="0" maxScale="0" simplifyDrawingTol="1" simplifyAlgorithm="0" symbologyReferenceScale="-1" version="3.28.5-Firenze" styleCategories="AllStyleCategories" minScale="0" labelsEnabled="1" simplifyLocal="1" simplifyDrawingHints="1">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" endField="" fixedDuration="0" mode="0" startExpression="" enabled="0" endExpression="" durationField="" accumulate="0" durationUnit="min" startField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation binding="Centroid" showMarkerSymbolInSurfacePlots="0" zoffset="0" symbology="Line" extrusionEnabled="0" respectLayerSymbol="1" zscale="1" extrusion="0" clamping="Terrain" type="IndividualFeatures">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
      <Option value="225,89,137,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.6" name="line_width" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="fill" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleFill">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
      <Option value="225,89,137,255" name="color" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="161,64,98,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="solid" name="style" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="225,89,137,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="diamond" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="161,64,98,255" name="outline_color" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 forceraster="0" type="RuleRenderer" enableorderby="0" symbollevels="0" referencescale="-1">
  <rules key="{b8c29f9a-2182-4e01-bcea-1687a6a41b0d}">
   <rule symbol="0" label="PIPE" key="{4d314a8c-24ee-482e-841d-8aa27d5ca772}" filter="&quot;inp_type&quot; = ''PIPE''"/>
   <rule symbol="1" label="VIRTUALPUMP" key="{921510fd-6923-4853-bb07-46f67356dd71}" filter="&quot;inp_type&quot; = ''VIRTUALPUMP''"/>
   <rule symbol="2" label="VIRTUALVALVE" key="{bb6e6bf4-12b0-4337-b08a-1753a74e27fd}" filter="&quot;inp_type&quot; = ''VIRTUALVALVE''"/>
   <rule symbol="3" label="NOT USED" key="{a29214e4-605a-4928-913f-0c7bf0d499f4}" filter="&quot;inp_type&quot; IS NULL"/>
  </rules>
  <symbols>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
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
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@1@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
      <layer pass="0" locked="0" enabled="1" class="FontMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="P" name="chr" type="QString"/>
        <Option value="255,255,255,255" name="color" type="QString"/>
        <Option value="MS Shell Dlg 2" name="font" type="QString"/>
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
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="2" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="MarkerLine">
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
      <Option value="true" name="place_on_every_part" type="bool"/>
      <Option value="CentralPoint" name="placements" type="QString"/>
      <Option value="0" name="ring_filter" type="QString"/>
      <Option value="1" name="rotate" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@2@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
       <data_defined_properties>
        <Option type="Map">
         <Option value="" name="name" type="QString"/>
         <Option name="properties"/>
         <Option value="collection" name="type" type="QString"/>
        </Option>
       </data_defined_properties>
      </layer>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="3" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
      <Option value="206,206,206,255" name="line_color" type="QString"/>
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
 </renderer-v2>
 <labeling type="rule-based">
  <rules key="{adcec219-b153-48bd-8a0d-a25cc3d481e7}">
   <rule key="{3116a9f4-7bc5-4b03-b909-9eceb2e3491a}" filter="&quot;inp_type&quot; IS NOT NULL">
    <settings calloutType="simple">
     <text-style textColor="0,0,0,255" fontLetterSpacing="0" fieldName="arccat_id" textOrientation="horizontal" allowHtml="0" fontFamily="MS Shell Dlg 2" blendMode="0" fontSizeMapUnitScale="3x:0,0,0,0,0,0" legendString="Aa" fontWeight="50" namedStyle="Normal" fontStrikeout="0" textOpacity="1" fontUnderline="0" fontSizeUnit="Point" useSubstitutions="0" fontKerning="1" forcedBold="0" forcedItalic="0" fontSize="8" fontItalic="0" fontWordSpacing="0" multilineHeight="1" capitalization="0" multilineHeightUnit="Percentage" previewBkgrdColor="255,255,255,255" isExpression="0">
      <families/>
      <text-buffer bufferSizeUnits="MM" bufferJoinStyle="128" bufferBlendMode="0" bufferNoFill="1" bufferColor="255,255,255,255" bufferSizeMapUnitScale="3x:0,0,0,0,0,0" bufferSize="1" bufferDraw="0" bufferOpacity="1"/>
      <text-mask maskedSymbolLayers="" maskSizeMapUnitScale="3x:0,0,0,0,0,0" maskOpacity="1" maskJoinStyle="128" maskEnabled="0" maskSizeUnits="MM" maskType="0" maskSize="0"/>
      <background shapeRotationType="0" shapeFillColor="255,255,255,255" shapeBorderWidthUnit="MM" shapeSizeX="0" shapeSizeUnit="MM" shapeBorderColor="128,128,128,255" shapeOpacity="1" shapeBorderWidthMapUnitScale="3x:0,0,0,0,0,0" shapeSizeY="0" shapeBorderWidth="0" shapeRadiiMapUnitScale="3x:0,0,0,0,0,0" shapeSVGFile="" shapeDraw="0" shapeRadiiX="0" shapeSizeType="0" shapeOffsetX="0" shapeJoinStyle="64" shapeOffsetUnit="MM" shapeType="0" shapeRadiiY="0" shapeRotation="0" shapeOffsetY="0" shapeOffsetMapUnitScale="3x:0,0,0,0,0,0" shapeRadiiUnit="MM" shapeBlendMode="0" shapeSizeMapUnitScale="3x:0,0,0,0,0,0">
       <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="markerSymbol" type="marker" force_rhr="0" alpha="1">
        <data_defined_properties>
         <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
         </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
         <data_defined_properties>
          <Option type="Map">
           <Option value="" name="name" type="QString"/>
           <Option name="properties"/>
           <Option value="collection" name="type" type="QString"/>
          </Option>
         </data_defined_properties>
        </layer>
       </symbol>
       <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="fillSymbol" type="fill" force_rhr="0" alpha="1">
        <data_defined_properties>
         <Option type="Map">
          <Option value="" name="name" type="QString"/>
          <Option name="properties"/>
          <Option value="collection" name="type" type="QString"/>
         </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" class="SimpleFill">
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
      <shadow shadowRadiusAlphaOnly="0" shadowColor="0,0,0,255" shadowBlendMode="6" shadowOffsetAngle="135" shadowOffsetUnit="MM" shadowDraw="0" shadowOffsetMapUnitScale="3x:0,0,0,0,0,0" shadowScale="100" shadowRadiusUnit="MM" shadowOffsetGlobal="1" shadowOpacity="0.69999999999999996" shadowRadiusMapUnitScale="3x:0,0,0,0,0,0" shadowUnder="0" shadowRadius="1.5" shadowOffsetDist="1"/>
      <dd_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </dd_properties>
      <substitutions/>
     </text-style>
     <text-format addDirectionSymbol="0" useMaxLineLengthForAutoWrap="1" placeDirectionSymbol="0" rightDirectionSymbol=">" wrapChar="" decimals="3" formatNumbers="0" plussign="0" leftDirectionSymbol="&lt;" autoWrapLength="0" multilineAlign="0" reverseDirectionSymbol="0"/>
     <placement overrunDistanceMapUnitScale="3x:0,0,0,0,0,0" centroidInside="0" lineAnchorPercent="0.5" fitInPolygonOnly="0" xOffset="0" maxCurvedCharAngleIn="25" placement="2" priority="5" maxCurvedCharAngleOut="-25" dist="0" lineAnchorTextPoint="CenterOfText" allowDegraded="0" layerType="LineGeometry" geometryGenerator="" distUnits="MM" distMapUnitScale="3x:0,0,0,0,0,0" overrunDistance="0" yOffset="0" rotationAngle="0" repeatDistance="0" repeatDistanceUnits="MM" rotationUnit="AngleDegrees" lineAnchorType="0" lineAnchorClipping="0" offsetType="0" centroidWhole="0" quadOffset="4" repeatDistanceMapUnitScale="3x:0,0,0,0,0,0" preserveRotation="1" geometryGeneratorType="PointGeometry" polygonPlacementFlags="2" placementFlags="10" labelOffsetMapUnitScale="3x:0,0,0,0,0,0" geometryGeneratorEnabled="0" offsetUnits="MM" predefinedPositionOrder="TR,TL,BR,BL,R,L,TSR,BSR" overlapHandling="PreventOverlap" overrunDistanceUnit="MM"/>
     <rendering minFeatureSize="0" scaleMax="1000" fontMaxPixelSize="10000" labelPerPart="0" scaleVisibility="1" drawLabels="1" upsidedownLabels="0" unplacedVisibility="0" obstacleFactor="1" mergeLines="0" limitNumLabels="0" scaleMin="0" maxNumLabels="2000" obstacle="1" obstacleType="0" fontLimitPixelSize="0" fontMinPixelSize="3" zIndex="0"/>
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
       <Option value="&lt;symbol clip_to_extent=&quot;1&quot; is_animated=&quot;0&quot; frame_rate=&quot;10&quot; name=&quot;symbol&quot; type=&quot;line&quot; force_rhr=&quot;0&quot; alpha=&quot;1&quot;>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;layer pass=&quot;0&quot; locked=&quot;0&quot; enabled=&quot;1&quot; class=&quot;SimpleLine&quot;>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;0&quot; name=&quot;align_dash_pattern&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;square&quot; name=&quot;capstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;5;2&quot; name=&quot;customdash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;customdash_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;customdash_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;dash_pattern_offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;dash_pattern_offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;dash_pattern_offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;draw_inside_polygon&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;bevel&quot; name=&quot;joinstyle&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;60,60,60,255&quot; name=&quot;line_color&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;solid&quot; name=&quot;line_style&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0.3&quot; name=&quot;line_width&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;line_width_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;offset&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;offset_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;offset_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;ring_filter&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_end&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_end_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_end_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;trim_distance_start&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;trim_distance_start_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;MM&quot; name=&quot;trim_distance_start_unit&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;tweak_dash_pattern_on_corners&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;0&quot; name=&quot;use_custom_dash&quot; type=&quot;QString&quot;/>&lt;Option value=&quot;3x:0,0,0,0,0,0&quot; name=&quot;width_map_unit_scale&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;data_defined_properties>&lt;Option type=&quot;Map&quot;>&lt;Option value=&quot;&quot; name=&quot;name&quot; type=&quot;QString&quot;/>&lt;Option name=&quot;properties&quot;/>&lt;Option value=&quot;collection&quot; name=&quot;type&quot; type=&quot;QString&quot;/>&lt;/Option>&lt;/data_defined_properties>&lt;/layer>&lt;/symbol>" name="lineSymbol" type="QString"/>
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
   </rule>
  </rules>
 </labeling>
 <customproperties>
  <Option type="Map">
   <Option name="dualview/previewExpressions" type="List">
    <Option value="&quot;arc_id&quot;" type="QString"/>
   </Option>
   <Option value="0" name="embeddedWidgets/count" type="QString"/>
   <Option name="variableNames"/>
   <Option name="variableValues"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory barWidth="5" showAxis="1" sizeType="MM" lineSizeType="MM" lineSizeScale="3x:0,0,0,0,0,0" scaleDependency="Area" width="15" backgroundAlpha="255" penColor="#000000" height="15" diagramOrientation="Up" penWidth="0" labelPlacementMethod="XHeight" scaleBasedVisibility="0" spacingUnit="MM" spacingUnitScale="3x:0,0,0,0,0,0" minimumSize="0" rotationOffset="270" penAlpha="255" minScaleDenominator="0" spacing="5" backgroundColor="#ffffff" opacity="1" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="0" enabled="0" direction="0">
   <fontProperties strikethrough="0" italic="0" underline="0" bold="0" description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style=""/>
   <axisSymbol>
    <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
 <DiagramLayerSettings linePlacementFlags="18" obstacle="0" placement="2" dist="0" priority="0" showAll="1" zIndex="0">
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
  <field name="nodetype_1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
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
  <field name="staticpress1" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
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
  <field name="depth" configurationFlags="None">
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
  <field name="cat_dint" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="sector_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="presszone_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="presszone_head" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="dma_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="dqa_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="soilcat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
  <field name="workcat_id_plan" configurationFlags="None">
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
  <field name="region_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
       <Option value="1" name="Barcelona" type="QString"/>
      </Option>
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
       <Option value="" name="" type="QString"/>
       <Option value="2" name="IGNORE CHECK" type="QString"/>
       <Option value="0" name="TO REVIEW" type="QString"/>
       <Option value="1" name="VERIFIED" type="QString"/>
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
  <field name="label_quadrant" configurationFlags="None">
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
  <field name="brand_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="model_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="serial_number" configurationFlags="None">
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
  <field name="macrominsector_id" configurationFlags="None">
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
  <field name="inp_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
 </fieldConfiguration>
 <aliases>
  <alias field="arc_id" index="0" name="arc_id"/>
  <alias field="code" index="1" name="code"/>
  <alias field="node_1" index="2" name="node_1"/>
  <alias field="nodetype_1" index="3" name="nodetype_1"/>
  <alias field="elevation1" index="4" name="elevation1"/>
  <alias field="depth1" index="5" name="depth1"/>
  <alias field="staticpress1" index="6" name="staticpressure1"/>
  <alias field="node_2" index="7" name="node_2"/>
  <alias field="nodetype_2" index="8" name="nodetype_2"/>
  <alias field="staticpress2" index="9" name="staticpressure2"/>
  <alias field="elevation2" index="10" name="elevation2"/>
  <alias field="depth2" index="11" name="depth2"/>
  <alias field="depth" index="12" name="Depth"/>
  <alias field="arccat_id" index="13" name="arccat_id"/>
  <alias field="arc_type" index="14" name="arc_type"/>
  <alias field="sys_type" index="15" name="sys_type"/>
  <alias field="cat_matcat_id" index="16" name="cat_matcat_id"/>
  <alias field="cat_pnom" index="17" name="cat_pnom"/>
  <alias field="cat_dnom" index="18" name="cat_dnom"/>
  <alias field="cat_dint" index="19" name=""/>
  <alias field="epa_type" index="20" name="epa type"/>
  <alias field="state" index="21" name="state"/>
  <alias field="state_type" index="22" name="state type"/>
  <alias field="expl_id" index="23" name="exploitation"/>
  <alias field="macroexpl_id" index="24" name="Macroexploitation"/>
  <alias field="sector_id" index="25" name="sector"/>
  <alias field="sector_name" index="26" name="Sector name"/>
  <alias field="macrosector_id" index="27" name="macrosector"/>
  <alias field="sector_type" index="28" name=""/>
  <alias field="presszone_id" index="29" name="Presszone"/>
  <alias field="presszone_name" index="30" name=""/>
  <alias field="presszone_type" index="31" name=""/>
  <alias field="presszone_head" index="32" name=""/>
  <alias field="dma_id" index="33" name="dma"/>
  <alias field="dma_name" index="34" name="Dma name"/>
  <alias field="dma_type" index="35" name=""/>
  <alias field="macrodma_id" index="36" name="macrodma_id"/>
  <alias field="dqa_id" index="37" name="Dqa"/>
  <alias field="dqa_name" index="38" name="Dqa name"/>
  <alias field="dqa_type" index="39" name=""/>
  <alias field="macrodqa_id" index="40" name="macrodqa_id"/>
  <alias field="annotation" index="41" name="annotation"/>
  <alias field="observ" index="42" name="observ"/>
  <alias field="comment" index="43" name="comment"/>
  <alias field="gis_length" index="44" name="gis_length"/>
  <alias field="custom_length" index="45" name="custom_length"/>
  <alias field="soilcat_id" index="46" name="soilcat_id"/>
  <alias field="function_type" index="47" name="function_type"/>
  <alias field="category_type" index="48" name="category_type"/>
  <alias field="fluid_type" index="49" name="fluid_type"/>
  <alias field="location_type" index="50" name="location_type"/>
  <alias field="workcat_id" index="51" name="work_id"/>
  <alias field="workcat_id_end" index="52" name="Work id end"/>
  <alias field="workcat_id_plan" index="53" name="workcat_id_plan"/>
  <alias field="buildercat_id" index="54" name="builder"/>
  <alias field="builtdate" index="55" name="builtdate"/>
  <alias field="enddate" index="56" name="enddate"/>
  <alias field="ownercat_id" index="57" name="owner"/>
  <alias field="muni_id" index="58" name="municipality"/>
  <alias field="postcode" index="59" name="postcode"/>
  <alias field="district_id" index="60" name="district"/>
  <alias field="streetname" index="61" name="streetname"/>
  <alias field="postnumber" index="62" name="postnumber"/>
  <alias field="postcomplement" index="63" name="postcomplement"/>
  <alias field="streetname2" index="64" name="streetname2"/>
  <alias field="postnumber2" index="65" name="postnumber2"/>
  <alias field="postcomplement2" index="66" name="postcomplement2"/>
  <alias field="region_id" index="67" name="Region"/>
  <alias field="province_id" index="68" name="Province"/>
  <alias field="descript" index="69" name="descript"/>
  <alias field="link" index="70" name="link"/>
  <alias field="verified" index="71" name="verified"/>
  <alias field="undelete" index="72" name="undelete"/>
  <alias field="label" index="73" name="Catalog label"/>
  <alias field="label_x" index="74" name="label_x"/>
  <alias field="label_y" index="75" name="label_y"/>
  <alias field="label_rotation" index="76" name="label_rotation"/>
  <alias field="label_quadrant" index="77" name="label_quadrant"/>
  <alias field="publish" index="78" name="publish"/>
  <alias field="inventory" index="79" name="inventory"/>
  <alias field="num_value" index="80" name="num_value"/>
  <alias field="adate" index="81" name="Adate"/>
  <alias field="adescript" index="82" name="A descript"/>
  <alias field="dma_style" index="83" name="Dma color"/>
  <alias field="presszone_style" index="84" name="Presszone color"/>
  <alias field="asset_id" index="85" name="asset_id"/>
  <alias field="pavcat_id" index="86" name="pavcat_id"/>
  <alias field="om_state" index="87" name="om_state"/>
  <alias field="conserv_state" index="88" name="conserv_state"/>
  <alias field="parent_id" index="89" name="parent_id"/>
  <alias field="expl_id2" index="90" name="Exploitation 2"/>
  <alias field="is_operative" index="91" name=""/>
  <alias field="brand_id" index="92" name="brand_id"/>
  <alias field="model_id" index="93" name="model_id"/>
  <alias field="serial_number" index="94" name="serial_number"/>
  <alias field="minsector_id" index="95" name="minsector_id"/>
  <alias field="macrominsector_id" index="96" name="macrominsector_id"/>
  <alias field="flow_max" index="97" name=""/>
  <alias field="flow_min" index="98" name=""/>
  <alias field="flow_avg" index="99" name=""/>
  <alias field="vel_max" index="100" name=""/>
  <alias field="vel_min" index="101" name=""/>
  <alias field="vel_avg" index="102" name=""/>
  <alias field="tstamp" index="103" name="Insert tstamp"/>
  <alias field="insert_user" index="104" name=""/>
  <alias field="lastupdate" index="105" name="Last update"/>
  <alias field="lastupdate_user" index="106" name="Last update user"/>
  <alias field="inp_type" index="107" name=""/>
 </aliases>
 <defaults>
  <default field="arc_id" expression="" applyOnUpdate="0"/>
  <default field="code" expression="" applyOnUpdate="0"/>
  <default field="node_1" expression="" applyOnUpdate="0"/>
  <default field="nodetype_1" expression="" applyOnUpdate="0"/>
  <default field="elevation1" expression="" applyOnUpdate="0"/>
  <default field="depth1" expression="" applyOnUpdate="0"/>
  <default field="staticpress1" expression="" applyOnUpdate="0"/>
  <default field="node_2" expression="" applyOnUpdate="0"/>
  <default field="nodetype_2" expression="" applyOnUpdate="0"/>
  <default field="staticpress2" expression="" applyOnUpdate="0"/>
  <default field="elevation2" expression="" applyOnUpdate="0"/>
  <default field="depth2" expression="" applyOnUpdate="0"/>
  <default field="depth" expression="" applyOnUpdate="0"/>
  <default field="arccat_id" expression="" applyOnUpdate="0"/>
  <default field="arc_type" expression="" applyOnUpdate="0"/>
  <default field="sys_type" expression="" applyOnUpdate="0"/>
  <default field="cat_matcat_id" expression="" applyOnUpdate="0"/>
  <default field="cat_pnom" expression="" applyOnUpdate="0"/>
  <default field="cat_dnom" expression="" applyOnUpdate="0"/>
  <default field="cat_dint" expression="" applyOnUpdate="0"/>
  <default field="epa_type" expression="" applyOnUpdate="0"/>
  <default field="state" expression="" applyOnUpdate="0"/>
  <default field="state_type" expression="" applyOnUpdate="0"/>
  <default field="expl_id" expression="" applyOnUpdate="0"/>
  <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
  <default field="sector_id" expression="" applyOnUpdate="0"/>
  <default field="sector_name" expression="" applyOnUpdate="0"/>
  <default field="macrosector_id" expression="" applyOnUpdate="0"/>
  <default field="sector_type" expression="" applyOnUpdate="0"/>
  <default field="presszone_id" expression="" applyOnUpdate="0"/>
  <default field="presszone_name" expression="" applyOnUpdate="0"/>
  <default field="presszone_type" expression="" applyOnUpdate="0"/>
  <default field="presszone_head" expression="" applyOnUpdate="0"/>
  <default field="dma_id" expression="" applyOnUpdate="0"/>
  <default field="dma_name" expression="" applyOnUpdate="0"/>
  <default field="dma_type" expression="" applyOnUpdate="0"/>
  <default field="macrodma_id" expression="" applyOnUpdate="0"/>
  <default field="dqa_id" expression="" applyOnUpdate="0"/>
  <default field="dqa_name" expression="" applyOnUpdate="0"/>
  <default field="dqa_type" expression="" applyOnUpdate="0"/>
  <default field="macrodqa_id" expression="" applyOnUpdate="0"/>
  <default field="annotation" expression="" applyOnUpdate="0"/>
  <default field="observ" expression="" applyOnUpdate="0"/>
  <default field="comment" expression="" applyOnUpdate="0"/>
  <default field="gis_length" expression="" applyOnUpdate="0"/>
  <default field="custom_length" expression="" applyOnUpdate="0"/>
  <default field="soilcat_id" expression="" applyOnUpdate="0"/>
  <default field="function_type" expression="" applyOnUpdate="0"/>
  <default field="category_type" expression="" applyOnUpdate="0"/>
  <default field="fluid_type" expression="" applyOnUpdate="0"/>
  <default field="location_type" expression="" applyOnUpdate="0"/>
  <default field="workcat_id" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_plan" expression="" applyOnUpdate="0"/>
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
  <default field="region_id" expression="" applyOnUpdate="0"/>
  <default field="province_id" expression="" applyOnUpdate="0"/>
  <default field="descript" expression="" applyOnUpdate="0"/>
  <default field="link" expression="" applyOnUpdate="0"/>
  <default field="verified" expression="" applyOnUpdate="0"/>
  <default field="undelete" expression="" applyOnUpdate="0"/>
  <default field="label" expression="" applyOnUpdate="0"/>
  <default field="label_x" expression="" applyOnUpdate="0"/>
  <default field="label_y" expression="" applyOnUpdate="0"/>
  <default field="label_rotation" expression="" applyOnUpdate="0"/>
  <default field="label_quadrant" expression="" applyOnUpdate="0"/>
  <default field="publish" expression="" applyOnUpdate="0"/>
  <default field="inventory" expression="" applyOnUpdate="0"/>
  <default field="num_value" expression="" applyOnUpdate="0"/>
  <default field="adate" expression="" applyOnUpdate="0"/>
  <default field="adescript" expression="" applyOnUpdate="0"/>
  <default field="dma_style" expression="" applyOnUpdate="0"/>
  <default field="presszone_style" expression="" applyOnUpdate="0"/>
  <default field="asset_id" expression="" applyOnUpdate="0"/>
  <default field="pavcat_id" expression="" applyOnUpdate="0"/>
  <default field="om_state" expression="" applyOnUpdate="0"/>
  <default field="conserv_state" expression="" applyOnUpdate="0"/>
  <default field="parent_id" expression="" applyOnUpdate="0"/>
  <default field="expl_id2" expression="" applyOnUpdate="0"/>
  <default field="is_operative" expression="" applyOnUpdate="0"/>
  <default field="brand_id" expression="" applyOnUpdate="0"/>
  <default field="model_id" expression="" applyOnUpdate="0"/>
  <default field="serial_number" expression="" applyOnUpdate="0"/>
  <default field="minsector_id" expression="" applyOnUpdate="0"/>
  <default field="macrominsector_id" expression="" applyOnUpdate="0"/>
  <default field="flow_max" expression="" applyOnUpdate="0"/>
  <default field="flow_min" expression="" applyOnUpdate="0"/>
  <default field="flow_avg" expression="" applyOnUpdate="0"/>
  <default field="vel_max" expression="" applyOnUpdate="0"/>
  <default field="vel_min" expression="" applyOnUpdate="0"/>
  <default field="vel_avg" expression="" applyOnUpdate="0"/>
  <default field="tstamp" expression="" applyOnUpdate="0"/>
  <default field="insert_user" expression="" applyOnUpdate="0"/>
  <default field="lastupdate" expression="" applyOnUpdate="0"/>
  <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  <default field="inp_type" expression="" applyOnUpdate="0"/>
 </defaults>
 <constraints>
  <constraint field="arc_id" unique_strength="1" notnull_strength="1" exp_strength="0" constraints="3"/>
  <constraint field="code" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="node_1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="nodetype_1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="elevation1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="depth1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="staticpress1" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="node_2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="nodetype_2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="staticpress2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="elevation2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="depth2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="depth" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="arccat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="arc_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_matcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_pnom" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_dnom" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_dint" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="epa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macroexpl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrosector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_head" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodqa_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="annotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="observ" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="comment" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="gis_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="custom_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="soilcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="function_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="category_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="fluid_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="location_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_end" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_plan" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="buildercat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="builtdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="enddate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="ownercat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="muni_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcode" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="district_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="streetname" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postnumber" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcomplement" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="streetname2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postnumber2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcomplement2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="region_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="province_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="descript" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="link" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="verified" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="undelete" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_x" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_y" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_rotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_quadrant" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="publish" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inventory" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="num_value" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="adate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="adescript" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_style" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_style" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="asset_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="pavcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="om_state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="conserv_state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="parent_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="is_operative" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="brand_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="model_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="serial_number" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="minsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrominsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="flow_max" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="flow_min" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="flow_avg" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="vel_max" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="vel_min" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="vel_avg" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="tstamp" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="insert_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inp_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
 </constraints>
 <constraintExpressions>
  <constraint field="arc_id" desc="" exp=""/>
  <constraint field="code" desc="" exp=""/>
  <constraint field="node_1" desc="" exp=""/>
  <constraint field="nodetype_1" desc="" exp=""/>
  <constraint field="elevation1" desc="" exp=""/>
  <constraint field="depth1" desc="" exp=""/>
  <constraint field="staticpress1" desc="" exp=""/>
  <constraint field="node_2" desc="" exp=""/>
  <constraint field="nodetype_2" desc="" exp=""/>
  <constraint field="staticpress2" desc="" exp=""/>
  <constraint field="elevation2" desc="" exp=""/>
  <constraint field="depth2" desc="" exp=""/>
  <constraint field="depth" desc="" exp=""/>
  <constraint field="arccat_id" desc="" exp=""/>
  <constraint field="arc_type" desc="" exp=""/>
  <constraint field="sys_type" desc="" exp=""/>
  <constraint field="cat_matcat_id" desc="" exp=""/>
  <constraint field="cat_pnom" desc="" exp=""/>
  <constraint field="cat_dnom" desc="" exp=""/>
  <constraint field="cat_dint" desc="" exp=""/>
  <constraint field="epa_type" desc="" exp=""/>
  <constraint field="state" desc="" exp=""/>
  <constraint field="state_type" desc="" exp=""/>
  <constraint field="expl_id" desc="" exp=""/>
  <constraint field="macroexpl_id" desc="" exp=""/>
  <constraint field="sector_id" desc="" exp=""/>
  <constraint field="sector_name" desc="" exp=""/>
  <constraint field="macrosector_id" desc="" exp=""/>
  <constraint field="sector_type" desc="" exp=""/>
  <constraint field="presszone_id" desc="" exp=""/>
  <constraint field="presszone_name" desc="" exp=""/>
  <constraint field="presszone_type" desc="" exp=""/>
  <constraint field="presszone_head" desc="" exp=""/>
  <constraint field="dma_id" desc="" exp=""/>
  <constraint field="dma_name" desc="" exp=""/>
  <constraint field="dma_type" desc="" exp=""/>
  <constraint field="macrodma_id" desc="" exp=""/>
  <constraint field="dqa_id" desc="" exp=""/>
  <constraint field="dqa_name" desc="" exp=""/>
  <constraint field="dqa_type" desc="" exp=""/>
  <constraint field="macrodqa_id" desc="" exp=""/>
  <constraint field="annotation" desc="" exp=""/>
  <constraint field="observ" desc="" exp=""/>
  <constraint field="comment" desc="" exp=""/>
  <constraint field="gis_length" desc="" exp=""/>
  <constraint field="custom_length" desc="" exp=""/>
  <constraint field="soilcat_id" desc="" exp=""/>
  <constraint field="function_type" desc="" exp=""/>
  <constraint field="category_type" desc="" exp=""/>
  <constraint field="fluid_type" desc="" exp=""/>
  <constraint field="location_type" desc="" exp=""/>
  <constraint field="workcat_id" desc="" exp=""/>
  <constraint field="workcat_id_end" desc="" exp=""/>
  <constraint field="workcat_id_plan" desc="" exp=""/>
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
  <constraint field="region_id" desc="" exp=""/>
  <constraint field="province_id" desc="" exp=""/>
  <constraint field="descript" desc="" exp=""/>
  <constraint field="link" desc="" exp=""/>
  <constraint field="verified" desc="" exp=""/>
  <constraint field="undelete" desc="" exp=""/>
  <constraint field="label" desc="" exp=""/>
  <constraint field="label_x" desc="" exp=""/>
  <constraint field="label_y" desc="" exp=""/>
  <constraint field="label_rotation" desc="" exp=""/>
  <constraint field="label_quadrant" desc="" exp=""/>
  <constraint field="publish" desc="" exp=""/>
  <constraint field="inventory" desc="" exp=""/>
  <constraint field="num_value" desc="" exp=""/>
  <constraint field="adate" desc="" exp=""/>
  <constraint field="adescript" desc="" exp=""/>
  <constraint field="dma_style" desc="" exp=""/>
  <constraint field="presszone_style" desc="" exp=""/>
  <constraint field="asset_id" desc="" exp=""/>
  <constraint field="pavcat_id" desc="" exp=""/>
  <constraint field="om_state" desc="" exp=""/>
  <constraint field="conserv_state" desc="" exp=""/>
  <constraint field="parent_id" desc="" exp=""/>
  <constraint field="expl_id2" desc="" exp=""/>
  <constraint field="is_operative" desc="" exp=""/>
  <constraint field="brand_id" desc="" exp=""/>
  <constraint field="model_id" desc="" exp=""/>
  <constraint field="serial_number" desc="" exp=""/>
  <constraint field="minsector_id" desc="" exp=""/>
  <constraint field="macrominsector_id" desc="" exp=""/>
  <constraint field="flow_max" desc="" exp=""/>
  <constraint field="flow_min" desc="" exp=""/>
  <constraint field="flow_avg" desc="" exp=""/>
  <constraint field="vel_max" desc="" exp=""/>
  <constraint field="vel_min" desc="" exp=""/>
  <constraint field="vel_avg" desc="" exp=""/>
  <constraint field="tstamp" desc="" exp=""/>
  <constraint field="insert_user" desc="" exp=""/>
  <constraint field="lastupdate" desc="" exp=""/>
  <constraint field="lastupdate_user" desc="" exp=""/>
  <constraint field="inp_type" desc="" exp=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
  <columns>
   <column hidden="0" width="-1" name="arc_id" type="field"/>
   <column hidden="0" width="-1" name="code" type="field"/>
   <column hidden="0" width="-1" name="node_1" type="field"/>
   <column hidden="0" width="-1" name="nodetype_1" type="field"/>
   <column hidden="0" width="-1" name="elevation1" type="field"/>
   <column hidden="0" width="-1" name="depth1" type="field"/>
   <column hidden="0" width="-1" name="staticpress1" type="field"/>
   <column hidden="0" width="-1" name="node_2" type="field"/>
   <column hidden="0" width="-1" name="nodetype_2" type="field"/>
   <column hidden="0" width="-1" name="staticpress2" type="field"/>
   <column hidden="0" width="-1" name="elevation2" type="field"/>
   <column hidden="0" width="-1" name="depth2" type="field"/>
   <column hidden="0" width="-1" name="depth" type="field"/>
   <column hidden="0" width="-1" name="arccat_id" type="field"/>
   <column hidden="0" width="-1" name="arc_type" type="field"/>
   <column hidden="0" width="-1" name="sys_type" type="field"/>
   <column hidden="0" width="-1" name="cat_matcat_id" type="field"/>
   <column hidden="0" width="-1" name="cat_pnom" type="field"/>
   <column hidden="0" width="-1" name="cat_dnom" type="field"/>
   <column hidden="0" width="-1" name="cat_dint" type="field"/>
   <column hidden="0" width="-1" name="epa_type" type="field"/>
   <column hidden="0" width="-1" name="state" type="field"/>
   <column hidden="0" width="-1" name="state_type" type="field"/>
   <column hidden="0" width="-1" name="expl_id" type="field"/>
   <column hidden="0" width="-1" name="macroexpl_id" type="field"/>
   <column hidden="0" width="-1" name="sector_id" type="field"/>
   <column hidden="0" width="-1" name="sector_name" type="field"/>
   <column hidden="0" width="-1" name="macrosector_id" type="field"/>
   <column hidden="0" width="-1" name="sector_type" type="field"/>
   <column hidden="0" width="-1" name="presszone_id" type="field"/>
   <column hidden="0" width="-1" name="presszone_name" type="field"/>
   <column hidden="0" width="-1" name="presszone_type" type="field"/>
   <column hidden="0" width="-1" name="presszone_head" type="field"/>
   <column hidden="0" width="-1" name="dma_id" type="field"/>
   <column hidden="0" width="-1" name="dma_name" type="field"/>
   <column hidden="0" width="-1" name="dma_type" type="field"/>
   <column hidden="0" width="-1" name="macrodma_id" type="field"/>
   <column hidden="0" width="-1" name="dqa_id" type="field"/>
   <column hidden="0" width="-1" name="dqa_name" type="field"/>
   <column hidden="0" width="-1" name="dqa_type" type="field"/>
   <column hidden="0" width="-1" name="macrodqa_id" type="field"/>
   <column hidden="0" width="-1" name="annotation" type="field"/>
   <column hidden="0" width="-1" name="observ" type="field"/>
   <column hidden="0" width="-1" name="comment" type="field"/>
   <column hidden="0" width="-1" name="gis_length" type="field"/>
   <column hidden="0" width="-1" name="custom_length" type="field"/>
   <column hidden="0" width="-1" name="soilcat_id" type="field"/>
   <column hidden="0" width="-1" name="function_type" type="field"/>
   <column hidden="0" width="-1" name="category_type" type="field"/>
   <column hidden="0" width="-1" name="fluid_type" type="field"/>
   <column hidden="0" width="-1" name="location_type" type="field"/>
   <column hidden="0" width="-1" name="workcat_id" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_end" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_plan" type="field"/>
   <column hidden="0" width="-1" name="buildercat_id" type="field"/>
   <column hidden="0" width="-1" name="builtdate" type="field"/>
   <column hidden="0" width="-1" name="enddate" type="field"/>
   <column hidden="0" width="-1" name="ownercat_id" type="field"/>
   <column hidden="0" width="-1" name="muni_id" type="field"/>
   <column hidden="0" width="-1" name="postcode" type="field"/>
   <column hidden="0" width="-1" name="district_id" type="field"/>
   <column hidden="0" width="-1" name="streetname" type="field"/>
   <column hidden="0" width="-1" name="postnumber" type="field"/>
   <column hidden="0" width="-1" name="postcomplement" type="field"/>
   <column hidden="0" width="-1" name="streetname2" type="field"/>
   <column hidden="0" width="-1" name="postnumber2" type="field"/>
   <column hidden="0" width="-1" name="postcomplement2" type="field"/>
   <column hidden="0" width="-1" name="region_id" type="field"/>
   <column hidden="0" width="-1" name="province_id" type="field"/>
   <column hidden="0" width="-1" name="descript" type="field"/>
   <column hidden="0" width="-1" name="link" type="field"/>
   <column hidden="0" width="-1" name="verified" type="field"/>
   <column hidden="0" width="-1" name="undelete" type="field"/>
   <column hidden="0" width="-1" name="label" type="field"/>
   <column hidden="0" width="-1" name="label_x" type="field"/>
   <column hidden="0" width="-1" name="label_y" type="field"/>
   <column hidden="0" width="-1" name="label_rotation" type="field"/>
   <column hidden="0" width="-1" name="label_quadrant" type="field"/>
   <column hidden="0" width="-1" name="publish" type="field"/>
   <column hidden="0" width="-1" name="inventory" type="field"/>
   <column hidden="0" width="-1" name="num_value" type="field"/>
   <column hidden="0" width="-1" name="adate" type="field"/>
   <column hidden="0" width="-1" name="adescript" type="field"/>
   <column hidden="0" width="-1" name="dma_style" type="field"/>
   <column hidden="0" width="-1" name="presszone_style" type="field"/>
   <column hidden="0" width="-1" name="asset_id" type="field"/>
   <column hidden="0" width="-1" name="pavcat_id" type="field"/>
   <column hidden="0" width="-1" name="om_state" type="field"/>
   <column hidden="0" width="-1" name="conserv_state" type="field"/>
   <column hidden="0" width="-1" name="parent_id" type="field"/>
   <column hidden="0" width="-1" name="expl_id2" type="field"/>
   <column hidden="0" width="-1" name="is_operative" type="field"/>
   <column hidden="0" width="-1" name="brand_id" type="field"/>
   <column hidden="0" width="-1" name="model_id" type="field"/>
   <column hidden="0" width="-1" name="serial_number" type="field"/>
   <column hidden="0" width="-1" name="minsector_id" type="field"/>
   <column hidden="0" width="-1" name="macrominsector_id" type="field"/>
   <column hidden="0" width="-1" name="flow_max" type="field"/>
   <column hidden="0" width="-1" name="flow_min" type="field"/>
   <column hidden="0" width="-1" name="flow_avg" type="field"/>
   <column hidden="0" width="-1" name="vel_max" type="field"/>
   <column hidden="0" width="-1" name="vel_min" type="field"/>
   <column hidden="0" width="-1" name="vel_avg" type="field"/>
   <column hidden="0" width="-1" name="tstamp" type="field"/>
   <column hidden="0" width="-1" name="insert_user" type="field"/>
   <column hidden="0" width="-1" name="lastupdate" type="field"/>
   <column hidden="0" width="-1" name="lastupdate_user" type="field"/>
   <column hidden="0" width="-1" name="inp_type" type="field"/>
   <column hidden="1" width="-1" type="actions"/>
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
  <field name="adate" editable="1"/>
  <field name="adescript" editable="1"/>
  <field name="annotation" editable="1"/>
  <field name="arc_id" editable="1"/>
  <field name="arc_type" editable="1"/>
  <field name="arccat_id" editable="1"/>
  <field name="asset_id" editable="1"/>
  <field name="brand_id" editable="1"/>
  <field name="buildercat_id" editable="1"/>
  <field name="builtdate" editable="1"/>
  <field name="cat_dint" editable="1"/>
  <field name="cat_dnom" editable="1"/>
  <field name="cat_matcat_id" editable="1"/>
  <field name="cat_pnom" editable="1"/>
  <field name="category_type" editable="1"/>
  <field name="code" editable="1"/>
  <field name="comment" editable="1"/>
  <field name="conserv_state" editable="1"/>
  <field name="custom_length" editable="1"/>
  <field name="depth" editable="1"/>
  <field name="depth1" editable="1"/>
  <field name="depth2" editable="1"/>
  <field name="descript" editable="1"/>
  <field name="district_id" editable="1"/>
  <field name="dma_id" editable="1"/>
  <field name="dma_name" editable="1"/>
  <field name="dma_style" editable="1"/>
  <field name="dma_type" editable="1"/>
  <field name="dqa_id" editable="1"/>
  <field name="dqa_name" editable="1"/>
  <field name="dqa_type" editable="1"/>
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
  <field name="gis_length" editable="1"/>
  <field name="inp_type" editable="1"/>
  <field name="insert_user" editable="1"/>
  <field name="inventory" editable="1"/>
  <field name="is_operative" editable="1"/>
  <field name="label" editable="1"/>
  <field name="label_quadrant" editable="1"/>
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
  <field name="macrominsector_id" editable="1"/>
  <field name="macrosector_id" editable="1"/>
  <field name="minsector_id" editable="1"/>
  <field name="model_id" editable="1"/>
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
  <field name="presszone_head" editable="1"/>
  <field name="presszone_id" editable="1"/>
  <field name="presszone_style" editable="1"/>
  <field name="presszone_type" editable="1"/>
  <field name="presszone_name" editable="1"/>
  <field name="province_id" editable="1"/>
  <field name="publish" editable="1"/>
  <field name="region_id" editable="1"/>
  <field name="sector_id" editable="1"/>
  <field name="sector_name" editable="1"/>
  <field name="sector_type" editable="1"/>
  <field name="serial_number" editable="1"/>
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
  <field labelOnTop="0" name="brand_id"/>
  <field labelOnTop="0" name="buildercat_id"/>
  <field labelOnTop="0" name="builtdate"/>
  <field labelOnTop="0" name="cat_dint"/>
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
  <field labelOnTop="0" name="dma_type"/>
  <field labelOnTop="0" name="dqa_id"/>
  <field labelOnTop="0" name="dqa_name"/>
  <field labelOnTop="0" name="dqa_type"/>
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
  <field labelOnTop="0" name="inp_type"/>
  <field labelOnTop="0" name="insert_user"/>
  <field labelOnTop="0" name="inventory"/>
  <field labelOnTop="0" name="is_operative"/>
  <field labelOnTop="0" name="label"/>
  <field labelOnTop="0" name="label_quadrant"/>
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
  <field labelOnTop="0" name="macrominsector_id"/>
  <field labelOnTop="0" name="macrosector_id"/>
  <field labelOnTop="0" name="minsector_id"/>
  <field labelOnTop="0" name="model_id"/>
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
  <field labelOnTop="0" name="presszone_head"/>
  <field labelOnTop="0" name="presszone_id"/>
  <field labelOnTop="0" name="presszone_style"/>
  <field labelOnTop="0" name="presszone_type"/>
  <field labelOnTop="0" name="presszone_name"/>
  <field labelOnTop="0" name="province_id"/>
  <field labelOnTop="0" name="publish"/>
  <field labelOnTop="0" name="region_id"/>
  <field labelOnTop="0" name="sector_id"/>
  <field labelOnTop="0" name="sector_name"/>
  <field labelOnTop="0" name="sector_type"/>
  <field labelOnTop="0" name="serial_number"/>
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
  <field name="brand_id" reuseLastValue="0"/>
  <field name="buildercat_id" reuseLastValue="0"/>
  <field name="builtdate" reuseLastValue="0"/>
  <field name="cat_dint" reuseLastValue="0"/>
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
  <field name="dma_type" reuseLastValue="0"/>
  <field name="dqa_id" reuseLastValue="0"/>
  <field name="dqa_name" reuseLastValue="0"/>
  <field name="dqa_type" reuseLastValue="0"/>
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
  <field name="inp_type" reuseLastValue="0"/>
  <field name="insert_user" reuseLastValue="0"/>
  <field name="inventory" reuseLastValue="0"/>
  <field name="is_operative" reuseLastValue="0"/>
  <field name="label" reuseLastValue="0"/>
  <field name="label_quadrant" reuseLastValue="0"/>
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
  <field name="macrominsector_id" reuseLastValue="0"/>
  <field name="macrosector_id" reuseLastValue="0"/>
  <field name="minsector_id" reuseLastValue="0"/>
  <field name="model_id" reuseLastValue="0"/>
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
  <field name="presszone_head" reuseLastValue="0"/>
  <field name="presszone_id" reuseLastValue="0"/>
  <field name="presszone_style" reuseLastValue="0"/>
  <field name="presszone_type" reuseLastValue="0"/>
  <field name="presszone_name" reuseLastValue="0"/>
  <field name="province_id" reuseLastValue="0"/>
  <field name="publish" reuseLastValue="0"/>
  <field name="region_id" reuseLastValue="0"/>
  <field name="sector_id" reuseLastValue="0"/>
  <field name="sector_name" reuseLastValue="0"/>
  <field name="sector_type" reuseLastValue="0"/>
  <field name="serial_number" reuseLastValue="0"/>
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
 <previewExpression>"sector_name"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>1</layerGeometryType>
</qgis>' where layername = 'v_edit_arc' and styleconfig_id = 102;

update sys_style set stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" readOnly="0" maxScale="0" simplifyDrawingTol="1" simplifyAlgorithm="0" symbologyReferenceScale="-1" version="3.28.5-Firenze" styleCategories="AllStyleCategories" minScale="2500" labelsEnabled="0" simplifyLocal="1" simplifyDrawingHints="0">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" endField="" fixedDuration="0" mode="0" startExpression="" enabled="0" endExpression="" durationField="" accumulate="0" durationUnit="min" startField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation binding="Centroid" showMarkerSymbolInSurfacePlots="0" zoffset="0" symbology="Line" extrusionEnabled="0" respectLayerSymbol="1" zscale="1" extrusion="0" clamping="Terrain" type="IndividualFeatures">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
      <Option value="125,139,143,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.6" name="line_width" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="fill" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleFill">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
      <Option value="125,139,143,255" name="color" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="89,99,102,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="solid" name="style" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="125,139,143,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="diamond" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="89,99,102,255" name="outline_color" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 attr="inp_type" forceraster="0" type="categorizedSymbol" enableorderby="0" symbollevels="0" referencescale="-1">
  <categories>
   <category symbol="0" render="true" value="JUNCTION" label="JUNCTION" type="string"/>
   <category symbol="1" render="true" value="" label="NOT USED" type="string"/>
  </categories>
  <symbols>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
      <Option value="1.2" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="215,215,215,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="circle" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="215,215,215,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.4" name="outline_width" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="diameter" name="scale_method" type="QString"/>
      <Option value="1.6" name="size" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
      <Option value="MM" name="size_unit" type="QString"/>
      <Option value="1" name="vertical_anchor_point" type="QString"/>
     </Option>
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
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
   <Option name="dualview/previewExpressions" type="List">
    <Option value="&quot;sector_name&quot;" type="QString"/>
   </Option>
   <Option value="0" name="embeddedWidgets/count" type="QString"/>
   <Option name="variableNames"/>
   <Option name="variableValues"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory barWidth="5" showAxis="1" sizeType="MM" lineSizeType="MM" lineSizeScale="3x:0,0,0,0,0,0" scaleDependency="Area" width="15" backgroundAlpha="255" penColor="#000000" height="15" diagramOrientation="Up" penWidth="0" labelPlacementMethod="XHeight" scaleBasedVisibility="1" spacingUnit="MM" spacingUnitScale="3x:0,0,0,0,0,0" minimumSize="0" rotationOffset="270" penAlpha="255" minScaleDenominator="0" spacing="5" backgroundColor="#ffffff" opacity="1" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="2500" enabled="0" direction="0">
   <fontProperties strikethrough="0" italic="0" underline="0" bold="0" description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style=""/>
   <axisSymbol>
    <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
 <DiagramLayerSettings linePlacementFlags="18" obstacle="0" placement="0" dist="0" priority="0" showAll="1" zIndex="0">
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
  <field name="cat_dint" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="inp_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="presszone_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="presszone_head" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="dma_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="dqa_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="crmzone_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
      </Option>
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
  <field name="customer_code" configurationFlags="None">
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
  <field name="staticpressure" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="soilcat_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
  <field name="workcat_id_plan" configurationFlags="None">
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
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
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
  <field name="region_id" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
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
       <Option value="" name="" type="QString"/>
       <Option value="1" name="Barcelona" type="QString"/>
      </Option>
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
       <Option value="" name="" type="QString"/>
       <Option value="2" name="IGNORE CHECK" type="QString"/>
       <Option value="0" name="TO REVIEW" type="QString"/>
       <Option value="1" name="VERIFIED" type="QString"/>
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
  <field name="label_quadrant" configurationFlags="None">
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
  <field name="expl_id2" configurationFlags="None">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option name="map" type="Map">
       <Option value="" name="" type="QString"/>
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
  <field name="plot_code" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="brand_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="model_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="serial_number" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="cat_valve" configurationFlags="None">
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
  <field name="macrominsector_id" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
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
 </fieldConfiguration>
 <aliases>
  <alias field="connec_id" index="0" name="connec_id"/>
  <alias field="code" index="1" name="code"/>
  <alias field="elevation" index="2" name="elevation"/>
  <alias field="depth" index="3" name="depth"/>
  <alias field="connec_type" index="4" name="connec_type"/>
  <alias field="sys_type" index="5" name="sys_type"/>
  <alias field="connecat_id" index="6" name="connecat_id"/>
  <alias field="cat_matcat_id" index="7" name="cat_matcat_id"/>
  <alias field="cat_pnom" index="8" name="cat_pnom"/>
  <alias field="cat_dnom" index="9" name="cat_dnom"/>
  <alias field="cat_dint" index="10" name=""/>
  <alias field="epa_type" index="11" name=""/>
  <alias field="inp_type" index="12" name=""/>
  <alias field="state" index="13" name="state"/>
  <alias field="state_type" index="14" name="state_type"/>
  <alias field="expl_id" index="15" name="exploitation"/>
  <alias field="macroexpl_id" index="16" name="Macroexploitation"/>
  <alias field="sector_id" index="17" name="sector"/>
  <alias field="sector_name" index="18" name="Sector name"/>
  <alias field="macrosector_id" index="19" name="macrosector"/>
  <alias field="presszone_id" index="20" name="Presszone"/>
  <alias field="presszone_name" index="21" name="Presszone name"/>
  <alias field="presszone_type" index="22" name=""/>
  <alias field="presszone_head" index="23" name=""/>
  <alias field="dma_id" index="24" name="dma"/>
  <alias field="dma_name" index="25" name="Dma name"/>
  <alias field="dma_type" index="26" name=""/>
  <alias field="macrodma_id" index="27" name="macrodma_id"/>
  <alias field="dqa_id" index="28" name="Dqa"/>
  <alias field="dqa_name" index="29" name="Dqa name"/>
  <alias field="dqa_type" index="30" name=""/>
  <alias field="macrodqa_id" index="31" name="macrodqa_id"/>
  <alias field="crmzone_id" index="32" name="crmzone_id"/>
  <alias field="crmzone_name" index="33" name="crmzone_name"/>
  <alias field="customer_code" index="34" name="customer_code"/>
  <alias field="connec_length" index="35" name="connec_length"/>
  <alias field="n_hydrometer" index="36" name="n_hydrometer"/>
  <alias field="arc_id" index="37" name="arc_id"/>
  <alias field="annotation" index="38" name="annotation"/>
  <alias field="observ" index="39" name="observ"/>
  <alias field="comment" index="40" name="comment"/>
  <alias field="staticpressure" index="41" name="staticpressure"/>
  <alias field="soilcat_id" index="42" name="soilcat_id"/>
  <alias field="function_type" index="43" name="function_type"/>
  <alias field="category_type" index="44" name="category_type"/>
  <alias field="fluid_type" index="45" name="fluid_type"/>
  <alias field="location_type" index="46" name="location_type"/>
  <alias field="workcat_id" index="47" name="work_id"/>
  <alias field="workcat_id_end" index="48" name="work_id_end"/>
  <alias field="workcat_id_plan" index="49" name="workcat_id_plan"/>
  <alias field="buildercat_id" index="50" name="builder"/>
  <alias field="builtdate" index="51" name="builtdate"/>
  <alias field="enddate" index="52" name="enddate"/>
  <alias field="ownercat_id" index="53" name="owner"/>
  <alias field="muni_id" index="54" name="municipality"/>
  <alias field="postcode" index="55" name="postcode"/>
  <alias field="district_id" index="56" name="district"/>
  <alias field="streetname" index="57" name="streetname"/>
  <alias field="postnumber" index="58" name="postnumber"/>
  <alias field="postcomplement" index="59" name="postcomplement"/>
  <alias field="streetname2" index="60" name="streetname2"/>
  <alias field="postnumber2" index="61" name="postnumber2"/>
  <alias field="postcomplement2" index="62" name="postcomplement2"/>
  <alias field="region_id" index="63" name="Region"/>
  <alias field="province_id" index="64" name="Province"/>
  <alias field="descript" index="65" name="descript"/>
  <alias field="svg" index="66" name="svg"/>
  <alias field="rotation" index="67" name="rotation"/>
  <alias field="link" index="68" name="link"/>
  <alias field="verified" index="69" name="verified"/>
  <alias field="undelete" index="70" name="undelete"/>
  <alias field="label" index="71" name="Catalog label"/>
  <alias field="label_x" index="72" name="label_x"/>
  <alias field="label_y" index="73" name="label_y"/>
  <alias field="label_rotation" index="74" name="label_rotation"/>
  <alias field="label_quadrant" index="75" name="label_quadrant"/>
  <alias field="publish" index="76" name="publish"/>
  <alias field="inventory" index="77" name="inventory"/>
  <alias field="num_value" index="78" name="num_value"/>
  <alias field="pjoint_id" index="79" name="pjoint_id"/>
  <alias field="pjoint_type" index="80" name="pjoint_type"/>
  <alias field="adate" index="81" name="Adate"/>
  <alias field="adescript" index="82" name="A descript"/>
  <alias field="accessibility" index="83" name="Accessibility"/>
  <alias field="asset_id" index="84" name="asset_id"/>
  <alias field="dma_style" index="85" name="Dma color"/>
  <alias field="presszone_style" index="86" name="Presszone color"/>
  <alias field="priority" index="87" name="priority"/>
  <alias field="valve_location" index="88" name="valve_location"/>
  <alias field="valve_type" index="89" name="valve_type"/>
  <alias field="shutoff_valve" index="90" name="shutoff_valve"/>
  <alias field="access_type" index="91" name="access_type"/>
  <alias field="placement_type" index="92" name="placement_type"/>
  <alias field="om_state" index="93" name="om_state"/>
  <alias field="conserv_state" index="94" name="conserv_state"/>
  <alias field="expl_id2" index="95" name="Exploitation 2"/>
  <alias field="is_operative" index="96" name=""/>
  <alias field="plot_code" index="97" name="plot_code"/>
  <alias field="brand_id" index="98" name="brand_id"/>
  <alias field="model_id" index="99" name="model_id"/>
  <alias field="serial_number" index="100" name="serial_number"/>
  <alias field="cat_valve" index="101" name="cat_valve"/>
  <alias field="minsector_id" index="102" name="minsector_id"/>
  <alias field="macrominsector_id" index="103" name="macrominsector_id"/>
  <alias field="demand" index="104" name=""/>
  <alias field="press_max" index="105" name=""/>
  <alias field="press_min" index="106" name=""/>
  <alias field="press_avg" index="107" name=""/>
  <alias field="quality_max" index="108" name=""/>
  <alias field="quality_min" index="109" name=""/>
  <alias field="quality_avg" index="110" name=""/>
  <alias field="tstamp" index="111" name="Insert tstamp"/>
  <alias field="insert_user" index="112" name=""/>
  <alias field="lastupdate" index="113" name="Last update"/>
  <alias field="lastupdate_user" index="114" name="Last update user"/>
 </aliases>
 <defaults>
  <default field="connec_id" expression="" applyOnUpdate="0"/>
  <default field="code" expression="" applyOnUpdate="0"/>
  <default field="elevation" expression="" applyOnUpdate="0"/>
  <default field="depth" expression="" applyOnUpdate="0"/>
  <default field="connec_type" expression="" applyOnUpdate="0"/>
  <default field="sys_type" expression="" applyOnUpdate="0"/>
  <default field="connecat_id" expression="" applyOnUpdate="0"/>
  <default field="cat_matcat_id" expression="" applyOnUpdate="0"/>
  <default field="cat_pnom" expression="" applyOnUpdate="0"/>
  <default field="cat_dnom" expression="" applyOnUpdate="0"/>
  <default field="cat_dint" expression="" applyOnUpdate="0"/>
  <default field="epa_type" expression="" applyOnUpdate="0"/>
  <default field="inp_type" expression="" applyOnUpdate="0"/>
  <default field="state" expression="" applyOnUpdate="0"/>
  <default field="state_type" expression="" applyOnUpdate="0"/>
  <default field="expl_id" expression="" applyOnUpdate="0"/>
  <default field="macroexpl_id" expression="" applyOnUpdate="0"/>
  <default field="sector_id" expression="" applyOnUpdate="0"/>
  <default field="sector_name" expression="" applyOnUpdate="0"/>
  <default field="macrosector_id" expression="" applyOnUpdate="0"/>
  <default field="presszone_id" expression="" applyOnUpdate="0"/>
  <default field="presszone_name" expression="" applyOnUpdate="0"/>
  <default field="presszone_type" expression="" applyOnUpdate="0"/>
  <default field="presszone_head" expression="" applyOnUpdate="0"/>
  <default field="dma_id" expression="" applyOnUpdate="0"/>
  <default field="dma_name" expression="" applyOnUpdate="0"/>
  <default field="dma_type" expression="" applyOnUpdate="0"/>
  <default field="macrodma_id" expression="" applyOnUpdate="0"/>
  <default field="dqa_id" expression="" applyOnUpdate="0"/>
  <default field="dqa_name" expression="" applyOnUpdate="0"/>
  <default field="dqa_type" expression="" applyOnUpdate="0"/>
  <default field="macrodqa_id" expression="" applyOnUpdate="0"/>
  <default field="crmzone_id" expression="" applyOnUpdate="0"/>
  <default field="crmzone_name" expression="" applyOnUpdate="0"/>
  <default field="customer_code" expression="" applyOnUpdate="0"/>
  <default field="connec_length" expression="" applyOnUpdate="0"/>
  <default field="n_hydrometer" expression="" applyOnUpdate="0"/>
  <default field="arc_id" expression="" applyOnUpdate="0"/>
  <default field="annotation" expression="" applyOnUpdate="0"/>
  <default field="observ" expression="" applyOnUpdate="0"/>
  <default field="comment" expression="" applyOnUpdate="0"/>
  <default field="staticpressure" expression="" applyOnUpdate="0"/>
  <default field="soilcat_id" expression="" applyOnUpdate="0"/>
  <default field="function_type" expression="" applyOnUpdate="0"/>
  <default field="category_type" expression="" applyOnUpdate="0"/>
  <default field="fluid_type" expression="" applyOnUpdate="0"/>
  <default field="location_type" expression="" applyOnUpdate="0"/>
  <default field="workcat_id" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_plan" expression="" applyOnUpdate="0"/>
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
  <default field="region_id" expression="" applyOnUpdate="0"/>
  <default field="province_id" expression="" applyOnUpdate="0"/>
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
  <default field="label_quadrant" expression="" applyOnUpdate="0"/>
  <default field="publish" expression="" applyOnUpdate="0"/>
  <default field="inventory" expression="" applyOnUpdate="0"/>
  <default field="num_value" expression="" applyOnUpdate="0"/>
  <default field="pjoint_id" expression="" applyOnUpdate="0"/>
  <default field="pjoint_type" expression="" applyOnUpdate="0"/>
  <default field="adate" expression="" applyOnUpdate="0"/>
  <default field="adescript" expression="" applyOnUpdate="0"/>
  <default field="accessibility" expression="" applyOnUpdate="0"/>
  <default field="asset_id" expression="" applyOnUpdate="0"/>
  <default field="dma_style" expression="" applyOnUpdate="0"/>
  <default field="presszone_style" expression="" applyOnUpdate="0"/>
  <default field="priority" expression="" applyOnUpdate="0"/>
  <default field="valve_location" expression="" applyOnUpdate="0"/>
  <default field="valve_type" expression="" applyOnUpdate="0"/>
  <default field="shutoff_valve" expression="" applyOnUpdate="0"/>
  <default field="access_type" expression="" applyOnUpdate="0"/>
  <default field="placement_type" expression="" applyOnUpdate="0"/>
  <default field="om_state" expression="" applyOnUpdate="0"/>
  <default field="conserv_state" expression="" applyOnUpdate="0"/>
  <default field="expl_id2" expression="" applyOnUpdate="0"/>
  <default field="is_operative" expression="" applyOnUpdate="0"/>
  <default field="plot_code" expression="" applyOnUpdate="0"/>
  <default field="brand_id" expression="" applyOnUpdate="0"/>
  <default field="model_id" expression="" applyOnUpdate="0"/>
  <default field="serial_number" expression="" applyOnUpdate="0"/>
  <default field="cat_valve" expression="" applyOnUpdate="0"/>
  <default field="minsector_id" expression="" applyOnUpdate="0"/>
  <default field="macrominsector_id" expression="" applyOnUpdate="0"/>
  <default field="demand" expression="" applyOnUpdate="0"/>
  <default field="press_max" expression="" applyOnUpdate="0"/>
  <default field="press_min" expression="" applyOnUpdate="0"/>
  <default field="press_avg" expression="" applyOnUpdate="0"/>
  <default field="quality_max" expression="" applyOnUpdate="0"/>
  <default field="quality_min" expression="" applyOnUpdate="0"/>
  <default field="quality_avg" expression="" applyOnUpdate="0"/>
  <default field="tstamp" expression="" applyOnUpdate="0"/>
  <default field="insert_user" expression="" applyOnUpdate="0"/>
  <default field="lastupdate" expression="" applyOnUpdate="0"/>
  <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
 </defaults>
 <constraints>
  <constraint field="connec_id" unique_strength="1" notnull_strength="1" exp_strength="0" constraints="3"/>
  <constraint field="code" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="elevation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="depth" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="connec_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sys_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="connecat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_matcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_pnom" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_dnom" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_dint" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="epa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inp_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macroexpl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrosector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_head" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodqa_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="crmzone_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="crmzone_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="customer_code" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="connec_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="n_hydrometer" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="arc_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="annotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="observ" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="comment" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="staticpressure" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="soilcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="function_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="category_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="fluid_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="location_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_end" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_plan" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="buildercat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="builtdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="enddate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="ownercat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="muni_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcode" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="district_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="streetname" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postnumber" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcomplement" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="streetname2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postnumber2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="postcomplement2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="region_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="province_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="descript" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="svg" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="rotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="link" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="verified" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="undelete" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_x" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_y" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_rotation" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="label_quadrant" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="publish" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inventory" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="num_value" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="pjoint_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="pjoint_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="adate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="adescript" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="accessibility" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="asset_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_style" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_style" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="priority" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="valve_location" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="valve_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="shutoff_valve" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="access_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="placement_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="om_state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="conserv_state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="is_operative" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="plot_code" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="brand_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="model_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="serial_number" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="cat_valve" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="minsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrominsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="demand" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="press_max" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="press_min" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="press_avg" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="quality_max" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="quality_min" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="quality_avg" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="tstamp" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="insert_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
 </constraints>
 <constraintExpressions>
  <constraint field="connec_id" desc="" exp=""/>
  <constraint field="code" desc="" exp=""/>
  <constraint field="elevation" desc="" exp=""/>
  <constraint field="depth" desc="" exp=""/>
  <constraint field="connec_type" desc="" exp=""/>
  <constraint field="sys_type" desc="" exp=""/>
  <constraint field="connecat_id" desc="" exp=""/>
  <constraint field="cat_matcat_id" desc="" exp=""/>
  <constraint field="cat_pnom" desc="" exp=""/>
  <constraint field="cat_dnom" desc="" exp=""/>
  <constraint field="cat_dint" desc="" exp=""/>
  <constraint field="epa_type" desc="" exp=""/>
  <constraint field="inp_type" desc="" exp=""/>
  <constraint field="state" desc="" exp=""/>
  <constraint field="state_type" desc="" exp=""/>
  <constraint field="expl_id" desc="" exp=""/>
  <constraint field="macroexpl_id" desc="" exp=""/>
  <constraint field="sector_id" desc="" exp=""/>
  <constraint field="sector_name" desc="" exp=""/>
  <constraint field="macrosector_id" desc="" exp=""/>
  <constraint field="presszone_id" desc="" exp=""/>
  <constraint field="presszone_name" desc="" exp=""/>
  <constraint field="presszone_type" desc="" exp=""/>
  <constraint field="presszone_head" desc="" exp=""/>
  <constraint field="dma_id" desc="" exp=""/>
  <constraint field="dma_name" desc="" exp=""/>
  <constraint field="dma_type" desc="" exp=""/>
  <constraint field="macrodma_id" desc="" exp=""/>
  <constraint field="dqa_id" desc="" exp=""/>
  <constraint field="dqa_name" desc="" exp=""/>
  <constraint field="dqa_type" desc="" exp=""/>
  <constraint field="macrodqa_id" desc="" exp=""/>
  <constraint field="crmzone_id" desc="" exp=""/>
  <constraint field="crmzone_name" desc="" exp=""/>
  <constraint field="customer_code" desc="" exp=""/>
  <constraint field="connec_length" desc="" exp=""/>
  <constraint field="n_hydrometer" desc="" exp=""/>
  <constraint field="arc_id" desc="" exp=""/>
  <constraint field="annotation" desc="" exp=""/>
  <constraint field="observ" desc="" exp=""/>
  <constraint field="comment" desc="" exp=""/>
  <constraint field="staticpressure" desc="" exp=""/>
  <constraint field="soilcat_id" desc="" exp=""/>
  <constraint field="function_type" desc="" exp=""/>
  <constraint field="category_type" desc="" exp=""/>
  <constraint field="fluid_type" desc="" exp=""/>
  <constraint field="location_type" desc="" exp=""/>
  <constraint field="workcat_id" desc="" exp=""/>
  <constraint field="workcat_id_end" desc="" exp=""/>
  <constraint field="workcat_id_plan" desc="" exp=""/>
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
  <constraint field="region_id" desc="" exp=""/>
  <constraint field="province_id" desc="" exp=""/>
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
  <constraint field="label_quadrant" desc="" exp=""/>
  <constraint field="publish" desc="" exp=""/>
  <constraint field="inventory" desc="" exp=""/>
  <constraint field="num_value" desc="" exp=""/>
  <constraint field="pjoint_id" desc="" exp=""/>
  <constraint field="pjoint_type" desc="" exp=""/>
  <constraint field="adate" desc="" exp=""/>
  <constraint field="adescript" desc="" exp=""/>
  <constraint field="accessibility" desc="" exp=""/>
  <constraint field="asset_id" desc="" exp=""/>
  <constraint field="dma_style" desc="" exp=""/>
  <constraint field="presszone_style" desc="" exp=""/>
  <constraint field="priority" desc="" exp=""/>
  <constraint field="valve_location" desc="" exp=""/>
  <constraint field="valve_type" desc="" exp=""/>
  <constraint field="shutoff_valve" desc="" exp=""/>
  <constraint field="access_type" desc="" exp=""/>
  <constraint field="placement_type" desc="" exp=""/>
  <constraint field="om_state" desc="" exp=""/>
  <constraint field="conserv_state" desc="" exp=""/>
  <constraint field="expl_id2" desc="" exp=""/>
  <constraint field="is_operative" desc="" exp=""/>
  <constraint field="plot_code" desc="" exp=""/>
  <constraint field="brand_id" desc="" exp=""/>
  <constraint field="model_id" desc="" exp=""/>
  <constraint field="serial_number" desc="" exp=""/>
  <constraint field="cat_valve" desc="" exp=""/>
  <constraint field="minsector_id" desc="" exp=""/>
  <constraint field="macrominsector_id" desc="" exp=""/>
  <constraint field="demand" desc="" exp=""/>
  <constraint field="press_max" desc="" exp=""/>
  <constraint field="press_min" desc="" exp=""/>
  <constraint field="press_avg" desc="" exp=""/>
  <constraint field="quality_max" desc="" exp=""/>
  <constraint field="quality_min" desc="" exp=""/>
  <constraint field="quality_avg" desc="" exp=""/>
  <constraint field="tstamp" desc="" exp=""/>
  <constraint field="insert_user" desc="" exp=""/>
  <constraint field="lastupdate" desc="" exp=""/>
  <constraint field="lastupdate_user" desc="" exp=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
  <columns>
   <column hidden="0" width="-1" name="connec_id" type="field"/>
   <column hidden="0" width="-1" name="code" type="field"/>
   <column hidden="0" width="-1" name="elevation" type="field"/>
   <column hidden="0" width="-1" name="depth" type="field"/>
   <column hidden="0" width="-1" name="connec_type" type="field"/>
   <column hidden="0" width="-1" name="sys_type" type="field"/>
   <column hidden="0" width="-1" name="connecat_id" type="field"/>
   <column hidden="0" width="-1" name="cat_matcat_id" type="field"/>
   <column hidden="0" width="-1" name="cat_pnom" type="field"/>
   <column hidden="0" width="-1" name="cat_dnom" type="field"/>
   <column hidden="0" width="-1" name="cat_dint" type="field"/>
   <column hidden="0" width="-1" name="epa_type" type="field"/>
   <column hidden="0" width="-1" name="inp_type" type="field"/>
   <column hidden="0" width="-1" name="state" type="field"/>
   <column hidden="0" width="-1" name="state_type" type="field"/>
   <column hidden="0" width="-1" name="expl_id" type="field"/>
   <column hidden="0" width="-1" name="macroexpl_id" type="field"/>
   <column hidden="0" width="-1" name="sector_id" type="field"/>
   <column hidden="0" width="-1" name="sector_name" type="field"/>
   <column hidden="0" width="-1" name="macrosector_id" type="field"/>
   <column hidden="0" width="-1" name="presszone_id" type="field"/>
   <column hidden="0" width="-1" name="presszone_name" type="field"/>
   <column hidden="0" width="-1" name="presszone_type" type="field"/>
   <column hidden="0" width="-1" name="presszone_head" type="field"/>
   <column hidden="0" width="-1" name="dma_id" type="field"/>
   <column hidden="0" width="-1" name="dma_name" type="field"/>
   <column hidden="0" width="-1" name="dma_type" type="field"/>
   <column hidden="0" width="-1" name="macrodma_id" type="field"/>
   <column hidden="0" width="-1" name="dqa_id" type="field"/>
   <column hidden="0" width="-1" name="dqa_name" type="field"/>
   <column hidden="0" width="-1" name="dqa_type" type="field"/>
   <column hidden="0" width="-1" name="macrodqa_id" type="field"/>
   <column hidden="0" width="-1" name="crmzone_id" type="field"/>
   <column hidden="0" width="-1" name="crmzone_name" type="field"/>
   <column hidden="0" width="-1" name="customer_code" type="field"/>
   <column hidden="0" width="-1" name="connec_length" type="field"/>
   <column hidden="0" width="-1" name="n_hydrometer" type="field"/>
   <column hidden="0" width="-1" name="arc_id" type="field"/>
   <column hidden="0" width="-1" name="annotation" type="field"/>
   <column hidden="0" width="-1" name="observ" type="field"/>
   <column hidden="0" width="-1" name="comment" type="field"/>
   <column hidden="0" width="-1" name="staticpressure" type="field"/>
   <column hidden="0" width="-1" name="soilcat_id" type="field"/>
   <column hidden="0" width="-1" name="function_type" type="field"/>
   <column hidden="0" width="-1" name="category_type" type="field"/>
   <column hidden="0" width="-1" name="fluid_type" type="field"/>
   <column hidden="0" width="-1" name="location_type" type="field"/>
   <column hidden="0" width="-1" name="workcat_id" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_end" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_plan" type="field"/>
   <column hidden="0" width="-1" name="buildercat_id" type="field"/>
   <column hidden="0" width="-1" name="builtdate" type="field"/>
   <column hidden="0" width="-1" name="enddate" type="field"/>
   <column hidden="0" width="-1" name="ownercat_id" type="field"/>
   <column hidden="0" width="-1" name="muni_id" type="field"/>
   <column hidden="0" width="-1" name="postcode" type="field"/>
   <column hidden="0" width="-1" name="district_id" type="field"/>
   <column hidden="0" width="-1" name="streetname" type="field"/>
   <column hidden="0" width="-1" name="postnumber" type="field"/>
   <column hidden="0" width="-1" name="postcomplement" type="field"/>
   <column hidden="0" width="-1" name="streetname2" type="field"/>
   <column hidden="0" width="-1" name="postnumber2" type="field"/>
   <column hidden="0" width="-1" name="postcomplement2" type="field"/>
   <column hidden="0" width="-1" name="region_id" type="field"/>
   <column hidden="0" width="-1" name="province_id" type="field"/>
   <column hidden="0" width="-1" name="descript" type="field"/>
   <column hidden="0" width="-1" name="svg" type="field"/>
   <column hidden="0" width="-1" name="rotation" type="field"/>
   <column hidden="0" width="-1" name="link" type="field"/>
   <column hidden="0" width="-1" name="verified" type="field"/>
   <column hidden="0" width="-1" name="undelete" type="field"/>
   <column hidden="0" width="-1" name="label" type="field"/>
   <column hidden="0" width="-1" name="label_x" type="field"/>
   <column hidden="0" width="-1" name="label_y" type="field"/>
   <column hidden="0" width="-1" name="label_rotation" type="field"/>
   <column hidden="0" width="-1" name="label_quadrant" type="field"/>
   <column hidden="0" width="-1" name="publish" type="field"/>
   <column hidden="0" width="-1" name="inventory" type="field"/>
   <column hidden="0" width="-1" name="num_value" type="field"/>
   <column hidden="0" width="-1" name="pjoint_id" type="field"/>
   <column hidden="0" width="-1" name="pjoint_type" type="field"/>
   <column hidden="0" width="-1" name="adate" type="field"/>
   <column hidden="0" width="-1" name="adescript" type="field"/>
   <column hidden="0" width="-1" name="accessibility" type="field"/>
   <column hidden="0" width="-1" name="asset_id" type="field"/>
   <column hidden="0" width="-1" name="dma_style" type="field"/>
   <column hidden="0" width="-1" name="presszone_style" type="field"/>
   <column hidden="0" width="-1" name="priority" type="field"/>
   <column hidden="0" width="-1" name="valve_location" type="field"/>
   <column hidden="0" width="-1" name="valve_type" type="field"/>
   <column hidden="0" width="-1" name="shutoff_valve" type="field"/>
   <column hidden="0" width="-1" name="access_type" type="field"/>
   <column hidden="0" width="-1" name="placement_type" type="field"/>
   <column hidden="0" width="-1" name="om_state" type="field"/>
   <column hidden="0" width="-1" name="conserv_state" type="field"/>
   <column hidden="0" width="-1" name="expl_id2" type="field"/>
   <column hidden="0" width="-1" name="is_operative" type="field"/>
   <column hidden="0" width="-1" name="plot_code" type="field"/>
   <column hidden="0" width="-1" name="brand_id" type="field"/>
   <column hidden="0" width="-1" name="model_id" type="field"/>
   <column hidden="0" width="-1" name="serial_number" type="field"/>
   <column hidden="0" width="-1" name="cat_valve" type="field"/>
   <column hidden="0" width="-1" name="minsector_id" type="field"/>
   <column hidden="0" width="-1" name="macrominsector_id" type="field"/>
   <column hidden="0" width="-1" name="demand" type="field"/>
   <column hidden="0" width="-1" name="press_max" type="field"/>
   <column hidden="0" width="-1" name="press_min" type="field"/>
   <column hidden="0" width="-1" name="press_avg" type="field"/>
   <column hidden="0" width="-1" name="quality_max" type="field"/>
   <column hidden="0" width="-1" name="quality_min" type="field"/>
   <column hidden="0" width="-1" name="quality_avg" type="field"/>
   <column hidden="0" width="-1" name="tstamp" type="field"/>
   <column hidden="0" width="-1" name="insert_user" type="field"/>
   <column hidden="0" width="-1" name="lastupdate" type="field"/>
   <column hidden="0" width="-1" name="lastupdate_user" type="field"/>
   <column hidden="1" width="-1" type="actions"/>
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
  <field name="accessibility" editable="1"/>
  <field name="adate" editable="1"/>
  <field name="adescript" editable="1"/>
  <field name="annotation" editable="1"/>
  <field name="arc_id" editable="1"/>
  <field name="asset_id" editable="1"/>
  <field name="brand_id" editable="1"/>
  <field name="buildercat_id" editable="1"/>
  <field name="builtdate" editable="1"/>
  <field name="cat_dint" editable="1"/>
  <field name="cat_dnom" editable="1"/>
  <field name="cat_matcat_id" editable="1"/>
  <field name="cat_pnom" editable="1"/>
  <field name="cat_valve" editable="1"/>
  <field name="category_type" editable="1"/>
  <field name="code" editable="1"/>
  <field name="comment" editable="1"/>
  <field name="connec_id" editable="1"/>
  <field name="connec_length" editable="1"/>
  <field name="connec_type" editable="1"/>
  <field name="connecat_id" editable="1"/>
  <field name="conserv_state" editable="1"/>
  <field name="crmzone_id" editable="1"/>
  <field name="crmzone_name" editable="1"/>
  <field name="customer_code" editable="1"/>
  <field name="demand" editable="1"/>
  <field name="depth" editable="1"/>
  <field name="descript" editable="1"/>
  <field name="district_id" editable="1"/>
  <field name="dma_id" editable="1"/>
  <field name="dma_name" editable="1"/>
  <field name="dma_style" editable="1"/>
  <field name="dma_type" editable="1"/>
  <field name="dqa_id" editable="1"/>
  <field name="dqa_name" editable="1"/>
  <field name="dqa_type" editable="1"/>
  <field name="elevation" editable="1"/>
  <field name="enddate" editable="1"/>
  <field name="epa_type" editable="1"/>
  <field name="expl_id" editable="1"/>
  <field name="expl_id2" editable="1"/>
  <field name="fluid_type" editable="1"/>
  <field name="function_type" editable="1"/>
  <field name="inp_type" editable="1"/>
  <field name="insert_user" editable="1"/>
  <field name="inventory" editable="1"/>
  <field name="is_operative" editable="1"/>
  <field name="label" editable="1"/>
  <field name="label_quadrant" editable="1"/>
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
  <field name="macrominsector_id" editable="1"/>
  <field name="macrosector_id" editable="1"/>
  <field name="minsector_id" editable="1"/>
  <field name="model_id" editable="1"/>
  <field name="muni_id" editable="1"/>
  <field name="n_hydrometer" editable="1"/>
  <field name="num_value" editable="1"/>
  <field name="observ" editable="1"/>
  <field name="om_state" editable="1"/>
  <field name="ownercat_id" editable="1"/>
  <field name="pjoint_id" editable="1"/>
  <field name="pjoint_type" editable="1"/>
  <field name="placement_type" editable="1"/>
  <field name="plot_code" editable="1"/>
  <field name="postcode" editable="1"/>
  <field name="postcomplement" editable="1"/>
  <field name="postcomplement2" editable="1"/>
  <field name="postnumber" editable="1"/>
  <field name="postnumber2" editable="1"/>
  <field name="press_avg" editable="1"/>
  <field name="press_max" editable="1"/>
  <field name="press_min" editable="1"/>
  <field name="presszone_head" editable="1"/>
  <field name="presszone_id" editable="1"/>
  <field name="presszone_name" editable="1"/>
  <field name="presszone_style" editable="1"/>
  <field name="presszone_type" editable="1"/>
  <field name="priority" editable="1"/>
  <field name="province_id" editable="1"/>
  <field name="publish" editable="1"/>
  <field name="quality_avg" editable="1"/>
  <field name="quality_max" editable="1"/>
  <field name="quality_min" editable="1"/>
  <field name="region_id" editable="1"/>
  <field name="rotation" editable="1"/>
  <field name="sector_id" editable="1"/>
  <field name="sector_name" editable="1"/>
  <field name="serial_number" editable="1"/>
  <field name="shutoff_valve" editable="1"/>
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
  <field name="valve_location" editable="1"/>
  <field name="valve_type" editable="1"/>
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
  <field labelOnTop="0" name="brand_id"/>
  <field labelOnTop="0" name="buildercat_id"/>
  <field labelOnTop="0" name="builtdate"/>
  <field labelOnTop="0" name="cat_dint"/>
  <field labelOnTop="0" name="cat_dnom"/>
  <field labelOnTop="0" name="cat_matcat_id"/>
  <field labelOnTop="0" name="cat_pnom"/>
  <field labelOnTop="0" name="cat_valve"/>
  <field labelOnTop="0" name="category_type"/>
  <field labelOnTop="0" name="code"/>
  <field labelOnTop="0" name="comment"/>
  <field labelOnTop="0" name="connec_id"/>
  <field labelOnTop="0" name="connec_length"/>
  <field labelOnTop="0" name="connec_type"/>
  <field labelOnTop="0" name="connecat_id"/>
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
  <field labelOnTop="0" name="dma_type"/>
  <field labelOnTop="0" name="dqa_id"/>
  <field labelOnTop="0" name="dqa_name"/>
  <field labelOnTop="0" name="dqa_type"/>
  <field labelOnTop="0" name="elevation"/>
  <field labelOnTop="0" name="enddate"/>
  <field labelOnTop="0" name="epa_type"/>
  <field labelOnTop="0" name="expl_id"/>
  <field labelOnTop="0" name="expl_id2"/>
  <field labelOnTop="0" name="fluid_type"/>
  <field labelOnTop="0" name="function_type"/>
  <field labelOnTop="0" name="inp_type"/>
  <field labelOnTop="0" name="insert_user"/>
  <field labelOnTop="0" name="inventory"/>
  <field labelOnTop="0" name="is_operative"/>
  <field labelOnTop="0" name="label"/>
  <field labelOnTop="0" name="label_quadrant"/>
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
  <field labelOnTop="0" name="macrominsector_id"/>
  <field labelOnTop="0" name="macrosector_id"/>
  <field labelOnTop="0" name="minsector_id"/>
  <field labelOnTop="0" name="model_id"/>
  <field labelOnTop="0" name="muni_id"/>
  <field labelOnTop="0" name="n_hydrometer"/>
  <field labelOnTop="0" name="num_value"/>
  <field labelOnTop="0" name="observ"/>
  <field labelOnTop="0" name="om_state"/>
  <field labelOnTop="0" name="ownercat_id"/>
  <field labelOnTop="0" name="pjoint_id"/>
  <field labelOnTop="0" name="pjoint_type"/>
  <field labelOnTop="0" name="placement_type"/>
  <field labelOnTop="0" name="plot_code"/>
  <field labelOnTop="0" name="postcode"/>
  <field labelOnTop="0" name="postcomplement"/>
  <field labelOnTop="0" name="postcomplement2"/>
  <field labelOnTop="0" name="postnumber"/>
  <field labelOnTop="0" name="postnumber2"/>
  <field labelOnTop="0" name="press_avg"/>
  <field labelOnTop="0" name="press_max"/>
  <field labelOnTop="0" name="press_min"/>
  <field labelOnTop="0" name="presszone_head"/>
  <field labelOnTop="0" name="presszone_id"/>
  <field labelOnTop="0" name="presszone_name"/>
  <field labelOnTop="0" name="presszone_style"/>
  <field labelOnTop="0" name="presszone_type"/>
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
  <field labelOnTop="0" name="serial_number"/>
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
  <field name="brand_id" reuseLastValue="0"/>
  <field name="buildercat_id" reuseLastValue="0"/>
  <field name="builtdate" reuseLastValue="0"/>
  <field name="cat_dint" reuseLastValue="0"/>
  <field name="cat_dnom" reuseLastValue="0"/>
  <field name="cat_matcat_id" reuseLastValue="0"/>
  <field name="cat_pnom" reuseLastValue="0"/>
  <field name="cat_valve" reuseLastValue="0"/>
  <field name="category_type" reuseLastValue="0"/>
  <field name="code" reuseLastValue="0"/>
  <field name="comment" reuseLastValue="0"/>
  <field name="connec_id" reuseLastValue="0"/>
  <field name="connec_length" reuseLastValue="0"/>
  <field name="connec_type" reuseLastValue="0"/>
  <field name="connecat_id" reuseLastValue="0"/>
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
  <field name="dma_type" reuseLastValue="0"/>
  <field name="dqa_id" reuseLastValue="0"/>
  <field name="dqa_name" reuseLastValue="0"/>
  <field name="dqa_type" reuseLastValue="0"/>
  <field name="elevation" reuseLastValue="0"/>
  <field name="enddate" reuseLastValue="0"/>
  <field name="epa_type" reuseLastValue="0"/>
  <field name="expl_id" reuseLastValue="0"/>
  <field name="expl_id2" reuseLastValue="0"/>
  <field name="fluid_type" reuseLastValue="0"/>
  <field name="function_type" reuseLastValue="0"/>
  <field name="inp_type" reuseLastValue="0"/>
  <field name="insert_user" reuseLastValue="0"/>
  <field name="inventory" reuseLastValue="0"/>
  <field name="is_operative" reuseLastValue="0"/>
  <field name="label" reuseLastValue="0"/>
  <field name="label_quadrant" reuseLastValue="0"/>
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
  <field name="macrominsector_id" reuseLastValue="0"/>
  <field name="macrosector_id" reuseLastValue="0"/>
  <field name="minsector_id" reuseLastValue="0"/>
  <field name="model_id" reuseLastValue="0"/>
  <field name="muni_id" reuseLastValue="0"/>
  <field name="n_hydrometer" reuseLastValue="0"/>
  <field name="num_value" reuseLastValue="0"/>
  <field name="observ" reuseLastValue="0"/>
  <field name="om_state" reuseLastValue="0"/>
  <field name="ownercat_id" reuseLastValue="0"/>
  <field name="pjoint_id" reuseLastValue="0"/>
  <field name="pjoint_type" reuseLastValue="0"/>
  <field name="placement_type" reuseLastValue="0"/>
  <field name="plot_code" reuseLastValue="0"/>
  <field name="postcode" reuseLastValue="0"/>
  <field name="postcomplement" reuseLastValue="0"/>
  <field name="postcomplement2" reuseLastValue="0"/>
  <field name="postnumber" reuseLastValue="0"/>
  <field name="postnumber2" reuseLastValue="0"/>
  <field name="press_avg" reuseLastValue="0"/>
  <field name="press_max" reuseLastValue="0"/>
  <field name="press_min" reuseLastValue="0"/>
  <field name="presszone_head" reuseLastValue="0"/>
  <field name="presszone_id" reuseLastValue="0"/>
  <field name="presszone_name" reuseLastValue="0"/>
  <field name="presszone_style" reuseLastValue="0"/>
  <field name="presszone_type" reuseLastValue="0"/>
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
  <field name="serial_number" reuseLastValue="0"/>
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
 <previewExpression>"sector_name"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>0</layerGeometryType>
</qgis>' where layername = 'v_edit_connec' and styleconfig_id = 102;


update sys_style set stylevalue =
'<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" readOnly="0" maxScale="0" simplifyDrawingTol="1" simplifyAlgorithm="0" symbologyReferenceScale="-1" version="3.28.5-Firenze" styleCategories="AllStyleCategories" minScale="2500" labelsEnabled="0" simplifyLocal="1" simplifyDrawingHints="1">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" endField="" fixedDuration="0" mode="0" startExpression="" enabled="0" endExpression="" durationField="" accumulate="0" durationUnit="min" startField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation binding="Centroid" showMarkerSymbolInSurfacePlots="0" zoffset="0" symbology="Line" extrusionEnabled="0" respectLayerSymbol="1" zscale="1" extrusion="0" clamping="Terrain" type="IndividualFeatures">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" name="name" type="QString"/>
    <Option name="properties"/>
    <Option value="collection" name="type" type="QString"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
      <Option value="125,139,143,255" name="line_color" type="QString"/>
      <Option value="solid" name="line_style" type="QString"/>
      <Option value="0.6" name="line_width" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="fill" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleFill">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale" type="QString"/>
      <Option value="125,139,143,255" name="color" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="89,99,102,255" name="outline_color" type="QString"/>
      <Option value="solid" name="outline_style" type="QString"/>
      <Option value="0.2" name="outline_width" type="QString"/>
      <Option value="MM" name="outline_width_unit" type="QString"/>
      <Option value="solid" name="style" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="marker" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
     <Option type="Map">
      <Option value="0" name="angle" type="QString"/>
      <Option value="square" name="cap_style" type="QString"/>
      <Option value="125,139,143,255" name="color" type="QString"/>
      <Option value="1" name="horizontal_anchor_point" type="QString"/>
      <Option value="bevel" name="joinstyle" type="QString"/>
      <Option value="diamond" name="name" type="QString"/>
      <Option value="0,0" name="offset" type="QString"/>
      <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
      <Option value="MM" name="offset_unit" type="QString"/>
      <Option value="89,99,102,255" name="outline_color" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 attr="inp_type" forceraster="0" type="categorizedSymbol" enableorderby="0" symbollevels="0" referencescale="-1">
  <categories>
   <category symbol="0" render="true" value="JUNCTION" label="JUNCTION" type="string"/>
   <category symbol="1" render="true" value="" label="NOT USED" type="string"/>
  </categories>
  <symbols>
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
      <Option value="49,232,238,255" name="line_color" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="GeometryGenerator">
     <Option type="Map">
      <Option value="Marker" name="SymbolType" type="QString"/>
      <Option value="end_point ($geometry)" name="geometryModifier" type="QString"/>
      <Option value="MapUnit" name="units" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@0@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="49,232,238,255" name="color" type="QString"/>
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
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="1" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
      <Option value="215,215,215,255" name="line_color" type="QString"/>
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="GeometryGenerator">
     <Option type="Map">
      <Option value="Marker" name="SymbolType" type="QString"/>
      <Option value="end_point ($geometry)" name="geometryModifier" type="QString"/>
      <Option value="MapUnit" name="units" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@1@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
       <Option type="Map">
        <Option value="0" name="angle" type="QString"/>
        <Option value="square" name="cap_style" type="QString"/>
        <Option value="215,215,215,255" name="color" type="QString"/>
        <Option value="1" name="horizontal_anchor_point" type="QString"/>
        <Option value="bevel" name="joinstyle" type="QString"/>
        <Option value="circle" name="name" type="QString"/>
        <Option value="0,0" name="offset" type="QString"/>
        <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
        <Option value="MM" name="offset_unit" type="QString"/>
        <Option value="215,215,215,255" name="outline_color" type="QString"/>
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
   <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="0" type="line" force_rhr="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" name="name" type="QString"/>
      <Option name="properties"/>
      <Option value="collection" name="type" type="QString"/>
     </Option>
    </data_defined_properties>
    <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer pass="0" locked="0" enabled="1" class="GeometryGenerator">
     <Option type="Map">
      <Option value="Marker" name="SymbolType" type="QString"/>
      <Option value="end_point ($geometry)" name="geometryModifier" type="QString"/>
      <Option value="MapUnit" name="units" type="QString"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="@0@1" type="marker" force_rhr="0" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
       </Option>
      </data_defined_properties>
      <layer pass="0" locked="0" enabled="1" class="SimpleMarker">
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
  </source-symbol>
  <colorramp name="[source]" type="randomcolors">
   <Option/>
  </colorramp>
  <rotation/>
  <sizescale/>
 </renderer-v2>
 <customproperties>
  <Option type="Map">
   <Option name="dualview/previewExpressions" type="List">
    <Option value="&quot;sector_name&quot;" type="QString"/>
   </Option>
   <Option value="0" name="embeddedWidgets/count" type="QString"/>
   <Option name="variableNames"/>
   <Option name="variableValues"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory barWidth="5" showAxis="1" sizeType="MM" lineSizeType="MM" lineSizeScale="3x:0,0,0,0,0,0" scaleDependency="Area" width="15" backgroundAlpha="255" penColor="#000000" height="15" diagramOrientation="Up" penWidth="0" labelPlacementMethod="XHeight" scaleBasedVisibility="0" spacingUnit="MM" spacingUnitScale="3x:0,0,0,0,0,0" minimumSize="0" rotationOffset="270" penAlpha="255" minScaleDenominator="0" spacing="5" backgroundColor="#ffffff" opacity="1" sizeScale="3x:0,0,0,0,0,0" maxScaleDenominator="0" enabled="0" direction="0">
   <fontProperties strikethrough="0" italic="0" underline="0" bold="0" description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style=""/>
   <axisSymbol>
    <symbol clip_to_extent="1" is_animated="0" frame_rate="10" name="" type="line" force_rhr="0" alpha="1">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" name="name" type="QString"/>
       <Option name="properties"/>
       <Option value="collection" name="type" type="QString"/>
      </Option>
     </data_defined_properties>
     <layer pass="0" locked="0" enabled="1" class="SimpleLine">
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
 <DiagramLayerSettings linePlacementFlags="18" obstacle="0" placement="2" dist="0" priority="0" showAll="1" zIndex="0">
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
  <field name="sector_name" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" name="IsMultiline" type="bool"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field name="sector_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="presszone_id" configurationFlags="None">
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
  <field name="presszone_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="presszone_head" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="dma_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="dqa_id" configurationFlags="None">
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
  <field name="dqa_type" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="muni_id" configurationFlags="None">
   <editWidget type="Range">
    <config>
     <Option/>
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
  <field name="staticpressure" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
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
  <field name="lastupdate" configurationFlags="None">
   <editWidget type="DateTime">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="lastupdate_user" configurationFlags="None">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="uncertain" configurationFlags="None">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" name="CheckedState" type="QString"/>
      <Option value="false" name="UncheckedState" type="QString"/>
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
  <field name="macrominsector_id" configurationFlags="None">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field name="inp_type" configurationFlags="None">
   <editWidget type="TextEdit">
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
  <alias field="exit_type" index="3" name="exit_type"/>
  <alias field="exit_id" index="4" name="exit_id"/>
  <alias field="state" index="5" name="state"/>
  <alias field="expl_id" index="6" name="expl_id"/>
  <alias field="sector_id" index="7" name="sector_id"/>
  <alias field="sector_name" index="8" name="sector_name"/>
  <alias field="sector_type" index="9" name=""/>
  <alias field="macrosector_id" index="10" name="macrosector_id"/>
  <alias field="presszone_id" index="11" name="Presszone"/>
  <alias field="presszone_name" index="12" name="presszone_name"/>
  <alias field="presszone_type" index="13" name=""/>
  <alias field="presszone_head" index="14" name=""/>
  <alias field="dma_id" index="15" name="dma_id"/>
  <alias field="dma_name" index="16" name="dma_name"/>
  <alias field="dma_type" index="17" name=""/>
  <alias field="macrodma_id" index="18" name="macrodma_id"/>
  <alias field="dqa_id" index="19" name="Dqa"/>
  <alias field="dqa_name" index="20" name="dqa_name"/>
  <alias field="dqa_type" index="21" name=""/>
  <alias field="macrodqa_id" index="22" name="macrodqa_id"/>
  <alias field="exit_topelev" index="23" name="Exit elevation"/>
  <alias field="exit_elev" index="24" name="exit_elev"/>
  <alias field="fluid_type" index="25" name="fluid_type"/>
  <alias field="gis_length" index="26" name="gis_length"/>
  <alias field="muni_id" index="27" name=""/>
  <alias field="expl_id2" index="28" name=""/>
  <alias field="epa_type" index="29" name="epa_type"/>
  <alias field="is_operative" index="30" name="is_operative"/>
  <alias field="staticpressure" index="31" name=""/>
  <alias field="connecat_id" index="32" name="connecat_id"/>
  <alias field="workcat_id" index="33" name="work_id"/>
  <alias field="workcat_id_end" index="34" name="work_id_end"/>
  <alias field="builtdate" index="35" name="builtdate"/>
  <alias field="enddate" index="36" name="enddate"/>
  <alias field="lastupdate" index="37" name=""/>
  <alias field="lastupdate_user" index="38" name=""/>
  <alias field="uncertain" index="39" name="Uncertain"/>
  <alias field="minsector_id" index="40" name="minsector_id"/>
  <alias field="macrominsector_id" index="41" name=""/>
  <alias field="inp_type" index="42" name=""/>
 </aliases>
 <defaults>
  <default field="link_id" expression="" applyOnUpdate="0"/>
  <default field="feature_type" expression="" applyOnUpdate="0"/>
  <default field="feature_id" expression="" applyOnUpdate="0"/>
  <default field="exit_type" expression="" applyOnUpdate="0"/>
  <default field="exit_id" expression="" applyOnUpdate="0"/>
  <default field="state" expression="" applyOnUpdate="0"/>
  <default field="expl_id" expression="" applyOnUpdate="0"/>
  <default field="sector_id" expression="" applyOnUpdate="0"/>
  <default field="sector_name" expression="" applyOnUpdate="0"/>
  <default field="sector_type" expression="" applyOnUpdate="0"/>
  <default field="macrosector_id" expression="" applyOnUpdate="0"/>
  <default field="presszone_id" expression="" applyOnUpdate="0"/>
  <default field="presszone_name" expression="" applyOnUpdate="0"/>
  <default field="presszone_type" expression="" applyOnUpdate="0"/>
  <default field="presszone_head" expression="" applyOnUpdate="0"/>
  <default field="dma_id" expression="" applyOnUpdate="0"/>
  <default field="dma_name" expression="" applyOnUpdate="0"/>
  <default field="dma_type" expression="" applyOnUpdate="0"/>
  <default field="macrodma_id" expression="" applyOnUpdate="0"/>
  <default field="dqa_id" expression="" applyOnUpdate="0"/>
  <default field="dqa_name" expression="" applyOnUpdate="0"/>
  <default field="dqa_type" expression="" applyOnUpdate="0"/>
  <default field="macrodqa_id" expression="" applyOnUpdate="0"/>
  <default field="exit_topelev" expression="" applyOnUpdate="0"/>
  <default field="exit_elev" expression="" applyOnUpdate="0"/>
  <default field="fluid_type" expression="" applyOnUpdate="0"/>
  <default field="gis_length" expression="" applyOnUpdate="0"/>
  <default field="muni_id" expression="" applyOnUpdate="0"/>
  <default field="expl_id2" expression="" applyOnUpdate="0"/>
  <default field="epa_type" expression="" applyOnUpdate="0"/>
  <default field="is_operative" expression="" applyOnUpdate="0"/>
  <default field="staticpressure" expression="" applyOnUpdate="0"/>
  <default field="connecat_id" expression="" applyOnUpdate="0"/>
  <default field="workcat_id" expression="" applyOnUpdate="0"/>
  <default field="workcat_id_end" expression="" applyOnUpdate="0"/>
  <default field="builtdate" expression="" applyOnUpdate="0"/>
  <default field="enddate" expression="" applyOnUpdate="0"/>
  <default field="lastupdate" expression="" applyOnUpdate="0"/>
  <default field="lastupdate_user" expression="" applyOnUpdate="0"/>
  <default field="uncertain" expression="" applyOnUpdate="0"/>
  <default field="minsector_id" expression="" applyOnUpdate="0"/>
  <default field="macrominsector_id" expression="" applyOnUpdate="0"/>
  <default field="inp_type" expression="" applyOnUpdate="0"/>
 </defaults>
 <constraints>
  <constraint field="link_id" unique_strength="1" notnull_strength="1" exp_strength="0" constraints="3"/>
  <constraint field="feature_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="feature_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="exit_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="exit_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="state" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="sector_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrosector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="presszone_head" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dma_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodma_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_name" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="dqa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrodqa_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="exit_topelev" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="exit_elev" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="fluid_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="gis_length" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="muni_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="expl_id2" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="epa_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="is_operative" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="staticpressure" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="connecat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="workcat_id_end" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="builtdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="enddate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="lastupdate_user" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="uncertain" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="minsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="macrominsector_id" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
  <constraint field="inp_type" unique_strength="0" notnull_strength="0" exp_strength="0" constraints="0"/>
 </constraints>
 <constraintExpressions>
  <constraint field="link_id" desc="" exp=""/>
  <constraint field="feature_type" desc="" exp=""/>
  <constraint field="feature_id" desc="" exp=""/>
  <constraint field="exit_type" desc="" exp=""/>
  <constraint field="exit_id" desc="" exp=""/>
  <constraint field="state" desc="" exp=""/>
  <constraint field="expl_id" desc="" exp=""/>
  <constraint field="sector_id" desc="" exp=""/>
  <constraint field="sector_name" desc="" exp=""/>
  <constraint field="sector_type" desc="" exp=""/>
  <constraint field="macrosector_id" desc="" exp=""/>
  <constraint field="presszone_id" desc="" exp=""/>
  <constraint field="presszone_name" desc="" exp=""/>
  <constraint field="presszone_type" desc="" exp=""/>
  <constraint field="presszone_head" desc="" exp=""/>
  <constraint field="dma_id" desc="" exp=""/>
  <constraint field="dma_name" desc="" exp=""/>
  <constraint field="dma_type" desc="" exp=""/>
  <constraint field="macrodma_id" desc="" exp=""/>
  <constraint field="dqa_id" desc="" exp=""/>
  <constraint field="dqa_name" desc="" exp=""/>
  <constraint field="dqa_type" desc="" exp=""/>
  <constraint field="macrodqa_id" desc="" exp=""/>
  <constraint field="exit_topelev" desc="" exp=""/>
  <constraint field="exit_elev" desc="" exp=""/>
  <constraint field="fluid_type" desc="" exp=""/>
  <constraint field="gis_length" desc="" exp=""/>
  <constraint field="muni_id" desc="" exp=""/>
  <constraint field="expl_id2" desc="" exp=""/>
  <constraint field="epa_type" desc="" exp=""/>
  <constraint field="is_operative" desc="" exp=""/>
  <constraint field="staticpressure" desc="" exp=""/>
  <constraint field="connecat_id" desc="" exp=""/>
  <constraint field="workcat_id" desc="" exp=""/>
  <constraint field="workcat_id_end" desc="" exp=""/>
  <constraint field="builtdate" desc="" exp=""/>
  <constraint field="enddate" desc="" exp=""/>
  <constraint field="lastupdate" desc="" exp=""/>
  <constraint field="lastupdate_user" desc="" exp=""/>
  <constraint field="uncertain" desc="" exp=""/>
  <constraint field="minsector_id" desc="" exp=""/>
  <constraint field="macrominsector_id" desc="" exp=""/>
  <constraint field="inp_type" desc="" exp=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortOrder="0" actionWidgetStyle="dropDown" sortExpression="">
  <columns>
   <column hidden="0" width="-1" name="link_id" type="field"/>
   <column hidden="0" width="-1" name="feature_type" type="field"/>
   <column hidden="0" width="-1" name="feature_id" type="field"/>
   <column hidden="0" width="-1" name="exit_type" type="field"/>
   <column hidden="0" width="-1" name="exit_id" type="field"/>
   <column hidden="0" width="-1" name="state" type="field"/>
   <column hidden="0" width="-1" name="expl_id" type="field"/>
   <column hidden="0" width="-1" name="sector_id" type="field"/>
   <column hidden="0" width="-1" name="sector_name" type="field"/>
   <column hidden="0" width="-1" name="sector_type" type="field"/>
   <column hidden="0" width="-1" name="macrosector_id" type="field"/>
   <column hidden="0" width="-1" name="presszone_id" type="field"/>
   <column hidden="0" width="-1" name="presszone_name" type="field"/>
   <column hidden="0" width="-1" name="presszone_type" type="field"/>
   <column hidden="0" width="-1" name="presszone_head" type="field"/>
   <column hidden="0" width="-1" name="dma_id" type="field"/>
   <column hidden="0" width="-1" name="dma_name" type="field"/>
   <column hidden="0" width="-1" name="dma_type" type="field"/>
   <column hidden="0" width="-1" name="macrodma_id" type="field"/>
   <column hidden="0" width="-1" name="dqa_id" type="field"/>
   <column hidden="0" width="-1" name="dqa_name" type="field"/>
   <column hidden="0" width="-1" name="dqa_type" type="field"/>
   <column hidden="0" width="-1" name="macrodqa_id" type="field"/>
   <column hidden="0" width="-1" name="exit_topelev" type="field"/>
   <column hidden="0" width="-1" name="exit_elev" type="field"/>
   <column hidden="0" width="-1" name="fluid_type" type="field"/>
   <column hidden="0" width="-1" name="gis_length" type="field"/>
   <column hidden="0" width="-1" name="muni_id" type="field"/>
   <column hidden="0" width="-1" name="expl_id2" type="field"/>
   <column hidden="0" width="-1" name="epa_type" type="field"/>
   <column hidden="0" width="-1" name="is_operative" type="field"/>
   <column hidden="0" width="-1" name="staticpressure" type="field"/>
   <column hidden="0" width="-1" name="connecat_id" type="field"/>
   <column hidden="0" width="-1" name="workcat_id" type="field"/>
   <column hidden="0" width="-1" name="workcat_id_end" type="field"/>
   <column hidden="0" width="-1" name="builtdate" type="field"/>
   <column hidden="0" width="-1" name="enddate" type="field"/>
   <column hidden="0" width="-1" name="lastupdate" type="field"/>
   <column hidden="0" width="-1" name="lastupdate_user" type="field"/>
   <column hidden="0" width="-1" name="uncertain" type="field"/>
   <column hidden="0" width="-1" name="minsector_id" type="field"/>
   <column hidden="0" width="-1" name="macrominsector_id" type="field"/>
   <column hidden="0" width="-1" name="inp_type" type="field"/>
   <column hidden="1" width="-1" type="actions"/>
  </columns>
 </attributetableconfig>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <storedexpressions/>
 <editform tolerant="1">C:/Users/Usuario/Documents</editform>
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
  <field name="builtdate" editable="1"/>
  <field name="connecat_id" editable="1"/>
  <field name="dma_id" editable="1"/>
  <field name="dma_name" editable="1"/>
  <field name="dma_type" editable="1"/>
  <field name="dqa_id" editable="1"/>
  <field name="dqa_name" editable="1"/>
  <field name="dqa_type" editable="1"/>
  <field name="enddate" editable="1"/>
  <field name="epa_type" editable="1"/>
  <field name="exit_elev" editable="1"/>
  <field name="exit_id" editable="1"/>
  <field name="exit_topelev" editable="1"/>
  <field name="exit_type" editable="1"/>
  <field name="expl_id" editable="1"/>
  <field name="expl_id2" editable="1"/>
  <field name="feature_id" editable="1"/>
  <field name="feature_type" editable="1"/>
  <field name="fluid_type" editable="1"/>
  <field name="gis_length" editable="1"/>
  <field name="inp_type" editable="1"/>
  <field name="is_operative" editable="1"/>
  <field name="lastupdate" editable="1"/>
  <field name="lastupdate_user" editable="1"/>
  <field name="link_id" editable="1"/>
  <field name="macrodma_id" editable="1"/>
  <field name="macrodqa_id" editable="1"/>
  <field name="macrominsector_id" editable="1"/>
  <field name="macrosector_id" editable="1"/>
  <field name="minsector_id" editable="1"/>
  <field name="muni_id" editable="1"/>
  <field name="presszone_head" editable="1"/>
  <field name="presszone_id" editable="1"/>
  <field name="presszone_name" editable="1"/>
  <field name="presszone_type" editable="1"/>
  <field name="sector_id" editable="1"/>
  <field name="sector_name" editable="1"/>
  <field name="sector_type" editable="1"/>
  <field name="state" editable="1"/>
  <field name="staticpressure" editable="1"/>
  <field name="uncertain" editable="1"/>
  <field name="workcat_id" editable="1"/>
  <field name="workcat_id_end" editable="1"/>
 </editable>
 <labelOnTop>
  <field labelOnTop="0" name="builtdate"/>
  <field labelOnTop="0" name="connecat_id"/>
  <field labelOnTop="0" name="dma_id"/>
  <field labelOnTop="0" name="dma_name"/>
  <field labelOnTop="0" name="dma_type"/>
  <field labelOnTop="0" name="dqa_id"/>
  <field labelOnTop="0" name="dqa_name"/>
  <field labelOnTop="0" name="dqa_type"/>
  <field labelOnTop="0" name="enddate"/>
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
  <field labelOnTop="0" name="inp_type"/>
  <field labelOnTop="0" name="is_operative"/>
  <field labelOnTop="0" name="lastupdate"/>
  <field labelOnTop="0" name="lastupdate_user"/>
  <field labelOnTop="0" name="link_id"/>
  <field labelOnTop="0" name="macrodma_id"/>
  <field labelOnTop="0" name="macrodqa_id"/>
  <field labelOnTop="0" name="macrominsector_id"/>
  <field labelOnTop="0" name="macrosector_id"/>
  <field labelOnTop="0" name="minsector_id"/>
  <field labelOnTop="0" name="muni_id"/>
  <field labelOnTop="0" name="presszone_head"/>
  <field labelOnTop="0" name="presszone_id"/>
  <field labelOnTop="0" name="presszone_name"/>
  <field labelOnTop="0" name="presszone_type"/>
  <field labelOnTop="0" name="sector_id"/>
  <field labelOnTop="0" name="sector_name"/>
  <field labelOnTop="0" name="sector_type"/>
  <field labelOnTop="0" name="state"/>
  <field labelOnTop="0" name="staticpressure"/>
  <field labelOnTop="0" name="uncertain"/>
  <field labelOnTop="0" name="workcat_id"/>
  <field labelOnTop="0" name="workcat_id_end"/>
 </labelOnTop>
 <reuseLastValue>
  <field name="builtdate" reuseLastValue="0"/>
  <field name="connecat_id" reuseLastValue="0"/>
  <field name="dma_id" reuseLastValue="0"/>
  <field name="dma_name" reuseLastValue="0"/>
  <field name="dma_type" reuseLastValue="0"/>
  <field name="dqa_id" reuseLastValue="0"/>
  <field name="dqa_name" reuseLastValue="0"/>
  <field name="dqa_type" reuseLastValue="0"/>
  <field name="enddate" reuseLastValue="0"/>
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
  <field name="inp_type" reuseLastValue="0"/>
  <field name="is_operative" reuseLastValue="0"/>
  <field name="lastupdate" reuseLastValue="0"/>
  <field name="lastupdate_user" reuseLastValue="0"/>
  <field name="link_id" reuseLastValue="0"/>
  <field name="macrodma_id" reuseLastValue="0"/>
  <field name="macrodqa_id" reuseLastValue="0"/>
  <field name="macrominsector_id" reuseLastValue="0"/>
  <field name="macrosector_id" reuseLastValue="0"/>
  <field name="minsector_id" reuseLastValue="0"/>
  <field name="muni_id" reuseLastValue="0"/>
  <field name="presszone_head" reuseLastValue="0"/>
  <field name="presszone_id" reuseLastValue="0"/>
  <field name="presszone_name" reuseLastValue="0"/>
  <field name="presszone_type" reuseLastValue="0"/>
  <field name="sector_id" reuseLastValue="0"/>
  <field name="sector_name" reuseLastValue="0"/>
  <field name="sector_type" reuseLastValue="0"/>
  <field name="state" reuseLastValue="0"/>
  <field name="staticpressure" reuseLastValue="0"/>
  <field name="uncertain" reuseLastValue="0"/>
  <field name="workcat_id" reuseLastValue="0"/>
  <field name="workcat_id_end" reuseLastValue="0"/>
 </reuseLastValue>
 <dataDefinedFieldProperties/>
 <widgets/>
 <previewExpression>"sector_name"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>1</layerGeometryType>
</qgis>' where layername = 'v_edit_link' and styleconfig_id = 102;