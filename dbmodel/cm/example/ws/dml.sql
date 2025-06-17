/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;

-- Review class
INSERT INTO om_reviewclass (id, idval, pschema_id, descript, active) VALUES(1, 'DEPOSITOS', 'PARENT_SCHEMA', 'TEST INSERT', TRUE);
INSERT INTO om_reviewclass (id, idval, pschema_id, descript, active) VALUES(2, 'VALVULAS HIDRAULICAS','PARENT_SCHEMA','TEST INSERT', TRUE);

-- Review class x object
INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active) VALUES (1, 'TANK', 1, TRUE);
INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active) VALUES (2, 'PR_SUSTA_VALVE', 1, TRUE);
INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active) VALUES (2, 'PR_REDUC_VALVE', 2, TRUE);
INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active) VALUES (2, 'PR_BREAK_VALVE', 3, TRUE);
INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active) VALUES (2, 'FL_CONTR_VALVE', 4, TRUE);
INSERT INTO om_reviewclass_x_object (reviewclass_id, object_id, orderby, active) VALUES (2, 'THROTTLE_VALVE', 5, TRUE);

-- Campaign
INSERT INTO om_campaign (campaign_id, name, active, organization_id, campaign_type, status) values (1, 'Campaign num.1', TRUE, 1, 1, 1);
INSERT INTO om_campaign (campaign_id, name, active, organization_id, campaign_type, status) values (2, 'Campaign num.2', TRUE, 2, 1, 1);

-- Campaign review
INSERT INTO om_campaign_review (campaign_id, reviewclass_id) VALUES(1, 1);
INSERT INTO om_campaign_review (campaign_id, reviewclass_id) VALUES(2, 1);

-- Campaign lot
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (1, 'Lot num.1', 1, TRUE, 4, 1);
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (2, 'Lot num.2', 1, TRUE, 5, 1);
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (3, 'Lot num.3', 2, TRUE, 6, 1);
INSERT INTO om_campaign_lot  (lot_id, name, campaign_id, active, team_id, status)  values (4, 'Lot num.4', 2, TRUE, 7, 1);
