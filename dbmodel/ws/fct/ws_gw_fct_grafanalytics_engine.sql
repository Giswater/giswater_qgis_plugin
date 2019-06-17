/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2704

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_engine(p_data json)
RETURNS integer AS
$BODY$


/*
SELECT SCHEMA_NAME.gw_fct_grafanalytics_engine('{"grafClass":"MSECTOR","arc":"114098"}')
*/

DECLARE
affected_rows numeric;
cont1 integer default 0;
v_arc text;
v_class text;
v_querytext text;
v_node text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_arc = (SELECT (p_data::json->>'arc'));
	v_class = (SELECT (p_data::json->>'grafClass'));
	v_node = (SELECT (p_data::json->>'node'));
	
	-- set the starting element
	IF v_node IS NOT NULL THEN
		v_querytext = 'UPDATE anl_graf SET flag=1, water=1, checkf=1 WHERE node_1='||quote_literal(v_node)||'  
		AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 
	ELSIF v_arc IS NOT NULL THEN
		v_querytext = 'UPDATE anl_graf SET flag=1, water=1, checkf=1 WHERE arc_id='||quote_literal(v_arc)||' 
		AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 
	END IF;

	--RAISE NOTICE 'v_querytext %',v_querytext;
	EXECUTE v_querytext;

	-- inundation process
	LOOP
		cont1 = cont1+1;
		UPDATE anl_graf n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graf a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id AND n.grafclass=v_class;
		GET DIAGNOSTICS affected_rows =row_count;
		EXIT WHEN affected_rows = 0;
		EXIT WHEN cont1 = 100;
	END LOOP;	
	
RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
