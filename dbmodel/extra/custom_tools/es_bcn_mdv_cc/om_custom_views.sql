/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path=SCHEMA_NAME,public;

CREATE VIEW SCHEMA_NAME.v_om_visit_node_photo AS
 SELECT DISTINCT ON (node.node_id)
 node.node_id,
 om_visit.id as visit_id,
 startdate as visit_date,
 p1,
 p2,
 p3,
 p4,
 node.the_geom
   FROM SCHEMA_NAME.om_visit
   JOIN SCHEMA_NAME.om_visit_x_node on om_visit.id=om_visit_x_node.visit_id
   JOIN SCHEMA_NAME.node on node.node_id=om_visit_x_node.node_id
     JOIN ( 
     SELECT * FROM crosstab(' 
	SELECT visit_id,row_number() over (partition by visit_id) as parameter_id, text FROM SCHEMA_NAME.om_visit_event_photo'::text
	,
	'SELECT DISTINCT parameter_id FROM (SELECT visit_id,row_number() over (partition by visit_id) as parameter_id,value FROM SCHEMA_NAME.om_visit_event_photo)a order by 1 LIMIT 4'::text)
	AS rpt (visit_id integer, p1 text, p2 text, p3 text, p4 text)
	) a ON a.visit_id=om_visit.id;



CREATE VIEW SCHEMA_NAME.v_om_visit_gully_photo AS
 SELECT DISTINCT ON (gully.gully_id)
 gully.gully_id,
 om_visit.id as visit_id,
 startdate as visit_date,
 p1,
 p2,
 p3,
 p4,
 gully.the_geom
   FROM SCHEMA_NAME.om_visit
   JOIN SCHEMA_NAME.om_visit_x_gully on om_visit.id=om_visit_x_gully.visit_id
   JOIN SCHEMA_NAME.gully on gully.gully_id=om_visit_x_gully.gully_id
     JOIN ( 
     SELECT * FROM crosstab(' 
	SELECT visit_id,row_number() over (partition by visit_id) as parameter_id, text FROM SCHEMA_NAME.om_visit_event_photo'::text
	,
	'SELECT DISTINCT parameter_id FROM (SELECT visit_id,row_number() over (partition by visit_id) as parameter_id,value FROM SCHEMA_NAME.om_visit_event_photo)a order by 1 LIMIT 4'::text)
	AS rpt (visit_id integer, p1 text, p2 text, p3 text, p4 text)
	) a ON a.visit_id=om_visit.id;





CREATE VIEW SCHEMA_NAME.v_om_visit_node_event AS

 SELECT distinct on (node.node_id)
  node.node_id,
 om_visit.id as visit_id,
 startdate as visit_date,
 tovalloletes,
  sabons,
 sorresgraves,
 net,
 organic,
 altres,
 arrels,
 node.the_geom
   FROM SCHEMA_NAME.om_visit
      JOIN SCHEMA_NAME.om_visit_x_node on om_visit.id=om_visit_x_node.visit_id
   JOIN SCHEMA_NAME.node on node.node_id=om_visit_x_node.node_id
     JOIN ( 
     SELECT * FROM crosstab(' 
	SELECT visit_id, parameter_id, ''true''::text as value FROM SCHEMA_NAME.om_visit_event'
	,
	'SELECT DISTINCT parameter_id FROM SCHEMA_NAME.om_visit_event')
	AS rpt (visit_id integer, tovalloletes text, sabons text, sorresgraves text, net text, organic text, altres text, arrels text)
	) a ON a.visit_id=om_visit.id;





CREATE VIEW SCHEMA_NAME.v_om_visit_gully_event AS

 SELECT distinct on (gully.gully_id)
  gully.gully_id,
 om_visit.id as visit_id,
 startdate as visit_date,
 tovalloletes,
  sabons,
 sorresgraves,
 net,
 organic,
 altres,
 arrels,
 gully.the_geom
   FROM SCHEMA_NAME.om_visit
      JOIN SCHEMA_NAME.om_visit_x_gully on om_visit.id=om_visit_x_gully.visit_id
   JOIN SCHEMA_NAME.gully on gully.gully_id=om_visit_x_gully.gully_id
     JOIN ( 
     SELECT * FROM crosstab(' 
	SELECT visit_id, parameter_id, ''true''::text as value FROM SCHEMA_NAME.om_visit_event'
	,
	'SELECT DISTINCT parameter_id FROM SCHEMA_NAME.om_visit_event')
	AS rpt (visit_id integer, tovalloletes text, sabons text, sorresgraves text, net text, organic text, altres text, arrels text)
	) a ON a.visit_id=om_visit.id;



CREATE VIEW SCHEMA_NAME.v_om_visit_gully AS
SELECT
gully.gully_id,
gully.top_elev,
gully.ymax,
gully.gratecat_id,
cat_grate.type AS cat_grate_type,
cat_grate.matcat_id AS cat_grate_matcat,
gully.dma_id,
gully.fluid_type,
cat_grate.svg AS cat_svg,
manhole_fill,
cleaned
FROM SCHEMA_NAME.om_visit_event
JOIN (SELECT gully_id, max(tstamp) as max_tstamp FROM SCHEMA_NAME.om_visit_event
        JOIN SCHEMA_NAME.om_visit_x_gully ON om_visit_event.visit_id=om_visit_x_gully.visit_id
        WHERE tstamp > ('now'::text::date - '30 days'::interval)
        GROUP BY 1
        ORDER BY 1,2) a ON max_tstamp=tstamp
RIGHT JOIN SCHEMA_NAME.gully ON gully.gully_id=a.gully_id
LEFT JOIN SCHEMA_NAME.cat_grate ON gully.gratecat_id::text = cat_grate.id::text



CREATE OR REPLACE VIEW SCHEMA_NAME.v_om_visit_node AS 
 SELECT node.node_id,
    node.top_elev,
    node.ymax,
    node.node_type,
    node.nodecat_id,
    node.dma_id,
    node.fluid_type,
    om_visit_event.manhole_fill,
    om_visit_event.cleaned
   FROM SCHEMA_NAME.om_visit_event
     JOIN ( SELECT om_visit_x_node.node_id,
            max(om_visit_event_1.tstamp) AS max_tstamp
           FROM SCHEMA_NAME.om_visit_event om_visit_event_1
             JOIN SCHEMA_NAME.om_visit_x_node ON om_visit_event_1.visit_id = om_visit_x_node.visit_id
          WHERE om_visit_event_1.tstamp > ('now'::text::date - '30 days'::interval)
          GROUP BY om_visit_x_node.node_id
          ORDER BY om_visit_x_node.node_id, max(om_visit_event_1.tstamp)) a ON a.max_tstamp = om_visit_event.tstamp
     RIGHT JOIN SCHEMA_NAME.node ON node.node_id::text = a.node_id::text
  ORDER BY om_visit_event.cleaned;



-- Another aproximation for gully event visit
DROP VIEW SCHEMA_NAME.v_om_visit_gully_event;
CREATE VIEW SCHEMA_NAME.v_om_visit_gully_event AS
SELECT DISTINCT ON (gully.gully_id) 
    gully.gully_id,
    om_visit.id AS visit_id,
    om_visit.startdate AS visit_date,
    a.parameter_id,
    a.text,
    a.observ,
    gully.the_geom
   FROM SCHEMA_NAME.om_visit
     JOIN SCHEMA_NAME.om_visit_x_gully ON om_visit.id = om_visit_x_gully.visit_id
     JOIN SCHEMA_NAME.gully ON gully.gully_id::text = om_visit_x_gully.gully_id::text
     JOIN ( select visit_id, parameter_id, text, observ FROM SCHEMA_NAME.om_visit_event ) a ON a.visit_id = om_visit.id;


	 
-- Another aproximation for node event visit 
DROP VIEW SCHEMA_NAME.v_om_visit_node_event;
CREATE VIEW SCHEMA_NAME.v_om_visit_node_event AS
SELECT DISTINCT ON (node.node_id) 
    node.node_id,
    om_visit.id AS visit_id,
    om_visit.startdate AS visit_date,
    a.parameter_id,
    a.text,
    a.observ,
    node.the_geom
   FROM SCHEMA_NAME.om_visit
     JOIN SCHEMA_NAME.om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     JOIN SCHEMA_NAME.node ON node.node_id::text = om_visit_x_node.node_id::text
     JOIN ( select visit_id, parameter_id, text, observ FROM SCHEMA_NAME.om_visit_event ) a ON a.visit_id = om_visit.id;




