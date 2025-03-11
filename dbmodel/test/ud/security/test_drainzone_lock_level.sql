/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- ===========================
-- PREPARE DATA
-- ===========================
INSERT INTO drainzone (drainzone_id, name) VALUES (-999, 'Drainzone999');
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-998, 'Drainzone998', 0);
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-997, 'Drainzone997', 1);
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-996, 'Drainzone996', 2);
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-995, 'Drainzone995', 3);

REVOKE UPDATE ON TABLE drainzone FROM role_edit;
GRANT UPDATE (drainzone_id, name, expl_id, descript, the_geom, link, graphconfig, stylesheet, active, tstamp, insert_user, lastupdate, lastupdate_user, drainzone_type) ON drainzone TO role_edit;
GRANT UPDATE (lock_level) ON drainzone TO role_admin;

CREATE USER admin_user;
GRANT role_admin to admin_user;

CREATE USER normal_user;
GRANT role_edit to normal_user;

-- ===========================
-- normal_user
-- ===========================
SET role normal_user;

-- lock_level is NULL
SELECT lives_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-999;',
    'Normal user can update when lock_level is NULL'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-999;',
    'Normal user can delete when lock_level is NULL'
);

-- lock_level = 0
SELECT lives_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-998;',
    'Normal user can update when lock_level = 0'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-998;',
    'Normal user can delete when lock_level = 0'
);

-- lock_level = 1
SELECT throws_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-997;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 1. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Normal user can not update when lock_level is 1'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-997;',
    'Normal user can delete when lock_level is 1'
);

-- lock_level = 2
SELECT lives_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-996;',
    'Normal user can update when lock_level is 2'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-996;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 2. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Normal user can not delete when lock_level is 2'
);

-- lock_level = 3
SELECT throws_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-995;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Normal user can not update when lock_level is 3'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-995;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Normal user can not delete when lock_level is 3'
);

-- update lock_level when lock_level = 0 TODO
SELECT throws_ok(
    'UPDATE drainzone set lock_level=0 WHERE drainzone_id=-998;',
    '42501',
    'permission denied for table drainzone',
    'Normal user can not update lock_level'
);

-- ===========================
-- admin_user
-- ===========================
SET ROLE admin_user;

-- recreate the drainzone with lock_level = 1 deleted by normal_user
INSERT INTO drainzone (drainzone_id, name, lock_level) VALUES (-997, 'Drainzone997', 1);

-- lock_level is NULL
SELECT lives_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-999;',
    'Admin user can update when lock_level is NULL'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-999;',
    'Admin user can delete when lock_level is NULL'
);

-- lock_level = 0
SELECT lives_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-998;',
    'Admin user can update when lock_level = 0'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-998;',
    'Admin user can delete when lock_level = 0'
);

-- lock_level = 1
SELECT throws_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-997;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 1. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Admin user can not update when lock_level is 1'
);

SELECT lives_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-997;',
    'Admin user can delete when lock_level is 1'
);

-- lock_level = 2
SELECT lives_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-996;',
    'Admin user can update when lock_level is 2'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-996;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 2. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Admin user can not delete when lock_level is 2'
);

-- lock_level = 3
SELECT throws_ok(
    'UPDATE drainzone set name=''zone'' WHERE drainzone_id=-995;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Admin user can not update when lock_level is 3'
);

SELECT throws_ok(
    'DELETE FROM drainzone WHERE drainzone_id=-995;',
    'P0001',
    'Function: [gw_trg_edit_controls] - CANNOT DO THIS OPERATION BECAUSE THE LOCK LEVEL IS SET TO 3. HINT: PLEASE REVIEW THE LOCK LEVEL',
    'Admin user can not delete when lock_level is 3'
);

-- update lock_level when lock_level = 3
SELECT lives_ok(
    'UPDATE drainzone set lock_level=0 WHERE drainzone_id=-995;',
    'Admin user can update lock_level'
);


SELECT * FROM finish();

ROLLBACK;
