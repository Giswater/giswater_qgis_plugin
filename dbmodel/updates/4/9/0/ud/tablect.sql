/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/



CREATE TRIGGER gw_trg_fk_array_array_table_expl AFTER INSERT OR UPDATE ON gully
FOR EACH ROW EXECUTE FUNCTION gw_trg_array_fk_array_table('expl_visibility', 'exploitation', 'expl_id');
