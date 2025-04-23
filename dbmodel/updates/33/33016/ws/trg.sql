/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--23/11/2019
DROP TRIGGER IF EXISTS gw_trg_edit_inp_arc_virtualvalve ON v_edit_inp_virtualvalve;
CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_virtualvalve  
FOR EACH ROW  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_virtualvalve');

  