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

BEGIN	

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	
	v_configtable:= TG_ARGV[0];	 -- not used yet. Ready to enhance this trigger control
	
	IF TG_OP = 'INSERT' THEN
        --check dv_querytext is correct
		IF (NEW.widgettype = 'combo' OR NEW.widgettype = 'typeahead') AND NEW.dv_querytext IS NOT NULL THEN

			v_querytext = NEW.dv_querytext;
			EXECUTE v_querytext;
		END IF;
        
        --check isautoupdate is FALSE when typeahead
        IF NEW.widgettype = 'typeahead' AND NEW.isautoupdate = TRUE THEN
            SELECT gw_fct_getmessage($${"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3096", "function":"2816","debug":null}}$$);	
        END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
        --check dv_querytext is correct
		IF (NEW.widgettype = 'combo' OR NEW.widgettype = 'typeahead') AND (NEW.dv_querytext != OLD.dv_querytext) AND NEW.dv_querytext IS NOT NULL THEN

			v_querytext = NEW.dv_querytext;
			EXECUTE v_querytext;
		END IF;
        
        --check isautoupdate is FALSE when typeahead
        IF NEW.widgettype = 'typeahead' AND NEW.isautoupdate = TRUE THEN
            SELECT gw_fct_getmessage($${"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"error":"3096", "function":"2816","debug":null}}$$);	
        END IF;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN
		RETURN NULL;

	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;