/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: XXXX


DROP TRIGGER IF EXISTS gw_trg_update_link_arc_id ON "SCHEMA_NAME".gully;
CREATE TRIGGER gw_trg_update_link_arc_id AFTER UPDATE OF arc_id ON "SCHEMA_NAME".gully
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_update_link_arc_id(gully);
