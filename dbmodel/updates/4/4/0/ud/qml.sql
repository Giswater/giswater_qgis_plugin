/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="RuleRenderer" enableorderby="0">
  <rules key="{726173c1-e48a-4505-bde5-b50ffb7bba39}">
   <rule scalemaxdenom="25000" label="Storage" key="{d22d6bf4-55db-4cb5-8b49-25a3c52a3d1b}" filter="&quot;sys_type&quot; = ''STORAGE''" symbol="0"/>
   <rule scalemaxdenom="25000" label="Chamber" key="{2ad49ef6-10ef-413f-9dc9-82ff5a236362}" filter="&quot;sys_type&quot; = ''CHAMBER''" symbol="1"/>
   <rule scalemaxdenom="25000" label="Wwtp" key="{fbe58f73-553d-4064-8e10-43eed3ee776f}" filter="&quot;sys_type&quot; = ''WWTP''" symbol="2"/>
   <rule scalemaxdenom="10000" label="Netgully" key="{93522d7c-98e1-4e5f-a8ed-62fd17ca4f1f}" filter="&quot;sys_type&quot; = ''NETGULLY''" symbol="3"/>
   <rule scalemaxdenom="10000" label="Netelement" key="{e9f34e9b-5335-4553-aad1-8f52fb4b7fd9}" filter="&quot;sys_type&quot; = ''NETELEMENT''" symbol="4"/>
   <rule scalemaxdenom="10000" label="Manhole" key="{c4d73b40-d93d-4ba0-b066-ff35c7a380fa}" filter="&quot;sys_type&quot; = ''MANHOLE''" symbol="5"/>
   <rule scalemaxdenom="10000" label="Netinit" key="{ab7634fb-6056-43cb-b569-bed1e561bc34}" filter="&quot;sys_type&quot; = ''NETINIT''" symbol="6"/>
   <rule scalemaxdenom="10000" label="Wjump" key="{010803db-b772-4cda-b196-1767fa88163b}" filter="&quot;sys_type&quot; = ''WJUMP''" symbol="7"/>
   <rule scalemaxdenom="10000" label="Junction" key="{1aea5824-3d04-41eb-9016-bc26e1c51f00}" filter="&quot;sys_type&quot; = ''JUNCTION''" symbol="8"/>
   <rule scalemaxdenom="10000" label="Outfall" key="{be5b7b53-a9d4-4085-af09-11a3194dacd4}" filter="&quot;sys_type&quot; = ''OUTFALL''" symbol="9"/>
   <rule scalemaxdenom="10000" label="Valve" key="{75dd03f5-eb03-4155-8f29-0179198c1276}" filter="&quot;sys_type&quot; = ''VALVE''" symbol="10"/>
   <rule label="ELSE" key="{a1136c92-02fe-48ae-a5fb-ee4cc74ed59b}" filter="ELSE" symbol="11"/>
  </rules>
  <symbols>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{4139793a-18d0-4b5c-bc75-f41f3a7b5779}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="44,67,207,255,rgb:0.17254901960784313,0.2627450980392157,0.81176470588235294,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="square" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.5" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="4.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{1179b589-e711-4659-b3d7-67d5f3da78f2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="square" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.5" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="4.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="10" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{2d774c18-3b60-4c9e-9ecd-53008777ba97}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="11" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{598777f4-654c-4e8c-9281-7cf254454945}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{209eda1d-d4a0-438c-9173-3ef3ab79623a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="square" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="0.5" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="4.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{4702f03f-33d6-4014-970d-18db360c593b}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.666667*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 4.5, 0.5, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="3" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{235b2722-111d-46ee-a67e-273027c81abf}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="106,233,255,0,rgb:0.41568627450980394,0.9137254901960784,1,0" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="1.8" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="4" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{44b56ed7-0be5-4cee-aee0-e9bb26e8ed60}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="129,10,78,255,rgb:0.50588235294117645,0.0392156862745098,0.30588235294117649,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="5" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{d37e5a6f-35ff-4504-8e37-feea38bb15a2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="106,233,255,255,rgb:0.41568627450980394,0.9137254901960784,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="6" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{14da8ea3-17a9-467a-b864-7165f04e9ddf}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="26,115,162,255,rgb:0.10196078431372549,0.45098039215686275,0.63529411764705879,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="4" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="7" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{4bf54520-34f7-444b-ae0a-bf5c8d7c207c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="147,218,255,255,rgb:0.57647058823529407,0.85490196078431369,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{01761201-7176-4576-9d02-30625002275d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="147,218,255,255,rgb:0.57647058823529407,0.85490196078431369,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="0.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.25*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 3.5, 0.3, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="8" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{0a9a2686-2556-4dc6-827c-3e56cbb69f62}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="45,136,255,255,rgb:0.17647058823529413,0.53333333333333333,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{adcb4267-a7be-4bab-afa4-94532d0b03e2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,0,rgb:1,0,0,0" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="0.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.25*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 3.5, 0.3, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="9" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{5edc1944-7988-4ed8-8960-7f2c9711180b}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="227,26,28,255,rgb:0.8901960784313725,0.10196078431372549,0.10980392156862745,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="filled_arrowhead" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.36999999999999994" type="double" name="exponent"/>
           <Option value="0.3" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="3" type="int" name="scaleType"/>
          </Option>
          <Option value="1" type="int" name="t"/>
         </Option>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </symbols>
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{4dde61b6-903a-4c6e-b4dc-07a344b202e2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </selectionSymbol>
 </selection>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerGeometryType>0</layerGeometryType>
</qgis>
' WHERE layername='ve_node' AND styleconfig_id=101;

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="categorizedSymbol" attr="state" enableorderby="0">
  <categories>
   <category render="true" value="0" label="OBSOLETE" type="double" uuid="{80823eb1-ba4e-4517-8d07-82b656725f9b}" symbol="0"/>
   <category render="true" value="1" label="OPERATIVE" type="string" uuid="{718813e6-c212-4d14-b2d5-b98922743e2c}" symbol="1"/>
   <category render="true" value="2" label="PLANIFIED" type="double" uuid="{f2a68c83-ffba-48c2-9142-acb8ab246deb}" symbol="2"/>
   <category render="true" value="NULL" label="ELSE" type="NULL" uuid="{008959b5-0990-4a3e-b59c-737e6def7796}" symbol="3"/>
  </categories>
  <symbols>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.36" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="MarkerLine" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="4" type="QString" name="average_angle_length"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="average_angle_map_unit_scale"/>
      <Option value="MM" type="QString" name="average_angle_unit"/>
      <Option value="3" type="QString" name="interval"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="interval_map_unit_scale"/>
      <Option value="MM" type="QString" name="interval_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="0" type="QString" name="offset_along_line"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_along_line_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_along_line_unit"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="true" type="bool" name="place_on_every_part"/>
      <Option value="CentralPoint" type="QString" name="placements"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="1" type="QString" name="rotate"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="@0@1" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer class="SimpleMarker" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="234,81,83,255,hsv:0.99833333333333329,0.6537575341420615,0.91807431143663687,1" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="filled_arrowhead" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
        <Option value="solid" type="QString" name="outline_style"/>
        <Option value="0" type="QString" name="outline_width"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
        <Option value="MM" type="QString" name="outline_width_unit"/>
        <Option value="diameter" type="QString" name="scale_method"/>
        <Option value="0.36" type="QString" name="size"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
        <Option value="MM" type="QString" name="size_unit"/>
        <Option value="1" type="QString" name="vertical_anchor_point"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" type="QString" name="name"/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option value="true" type="bool" name="active"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" type="QString" name="expression"/>
           <Option value="3" type="int" name="type"/>
          </Option>
         </Option>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="1" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.36" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleLine" pass="0" id="{7684a725-426f-47d3-859a-9e4bb0b9a024}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="219,219,219,0,hsv:0,0,0.86047150377660797,0" type="QString" name="line_color"/>
      <Option value="dot" type="QString" name="line_style"/>
      <Option value="0.3" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineColor">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when initoverflowpath = true then color_rgba(255,255,255,200) else color_rgba(100,100,100,0) end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.1 + 0.415 * ln((cat_geom1*cat_geom2) + 0.10)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.1 + 0.415 * ln((3.14*cat_geom1*cat_geom1/2) + 0.10)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="MarkerLine" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="4" type="QString" name="average_angle_length"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="average_angle_map_unit_scale"/>
      <Option value="MM" type="QString" name="average_angle_unit"/>
      <Option value="3" type="QString" name="interval"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="interval_map_unit_scale"/>
      <Option value="MM" type="QString" name="interval_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="0" type="QString" name="offset_along_line"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_along_line_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_along_line_unit"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="true" type="bool" name="place_on_every_part"/>
      <Option value="CentralPoint" type="QString" name="placements"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="1" type="QString" name="rotate"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="@1@2" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer class="SimpleMarker" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="filled_arrowhead" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
        <Option value="solid" type="QString" name="outline_style"/>
        <Option value="0" type="QString" name="outline_width"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
        <Option value="MM" type="QString" name="outline_width_unit"/>
        <Option value="diameter" type="QString" name="scale_method"/>
        <Option value="2.56" type="QString" name="size"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
        <Option value="MM" type="QString" name="size_unit"/>
        <Option value="1" type="QString" name="vertical_anchor_point"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" type="QString" name="name"/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option value="true" type="bool" name="active"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1500 THEN 3.0 &#xd;&#xa;WHEN @map_scale  > 1500 THEN 0&#xd;&#xa;END" type="QString" name="expression"/>
           <Option value="3" type="int" name="type"/>
          </Option>
         </Option>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.36" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="MarkerLine" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="4" type="QString" name="average_angle_length"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="average_angle_map_unit_scale"/>
      <Option value="MM" type="QString" name="average_angle_unit"/>
      <Option value="3" type="QString" name="interval"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="interval_map_unit_scale"/>
      <Option value="MM" type="QString" name="interval_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="0" type="QString" name="offset_along_line"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_along_line_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_along_line_unit"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="true" type="bool" name="place_on_every_part"/>
      <Option value="CentralPoint" type="QString" name="placements"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="1" type="QString" name="rotate"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="@2@1" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer class="SimpleMarker" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="filled_arrowhead" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
        <Option value="solid" type="QString" name="outline_style"/>
        <Option value="0" type="QString" name="outline_width"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
        <Option value="MM" type="QString" name="outline_width_unit"/>
        <Option value="diameter" type="QString" name="scale_method"/>
        <Option value="0.36" type="QString" name="size"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
        <Option value="MM" type="QString" name="size_unit"/>
        <Option value="1" type="QString" name="vertical_anchor_point"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" type="QString" name="name"/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option value="true" type="bool" name="active"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" type="QString" name="expression"/>
           <Option value="3" type="int" name="type"/>
          </Option>
         </Option>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="3" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{125567a8-a047-460b-9af5-14ba91bb9a69}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.36" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleLine" pass="0" id="{7684a725-426f-47d3-859a-9e4bb0b9a024}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="line_color"/>
      <Option value="dot" type="QString" name="line_style"/>
      <Option value="0.3" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineColor">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when initoverflowpath = true then color_rgba(255,255,255,200) else color_rgba(100,100,100,0) end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.1 + 0.415 * ln((cat_geom1*cat_geom2) + 0.10)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.1 + 0.415 * ln((3.14*cat_geom1*cat_geom1/2) + 0.10)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="MarkerLine" pass="0" id="{867127f5-d842-49bc-9fe7-f0c443d7eb32}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="4" type="QString" name="average_angle_length"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="average_angle_map_unit_scale"/>
      <Option value="MM" type="QString" name="average_angle_unit"/>
      <Option value="3" type="QString" name="interval"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="interval_map_unit_scale"/>
      <Option value="MM" type="QString" name="interval_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="0" type="QString" name="offset_along_line"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_along_line_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_along_line_unit"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="true" type="bool" name="place_on_every_part"/>
      <Option value="CentralPoint" type="QString" name="placements"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="1" type="QString" name="rotate"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when cat_geom2 > 0.5 and cat_geom2 &lt;50 then&#xd;&#xa;0.378 + 0.715 * ln((cat_geom1*cat_geom2) + 0.720)&#xd;&#xa;when cat_geom1 is not null then&#xd;&#xa;0.378 + 0.715 * ln((3.14*cat_geom1*cat_geom1/2) + 0.720)&#xd;&#xa;else 0.35 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="@3@2" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer class="SimpleMarker" pass="0" id="{8ffd9947-55a5-4c75-8756-c2fe1b12e838}" enabled="1" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="filled_arrowhead" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
        <Option value="solid" type="QString" name="outline_style"/>
        <Option value="0" type="QString" name="outline_width"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
        <Option value="MM" type="QString" name="outline_width_unit"/>
        <Option value="diameter" type="QString" name="scale_method"/>
        <Option value="2.56" type="QString" name="size"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
        <Option value="MM" type="QString" name="size_unit"/>
        <Option value="1" type="QString" name="vertical_anchor_point"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" type="QString" name="name"/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option value="true" type="bool" name="active"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1500 THEN 3.0 &#xd;&#xa;WHEN @map_scale  > 1500 THEN 0&#xd;&#xa;END" type="QString" name="expression"/>
           <Option value="3" type="int" name="type"/>
          </Option>
         </Option>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="0" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{3803a869-1bdf-438a-bb5c-37d3f352e512}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.36" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 0.55&#xd;&#xa;WHEN @map_scale  > 5000 THEN  &quot;conduit_cat_geom1&quot; * 0.4&#xd;&#xa;END" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="MarkerLine" pass="0" id="{737b3486-832c-473a-a370-2cfc286e6e75}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="4" type="QString" name="average_angle_length"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="average_angle_map_unit_scale"/>
      <Option value="MM" type="QString" name="average_angle_unit"/>
      <Option value="3" type="QString" name="interval"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="interval_map_unit_scale"/>
      <Option value="MM" type="QString" name="interval_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="0" type="QString" name="offset_along_line"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_along_line_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_along_line_unit"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="true" type="bool" name="place_on_every_part"/>
      <Option value="CentralPoint" type="QString" name="placements"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="1" type="QString" name="rotate"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="outlineWidth">
         <Option value="true" type="bool" name="active"/>
         <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 5000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 5000 THEN 0&#xd;&#xa;END" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="@0@1" alpha="1">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer class="SimpleMarker" pass="0" id="{48a00b63-2aee-4e04-a1cf-ef06d7691b80}" enabled="1" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="45,84,255,255,rgb:0.17647058823529413,0.32941176470588235,1,1" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="filled_arrowhead" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
        <Option value="solid" type="QString" name="outline_style"/>
        <Option value="0" type="QString" name="outline_width"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
        <Option value="MM" type="QString" name="outline_width_unit"/>
        <Option value="diameter" type="QString" name="scale_method"/>
        <Option value="0.36" type="QString" name="size"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
        <Option value="MM" type="QString" name="size_unit"/>
        <Option value="1" type="QString" name="vertical_anchor_point"/>
       </Option>
       <data_defined_properties>
        <Option type="Map">
         <Option value="" type="QString" name="name"/>
         <Option type="Map" name="properties">
          <Option type="Map" name="size">
           <Option value="true" type="bool" name="active"/>
           <Option value="CASE &#xd;&#xa;WHEN  @map_scale  &lt;= 1000 THEN 2.0 &#xd;&#xa;WHEN @map_scale  > 1000 THEN 0&#xd;&#xa;END" type="QString" name="expression"/>
           <Option value="3" type="int" name="type"/>
          </Option>
         </Option>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </source-symbol>
  <colorramp type="randomcolors" name="[source]">
   <Option/>
  </colorramp>
  <rotation/>
  <sizescale/>
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
 </renderer-v2>
 <selection mode="Default">
  <selectionColor invalid="1"/>
  <selectionSymbol>
   <symbol is_animated="0" force_rhr="0" type="line" clip_to_extent="1" frame_rate="10" name="" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleLine" pass="0" id="{3eade21d-240a-43fc-8947-ccec8cc9a73f}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="align_dash_pattern"/>
      <Option value="square" type="QString" name="capstyle"/>
      <Option value="5;2" type="QString" name="customdash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="customdash_map_unit_scale"/>
      <Option value="MM" type="QString" name="customdash_unit"/>
      <Option value="0" type="QString" name="dash_pattern_offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="dash_pattern_offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="dash_pattern_offset_unit"/>
      <Option value="0" type="QString" name="draw_inside_polygon"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.26" type="QString" name="line_width"/>
      <Option value="MM" type="QString" name="line_width_unit"/>
      <Option value="0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0" type="QString" name="ring_filter"/>
      <Option value="0" type="QString" name="trim_distance_end"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_end_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_end_unit"/>
      <Option value="0" type="QString" name="trim_distance_start"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="trim_distance_start_map_unit_scale"/>
      <Option value="MM" type="QString" name="trim_distance_start_unit"/>
      <Option value="0" type="QString" name="tweak_dash_pattern_on_corners"/>
      <Option value="0" type="QString" name="use_custom_dash"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="width_map_unit_scale"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
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
' WHERE layername='ve_arc' AND styleconfig_id=101;