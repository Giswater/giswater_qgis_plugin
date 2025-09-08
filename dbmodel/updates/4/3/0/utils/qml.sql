/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('ve_plan_psector', 110, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.7-Bratislava" styleCategories="Symbology">
 <renderer-v2 forceraster="0" type="RuleRenderer" symbollevels="0" referencescale="-1" enableorderby="0">
  <rules key="{27c5bcf5-31ab-4680-a34f-7d1469258a0b}">
   <rule key="{acd8b33b-d1cb-4560-9912-677a5b67bb73}" symbol="1" label="Active" filter="active is true"/>
   <rule key="{1a5745ef-3db0-447b-916c-16f80c5fad2f}" symbol="2" label="Inactive" filter="active is not true"/>
   <rule key="{d7963222-1f79-4e3c-81c2-99095fc5484b}" symbol="0" label="Archived" filter="status in (5,6,7)"/>
  </rules>
  <symbols>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="203,203,203,255,rgb:0.79607843137254897,0.79607843137254897,0.79607843137254897,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="203,203,203,255,hsv:0.82013888888888886,0,0.79452201113908594,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="b_diagonal" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="0,202,0,255,hsv:0.33333333333333331,1,0.792156862745098,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="255,149,0,255,rgb:1,0.58431372549019611,0,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
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
  <data-defined-properties>
   <Option type="Map">
    <Option type="QString" value="" name="name"/>
    <Option name="properties"/>
    <Option type="QString" value="collection" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{323b1679-e9a1-4444-89e5-7be9913c57d8}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="0,0,255,255,rgb:0,0,1,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.26" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="solid" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>2</layerGeometryType>
</qgis>
', true);


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.7-Bratislava" styleCategories="Symbology">
 <renderer-v2 forceraster="0" type="RuleRenderer" symbollevels="0" referencescale="-1" enableorderby="0">
  <rules key="{27c5bcf5-31ab-4680-a34f-7d1469258a0b}">
   <rule key="{acd8b33b-d1cb-4560-9912-677a5b67bb73}" symbol="1" label="Active" filter="active is true"/>
   <rule key="{1a5745ef-3db0-447b-916c-16f80c5fad2f}" symbol="2" label="Inactive" filter="active is not true"/>
   <rule key="{d7963222-1f79-4e3c-81c2-99095fc5484b}" symbol="0" label="Archived" filter="status in (5,6,7)"/>
  </rules>
  <symbols>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="203,203,203,255,rgb:0.79607843137254897,0.79607843137254897,0.79607843137254897,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="203,203,203,255,hsv:0.82013888888888886,0,0.79452201113908594,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="b_diagonal" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="0,202,0,255,hsv:0.33333333333333331,1,0.792156862745098,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{da502e84-2255-4840-b89b-b703671034aa}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="227,92,92,63,rgb:0.8901960784313725,0.36078431372549019,0.36078431372549019,0.24705882352941178" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="255,149,0,255,rgb:1,0.58431372549019611,0,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.75" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="no" name="style"/>
     </Option>
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
  <data-defined-properties>
   <Option type="Map">
    <Option type="QString" value="" name="name"/>
    <Option name="properties"/>
    <Option type="QString" value="collection" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol frame_rate="10" type="fill" clip_to_extent="1" is_animated="0" force_rhr="0" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option type="QString" value="" name="name"/>
      <Option name="properties"/>
      <Option type="QString" value="collection" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleFill" id="{323b1679-e9a1-4444-89e5-7be9913c57d8}" locked="0" pass="0" enabled="1">
     <Option type="Map">
      <Option type="QString" value="3x:0,0,0,0,0,0" name="border_width_map_unit_scale"/>
      <Option type="QString" value="0,0,255,255,rgb:0,0,1,1" name="color"/>
      <Option type="QString" value="bevel" name="joinstyle"/>
      <Option type="QString" value="0,0" name="offset"/>
      <Option type="QString" value="3x:0,0,0,0,0,0" name="offset_map_unit_scale"/>
      <Option type="QString" value="MM" name="offset_unit"/>
      <Option type="QString" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color"/>
      <Option type="QString" value="solid" name="outline_style"/>
      <Option type="QString" value="0.26" name="outline_width"/>
      <Option type="QString" value="MM" name="outline_width_unit"/>
      <Option type="QString" value="solid" name="style"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option type="QString" value="" name="name"/>
       <Option name="properties"/>
       <Option type="QString" value="collection" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>2</layerGeometryType>
</qgis>
' WHERE styleconfig_id=110;