/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/10
ALTER TABLE inp_pump DROP CONSTRAINT IF EXISTS inp_pump_curve_id_fkey;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id) 
REFERENCES inp_curve (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;