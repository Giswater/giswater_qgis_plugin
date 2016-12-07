/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
------
-- FK 00
------

ALTER TABLE "ext_streetaxis" DROP CONSTRAINT IF EXISTS "ext_streetaxis_type_fkey";
ALTER TABLE "ext_streetaxis" ADD FOREIGN KEY ("type") REFERENCES "ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_urban_propierties" DROP CONSTRAINT IF EXISTS "ext_urban_propierties_streetaxis_fkey";
ALTER TABLE "ext_urban_propierties" ADD FOREIGN KEY ("streetaxis") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "ext_rtc_scada" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_cat_scada_id_fkey";
ALTER TABLE "ext_rtc_scada" ADD FOREIGN KEY ("cat_scada_id") REFERENCES "ext_cat_scada" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_scada_x_value" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_x_value_scada_id_fkey";
ALTER TABLE "ext_rtc_scada_x_value" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "ext_rtc_scada_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_x_data_scada_id_fkey";
ALTER TABLE "ext_rtc_scada_x_data" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_scada_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_scada_x_data_cat_period_id_fkey";
ALTER TABLE "ext_rtc_scada_x_data" ADD FOREIGN KEY ("cat_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_cat_hydrometer_id_fkey";
ALTER TABLE "ext_rtc_hydrometer" ADD FOREIGN KEY ("cat_hydrometer_id") REFERENCES "ext_cat_hydrometer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer_x_data" DROP CONSTRAINT IF EXISTS "ext_rtc_hydrometer_x_data_cat_period_id_fkey";
ALTER TABLE "ext_rtc_hydrometer_x_data" ADD FOREIGN KEY ("cat_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;




------
-- FK 01
------

ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_matcat_id_fkey";
ALTER TABLE "cat_arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_arctype_id_fkey";
ALTER TABLE "cat_arc" ADD FOREIGN KEY ("arctype_id") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_matcat_id_fkey";
ALTER TABLE "cat_node" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_nodetype_id_fkey";
ALTER TABLE "cat_node" ADD FOREIGN KEY ("nodetype_id") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_node_type_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("node_type") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_nodecat_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("nodecat_id") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_sector_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_verified_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arccat_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_sector_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_1_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("node_1") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_2_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("node_2") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_verified_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_elementtype_id_fkey";
ALTER TABLE "cat_element" ADD FOREIGN KEY ("elementtype_id") REFERENCES "element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_matcat_id_fkey";
ALTER TABLE "cat_element" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_matcat_id_fkey";
ALTER TABLE "cat_connec" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_type_fkey";
ALTER TABLE "cat_connec" ADD FOREIGN KEY ("type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_connecat_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("connecat_id") REFERENCES "cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_sector_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_sector_id_fkey";
ALTER TABLE "dma" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_presszonecat_id_fkey";
ALTER TABLE "dma" ADD FOREIGN KEY ("presszonecat_id") REFERENCES "cat_press_zone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_connec_id_fkey";
ALTER TABLE "link" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_vnode_id_fkey";
ALTER TABLE "link" ADD FOREIGN KEY ("vnode_id") REFERENCES "vnode" ("vnode_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_arc_id_fkey";
ALTER TABLE "vnode" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_sector_id_fkey";
ALTER TABLE "vnode" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_dma_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_dma_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_dma_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_soilcat_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_soilcat_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_soilcat_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_category_type_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_category_type_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_category_type_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_fluid_type_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_fluid_type_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_fluid_type_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_location_type_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_location_type_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_location_type_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_end_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_end_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_end_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_buildercat_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_buildercat_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_buildercat_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_ownercat_id_fkey";
ALTER TABLE "node" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_ownercat_id_fkey";
ALTER TABLE "arc" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_ownercat_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey";
ALTER TABLE "connec" ADD FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_arc_id_fkey";
ALTER TABLE "vnode" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_junction" DROP CONSTRAINT IF EXISTS "man_junction_node_id_fkey";
ALTER TABLE "man_junction" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_tank" DROP CONSTRAINT IF EXISTS "man_tank_node_id_fkey";
ALTER TABLE "man_tank" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_hydrant" DROP CONSTRAINT IF EXISTS "man_hydrant_node_id_fkey";
ALTER TABLE "man_hydrant" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_node_id_fkey";
ALTER TABLE "man_valve" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_pump" DROP CONSTRAINT IF EXISTS "man_pump_node_id_fkey";
ALTER TABLE "man_pump" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_meter" DROP CONSTRAINT IF EXISTS "man_meter_node_id_fkey";
ALTER TABLE "man_meter" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_filter" DROP CONSTRAINT IF EXISTS "man_filter_node_id_fkey";
ALTER TABLE "man_filter" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_reduction" DROP CONSTRAINT IF EXISTS "man_reduction_node_id_fkey";
ALTER TABLE  "man_reduction" ADD FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_source" DROP CONSTRAINT IF EXISTS "man_source_node_id_fkey";
ALTER TABLE "man_source" ADD FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_waterwell" DROP CONSTRAINT IF EXISTS "man_waterwell_node_id_fkey";
ALTER TABLE "man_waterwell" ADD FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_manhole" DROP CONSTRAINT IF EXISTS "man_manhole_node_id_fkey";
ALTER TABLE "man_manhole" ADD FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "man_pipe" DROP CONSTRAINT IF EXISTS "man_pipe_arc_id_fkey";
ALTER TABLE "man_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_fountain" DROP CONSTRAINT IF EXISTS "man_fountain_connec_id_fkey";
ALTER TABLE "man_fountain" ADD FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_greentap" DROP CONSTRAINT IF EXISTS "man_greentap_connec_id_fkey";
ALTER TABLE "man_greentap" ADD FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_tap" DROP CONSTRAINT IF EXISTS "man_tap_connec_id_fkey";
ALTER TABLE "man_tap" ADD FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_wjoin" DROP CONSTRAINT IF EXISTS "man_wjoin_connec_id_fkey";
ALTER TABLE "man_wjoin" ADD FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
	
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_elementcat_id_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("elementcat_id") REFERENCES "cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_state_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_location_type_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_buildercat_id_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_ownercat_id_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_verified_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_end_fkey";
ALTER TABLE "element" ADD FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_element_id_fkey";
ALTER TABLE "element_x_arc" ADD FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_arc_id_fkey";
ALTER TABLE "element_x_arc" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_element_id_fkey";
ALTER TABLE "element_x_node" ADD FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_node_id_fkey";
ALTER TABLE "element_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_element_id_fkey";
ALTER TABLE "element_x_connec" ADD FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_connec_id_fkey";
ALTER TABLE "element_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "point" DROP CONSTRAINT IF EXISTS "point_point_type_fkey";
ALTER TABLE "point" ADD FOREIGN KEY ("point_type") REFERENCES "point_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "presszone" DROP CONSTRAINT IF EXISTS "presszone_presszonecat_id_fkey";
ALTER TABLE "presszone" ADD FOREIGN KEY ("presszonecat_id") REFERENCES "cat_press_zone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "pond" DROP CONSTRAINT IF EXISTS "pond_connec_id_fkey";
ALTER TABLE "pond" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pool" DROP CONSTRAINT IF EXISTS "pool_connec_id_fkey";
ALTER TABLE "pool" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_workcat_id_fkey";
ALTER TABLE "samplepoint" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_workcat_id_end_fkey";
ALTER TABLE "samplepoint" ADD FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
