/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4434, 'Trying to connect %feature_type% with id %connect_id% to the closest arc.', NULL, 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4436, 'Trying to connect %feature_type% with id %connect_id% to the closest arc at a maximum distance of %max_distance% meters.', NULL, 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4438, 'Trying to connect %feature_type% with id %connect_id% to the closest arc with a diameter smaller than %check_arcdnom%.', NULL, 0, true, 'generic', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4440, 'Trying to connect %feature_type% with id %connect_id% to the closest arc with a diameter smaller than %check_arcdnom% meters and at a maximum distance of %max_distance% meters.', NULL, 0, true, 'generic', 'core', 'AUDIT');

-- gw_fct_set_hydrometers (3520)
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3520, 'gw_fct_set_hydrometers', 'utils', 'function', 'json', 'json', 'Function to set hydrometers in the database.', NULL, NULL, 'core', NULL);
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4448, 'Invalid action: %action%. Must be INSERT, UPDATE, DELETE or REPLACE.', 'Check the action parameter in your request.', 2, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4450, 'No hydrometers provided in the request.', 'The hydrometers array cannot be empty. Provide at least one hydrometer.', 2, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4452, 'Code is required for hydrometer #%hydrometer% when using INSERT or REPLACE action.', 'Provide a valid code for each hydrometer.', 1, true, 'utils', 'core', 'UI');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4454, 'Hydrometer with code %code% not found for UPDATE operation.', 'Verify that the hydrometer exists in the database.', 2, true, 'utils', 'core', 'UI');

-- move there is and there are messages to -2 and -3, TEMPORARY SOLUTION
UPDATE sys_message
SET id=-3
WHERE id=5002;
UPDATE sys_message
SET id=-2
WHERE id=5000;

UPDATE sys_message
SET id=4456
WHERE id=5008;
UPDATE sys_message
SET id=4458
WHERE id=5010;

INSERT INTO sys_message (id,error_message,log_level,show_user,project_type,"source",message_type)
VALUES (4460,'Used plan psectors: %v_psectors%',0,true,'ud','core','UI');

INSERT INTO sys_message (id,error_message,log_level,show_user,project_type,"source",message_type)
VALUES (4462,'Commit changes: %v_commit_changes%',0,true,'ud','core','UI');

UPDATE config_form_fields SET label = 'Sys elev 2:' WHERE label = 'Elevation of the selected node 2:';

-- 06/11/2025
-- When updating y1, custom_y1, elev1, or custom_elev1, also refresh node_2 fields
UPDATE config_form_fields 
SET widgetcontrols = '{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2", "slope"]}'::json
WHERE columnname IN ('y1', 'custom_y1', 'elev1', 'custom_elev1')
AND formname LIKE 've_arc_%'
AND formtype = 'form_feature'
AND widgetcontrols::text LIKE '%autoupdateReloadFields%';

-- When updating y2, custom_y2, elev2, or custom_elev2, also refresh node_1 fields
UPDATE config_form_fields 
SET widgetcontrols = '{"autoupdateReloadFields":["node_1", "y1", "custom_y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2", "slope"]}'::json
WHERE columnname IN ('y2', 'custom_y2', 'elev2', 'custom_elev2')
AND formname LIKE 've_arc_%'
AND formtype = 'form_feature'
AND widgetcontrols::text LIKE '%autoupdateReloadFields%';

DO
$$
DECLARE
    v_rec record;
BEGIN
    FOR v_rec IN SELECT fid, except_msg FROM sys_fprocess LOOP
        IF right(v_rec.except_msg, 1) <> '.' AND right(v_rec.except_msg, 1) <> '!' AND right(v_rec.except_msg, 1) <> '?' THEN
            UPDATE sys_fprocess
            SET except_msg = v_rec.except_msg || '.'
            WHERE fid = v_rec.fid;
        END IF;
    END LOOP;
END;
$$;


UPDATE sys_fprocess SET query_text='SELECT a.node_id, a.nodecat_id, a.expl_id, a.the_geom FROM t_node a 
JOIN cat_node b ON a.nodecat_id = b.id
JOIN cat_feature_node c ON c.id = b.node_type
JOIN dma d ON d.dma_id = a.dma_id
WHERE d.active IS FALSE
AND ''DMA'' = ANY(c.graph_delimiter)' WHERE fid=636;

UPDATE sys_fprocess SET query_text='SELECT a.node_id, a.nodecat_id, a.expl_id, a.the_geom FROM node a 
JOIN cat_node b ON a.nodecat_id = b.id
JOIN cat_feature_node c ON c.id = b.node_type
JOIN presszone d ON d.presszone_id = a.presszone_id
WHERE d.active IS FALSE
AND ''PRESSZONE'' = ANY(c.graph_delimiter)' WHERE fid=182;

UPDATE sys_fprocess SET except_msg = 'arcs with length shorter than value set as node proximity. Please, check your data before continue.', 
query_text='SELECT arc_id,arccat_id,st_length(the_geom), the_geom, expl_id
FROM t_arc, config_param_system where parameter = ''edit_node_proximity'' 
and  st_length(the_geom) < json_extract_path_text(value::json,''value'')::numeric ' WHERE fid=391;

UPDATE config_param_system
	SET value='{"id":"EUR", "descript":"EURO", "symbol":"€", "separator":".", "decimals":true}'
	WHERE "parameter"='admin_currency';

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,"source")
	VALUES (3524,'gw_fct_set_currency_config','utils','function','num','num','Function to transform nuemric values of price to user configuration from admin_currency in config_param_system','core');

UPDATE sys_table SET id = 'v_rtc_hydrometer_x_connec' WHERE id = 'v_hydrometer_x_connec';

do $$
DECLARE
    column_name TEXT;
    v_admin_control_trigger BOOLEAN;
    table_name CONSTANT TEXT := 'config_form_fields';
    table_records RECORD;
BEGIN
    -- Store and disable the config control trigger
    SELECT value::boolean INTO v_admin_control_trigger 
    FROM config_param_system 
    WHERE parameter = 'admin_config_control_trigger';
    
    UPDATE config_param_system 
    SET value = 'FALSE' 
    WHERE parameter = 'admin_config_control_trigger';
    
    -- Perform the replacements
    FOR table_records IN SELECT formname, formtype, columnname, tabname, label, tooltip FROM config_form_fields WHERE label LIKE '%ID%' OR tooltip LIKE '%ID%' LOOP
        UPDATE config_form_fields
            SET label = regexp_replace(table_records.label, '\mID\M', 'Id', 'g'),
                tooltip = regexp_replace(table_records.tooltip, '\mID\M', 'Id', 'g')
            WHERE formname = table_records.formname
                AND formtype = table_records.formtype
                AND columnname = table_records.columnname
                AND tabname = table_records.tabname;

        -- Step 2: Capitalize only the first letter of each entry
        UPDATE config_form_fields
            SET label = UPPER(LEFT(label, 1)) || SUBSTRING(label FROM 2),
                tooltip = UPPER(LEFT(tooltip, 1)) || SUBSTRING(tooltip FROM 2)
            WHERE formname = table_records.formname
                AND formtype = table_records.formtype
                AND columnname = table_records.columnname
                AND tabname = table_records.tabname;
    END LOOP;
    
    -- Restore the original trigger setting
    IF v_admin_control_trigger IS NOT NULL THEN
        UPDATE config_param_system 
        SET value = v_admin_control_trigger::text 
        WHERE parameter = 'admin_config_control_trigger';
    END IF;
END;
$$;

UPDATE sys_fprocess SET except_msg = 'registers on arc''s catalog with null values on dint column.' WHERE fid=283;
UPDATE sys_message SET error_message = 'No node was found at these coordinates' WHERE id=3694;

-- 24/11/2025
UPDATE config_form_fields SET dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE '
WHERE formname ilike 've_%' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

-- 01/12/2025
UPDATE config_form_fields
SET iseditable=false
WHERE formname='ve_dimensions' AND formtype='form_feature' AND columnname='feature_type' AND tabname='tab_none';

-- 03/12/2025
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','id','string','text','Id:','id',true,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','code','string','text','Code:','code',true,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','parameter_type','string','text','Parameter type:','parameter_type',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,dv_querytext,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','feature_type','string','combo','Feature type:','feature_type',false,true,'SELECT DISTINCT feature_type as id, feature_type as idval FROM cat_feature',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','data_type','string','text','Data type:','data_type',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','critcity','integer','text','Critcity:','critcity',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','descript','string','text','Descript:','descript',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','form_type','string','text','Form type:','form_type',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','vdefault','string','text','Default:','vdefault',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','ismultifeature','boolean','check','Is multifeature:','ismultifeature',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','short_descript','string','text','Short descript:','short_descript',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('config_visit_parameter','form_feature','tab_none','active','boolean','check','Active:','active',false,true,false);

-- Om_visit_type
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','id','string','text','Id:','id',true,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','name','string','text','Name:','name',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','startdate','datetime','text','Start date:','startdate',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','enddate','datetime','text','End date:','enddate',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','descript','string','text','Descript:','descript',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','active','boolean','check','Active:','active',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','extusercat_id','integer','text','Extsuercat id:','extusercat_id',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','duration','string','text','Duration:','duration',false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,dv_querytext,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','feature_type','string','combo','Feature Type:','feature_type',false,true,'SELECT DISTINCT feature_type as id, feature_type as idval FROM cat_feature',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden)
	VALUES ('om_visit_cat','form_feature','tab_none','alias','string','text','Alias:','alias',false,true,false);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES (4464, 'The selected catalog is not available for the feature type selected', 'Select another catalog', 2, true, 'utils', 'core');

-- 4/12/2025
ALTER TABLE sys_fprocess 
ALTER COLUMN fprocess_name TYPE VARCHAR(250);

-- 09/12/2025
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        -- ve_exploitation
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('ve_exploitation','form_feature','tab_none','sector_id','string','multiple_option','Secotr id:','sector_id - Sector id',false,false,true,false,'select sector_id AS id, name AS idval from ve_sector where sector_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('ve_exploitation','form_feature','tab_none','muni_id','string','multiple_option','Municipality id','muni_id -Municipality id',false,false,true,false,'select muni_id AS id, name AS idval from utils.municipality where muni_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "utils.ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);

        -- utils.municipality
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('ext_municipality','form_feature','tab_none','sector_id','string','multiple_option','Secotr id:','sector_id - Sector id',false,false,true,false,'select sector_id AS id, name AS idval from ve_sector where sector_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('ext_municipality','form_feature','tab_none','expl_id','string','multiple_option','Exploitation id:','expl_id - Exploitation id',false,false,true,false,'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);
    
        -- ve_sector
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_sector' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from utils.ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "utils.ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_sector' AND columnname = 'muni_id';

        -- ve_dma
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dma' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from utils.ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "utils.ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dma' AND columnname = 'muni_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dma' AND columnname = 'sector_id';
        
        -- ve_presszone
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_presszone' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from utils.ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "utils.ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_presszone' AND columnname = 'muni_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_presszone' AND columnname = 'sector_id';
        
        -- ve_dqa
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dqa' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from utils.ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "utils.ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dqa' AND columnname = 'muni_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dqa' AND columnname = 'sector_id';
        
    ELSE 
        -- ve_exploitation
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('ve_exploitation','form_feature','tab_none','sector_id','string','multiple_option','Secotr id:','sector_id - Sector id',false,false,true,false,'select sector_id AS id, name AS idval from ve_sector where sector_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('ve_exploitation','form_feature','tab_none','muni_id','string','multiple_option','Municipality id','muni_id -Municipality id',false,false,true,false,'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);
        
        -- v_ext_municipality
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('v_ext_municipality','form_feature','tab_none','sector_id','string','multiple_option','Secotr id:','sector_id - Sector id',false,false,true,false,'select sector_id AS id, name AS idval from ve_sector where sector_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);
        INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
            VALUES ('v_ext_municipality','form_feature','tab_none','expl_id','string','multiple_option','Exploitation id:','expl_id - Exploitation id',false,false,true,false,'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0','{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::json,false);

        -- ve_sector
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_sector' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_sector' AND columnname = 'muni_id';

        -- ve_dma
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dma' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dma' AND columnname = 'muni_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dma' AND columnname = 'sector_id';
        
        -- ve_presszone
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_presszone' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_presszone' AND columnname = 'muni_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_presszone' AND columnname = 'sector_id';
        
        -- ve_dqa
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dqa' AND columnname = 'expl_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dqa' AND columnname = 'muni_id';
        UPDATE config_form_fields SET widgettype = 'multiple_option', dv_querytext = 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', widgetcontrols = (COALESCE(widgetcontrols::jsonb, '{}'::jsonb) || '{"valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "nofColumns": 2, "filterExpression": null, "allowMulti": true}}'::jsonb)::json WHERE formname = 've_dqa' AND columnname = 'sector_id';
        
    END IF;
END;
$$;

-- cat_material
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_material','form_feature','tab_none','feature_type','string','multiple_option','Feature type','feature_type - Feature Type',false,false,true,false,'select id, id as idval from sys_feature_type',true,false,'{"valueRelation":{"nullValue":false, "allowMulti": true, "layer": "sys_feature_type", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('cat_material','form_feature','tab_none','featurecat_id','string','multiple_option','Featurecat id','featurecat_id',false,false,true,false,'select id, id as idval from cat_feature',true,false,'{"valueRelation":{"nullValue":false, "allowMulti": true, "layer": "cat_feature", "activated": true, "keyColumn": "id", "valueColumn": "id", "filterExpression": null, "nofColumns": 3}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate)
	VALUES ('cat_material','form_feature','tab_none','id','string','text','Id','id - Id',true,false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate)
	VALUES ('cat_material','form_feature','tab_none','descript','string','text','Descript','id - Id',false,false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate)
	VALUES ('cat_material','form_feature','tab_none','n','string','text','N','id - Id',false,false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate)
	VALUES ('cat_material','form_feature','tab_none','link','string','text','Link','id - Id',false,false,true,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,hidden)
	VALUES ('cat_material','form_feature','tab_none','active','boolean','check','Active','id - Id',false,false,true,false,false);


UPDATE config_form_tableview
SET alias = 
    -- 1. Take the first character and Uppercase it
    UPPER(SUBSTR(
        REPLACE(
            CASE 
                WHEN alias IS NOT NULL THEN REGEXP_REPLACE(alias, '[:.]$', '') 
                ELSE columnname 
            END, 
            '_', ' '
        ), 
    1, 1)) 
    || -- Concatenate
    -- 2. Take the rest of the string (from pos 2) and Lowercase it
    LOWER(SUBSTR(
        REPLACE(
            CASE 
                WHEN alias IS NOT NULL THEN REGEXP_REPLACE(alias, '[:.]$', '') 
                ELSE columnname 
            END, 
            '_', ' '
        ), 
    2));

-- 12/12/2025
-- Config_form_fields
UPDATE config_form_fields
	SET "label"='Sys elev2:'
	WHERE label = 'Elevation of the selected node 2:';

UPDATE config_form_tableview
    SET alias = 'roughness'
    WHERE objectname = 'cat_mat_roughness' AND columnname = 'roughness';