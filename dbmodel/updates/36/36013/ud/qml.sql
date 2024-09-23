/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_style SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis simplifyDrawingHints="1" symbologyReferenceScale="-1" maxScale="0" minScale="0" version="3.28.5-Firenze" simplifyLocal="1" hasScaleBasedVisibilityFlag="0" readOnly="0" simplifyAlgorithm="0" simplifyMaxScale="1" labelsEnabled="0" simplifyDrawingTol="1" styleCategories="AllStyleCategories">
 <flags>
  <Identifiable>1</Identifiable>
  <Removable>1</Removable>
  <Searchable>1</Searchable>
  <Private>0</Private>
 </flags>
 <temporal limitMode="0" accumulate="0" mode="0" durationField="" fixedDuration="0" startField="" startExpression="" endExpression="" durationUnit="min" enabled="0" endField="">
  <fixedRange>
   <start></start>
   <end></end>
  </fixedRange>
 </temporal>
 <elevation extrusionEnabled="0" binding="Centroid" respectLayerSymbol="1" zoffset="0" showMarkerSymbolInSurfacePlots="0" zscale="1" type="IndividualFeatures" extrusion="0" clamping="Terrain" symbology="Line">
  <data-defined-properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
   </Option>
  </data-defined-properties>
  <profileLineSymbol>
   <symbol alpha="1" clip_to_extent="1" type="line" name="" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleLine" locked="0">
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
      <Option value="125,139,143,255" type="QString" name="line_color"/>
      <Option value="solid" type="QString" name="line_style"/>
      <Option value="0.6" type="QString" name="line_width"/>
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
  </profileLineSymbol>
  <profileFillSymbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleFill" locked="0">
     <Option type="Map">
      <Option value="3x:0,0,0,0,0,0" type="QString" name="border_width_map_unit_scale"/>
      <Option value="125,139,143,255" type="QString" name="color"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="89,99,102,255" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0.2" type="QString" name="outline_width"/>
      <Option value="MM" type="QString" name="outline_width_unit"/>
      <Option value="solid" type="QString" name="style"/>
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
  </profileFillSymbol>
  <profileMarkerSymbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleMarker" locked="0">
     <Option type="Map">
      <Option value="0" type="QString" name="angle"/>
      <Option value="square" type="QString" name="cap_style"/>
      <Option value="125,139,143,255" type="QString" name="color"/>
      <Option value="1" type="QString" name="horizontal_anchor_point"/>
      <Option value="bevel" type="QString" name="joinstyle"/>
      <Option value="diamond" type="QString" name="name"/>
      <Option value="0,0" type="QString" name="offset"/>
      <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
      <Option value="MM" type="QString" name="offset_unit"/>
      <Option value="89,99,102,255" type="QString" name="outline_color"/>
      <Option value="solid" type="QString" name="outline_style"/>
      <Option value="0.2" type="QString" name="outline_width"/>
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
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
    </layer>
   </symbol>
  </profileMarkerSymbol>
 </elevation>
 <renderer-v2 referencescale="-1" symbollevels="0" type="RuleRenderer" enableorderby="0" forceraster="0">
  <rules key="{f409d5eb-3e1c-4ad5-a144-856e7968cdb5}">
   <rule key="{dff7f0b4-0963-45c8-b446-deb20b67eeda}" symbol="0" filter=" &quot;feature_type&quot;  = ''GULLY''"/>
  </rules>
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="line" name="0" force_rhr="0" frame_rate="10" is_animated="0">
    <data_defined_properties>
     <Option type="Map">
      <Option value="" type="QString" name="name"/>
      <Option name="properties"/>
      <Option value="collection" type="QString" name="type"/>
     </Option>
    </data_defined_properties>
    <layer enabled="1" pass="0" class="SimpleLine" locked="0">
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
      <Option value="180,180,180,255" type="QString" name="line_color"/>
      <Option value="dash" type="QString" name="line_style"/>
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
    <layer enabled="1" pass="0" class="GeometryGenerator" locked="0">
     <Option type="Map">
      <Option value="Marker" type="QString" name="SymbolType"/>
      <Option value="end_point($geometry)" type="QString" name="geometryModifier"/>
      <Option value="MapUnit" type="QString" name="units"/>
     </Option>
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <symbol alpha="1" clip_to_extent="1" type="marker" name="@0@1" force_rhr="0" frame_rate="10" is_animated="0">
      <data_defined_properties>
       <Option type="Map">
        <Option value="" type="QString" name="name"/>
        <Option name="properties"/>
        <Option value="collection" type="QString" name="type"/>
       </Option>
      </data_defined_properties>
      <layer enabled="1" pass="0" class="SimpleMarker" locked="0">
       <Option type="Map">
        <Option value="0" type="QString" name="angle"/>
        <Option value="square" type="QString" name="cap_style"/>
        <Option value="255,0,0,255" type="QString" name="color"/>
        <Option value="1" type="QString" name="horizontal_anchor_point"/>
        <Option value="bevel" type="QString" name="joinstyle"/>
        <Option value="cross2" type="QString" name="name"/>
        <Option value="0,0" type="QString" name="offset"/>
        <Option value="3x:0,0,0,0,0,0" type="QString" name="offset_map_unit_scale"/>
        <Option value="MM" type="QString" name="offset_unit"/>
        <Option value="180,180,180,255" type="QString" name="outline_color"/>
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
         <Option name="properties"/>
         <Option value="collection" type="QString" name="type"/>
        </Option>
       </data_defined_properties>
      </layer>
     </symbol>
    </layer>
   </symbol>
  </symbols>
 </renderer-v2>
 <customproperties>
  <Option type="Map">
   <Option value="0" type="QString" name="embeddedWidgets/count"/>
   <Option type="invalid" name="variableNames"/>
   <Option type="invalid" name="variableValues"/>
  </Option>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerOpacity>1</layerOpacity>
 <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
  <DiagramCategory spacingUnitScale="3x:0,0,0,0,0,0" diagramOrientation="Up" opacity="1" spacing="5" penColor="#000000" backgroundAlpha="255" rotationOffset="270" lineSizeScale="3x:0,0,0,0,0,0" minimumSize="0" penWidth="0" penAlpha="255" height="15" sizeScale="3x:0,0,0,0,0,0" labelPlacementMethod="XHeight" maxScaleDenominator="0" direction="0" lineSizeType="MM" spacingUnit="MM" barWidth="5" width="15" enabled="0" backgroundColor="#ffffff" minScaleDenominator="0" sizeType="MM" showAxis="1" scaleBasedVisibility="0" scaleDependency="Area">
   <fontProperties description="MS Shell Dlg 2,7.8,-1,5,50,0,0,0,0,0" style="" bold="0" underline="0" italic="0" strikethrough="0"/>
   <attribute field="" label="" colorOpacity="1" color="#000000"/>
   <axisSymbol>
    <symbol alpha="1" clip_to_extent="1" type="line" name="" force_rhr="0" frame_rate="10" is_animated="0">
     <data_defined_properties>
      <Option type="Map">
       <Option value="" type="QString" name="name"/>
       <Option name="properties"/>
       <Option value="collection" type="QString" name="type"/>
      </Option>
     </data_defined_properties>
     <layer enabled="1" pass="0" class="SimpleLine" locked="0">
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
       <Option value="35,35,35,255" type="QString" name="line_color"/>
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
   </axisSymbol>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings priority="0" showAll="1" linePlacementFlags="18" placement="2" dist="0" zIndex="0" obstacle="0">
  <properties>
   <Option type="Map">
    <Option value="" type="QString" name="name"/>
    <Option name="properties"/>
    <Option value="collection" type="QString" name="type"/>
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
  <field configurationFlags="None" name="link_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="feature_type">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="ARC" type="QString" name="ARC"/>
       <Option value="CONNEC" type="QString" name="CONNEC"/>
       <Option value="ELEMENT" type="QString" name="ELEMENT"/>
       <Option value="GULLY" type="QString" name="GULLY"/>
       <Option value="LINK" type="QString" name="LINK"/>
       <Option value="NODE" type="QString" name="NODE"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="feature_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_type">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="ARC" type="QString" name="ARC"/>
       <Option value="CONNEC" type="QString" name="CONNEC"/>
       <Option value="GULLY" type="QString" name="GULLY"/>
       <Option value="NODE" type="QString" name="NODE"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="state">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="0" type="QString" name="OBSOLETE"/>
       <Option value="1" type="QString" name="OPERATIVE"/>
       <Option value="2" type="QString" name="PLANIFIED"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="expl_id">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="AllowNull"/>
      <Option value="" type="QString" name="FilterExpression"/>
      <Option value="expl_id" type="QString" name="Key"/>
      <Option value="v_edit_exploitation_79f9ccda_070f_4e89_b991_6f956aec4b36" type="QString" name="Layer"/>
      <Option value="name" type="QString" name="Value"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="macroexpl_id">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="sector_id">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="AllowNull"/>
      <Option value="" type="QString" name="FilterExpression"/>
      <Option value="sector_id" type="QString" name="Key"/>
      <Option value="v_edit_sector_d4924986_50a2_4c42_bad8_bfff1644805d" type="QString" name="Layer"/>
      <Option value="name" type="QString" name="Value"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="sector_type">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="macrosector_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="muni_id">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="drainzone_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="drainzone_type">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="dma_id">
   <editWidget type="ValueMap">
    <config>
     <Option type="Map">
      <Option type="Map" name="map">
       <Option value="0" type="QString" name="Undefined"/>
       <Option value="1" type="QString" name="dma_01"/>
       <Option value="3" type="QString" name="dma_02"/>
      </Option>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="macrodma_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_topelev">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="exit_elev">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="fluid_type">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="gis_length">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="sector_name">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="dma_name">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="expl_id2">
   <editWidget type="Range">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="epa_type">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="false" type="bool" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="is_operative">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" type="QString" name="CheckedState"/>
      <Option value="false" type="QString" name="UncheckedState"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="connecat_id">
   <editWidget type="ValueRelation">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="AllowNull"/>
      <Option value="" type="QString" name="FilterExpression"/>
      <Option value="id" type="QString" name="Key"/>
      <Option value="cat_connec_c478157f_493b_462e_addb_2de2fbf4f4da" type="QString" name="Layer"/>
      <Option value="id" type="QString" name="Value"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="workcat_id">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="workcat_id_end">
   <editWidget type="TextEdit">
    <config>
     <Option type="Map">
      <Option value="False" type="QString" name="IsMultiline"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="builtdate">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" type="bool" name="allow_null"/>
      <Option value="true" type="bool" name="calendar_popup"/>
      <Option value="yyyy-MM-dd" type="QString" name="display_format"/>
      <Option value="yyyy-MM-dd" type="QString" name="field_format"/>
      <Option value="false" type="bool" name="field_iso_format"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="enddate">
   <editWidget type="DateTime">
    <config>
     <Option type="Map">
      <Option value="true" type="bool" name="allow_null"/>
      <Option value="true" type="bool" name="calendar_popup"/>
      <Option value="yyyy-MM-dd" type="QString" name="display_format"/>
      <Option value="yyyy-MM-dd" type="QString" name="field_format"/>
      <Option value="false" type="bool" name="field_iso_format"/>
     </Option>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="lastupdate">
   <editWidget type="DateTime">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="lastupdate_user">
   <editWidget type="TextEdit">
    <config>
     <Option/>
    </config>
   </editWidget>
  </field>
  <field configurationFlags="None" name="uncertain">
   <editWidget type="CheckBox">
    <config>
     <Option type="Map">
      <Option value="true" type="QString" name="CheckedState"/>
      <Option value="false" type="QString" name="UncheckedState"/>
     </Option>
    </config>
   </editWidget>
  </field>
 </fieldConfiguration>
 <aliases>
  <alias field="link_id" name="link_id" index="0"/>
  <alias field="feature_type" name="feature_type" index="1"/>
  <alias field="feature_id" name="feature_id" index="2"/>
  <alias field="exit_type" name="exit_type" index="3"/>
  <alias field="exit_id" name="exit_id" index="4"/>
  <alias field="state" name="state" index="5"/>
  <alias field="expl_id" name="expl_id" index="6"/>
  <alias field="macroexpl_id" name="" index="7"/>
  <alias field="sector_id" name="sector_id" index="8"/>
  <alias field="sector_type" name="" index="9"/>
  <alias field="macrosector_id" name="macrosector_id" index="10"/>
  <alias field="muni_id" name="" index="11"/>
  <alias field="drainzone_id" name="drainzone_id" index="12"/>
  <alias field="drainzone_type" name="" index="13"/>
  <alias field="dma_id" name="dma_id" index="14"/>
  <alias field="macrodma_id" name="macrodma_id" index="15"/>
  <alias field="exit_topelev" name="exit_topelev" index="16"/>
  <alias field="exit_elev" name="exit_elev" index="17"/>
  <alias field="fluid_type" name="fluid_type" index="18"/>
  <alias field="gis_length" name="gis_length" index="19"/>
  <alias field="sector_name" name="sector_name" index="20"/>
  <alias field="dma_name" name="" index="21"/>
  <alias field="expl_id2" name="" index="22"/>
  <alias field="epa_type" name="epa_type" index="23"/>
  <alias field="is_operative" name="is_operative" index="24"/>
  <alias field="connecat_id" name="connecat_id" index="25"/>
  <alias field="workcat_id" name="workcat_id" index="26"/>
  <alias field="workcat_id_end" name="workcat_id_end" index="27"/>
  <alias field="builtdate" name="builtdate" index="28"/>
  <alias field="enddate" name="enddate" index="29"/>
  <alias field="lastupdate" name="" index="30"/>
  <alias field="lastupdate_user" name="" index="31"/>
  <alias field="uncertain" name="Uncertain" index="32"/>
 </aliases>
 <defaults>
  <default expression="" applyOnUpdate="0" field="link_id"/>
  <default expression="" applyOnUpdate="0" field="feature_type"/>
  <default expression="" applyOnUpdate="0" field="feature_id"/>
  <default expression="" applyOnUpdate="0" field="exit_type"/>
  <default expression="" applyOnUpdate="0" field="exit_id"/>
  <default expression="" applyOnUpdate="0" field="state"/>
  <default expression="" applyOnUpdate="0" field="expl_id"/>
  <default expression="" applyOnUpdate="0" field="macroexpl_id"/>
  <default expression="" applyOnUpdate="0" field="sector_id"/>
  <default expression="" applyOnUpdate="0" field="sector_type"/>
  <default expression="" applyOnUpdate="0" field="macrosector_id"/>
  <default expression="" applyOnUpdate="0" field="muni_id"/>
  <default expression="" applyOnUpdate="0" field="drainzone_id"/>
  <default expression="" applyOnUpdate="0" field="drainzone_type"/>
  <default expression="" applyOnUpdate="0" field="dma_id"/>
  <default expression="" applyOnUpdate="0" field="macrodma_id"/>
  <default expression="" applyOnUpdate="0" field="exit_topelev"/>
  <default expression="" applyOnUpdate="0" field="exit_elev"/>
  <default expression="" applyOnUpdate="0" field="fluid_type"/>
  <default expression="" applyOnUpdate="0" field="gis_length"/>
  <default expression="" applyOnUpdate="0" field="sector_name"/>
  <default expression="" applyOnUpdate="0" field="dma_name"/>
  <default expression="" applyOnUpdate="0" field="expl_id2"/>
  <default expression="" applyOnUpdate="0" field="epa_type"/>
  <default expression="" applyOnUpdate="0" field="is_operative"/>
  <default expression="" applyOnUpdate="0" field="connecat_id"/>
  <default expression="" applyOnUpdate="0" field="workcat_id"/>
  <default expression="" applyOnUpdate="0" field="workcat_id_end"/>
  <default expression="" applyOnUpdate="0" field="builtdate"/>
  <default expression="" applyOnUpdate="0" field="enddate"/>
  <default expression="" applyOnUpdate="0" field="lastupdate"/>
  <default expression="" applyOnUpdate="0" field="lastupdate_user"/>
  <default expression="" applyOnUpdate="0" field="uncertain"/>
 </defaults>
 <constraints>
  <constraint notnull_strength="2" field="link_id" constraints="3" exp_strength="0" unique_strength="1"/>
  <constraint notnull_strength="2" field="feature_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="feature_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="state" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="expl_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="macroexpl_id" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="sector_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="sector_type" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="macrosector_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="muni_id" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="drainzone_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="drainzone_type" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="dma_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="macrodma_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_topelev" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="exit_elev" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="fluid_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="gis_length" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="sector_name" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="dma_name" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="expl_id2" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="epa_type" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="is_operative" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="connecat_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="workcat_id" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="workcat_id_end" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="builtdate" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="enddate" constraints="1" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="lastupdate" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="0" field="lastupdate_user" constraints="0" exp_strength="0" unique_strength="0"/>
  <constraint notnull_strength="2" field="uncertain" constraints="1" exp_strength="0" unique_strength="0"/>
 </constraints>
 <constraintExpressions>
  <constraint exp="" field="link_id" desc=""/>
  <constraint exp="" field="feature_type" desc=""/>
  <constraint exp="" field="feature_id" desc=""/>
  <constraint exp="" field="exit_type" desc=""/>
  <constraint exp="" field="exit_id" desc=""/>
  <constraint exp="" field="state" desc=""/>
  <constraint exp="" field="expl_id" desc=""/>
  <constraint exp="" field="macroexpl_id" desc=""/>
  <constraint exp="" field="sector_id" desc=""/>
  <constraint exp="" field="sector_type" desc=""/>
  <constraint exp="" field="macrosector_id" desc=""/>
  <constraint exp="" field="muni_id" desc=""/>
  <constraint exp="" field="drainzone_id" desc=""/>
  <constraint exp="" field="drainzone_type" desc=""/>
  <constraint exp="" field="dma_id" desc=""/>
  <constraint exp="" field="macrodma_id" desc=""/>
  <constraint exp="" field="exit_topelev" desc=""/>
  <constraint exp="" field="exit_elev" desc=""/>
  <constraint exp="" field="fluid_type" desc=""/>
  <constraint exp="" field="gis_length" desc=""/>
  <constraint exp="" field="sector_name" desc=""/>
  <constraint exp="" field="dma_name" desc=""/>
  <constraint exp="" field="expl_id2" desc=""/>
  <constraint exp="" field="epa_type" desc=""/>
  <constraint exp="" field="is_operative" desc=""/>
  <constraint exp="" field="connecat_id" desc=""/>
  <constraint exp="" field="workcat_id" desc=""/>
  <constraint exp="" field="workcat_id_end" desc=""/>
  <constraint exp="" field="builtdate" desc=""/>
  <constraint exp="" field="enddate" desc=""/>
  <constraint exp="" field="lastupdate" desc=""/>
  <constraint exp="" field="lastupdate_user" desc=""/>
  <constraint exp="" field="uncertain" desc=""/>
 </constraintExpressions>
 <expressionfields/>
 <attributeactions>
  <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
 </attributeactions>
 <attributetableconfig sortExpression="" actionWidgetStyle="dropDown" sortOrder="0">
  <columns>
   <column type="field" name="link_id" width="-1" hidden="0"/>
   <column type="field" name="feature_type" width="-1" hidden="0"/>
   <column type="field" name="feature_id" width="-1" hidden="0"/>
   <column type="field" name="exit_type" width="-1" hidden="0"/>
   <column type="field" name="exit_id" width="-1" hidden="0"/>
   <column type="field" name="state" width="-1" hidden="0"/>
   <column type="field" name="expl_id" width="-1" hidden="0"/>
   <column type="field" name="macroexpl_id" width="-1" hidden="0"/>
   <column type="field" name="sector_id" width="-1" hidden="0"/>
   <column type="field" name="sector_type" width="-1" hidden="0"/>
   <column type="field" name="macrosector_id" width="-1" hidden="1"/>
   <column type="field" name="muni_id" width="-1" hidden="0"/>
   <column type="field" name="drainzone_id" width="-1" hidden="0"/>
   <column type="field" name="drainzone_type" width="-1" hidden="0"/>
   <column type="field" name="dma_id" width="-1" hidden="0"/>
   <column type="field" name="macrodma_id" width="-1" hidden="1"/>
   <column type="field" name="exit_topelev" width="-1" hidden="1"/>
   <column type="field" name="exit_elev" width="-1" hidden="1"/>
   <column type="field" name="fluid_type" width="-1" hidden="0"/>
   <column type="field" name="gis_length" width="-1" hidden="0"/>
   <column type="field" name="sector_name" width="-1" hidden="1"/>
   <column type="field" name="dma_name" width="-1" hidden="0"/>
   <column type="field" name="expl_id2" width="-1" hidden="0"/>
   <column type="field" name="epa_type" width="-1" hidden="0"/>
   <column type="field" name="is_operative" width="-1" hidden="0"/>
   <column type="field" name="connecat_id" width="-1" hidden="0"/>
   <column type="field" name="workcat_id" width="-1" hidden="0"/>
   <column type="field" name="workcat_id_end" width="-1" hidden="0"/>
   <column type="field" name="builtdate" width="-1" hidden="0"/>
   <column type="field" name="enddate" width="-1" hidden="0"/>
   <column type="field" name="lastupdate" width="-1" hidden="0"/>
   <column type="field" name="lastupdate_user" width="-1" hidden="0"/>
   <column type="field" name="uncertain" width="-1" hidden="1"/>
   <column type="actions" width="-1" hidden="1"/>
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
  <field editable="1" name="builtdate"/>
  <field editable="0" name="connecat_id"/>
  <field editable="0" name="dma_id"/>
  <field editable="1" name="dma_name"/>
  <field editable="0" name="drainzone_id"/>
  <field editable="1" name="drainzone_type"/>
  <field editable="1" name="enddate"/>
  <field editable="0" name="epa_type"/>
  <field editable="0" name="exit_elev"/>
  <field editable="0" name="exit_id"/>
  <field editable="0" name="exit_topelev"/>
  <field editable="0" name="exit_type"/>
  <field editable="0" name="expl_id"/>
  <field editable="1" name="expl_id2"/>
  <field editable="0" name="feature_id"/>
  <field editable="0" name="feature_type"/>
  <field editable="0" name="fluid_type"/>
  <field editable="0" name="gis_length"/>
  <field editable="0" name="is_operative"/>
  <field editable="1" name="lastupdate"/>
  <field editable="1" name="lastupdate_user"/>
  <field editable="0" name="link_id"/>
  <field editable="0" name="macrodma_id"/>
  <field editable="1" name="macroexpl_id"/>
  <field editable="0" name="macrosector_id"/>
  <field editable="1" name="muni_id"/>
  <field editable="0" name="sector_id"/>
  <field editable="0" name="sector_name"/>
  <field editable="1" name="sector_type"/>
  <field editable="1" name="state"/>
  <field editable="1" name="uncertain"/>
  <field editable="1" name="workcat_id"/>
  <field editable="1" name="workcat_id_end"/>
 </editable>
 <labelOnTop>
  <field name="builtdate" labelOnTop="0"/>
  <field name="connecat_id" labelOnTop="0"/>
  <field name="dma_id" labelOnTop="0"/>
  <field name="dma_name" labelOnTop="0"/>
  <field name="drainzone_id" labelOnTop="0"/>
  <field name="drainzone_type" labelOnTop="0"/>
  <field name="enddate" labelOnTop="0"/>
  <field name="epa_type" labelOnTop="0"/>
  <field name="exit_elev" labelOnTop="0"/>
  <field name="exit_id" labelOnTop="0"/>
  <field name="exit_topelev" labelOnTop="0"/>
  <field name="exit_type" labelOnTop="0"/>
  <field name="expl_id" labelOnTop="0"/>
  <field name="expl_id2" labelOnTop="0"/>
  <field name="feature_id" labelOnTop="0"/>
  <field name="feature_type" labelOnTop="0"/>
  <field name="fluid_type" labelOnTop="0"/>
  <field name="gis_length" labelOnTop="0"/>
  <field name="is_operative" labelOnTop="0"/>
  <field name="lastupdate" labelOnTop="0"/>
  <field name="lastupdate_user" labelOnTop="0"/>
  <field name="link_id" labelOnTop="0"/>
  <field name="macrodma_id" labelOnTop="0"/>
  <field name="macroexpl_id" labelOnTop="0"/>
  <field name="macrosector_id" labelOnTop="0"/>
  <field name="muni_id" labelOnTop="0"/>
  <field name="sector_id" labelOnTop="0"/>
  <field name="sector_name" labelOnTop="0"/>
  <field name="sector_type" labelOnTop="0"/>
  <field name="state" labelOnTop="0"/>
  <field name="uncertain" labelOnTop="0"/>
  <field name="workcat_id" labelOnTop="0"/>
  <field name="workcat_id_end" labelOnTop="0"/>
 </labelOnTop>
 <reuseLastValue>
  <field reuseLastValue="0" name="builtdate"/>
  <field reuseLastValue="0" name="connecat_id"/>
  <field reuseLastValue="0" name="dma_id"/>
  <field reuseLastValue="0" name="dma_name"/>
  <field reuseLastValue="0" name="drainzone_id"/>
  <field reuseLastValue="0" name="drainzone_type"/>
  <field reuseLastValue="0" name="enddate"/>
  <field reuseLastValue="0" name="epa_type"/>
  <field reuseLastValue="0" name="exit_elev"/>
  <field reuseLastValue="0" name="exit_id"/>
  <field reuseLastValue="0" name="exit_topelev"/>
  <field reuseLastValue="0" name="exit_type"/>
  <field reuseLastValue="0" name="expl_id"/>
  <field reuseLastValue="0" name="expl_id2"/>
  <field reuseLastValue="0" name="feature_id"/>
  <field reuseLastValue="0" name="feature_type"/>
  <field reuseLastValue="0" name="fluid_type"/>
  <field reuseLastValue="0" name="gis_length"/>
  <field reuseLastValue="0" name="is_operative"/>
  <field reuseLastValue="0" name="lastupdate"/>
  <field reuseLastValue="0" name="lastupdate_user"/>
  <field reuseLastValue="0" name="link_id"/>
  <field reuseLastValue="0" name="macrodma_id"/>
  <field reuseLastValue="0" name="macroexpl_id"/>
  <field reuseLastValue="0" name="macrosector_id"/>
  <field reuseLastValue="0" name="muni_id"/>
  <field reuseLastValue="0" name="sector_id"/>
  <field reuseLastValue="0" name="sector_name"/>
  <field reuseLastValue="0" name="sector_type"/>
  <field reuseLastValue="0" name="state"/>
  <field reuseLastValue="0" name="uncertain"/>
  <field reuseLastValue="0" name="workcat_id"/>
  <field reuseLastValue="0" name="workcat_id_end"/>
 </reuseLastValue>
 <dataDefinedFieldProperties/>
 <widgets/>
 <previewExpression>"sector_name"</previewExpression>
 <mapTip></mapTip>
 <layerGeometryType>1</layerGeometryType>
</qgis>
' WHERE styleconfig_id=102 and layername='v_edit_link';


