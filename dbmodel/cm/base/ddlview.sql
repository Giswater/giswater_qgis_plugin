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

CREATE OR REPLACE VIEW v_ui_doc_x_node
AS
SELECT
	doc_x_node.doc_id,
	doc_x_node.node_id,
	doc.name,
	doc.doc_type,
	doc.path,
	doc.observ,
	doc.date,
	doc.user_name,
	doc_x_node.node_uuid
FROM cm.doc_x_node
JOIN cm.doc ON doc.id::text = doc_x_node.doc_id::text;

GRANT ALL ON TABLE v_ui_doc_x_node TO role_cm_manager;
GRANT ALL ON TABLE v_ui_doc_x_node TO role_cm_field;

CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS
SELECT
	doc_x_arc.doc_id,
	doc_x_arc.arc_id,
	doc.name,
	doc.doc_type,
	doc.path,
	doc.observ,
	doc.date,
	doc.user_name,
	doc_x_arc.arc_uuid
FROM cm.doc_x_arc
JOIN cm.doc ON doc.id::text = doc_x_arc.doc_id::text;

GRANT ALL ON TABLE v_ui_doc_x_arc TO role_cm_manager;
GRANT ALL ON TABLE v_ui_doc_x_arc TO role_cm_field;

CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS
SELECT
	doc_x_connec.doc_id,
	doc_x_connec.connec_id,
	doc.name,
	doc.doc_type,
	doc.path,
	doc.observ,
	doc.date,
	doc.user_name,
	doc_x_connec.connec_uuid
FROM cm.doc_x_connec
JOIN cm.doc ON doc.id::text = doc_x_connec.doc_id::text;

GRANT ALL ON TABLE v_ui_doc_x_connec TO role_cm_manager;
GRANT ALL ON TABLE v_ui_doc_x_connec TO role_cm_field;

CREATE OR REPLACE VIEW v_ui_doc_x_link
AS
SELECT
	doc_x_link.doc_id,
	doc_x_link.link_id,
	doc.name,
	doc.doc_type,
	doc.path,
	doc.observ,
	doc.date,
	doc.user_name,
	doc_x_link.link_uuid
FROM cm.doc_x_link
JOIN cm.doc ON doc.id::text = doc_x_link.doc_id::text;

GRANT ALL ON TABLE v_ui_doc_x_link TO role_cm_manager;
GRANT ALL ON TABLE v_ui_doc_x_link TO role_cm_field;