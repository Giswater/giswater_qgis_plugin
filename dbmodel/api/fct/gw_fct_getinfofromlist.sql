CREATE OR REPLACE FUNCTION ws_sample.gw_api_getinfofromlist(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- lot
SELECT ws_sample.gw_api_getinfofromlist($${
		"client":{"device":9, "infoType":100, "lang":"ES"},
		"form":{},
		"feature":{"featureType":"lot", "id":"1"},
		"data":{}}$$)
	
*/

DECLARE
	-- Variables
	v_apiversion text;
	v_featuretype text;
	v_lotfeaturetype text;
	v_projecttype text;
	v_activelayer json;
	v_layermanager json;
	v_rectgeometry text;
	v_rectgeometry_json json;
	v_id text;
BEGIN

	--  Set search path to local schema
	SET search_path = "ws_sample", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

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
		v_layerManager := concat ('{"activeLayer":',v_activelayer,',"visibleLayers":',v_activelayer,'}');

		raise notice 'v_activelayer %', v_activelayer;
 		-- set zoom on canvas
		EXECUTE ' SELECT row_to_json (b) FROM (SELECT st_astext(st_envelope(st_extent(the_geom))) FROM (SELECT the_geom FROM '||v_activelayer||' WHERE lot_id= '||v_id||')a)b'    
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

	RETURN v_rectgeometry;
	
--    Exception handling
 --     RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

