/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 31/12/2024
 CREATE TRIGGER gw_trg_exploitation AFTER INSERT OR UPDATE of active OR DELETE on exploitation 
 FOR EACH ROW EXECUTE FUNCTION gw_trg_exploitation();


