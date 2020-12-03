/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_controls_x_arc DROP CONSTRAINT IF EXISTS inp_controls_x_arc_id_fkey;
ALTER TABLE inp_controls_x_node DROP CONSTRAINT IF EXISTS inp_controls_x_node_id_fkey;

ALTER TABLE sys_csv2pg_cat ALTER COLUMN readheader SET DEFAULT true;

ALTER TABLE price_compost DROP CONSTRAINT IF EXISTS price_compost_pricecat_id_fkey;
ALTER TABLE price_compost ADD CONSTRAINT price_compost_pricecat_id_fkey FOREIGN KEY (pricecat_id)
REFERENCES price_cat_simple (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE audit_price_simple DROP CONSTRAINT IF EXISTS  audit_price_simple_pkey;
ALTER TABLE audit_price_simple ADD CONSTRAINT audit_price_simple_pkey PRIMARY KEY (id, pricecat_id);

ALTER TABLE price_compost_value DROP CONSTRAINT IF EXISTS  price_compost_value_simple_id_fkey;
ALTER TABLE price_compost_value ADD CONSTRAINT price_compost_value_compost_id_fkey2 FOREIGN KEY (simple_id)
REFERENCES price_compost (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE connec ADD CONSTRAINT connec_pjoint_type_ckeck 
CHECK (pjoint_type::text = ANY (ARRAY['NODE'::character varying, 'VNODE'::character varying]::text[]));

