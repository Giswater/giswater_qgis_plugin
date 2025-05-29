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

INSERT INTO v_edit_review_node (node_id, top_elev, "depth", nodecat_id, annotation, observ, review_obs, expl_id, the_geom, field_date, field_checked, is_validated)
VALUES(-901, 0, 0, '', '', '', '', 0,null, null, false, 0);
SELECT is((SELECT count(*)::integer FROM v_edit_review_node WHERE node_id = -901), 1, 'INSERT: v_edit_review_node -901 was inserted');
SELECT is((SELECT count(*)::integer FROM review_node WHERE node_id = -901), 1, 'INSERT: review_node -901 was inserted');


UPDATE v_edit_review_node SET annotation = 'updated annotation' WHERE node_id = -901;
SELECT is((SELECT annotation FROM v_edit_review_node WHERE node_id = -901), 'updated annotation', 'UPDATE: v_edit_review_node -901 was updated');
SELECT is((SELECT annotation FROM review_node WHERE node_id = -901), 'updated annotation', 'UPDATE: review_node -901 was updated');


DELETE FROM v_edit_review_node WHERE node_id = -901;
SELECT is((SELECT count(*)::integer FROM v_edit_review_node WHERE node_id = -901), 0, 'DELETE: v_edit_review_node -901 was deleted');
SELECT is((SELECT count(*)::integer FROM review_node WHERE node_id = -901), 0, 'DELETE: review_node -901 was deleted');


SELECT * FROM finish();

ROLLBACK;