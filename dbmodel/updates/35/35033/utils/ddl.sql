/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"parent_id", "dataType":"character varying(16)"}}$$);

CREATE TABLE arc_border_expl (
  arc_id varchar(16),
  expl_id int4,
  CONSTRAINT arc_border_expl_pkey PRIMARY KEY (arc_id, expl_id)
);

ALTER TABLE arc_border_expl ADD CONSTRAINT arc_border_expl_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc_border_expl ADD CONSTRAINT arc_border_expl_arc_id_fkey FOREIGN KEY (arc_id)
REFERENCES arc (arc_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

