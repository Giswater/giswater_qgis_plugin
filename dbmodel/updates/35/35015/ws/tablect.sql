/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/14
ALTER TABLE selector_inp_dscenario DROP CONSTRAINT inp_selector_dscenario_dscenario_id_fkey;

ALTER TABLE selector_inp_dscenario
ADD CONSTRAINT inp_selector_dscenario_dscenario_id_fkey FOREIGN KEY (dscenario_id)
REFERENCES cat_dscenario (dscenario_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;