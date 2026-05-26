/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_element_x_node;
DROP VIEW IF EXISTS v_element_x_arc;
DROP VIEW IF EXISTS v_element_x_connec; 
DROP VIEW IF EXISTS v_element_x_gully;
DROP VIEW IF EXISTS v_ui_element_x_arc;
DROP VIEW IF EXISTS v_ui_element_x_link;
DROP VIEW IF EXISTS v_ui_element_x_node;
DROP VIEW IF EXISTS v_ui_element_x_connec;
DROP VIEW IF EXISTS v_ui_element_x_gully;   

ALTER TABLE man_type_function DROP CONSTRAINT man_type_function_pkey;
ALTER TABLE man_type_category DROP CONSTRAINT man_type_category_pkey;
ALTER TABLE man_type_location DROP CONSTRAINT man_type_location_pkey;

ALTER TABLE man_type_function DROP CONSTRAINT man_type_function_unique;
ALTER TABLE man_type_category DROP CONSTRAINT man_type_category_unique;
ALTER TABLE man_type_location DROP CONSTRAINT man_type_location_unique;

ALTER TABLE man_type_function DROP CONSTRAINT man_type_function_feature_type_fkey;
ALTER TABLE man_type_category DROP CONSTRAINT man_type_category_feature_type_fkey;
ALTER TABLE man_type_location DROP CONSTRAINT man_type_location_feature_type_fkey;

ALTER TABLE man_type_function
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

ALTER TABLE man_type_category
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

ALTER TABLE man_type_location
ALTER COLUMN feature_type TYPE text[]
USING ARRAY[feature_type];

DO $$
DECLARE
    rec text;
    v_table text;
    v_column text;
    arr text[] := ARRAY['category', 'function', 'location'];
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
END $$;

ALTER TABLE man_type_function DROP COLUMN id;
ALTER TABLE man_type_category DROP COLUMN id;
ALTER TABLE man_type_location DROP COLUMN id;

ALTER TABLE man_type_function ADD CONSTRAINT man_type_function_pk PRIMARY KEY (function_type);
ALTER TABLE man_type_category ADD CONSTRAINT man_type_category_pk PRIMARY KEY (category_type);
ALTER TABLE man_type_location ADD CONSTRAINT man_type_location_pk PRIMARY KEY (location_type);

ALTER TABLE node ADD CONSTRAINT node_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE arc ADD CONSTRAINT arc_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE connec ADD CONSTRAINT connec_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE element ADD CONSTRAINT element_man_type_function_fk FOREIGN KEY (function_type) REFERENCES man_type_function(function_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE element ADD CONSTRAINT element_man_type_category_fk FOREIGN KEY (category_type) REFERENCES man_type_category(category_type) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE element ADD CONSTRAINT element_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE link ADD CONSTRAINT link_man_type_location_fk FOREIGN KEY (location_type) REFERENCES man_type_location(location_type) ON DELETE SET NULL ON UPDATE CASCADE;
