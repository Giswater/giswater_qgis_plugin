/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''ARC''', '''ARC''=ANY(feature_type)')
WHERE columnname = 'fluid_type'
AND formname ILIKE 've_arc%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''NODE''', '''NODE''=ANY(feature_type)')
WHERE columnname = 'fluid_type'
AND formname ILIKE 've_node%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''CONNEC''', '''CONNEC''=ANY(feature_type)')
WHERE columnname = 'fluid_type'
AND formname ILIKE 've_connec%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type = ''ELEMENT''', '''ELEMENT''=ANY(feature_type)')
WHERE columnname = 'fluid_type'
AND formname ILIKE 've_element%';

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
'
WHERE fid=422;

UPDATE sys_fprocess
SET query_text='
SELECT ''ARC'', arc_id, fluid_type 
FROM t_arc t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_fluid mt
	WHERE mt.fluid_type = t.fluid_type
	AND ''ARC'' = ANY(mt.feature_type)
)
AND fluid_type IS NOT NULL
UNION
SELECT ''NODE'', node_id, fluid_type 
FROM t_node t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_fluid mt
	WHERE mt.fluid_type = t.fluid_type
	AND ''NODE'' = ANY(mt.feature_type)
)
AND fluid_type IS NOT NULL
UNION
SELECT ''CONNEC'', connec_id, fluid_type 
FROM t_connec t
WHERE NOT EXISTS (
	SELECT 1
	FROM man_type_fluid mt
	WHERE mt.fluid_type = t.fluid_type
	AND ''CONNEC'' = ANY(mt.feature_type)
)
AND fluid_type IS NOT NULL
'
WHERE fid=423;

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
AND function_type IS NOT NULL
'
WHERE fid=424;
