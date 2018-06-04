/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--------
--DROP
--------



ALTER TABLE "arc_type" DROP CONSTRAINT IF EXISTS "arc_type_epa_default_fkey";
ALTER TABLE "arc_type" DROP CONSTRAINT IF EXISTS "arc_type_id_fkey";
ALTER TABLE "arc_type" DROP CONSTRAINT IF EXISTS "arc_type_type_fkey";

ALTER TABLE "node_type" DROP CONSTRAINT IF EXISTS "node_type_epa_default_fkey";
ALTER TABLE "node_type" DROP CONSTRAINT IF EXISTS "node_type_id_fkey";
ALTER TABLE "node_type" DROP CONSTRAINT IF EXISTS "node_type_type_fkey";

ALTER TABLE "connec_type" DROP CONSTRAINT IF EXISTS "connec_type_id_fkey";
ALTER TABLE "connec_type" DROP CONSTRAINT IF EXISTS "connec_type_type_fkey";

ALTER TABLE "sys_feature_cat" DROP CONSTRAINT IF EXISTS "sys_feature_cat_type_fkey";

ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_elementtype_id_fkey";
ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_matcat_id_fkey";
ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_brand_fkey";
ALTER TABLE "cat_element" DROP CONSTRAINT IF EXISTS "cat_element_model_fkey";

ALTER TABLE "cat_feature" DROP CONSTRAINT IF EXISTS "cat_feature_feature_type_fkey";
ALTER TABLE "cat_feature" DROP CONSTRAINT IF EXISTS "cat_feature_system_id_fkey";

ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m3exc_cost_fkey";
ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m3fill_cost_fkey";
ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m3excess_cost_fkey";
ALTER TABLE "cat_soil" DROP CONSTRAINT IF EXISTS "cat_soil_m2trenchl_cost_fkey";

--ALTER TABLE "cat_work" DROP CONSTRAINT IF EXISTS "cat_work_workid_key1_fkey";
--ALTER TABLE "cat_work" DROP CONSTRAINT IF EXISTS "cat_work_workid_key2_fkey";

ALTER TABLE "cat_pavement" DROP CONSTRAINT IF EXISTS "cat_pavement_m2_cost_fkey";

ALTER TABLE "cat_brand_model" DROP CONSTRAINT IF EXISTS "cat_brand_model_catbrand_id_fkey";

ALTER TABLE "cat_arc_class_cat" DROP CONSTRAINT IF EXISTS "cat_arc_class_class_type_fkey";

ALTER TABLE "cat_arc_class" DROP CONSTRAINT IF EXISTS "cat_arc_class_classtype_id_fkey";
ALTER TABLE "cat_arc_class" DROP CONSTRAINT IF EXISTS  "cat_arc_class_catclass_id_fkey";

ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_sector_id_fkey";
ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_state_fkey";
ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_verified_fkey";
ALTER TABLE "vnode" DROP CONSTRAINT IF EXISTS "vnode_exploitation_id_fkey";

ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_state_fkey";
ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_exploitation_id_fkey";
ALTER TABLE "link" DROP CONSTRAINT IF EXISTS"link_feature_type_fkey";
ALTER TABLE "link" DROP CONSTRAINT IF EXISTS "link_exit_type_fkey";

ALTER TABLE "polygon" DROP CONSTRAINT IF EXISTS "polygon_sys_type_fkey";

ALTER TABLE "value_state_type" DROP CONSTRAINT IF EXISTS "value_state_type_state_fkey";



-- MAPZONES

ALTER TABLE "exploitation" DROP CONSTRAINT IF EXISTS "macroexpl_id_fkey";

ALTER TABLE "macrodma" DROP CONSTRAINT IF EXISTS "macrodma_expl_id_fkey";

ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_expl_id_fkey";
ALTER TABLE "dma" DROP CONSTRAINT IF EXISTS "dma_macrodma_id_fkey";

ALTER TABLE "sector" DROP CONSTRAINT IF EXISTS "sector_macrosector_id_fkey";


ALTER TABLE "exploitation_x_user" DROP CONSTRAINT IF EXISTS "exploitation_x_user_expl_id_fkey";
ALTER TABLE "exploitation_x_user" DROP CONSTRAINT IF EXISTS "exploitation_x_user_username_fkey";
ALTER TABLE "exploitation_x_user" DROP CONSTRAINT IF EXISTS "exploitation_x_user_expl_username_unique";

--ALTER TABLE "selector_expl" DROP CONSTRAINT IF EXISTS "selector_expl_username_id_fkey" ;


--ELEMENT
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_elementcat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_state_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_workcat_id_end_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_buildercat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_ownercat_id_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_verified_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_feature_type_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_state_type_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_function_type_feature_type_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_category_type_feature_type_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_fluid_type_feature_type_fkey";
ALTER TABLE "element" DROP CONSTRAINT IF EXISTS "element_location_type_feature_type_fkey";

ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_element_id_fkey";
ALTER TABLE "element_x_arc" DROP CONSTRAINT IF EXISTS "element_x_arc_arc_id_fkey";

ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_element_id_fkey";
ALTER TABLE "element_x_node" DROP CONSTRAINT IF EXISTS "element_x_node_node_id_fkey";

ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_element_id_fkey";
ALTER TABLE "element_x_connec" DROP CONSTRAINT IF EXISTS "element_x_connec_connec_id_fkey";

ALTER TABLE "man_addfields_value" DROP CONSTRAINT IF EXISTS "man_addfields_value_parameter_id_fkey";
ALTER TABLE "man_addfields_parameter" DROP CONSTRAINT IF EXISTS  "man_addfields_parameter_cat_feature_id_fkey";
ALTER TABLE "man_addfields_parameter" DROP CONSTRAINT IF EXISTS "man_addfields_parameter_widgettype_id_fkey";
ALTER TABLE "man_addfields_parameter" DROP CONSTRAINT IF EXISTS "man_addfields_parameter_datetype_id_fkey";
ALTER TABLE "man_addfields_cat_combo" DROP CONSTRAINT IF EXISTS "man_addfields_cat_combo_parameter_id_fkey";




--------
--ADD
--------




ALTER TABLE "cat_feature" ADD CONSTRAINT "cat_feature_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_feature" ADD CONSTRAINT "cat_feature_system_id_fkey" FOREIGN KEY ("system_id") REFERENCES "sys_feature_cat" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "arc_type" ADD CONSTRAINT "arc_type_epa_default_fkey" FOREIGN KEY ("epa_default") REFERENCES "inp_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc_type" ADD CONSTRAINT "arc_type_id_fkey" FOREIGN KEY ("id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc_type" ADD CONSTRAINT "arc_type_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node_type" ADD CONSTRAINT "node_type_epa_default_fkey" FOREIGN KEY ("epa_default") REFERENCES "inp_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node_type" ADD CONSTRAINT "node_type_id_fkey" FOREIGN KEY ("id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node_type" ADD CONSTRAINT "node_type_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec_type" ADD CONSTRAINT "connec_type_id_fkey" FOREIGN KEY ("id") REFERENCES "cat_feature" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec_type" ADD CONSTRAINT "connec_type_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sys_feature_cat" ADD CONSTRAINT "sys_feature_cat_type_fkey" FOREIGN KEY ("type") REFERENCES "sys_feature_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_elementtype_id_fkey" FOREIGN KEY ("elementtype_id") REFERENCES "element_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_matcat_id_fkey" FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_element" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_brand_fkey" FOREIGN KEY ("brand") REFERENCES "cat_brand" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_element" ADD CONSTRAINT "cat_element_model_fkey" FOREIGN KEY ("model") REFERENCES "cat_brand_model" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m3exc_cost_fkey" FOREIGN KEY ("m3exc_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m3fill_cost_fkey" FOREIGN KEY ("m3fill_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m3excess_cost_fkey" FOREIGN KEY ("m3excess_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "cat_soil" ADD CONSTRAINT "cat_soil_m2trenchl_cost_fkey" FOREIGN KEY ("m2trenchl_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

--ALTER TABLE "cat_work" ADD CONSTRAINT "cat_work_workid_key1_fkey" FOREIGN KEY ("workid_key1") REFERENCES "cat_work" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
--ALTER TABLE "cat_work" ADD CONSTRAINT "cat_work_workid_key2_fkey" FOREIGN KEY ("workid_key2") REFERENCES "cat_work" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_pavement" ADD CONSTRAINT "cat_pavement_m2_cost_fkey" FOREIGN KEY ("m2_cost") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_brand_model" ADD CONSTRAINT "cat_brand_model_catbrand_id_fkey" FOREIGN KEY ("catbrand_id") REFERENCES "cat_brand" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cat_arc_class_cat" ADD CONSTRAINT "cat_arc_class_class_type_fkey" FOREIGN KEY ("class_type") REFERENCES "cat_arc_class_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_arc_class" ADD CONSTRAINT "cat_arc_class_classtype_id_fkey" FOREIGN KEY ("class_type") REFERENCES "cat_arc_class_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc_class" ADD CONSTRAINT "cat_arc_class_catclass_id_fkey" FOREIGN KEY ("catclass_id") REFERENCES "cat_arc_class_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "value_state_type" ADD CONSTRAINT "value_state_type_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



-- MAPZONES
ALTER TABLE "exploitation" ADD CONSTRAINT "macroexpl_id_fkey" FOREIGN KEY ("macroexpl_id") REFERENCES "macroexploitation" ("macroexpl_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "macrodma" ADD CONSTRAINT "macrodma_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "dma" ADD CONSTRAINT "dma_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dma" ADD CONSTRAINT "dma_macrodma_id_fkey" FOREIGN KEY ("macrodma_id") REFERENCES "macrodma" ("macrodma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "sector" ADD CONSTRAINT "sector_macrosector_id_fkey" FOREIGN KEY ("macrosector_id") REFERENCES "macrosector" ("macrosector_id") ON DELETE RESTRICT ON UPDATE CASCADE;



--LINK +VNODE
ALTER TABLE "vnode" ADD CONSTRAINT "vnode_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "vnode" ADD CONSTRAINT "vnode_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "vnode" ADD CONSTRAINT "vnode_verified_fkey" FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "vnode" ADD CONSTRAINT "vnode_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "link" ADD CONSTRAINT "link_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "link" ADD CONSTRAINT "link_exploitation_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "link" ADD CONSTRAINT "link_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "link" ADD CONSTRAINT "link_exit_type_fkey" FOREIGN KEY ("exit_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE; 







ALTER TABLE "exploitation_x_user" ADD CONSTRAINT "exploitation_x_user_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "exploitation_x_user" ADD CONSTRAINT "exploitation_x_user_username_fkey" FOREIGN KEY ("username") REFERENCES "cat_users" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "exploitation_x_user" ADD CONSTRAINT "exploitation_x_user_expl_username_unique" UNIQUE (expl_id, username);

--ALTER TABLE "selector_expl" ADD CONSTRAINT selector_expl_username_id_fkey FOREIGN KEY (expl_id, cur_user) REFERENCES "exploitation_x_user" (expl_id, username) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE "polygon"  ADD CONSTRAINT  "polygon_sys_type_fkey" FOREIGN KEY ("sys_type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


--ELEMENT
ALTER TABLE "element" ADD CONSTRAINT "element_elementcat_id_fkey" FOREIGN KEY ("elementcat_id") REFERENCES "cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_state_fkey" FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_state_type_fkey" FOREIGN KEY ("state_type") REFERENCES "value_state_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_workcat_id_fkey" FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_workcat_id_end_fkey" FOREIGN KEY ("workcat_id_end") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_buildercat_id_fkey" FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_ownercat_id_fkey" FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_verified_fkey" FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_cat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT "element_function_type_feature_type_fkey" FOREIGN KEY ("function_type","feature_type") REFERENCES "man_type_function" ("function_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "element" ADD CONSTRAINT "element_category_type_feature_type_fkey" FOREIGN KEY ("category_type","feature_type") REFERENCES "man_type_category" ("category_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "element" ADD CONSTRAINT "element_fluid_type_feature_type_fkey" FOREIGN KEY ("fluid_type","feature_type") REFERENCES "man_type_fluid" ("fluid_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 
ALTER TABLE "element" ADD CONSTRAINT "element_location_type_feature_type_fkey" FOREIGN KEY ("location_type","feature_type") REFERENCES "man_type_location" ("location_type", "feature_type") ON DELETE RESTRICT ON UPDATE CASCADE; 

ALTER TABLE "element_x_arc" ADD CONSTRAINT "element_x_arc_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_arc" ADD CONSTRAINT "element_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_node" ADD CONSTRAINT "element_x_node_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_node" ADD CONSTRAINT "element_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_connec" ADD CONSTRAINT "element_x_connec_element_id_fkey" FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_connec" ADD CONSTRAINT "element_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;


--CUSTOM FIELDS

ALTER TABLE "man_addfields_parameter" ADD CONSTRAINT "man_addfields_parameter_cat_feature_id_fkey" FOREIGN KEY ("cat_feature_id") REFERENCES "cat_feature" ("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_addfields_parameter" ADD CONSTRAINT "man_addfields_parameter_widgettype_id_fkey" FOREIGN KEY ("widgettype_id") REFERENCES "man_addfields_cat_widgettype" ("id") ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "man_addfields_parameter" ADD CONSTRAINT "man_addfields_parameter_datetype_id_fkey" FOREIGN KEY ("datatype_id") REFERENCES "man_addfields_cat_datatype" ("id") ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE "man_addfields_value" ADD CONSTRAINT "man_addfields_value_parameter_id_fkey" FOREIGN KEY ("parameter_id") REFERENCES "man_addfields_parameter" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "man_addfields_cat_combo" ADD CONSTRAINT "man_addfields_cat_combo_parameter_id_fkey" FOREIGN KEY ("parameter_id") REFERENCES "man_addfields_parameter" ("id") ON UPDATE CASCADE ON DELETE RESTRICT;








