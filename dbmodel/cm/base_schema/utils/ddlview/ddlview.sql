/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_team_x_user AS 
SELECT om_team_x_user.id,
om_team_x_user.user_id,
cat_user.user_id AS user_name,
om_team_x_user.team_id,
cat_team.name AS team_name
FROM om_team_x_user
JOIN cat_team USING (team_id)
JOIN cat_user USING (user_id);



CREATE OR REPLACE VIEW vi_campaign AS
SELECT 
om_campaign.id,
om_campaign.startdate,
om_campaign.enddate,
om_campaign.real_startdate,
om_campaign.real_enddate,
om_campaign.descript,
cat_organization.name AS org_name,
om_campaign.duration,
sys_typevalue.idval AS status,
om_campaign.address,
om_campaign.active
FROM om_campaign
LEFT JOIN cat_organization ON cat_organization.organization_id = om_campaign.organization_id
LEFT JOIN sys_typevalue ON sys_typevalue.id::integer = om_campaign.status AND sys_typevalue.typevalue = 'campaign_status'::text;



CREATE OR REPLACE VIEW vi_campaign_lot AS
SELECT om_campaign_lot.id,
om_campaign_lot.startdate,
om_campaign_lot.enddate,
om_campaign_lot.real_startdate,
om_campaign_lot.real_enddate,
om_campaign_lot.descript,
cat_team.name AS team,
om_campaign_lot.duration,
sys_typevalue.idval AS status,
workorder.workorder_name,
om_campaign_lot.address,
om_campaign_lot.active
FROM om_campaign_lot
LEFT JOIN workorder ON workorder.workorder_id = om_campaign_lot.workorder_id
LEFT JOIN cat_team ON cat_team.team_id = om_campaign_lot.team_id
LEFT JOIN sys_typevalue ON sys_typevalue.id::integer = om_campaign_lot.status AND sys_typevalue.typevalue = 'lot_status'::text;