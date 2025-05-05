/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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


-- Team administrator
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(1,  '48178923Z', 'agarcia', 'agarcia', 'Alex Garcia Lopez',     'administrador1', 1, true),
(2,  '38145678P', 'ssanchez',    'ssanchez',    'Sergio Sanchez Bueno','administrador2', 1, true);

-- Team: Manager o1
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(3,  '79234561A', 'jperis',    'jperis',    'Juan Peris Gallego',   'manager o1', 2, true),
(4,  '10923456H', 'msierra',   'msierra',   'Marta Sierra Roca',    'manager o1', 2, true);

-- Team: Manager o2
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(5,  '52013478Y', 'atorres',   'atorres',   'Ana Torres Delgado',   'manager o2', 3, true),
(6,  '64823109F', 'cfuentes',  'cfuentes',  'Carlos Fuentes Mora',  'manager o2', 3, true);

-- Team: o1 field 1
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(7,  '78124567Q', 'lblanco',   'lblanco',   'Laura Blanco Martos',  'o1 field 1', 4, true),
(8,  '34567012K', 'dferrer',   'dferrer',   'David Ferrer Romeu',   'o1 field 1', 4, true);

-- Team: o1 field 2
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(9,  '46283910L', 'ngallart',  'ngallart',  'Nuria Gallart Costa',  'o1 field 2', 5, true),
(10, '57201894W', 'omartin',   'omartin',   'Oscar Martin Serra',   'o1 field 2', 5, true);

-- Team: o2 field 1
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(11, '68391740T', 'iramos',    'iramos',    'Ines Ramos Vega',      'o2 field 1', 6, true),
(12, '78291034X', 'pablo',     'pablo',     'Pablo Nuñez Bravo',    'o2 field 1', 6, true);

-- Team: o2 field 2
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(13, '84023910S', 'cgil',      'cgil',      'Carla Gil Torras',     'o2 field 2', 7, true),
(14, '92034185M', 'rbueno',    'rbueno',    'Raul Bueno Soler',     'o2 field 2', 7, true);

-- Easy user for test in local
INSERT INTO cat_user (user_id, code, loginname, username, fullname, descript, team_id, active) VALUES
(15, '92034185M', 'postgres', 'postgres', 'Postgres', 'o2 field 2', 1, true);

