/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE man_type_fluid DROP CONSTRAINT man_type_fluid_pkey;

ALTER TABLE man_type_fluid DROP CONSTRAINT man_type_fluid_unique;

ALTER TABLE man_type_fluid DROP CONSTRAINT man_type_fluid_feature_type_fkey;

ALTER TABLE man_type_fluid
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];


DO $$
DECLARE
    rec text;
    v_table text;
    v_column text;
    arr text[] := ARRAY['fluid'];
BEGIN
    FOREACH rec IN ARRAY arr LOOP
        v_table := 'man_type_' || rec;
        v_column := rec || '_type';
        EXECUTE format('
            UPDATE %I t
            SET 
            feature_type = merged.merged_array_col3,
            featurecat_id = merged.merged_array_col4
            FROM (
                SELECT 
                %I,
                array_agg(DISTINCT elem3) AS merged_array_col3,
                array_agg(DISTINCT elem4) AS merged_array_col4
            FROM %I
                    LEFT JOIN LATERAL unnest(feature_type) AS elem3 ON TRUE
                    LEFT JOIN LATERAL unnest(featurecat_id) AS elem4 ON TRUE
            GROUP BY %I
            ) AS merged
            WHERE t.%I = merged.%I;
        ', v_table, v_column, v_table, v_column, v_column, v_column);


        EXECUTE format('
            DELETE FROM %I t
            USING (
                SELECT id
                    FROM (
                        SELECT id,
                                ROW_NUMBER() OVER (PARTITION BY %I, feature_type, featurecat_id ORDER BY id) AS rn
                        FROM %I
                    ) sub
                WHERE rn > 1
            ) dup
            WHERE t.id = dup.id;
        ', v_table, v_column, v_table);
    END LOOP;

    FOREACH rec IN ARRAY arr LOOP
        v_table := 'man_type_' || rec;
        v_column := rec || '_type';
        EXECUTE format('
            ALTER TABLE %I ADD CONSTRAINT %I_unique UNIQUE (%I, feature_type);
        ', v_table, v_table, v_column);
    END LOOP;
END $$;

ALTER TABLE man_type_fluid DROP COLUMN id;
ALTER TABLE man_type_fluid ADD CONSTRAINT man_type_fluid_pk PRIMARY KEY (fluid_type);

ALTER TABLE node ADD CONSTRAINT node_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE link ADD CONSTRAINT link_man_type_fluid_fk FOREIGN KEY (fluid_type) REFERENCES man_type_fluid(fluid_type) ON DELETE SET NULL ON UPDATE CASCADE;

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
SET 
fprocess_name='Check fluid_type values exists on man_ table',
except_msg='features with fluid_type does not exists on man_type_fluid table.',
info_msg='All features has fluid_type informed on man_type_fluid table',
query_text='
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

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_fluid;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_fluid FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_fluid');
