/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/07/10

CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text,'lyt_date_1'::text, 'lyt_date_2'::text])) 
  AND b.cur_user::name = "current_user"() AND (a.epaversion::json ->> 'from'::text) = '5.0.022'::text AND b.value IS NOT NULL AND a.idval IS NOT NULL
UNION
 SELECT 'INFILTRATION'::text AS parameter,
    cat_hydrology.infiltration AS value
   FROM selector_inp_hydrology,
    cat_hydrology
  WHERE selector_inp_hydrology.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_report AS 
 SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_reports_1'::text, 'lyt_reports_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL;
