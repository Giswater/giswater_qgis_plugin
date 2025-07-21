/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


CREATE OR REPLACE VIEW vi_campaign AS
SELECT
om_campaign.campaign_id,
om_campaign.startdate,
om_campaign.enddate,
om_campaign.real_startdate,
om_campaign.real_enddate,
om_campaign.descript,
cat_organization.orgname AS org_name,
om_campaign.duration,
sys_typevalue.idval AS status,
om_campaign.active
FROM om_campaign
LEFT JOIN cat_organization ON cat_organization.organization_id = om_campaign.organization_id
LEFT JOIN sys_typevalue ON sys_typevalue.id::integer = om_campaign.status AND sys_typevalue.typevalue = 'campaign_status'::text;


CREATE OR REPLACE VIEW vi_campaign_lot AS
SELECT om_campaign_lot.lot_id,
om_campaign_lot.startdate,
om_campaign_lot.enddate,
om_campaign_lot.real_startdate,
om_campaign_lot.real_enddate,
om_campaign_lot.descript,
cat_team.teamname AS team,
om_campaign_lot.duration,
sys_typevalue.idval AS status,
workorder.workorder_name,
om_campaign_lot.active
FROM om_campaign_lot
LEFT JOIN workorder ON workorder.workorder_id = om_campaign_lot.workorder_id
LEFT JOIN cat_team ON cat_team.team_id = om_campaign_lot.team_id
LEFT JOIN sys_typevalue ON sys_typevalue.id::integer = om_campaign_lot.status AND sys_typevalue.typevalue = 'lot_status'::text;


CREATE VIEW v_ui_campaign AS
WITH campaign_reviewvisit AS (SELECT ocr.campaign_id, omr.idval FROM om_campaign_review ocr
	LEFT JOIN om_reviewclass omr ON ocr.reviewclass_id = omr.id
	UNION
	SELECT ocr.campaign_id, omr.idval FROM om_campaign_visit ocr
	LEFT JOIN om_reviewclass omr ON ocr.visitclass_id = omr.id)
	SELECT
	c.campaign_id,
	c."name",
	c.startdate,
	c.enddate,
	c.real_startdate,
	c.real_enddate,
	st.idval AS campaign_type,
	crv.idval AS campaign_class,
	c.descript,
	c.active,
	c.organization_id,
	c.duration,
	c.status,
	c.the_geom
	FROM om_campaign c
	LEFT JOIN campaign_reviewvisit crv USING (campaign_id)
	LEFT JOIN sys_typevalue st ON st.id = c.campaign_type::TEXT
	WHERE st.typevalue = 'campaign_type';


CREATE OR REPLACE VIEW v_selector_lot
AS SELECT row_number() OVER () AS id,
    selector_lot.lot_id,
    om_campaign_lot.name,
    selector_lot.cur_user
   FROM selector_lot
     JOIN om_campaign_lot USING (lot_id)
  WHERE selector_lot.cur_user = CURRENT_USER;
