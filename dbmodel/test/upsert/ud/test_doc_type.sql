/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(4);

-- 1. INSERT
INSERT INTO doc_type (id, comment) VALUES ('AS_BUILT2', 'test');
SELECT is((SELECT count(*)::integer FROM doc_type WHERE id = 'AS_BUILT2'), 1, 'INSERT: doc_type AS_BUILT2 was inserted');

-- 2. UPDATE
UPDATE doc_type SET comment = 'updated test' WHERE id = 'AS_BUILT2';
SELECT is((SELECT comment FROM doc_type WHERE id = 'AS_BUILT2'), 'updated test', 'UPDATE: Comment was updated to "updated test"');

-- 3. UPSERT
INSERT INTO doc_type (id, comment)
VALUES ('AS_BUILT2', 'upsert test')
ON CONFLICT (id) DO UPDATE SET comment = EXCLUDED.comment;
SELECT is((SELECT comment FROM doc_type WHERE id = 'AS_BUILT2'), 'upsert test', 'UPSERT: Comment was updated to "upsert test" using ON CONFLICT');

-- 4. DELETE
DELETE FROM doc_type WHERE id = 'AS_BUILT2';
SELECT is((SELECT count(*)::integer FROM doc_type WHERE id = 'AS_BUILT2'), 0, 'DELETE: doc_type AS_BUILT2 was deleted');

SELECT * FROM finish();

ROLLBACK;
