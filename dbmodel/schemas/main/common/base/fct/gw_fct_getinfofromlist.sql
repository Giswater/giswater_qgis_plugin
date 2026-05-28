/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2584

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getinfofromlist(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfofromlist(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- lot
SELECT SCHEMA_NAME.gw_fct_getinfofromlist($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{},
		"feature":{"featureType":"lot", "id":"1"},
		"data":{}}$$)
*/

DECLARE

v_version text;
v_featuretype text;
v_lotfeaturetype text;
v_projecttype text;
v_activelayer json;
v_rectgeometry text;
v_rectgeometry_json json;
v_id text;

BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get project type
	SELECT project_type INTO v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	--  get parameters from input
	v_featuretype = (p_data ->>'feature')::json->>'featureType';
	v_id = (p_data ->>'feature')::json->>'id';

		
	-- return
	IF v_featuretype = 'arc' OR v_featuretype = 'node' OR v_featuretype = 'connec' OR v_featuretype = 'gully' THEN

		-- todo: return getinfofromid

	ELSIF  v_featuretype = 'mincut' THEN 

		-- todo: return getmincut

	ELSIF  v_featuretype = 'lot' THEN 

		-- get feature type
		SELECT feature_type INTO v_lotfeaturetype FROM om_visit_lot WHERE id=v_id::integer;

		-- set layer manager
		v_activelayer := concat ('"ve_lot_x_',lower(v_lotfeaturetype),'"');

 		-- set zoom on canvas
		EXECUTE ' SELECT row_to_json (b) FROM (SELECT st_astext(st_envelope(st_extent(the_geom))) FROM (SELECT the_geom FROM '||quote_ident(v_activelayer)||' WHERE lot_id= '||quote_literal(v_id)||')a)b'    
			INTO v_rectgeometry;
		
		-- set selector
		DELETE FROM selector_lot WHERE cur_user=current_user;
		INSERT INTO selector_lot (lot_id, cur_user) VALUES (v_id::integer, current_user);

		-- set form
			--headertext
			--
		
	ELSIF  v_featuretype = 'visit' THEN 

	ELSIF  v_featuretype = 'event' THEN 

	ELSIF  v_featuretype = 'workcat' THEN
	 
		-- todo: return getinfofromid

	ELSIF  v_featuretype = 'element' THEN
	
		-- todo: return getinfofromid 
	
	ELSIF  v_featuretype = 'doc' THEN 

	ELSIF  v_featuretype = 'epa' THEN 

	ELSIF  v_featuretype = 'psector' THEN
	 
		-- todo: return getinfofromid
	ELSE 
		-- generic: todo
	END IF;

	RETURN gw_fct_json_create_return(v_rectgeometry, 2584, null, null, null);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

