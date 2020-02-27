/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1126


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_network_features();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_vnode()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_projectype text;
	v_new_arc_id text;
	v_link_geom public.geometry;
	v_arc_geom public.geometry;
	v_userdefined_geom boolean;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	SELECT wsoftware INTO v_projectype FROM version LIMIT 1;

	-- Insert
	IF TG_OP = 'INSERT' THEN
		PERFORM gw_fct_audit_function (3084,1126, NULL);
		RETURN NEW;

	-- Update
	ELSIF TG_OP = 'UPDATE' THEN
		PERFORM gw_fct_audit_function (3086,1126, NULL);
		RETURN NEW;
		
	-- Delete
	ELSIF TG_OP = 'DELETE' THEN
		PERFORM gw_fct_audit_function (3088,1126, NULL);
		RETURN NULL;
   
	END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
