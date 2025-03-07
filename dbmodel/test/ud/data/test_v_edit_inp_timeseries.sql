/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

INSERT INTO v_edit_inp_timeseries (id, timser_type, times_type, descript, fname, expl_id, log, active)
VALUES('-901', 'Rainfall', 'RELATIVE', NULL, NULL, 1, NULL, true);



SELECT is((SELECT count(*)::integer FROM v_edit_inp_timeseries WHERE id = '-901'), 1, 'INSERT: v_edit_inp_timeseries -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_timeseries WHERE id = '-901'), 1, 'INSERT: inp_timeseries -901 was inserted');

UPDATE v_edit_inp_timeseries SET descript = 'updated descript' WHERE id = '-901';
SELECT is((SELECT descript FROM v_edit_inp_timeseries WHERE id = '-901'), 'updated descript', 'UPDATE: v_edit_inp_timeseries -901 was updated');
SELECT is((SELECT descript FROM inp_timeseries WHERE id = '-901'), 'updated descript', 'UPDATE: inp_timeseries -901 was updated');

DELETE FROM v_edit_inp_timeseries WHERE id = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_inp_timeseries WHERE id = '-901'), 0, 'DELETE: v_edit_inp_timeseries -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_timeseries WHERE id = '-901'), 0, 'DELETE: inp_timeseries -901 was deleted');


SELECT * FROM finish();


ROLLBACK;