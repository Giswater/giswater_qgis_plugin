/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE gully ADD CONSTRAINT gully_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;

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

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE columnname = 'function_type'
AND formname ILIKE 've_gully%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE columnname = 'category_type'
AND formname ILIKE 've_gully%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE columnname = 'location_type'
AND formname ILIKE 've_gully%';

UPDATE sys_param_user
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE id ILIKE 'edit_gully_%'
AND dv_querytext ILIKE '%man_type%';

UPDATE sys_fprocess
SET query_text='
SELECT ''ARC'', arc_id, category_type 
FROM t_arc t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_category mt
	WHERE mt.category_type = t.category_type
	AND ''ARC'' = ANY(mt.feature_type)
)
AND category_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, category_type 
FROM t_node t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_category mt
	WHERE mt.category_type = t.category_type
	AND ''NODE'' = ANY(mt.feature_type)
)
AND category_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, category_type 
FROM t_connec t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_category mt
	WHERE mt.category_type = t.category_type
	AND ''CONNEC'' = ANY(mt.feature_type)
)
AND category_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, category_type 
FROM t_gully t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_category mt
	WHERE mt.category_type = t.category_type
	AND ''GULLY'' = ANY(mt.feature_type)
)
AND category_type IS NOT NULL
'
WHERE fid=421;

UPDATE sys_fprocess
SET query_text='
SELECT ''ARC'', arc_id, function_type 
FROM t_arc t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_function mt
	WHERE mt.function_type = t.function_type
	AND ''ARC'' = ANY(mt.feature_type)
)
AND function_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, function_type 
FROM t_node t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_function mt
	WHERE mt.function_type = t.function_type
	AND ''NODE'' = ANY(mt.feature_type)
)
AND function_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, function_type 
FROM t_connec t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_function mt
	WHERE mt.function_type = t.function_type
	AND ''CONNEC'' = ANY(mt.feature_type)
)
AND function_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, function_type 
FROM t_gully t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_function mt
	WHERE mt.function_type = t.function_type
	AND ''GULLY'' = ANY(mt.feature_type)
)
AND function_type IS NOT NULL
'
WHERE fid=550;

UPDATE sys_fprocess
SET query_text='
SELECT ''ARC'', arc_id, location_type 
FROM t_arc t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_location mt
	WHERE mt.location_type = t.location_type
	AND ''ARC'' = ANY(mt.feature_type)
)
AND location_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, location_type 
FROM t_node t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_location mt
	WHERE mt.location_type = t.location_type
	AND ''NODE'' = ANY(mt.feature_type)
)
AND location_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, location_type 
FROM t_connec t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_location mt
	WHERE mt.location_type = t.location_type
	AND ''CONNEC'' = ANY(mt.feature_type)
)
AND location_type IS NOT NULL
UNION
SELECT ''GULLY'', gully_id, location_type 
FROM t_gully t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_location mt
	WHERE mt.location_type = t.location_type
	AND ''GULLY'' = ANY(mt.feature_type)
)
AND location_type IS NOT NULL
'
WHERE fid=558;

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_gully FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('gully');
