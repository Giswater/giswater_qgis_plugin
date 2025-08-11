/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;

grant role_cm_admin to current_user;

INSERT INTO cat_organization (organization_id, code, orgname, descript, active) VALUES(1, '123123', 'OWNER', 'OWNER ORGANIZATION', true);
INSERT INTO cat_organization (organization_id, code, orgname, descript, active) VALUES(2, '123123', 'ORG1', 'EXTERNAL ORGANIZATION', true);
INSERT INTO cat_organization (organization_id, code, orgname, descript, active) VALUES(3, '123123', 'ORG2', 'EXTERNAL ORGANIZATION', true);

INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(1, '1234512345', 'ADMIN', 1, 'admin team', 'role_cm_admin', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(2, '1234512345', 'o1_manager', 2, 'manager team of org 1', 'role_cm_manager', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(3, '1234512345', 'o2_manager', 3, 'manager team of org 2', 'role_cm_manager', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(4, '1234512345', 'o1_field1', 2, 'field team of org1', 'role_cm_field', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(5, '1234512345', 'o1_field2', 2, 'field team of org1', 'role_cm_field', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(6, '1234512345', 'o2_field1', 3, 'field team of org2', 'role_cm_field', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(7, '1234512345', 'o2_field2', 3, 'field team of org2', 'role_cm_field', true);
INSERT INTO cat_team (team_id, code, teamname, organization_id, descript, role_id, active) VALUES(8, '1234512345', 'team_edit', 1, 'team edit', 'role_cm_edit', true);


-- Team administrator
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(1, 'agarcia', 1, true),
(2, 'ssanchez', 1, true);

-- Team: Manager o1
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(3, 'jperis', 2, true),
(4, 'msierra', 2, true),
(5, 'o1_manager', 2, true);

-- Team: Manager o2
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(6, 'atorres', 3, true),
(7, 'cfuentes', 3, true),
(8, 'o2_manager', 3, true);

-- Team: o1 field 1
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(9, 'lblanco', 4, true),
(10, 'dferrer', 4, true),
(11, 'o1_field1', 4, true);

-- Team: o1 field 2
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(12, 'ngallart', 5, true),
(13, 'omartin', 5, true),
(14, 'o1_field2', 5, true);

-- Team: o2 field 1
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(15, 'iramos', 6, true),
(16, 'pablo', 6, true),
(17, 'o2_field1', 6, true);

-- Team: o2 field 2
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(18, 'cgil', 7, true),
(19, 'rbueno', 7, true),
(20, 'o2_field2', 7, true);

-- Easy user for test in local
INSERT INTO cat_user (user_id, username, team_id, active) VALUES
(21, 'postgres', 1, true),
(22, 'bgeoadmin', 1, true);

-- Reset sequences
SELECT setval('cat_organization_organization_id_seq', (SELECT MAX(organization_id) FROM cat_organization), true);
SELECT setval('cat_team_team_id_seq', (SELECT MAX(team_id) FROM cat_team), true);
SELECT setval('cat_user_user_id_seq', (SELECT MAX(user_id) FROM cat_user), true);

