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

INSERT INTO ve_inp_dscenario_shortpipe (dscenario_id, node_id, minorloss, status, bulk_coeff, wall_coeff, the_geom)
VALUES(1, '1088', -901, '', 0, 0, null);
SELECT is((SELECT count(*)::integer FROM ve_inp_dscenario_shortpipe WHERE minorloss = -901), 1, 'INSERT: ve_inp_dscenario_shortpipe -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_shortpipe WHERE minorloss = -901), 1, 'INSERT: inp_dscenario_shortpipe -901 was inserted');

UPDATE ve_inp_dscenario_shortpipe SET status = 'OPEN' WHERE minorloss = -901;
SELECT is((SELECT status FROM ve_inp_dscenario_shortpipe WHERE minorloss = -901), 'OPEN', 'UPDATE: ve_inp_dscenario_shortpipe -901 was updated');
SELECT is((SELECT status FROM inp_dscenario_shortpipe WHERE minorloss = -901), 'OPEN', 'UPDATE: inp_dscenario_shortpipe -901 was updated');

DELETE FROM ve_inp_dscenario_shortpipe WHERE minorloss = -901;
SELECT is((SELECT count(*)::integer FROM ve_inp_dscenario_shortpipe WHERE minorloss = -901), 0, 'DELETE: ve_inp_dscenario_shortpipe -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_shortpipe WHERE minorloss = -901), 0, 'DELETE: inp_dscenario_shortpipe -901 was deleted');


SELECT * FROM finish();


ROLLBACK;