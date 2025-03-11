/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO v_edit_inp_dscenario_pipe (dscenario_id, arc_id, minorloss, status, roughness, dint, bulk_coeff, wall_coeff, the_geom)
VALUES(1, '2012', -901, '', 0, 0, 0, 0, null);
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_pipe WHERE minorloss = -901), 1, 'INSERT: v_edit_inp_dscenario_pipe -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_pipe WHERE minorloss = -901), 1, 'INSERT: inp_dscenario_pipe -901 was inserted');

UPDATE v_edit_inp_dscenario_pipe SET status = 'OPEN' WHERE minorloss = -901;
SELECT is((SELECT status FROM v_edit_inp_dscenario_pipe WHERE minorloss = -901), 'OPEN', 'UPDATE: v_edit_inp_dscenario_pipe -901 was updated');
SELECT is((SELECT status FROM inp_dscenario_pipe WHERE minorloss = -901), 'OPEN', 'UPDATE: inp_dscenario_pipe -901 was updated');

DELETE FROM v_edit_inp_dscenario_pipe WHERE minorloss = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_pipe WHERE minorloss = -901), 0, 'DELETE: v_edit_inp_dscenario_pipe -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_pipe WHERE minorloss = -901), 0, 'DELETE: inp_dscenario_pipe -901 was deleted');


SELECT * FROM finish();


ROLLBACK;