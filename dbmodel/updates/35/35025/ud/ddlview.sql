/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/05/30
CREATE OR REPLACE VIEW vi_lid_controls AS 
 SELECT a.lidco_id,
    a.lidco_type,
    a.other1,
    a.other2,
    a.other3,
    a.other4,
    a.other5,
    a.other6,
    a.other7
   FROM ( SELECT 0 AS id,
            inp_lid.lidco_id,
            inp_lid.lidco_type,
            NULL::numeric AS other1,
            NULL::numeric AS other2,
            NULL::numeric AS other3,
            NULL::numeric AS other4,
            NULL::numeric AS other5,
            NULL::numeric AS other6,
            NULL::text AS other7
           FROM inp_lid
        UNION
         SELECT inp_lid_value.id,
            inp_lid_value.lidco_id,
            inp_typevalue.idval AS lidco_type,
            inp_lid_value.value_2 AS other1,
            inp_lid_value.value_3 AS other2,
            inp_lid_value.value_4 AS other3,
            inp_lid_value.value_5 AS other4,
            inp_lid_value.value_6 AS other5,
            inp_lid_value.value_7 AS other6,
            inp_lid_value.value_8 AS other7
           FROM inp_lid_value
             LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_lid_value.lidlayer::text
          WHERE inp_typevalue.typevalue::text = 'inp_value_lidlayer'::text) a
  ORDER BY a.lidco_id, a.id;