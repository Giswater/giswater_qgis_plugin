/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;
----------------------------
--    GIS EDITING VIEWS
----------------------------
  

DROP VIEW IF EXISTS v_edit_samplepoint CASCADE;
CREATE VIEW v_edit_samplepoint AS SELECT
	sample_id,
	code,
	lab_code,
	feature_id,
	featurecat_id,
	samplepoint.dma_id,
	dma.macrodma_id,
	state,
	builtdate,
	enddate,
	workcat_id,
	workcat_id_end,
	rotation,
	street1,
	street2,
	place_name,
	cabinet,
	observations,
	verified,
	samplepoint.the_geom,
	samplepoint.expl_id
FROM selector_expl,samplepoint
JOIN v_state_samplepoint ON samplepoint.sample_id=v_state_samplepoint.sample_id
LEFT JOIN dma ON dma.dma_id=samplepoint.dma_id
WHERE ((samplepoint.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



DROP VIEW IF EXISTS v_edit_element CASCADE;
CREATE VIEW v_edit_element AS SELECT
	element_id,
	code,
	elementcat_id,
	serial_number,
	element.dma_id,
	dma.macrodma_id,
	state,
	state_type,
	annotation,
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
	link,
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
LEFT JOIN dma ON dma.dma_id=element.dma_id
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
 