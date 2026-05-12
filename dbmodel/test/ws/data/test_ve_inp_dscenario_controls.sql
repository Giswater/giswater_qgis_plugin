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

INSERT INTO ve_inp_dscenario_controls (dscenario_id, sector_id,"text")
VALUES(1, 0,'-901');
SELECT is((SELECT count(*)::integer FROM ve_inp_dscenario_controls WHERE "text" = '-901'), 1, 'INSERT: ve_inp_dscenario_controls -901 was inserted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_controls WHERE "text" = '-901'), 1, 'INSERT: inp_dscenario_controls -901 was inserted');

UPDATE ve_inp_dscenario_controls SET active = true WHERE "text" = '-901';
SELECT is((SELECT active FROM ve_inp_dscenario_controls WHERE "text" = '-901'), true, 'UPDATE: ve_inp_dscenario_controls -901 was updated');
SELECT is((SELECT active FROM inp_dscenario_controls WHERE "text" = '-901'), true, 'UPDATE: inp_dscenario_controls -901 was updated');

DELETE FROM ve_inp_dscenario_controls WHERE "text" = '-901';
SELECT is((SELECT count(*)::integer FROM ve_inp_dscenario_controls WHERE "text" = '-901'), 0, 'DELETE: ve_inp_dscenario_controls -901 was deleted');
SELECT is((SELECT count(*)::integer FROM inp_dscenario_controls WHERE "text" = '-901'), 0, 'DELETE: inp_dscenario_controls -901 was deleted');


SELECT * FROM finish();


ROLLBACK;