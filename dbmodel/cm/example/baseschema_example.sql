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
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(1, '48178923Z', 'fmartinez', 'ferran martinez lopez', 'administrador1', 1, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(2, '38145678P', 'dmarin', 'daniel marin bocanegra', 'administrador2', 1, true);

-- Team: Manager o1
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(3, '79234561A', 'jperis', 'juan peris gallego', 'manager o1', 2, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(4, '10923456H', 'msierra', 'marta sierra roca', 'manager o1', 2, true);

-- Team: Manager o2
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(5, '52013478Y', 'atorres', 'ana torres delgado', 'manager o2', 3, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(6, '64823109F', 'cfuentes', 'carlos fuentes mora', 'manager o2', 3, true);

-- Team: o1 field 1
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(7, '78124567Q', 'lblanco', 'laura blanco martos', 'o1 field 1', 4, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(8, '34567012K', 'dferrer', 'david ferrer romeu', 'o1 field 1', 4, true);

-- Team: o1 field 2
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(9, '46283910L', 'ngallart', 'nuria gallart costa', 'o1 field 2', 5, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(10, '57201894W', 'omartin', 'oscar martin serra', 'o1 field 2', 5, true);

-- Team: o2 field 1
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(11, '68391740T', 'iramos', 'ines ramos vega', 'o2 field 1', 6, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(12, '78291034X', 'pablo', 'pablo nuñez bravo', 'o2 field 1', 6, true);

-- Team: o2 field 2
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(13, '84023910S', 'cgil', 'carla gil torras', 'o2 field 2', 7, true);
INSERT INTO cat_user (user_id, code, username, fullname, descript, team_id, active) VALUES(14, '92034185M', 'rbueno', 'raul bueno soler', 'o2 field 2', 7, true);