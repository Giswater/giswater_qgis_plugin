/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(8);

-- Subtest 1: Testing doc_type operations
INSERT INTO doc_type (id, comment) VALUES ('AS_BUILT2', 'test');
SELECT is((SELECT count(*)::integer FROM doc_type WHERE id = 'AS_BUILT2'), 1, 'INSERT: doc_type "AS_BUILT2" was inserted');

UPDATE doc_type SET comment = 'updated test' WHERE id = 'AS_BUILT2';
SELECT is((SELECT comment FROM doc_type WHERE id = 'AS_BUILT2'), 'updated test', 'UPDATE: Comment was updated to "updated test"');

INSERT INTO doc_type (id, comment)
VALUES ('AS_BUILT2', 'upsert test')
ON CONFLICT (id) DO UPDATE SET comment = EXCLUDED.comment;
SELECT is((SELECT comment FROM doc_type WHERE id = 'AS_BUILT2'), 'upsert test', 'UPSERT: Comment was updated to "upsert test" using ON CONFLICT');

DELETE FROM doc_type WHERE id = 'AS_BUILT2';
SELECT is((SELECT count(*)::integer FROM doc_type WHERE id = 'AS_BUILT2'), 0, 'DELETE: doc_type AS_BUILT2 was deleted');


-- Subtest 2: Testing doc operations
INSERT INTO doc (id, doc_type, "path", observ, "date", user_name, tstamp, the_geom, "name")
VALUES('Demo document 4', 'OTHER', 'https://bgeo.es', NULL, '2024-08-19 12:06:28.330', 'postgres', '2024-08-19 12:06:28.330', NULL, 'Demo document 4');
SELECT is((SELECT count(*)::integer FROM doc WHERE id = 'Demo document 4'), 1, 'INSERT: doc "Demo document 4" was inserted');

UPDATE doc SET observ = 'updated test' WHERE id = 'Demo document 4';
SELECT is((SELECT observ FROM doc WHERE id = 'Demo document 4'), 'updated test', 'UPDATE: observ was updated to "updated test"');

INSERT INTO doc (id, doc_type, "path", observ, "date", user_name, tstamp, the_geom, "name")
VALUES('Demo document 4', 'OTHER', 'https://bgeo.es', 'upsert test', '2024-08-19 12:06:28.330', 'postgres', '2024-08-19 12:06:28.330', NULL, 'Demo document 5')
ON CONFLICT (id) DO UPDATE SET observ = EXCLUDED.observ;
SELECT is((SELECT observ FROM doc WHERE id = 'Demo document 4'), 'upsert test', 'UPSERT: observ was updated to "upsert test" using ON CONFLICT');

DELETE FROM doc WHERE id = 'Demo document 4';
SELECT is((SELECT count(*)::integer FROM doc WHERE id = 'Demo document 4'), 0, 'DELETE: doc "Demo document 4" was deleted');


SELECT * FROM finish();

ROLLBACK;
