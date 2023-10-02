/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_transects AS
 SELECT inp_transects_value.text
   FROM selector_sector s,
    inp_transects t
     JOIN inp_transects_value ON tsect_id=t.id
  WHERE (t.sector_id = s.sector_id AND s.cur_user = "current_user"()::text) OR t.sector_id IS NULL
  ORDER BY t.id;


CREATE OR REPLACE VIEW v_edit_inp_transects AS
 SELECT DISTINCT t.id,
    t.tsect_id,
    c.sector_id,
    t.text
   FROM selector_sector,
    inp_transects c
JOIN inp_transects_value t on t.tsect_id = c.id
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
  
  
  CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
   FROM node
     JOIN v_state_node USING (node_id)
     JOIN v_expl_node USING (node_id)
     JOIN polygon ON polygon.feature_id::text = node.node_id::text;