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
