/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



----------------------------
--    GIS EDITING VIEWS
----------------------------

DROP VIEW IF EXISTS v_edit_cad_auxcircle CASCADE;
CREATE VIEW v_edit_cad_auxcircle AS SELECT
id ,
geom_polygon
FROM temp_table 
WHERE user_name=current_user
AND fprocesscat_id=28;


DROP VIEW IF EXISTS v_edit_cad_auxpoint CASCADE;
CREATE VIEW v_edit_cad_auxpoint AS SELECT
id ,
geom_point
FROM temp_table 
WHERE user_name=current_user
AND fprocesscat_id=27;
  

  
  
DROP VIEW IF EXISTS v_edit_macrodma CASCADE;
CREATE VIEW v_edit_macrodma AS SELECT
	macrodma_id,
	name,
	descript,
	the_geom,
	undelete,
	macrodma.expl_id
FROM selector_expl, macrodma 
WHERE ((macrodma.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());


  
DROP VIEW IF EXISTS v_edit_dma CASCADE;
CREATE VIEW v_edit_dma AS SELECT
	dma_id,
	name,
	macrodma_id,
	descript,
	the_geom,
	undelete,
	dma.expl_id
	FROM selector_expl, dma 
WHERE ((dma.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
    

 
DROP VIEW IF EXISTS v_edit_macrosector CASCADE;
CREATE VIEW v_edit_macrosector AS SELECT DISTINCT on (macrosector_id)
	macrosector.macrosector_id,
	macrosector.name,
	macrosector.descript,
	macrosector.the_geom,
	macrosector.undelete
FROM inp_selector_sector, sector 
JOIN macrosector ON macrosector.macrosector_id=sector.macrosector_id
WHERE ((sector.sector_id)=(inp_selector_sector.sector_id)
AND inp_selector_sector.cur_user="current_user"());  

 
 
DROP VIEW IF EXISTS v_edit_sector CASCADE;
CREATE VIEW v_edit_sector AS SELECT
	sector.sector_id,
	sector.name,
	sector.descript,
	sector.macrosector_id,
	sector.the_geom,
	sector.undelete
FROM inp_selector_sector,sector 
WHERE ((sector.sector_id)=(inp_selector_sector.sector_id) 
AND inp_selector_sector.cur_user="current_user"());



   
  

DROP VIEW IF EXISTS v_edit_element CASCADE;
CREATE VIEW v_edit_element AS SELECT
	element.element_id,
	code,
	elementcat_id,
	cat_element.elementtype_id,
	serial_number,
	state,
	state_type,
	num_elements,
	observ,
	comment,
	function_type,
	category_type,
	location_type,
	fluid_type,
	workcat_id,
	workcat_id_end,
	buildercat_id,
	builtdate,
	enddate,
	ownercat_id,
	rotation,
	concat(element_type.link_path, element.link) AS link,
	verified,
	element.the_geom,
	label_x,
	label_y,
	label_rotation,
	publish,
	inventory,
	element.undelete,
	element.expl_id
FROM selector_expl,element
JOIN v_state_element ON element.element_id=v_state_element.element_id
JOIN cat_element ON elementcat_id = id
JOIN element_type ON element_type.id=elementtype_id
	WHERE ((element.expl_id)=(selector_expl.expl_id)
	AND selector_expl.cur_user="current_user"());	
	
	
	


DROP VIEW IF EXISTS v_edit_dimensions CASCADE;
CREATE OR REPLACE VIEW v_edit_dimensions AS 
 SELECT dimensions.id,
    dimensions.distance,
    dimensions.depth,
    dimensions.the_geom,
    dimensions.x_label,
    dimensions.y_label,
    dimensions.rotation_label,
    dimensions.offset_label,
    dimensions.direction_arrow,
    dimensions.x_symbol,
    dimensions.y_symbol,
    dimensions.feature_id,
    dimensions.feature_type,
    dimensions.state,
	dimensions.expl_id
FROM selector_expl,dimensions
JOIN v_state_dimensions ON dimensions.id=v_state_dimensions.id
WHERE ((dimensions.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
 