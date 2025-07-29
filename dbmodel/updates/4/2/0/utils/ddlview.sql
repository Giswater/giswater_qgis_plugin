/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW ve_frelem
AS WITH sel_state AS (
    SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
), sel_sector AS (
    SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
), sel_expl AS (
    SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
), sel_muni AS (
    SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
), element_selector AS (
    SELECT
        e.element_id,
        e.code,
        e.sys_code,
        e.top_elev,
        e.elementcat_id,
        e.num_elements,
        e.epa_type,
        e.state,
        e.state_type,
        e.expl_id,
        e.muni_id,
        e.sector_id,
        e.omzone_id,
        e.function_type,
        e.category_type,
        e.location_type,
        e.observ,
        e.comment,
        e.workcat_id,
        e.workcat_id_end,
        e.builtdate,
        e.enddate,
        e.ownercat_id,
        e.brand_id,
        e.model_id,
        e.serial_number,
        e.asset_id,
        e.verified,
        e.datasource,
        e.label_x,
        e.label_y,
        e.label_rotation,
        e.rotation,
        e.inventory,
        e.publish,
        e.trace_featuregeom,
        e.lock_level,
        e.expl_visibility,
        e.created_at,
        e.created_by,
        e.updated_at,
        e.updated_by,
        e.the_geom
    FROM element e
    WHERE EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = e.sector_id)
    AND EXISTS (SELECT 1 FROM sel_expl e WHERE e.expl_id = e.expl_id)
    AND EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = e.state)
    AND EXISTS (SELECT 1 FROM sel_muni m WHERE m.muni_id = e.muni_id)
), element_selected AS (
    SELECT 
        e.element_id,
        e.code,
        e.sys_code,
        e.top_elev,
        cat_element.element_type,
        e.elementcat_id,
        e.num_elements,
        e.epa_type,
        e.state,
        e.state_type,
        e.expl_id,
        e.muni_id,
        e.sector_id,
        e.omzone_id,
        e.function_type,
        e.category_type,
        e.location_type,
        e.observ,
        e.comment,
        cat_element.link,
        e.workcat_id,
        e.workcat_id_end,
        e.builtdate,
        e.enddate,
        e.ownercat_id,
        e.brand_id,
        e.model_id,
        e.serial_number,
        e.asset_id,
        e.verified,
        e.datasource,
        e.label_x,
        e.label_y,
        e.label_rotation,
        e.rotation,
        e.inventory,
        e.publish,
        e.trace_featuregeom,
        e.lock_level,
        e.expl_visibility,
        man_frelem.node_id,
        man_frelem.order_id,
        concat(man_frelem.node_id, '_FR', man_frelem.order_id) AS nodarc_id,
        man_frelem.to_arc,
        man_frelem.flwreg_length,
        st_x(st_endpoint(st_setsrid(st_makeline(e.the_geom, st_lineinterpolatepoint(a.the_geom, man_frelem.flwreg_length::double precision / st_length(a.the_geom))), 25831)::geometry(LineString,25831))) AS symbol_x,
        st_y(st_endpoint(st_setsrid(st_makeline(e.the_geom, st_lineinterpolatepoint(a.the_geom, man_frelem.flwreg_length::double precision / st_length(a.the_geom))), 25831)::geometry(LineString,25831))) AS symbol_y,
        e.created_at,
        e.created_by,
        e.updated_at,
        e.updated_by,
        e.the_geom
    FROM element_selector e
    JOIN cat_element ON e.elementcat_id::text = cat_element.id::text
    JOIN man_frelem ON e.element_id::text = man_frelem.element_id::text
    JOIN arc a ON a.arc_id = man_frelem.to_arc
)
SELECT * FROM element_selected;


CREATE OR REPLACE VIEW ve_genelem
AS WITH sel_state AS (
    SELECT selector_state.state_id FROM selector_state WHERE selector_state.cur_user = CURRENT_USER
), sel_sector AS (
    SELECT selector_sector.sector_id FROM selector_sector WHERE selector_sector.cur_user = CURRENT_USER
), sel_expl AS (
    SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
), sel_muni AS (
    SELECT selector_municipality.muni_id FROM selector_municipality WHERE selector_municipality.cur_user = CURRENT_USER
), element_selector AS (
    SELECT
        e.element_id,
        e.code,
        e.sys_code,
        e.top_elev,
        e.elementcat_id,
        e.num_elements,
        e.epa_type,
        e.state,
        e.state_type,
        e.expl_id,
        e.muni_id,
        e.sector_id,
        e.omzone_id,
        e.function_type,
        e.category_type,
        e.location_type,
        e.observ,
        e.comment,
        e.link,
        e.workcat_id,
        e.workcat_id_end,
        e.builtdate,
        e.enddate,
        e.ownercat_id,
        e.brand_id,
        e.model_id,
        e.serial_number,
        e.asset_id,
        e.verified,
        e.datasource,
        e.label_x,
        e.label_y,
        e.label_rotation,
        e.rotation,
        e.inventory,
        e.publish,
        e.trace_featuregeom,
        e.lock_level,
        e.expl_visibility,
        e.created_at,
        e.created_by,
        e.updated_at,
        e.updated_by,
        e.the_geom
    FROM element e
    WHERE EXISTS (SELECT 1 FROM sel_sector s WHERE s.sector_id = e.sector_id)
    AND EXISTS (SELECT 1 FROM sel_expl e WHERE e.expl_id = e.expl_id)
    AND EXISTS (SELECT 1 FROM sel_state s WHERE s.state_id = e.state)
    AND EXISTS (SELECT 1 FROM sel_muni m WHERE m.muni_id = e.muni_id)
), element_selected AS (
    SELECT 
        e.element_id,
        e.code,
        e.sys_code,
        e.top_elev,
        cat_element.element_type,
        e.elementcat_id,
        e.num_elements,
        e.epa_type,
        e.state,
        e.state_type,
        e.expl_id,
        e.muni_id,
        e.sector_id,
        e.omzone_id,
        e.function_type,
        e.category_type,
        e.location_type,
        e.observ,
        e.comment,
        e.link,
        e.workcat_id,
        e.workcat_id_end,
        e.builtdate,
        e.enddate,
        e.ownercat_id,
        e.brand_id,
        e.model_id,
        e.serial_number,
        e.asset_id,
        e.verified,
        e.datasource,
        e.label_x,
        e.label_y,
        e.label_rotation,
        e.rotation,
        e.inventory,
        e.publish,
        e.trace_featuregeom,
        e.lock_level,
        e.expl_visibility,
        e.created_at,
        e.created_by,
        e.updated_at,
        e.updated_by,
        e.the_geom
    FROM element_selector e
    JOIN cat_element ON e.elementcat_id::text = cat_element.id::text
    LEFT JOIN cat_feature_element ON cat_element.element_type::text = cat_feature_element.id::text
    JOIN man_genelem USING (element_id)
)
SELECT * FROM element_selected;