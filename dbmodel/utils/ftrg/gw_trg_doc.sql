/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2686


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_doc() RETURNS trigger AS $BODY$
DECLARE 
    doc_table varchar;
    v_sql varchar;
    v_sourcetext json;
    v_targettext text;
    v_record record;
    v_enabled boolean;
    
BEGIN

   -- set search_path
   EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
   -- getting config data
   v_enabled = (SELECT value::json->>'enabled' FROM config_param_system WHERE parameter='edit_replace_doc_folderpath')::boolean;
   v_sourcetext = (SELECT value::json->>'values' FROM config_param_system WHERE parameter='edit_replace_doc_folderpath')::text;

   IF v_enabled THEN 
	-- looping data
	FOR v_record IN SELECT (a)->>'source' as source,(a)->>'target' as target  FROM json_array_elements(v_sourcetext) a
	LOOP
		NEW.path=REPLACE (NEW.path, v_record.source, v_record.target);
	END LOOP;
  END IF;
 
   RETURN NEW;    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
