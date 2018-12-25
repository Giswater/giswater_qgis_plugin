/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP TRIGGER IF EXISTS gw_trg_edit_ve_pipe ON "SCHEMA_NAME".ve_arc_pipe;
CREATE TRIGGER gw_trg_edit_ve_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".ve_arc_pipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_ve_arc('PIPE');    
  