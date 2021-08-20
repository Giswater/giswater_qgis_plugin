/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/08/19
CREATE OR REPLACE VIEW vi_lid_controls AS 
SELECT inp_lid_control.lidco_id,
inp_typevalue.id AS lidco_type,
inp_lid_control.value_2 AS other1,
inp_lid_control.value_3 AS other2,
inp_lid_control.value_4 AS other3,
inp_lid_control.value_5 AS other4,
inp_lid_control.value_6 AS other5,
inp_lid_control.value_7 AS other6,
inp_lid_control.value_8 AS other7
FROM inp_lid_control
LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_lid_control.lidco_type::text
WHERE inp_typevalue.typevalue::text = 'inp_value_lidcontrol'::text
ORDER BY inp_lid_control.id;