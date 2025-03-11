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

INSERT INTO v_edit_inp_dscenario_valve (dscenario_id, node_id, nodarc_id, valv_type, setting, curve_id, minorloss, status, add_settings, init_quality, the_geom)
VALUES(1, '1083', '1083_n2a', 'PRV', -901, NULL, 0.0000, 'ACTIVE', 0.0, 0.0, 'SRID=25831;POINT (419524.43246714014 4576488.44256104)'::public.geometry);
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_valve WHERE setting = -901), 1, 'INSERT: v_edit_inp_dscenario_valve -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_valve WHERE setting = -901), 1, 'INSERT: inp_dscenario_valve -901 was inserted');

UPDATE v_edit_inp_dscenario_valve SET status = 'ACTIVE' WHERE setting = -901;
SELECT is((SELECT status FROM v_edit_inp_dscenario_valve WHERE setting = -901), 'ACTIVE', 'UPDATE: v_edit_inp_dscenario_valve -901 was updated');
SELECT is((SELECT status FROM inp_dscenario_valve WHERE setting = -901), 'ACTIVE', 'UPDATE: inp_dscenario_valve -901 was updated');

DELETE FROM v_edit_inp_dscenario_valve WHERE setting = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_inp_dscenario_valve WHERE setting = -901), 0, 'DELETE: v_edit_inp_dscenario_valve -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_valve WHERE setting = -901), 0, 'DELETE: inp_dscenario_valve -901 was deleted');


SELECT * FROM finish();


ROLLBACK;