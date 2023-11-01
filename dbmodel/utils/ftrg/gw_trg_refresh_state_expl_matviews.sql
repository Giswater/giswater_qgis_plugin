/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3286


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_refresh_state_expl_matviews() RETURNS trigger AS $BODY$
DECLARE 
v_sourcetable text;
v_project_type text;
    
BEGIN

	-- set search_path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_sourcetable:= TG_ARGV[0];

	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	IF v_sourcetable = 'selector_psector' THEN
		REFRESH MATERIALIZED VIEW v_state_arc;
		REFRESH MATERIALIZED VIEW v_state_node;
		REFRESH MATERIALIZED VIEW v_state_connec;
		REFRESH MATERIALIZED VIEW v_state_link;
		IF v_project_type = 'UD' THEN
			REFRESH MATERIALIZED VIEW v_state_gully;
		END IF;

	ELSIF v_sourcetable = 'selector_expl' THEN
	   	REFRESH MATERIALIZED VIEW v_expl_arc;
		REFRESH MATERIALIZED VIEW v_expl_node;

	ELSIF v_sourcetable = 'plan_psector_x_arc' THEN
		REFRESH MATERIALIZED VIEW v_state_arc;
		
	ELSIF v_sourcetable = 'plan_psector_x_node' THEN
		REFRESH MATERIALIZED VIEW v_state_node;

	ELSIF v_sourcetable = 'plan_psector_x_connec' THEN
		REFRESH MATERIALIZED VIEW v_state_connec;

	ELSIF v_sourcetable = 'plan_psector_x_gully' THEN
		REFRESH MATERIALIZED VIEW v_state_gully;

	ELSIF v_sourcetable = 'arc' THEN
	   	REFRESH MATERIALIZED VIEW v_expl_arc;
	   	REFRESH MATERIALIZED VIEW v_state_arc;

	ELSIF v_sourcetable = 'node' THEN
		REFRESH MATERIALIZED VIEW v_expl_node;
	   	REFRESH MATERIALIZED VIEW v_state_node;

	ELSIF v_sourcetable = 'connec' THEN
	   	REFRESH MATERIALIZED VIEW v_state_connec;

	ELSIF v_sourcetable = 'gully' THEN
	   	REFRESH MATERIALIZED VIEW v_state_gully;

	ELSIF v_sourcetable = 'link' THEN
	   	REFRESH MATERIALIZED VIEW v_state_link;
	END IF;
   
	RETURN NEW;    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  
