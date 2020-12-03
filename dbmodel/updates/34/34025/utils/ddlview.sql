/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/25
DROP VIEW IF EXISTS v_edit_cad_auxcircle;
CREATE OR REPLACE VIEW v_edit_cad_auxcircle AS 
 SELECT temp_table.id,
    temp_table.geom_polygon
   FROM temp_table
  WHERE temp_table.cur_user = "current_user"()::text AND temp_table.fid = 361;


DROP VIEW IF EXISTS v_edit_cad_auxline;
CREATE OR REPLACE VIEW v_edit_cad_auxline AS 
 SELECT temp_table.id,
    temp_table.geom_line
   FROM temp_table
  WHERE temp_table.cur_user = "current_user"()::text AND temp_table.fid = 362;
  