/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_dimensions AS 
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
    dimensions.expl_id,
    dimensions.observ,
    dimensions.comment,
    dimensions.sector_id,
    dimensions.muni_id
   FROM selector_expl,
    dimensions
     JOIN v_state_dimensions ON dimensions.id = v_state_dimensions.id
     LEFT JOIN selector_municipality m USING (muni_id)
     JOIN selector_sector s USING (sector_id)
  WHERE (m.cur_user = CURRENT_USER::text OR dimensions.muni_id IS NULL) 
  AND s.cur_user = CURRENT_USER::text AND dimensions.expl_id = selector_expl.expl_id 
  AND selector_expl.cur_user = "current_user"()::text;