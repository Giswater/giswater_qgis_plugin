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

INSERT INTO v_edit_review_arc (arc_id, arccat_id, annotation, observ, review_obs, expl_id, the_geom, field_date, field_checked, is_validated) 
VALUES('-901', '', '', '', '', 0, null, null, false, 0);
SELECT is((SELECT count(*)::integer FROM v_edit_review_arc WHERE review_arc_id = '-901'), 1, 'INSERT: v_edit_review_arc -901 was inserted');
SELECT is((SELECT count(*)::integer FROM review_arc WHERE review_arc_id = '-901'), 1, 'INSERT: review_arc -901 was inserted');


UPDATE v_edit_review_arc SET observ = 'updated observ' WHERE review_arc_id = '-901';
SELECT is((SELECT observ FROM v_edit_review_arc WHERE review_arc_id = '-901'), 'updated observ', 'UPDATE: v_edit_review_arc -901 was updated');
SELECT is((SELECT observ FROM review_arc WHERE review_arc_id = '-901', 'updated observ', 'UPDATE: review_arc -901 was updated');


DELETE FROM v_edit_review_arc WHERE review_arc_id = '-901';
SELECT is((SELECT count(*)::integer FROM v_edit_review_arc WHERE review_arc_id = '-901'), 0, 'DELETE: v_edit_review_arc -901 was deleted');
SELECT is((SELECT count(*)::integer FROM review_arc WHERE review_arc_id = '-901'), 0, 'DELETE: review_arc -901 was deleted');


SELECT * FROM finish();

ROLLBACK;