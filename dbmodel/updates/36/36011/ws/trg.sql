/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER gw_trg_link_data ON connec;
CREATE TRIGGER gw_trg_link_data
AFTER UPDATE OF epa_type, state_type, expl_id2, connecat_id, fluid_type
ON connec FOR EACH ROW EXECUTE PROCEDURE gw_trg_link_data('connec');