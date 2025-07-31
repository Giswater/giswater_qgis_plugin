/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE element DROP CONSTRAINT IF EXISTS element_epa_type_check;
ALTER TABLE "element" ADD CONSTRAINT element_epa_type_check CHECK (((epa_type)::text = ANY (ARRAY['FRPUMP'::text, 'FRVALVE'::text, 'UNDEFINED'::text])));

-- 31/07/2025
ALTER TABLE "element" ADD CONSTRAINT element_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id);
ALTER TABLE man_frelem ADD CONSTRAINT man_frelem_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id);