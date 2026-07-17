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

CREATE OR REPLACE VIEW v_element_x_node
AS SELECT element_x_node.node_id,
    element_x_node.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.updated_at
FROM element_x_node
JOIN element ON element.element_id::text = element_x_node.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_element_x_arc
AS SELECT element_x_arc.arc_id,
    element_x_arc.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.updated_at
FROM element_x_arc
JOIN element ON element.element_id::text = element_x_arc.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_element_x_connec
AS SELECT element_x_connec.connec_id,
    element_x_connec.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.updated_at
FROM element_x_connec
JOIN element ON element.element_id::text = element_x_connec.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT element_x_arc.arc_id,
    element_x_arc.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element_x_arc.arc_uuid
FROM element_x_arc
JOIN element ON element.element_id::text = element_x_arc.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_link
AS SELECT element_x_link.link_id,
    element_x_link.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element_x_link.link_uuid
FROM element_x_link
JOIN element ON element.element_id::text = element_x_link.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT element_x_node.node_id,
    element_x_node.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element_x_node.node_uuid
FROM element_x_node
JOIN element ON element.element_id::text = element_x_node.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT element_x_connec.connec_id,
    element_x_connec.element_id,
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
    element.link,
    element.publish,
    element.inventory,
    element_x_connec.connec_uuid
FROM element_x_connec
JOIN element ON element.element_id::text = element_x_connec.element_id::text
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text 
    AND 'ELEMENT' = ANY(man_type_location.feature_type)
LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
JOIN cat_feature ON cat_feature.id::text = cfe.id::text;


UPDATE sys_message SET error_message = 'The %feature_type% with id %connec_id% has been successfully connected to the arc with id %arc_id%'
WHERE id = 4430;

DELETE FROM config_form_fields WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';

UPDATE config_typevalue
SET idval = substring(idval FROM 12 FOR length(idval) - 12)
WHERE typevalue = 'sys_table_context' and idval like '{"levels":%';

DELETE FROM sys_function WHERE id = 3346; -- gw_trg_mantypevalue_fk
DROP FUNCTION gw_trg_mantypevalue_fk() CASCADE;

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

UPDATE sys_param_user
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''ARC''', '''ARC''=ANY(feature_type)')
WHERE id ILIKE 'edit_arc_%'
AND dv_querytext ILIKE '%man_type%';

UPDATE sys_param_user
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''NODE''', '''NODE''=ANY(feature_type)')
WHERE id ILIKE 'edit_node_%'
AND dv_querytext ILIKE '%man_type%';

UPDATE sys_param_user
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''CONNEC''', '''CONNEC''=ANY(feature_type)')
WHERE id ILIKE 'edit_connec_%'
AND dv_querytext ILIKE '%man_type%';


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


DELETE FROM sys_label WHERE id=1006;
DELETE FROM sys_label WHERE id=1007;
DELETE FROM sys_label WHERE id=1008;
DELETE FROM sys_label WHERE id = 3013;

INSERT INTO sys_message (id,error_message,log_level,show_user,project_type,"source",message_type)
VALUES(4442, 'To check CRITICAL ERRORS or WARNINGS, execute a query FROM anl_table WHERE fid=error number AND current_user. For example:  SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;  Only the errors with anl_table next to the number can be checked this way. Using Giswater Toolbox it''s also posible to check these errors.',
0,true,'utils','core','AUDIT');


INSERT INTO sys_message (id, error_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4444, 'It is not allowed to change the exploitation because your current psector does not belong to the exploitation you have selected. Click on the Play button to exit psector mode and then, change the exploitation.', 0, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4446, 'It is not allowed to change the sector because your current psector does not belong to the sector you have selected. Click on the Play button to exit psector mode and then, change the sector.', 0, true, 'utils', 'core', 'UI');


CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('connec');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_link FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('link');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('node');

CREATE TRIGGER gw_trg_ui_element INSTEAD OF INSERT
OR DELETE
OR UPDATE ON
v_ui_element_x_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('arc');

DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_category;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_function;
DROP TRIGGER IF EXISTS gw_trg_config_control ON man_type_location;
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_category FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_category');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_function FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_function');
CREATE TRIGGER gw_trg_config_control AFTER INSERT OR UPDATE OF feature_type, featurecat_id ON man_type_location FOR EACH ROW EXECUTE FUNCTION gw_trg_config_control('man_type_location');
