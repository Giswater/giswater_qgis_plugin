/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_inp_dscenario_frpump;

CREATE OR REPLACE VIEW ve_inp_dscenario_frpump
AS SELECT s.dscenario_id,
    f.element_id,
    n.node_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frpump f
    JOIN ve_inp_frpump n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;
