/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2816

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_config_control()
  RETURNS trigger AS
$BODY$

DECLARE 
v_querytext text;
v_configtable text;
v_count integer;
v_widgettype text;
v_message json;
v_variables text;

BEGIN	

	-- search path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_configtable:= TG_ARGV[0];	 -- not used yet. Ready to enhance this trigger control

	IF (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter  = 'config_control') THEN

		IF v_configtable = 'audit_cat_param_user' THEN 

			IF TG_OP = 'INSERT' THEN
				RETURN NEW;
			ELSIF TG_OP = 'UPDATE' THEN
				RETURN NEW;
			ELSIF TG_OP = 'DELETE' THEN
				RETURN OLD;
			END IF;
			
		ELSIF v_configtable = 'config_api_form_fields' THEN 
		
			IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

				v_variables = concat('formname: ',NEW.formname,', column_id: ',NEW.column_id,', dv_querytext_filterc: ',NEW.dv_querytext_filterc);

				-- check dv_querytext restrictions
				IF (NEW.widgettype = 'combo' OR NEW.widgettype = 'typeahead') THEN

					--check dv_querytext is correct
					IF NEW.dv_querytext IS NOT NULL THEN
						v_querytext = NEW.dv_querytext;
						EXECUTE v_querytext;
					END IF;

					--check that when dv_querytextfilterc exists dv_parent_id also
					IF NEW.dv_querytext_filterc IS NOT NULL THEN

						IF NEW.dv_parent_id IS NULL THEN
							v_message = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3102", "function":"2816", "debug":null, "variables":"',v_variables,'"}}');
							SELECT gw_fct_getmessage(v_message);
						ELSE
							EXECUTE 'SELECT column_id FROM config_api_form_fields WHERE column_id = '||quote_literal(NEW.dv_parent_id)||' AND formname = '||quote_literal(NEW.formname)
								INTO v_widgettype;

							IF v_widgettype IS NULL THEN
								v_message = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3104", "function":"2816", "debug":null, "variables":"',v_variables,'"}}');
								SELECT gw_fct_getmessage(v_message);					
							END IF;	
						END IF;
					END IF;
				END IF;
			
				--check for typeahead some additional restrictions
				IF NEW.widgettype = 'typeahead' THEN

					-- isautoupdate is FALSE
					IF NEW.isautoupdate = TRUE THEN
						SELECT gw_fct_getmessage($${"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3096", "function":"2816","debug":null}}$$);	
					END IF;

					-- dv_parent_id IS COMBO
					IF NEW.dv_parent_id IS NOT NULL THEN

						EXECUTE 'SELECT widgettype FROM config_api_form_fields WHERE column_id = '||quote_literal(NEW.dv_parent_id)||' AND formname = '||quote_literal(NEW.formname)
							INTO v_widgettype;
		
						IF v_widgettype != 'combo' THEN
						--	v_message = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3098", "function":"2816", "debug":null, "variables":"',v_variables,'"}}');
						--	SELECT gw_fct_getmessage(v_message);
						END IF;
					END IF;
					
					--query text HAS SAME id THAN idval
					IF NEW.dv_querytext IS NOT NULL THEN
					
						EXECUTE 'SELECT count(*) FROM( ' ||NEW.dv_querytext|| ')a WHERE id::text != idval::text' INTO v_count;

						IF v_count > 0 THEN
							v_message = concat('{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3100", "function":"2816", "debug":null, "variables":"',v_variables,'"}}');
							SELECT gw_fct_getmessage(v_message);						
						END IF;
					END IF;
				END IF;
				
				RETURN NEW;
			
			ELSIF TGOP = 'DELETE' THEN
			
				RETURN NULL;
			END IF;
		END IF;
	END IF;

	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
