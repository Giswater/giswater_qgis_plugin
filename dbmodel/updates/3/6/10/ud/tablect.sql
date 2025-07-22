/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_flwreg_pump DROP CONSTRAINT inp_flwreg_pump_to_arc_fkey;

ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_to_arc_fkey FOREIGN KEY (to_arc) 
REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;

