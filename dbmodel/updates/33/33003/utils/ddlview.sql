/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 08/10/2019

CREATE OR REPLACE VIEW v_edit_exploitation AS
SELECT    exploitation.expl_id, 
    name, 
    macroexpl_id, 
    descript, 
    undelete, 
    the_geom, 
    tstamp
    FROM selector_expl, exploitation
      WHERE exploitation.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
