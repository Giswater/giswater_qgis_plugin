/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1140

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_element() RETURNS trigger AS $BODY$
DECLARE
    feature_type text;
	feature_column text;
    element_table text;
    v_sql text;
    variable text;
    v_old_value text;
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    feature_type:= TG_ARGV[0];
    element_table:= 'element_x_'||feature_type;
	feature_column:= feature_type||'_id';

    IF TG_OP = 'INSERT' THEN

        --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        -- "data":{"message":"1", "function":"1140","parameters":null, "variables":null}}$$);

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

        --PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        -- "data":{"message":"2", "function":"1140","parameters":null, "variables":null}}$$);
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
		EXECUTE format('SELECT ($1).%I', feature_column)
      	INTO v_old_value
      	USING OLD;

        v_sql:= 'DELETE FROM '||element_table||' WHERE element_id = '||quote_literal(OLD.element_id)||' AND	 '||feature_column||' = '||quote_literal(v_old_value)||';';
        EXECUTE v_sql;
        RETURN NULL;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




