/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop VIEW v_inp_subcatch2node;
drop VIEW v_inp_subcatchcentroid;
drop VIEW vi_coverages;
drop VIEW vi_groundwater;
drop VIEW vi_infiltration;
drop VIEW vi_lid_usage;
drop VIEW vi_loadings;
drop VIEW vi_subareas;
drop VIEW vi_subcatchments;
drop VIEW vi_gwf;
drop VIEW ve_subcatchment;
drop VIEW v_edit_subcatchment;


CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.idval as parameter,
    b.value
   FROM audit_cat_param_user a
   JOIN config_param_user b ON a.id = b.parameter::text
   WHERE (a.layoutname = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 'grl_date_13'::text, 'grl_date_14'::text]))
   AND b.cur_user::name = "current_user"()
   AND a.epaversion::json->>'from'='5.0.022'
   AND b.value IS NOT NULL
   UNION
	SELECT 'INFILTRATION' , infiltration as value from inp_selector_hydrology, cat_hydrology
	where cur_user=current_user;

