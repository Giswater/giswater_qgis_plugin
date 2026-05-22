/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 21/05/2026
CREATE OR REPLACE VIEW ve_omunit
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT DISTINCT ON (omunit_id) omunit_id,
    node_1,
    node_2,
    macroomunit_id,
    order_number,
    expl_id,
    muni_id,
    sector_id,
    the_geom
   FROM omunit o
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = ANY (o.expl_id))) AND omunit_id > 0
  ORDER BY omunit_id;

CREATE OR REPLACE VIEW ve_macroomunit
AS WITH sel_expl AS (
         SELECT selector_expl.expl_id
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        )
 SELECT DISTINCT ON (macroomunit_id) macroomunit_id,
    node_1,
    node_2,
    catchment_node,
    order_number,
    expl_id,
    muni_id,
    sector_id,
    the_geom
   FROM macroomunit m
  WHERE (EXISTS ( SELECT 1
           FROM sel_expl
          WHERE sel_expl.expl_id = ANY (m.expl_id))) AND macroomunit_id > 0
  ORDER BY macroomunit_id;
