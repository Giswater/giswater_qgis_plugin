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


INSERT INTO v_edit_inp_inflows (node_id, order_id, timser_id, sfactor, base, pattern_id)
VALUES('131', -901, 'T10-5m', 0, 0, 'pattern_11');


SELECT is((SELECT count(*)::integer FROM v_edit_inp_inflows WHERE order_id = -901), 1, 'INSERT: v_edit_inp_inflows -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_inflows WHERE order_id = -901), 1, 'INSERT: inp_inflows -901 was inserted');

UPDATE v_edit_inp_inflows SET pattern_id = 'pattern_12' WHERE order_id = -901;
SELECT is((SELECT pattern_id FROM v_edit_inp_inflows WHERE order_id = -901), 'pattern_12', 'UPDATE: v_edit_inp_inflows -901 was updated');
SELECT is((SELECT pattern_id FROM inp_inflows WHERE order_id = -901), 'pattern_12', 'UPDATE: inp_inflows -901 was updated');

DELETE FROM v_edit_inp_inflows WHERE order_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_inp_inflows WHERE order_id = -901), 0, 'DELETE: v_edit_inp_inflows -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_inflows WHERE order_id = -901), 0, 'DELETE: inp_inflows -901 was deleted');


SELECT * FROM finish();


ROLLBACK;