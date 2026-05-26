/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_element_x_gully
AS SELECT element_x_gully.gully_id,
    element_x_gully.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.updated_at
FROM element_x_gully
JOIN element ON element.element_id::text = element_x_gully.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_gully
AS SELECT element_x_gully.gully_id,
    element_x_gully.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element_x_gully.gully_uuid
FROM element_x_gully
JOIN element ON element.element_id = element_x_gully.element_id
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
JOIN cat_feature ON cat_feature.id::text = cfe.id::text;