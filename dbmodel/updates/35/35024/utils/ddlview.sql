/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
DROP VIEW v_edit_inp_curve_value;
CREATE OR REPLACE VIEW v_edit_inp_curve_value AS 
SELECT DISTINCT cv.id,
cv.curve_id,
cv.x_value,
cv.y_value
FROM selector_expl s,
inp_curve c
JOIN inp_curve_value cv ON c.id::text = cv.curve_id::text
WHERE c.expl_id = s.expl_id AND s.cur_user = "current_user"()::text OR c.expl_id IS NULL
ORDER BY cv.id;

