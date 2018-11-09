/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--

SET search_path = "SCHEMA_NAME", public, pg_catalog;


------
-- FK 01
------
-------
--DROP
-------
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_arctype_id_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_matcat_id_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_cost_unit_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_cost_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_m2bottom_cost_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_m3protec_cost_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_brand_fkey";
ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_model_fkey";

ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_nodetype_id_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_matcat_id_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_cost_unit_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_cost_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_brand_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_model_fkey";

ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_matcat_id_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_type_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_type_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_brand_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_model_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_cost_ut_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_cost_ml_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_cost_m3_fkey";

ALTER TABLE "cat_presszone" DROP CONSTRAINT IF EXISTS "cat_presszone_expl_id_fkey";


ALTER TABLE "pond" DROP CONSTRAINT IF EXISTS "pond_state_fkey";
ALTER TABLE "pond" DROP CONSTRAINT IF EXISTS "pond_connec_id_fkey";
ALTER TABLE "pond" DROP CONSTRAINT IF EXISTS "pond_dma_id_fkey";
ALTER TABLE "pond" DROP CONSTRAINT IF EXISTS "pond_exploitation_id_fkey";
  
ALTER TABLE "pool" DROP CONSTRAINT IF EXISTS "pool_state_fkey";
ALTER TABLE "pool" DROP CONSTRAINT IF EXISTS "pool_connec_id_fkey";
ALTER TABLE "pool" DROP CONSTRAINT IF EXISTS "pool_dma_id_fkey";
ALTER TABLE "pool" DROP CONSTRAINT IF EXISTS "pool_exploitation_id_fkey";

ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_featurecat_fkey" ;
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_state_fkey";
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_exploitation_id_fkey";
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_verified_fkey";
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_workcat_id_fkey";
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_workcat_id_end_fkey";
ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_presszonecat_id_fkey";


--MAN TYPE
ALTER TABLE "man_type_category" DROP CONSTRAINT IF EXISTS "man_type_category_feature_type_fkey";
ALTER TABLE "man_type_category" DROP CONSTRAINT IF EXISTS "man_type_category_unique" CASCADE;

ALTER TABLE "man_type_function" DROP CONSTRAINT IF EXISTS "man_type_function_feature_type_fkey";
ALTER TABLE "man_type_function" DROP CONSTRAINT IF EXISTS "man_type_function_unique" CASCADE;

ALTER TABLE "man_type_location" DROP CONSTRAINT IF EXISTS "man_type_location_feature_type_fkey";
ALTER TABLE "man_type_location" DROP CONSTRAINT IF EXISTS "man_type_location_unique" CASCADE;

ALTER TABLE "man_type_fluid" DROP CONSTRAINT IF EXISTS "man_type_fluid_feature_type_fkey";
ALTER TABLE "man_type_fluid" DROP CONSTRAINT IF EXISTS "man_type_fluid_unique" CASCADE;



--NODE/ARC/CONNEC
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_nodecat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_sector_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_arc_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_parent_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_dma_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_soilcat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_end_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_buildercat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_ownercat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_verified_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_expl_fkey" ;
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_epa_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_feature_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_presszonecat_id_fkey";
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_function_type_feature_type_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS  node_category_type_feature_type_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS  node_fluid_type_feature_type_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS  node_location_type_feature_type_fkey;




ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arccat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_sector_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_1_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_2_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_dma_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_soilcat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_end_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_buildercat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_ownercat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_verified_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_expl_fkey" ;
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_epa_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_feature_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_presszonecat_id_fkey";
ALTER TABLE arc DROP CONSTRAINT IF EXISTS  arc_function_type_feature_type_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS  arc_category_type_feature_type_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS  arc_fluid_type_feature_type_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS  arc_location_type_feature_type_fkey;



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
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_verified_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_expl_fkey" ;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_muni_id_fkey" ;
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_feature_type_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_presszonecat_id_fkey";
ALTER TABLE connec DROP CONSTRAINT IF EXISTS  connec_function_type_feature_type_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS  connec_category_type_feature_type_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS  connec_fluid_type_feature_type_fkey;
ALTER TABLE connec DROP CONSTRAINT IF EXISTS  connec_location_type_feature_type_fkey;



--MAN_TABLE

ALTER TABLE "man_junction" DROP CONSTRAINT IF EXISTS "man_junction_node_id_fkey";
ALTER TABLE "man_tank" DROP CONSTRAINT IF EXISTS "man_tank_node_id_fkey";
ALTER TABLE "man_tank" DROP CONSTRAINT IF EXISTS "man_tank_pol_id_fkey";
ALTER TABLE "man_hydrant" DROP CONSTRAINT IF EXISTS "man_hydrant_node_id_fkey";
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_node_id_fkey";
ALTER TABLE "man_valve" DROP CONSTRAINT IF EXISTS "man_valve_cat_valve2_fkey";
ALTER TABLE "man_pump" DROP CONSTRAINT IF EXISTS "man_pump_node_id_fkey";
ALTER TABLE "man_meter" DROP CONSTRAINT IF EXISTS "man_meter_node_id_fkey";
ALTER TABLE "man_filter" DROP CONSTRAINT IF EXISTS "man_filter_node_id_fkey";
ALTER TABLE "man_reduction" DROP CONSTRAINT IF EXISTS "man_reduction_node_id_fkey";
ALTER TABLE "man_source" DROP CONSTRAINT IF EXISTS "man_source_node_id_fkey";
ALTER TABLE "man_waterwell" DROP CONSTRAINT IF EXISTS "man_waterwell_node_id_fkey";
ALTER TABLE "man_manhole" DROP CONSTRAINT IF EXISTS "man_manhole_node_id_fkey";
ALTER TABLE "man_register" DROP CONSTRAINT IF EXISTS "man_register_node_id_fkey";
ALTER TABLE "man_register" DROP CONSTRAINT IF EXISTS "man_register_pol_id_fkey";
ALTER TABLE "man_netwjoin" DROP CONSTRAINT IF EXISTS "man_netwjoin_node_id_fkey";
ALTER TABLE "man_netwjoin" DROP CONSTRAINT IF EXISTS "man_netwjoin_cat_valve_fkey";
ALTER TABLE "man_expansiontank" DROP CONSTRAINT IF EXISTS "man_expansiontank_node_id_fkey";
ALTER TABLE "man_flexunion" DROP CONSTRAINT IF EXISTS "man_flexunion_node_id_fkey";
ALTER TABLE "man_wtp" DROP CONSTRAINT IF EXISTS "man_wtp_node_id_fkey";
ALTER TABLE "man_netsamplepoint" DROP CONSTRAINT IF EXISTS "man_netsamplepoint_node_id_fkey";
ALTER TABLE "man_netelement" DROP CONSTRAINT IF EXISTS "man_netelement_node_id_fkey";
ALTER TABLE "man_hydrant" DROP CONSTRAINT IF EXISTS "man_hydrant_catnode_id_fkey";	

ALTER TABLE "man_pipe" DROP CONSTRAINT IF EXISTS "man_pipe_arc_id_fkey";
ALTER TABLE "man_varc" DROP CONSTRAINT IF EXISTS "man_varc_arc_id_fkey";

ALTER TABLE "man_fountain" DROP CONSTRAINT IF EXISTS "man_fountain_connec_id_fkey";
ALTER TABLE "man_fountain" DROP CONSTRAINT IF EXISTS "man_fountain_pol_id_fkey";
ALTER TABLE "man_fountain" DROP CONSTRAINT IF EXISTS "man_fountain_linked_connec_fkey";

ALTER TABLE "man_greentap" DROP CONSTRAINT IF EXISTS "man_greentap_connec_id_fkey";
ALTER TABLE "man_greentap" DROP CONSTRAINT IF EXISTS "man_greentap_linked_connec_fkey";

ALTER TABLE "man_tap" DROP CONSTRAINT IF EXISTS "man_tap_connec_id_fkey";
ALTER TABLE "man_tap" DROP CONSTRAINT IF EXISTS "man_tap_cat_valve_fkey";
ALTER TABLE "man_tap" DROP CONSTRAINT IF EXISTS "man_tap_linked_connec_fkey";

ALTER TABLE "man_wjoin" DROP CONSTRAINT IF EXISTS "man_wjoin_connec_id_fkey";
ALTER TABLE "man_wjoin" DROP CONSTRAINT IF EXISTS "man_wjoin_cat_valve_fkey";

ALTER TABLE "macrodma" DROP CONSTRAINT IF EXISTS "macrodma_exploitation_id_fkey";

ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_exploitation_id_fkey";
ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_macrodma_id_fkey";


-------
--ADD
-------

--CATALOGS
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_arctype_id_fkey" FOREIGN KEY ("arctype_id") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_cost_unit_fkey" FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_cost_fkey" FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_m2bottom_cost_fkey" FOREIGN KEY ("m2bottom_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_m3protec_cost_fkey" FOREIGN KEY ("m3protec_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_brand_fkey" FOREIGN KEY ("brand") REFERENCES "cat_brand" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_model_fkey" FOREIGN KEY ("model") REFERENCES "cat_brand_model" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_nodetype_id_fkey" FOREIGN KEY ("nodetype_id") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_cost_unit_fkey" FOREIGN KEY ("cost_unit") REFERENCES "price_value_unit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_cost_fkey" FOREIGN KEY ("cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_brand_fkey" FOREIGN KEY ("brand") REFERENCES "cat_brand" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_model_fkey" FOREIGN KEY ("model") REFERENCES "cat_brand_model" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_type_fkey" FOREIGN KEY ("connectype_id") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_brand_fkey" FOREIGN KEY ("brand") REFERENCES "cat_brand" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_model_fkey" FOREIGN KEY ("model") REFERENCES "cat_brand_model" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_cost_ut_fkey" FOREIGN KEY ("cost_ut") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_cost_ml_fkey" FOREIGN KEY ("cost_ml") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_cost_m3_fkey" FOREIGN KEY ("cost_m3") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_presszone" ADD CONSTRAINT "cat_presszone_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;



--MAN_TYPE
ALTER TABLE "man_type_category" ADD CONSTRAINT "man_type_category_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "man_type_category" ADD CONSTRAINT "man_type_category_unique" UNIQUE (category_type, feature_type);

ALTER TABLE "man_type_function" ADD CONSTRAINT "man_type_function_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "man_type_function" ADD CONSTRAINT "man_type_function_unique" UNIQUE (function_type, feature_type);

ALTER TABLE "man_type_location" ADD CONSTRAINT "man_type_location_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "man_type_location" ADD CONSTRAINT "man_type_location_unique" UNIQUE (location_type, feature_type);
 
ALTER TABLE "man_type_fluid" ADD CONSTRAINT "man_type_fluid_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "man_type_fluid" ADD CONSTRAINT "man_type_fluid_unique" UNIQUE (fluid_type, feature_type);


--SECTORES 
ALTER TABLE "macrodma" ADD CONSTRAINT "macrodma_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "dma" ADD CONSTRAINT "dma_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dma" ADD CONSTRAINT "dma_macrodma_id_fkey" FOREIGN KEY ("macrodma_id") REFERENCES "macrodma" ("macrodma_id") ON DELETE RESTRICT ON UPDATE CASCADE;


--NODE/ARC/CONNEC/GULLY
ALTER TABLE "node" ADD CONSTRAINT "node_nodecat_id_fkey" FOREIGN KEY ("nodecat_id") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_epa_type_fkey" FOREIGN KEY ("epa_type") REFERENCES "inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_presszonecat_id_fkey" FOREIGN KEY ("presszonecat_id")  REFERENCES "cat_presszone" ("id") ON  DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_function_type_feature_type_fkey" FOREIGN KEY ("function_type","feature_type") REFERENCES "man_type_function" ("function_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "node" ADD CONSTRAINT "node_category_type_feature_type_fkey" FOREIGN KEY ("category_type","feature_type") REFERENCES "man_type_category" ("category_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "node" ADD CONSTRAINT "node_fluid_type_feature_type_fkey" FOREIGN KEY ("fluid_type","feature_type") REFERENCES "man_type_fluid" ("fluid_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "node" ADD CONSTRAINT "node_location_type_feature_type_fkey" FOREIGN KEY ("location_type","feature_type") REFERENCES "man_type_location" ("location_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 


ALTER TABLE "arc" ADD CONSTRAINT "arc_node_1_fkey" FOREIGN KEY ("node_1") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_node_2_fkey" FOREIGN KEY ("node_2") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_arccat_id_fkey" FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_expl_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_epa_type_fkey" FOREIGN KEY ("epa_type") REFERENCES "inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_presszonecat_id_fkey" FOREIGN KEY ("presszonecat_id")  REFERENCES "cat_presszone" ("id") ON  DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_function_type_feature_type_fkey" FOREIGN KEY ("function_type","feature_type") REFERENCES "man_type_function" ("function_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "arc" ADD CONSTRAINT "arc_category_type_feature_type_fkey" FOREIGN KEY ("category_type","feature_type") REFERENCES "man_type_category" ("category_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "arc" ADD CONSTRAINT "arc_fluid_type_feature_type_fkey" FOREIGN KEY ("fluid_type","feature_type") REFERENCES "man_type_fluid" ("fluid_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "arc" ADD CONSTRAINT "arc_location_type_feature_type_fkey" FOREIGN KEY ("location_type","feature_type") REFERENCES "man_type_location" ("location_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 



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
ALTER TABLE "connec" ADD CONSTRAINT "connec_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_presszonecat_id_fkey" FOREIGN KEY ("presszonecat_id")  REFERENCES "cat_presszone" ("id") ON  DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_function_type_feature_type_fkey" FOREIGN KEY ("function_type","feature_type") REFERENCES "man_type_function" ("function_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "connec" ADD CONSTRAINT "connec_category_type_feature_type_fkey" FOREIGN KEY ("category_type","feature_type") REFERENCES "man_type_category" ("category_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "connec" ADD CONSTRAINT "connec_fluid_type_feature_type_fkey" FOREIGN KEY ("fluid_type","feature_type") REFERENCES "man_type_fluid" ("fluid_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "connec" ADD CONSTRAINT "connec_location_type_feature_type_fkey" FOREIGN KEY ("location_type","feature_type") REFERENCES "man_type_location" ("location_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 


-- POOL/POND
ALTER TABLE "pond" ADD CONSTRAINT "pond_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pond" ADD CONSTRAINT "pond_state_fkey" FOREIGN KEY ("state")  REFERENCES "value_state" ("id") ON  DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pond" ADD CONSTRAINT "pond_dma_id_fkey" FOREIGN KEY ("dma_id")  REFERENCES "dma" ("dma_id") ON  DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pond" ADD CONSTRAINT "pond_exploitation_id_fkey" FOREIGN KEY ("expl_id")  REFERENCES "exploitation" ("expl_id") ON  DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "pool" ADD CONSTRAINT "pool_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pool" ADD CONSTRAINT "pool_state_fkey" FOREIGN KEY ("state")  REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pool" ADD CONSTRAINT "pool_dma_id_fkey" FOREIGN KEY ("dma_id")  REFERENCES "dma" ("dma_id") ON  DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "pool" ADD CONSTRAINT "pool_exploitation_id_fkey" FOREIGN KEY ("expl_id")  REFERENCES "exploitation" ("expl_id") ON  DELETE RESTRICT ON UPDATE CASCADE;



--MAN TABLES
ALTER TABLE "man_junction" ADD CONSTRAINT "man_junction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_tank" ADD CONSTRAINT "man_tank_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_tank" ADD CONSTRAINT "man_tank_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon" ("pol_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_hydrant" ADD CONSTRAINT "man_hydrant_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" ADD CONSTRAINT "man_valve_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" ADD CONSTRAINT "man_valve_cat_valve2_fkey" FOREIGN KEY ("cat_valve2") REFERENCES "cat_node" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_pump" ADD CONSTRAINT "man_pump_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_filter" ADD CONSTRAINT "man_filter_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_meter" ADD CONSTRAINT "man_meter_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_manhole" ADD CONSTRAINT "man_manhole_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE  "man_reduction" ADD CONSTRAINT "man_reduction_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_source" ADD CONSTRAINT "man_source_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_waterwell" ADD CONSTRAINT "man_waterwell_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_register" ADD CONSTRAINT "man_register_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_register" ADD CONSTRAINT "man_register_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon" ("pol_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_netwjoin" ADD CONSTRAINT "man_netwjoin_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_netwjoin" ADD CONSTRAINT "man_netwjoin_cat_valve_fkey" FOREIGN KEY ("cat_valve") REFERENCES "cat_node" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_expansiontank" ADD CONSTRAINT "man_expansiontank_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_flexunion" ADD CONSTRAINT "man_flexunion_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_wtp" ADD CONSTRAINT "man_wtp_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_netsamplepoint" ADD CONSTRAINT "man_netsamplepoint_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;	
ALTER TABLE "man_netelement" ADD CONSTRAINT "man_netelement_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node"("node_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_hydrant" ADD CONSTRAINT "man_hydrant_catnode_id_fkey" FOREIGN KEY ("valve") REFERENCES "cat_node"("id") ON UPDATE CASCADE ON DELETE CASCADE;	

ALTER TABLE "man_pipe" ADD CONSTRAINT "man_pipe_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_varc" ADD CONSTRAINT "man_varc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_fountain" ADD CONSTRAINT "man_fountain_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_fountain" ADD CONSTRAINT "man_fountain_pol_id_fkey" FOREIGN KEY ("pol_id") REFERENCES "polygon"("pol_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_fountain"  ADD CONSTRAINT "man_fountain_linked_connec_fkey" FOREIGN KEY ("linked_connec") REFERENCES "connec" ("connec_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "man_greentap" ADD CONSTRAINT "man_greentap_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_greentap"  ADD CONSTRAINT "man_greentap_linked_connec_fkey" FOREIGN KEY ("linked_connec") REFERENCES "connec"("connec_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "man_tap" ADD CONSTRAINT "man_tap_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_tap" ADD CONSTRAINT "man_tap_cat_valve_fkey" FOREIGN KEY ("cat_valve") REFERENCES "cat_node" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_tap"  ADD CONSTRAINT "man_tap_linked_connec_fkey" FOREIGN KEY ("linked_connec") REFERENCES "connec" ("connec_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "man_wjoin" ADD CONSTRAINT "man_wjoin_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec"("connec_id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_wjoin" ADD CONSTRAINT "man_wjoin_cat_valve_fkey" FOREIGN KEY ("cat_valve") REFERENCES "cat_node" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

--SAMPLEPOINT
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_featurecat_fkey" FOREIGN KEY ("featurecat_id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_verified_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "samplepoint" ADD CONSTRAINT "samplepoint_presszonecat_id_fkey" FOREIGN KEY ("presszonecat_id") REFERENCES "cat_presszone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;;

