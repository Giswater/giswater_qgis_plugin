/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
----------------------------
--    GIS EDITING VIEWS
----------------------------
  

DROP VIEW IF EXISTS v_edit_macrodma CASCADE;
CREATE VIEW v_edit_macrodma AS SELECT
	macrodma.macrodma_id,
	macrodma.descript,
	macrodma.the_geom,
	macrodma.undelete,
	macrodma.expl_id
FROM expl_selector, macrodma 
WHERE ((macrodma.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);
  

  
DROP VIEW IF EXISTS v_edit_dma CASCADE;
CREATE VIEW v_edit_dma AS SELECT
	dma.dma_id,
	dma.sector_id,
	dma.presszonecat_id,
	dma.descript,
	dma.observ,
	dma.the_geom,
	dma.undelete,
	dma.macrodma_id,
	dma.expl_id
	FROM expl_selector, dma 
WHERE ((dma.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);
  


DROP VIEW IF EXISTS v_edit_sector CASCADE;
CREATE VIEW v_edit_sector AS SELECT
	sector.sector_id,
	sector.descript,
	sector.the_geom,
	sector.undelete,
	sector.expl_id
FROM expl_selector,sector 
WHERE ((sector.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);

  

DROP VIEW IF EXISTS v_edit_polygon CASCADE;
CREATE VIEW v_edit_polygon AS SELECT
	pol_id,
	text,
	polygon.the_geom,
	polygon.undelete,
	polygon.expl_id
FROM expl_selector, polygon
WHERE ((polygon.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);





DROP VIEW IF EXISTS v_edit_link CASCADE;
CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.featurecat_id,
    link.feature_id,
    link.vnode_id,
    st_length2d(link.the_geom) AS gis_length,
    link.custom_length,
    link.the_geom,
    link.expl_id,
	link."state"
   FROM expl_selector, link
  WHERE link.expl_id::text = expl_selector.expl_id::text AND expl_selector.cur_user = "current_user"()::text;

  
  
  DROP VIEW IF EXISTS v_edit_vnode CASCADE;
CREATE VIEW v_edit_vnode AS SELECT
	vnode_id,
	userdefined_pos,
	vnode_type,
	sector_id,
	state,
	annotation,
	vnode.the_geom,
	vnode.expl_id
FROM expl_selector,vnode
WHERE ((vnode.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);




DROP VIEW IF EXISTS v_edit_point CASCADE;
CREATE VIEW v_edit_point AS SELECT
	point_id,
	point_type,
	observ,
	text,
	link,
	point.the_geom,
	point.undelete,
	point.expl_id
FROM expl_selector,point
WHERE ((point.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);



DROP VIEW IF EXISTS v_edit_samplepoint CASCADE;
CREATE VIEW v_edit_samplepoint AS SELECT
	sample_id,
	state,
	rotation,
	code_lab,
	element_type,
	workcat_id,
	workcat_id_end,
	street1,
	street2,
	place,
	element_code,
	cabinet,
	dma_id2,
	observations,
	samplepoint.the_geom,
	samplepoint.expl_id
FROM expl_selector,samplepoint
WHERE ((samplepoint.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);


DROP VIEW IF EXISTS v_edit_element CASCADE;
CREATE VIEW v_edit_element AS SELECT
	element_id,
	elementcat_id,
	state,
	annotation,
	observ,
	comment,
	location_type,
	workcat_id,
	buildercat_id,
	builtdate,
	ownercat_id,
	enddate AS end_date,
	rotation,
	link,
	verified,
	workcat_id_end,
	code,
	element.the_geom,
	element.expl_id
FROM expl_selector,element
WHERE ((element.expl_id)::text=(expl_selector.expl_id)::text
AND expl_selector.cur_user="current_user"()::text);
 