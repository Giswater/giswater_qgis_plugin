/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;
SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(10);

-- NODE TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT node_id, COUNT(*) as cnt
        FROM v_edit_node
        GROUP BY node_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate node_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT node_id, COUNT(*)
        FROM v_edit_node
        GROUP BY node_id
        HAVING COUNT(*) > 1
    ),
    'Each node_id should be unique in v_edit_node'
);

-- ARC TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT arc_id, COUNT(*) as cnt
        FROM v_edit_arc
        GROUP BY arc_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate arc_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT arc_id, COUNT(*)
        FROM v_edit_arc
        GROUP BY arc_id
        HAVING COUNT(*) > 1
    ),
    'Each arc_id should be unique in v_edit_arc'
);

-- ELEMENT TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT element_id, COUNT(*) as cnt
        FROM v_edit_element
        GROUP BY element_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate element_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT element_id, COUNT(*)
        FROM v_edit_element
        GROUP BY element_id
        HAVING COUNT(*) > 1
    ),
    'Each element_id should be unique in v_edit_element'
);

-- LINK TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT link_id, COUNT(*) as cnt
        FROM v_edit_link
        GROUP BY link_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate link_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT link_id, COUNT(*)
        FROM v_edit_link
        GROUP BY link_id
        HAVING COUNT(*) > 1
    ),
    'Each link_id should be unique in v_edit_link'
);

-- CONNEC TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT connec_id, COUNT(*) as cnt
        FROM v_edit_connec
        GROUP BY connec_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate connec_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT connec_id, COUNT(*)
        FROM v_edit_connec
        GROUP BY connec_id
        HAVING COUNT(*) > 1
    ),
    'Each connec_id should be unique in v_edit_connec'
);

-- Finish the test
SELECT * FROM finish();

ROLLBACK;