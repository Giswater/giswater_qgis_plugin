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


CREATE OR REPLACE VIEW v_edit_inp_dscenario_controls AS 
SELECT id,
d.dscenario_id,
i.sector_id,
i.text,
i.active
FROM selector_inp_dscenario, inp_dscenario_controls i 
JOIN cat_dscenario d USING (dscenario_id)
WHERE i.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


 CREATE OR REPLACE VIEW v_anl_grafanalytics_mapzones AS 
 SELECT temp_anlgraf.arc_id,
    temp_anlgraf.node_1,
    temp_anlgraf.node_2,
    temp_anlgraf.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraf
     JOIN ( SELECT temp_anlgraf_1.arc_id,
            temp_anlgraf_1.node_1,
            temp_anlgraf_1.node_2,
            temp_anlgraf_1.water,
            temp_anlgraf_1.flag,
            temp_anlgraf_1.checkf,
            temp_anlgraf_1.value,
	    temp_anlgraf_1.trace
           FROM temp_anlgraf temp_anlgraf_1
          WHERE temp_anlgraf_1.water = 1) a2 ON temp_anlgraf.node_1::text = a2.node_2::text
  WHERE temp_anlgraf.flag < 2 AND temp_anlgraf.water = 0 AND a2.flag = 0;