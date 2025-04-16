/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO cat_organization (organization_id, code, "name", descript, active) VALUES(1, '123123', 'OWNER', 'PROPIETARIS', true);
INSERT INTO cat_organization (organization_id, code, "name", descript, active) VALUES(2, '123123', 'O1', 'O1', true);
INSERT INTO cat_organization (organization_id, code, "name", descript, active) VALUES(3, '123123', 'O2', 'O2', true);

INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(1, '1234512345', 'ADMIN', 1, 'equip administratiu', 'role_admin', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(2, '1234512345', 'o1_manager', 2, 'equip administratiu', 'role_manager', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(3, '1234512345', 'o2_manager', 3, 'equip administratiu', 'role_manager', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(4, '1234512345', 'o1_field1', 2, 'equip camp', 'role_field', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(5, '1234512345', 'o1_field2', 2, 'equip camp', 'role_field', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(6, '1234512345', 'o2_field1', 3, 'equip camp', 'role_field', true);
INSERT INTO cat_team (team_id, code, "name", organization_id, descript, role_id, active) VALUES(7, '1234512345', 'o2_field2', 3, 'equip camp', 'role_field', true);

-- Team administrator
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('ferran', 'ferran@gmail.com', '48178923Z', 'ferran martinez lopez', 'administrador1', 1, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('daniel', 'daniel@gmail.com', '38145678P', 'daniel marin bocanegra', 'administrador2', 1, true);

-- Team: Manager o1
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('juan', 'juan@gmail.com', '79234561A', 'juan peris gallego', 'manager o1', 2, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('marta', 'marta.o1@gmail.com', '10923456H', 'marta sierra roca', 'manager o1', 2, true);

-- Team: Manager o2
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('ana', 'ana.o2@gmail.com', '52013478Y', 'ana torres delgado', 'manager o2', 3, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('carlos', 'carlos.manager@gmail.com', '64823109F', 'carlos fuentes mora', 'manager o2', 3, true);

-- Team: o1 field 1
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('laura', 'laura.field1@gmail.com', '78124567Q', 'laura blanco martí', 'o1 field 1', 4, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('david', 'david.o1f1@gmail.com', '34567012K', 'david ferrer romeu', 'o1 field 1', 4, true);

-- Team: o1 field 2
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('nuria', 'nuria.o1f2@gmail.com', '46283910L', 'nuria gallart costa', 'o1 field 2', 5, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('oscar', 'oscar.field2@gmail.com', '57201894W', 'oscar martin serra', 'o1 field 2', 5, true);

-- Team: o2 field 1
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('ines', 'ines.o2f1@gmail.com', '68391740T', 'ines ramos vega', 'o2 field 1', 6, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('pablo', 'pablo.o2f1@gmail.com', '78291034X', 'pablo nuñez bravo', 'o2 field 1', 6, true);

-- Team: o2 field 2
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('carla', 'carla.o2f2@gmail.com', '84023910S', 'carla gil torras', 'o2 field 2', 7, true);
INSERT INTO cat_user (user_id, loginname, code, "name", descript, team_id, active) VALUES('raul', 'raul.o2f2@gmail.com', '92034185M', 'raul bueno soler', 'o2 field 2', 7, true);