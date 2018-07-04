/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP

ALTER TABLE cat_feature ALTER COLUMN "system_id" DROP NOT NULL;
ALTER TABLE cat_feature ALTER COLUMN "feature_type" DROP NOT NULL;

ALTER TABLE arc_type ALTER COLUMN "type" DROP NOT NULL;
ALTER TABLE arc_type ALTER COLUMN epa_default DROP NOT NULL;
ALTER TABLE arc_type ALTER COLUMN man_table DROP NOT NULL;
ALTER TABLE arc_type ALTER COLUMN epa_table DROP NOT NULL;

ALTER TABLE node_type ALTER COLUMN "type" DROP NOT NULL;
ALTER TABLE node_type ALTER COLUMN epa_default DROP NOT NULL;
ALTER TABLE node_type ALTER COLUMN man_table DROP NOT NULL;
ALTER TABLE node_type ALTER COLUMN epa_table DROP NOT NULL;

ALTER TABLE connec_type ALTER COLUMN "type" DROP NOT NULL;
ALTER TABLE connec_type ALTER COLUMN man_table DROP NOT NULL;

ALTER TABLE sys_feature_cat ALTER COLUMN "type" DROP NOT NULL;

ALTER TABLE cat_element ALTER COLUMN "elementtype_id" DROP NOT NULL;

ALTER TABLE cat_brand_model ALTER COLUMN "catbrand_id" DROP NOT NULL;

ALTER TABLE vnode ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE vnode ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE vnode ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE vnode ALTER COLUMN "state" DROP NOT NULL;

ALTER TABLE link ALTER COLUMN expl_id DROP NOT NULL;
ALTER TABLE link ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE link ALTER COLUMN feature_type DROP NOT NULL;
ALTER TABLE link ALTER COLUMN exit_type DROP NOT NULL;

ALTER TABLE man_type_function ALTER COLUMN function_type DROP NOT NULL;
ALTER TABLE man_type_function ALTER COLUMN feature_type DROP NOT NULL;

ALTER TABLE man_type_category ALTER COLUMN category_type DROP NOT NULL;
ALTER TABLE man_type_category ALTER COLUMN feature_type DROP NOT NULL;

ALTER TABLE man_type_fluid ALTER COLUMN fluid_type DROP NOT NULL;
ALTER TABLE man_type_fluid ALTER COLUMN feature_type DROP NOT NULL;

ALTER TABLE man_type_location ALTER COLUMN location_type DROP NOT NULL;
ALTER TABLE man_type_location ALTER COLUMN feature_type DROP NOT NULL;

ALTER TABLE macroexploitation ALTER COLUMN name DROP NOT NULL;

ALTER TABLE macrosector ALTER COLUMN name DROP NOT NULL;

ALTER TABLE macrodma ALTER COLUMN name DROP NOT NULL;
ALTER TABLE macrodma ALTER COLUMN expl_id DROP NOT NULL;

ALTER TABLE exploitation ALTER COLUMN name DROP NOT NULL;
ALTER TABLE exploitation ALTER COLUMN macroexpl_id DROP NOT NULL;

ALTER TABLE sector ALTER COLUMN name DROP NOT NULL;

ALTER TABLE dma ALTER COLUMN name DROP NOT NULL;
ALTER TABLE dma ALTER COLUMN expl_id DROP NOT NULL;

ALTER TABLE element ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE element ALTER COLUMN elementcat_id DROP NOT NULL;

ALTER TABLE element_x_arc ALTER COLUMN element_id DROP NOT NULL;
ALTER TABLE element_x_arc ALTER COLUMN arc_id DROP NOT NULL;

ALTER TABLE element_x_node ALTER COLUMN element_id DROP NOT NULL;
ALTER TABLE element_x_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE element_x_connec ALTER COLUMN element_id DROP NOT NULL;
ALTER TABLE element_x_connec ALTER COLUMN connec_id DROP NOT NULL;

ALTER TABLE value_state ALTER COLUMN name DROP NOT NULL;

ALTER TABLE value_state_type ALTER COLUMN name DROP NOT NULL;
ALTER TABLE value_state_type ALTER COLUMN "state" DROP NOT NULL;

ALTER TABLE man_addfields_parameter ALTER COLUMN param_name DROP NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN is_mandatory DROP NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN datatype_id DROP NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN form_label DROP NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN widgettype_id DROP NOT NULL;

ALTER TABLE man_addfields_value ALTER COLUMN feature_id DROP NOT NULL;
ALTER TABLE man_addfields_value ALTER COLUMN parameter_id DROP NOT NULL;

--SET

ALTER TABLE arc_type ALTER COLUMN "type" SET NOT NULL;
ALTER TABLE arc_type ALTER COLUMN epa_default SET NOT NULL;
ALTER TABLE arc_type ALTER COLUMN man_table SET NOT NULL;
ALTER TABLE arc_type ALTER COLUMN epa_table SET NOT NULL;

ALTER TABLE node_type ALTER COLUMN "type" SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN epa_default SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN man_table SET NOT NULL;
ALTER TABLE node_type ALTER COLUMN epa_table SET NOT NULL;

ALTER TABLE connec_type ALTER COLUMN "type" SET NOT NULL;
ALTER TABLE connec_type ALTER COLUMN man_table SET NOT NULL;

ALTER TABLE vnode ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE vnode ALTER COLUMN dma_id SET NOT NULL;
ALTER TABLE vnode ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE vnode ALTER COLUMN "state" SET NOT NULL;

ALTER TABLE link ALTER COLUMN expl_id SET NOT NULL;
ALTER TABLE link ALTER COLUMN "state" SET NOT NULL;

ALTER TABLE man_type_function ALTER COLUMN function_type SET NOT NULL;
ALTER TABLE man_type_category ALTER COLUMN category_type SET NOT NULL;
ALTER TABLE man_type_fluid ALTER COLUMN fluid_type SET NOT NULL;
ALTER TABLE man_type_location ALTER COLUMN location_type SET NOT NULL;

ALTER TABLE macroexploitation ALTER COLUMN name SET NOT NULL;

ALTER TABLE exploitation ALTER COLUMN name SET NOT NULL;
ALTER TABLE exploitation ALTER COLUMN macroexpl_id SET NOT NULL;

ALTER TABLE macrosector ALTER COLUMN name SET NOT NULL;

ALTER TABLE sector ALTER COLUMN name SET NOT NULL;

ALTER TABLE macrodma ALTER COLUMN name SET NOT NULL;
ALTER TABLE macrodma ALTER COLUMN expl_id SET NOT NULL;



ALTER TABLE element ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE element ALTER COLUMN elementcat_id SET NOT NULL;

ALTER TABLE element_x_arc ALTER COLUMN element_id SET NOT NULL;
ALTER TABLE element_x_arc ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE element_x_node ALTER COLUMN element_id SET NOT NULL;
ALTER TABLE element_x_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE element_x_connec ALTER COLUMN element_id SET NOT NULL;
ALTER TABLE element_x_connec ALTER COLUMN connec_id SET NOT NULL;

ALTER TABLE value_state ALTER COLUMN name SET NOT NULL;

ALTER TABLE value_state_type ALTER COLUMN name SET NOT NULL;

ALTER TABLE man_addfields_parameter ALTER COLUMN param_name SET NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN is_mandatory SET NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN datatype_id SET NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN form_label SET NOT NULL;
ALTER TABLE man_addfields_parameter ALTER COLUMN widgettype_id SET NOT NULL;

ALTER TABLE man_addfields_value ALTER COLUMN feature_id SET NOT NULL;
ALTER TABLE man_addfields_value ALTER COLUMN parameter_id SET NOT NULL;


