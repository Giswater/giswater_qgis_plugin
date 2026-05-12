/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE inp_frpump DROP CONSTRAINT IF EXISTS inp_frpump_element_id_fkey;
ALTER TABLE inp_frshortpipe DROP CONSTRAINT IF EXISTS inp_frshortpipe_fk_element_id;
ALTER TABLE inp_frvalve DROP CONSTRAINT IF EXISTS inp_frvalve_node_id_fkey;

ALTER TABLE inp_frpump ADD CONSTRAINT inp_frpump_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_frshortpipe ADD CONSTRAINT inp_frshortpipe_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_frvalve ADD CONSTRAINT inp_frvalve_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
