/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 1138



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_doc() RETURNS trigger AS $BODY$
DECLARE 
    feature_type text;
	feature_column text;
    doc_table text;
    v_sql text;
    variable text;
    v_old_value text;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    feature_type:= TG_ARGV[0];
    doc_table:= 'doc_x_'||feature_type;
	feature_column:= feature_type||'_id';

    IF TG_OP = 'INSERT' THEN
         --EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, "data":{"message":"1", "function":"1138","parameters":null}}$$);';

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        --EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, "data":{"message":"2", "function":"1138","parameters":null}}$$);';
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		
		EXECUTE format('SELECT ($1).%I', feature_column)
      	INTO v_old_value
      	USING OLD;

        v_sql:= 'DELETE FROM '||doc_table||' WHERE doc_id = '||quote_literal(OLD.doc_id)||' AND '||feature_column||' = '||quote_literal(v_old_value)||';';
        EXECUTE v_sql;
         --EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, "data":{"message":"3", "function":"1138","parameters":null}}$$);';
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

