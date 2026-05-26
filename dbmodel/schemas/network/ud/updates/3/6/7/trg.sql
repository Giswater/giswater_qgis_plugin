/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_edit_inp_subc2outlet instead of insert or delete or Update 
on v_edit_inp_subc2outlet for each row execute function gw_trg_edit_inp_subc2outlet();