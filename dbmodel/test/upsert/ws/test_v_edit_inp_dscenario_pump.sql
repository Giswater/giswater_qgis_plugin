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

INSERT INTO v_edit_inp_dscenario_pump (dscenario_id, node_id, power, curve_id, speed, pattern_id, status, effic_curve_id, energy_price, energy_pattern_id, the_geom)
VALUES(1, '1105', '-901', '', 0, '', '', '', 0, '', null);
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_pump WHERE power = '-901'), 1, 'INSERT: v_edit_inp_dscenario_pump -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_pump WHERE power = '-901'), 1, 'INSERT: inp_dscenario_pump -901 was inserted');

UPDATE v_edit_inp_dscenario_pump SET status = 'OPEN' WHERE power = '-901';
SELECT is((SELECT status FROM v_edit_inp_dscenario_pump WHERE power = '-901'), 'OPEN', 'UPDATE: v_edit_inp_dscenario_pump -901 was updated');
SELECT is((SELECT status FROM inp_dscenario_pump WHERE power = '-901'), 'OPEN', 'UPDATE: inp_dscenario_pump -901 was updated');

DELETE FROM v_edit_inp_dscenario_pump WHERE power = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_pump WHERE power = '-901'), 0, 'DELETE: v_edit_inp_dscenario_pump -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_pump WHERE power = '-901'), 0, 'DELETE: inp_dscenario_pump -901 was deleted');


SELECT * FROM finish();


ROLLBACK;