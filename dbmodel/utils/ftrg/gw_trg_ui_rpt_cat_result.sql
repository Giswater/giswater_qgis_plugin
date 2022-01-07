/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 2932

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_ui_rpt_cat_result() RETURNS trigger AS $BODY$
DECLARE 
    doc_table varchar;
    v_sql varchar;
    
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    doc_table:= TG_ARGV[0];

    IF TG_OP = 'INSERT' THEN
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
	
		-- update expl_id
		IF NEW.expl_id != OLD.expl_id AND NEW.expl_id IS NOT NULL THEN
			IF admin_exploitation_x_user IS FALSE THEN
				UPDATE rpt_cat_result SET expl_id = NEW.expl_id WHERE result_id = NEW.result_id;
			ELSIF admin_exploitation_x_user IS TRUE THEN
				IF NEW.cur_user = current_user THEN
					UPDATE rpt_cat_result SET expl_id = NEW.expl_id WHERE result_id = NEW.result_id;
				END IF;
			END IF;
		END IF;
		
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        v_sql:= 'DELETE FROM rpt_cat_result WHERE result_id = '||quote_literal(OLD.result_id)||';';
		IF admin_exploitation_x_user IS FALSE THEN
	        EXECUTE v_sql;
			ELSIF admin_exploitation_x_user IS TRUE THEN
				IF NEW.cur_user = current_user THEN
					EXECUTE v_sql;
				END IF;
			END IF;
        EXECUTE v_sql;
        RETURN NULL;
    
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
