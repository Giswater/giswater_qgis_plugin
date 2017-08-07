/*
This file is part of Giswater 2.0
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
	featurecat_id
	dma_id,
	state,
	workcat_id,
	workcat_id_end,
	rotation,
	street1,
	street2,
	place_name,
	cabinet,
	observations,
	the_geom,
	samplepoint.expl_id
FROM selector_expl,samplepoint
WHERE ((samplepoint.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());



DROP VIEW IF EXISTS v_edit_element CASCADE;
CREATE VIEW v_edit_element AS SELECT
	element_id,
	elementcat_id,
	code,
	serial_number,
	state,
	annotation,
	observ,
	comment,
	location_type,
	workcat_id,
	buildercat_id,
	builtdate,
	ownercat_id,
	enddate AS enddate,
	rotation,
	link,
	verified,
	workcat_id_end,
	the_geom,
	element.expl_id
FROM selector_expl,element
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
    dimensions.state
FROM selector_expl,dimensions
WHERE ((dimensions.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
 