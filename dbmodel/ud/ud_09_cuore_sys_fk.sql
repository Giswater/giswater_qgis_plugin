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
ALTER TABLE "ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_type_fkey" FOREIGN KEY ("type") REFERENCES "ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_urban_propierties" DROP CONSTRAINT IF EXISTS "ext_urban_propierties_streetaxis_fkey";
ALTER TABLE "ext_urban_propierties" ADD CONSTRAINT "ext_urban_propierties_streetaxis_fkey" FOREIGN KEY ("streetaxis") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



------
-- FK 01
------
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_matcat_id_fkey";
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_matcat_id_fkey";
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_node_type_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_node_type_fkey" FOREIGN KEY ("node_type") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_nodecat_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_nodecat_id_fkey" FOREIGN KEY ("nodecat_id") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_sector_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_verified_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arc_type_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_arc_type_fkey" FOREIGN KEY ("arc_type") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arccat_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_arccat_id_fkey" FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_sector_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_1_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_node_1_fkey" FOREIGN KEY ("node_1") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_2_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_node_2_fkey" FOREIGN KEY ("node_2") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_verified_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_elementtype_id_fkey";
ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_elementtype_id_fkey" FOREIGN KEY ("elementtype_id") REFERENCES "element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_matcat_id_fkey";
ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_matcat_id_fkey";
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_type_fkey";
--ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_type_fkey" FOREIGN KEY ("type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_connecat_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_connecat_id_fkey" FOREIGN KEY ("connecat_id") REFERENCES "cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_sector_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_featurecat_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_type_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_type_id_fkey" FOREIGN KEY ("connec_type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_sector_id_fkey";
ALTER TABLE "dma" ADD CONSTRAINT "dma_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_connec_id_fkey";
ALTER TABLE "link" ADD CONSTRAINT "link_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_vnode_id_fkey";
ALTER TABLE "link" ADD CONSTRAINT "link_vnode_id_fkey" FOREIGN KEY ("vnode_id") REFERENCES "vnode" ("vnode_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_arc_id_fkey";
ALTER TABLE "vnode" ADD CONSTRAINT "vnode_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_sector_id_fkey";
ALTER TABLE "vnode" ADD CONSTRAINT "vnode_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_gratecat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_gratecat_id_fkey" FOREIGN KEY ("gratecat_id") REFERENCES "cat_grate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_arccat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_arccat_id_fkey" FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_matcat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_groove_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_groove_fkey" FOREIGN KEY ("groove") REFERENCES "value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_siphon_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_siphon_fkey" FOREIGN KEY ("siphon") REFERENCES "value_yesno" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_featurecat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_dma_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_dma_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_dma_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_dma_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_soilcat_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_soilcat_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_soilcat_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_soilcat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_category_type_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_category_type_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_category_type_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_category_type_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_fluid_type_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_fluid_type_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_fluid_type_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_fluid_type_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_location_type_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_location_type_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_location_type_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_location_type_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_workcat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_end_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_end_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_end_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_workcat_id_end_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_buildercat_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_buildercat_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_buildercat_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_buildercat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_ownercat_id_fkey";
ALTER TABLE "node" ADD CONSTRAINT "node_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_ownercat_id_fkey";
ALTER TABLE "arc" ADD CONSTRAINT "arc_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_ownercat_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_ownercat_id_fkey";
ALTER TABLE "gully" ADD CONSTRAINT "gully_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey";
ALTER TABLE "connec" ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "man_junction" DROP CONSTRAINT IF EXISTS "man_junction_node_id_fkey";
ALTER TABLE "man_junction" ADD CONSTRAINT "man_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_storage" DROP CONSTRAINT IF EXISTS "man_storage_node_id_fkey";
ALTER TABLE "man_storage" ADD CONSTRAINT "man_storage_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_outfall" DROP CONSTRAINT IF EXISTS "man_outfall_node_id_fkey";
ALTER TABLE "man_outfall" ADD CONSTRAINT "man_outfall_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netgully" DROP CONSTRAINT IF EXISTS "man_netgully_node_id_fkey";
ALTER TABLE "man_netgully" ADD CONSTRAINT "man_netgully_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_node_id_fkey";
ALTER TABLE "man_valve" ADD CONSTRAINT "man_valve_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_chamber" DROP CONSTRAINT IF EXISTS "man_chamber_node_id_fkey";
ALTER TABLE "man_chamber" ADD CONSTRAINT "man_chamber_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_manhole" DROP CONSTRAINT IF EXISTS "man_manhole_node_id_fkey";
ALTER TABLE "man_manhole" ADD CONSTRAINT "man_manhole_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netinit" DROP CONSTRAINT IF EXISTS "man_netinit_node_id_fkey";
ALTER TABLE "man_netinit" ADD CONSTRAINT "man_netinit_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wjump" DROP CONSTRAINT IF EXISTS "man_wjump_node_id_fkey";
ALTER TABLE "man_wjump" ADD CONSTRAINT "man_wjump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wwtp" DROP CONSTRAINT IF EXISTS "man_wwtp_node_id_fkey";
ALTER TABLE "man_wwtp" ADD CONSTRAINT "man_wwtp_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_conduit" DROP CONSTRAINT IF EXISTS "man_conduit_arc_id_fkey";
ALTER TABLE "man_conduit" ADD CONSTRAINT "man_conduit_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_varc" DROP CONSTRAINT IF EXISTS "man_varc_arc_id_fkey";
ALTER TABLE "man_varc" ADD CONSTRAINT "man_varc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_siphon" DROP CONSTRAINT IF EXISTS "man_siphon_arc_id_fkey";
ALTER TABLE "man_siphon" ADD CONSTRAINT "man_siphon_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_waccel" DROP CONSTRAINT IF EXISTS "man_waccel_arc_id_fkey";
ALTER TABLE "man_waccel" ADD CONSTRAINT "man_waccel_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_elementcat_id_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_elementcat_id_fkey" FOREIGN KEY ("elementcat_id") REFERENCES "cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_state_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_location_type_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_buildercat_id_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_ownercat_id_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_verified_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_end_fkey";
ALTER TABLE "element" ADD CONSTRAINT "element_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_element_id_fkey";
ALTER TABLE "element_x_arc" ADD CONSTRAINT "element_x_arc_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_arc_id_fkey";
ALTER TABLE "element_x_arc" ADD CONSTRAINT "element_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_element_id_fkey";
ALTER TABLE "element_x_node" ADD CONSTRAINT "element_x_node_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_node_id_fkey";
ALTER TABLE "element_x_node" ADD CONSTRAINT "element_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_element_id_fkey";
ALTER TABLE "element_x_connec" ADD CONSTRAINT "element_x_connec_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_connec_id_fkey";
ALTER TABLE "element_x_connec" ADD CONSTRAINT "element_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_gully" DROP CONSTRAINT IF EXISTS "element_x_gully_element_id_fkey";
ALTER TABLE "element_x_gully" ADD CONSTRAINT "element_x_gully_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_gully" DROP CONSTRAINT IF EXISTS "element_x_gully_gully_id_fkey";
ALTER TABLE "element_x_gully" ADD CONSTRAINT "element_x_gully_gully_id_fkey" FOREIGN KEY ("gully_id") REFERENCES "gully" ("gully_id") ON DELETE CASCADE ON UPDATE CASCADE;

--LTER TABLE "db_cat_table" DROP CONSTRAINT IF EXISTS "db_cat_table_db_cat_clientlayer_id_fkey";
--ALTER TABLE db_cat_table ADD CONSTRAINT "db_cat_table_db_cat_clientlayer_id_fkey" FOREIGN KEY ("db_cat_clientlayer_id") REFERENCES db_cat_clientlayer ("qgis_layer_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "db_cat_table_x_column" DROP CONSTRAINT IF EXISTS "db_cat_table_x_column_db_cat_table_fkey";
--ALTER TABLE db_cat_table_x_column ADD CONSTRAINT db_cat_table_x_column_db_cat_table_fkey FOREIGN KEY (table_id) REFERENCES db_cat_table (id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_featurecat_id_fkey";
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
