/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


------
-- FK 01
------
---------
--DROP
---------
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_shape_id_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_matcat_id_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_cost_unit_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_cost_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_m2bottom_cost_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_m3protec_cost_fkey";

ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_cost_unit_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_cost_fkey";

ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS  "cat_connec_matcat_id_fkey";

ALTER TABLE "cat_grate" DROP CONSTRAINT IF EXISTS "cat_grate_matcat_id_fkey";

ALTER TABLE "macrodma" DROP CONSTRAINT IF EXISTS "macrodma_exploitation_id_fkey";

ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_exploitation_id_fkey";
ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_macrodma_id_fkey";

ALTER TABLE "sector" DROP CONSTRAINT IF EXISTS "sector_macrosector_id_fkey";

--NODE/ARC/CONNEC
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_nodecat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_node_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_sector_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_dma_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_soilcat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_end_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_buildercat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_ownercat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_muni_id_fkey" ;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_streetaxis_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_address_02_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_verified_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_expl_fkey" ;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_expl_fkey" ;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_epa_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_feature_type_fkey"

ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arccat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arc_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_sector_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_1_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_2_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state__type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_dma_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_soilcat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id__end_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_buildercat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_muni_id_fkey" ;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_streetaxis_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_address_02_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_ownercat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_verified_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_expl_fkey" ;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_epa_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_feature_type_fkey"

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_connecat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_sector_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_arc_id_fkey" ;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_state_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_state_type_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_dma_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_soilcat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_end_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_buildercat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_ownercat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_muni_id_fkey" ;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_address_02_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_verified_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_expl_fkey" ;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_feature_type_fkey"
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_type_id_fkey" ;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_featurecat_id_fkey";

ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_matcat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_type_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_gratecat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_connec_arccat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_arc_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_sector_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_dma_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_state_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_state_type_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_soilcat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_workcat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_workcat_id_end_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_buildercat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_ownercat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_muni_id_fkey" ;
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_streetaxis_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_address_02_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_featurecat_id_fkey";
ALTER TABLE "gully" DROP CONSTRAINT IF EXISTS "gully_feature_type_fkey" ;

--MAN TABLES
ALTER TABLE "man_netinit" DROP CONSTRAINT IF EXISTS "man_netinit_node_id_fkey";
ALTER TABLE "man_junction" DROP CONSTRAINT IF EXISTS "man_junction_node_id_fkey";
ALTER TABLE "man_manhole" DROP CONSTRAINT IF EXISTS "man_manhole_node_id_fkey";
ALTER TABLE "man_wjump" DROP CONSTRAINT IF EXISTS "man_wjump_node_id_fkey";
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_node_id_fkey";
ALTER TABLE "man_outfall" DROP CONSTRAINT IF EXISTS "man_outfall_node_id_fkey";
ALTER TABLE "man_netelement" DROP CONSTRAINT IF EXISTS "man_netelement_node_id_fkey";
ALTER TABLE "man_netgully" DROP CONSTRAINT IF EXISTS "man_netgully_node_id_fkey";
ALTER TABLE "netgully" DROP CONSTRAINT IF EXISTS "netgully_gratecat_id_fkey";
ALTER TABLE "netgully" DROP CONSTRAINT IF EXISTS "netgully_muni_id_fkey";
ALTER TABLE "man_netgully" DROP CONSTRAINT IF EXISTS "man_netgully_pol_id_fkey" ;
ALTER TABLE "man_chamber" DROP CONSTRAINT IF EXISTS "man_chamber_node_id_fkey";
ALTER TABLE "man_chamber" DROP CONSTRAINT IF EXISTS "man_chamber_pol_id_fkey";
ALTER TABLE "man_storage" DROP CONSTRAINT IF EXISTS "man_storage_node_id_fkey";
ALTER TABLE "man_storage" DROP CONSTRAINT IF EXISTS "man_storage_pol_id_fkey"
ALTER TABLE "man_wwtp" DROP CONSTRAINT IF EXISTS "man_wwtp_node_id_fkey";
ALTER TABLE "man_wwtp" DROP CONSTRAINT IF EXISTS "man_wwtp_pol_id_fkey";

ALTER TABLE "man_conduit" DROP CONSTRAINT IF EXISTS "man_conduit_arc_id_fkey";
ALTER TABLE "man_varc" DROP CONSTRAINT IF EXISTS "man_varc_arc_id_fkey";
ALTER TABLE "man_siphon" DROP CONSTRAINT IF EXISTS "man_siphon_arc_id_fkey";
ALTER TABLE "man_waccel" DROP CONSTRAINT IF EXISTS "man_waccel_arc_id_fkey";

--OTHERS
ALTER TABLE "element_x_gully" DROP CONSTRAINT IF EXISTS "element_x_gully_element_id_fkey";
ALTER TABLE "element_x_gully" DROP CONSTRAINT IF EXISTS "element_x_gully_gully_id_fkey";

---------
--ADD
---------

--CATALOGS
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_shape_id_fkey" FOREIGN KEY ("shape") REFERENCES "cat_arc_shape" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_cost_unit_fkey" FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_cost_fkey" FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_m2bottom_cost_fkey" FOREIGN KEY ("m2bottom_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_m3protec_cost_fkey" FOREIGN KEY ("m3protec_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_cost_unit_fkey" FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_cost_fkey" FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_grate" ADD CONSTRAINT "cat_grate_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

--SECTORES 
ALTER TABLE "macrodma" ADD CONSTRAINT "macrodma_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "dma" ADD CONSTRAINT "dma_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dma" ADD CONSTRAINT "dma_macrodma_id_fkey" FOREIGN KEY ("macrodma_id") REFERENCES "macrodma" ("macrodma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sector" ADD CONSTRAINT "sector_macrosector_id_fkey" FOREIGN KEY ("macrosector_id") REFERENCES "macrosector" ("macrosector_id") ON DELETE RESTRICT ON UPDATE CASCADE;


--NODE/ARC/CONNECT/GULLY
ALTER TABLE "node" ADD CONSTRAINT "node_nodecat_id_fkey" FOREIGN KEY ("nodecat_id") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_node_type_fkey" FOREIGN KEY ("node_type") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_address_02_fkey" FOREIGN KEY ("address_02") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_epa_type_fkey" FOREIGN KEY ("epa_type") REFERENCES "inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "arc" ADD CONSTRAINT "arc_node_1_fkey" FOREIGN KEY ("node_1") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_node_2_fkey" FOREIGN KEY ("node_2") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_arccat_id_fkey" FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_arc_type_fkey" FOREIGN KEY ("arc_type") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_address_02_fkey" FOREIGN KEY ("address_02") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_epa_type_fkey" FOREIGN KEY ("epa_type") REFERENCES "inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "connec" ADD CONSTRAINT "connec_connecat_id_fkey" FOREIGN KEY ("connecat_id") REFERENCES "cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_address_02_fkey" FOREIGN KEY ("address_02") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_type_id_fkey" FOREIGN KEY ("connec_type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "gully" ADD CONSTRAINT "gully_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_type_id_fkey" FOREIGN KEY ("gully_type") REFERENCES "gully_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_gratecat_id_fkey" FOREIGN KEY ("gratecat_id") REFERENCES "cat_grate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_connec_arccat_id_fkey" FOREIGN KEY ("connec_arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_state_id_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_muni_id_fkey" FOREIGN KEY ("muni_id") REFERENCES "ext_municipality" ("muni_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_address_02_fkey" FOREIGN KEY ("address_02") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_featurecat_id_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "gully" ADD CONSTRAINT "gully_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

--MAN TABLES
ALTER TABLE "man_netinit" ADD CONSTRAINT "man_netinit_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_junction" ADD CONSTRAINT "man_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_manhole" ADD CONSTRAINT "man_manhole_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wjump" ADD CONSTRAINT "man_wjump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" ADD CONSTRAINT "man_valve_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_outfall" ADD CONSTRAINT "man_outfall_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netelement" ADD CONSTRAINT "man_netelement_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netgully" ADD CONSTRAINT "man_netgully_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netgully" ADD CONSTRAINT "man_netgully_gratecat_id_fkey" FOREIGN KEY ("gratecat_id") REFERENCES "cat_grate" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "man_netgully" ADD CONSTRAINT "man_netgully_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon" ("pol_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_chamber" ADD CONSTRAINT "man_chamber_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_chamber" ADD CONSTRAINT "man_chamber_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon" ("pol_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_storage" ADD CONSTRAINT "man_storage_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_storage" ADD CONSTRAINT "man_storage_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon" ("pol_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wwtp" ADD CONSTRAINT "man_wwtp_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_wwtp" ADD CONSTRAINT "man_wwtp_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon" ("pol_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_conduit" ADD CONSTRAINT "man_conduit_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_varc" ADD CONSTRAINT "man_varc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_siphon" ADD CONSTRAINT "man_siphon_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_waccel" ADD CONSTRAINT "man_waccel_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;


--OTHERS
ALTER TABLE "element_x_gully" ADD CONSTRAINT "element_x_gully_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element_x_gully" ADD CONSTRAINT "element_x_gully_gully_id_fkey" FOREIGN KEY ("gully_id") REFERENCES "gully" ("gully_id") ON DELETE RESTRICT ON UPDATE CASCADE;
