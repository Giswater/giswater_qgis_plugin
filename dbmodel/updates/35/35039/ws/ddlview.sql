/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

DROP view v_edit_inp_dscenario_demand;
CREATE OR REPLACE VIEW v_edit_inp_dscenario_demand AS 
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    node.sector_id,
    node.expl_id, 
    node.presszone_id, 
    node.dma_id,
    node.the_geom
   FROM inp_dscenario_demand
   JOIN node ON node.node_id::text = inp_dscenario_demand.feature_id::text
   JOIN selector_sector s ON s.sector_id = node.sector_id
   JOIN selector_inp_dscenario d USING (dscenario_id)
   WHERE s.cur_user = current_user AND d.cur_user = current_user
UNION
 SELECT inp_dscenario_demand.id,
    inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source,
    connec.sector_id,
    connec.expl_id, 
    connec.presszone_id, 
    connec.dma_id,
    connec.the_geom
   FROM inp_dscenario_demand
   JOIN connec ON connec.connec_id::text = inp_dscenario_demand.feature_id::text
   JOIN selector_sector s ON s.sector_id = connec.sector_id
   JOIN selector_inp_dscenario d USING (dscenario_id)
   WHERE s.cur_user = current_user AND d.cur_user = current_user;
   