/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_message SET error_message = 'The %feature_type% with id %connec_id% has been successfully connected to the arc with id %arc_id%'
WHERE id = 4430;

DELETE FROM config_form_fields WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';

UPDATE config_typevalue
SET idval = substring(idval FROM 12 FOR length(idval) - 12)
WHERE typevalue = 'sys_table_context' and idval like '{"levels":%';

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

    FOREACH rec IN ARRAY arr LOOP
        v_table := 'man_type_' || rec;
        v_column := rec || '_type';
        EXECUTE format('
            ALTER TABLE %I ADD CONSTRAINT %I_unique UNIQUE (%I, feature_type);
        ', v_table, v_table, v_column);
    END LOOP;
END $$;


UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''ARC''', '''ARC''=ANY(feature_type)')
WHERE columnname = 'function_type'
AND formname ILIKE 've_arc%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''NODE''', '''NODE''=ANY(feature_type)')
WHERE columnname = 'function_type'
AND formname ILIKE 've_node%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''CONNEC''', '''CONNEC''=ANY(feature_type)')
WHERE columnname = 'function_type'
AND formname ILIKE 've_connec%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type = ''ELEMENT''', '''ELEMENT''=ANY(feature_type)')
WHERE columnname = 'function_type'
AND formname ILIKE 've_element%';

--
UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''ARC''', '''ARC''=ANY(feature_type)')
WHERE columnname = 'location_type'
AND formname ILIKE 've_arc%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''NODE''', '''NODE''=ANY(feature_type)')
WHERE columnname = 'location_type'
AND formname ILIKE 've_node%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''CONNEC''', '''CONNEC''=ANY(feature_type)')
WHERE columnname = 'location_type'
AND formname ILIKE 've_connec%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type = ''ELEMENT''', '''ELEMENT''=ANY(feature_type)')
WHERE columnname = 'location_type'
AND formname ILIKE 've_element%';

-- 
UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''ARC''', '''ARC''=ANY(feature_type)')
WHERE columnname = 'category_type'
AND formname ILIKE 've_arc%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''NODE''', '''NODE''=ANY(feature_type)')
WHERE columnname = 'category_type'
AND formname ILIKE 've_node%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''CONNEC''', '''CONNEC''=ANY(feature_type)')
WHERE columnname = 'category_type'
AND formname ILIKE 've_connec%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type = ''ELEMENT''', '''ELEMENT''=ANY(feature_type)')
WHERE columnname = 'category_type'
AND formname ILIKE 've_element%';

INSERT INTO sys_message (id,error_message,log_level,show_user,project_type,"source",message_type)
	VALUES (4432,'PLEASE, SET SOME VALUE FOR STATE_TYPE FOR PLANIFIED OBJECTS (CONFIG DIALOG)',0,true,'utils','core','UI');

UPDATE plan_typevalue SET descript='The Psector is being planned.' WHERE typevalue='psector_status' AND id='1';
UPDATE plan_typevalue SET descript='The Psector is planned and ready to work with.' WHERE typevalue='psector_status' AND id='2';
UPDATE plan_typevalue SET descript='The Psector is being executed on the network.' WHERE typevalue='psector_status' AND id='3';
UPDATE plan_typevalue SET descript='The Psector has been executed.' WHERE typevalue='psector_status' AND id='4';
UPDATE plan_typevalue SET descript='The Psector has been executed, and the objects defined during the planning phase (additions and removals) have been automatically implemented.' WHERE typevalue='psector_status' AND id='5';
UPDATE plan_typevalue SET descript='The Psector has been executed and is now archived.' WHERE typevalue='psector_status' AND id='6';
UPDATE plan_typevalue SET descript='The Psector has been cancelled because it was not executed and archived at the same time.' WHERE typevalue='psector_status' AND id='7';
UPDATE plan_typevalue SET descript='The Psector was archived but has been restored.' WHERE typevalue='psector_status' AND id='8';
