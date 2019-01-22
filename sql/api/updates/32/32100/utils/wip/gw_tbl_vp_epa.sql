/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;




CREATE OR REPLACE VIEW SCHEMA_NAME.vp_epa_arc AS 
 SELECT arc_id AS nid,
 epa_type,
	case when epa_type='PIPE' THEN 've_inp_pipe' 
	     when epa_type='NOT DEFINED' THEN null
	     end as epatable	
   FROM SCHEMA_NAME.arc;



CREATE OR REPLACE VIEW SCHEMA_NAME.vp_epa_node AS 

 SELECT node_id AS nid,
  epa_type,
	case when epa_type='JUNCTION' THEN 've_inp_junction' 
		when epa_type='PUMP' THEN 've_inp_pump' 
		when epa_type='RESERVOIR' THEN 've_inp_reservoir' 
		when epa_type='TANK' THEN 've_inp_tank' 
		when epa_type='VALVE' THEN 've_inp_valve' 
		when epa_type='SHORTPIPE' THEN 've_inp_shortpipe' 
		when epa_type='NOT DEFINED' THEN null
		end as epatable
   FROM SCHEMA_NAME.node;


