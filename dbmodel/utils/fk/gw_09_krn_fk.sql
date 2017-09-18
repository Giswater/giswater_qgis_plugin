/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

/*
------
-- FK 01
------

ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_elementtype_id_fkey";
ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_matcat_id_fkey";

ALTER TABLE "macrodma" DROP CONSTRAINT IF EXISTS "macrodma_exploitation_id_fkey";

ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_macrodma_id_fkey";

ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_connec_id_fkey";
ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_vnode_id_fkey";

ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_arc_id_fkey";
ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_sector_id_fkey";

ALTER TABLE "cat_arc" DROP CONSTRAINT IF EXISTS "cat_arc_matcat_id_fkey";
ALTER TABLE "cat_node" DROP CONSTRAINT IF EXISTS "cat_node_matcat_id_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_node_type_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_nodecat_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_sector_id_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_state_fkey";
ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_verified_fkey";

ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_arccat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_sector_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_1_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_node_2_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_state_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_verified_fkey";

ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_matcat_id_fkey";
ALTER TABLE "cat_connec" DROP CONSTRAINT IF EXISTS "cat_connec_type_fkey";

ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_connecat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_sector_id_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_dma_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_dma_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_dma_id_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_soilcat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_soilcat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_soilcat_id_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_function_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_function_type_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_function_type_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_category_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_category_type_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_category_type_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_fluid_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_fluid_type_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_fluid_type_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_location_type_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_location_type_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_location_type_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_workcat_id_end_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_workcat_id_end_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_workcat_id_end_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_buildercat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_buildercat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_buildercat_id_fkey";

ALTER TABLE "node" DROP CONSTRAINT IF EXISTS "node_ownercat_id_fkey";
ALTER TABLE "arc" DROP CONSTRAINT IF EXISTS "arc_ownercat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_ownercat_id_fkey";
ALTER TABLE "connec" DROP CONSTRAINT IF EXISTS "connec_streetaxis_id_fkey";


ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_arc_id_fkey";

ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_elementcat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_state_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_location_type_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_buildercat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_ownercat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_verified_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_end_fkey";


ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_element_id_fkey";
ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_arc_id_fkey";

ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_element_id_fkey";
ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_node_id_fkey";

ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_element_id_fkey";
ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_connec_id_fkey";

ALTER TABLE "db_cat_table" DROP CONSTRAINT IF EXISTS "db_cat_table_db_cat_clientlayer_id_fkey";
ALTER TABLE "db_cat_table_x_column" DROP CONSTRAINT IF EXISTS "db_cat_table_x_column_db_cat_table_fkey";

ALTER TABLE link DROP CONSTRAINT IF EXISTS "link_featurecat_id_fkey";

ALTER TABLE man_custom_field DROP CONSTRAINT IF EXISTS "man_custom_field_man_custom_field_parameter_fkey";
ALTER TABLE man_custom_field_parameter DROP CONSTRAINT IF EXISTS "man_custom_field_parameter_cat_feature_fkey";

ALTER TABLE "arc_type" DROP CONSTRAINT IF EXISTS "arc_type_type_fkey";
ALTER TABLE "node_type" DROP CONSTRAINT IF EXISTS "node_type_type_fkey";

ALTER TABLE "ext_streetaxis" DROP CONSTRAINT IF EXISTS "ext_streetaxis_type_fkey";
ALTER TABLE "ext_urban_plot" DROP CONSTRAINT IF EXISTS "ext_urban_plot_streetaxis_fkey";

ALTER TABLE "samplepoint" DROP CONSTRAINT IF EXISTS "samplepoint_featurecat_id_fkey";

*/
-- 
--CREATE FK
---

ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



ALTER TABLE "cat_arc" ADD CONSTRAINT "cat_arc_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_node" ADD CONSTRAINT "cat_node_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


--ALTER TABLE "node" ADD CONSTRAINT "node_node_type_fkey" FOREIGN KEY ("node_type") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_nodecat_id_fkey" FOREIGN KEY ("nodecat_id") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD CONSTRAINT "node_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "arc" ADD CONSTRAINT "arc_arccat_id_fkey" FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_node_1_fkey" FOREIGN KEY ("node_1") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_node_2_fkey" FOREIGN KEY ("node_2") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_elementtype_id_fkey" FOREIGN KEY ("elementtype_id") REFERENCES "element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_connec" ADD CONSTRAINT "cat_connec_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" ADD CONSTRAINT "connec_connecat_id_fkey" FOREIGN KEY ("connecat_id") REFERENCES "cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "vnode" ADD CONSTRAINT "vnode_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_dma_id_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_soilcat_id_fkey" FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_category_type_fkey" FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_function_type_fkey" FOREIGN KEY ("function_type") REFERENCES "man_type_function" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_function_type_fkey" FOREIGN KEY ("function_type") REFERENCES "man_type_function" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_function_type_fkey" FOREIGN KEY ("function_type") REFERENCES "man_type_function" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_fluid_type_fkey" FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_streetaxis_id_fkey" FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD CONSTRAINT "node_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD CONSTRAINT "arc_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD CONSTRAINT "connec_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "element" ADD CONSTRAINT "element_elementcat_id_fkey" FOREIGN KEY ("elementcat_id") REFERENCES "cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_location_type_fkey" FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "element_x_arc" ADD CONSTRAINT "element_x_arc_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element_x_arc" ADD CONSTRAINT "element_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "element_x_node" ADD CONSTRAINT "element_x_node_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element_x_node" ADD CONSTRAINT "element_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "element_x_connec" ADD CONSTRAINT "element_x_connec_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element_x_connec" ADD CONSTRAINT "element_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

--ALTER TABLE db_cat_table ADD CONSTRAINT "db_cat_table_db_cat_clientlayer_id_fkey" FOREIGN KEY ("db_cat_clientlayer_id") REFERENCES db_cat_clientlayer ("qgis_layer_id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE db_cat_table_x_column ADD CONSTRAINT db_cat_table_x_column_db_cat_table_fkey FOREIGN KEY (table_id) REFERENCES db_cat_table (id) ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE link ADD CONSTRAINT link_featurecat_id_fkey FOREIGN KEY (featurecat_id) REFERENCES cat_feature (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;




---------------------
-- TODO: CONSTRAINTS ON arc_type & node_type man_table & epa_table
----------------------

--ALTER TABLE "cat_feature" ADD CONSTRAINT "cat_feature_cat_fkey" FOREIGN KEY ("system_id") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
--ALTER TABLE "cat_feature" ADD CONSTRAINT "cat_feature_type_fkey" FOREIGN KEY ("type) REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

--ALTER TABLE "arc_type" ADD CONSTRAINT "arc_type_id_fkey" FOREIGN KEY ("id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
--ALTER TABLE "arc_type" ADD CONSTRAINT "arc_type_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

--ALTER TABLE "node_type" ADD CONSTRAINT "node_type_id_fkey" FOREIGN KEY ("id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
--ALTER TABLE "node_type" ADD CONSTRAINT "node_type_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

--ALTER TABLE "connec_type" ADD CONSTRAINT "connec_type_id_fkey" FOREIGN KEY ("id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
--ALTER TABLE "connec_type" ADD CONSTRAINT "connec_type_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;





ALTER TABLE "ext_streetaxis" ADD CONSTRAINT "ext_streetaxis_type_fkey" FOREIGN KEY ("type") REFERENCES "ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
--ALTER TABLE "ext_urban_plot" ADD CONSTRAINT "ext_urban_plot_streetaxis_fkey" FOREIGN KEY ("streetaxis") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "plan_psector" ADD CONSTRAINT "plan_psector_priority_fkey" FOREIGN KEY ("priority") REFERENCES "value_priority" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "selector_psector" ADD CONSTRAINT "selector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "plan_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "selector_state" ADD CONSTRAINT "selector_state_id_fkey" FOREIGN KEY ("state_id") REFERENCES "value_state" ("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "selector_expl" ADD CONSTRAINT "selector_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON UPDATE CASCADE ON DELETE CASCADE;
