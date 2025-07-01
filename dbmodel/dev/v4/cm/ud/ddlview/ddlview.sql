/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW ve_lot_x_gully AS 
SELECT row_number() OVER (ORDER BY om_visit_lot_x_gully.lot_id, gully.gully_id) AS rid,
gully.gully_id,
lower(gully.feature_type::text) AS feature_type,
gully.code,
om_visit_lot.visitclass_id,
om_visit_lot_x_gully.lot_id,
om_visit_lot_x_gully.status,
om_typevalue.idval AS status_name,
om_visit_lot_x_gully.observ,
gully.the_geom
FROM selector_lot,
om_visit_lot
JOIN om_visit_lot_x_gully ON om_visit_lot_x_gully.lot_id = om_visit_lot.id
JOIN gully ON gully.gully_id::text = om_visit_lot_x_gully.gully_id::text
LEFT JOIN om_typevalue ON om_typevalue.id::integer = om_visit_lot_x_gully.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ve_lot_x_gully_web AS 
 SELECT row_number() OVER (ORDER BY gully.gully_id) AS rid,
    gully.gully_id,
    om_visit_lot_x_gully.lot_id,
    om_visit_lot_x_gully.status,
    gully.the_geom,
    'GULLY'::text AS sys_type,
    gully.code
   FROM om_visit_lot
     JOIN om_visit_lot_x_gully ON om_visit_lot_x_gully.lot_id = om_visit_lot.id
     JOIN gully ON gully.gully_id::text = om_visit_lot_x_gully.gully_id::text
     JOIN om_visit_lot_x_user ON om_visit_lot_x_user.lot_id = om_visit_lot_x_gully.lot_id
  WHERE om_visit_lot_x_user.endtime IS NULL;