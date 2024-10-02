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

-- funciona el insert pero no aparece nada en la tabla
INSERT INTO v_edit_dimensions (id, distance, "depth", the_geom, x_label, y_label, rotation_label, offset_label, direction_arrow, x_symbol, y_symbol, feature_id, feature_type, state, expl_id, observ, "comment", sector_id, muni_id)
VALUES(-901, 0, 0, NULL, 0, 0, 0, 0, false, 0, 0, '', 'ARC', 0, 0, '', '', 0, 0);
SELECT is((SELECT count(*)::integer FROM v_edit_dimensions WHERE id = -901), 1, 'INSERT: v_edit_dimensions -901 was inserted');
SELECT is((SELECT count(*)::integer FROM dimensions WHERE id = -901), 1, 'INSERT: dimensions -901 was inserted');

UPDATE v_edit_dimensions SET feature_type = 'updated feature_type' WHERE id = -901;
SELECT is((SELECT feature_type FROM v_edit_dimensions WHERE id = -901), 'updated feature_type', 'UPDATE: v_edit_dimensions -901 was updated');
SELECT is((SELECT feature_type FROM dimensions WHERE id = -901), 'updated feature_type', 'UPDATE: dimensions -901 was updated');

DELETE FROM v_edit_dimensions WHERE id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_dimensions WHERE id = -901), 0, 'DELETE: v_edit_dimensions -901 was deleted');
SELECT is((SELECT count(*)::integer FROM dimensions WHERE id = -901), 0, 'DELETE: dimensions -901 was deleted');

SELECT * FROM finish();

ROLLBACK;