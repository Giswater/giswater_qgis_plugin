/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DELETE FROM config_form_fields WHERE (formname ILIKE '%frelem%' OR formname ILIKE '%genelem%') AND tabname = 'tab_none';
DELETE FROM config_form_fields WHERE formname ILIKE '%frelem%' AND columnname = 'nodarc_id';

-- 05/08/2025
UPDATE config_form_fields SET dv_querytext = 'WITH check_value AS (
  SELECT value::integer AS psector_value 
  FROM config_param_user 
  WHERE parameter = ''plan_psector_current''
  AND cur_user = current_user
)
SELECT id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT psector_value FROM check_value) IS NULL THEN id != 2 
  ELSE id=2 
END' WHERE columnname = 'state';


-- 06/08/2025
-- Add brand and model to ve_node, ve_arc, ve_connec, ve_element, ve_frelem, ve_genelem
  -- Existing ones
    -- Brand_id
UPDATE config_form_fields SET dv_querytext = NULL, label = 'Brand', isparent = false, isautoupdate = false, widgetcontrols = '{"setMultiline":false}'::json
WHERE columnname = 'brand_id' AND formtype = 'form_feature' AND tabname = 'tab_data';

DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='brand_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

    -- Model_id
UPDATE config_form_fields SET dv_querytext = NULL, label = 'Model', isparent = false, isautoupdate = false, widgetcontrols = '{"setMultiline":false}'::json
WHERE columnname = 'model_id' AND formtype = 'form_feature' AND tabname = 'tab_data';

DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='model_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand_model WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

  -- New ones
    -- brand_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT DISTINCT formname, formtype, tabname FROM config_form_fields cff WHERE formname ILIKE ANY (ARRAY['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
      AND tabname = 'tab_data' AND formtype = 'form_feature' AND NOT EXISTS (SELECT 1 FROM config_form_fields cff2 WHERE cff2.formname = cff.formname AND cff2.formtype = cff.formtype
      AND cff2.tabname = cff.tabname AND cff2.columnname = 'brand_id')
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');

    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden) VALUES
    (rec.formname, rec.formtype, rec.tabname, 'brand_id', 'lyt_data_2', v_layoutorder, 'text', 'combo', 'Brand id', 'brand_id', false, false, true, false, v_dv_querytext, false);
  END LOOP;
END $$;

    -- model_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT DISTINCT formname, formtype, tabname FROM config_form_fields cff WHERE formname ILIKE ANY (ARRAY['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
      AND tabname = 'tab_data' AND formtype = 'form_feature' AND NOT EXISTS (SELECT 1 FROM config_form_fields cff2 WHERE cff2.formname = cff.formname AND cff2.formtype = cff.formtype
      AND cff2.tabname = cff.tabname AND cff2.columnname = 'model_id')
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand_model WHERE %L = ANY(featurecat_id::text[])', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');

    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, label, tooltip, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, hidden) VALUES
    (rec.formname, rec.formtype, rec.tabname, 'model_id', 'lyt_data_2', v_layoutorder, 'text', 'combo', 'Model id', 'model_id', false, false, true, false, v_dv_querytext, false);
  END LOOP;
END $$;

	-- ve_connec
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,dv_querytext,hidden)
	VALUES ('ve_connec','form_feature','tab_data','brand_id','lyt_data_2',23,'text','text','Brand','brand_id',false,true,NULL,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,dv_querytext,hidden)
	VALUES ('ve_connec','form_feature','tab_data','model_id','lyt_data_2',24,'text','text','Model','model_id',false,true,NULL,false);

    -- ve_gully
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,dv_querytext,hidden)
	VALUES ('ve_gully','form_feature','tab_data','brand_id','lyt_data_2',23,'text','text','Brand','brand_id',false,true,NULL,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,dv_querytext,hidden)
	VALUES ('ve_gully','form_feature','tab_data','model_id','lyt_data_2',24,'text','text','Model','model_id',false,true,NULL,false);

  -- Elements
    -- ve_frelem
      -- eorifice
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eorifice','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EORIFICE'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eorifice','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EORIFICE'' = ANY(featurecat_id::text[])');

    -- eoutlet
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
    VALUES ('ve_frelem_eoutlet','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EOUTLET'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eoutlet','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EOUTLET'' = ANY(featurecat_id::text[])');

    -- epump
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_epump','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EPUMP'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_epump','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EPUMP'' = ANY(featurecat_id::text[])');

    -- eweir
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eweir','form_feature','tab_data','brand_id','lyt_data_1',13,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EWEIR'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_frelem_eweir','form_feature','tab_data','model_id','lyt_data_1',14,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EWEIR'' = ANY(featurecat_id::text[])');

UPDATE config_form_fields SET layoutorder=15 WHERE formname ILIKE 've_frelem_%' AND formtype='form_feature' AND columnname='rotation' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=16 WHERE formname ILIKE 've_frelem_%' AND formtype='form_feature' AND columnname='top_elev' AND tabname='tab_data';

    -- ve_genelem
      -- ecover
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_ecover','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''ECOVER'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_ecover','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''ECOVER'' = ANY(featurecat_id::text[])');

    -- egate
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
    VALUES ('ve_genelem_egate','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EGATE'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_egate','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EGATE'' = ANY(featurecat_id::text[])');

    -- eiot_sensor
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_eiot_sensor','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EIOT_SENSOR'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_eiot_sensor','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EIOT_SENSOR'' = ANY(featurecat_id::text[])');

    -- eprotector
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_eprotector','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''EPROTECTOR'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_eprotector','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''EPROTECTOR'' = ANY(featurecat_id::text[])');

    -- estep
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_estep','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''ESTEP'' = ANY(featurecat_id::text[])');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext)
	VALUES ('ve_genelem_estep','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''ESTEP'' = ANY(featurecat_id::text[])');

UPDATE config_form_fields SET layoutorder=14 WHERE formname ILIKE 've_genelem_%' AND formtype='form_feature' AND columnname='rotation' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=15 WHERE formname ILIKE 've_genelem_%' AND formtype='form_feature' AND columnname='top_elev' AND tabname='tab_data';


-- Generate base element
DELETE FROM config_form_fields WHERE formname = 've_element';

INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','sector_id','lyt_bot_1',1,'integer','combo','Sector ID','Sector ID',false,false,true,false,'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL',true,false,'{"label":"color:blue; font-weight:bold;"}'::json,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','state','lyt_bot_1',2,'integer','combo','State','State',false,false,true,false,'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','state_type','lyt_bot_1',3,'integer','combo','State Type','State Type',false,false,true,false,'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','code','lyt_data_1',1,'string','text','Code','Code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','num_elements','lyt_data_1',2,'integer','text','Number of Elements','Number of Elements',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','comment','lyt_data_1',3,'string','text','Comments','Comments',false,false,true,false,'{"setMultiline":true}'::json,true);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','function_type','lyt_data_1',4,'string','combo','Function Type','Function Type',false,false,true,false,'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','category_type','lyt_data_1',5,'string','combo','Category Type','Category Type',false,false,true,false,'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','location_type','lyt_data_1',6,'string','combo','Location Type','Location Type',false,false,true,false,'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT'' OR ''EORIFICE'' = ANY(featurecat_id::text[])',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_data','workcat_id','lyt_data_1',7,'string','typeahead','Workcat ID','Workcat ID',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,'action_workcat',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','workcat_id_end','lyt_data_1',8,'string','typeahead','Workcat ID End','Workcat ID End','Only when state is obsolete',false,false,true,false,'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL AND active IS TRUE','{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','builtdate','lyt_data_1',9,'date','datetime','Built Date','Built Date',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','enddate','lyt_data_1',10,'date','datetime','End Date','End Date',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','ownercat_id','lyt_data_1',11,'string','combo','Owner Catalog','Owner Catalog',false,false,true,false,'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL AND active IS TRUE',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
	VALUES ('ve_element','form_feature','tab_data','brand_id','lyt_data_1',12,'text','combo','Brand','brand_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand WHERE ''GENELEM'' = ANY(featurecat_id::text[])', false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,hidden)
	VALUES ('ve_element','form_feature','tab_data','model_id','lyt_data_1',13,'text','combo','Model','model_id',false,false,true,false,'SELECT id, id as idval FROM cat_brand_model WHERE ''GENELEM'' = ANY(featurecat_id::text[])',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','rotation','lyt_data_1',12,'double','text','Rotation','Rotation',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','top_elev','lyt_data_1',13,'double','text','Top Elevation','Top Elevation',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','expl_id','lyt_data_2',1,'integer','combo','Exploitation ID','Exploitation ID',false,false,true,false,'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL',true,false,'{"label":"color:green; font-weight:bold;"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,dv_querytext,dv_orderby_id,dv_isnullvalue,hidden)
	VALUES ('ve_element','form_feature','tab_data','muni_id','lyt_data_3',1,'string','combo','Municipality id:','muni_id - Identifier of the municipality',false,false,true,'SELECT muni_id as id, name as idval from v_ext_municipality WHERE muni_id IS NOT NULL',true,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','observ','lyt_data_3',2,'string','text','Observations','Observations',false,false,true,false,'{"setMultiline":true}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','elementcat_id','lyt_top_1',1,'string','combo','Element Catalog','Element Catalog',true,false,true,false,'SELECT id, id as idval FROM cat_element WHERE element_type = ''ECOVER''',true,false,'{"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_data','element_id','lyt_top_1',2,'string','text','Element ID','Element ID',false,false,false,false,'{"saveValue":false,"setMultiline": false, "labelPosition": "top"}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_insert','lyt_features_1',1,'button',false,false,true,false,false,'{
  "icon": "111"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "insert_feature",
  "parameters": {
    "targetwidget": "tab_features_feature_id"
  }
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_delete','lyt_features_1',2,'button',false,false,true,false,false,'{
  "icon": "112"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "delete_object",
  "parameters": {
    "columnfind": "element_id",
    "targetwidget": "tab_features_tbl_element",
    "sourceview": "element"
  }
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,widgetfunction,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_snapping','lyt_features_1',3,'button',false,false,true,false,false,'{
  "icon": "137"
}'::json,'{
  "saveValue": false
}'::json,'{
  "functionName": "selection_init"
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,ismandatory,isparent,iseditable,isautoupdate,isfilter,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_element','form_feature','tab_features','btn_expr_select','lyt_features_1',4,'button',false,false,true,false,false,'{
  "icon": "178"
}'::json,'{
  "saveValue": false
}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_arc','lyt_features_2_arc',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_arc",
  "featureType": "arc"
}'::json,'tbl_element_x_arc',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_connec','lyt_features_2_connec',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_connec",
  "featureType": "connec"
}'::json,'tbl_element_x_connec',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_gully','lyt_features_2_gully',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_gully",
  "featureType": "gully"
}'::json,'tbl_element_x_gully',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_link','lyt_features_2_link',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_link",
  "featureType": "link"
}'::json,'tbl_element_x_link',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,widgetcontrols,linkedobject,hidden)
	VALUES ('ve_element','form_feature','tab_features','tbl_element_x_node','lyt_features_2_node',0,'tableview','','',false,false,false,false,false,'{
  "saveValue": false,
  "tableUpsert": "v_ui_element_x_node",
  "featureType": "node"
}'::json,'tbl_element_x_node',false);

-- Config_form_fields
DO $$
DECLARE
  rec record;
BEGIN
-- frelem
  FOR rec IN (SELECT * FROM config_form_fields WHERE formname ILIKE '%frelem_%')
  LOOP
    UPDATE config_form_fields SET formname = replace(rec.formname, 'frelem', 'element') WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND columnname = rec.columnname;
  END LOOP;
  -- genelem
  FOR rec IN (SELECT * FROM config_form_fields WHERE formname ILIKE '%genelem_%')
  LOOP
    UPDATE config_form_fields SET formname = replace(rec.formname, 'genelem', 'element') WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND columnname = rec.columnname;
  END LOOP;
END $$;

-- 12/08/2025
DELETE FROM config_form_fields WHERE formname ILIKE '%element%' AND formtype='form_feature' AND columnname='order_id' AND tabname='tab_data';
UPDATE config_form_fields SET layoutorder=4 WHERE formname ILIKE '%element%' AND formtype='form_feature'AND tabname='tab_data' AND columnname='expl_id' AND layoutorder=5;
UPDATE config_form_fields
	SET layoutorder=3
	WHERE formname='ve_element_epump' AND formtype='form_feature' AND columnname='flwreg_length' AND tabname='tab_data';
UPDATE config_form_fields
	SET layoutorder=2
	WHERE formname='ve_element_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';

-- Editable, datatype and mandatory fields for frelemnts
UPDATE config_form_fields
	SET ismandatory=true,iseditable=true
	WHERE formname='ve_element_epump' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true,"datatype"='integer'
	WHERE formname='ve_element_eorifice' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true,"datatype"='integer'
	WHERE formname='ve_element_eoutlet' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';
UPDATE config_form_fields
	SET iseditable=true,"datatype"='integer'
	WHERE formname='ve_element_eweir' AND formtype='form_feature' AND columnname='to_arc' AND tabname='tab_data';


-- last update
-- last update
-- Normalize "label": replace underscores with spaces, trim, ensure only the first letter is uppercase,
-- and append a colon if missing. Only updates rows needing changes.
UPDATE config_form_fields
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        formname, formtype, columnname, tabname,
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM config_form_fields
) AS sub
WHERE config_form_fields.formname   = sub.formname
  AND config_form_fields.formtype   = sub.formtype
  AND config_form_fields.columnname = sub.columnname
  AND config_form_fields.tabname    = sub.tabname
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );

UPDATE config_param_system
SET "label" =
    UPPER(LEFT(cleaned, 1)) ||
    SUBSTRING(cleaned FROM 2) ||
    CASE WHEN RIGHT(cleaned, 1) = ':' THEN '' ELSE ':' END
FROM (
    SELECT
        "parameter",
        TRIM(
            regexp_replace(
                regexp_replace(replace("label", '_', ' '), '\s+', ' ', 'g'),
                '\s+$', '', 'g'
            )
        ) AS cleaned
    FROM config_param_system
) AS sub
WHERE config_param_system."parameter" = sub."parameter"
  AND "label" IS NOT NULL
  AND (
        LEFT("label", 1) <> UPPER(LEFT("label", 1))
     OR RIGHT(sub.cleaned, 1) <> ':'
  );

UPDATE config_form_fields SET widgetcontrols='{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'::json WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='expl_id' AND tabname='tab_data';

UPDATE config_form_fields SET "datatype"='string', widgettype='combo', ismandatory=true, iseditable=true, dv_querytext='SELECT id, idval FROM om_typevalue WHERE typevalue = ''fluid_type''', dv_isnullvalue=true WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='fluid_type' AND tabname='tab_data';

DELETE FROM config_form_fields WHERE formname ILIKE '%ve_link%' AND formtype='form_feature' AND columnname='n_hydrometer' AND tabname='tab_none';

DELETE FROM config_form_fields WHERE formname ILIKE '%ve_gully%' AND formtype='form_feature' AND columnname IN ('connec_y1', 'connec_y2') AND tabname='tab_none';

-- 08/08/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2)
ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
DELETE FROM config_form_fields WHERE formname ILIKE '%ve_gully%' AND formtype='form_feature' AND columnname IN ('connec_y1', 'connec_y2') AND tabname='tab_none';

-- 08/08/2025
DELETE FROM config_form_fields WHERE formname ILIKE '%elem%' AND formtype='form_feature' AND columnname='element_id' AND tabname='tab_data';

-- 12/08/2025

DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT child_layer FROM cat_feature WHERE feature_class = 'VALVE')
  LOOP
    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
    "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
    dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
    stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES(rec.child_layer, 'form_feature', 'tab_data', 'flowsetting', 'lyt_data_2', (SELECT max(layoutorder) + 1 AS layoutorder FROM config_form_fields WHERE formname = rec.child_layer AND tabname = 'tab_data' AND layoutname = 'lyt_data_2'),
    'numeric', 'text', 'Flow Setting:', 'Flow Setting:', NULL, false, false, true, false, NULL,
    NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, true, NULL)
    ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
    layoutorder = EXCLUDED.layoutorder,
    datatype = EXCLUDED.datatype,
    widgettype = EXCLUDED.widgettype,
    label = EXCLUDED.label,
    dv_querytext = EXCLUDED.dv_querytext,
    dv_orderby_id = EXCLUDED.dv_orderby_id,
    dv_isnullvalue = EXCLUDED.dv_isnullvalue,
    dv_parent_id = EXCLUDED.dv_parent_id,
    dv_querytext_filterc = EXCLUDED.dv_querytext_filterc,
    hidden = EXCLUDED.hidden;
  END LOOP;
END $$;

DELETE FROM config_form_fields WHERE formname ILIKE 've_element%' AND formtype='form_feature' AND columnname='tbl_element_x_gully' AND tabname='tab_features';

UPDATE config_form_fields SET dv_querytext =
'SELECT id, idval FROM inp_typevalue WHERE id IS NOT NULL AND typevalue=''inp_typevalue_outlet'''
WHERE formname = 've_epa_froutlet' and columnname = 'outlet_type';


UPDATE config_form_fields SET dv_querytext =
'WITH psector_value AS (
  		SELECT value::integer AS psector_value 
  		FROM config_param_user 
  		WHERE parameter = ''plan_psector_current'' AND cur_user = current_user),
	 tg_op_value AS (
  		SELECT value::text AS tg_op_value 
  		FROM config_param_user 
  		WHERE parameter = ''utils_transaction_mode'' AND cur_user = current_user)  
SELECT id::integer as id, name as idval
FROM value_state 
WHERE id IS NOT NULL 
AND CASE 
  WHEN (SELECT tg_op_value FROM tg_op_value)!=''INSERT'' THEN id IN (0,1,2)
  WHEN (SELECT tg_op_value FROM tg_op_value) =''INSERT'' AND (SELECT psector_value FROM psector_value) IS NOT NULL THEN id = 2 
  ELSE id < 2 
END' 
WHERE columnname = 'state';


update config_form_fields set dv_orderby_id = true where formtype ='psector' and columnname ='status';

-- Brand_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='brand_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand WHERE %L = ANY(featurecat_id::text[]) OR featurecat_id IS NULL', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;

-- Model_id
DO $$
DECLARE
  v_dv_querytext text;
  v_layoutorder integer;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='model_id' AND tabname='tab_data' AND formname ilike any(array['ve_node_%', 've_arc_%', 've_connec_%', 've_gully_%'])
  LOOP
    v_dv_querytext := format('SELECT id, id as idval FROM cat_brand_model WHERE %L = ANY(featurecat_id::text[]) OR featurecat_id IS NULL', upper(regexp_replace(rec.formname, '^ve_(node|arc|connec|gully)_', '', 'i')));
    v_layoutorder := (SELECT MAX(layoutorder) + 1 FROM config_form_fields WHERE formname = rec.formname AND formtype = rec.formtype AND tabname = rec.tabname AND layoutname = 'lyt_data_2');
	UPDATE config_form_fields SET dv_querytext = v_dv_querytext, widgettype = 'combo', layoutname = 'lyt_data_2', layoutorder = v_layoutorder WHERE formname = rec.formname AND formtype = rec.formtype AND columnname = rec.columnname AND tabname = rec.tabname;
  END LOOP;
END $$;


-- ve_dma
DELETE FROM config_form_fields where formname in ('v_ui_dma', 've_dma');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','dma_id','lyt_data_1',1,'integer','text','Dma id:','dma_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dma", "activated": true, "keyColumn": "dma_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','dma_type','lyt_data_1',6,'string','combo','Dma type:','dma_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dma_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,hidden)
	VALUES ('ve_dma','form_feature','tab_none','avg_press','lyt_data_1',10,'numeric','text','Average pressure:','avg_press',false,false,true,false,false,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','pattern_id','lyt_data_1',11,'string','combo','Pattern id:','pattern_id',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','effc','lyt_data_1',12,'string','text','Effc:','effc',false,false,true,false,false,'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL',true,true,'{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','graphconfig','lyt_data_1',13,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','stylesheet','lyt_data_1',14,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','lock_level','lyt_data_1',15,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','link','lyt_data_1',19,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','addparam','lyt_data_1',17,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_at','lyt_data_1',18,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','created_by','lyt_data_1',19,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_at','lyt_data_1',20,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dma','form_feature','tab_none','updated_by','lyt_data_1',21,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_dwfzone
DELETE FROM config_form_fields WHERE formname IN ('ve_dwfzone', 'v_ui_dwfzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','dwfzone_id','lyt_data_1',1,'integer','text','Dwfzone id:','dwfzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_dwfzone", "activated": true, "keyColumn": "dwfzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','dwfzone_type','lyt_data_1',6,'string','combo','Dwfzone type:','dwfzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''dwfzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','drainzone_id','lyt_data_1',7,'string','combo','Drainzone:','drainzone_id',false,false,true,false,'SELECT drainzone_id as id, name as idval FROM drainzone WHERE drainzone_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','graphconfig','lyt_data_1',11,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','stylesheet','lyt_data_1',12,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','lock_level','lyt_data_1',13,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','link','lyt_data_1',14,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','addparam','lyt_data_1',15,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','created_at','lyt_data_1',16,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','created_by','lyt_data_1',17,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','updated_at','lyt_data_1',18,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_dwfzone','form_feature','tab_none','updated_by','lyt_data_1',19,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_drainzone
DELETE FROM config_form_fields WHERE formname IN ('ve_drainzone', 'v_ui_drainzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','sector_id','lyt_data_1',8,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','drainzone_id','lyt_data_1',1,'integer','text','Drainzone id:','drainzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_drainzone", "activated": true, "keyColumn": "drainzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','drainzone_type','lyt_data_1',6,'string','combo','Drainzone type:','drainzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''drainzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','expl_id','lyt_data_1',7,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','graphconfig','lyt_data_1',10,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','stylesheet','lyt_data_1',11,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','lock_level','lyt_data_1',12,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','link','lyt_data_1',13,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','addparam','lyt_data_1',14,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','created_at','lyt_data_1',15,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','created_by','lyt_data_1',16,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','updated_at','lyt_data_1',17,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_drainzone','form_feature','tab_none','updated_by','lyt_data_1',18,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_omzone
DELETE FROM config_form_fields WHERE formname IN ('ve_omzone', 'v_ui_omzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','omzone_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','omzone_type','lyt_data_1',6,'string','combo','Omzone type:','omzone_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''omzone_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','macroomzone_id','lyt_data_1',7,'string','combo','Macroomzone:','macroomzone_id',false,false,true,false,'SELECT macroomzone_id as id, name as idval FROM macroomzone WHERE macroomzone_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','muni_id','lyt_data_1',10,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','graphconfig','lyt_data_1',11,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','stylesheet','lyt_data_1',12,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','lock_level','lyt_data_1',13,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','link','lyt_data_1',14,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','addparam','lyt_data_1',15,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','created_at','lyt_data_1',16,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','created_by','lyt_data_1',17,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','updated_at','lyt_data_1',18,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_omzone','form_feature','tab_none','updated_by','lyt_data_1',19,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macroomzone
DELETE FROM config_form_fields WHERE formname IN ('ve_macroomzone', 'v_ui_macroomzone');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','macroomzone_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,true,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macroomzone','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_macrosector
DELETE FROM config_form_fields WHERE formname IN ('ve_macrosector', 'v_ui_macrosector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','sector_id','lyt_data_1',7,'integer','text','Sector id:','sector_id','Ex: {1,2}',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','macrosector_id','lyt_data_1',1,'integer','text','Omzone id:','omzone_id',false,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_omzone", "activated": true, "keyColumn": "omzone_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','expl_id','lyt_data_1',6,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','muni_id','lyt_data_1',8,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','stylesheet','lyt_data_1',9,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','lock_level','lyt_data_1',10,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','link','lyt_data_1',11,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','addparam','lyt_data_1',12,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','created_at','lyt_data_1',13,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','created_by','lyt_data_1',14,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','updated_at','lyt_data_1',15,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_macrosector','form_feature','tab_none','updated_by','lyt_data_1',16,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

-- ve_sector
DELETE FROM config_form_fields WHERE formname IN ('v_ui_sector','ve_sector');
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,stylesheet,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','sector_id','lyt_data_1',1,'integer','text','Sector id:','sector_id',true,false,false,false,'{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','code','lyt_data_1',2,'string','text','Code:','code',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','name','lyt_data_1',3,'string','text','Name:','name',true,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','descript','lyt_data_1',4,'string','text','Descript:','descript',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,isfilter,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','active','lyt_data_1',5,'boolean','check','Active:','active',false,false,true,false,false,false,'{"vdefault_value": true}',false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','sector_type','lyt_data_1',6,'string','combo','Sector type:','sector_type',false,false,true,false,'SELECT id, idval FROM edit_typevalue WHERE typevalue=''sector_type''',true,true,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,dv_orderby_id,dv_isnullvalue,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','macrosector_id','lyt_data_1',7,'string','combo','Macrosector id:','macrosector_id',false,false,true,false,'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL',true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','expl_id','lyt_data_1',8,'text','text','Expl id:','expl_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','muni_id','lyt_data_1',9,'text','text','Muni id:','muni_id','Ex: {1,2}',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','graphconfig','lyt_data_1',10,'string','text','Graphconfig:','graphconfig',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','stylesheet','lyt_data_1',11,'string','text','Stylesheet:','stylesheet',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','lock_level','lyt_data_1',12,'text','text','Lock level:','lock_level',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','link','lyt_data_1',13,'text','text','Link:','link',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','addparam','lyt_data_1',14,'text','text','Addparam:','addparam',false,false,true,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','created_at','lyt_data_1',15,'datetime','datetime','Created at:','created_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','created_by','lyt_data_1',16,'string','text','Created by:','created_by',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','updated_at','lyt_data_1',17,'datetime','datetime','Updated at:','updated_at',false,false,false,false,'{"setMultiline":false}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,widgetcontrols,hidden)
	VALUES ('ve_sector','form_feature','tab_none','updated_by','lyt_data_1',18,'string','text','Updated by:','updated_by',false,false,false,false,'{"setMultiline":false}'::json,false);

UPDATE config_form_fields SET widgettype='list' WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('expl_id', 'sector_id', 'muni_id');


UPDATE config_form_fields SET iseditable=true WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname = 'graphconfig';
UPDATE config_form_fields SET widgettype='text' WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('created_at', 'updated_at');

UPDATE config_form_fields SET placeholder=NULL WHERE formname IN('ve_dma', 've_sector', 've_macrosector', 've_omzone', 've_macroomzone', 've_dwfzone', 've_drainzone') AND columnname IN('expl_id', 'sector_id', 'muni_id') AND iseditable=false;

-- 16/09/2025
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_chamber' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_change' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_circ_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_highpoint' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_jump' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_junction' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_netgully' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_netinit' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_outfall' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_overflow_storage' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_pump_station' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_rect_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_register' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_sandbox' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_sewer_storage' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_valve' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_virtual_node' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_weir' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_wwtp' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_node_out_manhole' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_cjoin' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_connec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';
UPDATE config_form_fields
	SET "label"='Sector ID:'
	WHERE formname='ve_connec_vconnec' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

UPDATE config_form_fields SET layoutorder = 1 WHERE formname ilike 've_%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'sector_id' AND layoutname = 'lyt_bot_1';
UPDATE config_form_fields SET layoutorder = 2 WHERE formname ilike 've_%' AND formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'omzone_id' AND layoutname = 'lyt_bot_1';

-- 17/09/2025
UPDATE config_form_fields SET columnname = 'dwfzone_id', label = 'Dwfzone', tooltip = 'dwfzone_id', 
	dv_querytext = 'SELECT dwfzone_id as id, name as idval FROM dwfzone WHERE dwfzone_id = 0 UNION SELECT dwfzone_id as id, name as idval FROM dwfzone WHERE dwfzone_id IS NOT NULL AND active IS TRUE',
	dv_querytext_filterc = ' AND dwfzone.expl_id'
WHERE formtype = 'form_feature' AND tabname = 'tab_data' AND columnname = 'omzone_id' AND layoutname = 'lyt_bot_1';

-- 19/09/2025
UPDATE config_form_fields SET widgettype = 'text', iseditable = true WHERE formname = 've_sector' AND columnname = 'sector_id';

-- 20/10/2025
UPDATE config_form_fields SET label = 'Dma', tooltip = 'dma_id' WHERE formname LIKE '%_node%' AND formtype = 'form_feature' AND columnname = 'dma_id';
UPDATE config_form_fields SET label = 'Dma', tooltip = 'dma_id' WHERE formname LIKE '%_connec%' AND formtype = 'form_feature' AND columnname = 'dma_id';
UPDATE config_form_fields SET label = 'Dma', tooltip = 'dma_id' WHERE formname LIKE '%_arc%' AND formtype = 'form_feature' AND columnname = 'dma_id';
UPDATE config_form_fields SET label = 'Dma', tooltip = 'dma_id' WHERE formname LIKE '%_gully%' AND formtype = 'form_feature' AND columnname = 'dma_id';

-- 21/10/2025
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

UPDATE config_form_fields
SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null AND ''LINK''=ANY(feature_type)) ) AND active IS TRUE'
WHERE formname='ve_link' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';

UPDATE config_form_fields
	SET dv_isnullvalue=true
	WHERE formname='generic' AND formtype='psector' AND columnname='workcat_id_plan' AND tabname='tab_general';

UPDATE config_form_fields cff SET web_layoutorder = t.new_web_layoutorder FROM ( 
	SELECT formname, formtype, tabname, columnname, layoutname, layoutorder,
	ROW_number() OVER(
		PARTITION BY formname
		ORDER BY 
		CASE 
			WHEN layoutname = 'lyt_top_1' THEN 1 
			WHEN layoutname = 'lyt_top_2' THEN 2 
			WHEN layoutname = 'lyt_top_3' THEN 3
			WHEN layoutname = 'lyt_bot_1' THEN 4 
			WHEN layoutname = 'lyt_bot_2' THEN 5 
			WHEN layoutname = 'lyt_bot_3' THEN 6 
			WHEN layoutname = 'lyt_data_1' THEN 7
			WHEN layoutname = 'lyt_data_2' THEN 8 
			WHEN layoutname = 'lyt_data_3' THEN 9
			WHEN layoutname = 'lyt_data_4' THEN 10
		END, layoutorder
	) AS new_web_layoutorder
	FROM config_form_fields cff
	WHERE tabname = 'tab_data'
) t
WHERE cff.formname = t.formname 
	AND cff.formtype = t.formtype 
	AND cff.tabname = t.tabname 
	AND cff.columnname = t.columnname;


-- 06/11/2025
-- When updating y1, elev1, or custom_elev1, also refresh node_2 fields
UPDATE config_form_fields 
SET widgetcontrols = '{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2", "slope"]}'::json
WHERE columnname IN ('y1', 'elev1', 'custom_elev1')
AND formname LIKE 've_arc_%'
AND formtype = 'form_feature'
AND widgetcontrols::text LIKE '%autoupdateReloadFields%';

-- When updating y2, elev2, or custom_elev2, also refresh node_1 fields
UPDATE config_form_fields 
SET widgetcontrols = '{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1", "node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2", "slope"]}'::json
WHERE columnname IN ('y2', 'elev2', 'custom_elev2')
AND formname LIKE 've_arc_%'
AND formtype = 'form_feature'
AND widgetcontrols::text LIKE '%autoupdateReloadFields%';

-- 14/11/2025
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
    FOR table_records IN SELECT formname, formtype, columnname, tabname, label, tooltip FROM config_form_fields WHERE label like '%ID%' OR tooltip like '%ID%' LOOP
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


-- 24/11/2025
UPDATE config_form_fields SET dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE '
WHERE formname ilike 've_%' AND formtype='form_feature' AND columnname='sector_id' AND tabname='tab_data';

-- 01/12/2025
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='btn_doc_delete' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='btn_doc_insert' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='btn_doc_new' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='doc_name' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL,tooltip=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='hspacer_document_1' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='open_doc' AND tabname='tab_documents';
UPDATE config_form_fields
	SET "label"=NULL,tooltip=NULL
	WHERE formname='element' AND formtype='form_feature' AND columnname='tbl_documents' AND tabname='tab_documents';

-- 02/12/2025
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='y1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='elev1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_elev1' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='y2' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_y2' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='elev2' AND tabname='tab_data';
UPDATE config_form_fields
SET widgetcontrols='{"autoupdateReloadFields":["node_1", "y1", "custom_elev1", "sys_y1", "sys_elev1", "z1", "r1","node_2", "y2", "custom_elev2", "sys_y2", "sys_elev2", "z2", "r2","slope"]}'::json
WHERE formname ILIKE 've_arc_%' AND formtype='form_feature' AND columnname='custom_elev2' AND tabname='tab_data';


-- 09/12/2025
DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
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
        
    ELSE 
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
        
    END IF;
END;
$$;

-- 12/12/2025
-- Config_form_fields
UPDATE config_form_fields
	SET "label"='Sys elev2:'
	WHERE label = 'Elevation of the selected node 2:';

-- 15/12/2025
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_chamber', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_change', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_circ_manhole', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_highpoint', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_jump', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_junction', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_netelement', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_netgully', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_netinit', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_out_manhole', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_outfall', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_overflow_storage', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_pump_station', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_rect_manhole', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_register', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_sandbox', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_sewer_storage', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_valve', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_virtual_node', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_weir', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_node_wwtp', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_arc', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_arc_conduit', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_arc_pump_pipe', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_arc_siphon', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_arc_varc', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_arc_waccel', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;


INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_connec', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_connec_cjoin', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_connec_connec', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_connec_vconnec', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_link', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_link_conduitlink', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_link_link', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_link_pipelink', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_link_vlink', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_gully', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_gully_ginlet', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_gully_gully', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_gully_pgully', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) 
VALUES('ve_gully_vgully', 'form_feature', 'tab_data', 'expl_visibility', 'lyt_data_2', 43, 'text', 'text', 'Expl id visibility:', 'Expl_id visibility', NULL, false, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, NULL) ON CONFLICT DO NOTHING;


-- 16/12/2025
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