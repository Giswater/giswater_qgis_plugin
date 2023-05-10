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
rec_feature text;

BEGIN	

	-- search path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_configtable:= TG_ARGV[0];	 -- not used yet. Ready to enhance this trigger control

	IF (SELECT value::boolean FROM config_param_system WHERE parameter='admin_config_control_trigger') IS TRUE THEN

		IF v_configtable = 'sys_param_user' THEN 
		
		ELSIF v_configtable IN ('man_type_category', 'man_type_fluid', 'man_type_function', 'man_type_location', 'cat_brand', 'cat_brand_model') THEN 
			v_querytext='SELECT * FROM '||v_configtable||';';

			--add parenthesis if new definition of featurecat doesn't have it
	 		IF NEW.featurecat_id NOT ILIKE '{%}' AND NEW.featurecat_id IS NOT NULL THEN
	 			IF v_configtable IN ( 'cat_brand', 'cat_brand_model') THEN
					EXECUTE 'UPDATE '||v_configtable||' SET featurecat_id = concat(''{'','||quote_literal(NEW.featurecat_id)||',''}'') WHERE id = '||quote_literal(NEW.id)||';';
				ELSE 
					EXECUTE 'UPDATE '||v_configtable||' SET featurecat_id = concat(''{'','||quote_literal(NEW.featurecat_id)||',''}'') WHERE id = '||NEW.id||';';
				END IF;
			END IF;
			
			--check if all featurecat are present on table cat_feature
			IF NEW.featurecat_id IS NOT NULL THEN
				IF NEW.featurecat_id NOT ILIKE '{%}' THEN
					NEW.featurecat_id = concat('{',NEW.featurecat_id,'}');
				END IF;

				FOREACH rec_feature IN array(NEW.featurecat_id::text[]) LOOP
					IF rec_feature NOT IN (SELECT id FROM cat_feature) THEN
						v_variables = concat('table: ',v_configtable,', featurecat: ',rec_feature);
						v_message = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3172",
						"function":"2816", "debug":null, "variables":"',v_variables,'"}}');
						PERFORM gw_fct_getmessage(v_message);
					END IF;
				END LOOP;
			END IF;

		ELSIF v_configtable = 'config_form_fields' THEN 
		
			IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

				v_variables = concat('formname: ',NEW.formname,', columnname: ',NEW.columnname,', dv_querytext_filterc: ',NEW.dv_querytext_filterc);

				-- check dv_querytext restrictions
				IF (NEW.widgettype = 'combo' OR NEW.widgettype = 'typeahead') THEN

					--check dv_querytext is correct
					IF NEW.dv_querytext IS NOT NULL THEN
						v_querytext = NEW.dv_querytext;
						EXECUTE v_querytext;
					END IF;

					--check that when dv_querytextfilterc exists dv_parent_id also
					IF NEW.dv_querytext_filterc IS NOT null THEN

						--check if dv_parent_id is not null (only for combo because for typeahead null value means feature_id)
						IF NEW.dv_parent_id IS null AND NEW.widgettype != 'typeahead' THEN
							v_message = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3102", "function":"2816",
							"debug":null, "variables":"',v_variables,'"}}');
							PERFORM gw_fct_getmessage(v_message);
					
						elsif NEW.dv_parent_id IS null AND NEW.widgettype = 'typeahead' THEN
							NEW.dv_parent_id= '';
						end if;
					
						--check if dv_parent_id is correct (another existing columnname)
						EXECUTE 'SELECT columnname FROM config_form_fields WHERE columnname = '||quote_literal(NEW.dv_parent_id)||' AND formname = '||
						quote_literal(NEW.formname)||'' INTO v_widgettype;

						IF v_widgettype IS NULL and NEW.widgettype != 'typeahead'THEN
							v_message = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3104",
							"function":"2816", "debug":null, "variables":"',v_variables,'"}}');
							PERFORM gw_fct_getmessage(v_message);
						END IF;	
					END IF;
				END IF;

				--check isparent/dv_parent_id
				IF NEW.isparent IS TRUE THEN
				
						--count if dv_parent_id exists before set isparent=TRUE
						SELECT count(*) FROM config_form_fields WHERE formname=NEW.formname AND dv_parent_id=NEW.columnname INTO v_count;

						IF v_count = 0 THEN
							v_message = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3168",
							"function":"2816", "debug":null, "variables":"',v_variables,'"}}');
							PERFORM gw_fct_getmessage(v_message);
						END IF;
				END IF;
			
				--check for typeahead some additional restrictions
				IF NEW.widgettype = 'typeahead' THEN
	
					-- isautoupdate is FALSE
					IF NEW.isautoupdate = TRUE THEN
						PERFORM gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3096", "function":"2816","debug":null}}$$);	
					END IF;
			
					--query text HAS SAME id THAN idval (with the exception of streetname and streename2)
					IF NEW.dv_querytext IS NOT NULL THEN
	
						IF NEW.columnname = 'streetname' OR NEW.columnname = 'streetname2' THEN
							-- do nothing (with the exception of streetname and streename2
						ELSE
							EXECUTE 'SELECT count(*) FROM( ' ||NEW.dv_querytext|| ')a WHERE id::text != idval::text' INTO v_count;
	
							IF v_count > 0 THEN
								v_message = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3100",
								"function":"2816", "debug":null, "variables":"',v_variables,'"}}');
								PERFORM gw_fct_getmessage(v_message);						
							END IF;
						END IF;
					END IF;
				END IF;

			ELSIF TG_OP = 'UPDATE' THEN
	
				IF NEW.dv_parent_id IS NULL THEN
			
					-- check if related isparent is TRUE when setting dv_parent_id to NULL
					IF (SELECT isparent FROM config_form_fields WHERE formname=NEW.formname AND columnname=OLD.dv_parent_id
					and NEW.widgettype != 'typeahead') is true THEN 
						
						--only if there're no more fields related to the parent
						SELECT count(*) FROM config_form_fields WHERE formname=NEW.formname AND dv_parent_id=OLD.dv_parent_id INTO v_count;
					
						IF v_count = 1 THEN		
								v_message = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"message":"3170",
								"function":"2816", "debug":null, "variables":"',v_variables,'"}}');
								PERFORM gw_fct_getmessage(v_message);
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;
	
	-- return
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
		RETURN NEW;
	ELSIF TG_OP = 'DELETE' THEN
		RETURN OLD;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

