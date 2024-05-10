/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3286

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_refresh_state_expl_matviews()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

DECLARE 
v_sourcetable text;
v_project_type text;
v_transact int8;
v_cur_transact int8;
    
BEGIN

	-- set search_path
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_sourcetable:= TG_ARGV[0];

	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);

	-- strategy to emulate 'for statement' trigger 
	v_transact = (select value from config_param_user where parameter = 'txid_refresh_matview' and cur_user = current_user);
	v_cur_transact = (select txid_current());
	if v_transact = v_cur_transact then	
		return null;
	end if;
	delete from config_param_user where parameter = 'txid_refresh_matview' and cur_user = current_user;
	insert into config_param_user (parameter, value, cur_user) values ('txid_refresh_matview', v_cur_transact, current_user);

	-- setting values for role_basic because owner of materialized views in order to ensure the refresh with same values of user
	if v_sourcetable in ('selector_psector', 'selector_expl', 'selector_state') THEN
		delete from selector_psector where cur_user = 'role_basic';
		delete from selector_expl where cur_user = 'role_basic';
		delete from selector_state where cur_user = 'role_basic';

		insert into selector_psector select psector_id, 'role_basic' from selector_psector where cur_user = current_user;
		insert into selector_expl select expl_id, 'role_basic' from selector_expl where cur_user = current_user;
		insert into selector_state select state_id, 'role_basic' from selector_state where cur_user = current_user;
	end if;


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
		REFRESH MATERIALIZED VIEW v_state_connec;
		REFRESH MATERIALIZED VIEW v_state_link;
		REFRESH MATERIALIZED VIEW v_state_link_connec;

		IF v_project_type = 'UD' THEN
			REFRESH MATERIALIZED VIEW v_state_gully;
			REFRESH MATERIALIZED VIEW v_state_link_gully;
		END IF;
	
	ELSIF v_sourcetable = 'selector_state' THEN
	   	REFRESH MATERIALIZED VIEW v_state_arc;
		REFRESH MATERIALIZED VIEW v_state_node;
		REFRESH MATERIALIZED VIEW v_state_connec;
		REFRESH MATERIALIZED VIEW v_state_link;
		REFRESH MATERIALIZED VIEW v_state_link_connec;
		IF v_project_type = 'UD' THEN
			REFRESH MATERIALIZED VIEW v_state_gully;
			REFRESH MATERIALIZED VIEW v_state_link_gully;
		END IF;
	
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
   
	RETURN new;    
    
END;
$function$
;
