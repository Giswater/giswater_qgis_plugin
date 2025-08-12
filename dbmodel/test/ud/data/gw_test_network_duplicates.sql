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

SELECT plan(14);

-- NODE TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT node_id, COUNT(*) as cnt
        FROM ve_node
        GROUP BY node_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate node_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT node_id, COUNT(*)
        FROM ve_node
        GROUP BY node_id
        HAVING COUNT(*) > 1
    ),
    'Each node_id should be unique in ve_node'
);

-- ARC TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT arc_id, COUNT(*) as cnt
        FROM ve_arc
        GROUP BY arc_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate arc_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT arc_id, COUNT(*)
        FROM ve_arc
        GROUP BY arc_id
        HAVING COUNT(*) > 1
    ),
    'Each arc_id should be unique in ve_arc'
);

-- ELEMENT TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT element_id, COUNT(*) as cnt
        FROM ve__manfrelem
        GROUP BY element_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate element_ids on ve_man_frelem'
);

SELECT ok(
    NOT EXISTS (
        SELECT element_id, COUNT(*)
        FROM ve_man_frelem
        GROUP BY element_id
        HAVING COUNT(*) > 1
    ),
    'Each element_id should be unique in ve_man_frelem'
);

SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT element_id, COUNT(*) as cnt
        FROM ve_element
        GROUP BY element_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate element_ids on ve_element'
);

SELECT ok(
    NOT EXISTS (
        SELECT element_id, COUNT(*)
        FROM ve_element
        GROUP BY element_id
        HAVING COUNT(*) > 1
    ),
    'Each element_id should be unique in ve_element'
);

-- LINK TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT link_id, COUNT(*) as cnt
        FROM ve_link
        GROUP BY link_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate link_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT link_id, COUNT(*)
        FROM ve_link
        GROUP BY link_id
        HAVING COUNT(*) > 1
    ),
    'Each link_id should be unique in ve_link'
);

-- CONNEC TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT connec_id, COUNT(*) as cnt
        FROM ve_connec
        GROUP BY connec_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate connec_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT connec_id, COUNT(*)
        FROM ve_connec
        GROUP BY connec_id
        HAVING COUNT(*) > 1
    ),
    'Each connec_id should be unique in ve_connec'
);

-- GULLY TESTS
SELECT is(
    (SELECT COUNT(*)
    FROM (
        SELECT gully_id, COUNT(*) as cnt
        FROM ve_gully
        GROUP BY gully_id
        HAVING COUNT(*) > 1
    ) a),
    0::bigint,
    'There should be no duplicate gully_ids'
);

SELECT ok(
    NOT EXISTS (
        SELECT gully_id, COUNT(*)
        FROM ve_gully
        GROUP BY gully_id
        HAVING COUNT(*) > 1
    ),
    'Each gully_id should be unique in ve_gully'
);

-- Finish the test
SELECT * FROM finish();

ROLLBACK;