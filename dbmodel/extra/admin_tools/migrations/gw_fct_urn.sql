/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- Function: SCHEMA_NAME.gw_fct_urn();

-- DROP FUNCTION SCHEMA_NAME.gw_fct_urn();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_urn() RETURNS integer AS
$BODY$
DECLARE 
urn_id_seq integer;
project_type_aux varchar;
BEGIN 

    SET search_path = "SCHEMA_NAME", public;

	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	IF project_type_aux='WS' THEN
	SELECT GREATEST (
		(SELECT max(node_id::integer) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::integer) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::integer) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(link_id::integer) FROM link WHERE link_id ~ '^\d+$'),
		(SELECT max(element_id::integer) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::integer) FROM polygon WHERE pol_id ~ '^\d+$'),
		(SELECT max(vnode_id::integer) FROM vnode WHERE vnode_id ~ '^\d+$')
		) INTO urn_id_seq;

		END IF;
		
	IF project_type_aux='UD' THEN
	SELECT GREATEST (
		(SELECT max(node_id::integer) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::integer) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::integer) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::integer) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(link_id::integer) FROM link WHERE link_id ~ '^\d+$'),
		(SELECT max(element_id::integer) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::integer) FROM polygon WHERE pol_id ~ '^\d+$'),
		(SELECT max(vnode_id::integer) FROM vnode WHERE vnode_id ~ '^\d+$')
		) INTO urn_id_seq;

		END IF;
	RETURN urn_id_seq;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
