 /*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
 


--2019/30/03
DROP VIEW IF EXISTS v_edit_dma;
CREATE OR REPLACE VIEW v_edit_dma AS 
 SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
	dma.pattern_id,
	dma.link
   FROM selector_expl, dma  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
