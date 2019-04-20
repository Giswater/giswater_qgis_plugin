/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/04/20
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_dwfscenario_id_fkey FOREIGN KEY (dwfscenario_id) REFERENCES cat_dwf_scenario (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_dwfscenario_id_fkey FOREIGN KEY (dwfscenario_id) REFERENCES cat_dwf_scenario (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_dwf_pol_x_node DROP CONSTRAINT inp_dwf_pol_x_node_pkey;

ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_pkey PRIMARY KEY(poll_id, node_id, dwfscenario_id);
