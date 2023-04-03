/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TRIGGER gw_trg_link_data AFTER INSERT OR UPDATE OF expl_id2
ON gully FOR EACH ROW EXECUTE FUNCTION gw_trg_link_data('gully');