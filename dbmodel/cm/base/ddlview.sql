/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


CREATE OR REPLACE VIEW v_ui_campaign AS
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
	c.status,
	c.the_geom
	FROM om_campaign c
	LEFT JOIN campaign_reviewvisit crv USING (campaign_id)
	LEFT JOIN sys_typevalue st ON st.id = c.campaign_type::TEXT	AND st.typevalue = 'campaign_type';

CREATE OR REPLACE VIEW v_ui_campaign_lot AS
	SELECT
	l.lot_id,
	l.name,
	l.startdate,
	l.enddate,
	l.real_startdate,
	l.real_enddate,
	c.name AS campaign_name,
	wo.workorder_name,
	l.descript,
	l.active,
	t.teamname as team_name,
	st.idval as status,
	l.expl_id,
	l.sector_id,
	l.the_geom
	FROM om_campaign_lot l
	LEFT JOIN om_campaign c ON l.campaign_id = c.campaign_id
	LEFT JOIN workorder wo ON l.workorder_id = wo.workorder_id
	LEFT JOIN cat_team t ON l.team_id = t.team_id
	LEFT JOIN sys_typevalue st ON st.id = l.status::text AND st.typevalue = 'lot_status';

CREATE OR REPLACE VIEW v_selector_lot
AS SELECT row_number() OVER () AS id,
    selector_lot.lot_id,
    om_campaign_lot.name,
    selector_lot.cur_user
   FROM selector_lot
     JOIN om_campaign_lot USING (lot_id)
  WHERE selector_lot.cur_user = CURRENT_USER;

CREATE OR REPLACE VIEW v_filter_lot AS 
 SELECT ocl.lot_id, name, status, campaign_id, the_geom 
   FROM selector_lot sl 
     JOIN om_campaign_lot ocl ON ocl.lot_id = sl.lot_id
  WHERE sl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_filter_campaign AS 
 SELECT oc.campaign_id, name, status, the_geom 
   FROM selector_campaign sc
     JOIN om_campaign oc ON oc.campaign_id = sc.campaign_id
  WHERE sc.cur_user = "current_user"()::text;

-- Permissions for v_selector_lot
GRANT SELECT ON TABLE cm.v_selector_lot TO role_cm_field;