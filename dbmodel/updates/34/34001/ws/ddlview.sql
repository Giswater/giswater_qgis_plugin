/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/06
CREATE OR REPLACE VIEW v_minsector AS 
 SELECT minsector.minsector_id,
    minsector.dma_id,
    minsector.dqa_id,
    minsector.presszonecat_id,
    minsector.sector_id,
    minsector.expl_id,
    minsector.the_geom
   FROM selector_expl, minsector
  WHERE minsector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
