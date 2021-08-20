/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3070


CREATE OR REPLACE FUNCTION ud_sample.gw_fct_pg2epa_vnodetrimarcs(result_id_var character varying)  RETURNS json AS 
$BODY$

--SELECT link_id, vnode_id FROM ud_sample.link, ud_sample.vnode where st_dwithin(st_endpoint(link.the_geom), vnode.the_geom, 0.01) and vnode.state = 0 and link.state > 0

/*
SELECT ud_sample.gw_fct_pg2epa_vnodetrimarcs('r1')
*/

DECLARE

v_count integer = 0;
v_result integer = 0;
v_record record;
v_count2 integer = 0;
      
BEGIN
	--  Search path
	SET search_path = "ud_sample", public;
	
	-- todo
	same ws
	marcar un tolerancia per no generar arcs més petits de letsay 2 metres
	insertar a la taula temp_gully tot el resultant de la pelicula

 
RETURN v_result;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;