/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
 CREATE VIEW v_edit_cat_dscenario AS
 SELECT DISTINCT ON (dscenario_id)
  dscenario_id,
  c.name,
  c.descript,
  dscenario_type,
  parent_id,
  c.expl_id,
  c.active,
  c.log
  FROM cat_dscenario c, selector_expl s
  WHERE (s.expl_id = c.expl_id AND cur_user = current_user)
  OR c.expl_id is null;