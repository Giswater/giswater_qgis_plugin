/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO v_edit_inp_dscenario_reservoir (dscenario_id, node_id, pattern_id, head, init_quality, source_type, source_quality, source_pattern_id, the_geom)
VALUES(1, '1097', 'PTN-HYDRANT', -901, 0, '', 0, '', null);
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_reservoir WHERE head = -901), 1, 'INSERT: v_edit_inp_dscenario_reservoir -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_reservoir WHERE head = -901), 1, 'INSERT: inp_dscenario_reservoir -901 was inserted');

UPDATE v_edit_inp_dscenario_reservoir SET source_pattern_id = 'updated source' WHERE head = -901;
SELECT is((SELECT source_pattern_id FROM v_edit_inp_dscenario_reservoir WHERE head = -901), 'updated source', 'UPDATE: v_edit_inp_dscenario_reservoir -901 was updated');
SELECT is((SELECT source_pattern_id FROM inp_dscenario_reservoir WHERE head = -901), 'updated source', 'UPDATE: inp_dscenario_reservoir -901 was updated');

DELETE FROM v_edit_inp_dscenario_reservoir WHERE head = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_reservoir WHERE head = -901), 0, 'DELETE: v_edit_inp_dscenario_reservoir -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_reservoir WHERE head = -901), 0, 'DELETE: inp_dscenario_reservoir -901 was deleted');


SELECT * FROM finish();


ROLLBACK;