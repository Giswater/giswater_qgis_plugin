/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="RuleRenderer" enableorderby="0">
  <rules key="{f9bd1dda-e8cb-4456-b498-a3f1312029f9}">
   <rule scalemaxdenom="25000" label="Wtp" key="{d0729bdd-7dcb-4e5d-9962-cd92c35d405e}" filter="&quot;sys_type&quot; = ''WTP''" symbol="0"/>
   <rule scalemaxdenom="25000" label="Waterwell" key="{2ecb80ea-9da6-4533-aad0-7275c5a08550}" filter="&quot;sys_type&quot; = ''WATERWELL''" symbol="1"/>
   <rule scalemaxdenom="25000" label="Source" key="{88ef1cea-1727-4681-9d7e-964bcfee179f}" filter="&quot;sys_type&quot; = ''SOURCE''" symbol="2"/>
   <rule scalemaxdenom="25000" label="Tank" key="{5d885b4a-fd95-42b2-8da9-717face5a272}" filter="&quot;sys_type&quot; = ''TANK''" symbol="3"/>
   <rule scalemaxdenom="10000" label="Expantank" key="{eed06555-2d38-4bfe-b114-13e014b63af1}" filter="&quot;sys_type&quot; = ''EXPANSIONTANK''" symbol="4"/>
   <rule scalemaxdenom="10000" label="Filter" key="{d2138541-5cb8-4896-b97e-494fa6df6d40}" filter="&quot;sys_type&quot; = ''FILTER''" symbol="5"/>
   <rule scalemaxdenom="10000" label="Flexunion" key="{9f0ffeda-84af-4676-9263-119eb6042786}" filter="&quot;sys_type&quot; = ''FLEXUNION''" symbol="6"/>
   <rule scalemaxdenom="10000" label="Hydrant" key="{bfe404fe-23c9-4c26-a91e-bc5e89b7203b}" filter="&quot;sys_type&quot; = ''HYDRANT''" symbol="7"/>
   <rule scalemaxdenom="10000" label="Meter" key="{70f23680-8f8d-4eb8-ad9d-b6c222b1359a}" filter="&quot;sys_type&quot; = ''METER''" symbol="8"/>
   <rule scalemaxdenom="10000" label="Netelement" key="{086f2a29-0a69-4a25-9b96-9f5d9f2955c1}" filter="&quot;sys_type&quot; = ''NETELEMENT''" symbol="9"/>
   <rule scalemaxdenom="10000" label="Netsamplepoint" key="{c0f1b0c8-34ee-4ec4-a914-97824ad2c467}" filter="&quot;sys_type&quot; = ''NETSAMPLEPOINT''" symbol="10"/>
   <rule scalemaxdenom="10000" label="Pump" key="{01479095-8f9e-40cf-b92b-6e13874561ae}" filter="&quot;sys_type&quot; = ''PUMP''" symbol="11"/>
   <rule scalemaxdenom="10000" label="Register" key="{8e1a0afb-c274-48ae-95a9-9c35583776c7}" filter="&quot;sys_type&quot; = ''REGISTER''" symbol="12"/>
   <rule scalemaxdenom="10000" label="Manhole" key="{118313b2-195c-4998-a2e3-965b368f9482}" filter="&quot;sys_type&quot; = ''MANHOLE''" symbol="13"/>
   <rule scalemaxdenom="10000" label="Reduction" key="{94bc6268-f342-4b79-a7f0-d8ba6498eb62}" filter="&quot;sys_type&quot; = ''REDUCTION''" symbol="14"/>
   <rule scalemaxdenom="5000" label="Junction" key="{4006148d-3986-44fc-b269-0707485e9bd0}" filter="&quot;sys_type&quot; = ''JUNCTION''" symbol="15"/>
   <rule scalemaxdenom="10000" label="Netwjoin" key="{2efa5954-7163-4c85-b608-6e6326bf4b5b}" filter="&quot;sys_type&quot; = ''NETWJOIN''" symbol="16"/>
   <rule scalemaxdenom="10000" label="Valve Open" key="{d6c2b118-3f7e-4809-a8e8-e6857e5a3f87}" filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  false or  &quot;closed_valve&quot; =  NULL )" symbol="17"/>
   <rule scalemaxdenom="10000" label="Valve Closed" key="{82481050-9411-4920-bf5b-aa8cde85e324}" filter="&quot;sys_type&quot; = ''VALVE'' and (&quot;closed_valve&quot;  =  true )" symbol="18"/>
   <rule scalemaxdenom="5000" label="ELSE" key="{efa48ca5-15b2-40e0-ae34-55ea7492a71b}" filter="ELSE" symbol="19"/>
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
    <layer class="SimpleMarker" pass="0" id="{2426fdf4-b863-4a31-8d22-75d3b87db206}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{60f8cb73-bd3f-4499-81be-3df8dc0b9276}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="W" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="Normal" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{bc3fd64a-7e37-4600-a277-2a6e0beed2f2}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,0,rgb:1,1,1,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{6491853f-3db7-4599-8f47-82ea692a3939}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="W" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{cafe2365-bf84-40bc-b4fd-71716f972139}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="0,100,200,255,rgb:0,0.39215686274509803,0.78431372549019607,1" type="QString" name="color"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
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
    <layer class="FontMarker" pass="0" id="{219fcf31-f2fe-4d0d-9707-a0eb69de422a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="S" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="2.5" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.0666667*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 4.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.833333*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 4.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{8dc8a232-f679-482d-b793-ac2b53347478}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,127,0,255,rgb:1,0.49803921568627452,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{3afd08f1-43b6-467e-a8ef-4a35b950ef4a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="P" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="12" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{680b46d0-028b-48eb-abf8-6b72554acb67}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="32,10,129,255,rgb:0.12549019607843137,0.0392156862745098,0.50588235294117645,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{cf489170-55a0-4d90-8676-2128de54ea7c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="R" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="13" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a6a44934-0dbe-4f33-abcf-2aa1924e6f07}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="166,206,227,255,rgb:0.65098039215686276,0.80784313725490198,0.8901960784313725,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{3d10fcb3-5875-4796-a630-8f37f10a6db5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="M" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="14" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{e713d3d0-79b7-4a2e-938b-7b27ae020cb5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="237,183,25,255,rgb:0.92941176470588238,0.71764705882352942,0.09803921568627451,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,0,rgb:1,1,1,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{99c6600d-cec6-4008-8248-a7379dc5646a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="R" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="15" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="0,242,255,255,rgb:0,0.94901960784313721,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="outline_color"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="1" type="double" name="maxSize"/>
           <Option value="5000" type="double" name="maxValue"/>
           <Option value="2" type="double" name="minSize"/>
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
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="16" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a1265017-edec-4d00-80fd-b7b30430a661}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="70,151,75,255,rgb:0.27450980392156865,0.59215686274509804,0.29411764705882354,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="3.75" type="QString" name="size"/>
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
         <Option value="0.75*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{7bbb273b-2b48-4e46-8049-c6a5b6beb6fe}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="cross" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="5" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="17" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{592e9086-2d83-4d08-9568-51d5431fb897}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{6544b1be-a893-4047-b925-e492b240f401}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="V" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="char">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="18" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{3a816b27-397e-4ff3-84c6-ffe6d22b372d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="199,28,31,255,rgb:0.7803921568627451,0.10980392156862745,0.12156862745098039,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{23bcf08d-7c4e-47b3-8c8e-8bac2a91a2f8}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="V" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="char">
         <Option value="true" type="bool" name="active"/>
         <Option value="case when node_type IN ( ''AIR_VALVE'' , ''CHECK_VALVE'' , ''PR_REDUC_VALVE'' )then left( &quot;node_type&quot; , 1) else ''V'' end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="19" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{c3168ec5-08d4-4f23-95b2-b9080a65290a}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="121,208,255,255,rgb:0.473685816739147,0.81579308766308078,1,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="50,48,55,255,rgb:0.19607843137254902,0.18823529411764706,0.21568627450980393,1" type="QString" name="outline_color"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="1" type="double" name="maxSize"/>
           <Option value="5000" type="double" name="maxValue"/>
           <Option value="2" type="double" name="minSize"/>
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
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{a7d527ec-c92e-4b39-90ad-ef546a13966c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="35,200,120,255,rgb:0.13725490196078433,0.78431372549019607,0.47058823529411764,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{dd1def90-d6fa-4b87-9bdc-e4534a97034d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="S" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{4179f10b-4e31-4983-a9cd-ec5fbc3b6eb7}" enabled="1" locked="0">
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
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="2" type="double" name="maxSize"/>
           <Option value="25000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{a448a54c-2934-4e3f-bdbe-e6406ca777af}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="D" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,-0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 25000, 5.5, 2, 0.37), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{e58b92e2-1f0d-44eb-9935-334695a38e22}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="25,237,206,255,rgb:0.09803921568627451,0.92941176470588238,0.80784313725490198,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{02d4b74a-f777-457b-9601-4a3ef69b405c}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="E" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{5c06718c-3f7d-4ce0-9cd6-20a447774d9d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="251,154,153,255,rgb:0.98431372549019602,0.60392156862745094,0.59999999999999998,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{85d6b24f-f9af-47cf-b64a-dcf9f311b03b}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="F" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{c76bb1e8-5a31-4354-b5fd-a41a2cb4aac4}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="191,246,61,255,rgb:0.74901960784313726,0.96470588235294119,0.23921568627450981,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{bc070515-6a58-47fc-b850-6fc0deb93cf5}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="F" type="QString" name="chr"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{1984c6a8-1af1-4fb5-ab16-083f08f31657}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="249,53,57,255,rgb:0.97647058823529409,0.20784313725490197,0.22352941176470589,1" type="QString" name="color"/>
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
      <Option value="4.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
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
    <layer class="FontMarker" pass="0" id="{186c2840-36b7-44b7-a198-0f5c96a45f52}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="H" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,-0.00000000000000006" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="angle">
         <Option value="false" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.37), 0)))|| '','' || ''0''" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.37), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{ab36f7c9-d62b-4b43-8c4f-5e89e62e4a2b}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="133,133,133,255,rgb:0.52156862745098043,0.52156862745098043,0.52156862745098043,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{a21eceef-f8ec-408e-90cc-21515599a898}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="M" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{a2fe185b-9594-40fa-b75b-44ed3f0d1f45}" enabled="1" locked="0">
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
      <Option value="0,0,0,0,rgb:0,0,0,0" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="0.52" type="double" name="exponent"/>
           <Option value="0.7" type="double" name="maxSize"/>
           <Option value="10000" type="double" name="maxValue"/>
           <Option value="5.5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{994f37d8-bd5b-4699-9434-22b4c78faaa9}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="E" type="QString" name="chr"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="255,255,255,255,rgb:1,1,1,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3.2" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="''0''|| '','' || tostring(-0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.761905*(coalesce(scale_exp(var(''map_scale''), 0, 10000, 5.5, 0.7, 0.52), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{71ca92da-75c9-49ce-a629-80db92f6b424}" enabled="1" locked="0">
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
   <category render="true" value="0" label="OBSOLETE" type="long" uuid="{fafb3932-336b-408a-b613-7564fa603517}" symbol="0"/>
   <category render="true" value="1" label="OPERATIVE" type="string" uuid="{2e0bc629-0440-42a8-bf37-83a5302de991}" symbol="1"/>
   <category render="true" value="2" label="PLANIFIED" type="long" uuid="{a6c3dc9a-d6c8-41f1-b37d-f9bdb0a71f65}" symbol="2"/>
   <category render="true" value="NULL" label="ELSE" type="NULL" uuid="{0f6ce22d-4427-42a8-b477-4879f8b8e4d3}" symbol="3"/>
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
    <layer class="SimpleLine" pass="0" id="{7495e564-1f2e-4c4e-adf2-96c2a06cbe10}" enabled="1" locked="0">
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
      <Option value="227,26,28,255,rgb:0.8901960784313725,0.10196078431372549,0.10980392156862745,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
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
         <Option value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
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
    <layer class="SimpleLine" pass="0" id="{b64bb163-e03e-4b0d-843e-76c497204421}" enabled="1" locked="0">
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
      <Option value="31,120,180,255,rgb:0.12156862745098039,0.47058823529411764,0.70588235294117652,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
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
         <Option value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
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
    <layer class="SimpleLine" pass="0" id="{8e6baa60-d3ad-4440-baf0-f5e293ac693f}" enabled="1" locked="0">
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
      <Option value="230,186,68,255,rgb:0.90196078431372551,0.72941176470588232,0.26666666666666666,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
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
         <Option value="case when cat_dnom is not null then&#xd;&#xa;-4.862 + 0.977 * ln(&quot;cat_dnom&quot; + 159.243)&#xd;&#xa;else 0.25 end" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
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
    <layer class="SimpleLine" pass="0" id="{c1dd7591-7c13-46c8-b3a8-495843eb24cb}" enabled="1" locked="0">
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
      <Option value="0.5" type="QString" name="line_width"/>
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
    <layer class="SimpleLine" pass="0" id="{38fef836-dca4-44ce-94cc-d00396fe66f2}" enabled="1" locked="0">
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
      <Option value="227,61,39,255,rgb:0.8901960784313725,0.23921568627450981,0.15294117647058825,1" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.5" type="QString" name="line_width"/>
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
    <layer class="SimpleLine" pass="0" id="{f0817fea-ea6c-4aa3-912a-22eceb8fe77a}" enabled="1" locked="0">
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


UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.7-Bratislava">
 <renderer-v2 symbollevels="0" referencescale="-1" forceraster="0" type="RuleRenderer" enableorderby="0">
  <rules key="{cd75f41e-3b1d-443c-8148-fbc4436aa9cb}">
   <rule scalemindenom="1" scalemaxdenom="1500" label="Greentap" key="{24b63ac0-a836-4203-bd64-161a0112ee9a}" filter=" &quot;sys_type&quot; = ''GREENTAP''" symbol="0"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Wjoin" key="{abcdb374-fe6a-4d04-a466-31fdd93144e8}" filter=" &quot;sys_type&quot; =''WJOIN''" symbol="1"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Tap" key="{7dc90f4d-d098-491a-b817-e7ea68fc2fd6}" filter=" &quot;sys_type&quot; =''TAP''" symbol="2"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Fountain" key="{39e4856f-0fc3-4498-8d4b-44d2851b421f}" filter=" &quot;sys_type&quot; =''FOUNTAIN''" symbol="3"/>
   <rule scalemindenom="1" scalemaxdenom="1500" label="Wjoin" key="{60014a37-16d8-4086-a5f3-248ffeeeefa3}" filter="ELSE" symbol="4"/>
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
    <layer class="SimpleMarker" pass="0" id="{12cc35f6-2de1-4246-b4e0-8a183935eeae}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="201,246,158,255,rgb:0.78823529411764703,0.96470588235294119,0.61960784313725492,1" type="QString" name="color"/>
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
      <Option value="1.6" type="QString" name="size"/>
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
           <Option value="0.57" type="double" name="exponent"/>
           <Option value="1" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="3.5" type="double" name="minSize"/>
           <Option value="0" type="double" name="minValue"/>
           <Option value="0" type="double" name="nullSize"/>
           <Option value="2" type="int" name="scaleType"/>
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
    <layer class="SimpleMarker" pass="0" id="{362f8968-f888-433b-90e4-e5098d869499}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="circle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="49,180,227,255,rgb:0.19215686274509805,0.70588235294117652,0.8901960784313725,1" type="QString" name="outline_color"/>
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
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.666667*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 3.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{67948e1f-e6bb-4593-b5ad-8bb9fcf49d7d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="cross" type="QString" name="name"/>
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
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
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
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="2" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{9be7c088-b096-4952-9c7a-3fe50ee2852a}" enabled="1" locked="0">
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
           <Option value="1.5" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
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
   <symbol is_animated="0" force_rhr="0" type="marker" clip_to_extent="1" frame_rate="10" name="3" alpha="1">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer class="SimpleMarker" pass="0" id="{d8e73060-669b-4565-9660-e859c06a83fd}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="44,67,207,83,rgb:0.17254901960784313,0.2627450980392157,0.81176470588235294,0.32549019607843138" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="triangle" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="22,0,148,255,rgb:0.08627450980392157,0,0.58039215686274515,1" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="diameter" type="QString" name="scale_method"/>
      <Option value="4.2" type="QString" name="size"/>
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
           <Option value="2.5" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
           <Option value="5" type="double" name="minSize"/>
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
    <layer class="FontMarker" pass="0" id="{b07449ae-bcc9-48eb-8ebd-ae0ffa344f84}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="F" type="QString" name="chr"/>
      <Option value="22,0,148,255,rgb:0.08627450980392157,0,0.58039215686274515,1" type="QString" name="color"/>
      <Option value="Arial" type="QString" name="font"/>
      <Option value="" type="QString" name="font_style"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0.20000000000000001,0.20000000000000001" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="0,0,0,255,rgb:0,0,0,1" type="QString" name="outline_color"/>
      <Option value="0" type="QString" name="outline_width"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="outline_width_map_unit_scale"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="3" type="QString" name="size"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="size_map_unit_scale"/>
      <Option value="MM" type="QString" name="size_unit"/>
      <Option value="1" type="QString" name="vertical_anchor_point"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option type="Map" name="properties">
        <Option type="Map" name="offset">
         <Option value="true" type="bool" name="active"/>
         <Option value="tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0)))|| '','' || tostring(0.047619*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0)))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.714286*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 5, 2.5, 0.37), 0))" type="QString" name="expression"/>
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
    <layer class="SimpleMarker" pass="0" id="{362f8968-f888-433b-90e4-e5098d869499}" enabled="1" locked="0">
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
      <Option value="121,208,255,255,rgb:0.47450980392156861,0.81568627450980391,1,1" type="QString" name="outline_color"/>
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
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="0.666667*(coalesce(scale_exp(var(''map_scale''), 0, 1500, 3.5, 2, 0.37), 0))" type="QString" name="expression"/>
         <Option value="3" type="int" name="type"/>
        </Option>
       </Option>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
    <layer class="SimpleMarker" pass="0" id="{67948e1f-e6bb-4593-b5ad-8bb9fcf49d7d}" enabled="1" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="255,0,0,255,rgb:1,0,0,1" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="cross" type="QString" name="name"/>
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
        <Option type="Map" name="angle">
         <Option value="true" type="bool" name="active"/>
         <Option value="rotation" type="QString" name="field"/>
         <Option value="2" type="int" name="type"/>
        </Option>
        <Option type="Map" name="size">
         <Option value="true" type="bool" name="active"/>
         <Option value="var(''map_scale'')" type="QString" name="expression"/>
         <Option type="Map" name="transformer">
          <Option type="Map" name="d">
           <Option value="0.37" type="double" name="exponent"/>
           <Option value="2" type="double" name="maxSize"/>
           <Option value="1500" type="double" name="maxValue"/>
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
    <layer class="SimpleMarker" pass="0" id="{593cbcfc-245e-4774-ad13-56169b965bf5}" enabled="1" locked="0">
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
' WHERE layername='ve_connec' AND styleconfig_id=101;