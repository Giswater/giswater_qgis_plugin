/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3004

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_output(integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_output(result_id_arg integer)
RETURNS integer AS
$BODY$

DECLARE

v_volume float;
v_priority json;
v_count int2;
v_mincutdetails text;
v_output json;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- count arcs
	SELECT count(arc_id), sum(st_length(arc.the_geom))::numeric(12,2) INTO v_numarcs, v_length 
	FROM om_mincut_arc JOIN arc USING (arc_id) WHERE result_id=result_id_arg group by result_id;
	SELECT sum(area*st_length(arc.the_geom))::numeric(12,2) INTO v_volume 
	FROM om_mincut_arc JOIN arc USING (arc_id) JOIN cat_arc ON arccat_id=cat_arc.id 
	WHERE result_id=result_id_arg group by result_id, arccat_id;

	-- count connec
	SELECT count(connec_id) INTO v_numconnecs FROM om_mincut_connec WHERE result_id=result_id_arg AND state=1;

	-- count hydrometers
	SELECT count (rtc_hydrometer_x_connec.hydrometer_id) INTO v_numhydrometer 
	FROM rtc_hydrometer_x_connec JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
	JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
	JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg;

	-- priority hydrometers
	v_priority = 	(SELECT (array_to_json(array_agg((b)))) FROM 
	(SELECT concat('{"category":"',category_id,'","number":"', count(rtc_hydrometer_x_connec.hydrometer_id), '"}')::json as b FROM rtc_hydrometer_x_connec 
			JOIN om_mincut_connec ON rtc_hydrometer_x_connec.connec_id=om_mincut_connec.connec_id 
			JOIN v_rtc_hydrometer ON v_rtc_hydrometer.hydrometer_id=rtc_hydrometer_x_connec.hydrometer_id
			JOIN connec ON connec.connec_id=v_rtc_hydrometer.connec_id WHERE result_id=result_id_arg 
			GROUP BY category_id ORDER BY category_id)a);
				
	IF v_priority IS NULL THEN v_priority='{}'; END IF;
	
	v_mincutdetails = (concat('"minsector_id":"',element_id_arg,'","arcs":{"number":"',v_numarcs,'", "length":"',v_length,'", "volume":"', 
	v_volume, '"}, "connecs":{"number":"',v_numconnecs,'","hydrometers":{"total":"',v_numhydrometer,'","classified":',v_priority,'}}'));

	v_output = concat ('{', v_mincutdetails , '}');
			
	--update output results
	UPDATE om_mincut SET output = v_output WHERE id = result_id_arg;

    RETURN v_mincutdetails;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;