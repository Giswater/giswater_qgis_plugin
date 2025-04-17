/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog


INSERT INTO om_reviewclass (id, idval, pschema_id, descript, active) VALUES(1, 'DEPOSITOS', 'PARENT_SCHEMA', 'TEST INSERT', true);
INSERT INTO om_reviewclass (id, idval, pschema_id, descript, active) VALUES(2, 'VALVULAS HIDRAULICAS','PARENT_SCHEMA','TEST INSERT', true);


INSERT INTO om_reviewclass_x_object VALUES (1,'TANK',true);

INSERT INTO om_reviewclass_x_object VALUES (2,'PR_SUSTA_VALVE',true);
INSERT INTO om_reviewclass_x_object VALUES (2,'PR_REDUC_VALVE',true);
INSERT INTO om_reviewclass_x_object VALUES (2,'PR_BREAK_VALVE',true);
INSERT INTO om_reviewclass_x_object VALUES (2,'FL_CONTR_VALVE',true);
INSERT INTO om_reviewclass_x_object VALUES (2,'THROTTLE_VALVE',true);
