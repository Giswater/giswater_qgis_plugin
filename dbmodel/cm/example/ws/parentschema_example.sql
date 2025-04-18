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

insert into om_campaign (campaign_id, name, active, organization_id, campaign_type, status) values (1, 'Campaign num.1', TRUE, 1, 1);
insert into om_campaign (campaign_id, name, active, organization_id, campaign_type, status) values (2, 'Campaign num.2', TRUE, 2, 1);

insert into om_campaign_review values (1, 1);
insert into om_campaign_review values (2, 1);

insert into om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (1, 'Lot num.1', 1, true, 4, 1);
insert into om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (2, 'Lot num.2', 1, true, 5, 1);
insert into om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (3, 'Lot num.3', 2, true, 6, 1);
insert into om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (4, 'Lot num.4', 2, true, 7, 1);