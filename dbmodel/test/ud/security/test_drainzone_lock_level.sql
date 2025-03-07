/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

INSERT INTO drainzone (drainzone_id, name) VALUES (-999, 'Drainzone999');
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-998, 'Drainzone999', 0);
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-997, 'Drainzone998', 1);
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-996, 'Drainzone997', 2);
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-995, 'Drainzone996', 3);

REVOKE UPDATE (lock_level) ON TABLE drainzone FROM public;

CREATE USER admin_user;
GRANT role_system to admin_user;
GRANT UPDATE (lock_level) ON drainzone TO role_system;

CREATE USER nomral_user;
GRANT role_edit to nomral_user;


-- normal_user
SET ROLE normal_user;

-- lock_level is NULL
SELECT lives_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-999;',
    'Normal user can update when lock_level is NULL'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-999;',
    'Normal user can delete when lock_level is NULL'
);

-- lock_level = 0
SELECT lives_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-998;',
    'Normal user can update when lock_level = 0'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-998;',
    'Normal user can delete when lock_level = 0'
);


-- lock_level = 1
SELECT throws_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-997;',
    'ERROR: Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 1. HINT: PLEASE REVIEW THE LOCK LEVEL - 1',
    'Normal user can not update when lock_level is 1'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-997;',
    'Normal user can delete when lock_level is 1'
);


-- lock_level = 2
SELECT lives_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-996;',
    'Normal user can update when lock_level is 2'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-996;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 2. HINT: PLEASE REVIEW THE LOCK LEVEL - 2',
    'Normal user can not delete when lock_level is 2'
);


-- lock_level = 3
SELECT throws_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-995;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL - 3',
    'Normal user can not update when lock_level is 3'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-995;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL - 3',
    'Normal user can not delete when lock_level is 3'
);

-- update lock_level when lock_level = 0 TODO
SELECT throws_ok(
    'UPDATE drainzone set lock_level=0 WHERE drainzone_id=-998;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 0. HINT: PLEASE REVIEW THE LOCK LEVEL - 0',
    'Normal user can not update lock_level'
);









-- admin_user
SET ROLE admin_user;
-- lock_level is NULL
SELECT lives_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-999;',
    'Normal user can update when lock_level is NULL'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-999;',
    'Normal user can delete when lock_level is NULL'
);

-- lock_level = 0
SELECT lives_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-998;',
    'Normal user can update when lock_level = 0'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-998;',
    'Normal user can delete when lock_level = 0'
);


-- lock_level = 1
SELECT throws_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-997;',
    'ERROR: Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 1. HINT: PLEASE REVIEW THE LOCK LEVEL - 1',
    'Normal user can not update when lock_level is 1'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-997;',
    'Normal user can delete when lock_level is 1'
);


-- lock_level = 2
SELECT lives_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-996;',
    'Normal user can update when lock_level is 2'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-996;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 2. HINT: PLEASE REVIEW THE LOCK LEVEL - 2',
    'Normal user can not delete when lock_level is 2'
);


-- lock_level = 3
SELECT throws_ok(
    'UPDATE drainzone set name="zone" WHERE drainzone_id=-995;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL - 3',
    'Normal user can not update when lock_level is 3'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-995;',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL - 3',
    'Normal user can not delete when lock_level is 3'
);

-- update lock_level when lock_level = 3
SELECT lives_ok(
    'UPDATE drainzone set lock_level=0 WHERE drainzone_id=-995;',
    'Admin user can update lock_level'
);




SELECT * FROM finish();


ROLLBACK;