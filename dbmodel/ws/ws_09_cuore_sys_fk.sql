/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
------
-- FK 00
------

ALTER TABLE "ext_streetaxis" ADD FOREIGN KEY ("type") REFERENCES "ext_type_street" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_urban_propierties" ADD FOREIGN KEY ("streetaxis") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



ALTER TABLE "ext_rtc_scada" ADD FOREIGN KEY ("cat_scada_id") REFERENCES "ext_cat_scada" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_scada_x_value" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_scada_x_data" ADD FOREIGN KEY ("scada_id") REFERENCES "ext_rtc_scada" ("scada_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ext_rtc_scada_x_data" ADD FOREIGN KEY ("cat_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "ext_cat_hydrometer" ADD FOREIGN KEY ("hydrometer_type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer" ADD FOREIGN KEY ("cat_hydrometer_id") REFERENCES "ext_cat_hydrometer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer_x_value" ADD FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "ext_rtc_hydrometer_x_data" ADD FOREIGN KEY ("hydrometer_id") REFERENCES "ext_rtc_hydrometer" ("hydrometer_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ext_rtc_hydrometer_x_data" ADD FOREIGN KEY ("cat_period_id") REFERENCES "ext_cat_period" ("id") ON DELETE CASCADE ON UPDATE CASCADE;




------
-- FK 01
------


ALTER TABLE "cat_arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_arc" ADD FOREIGN KEY ("arctype_id") REFERENCES "arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_node" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_node" ADD FOREIGN KEY ("nodetype_id") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("node_type") REFERENCES "node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD FOREIGN KEY ("nodecat_id") REFERENCES "cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "node" ADD FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "arc" ADD FOREIGN KEY ("arccat_id") REFERENCES "cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("node_1") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("node_2") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "cat_element" ADD FOREIGN KEY ("elementtype_id") REFERENCES "element_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_element" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "cat_connec" ADD FOREIGN KEY ("matcat_id") REFERENCES "cat_mat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "cat_connec" ADD FOREIGN KEY ("type") REFERENCES "connec_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" ADD FOREIGN KEY ("connecat_id") REFERENCES "cat_connec" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "dma" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "dma" ADD FOREIGN KEY ("presszonecat_id") REFERENCES "cat_press_zone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "link" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "link" ADD FOREIGN KEY ("vnode_id") REFERENCES "vnode" ("vnode_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "vnode" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "vnode" ADD FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("dma_id") REFERENCES "dma" ("dma_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("soilcat_id") REFERENCES "cat_soil" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("category_type") REFERENCES "man_type_category" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("fluid_type") REFERENCES "man_type_fluid" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "node" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "arc" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "connec" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "connec" ADD FOREIGN KEY ("streetaxis_id") REFERENCES "ext_streetaxis" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "vnode" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_junction" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_tank" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_hydrant" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_valve" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_pump" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_meter" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "man_filter" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "man_pipe" ADD FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element" ADD FOREIGN KEY ("elementcat_id") REFERENCES "cat_element" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD FOREIGN KEY ("state") REFERENCES "value_state" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD FOREIGN KEY ("location_type") REFERENCES "man_type_location" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD FOREIGN KEY ("workcat_id") REFERENCES "cat_work" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD FOREIGN KEY ("buildercat_id") REFERENCES "cat_builder" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD FOREIGN KEY ("ownercat_id") REFERENCES "cat_owner" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD FOREIGN KEY ("verified") REFERENCES "value_verified" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "element_x_node" ADD FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_node" ADD FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "element_x_connec" ADD FOREIGN KEY ("element_id") REFERENCES "element" ("element_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "element_x_connec" ADD FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "point" ADD FOREIGN KEY ("point_type") REFERENCES "point_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "presszone" ADD FOREIGN KEY ("presszonecat_id") REFERENCES "cat_press_zone" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;



