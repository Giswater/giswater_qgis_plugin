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

INSERT INTO v_edit_minsector 
(minsector_id, code, dma_id, dqa_id, presszone_id, expl_id, num_border, num_connec, num_hydro, length, descript, addparam, the_geom) 
VALUES(-901, '', 0, 0, '1', 0, 0, 0, 0, 0, '', null, null);
SELECT is((SELECT count(*)::integer FROM v_edit_minsector WHERE minsector_id = -901), 1, 'INSERT: v_edit_minsector -901 was inserted');
SELECT is((SELECT count(*)::integer FROM minsector WHERE minsector_id = -901), 1, 'INSERT: minsector -901 was inserted');


UPDATE v_edit_minsector SET code = 'updated code' WHERE minsector_id = -901;
SELECT is((SELECT code FROM v_edit_minsector WHERE minsector_id = -901), 'updated code', 'UPDATE: v_edit_minsector -901 was updated');
SELECT is((SELECT code FROM minsector WHERE minsector_id = -901), 'updated code', 'UPDATE: minsector -901 was updated');


DELETE FROM v_edit_minsector WHERE minsector_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_minsector WHERE minsector_id = -901), 0, 'DELETE: v_edit_minsector -901 was deleted');
SELECT is((SELECT count(*)::integer FROM minsector WHERE minsector_id = -901), 0, 'DELETE: minsector -901 was deleted');


SELECT * FROM finish();

ROLLBACK;