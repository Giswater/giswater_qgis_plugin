/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_seturn(p_feature_id text , p_feature_type text)
  RETURNS text AS
$BODY$

/*
SELECT gw_fct_seturn (node_id, 'node') FROM node WHERE node_id = '';
*/

DECLARE 
max_aux int8;
project_type_aux text;

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	SELECT project_type INTO project_type_aux FROM sys_version LIMIT 1;
	
	--urn
	IF project_type_aux='WS' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO max_aux;
	ELSIF project_type_aux='UD' THEN
		SELECT GREATEST (
		(SELECT max(node_id::int8) FROM node WHERE node_id ~ '^\d+$'),
		(SELECT max(arc_id::int8) FROM arc WHERE arc_id ~ '^\d+$'),
		(SELECT max(connec_id::int8) FROM connec WHERE connec_id ~ '^\d+$'),
		(SELECT max(gully_id::int8) FROM gully WHERE gully_id ~ '^\d+$'),
		(SELECT max(element_id::int8) FROM element WHERE element_id ~ '^\d+$'),
		(SELECT max(pol_id::int8) FROM polygon WHERE pol_id ~ '^\d+$')
		) INTO max_aux;
	END IF;	

	EXECUTE 'UPDATE '||p_feature_type||' SET '||concat(p_feature_type,'_id')|| ' = ' || max_aux+1|| ' WHERE '||concat(p_feature_type,'_id')|| ' = '||quote_literal(p_feature_id);

	PERFORM setval('SCHEMA_NAME.urn_id_seq',max_aux+1);
	
return concat('New value for ',p_feature_type,' ',p_feature_id, ':', max_aux+1);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

