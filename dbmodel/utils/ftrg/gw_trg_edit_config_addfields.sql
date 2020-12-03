/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2808

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_config_addfields()
  RETURNS trigger AS
$BODY$
DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- sys_addfields table
	UPDATE sys_addfields SET
	num_decimals = NEW.num_decimals,
	field_length = NEW.field_length,
	orderby = NEW.addfield_order,
	active = NEW.addfield_active
	WHERE param_id=OLD.param_id AND cat_feature_id=OLD.cat_feature_id;
		
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


