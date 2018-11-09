/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE FUNCTION gw_fct_flow_swmm2pg (result_id_var text)  RETURNS void AS

$BODY$


BEGIN

SET search_path='SCHEMA_NAME',public;

UPDATE subcatchment SET parea=area*imperv;

UPDATE arc SET flow=max_flow/mfull_flow
FROM rpt_arcflow_sum WHERE arc_id=arc_id AND result_id=result_id_var;

		
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

