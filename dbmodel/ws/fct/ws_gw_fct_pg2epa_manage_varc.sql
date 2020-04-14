/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2854

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_manage_varc(result_id_var character varying)
  RETURNS integer AS
$BODY$

-- set diameter and roughness for those arcs with arc_type ='VARC' AND epa_type ='PIPE'. 

DECLARE

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	UPDATE rpt_inp_arc SET diameter = a.diameter, roughness = a.roughness FROM (
	
			-- those arcs VARC-PIPE close to JUNCTION with same sector. In case of two JUNCTION on diferent sector -> select distinct is applied but problem is served
			with virtual AS
				(SELECT distinct on(arc_id) arc_id, node_1 as node_id, n.epa_type FROM rpt_inp_arc a JOIN rpt_inp_node n ON node_1 = node_id 
				WHERE arc_type = 'VARC' AND a.epa_type ='PIPE' AND n.epa_type = 'JUNCTION' AND a.sector_id = n.sector_id AND result_id  = result_id_var 
				UNION
				SELECT distinct on(arc_id) arc_id, node_2, n.epa_type FROM rpt_inp_arc a JOIN rpt_inp_node n ON node_2 = node_id 
				WHERE arc_type = 'VARC' AND a.epa_type ='PIPE' AND n.epa_type = 'JUNCTION'  AND a.sector_id = n.sector_id AND result_id  = result_id_var )

			-- those arcs PIPE-PIPE close to JUNCTION identified before
			SELECT v.arc_id, diameter, roughness FROM rpt_inp_arc a JOIN virtual v ON node_id = node_1 OR node_id = node_2
			WHERE a.arc_id != v.arc_id) a 

			WHERE a.arc_id = rpt_inp_arc.arc_id AND result_id  = result_id_var;
	
	RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
