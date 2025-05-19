/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_arc_node_values
    AFTER INSERT OR UPDATE OF node_1, node_2
    ON arc
    FOR EACH ROW
    EXECUTE FUNCTION gw_trg_arc_node_values();