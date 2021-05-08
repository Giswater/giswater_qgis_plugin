/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.parameter,
    a.value
   FROM ( SELECT a_1.idval AS parameter,
                CASE
                    WHEN a_1.idval = 'UNBALANCED'::text AND b.value = 'CONTINUE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_unbalanced_n'::text AND config_param_user.cur_user::name = "current_user"()))
                    WHEN a_1.idval = 'QUALITY'::text AND b.value = 'TRACE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_node_id'::text AND config_param_user.cur_user::name = "current_user"()))
                    WHEN a_1.idval = 'HYDRAULICS'::text AND (b.value = 'USE'::text OR b.value = 'SAVE'::text) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_hydraulics_fname'::text AND config_param_user.cur_user::name = "current_user"()))
                    WHEN a_1.idval = 'HYDRAULICS'::text AND b.value = 'NONE'::text THEN NULL::text
                    ELSE b.value
                END AS value
           FROM sys_param_user a_1
             JOIN config_param_user b ON a_1.id = b.parameter::text
          WHERE (a_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text]))
                 AND (a_1.idval <> ALL (ARRAY['UNBALANCED_N'::text, 'NODE_ID'::text, 'HYDRAULICS_FNAME'::text])) 
                 AND b.cur_user::name = "current_user"() 
                 AND b.value IS NOT NULL 
                 AND a_1.idval NOT IN ('VALVE_MODE_MINCUT_RESULT')
                 AND b.parameter::text NOT IN ('PATTERN') 
                 AND b.value <> 'NULLVALUE'::text) a
  WHERE (a.parameter  <> 'HYDRAULICS'::text OR a.parameter = 'HYDRAULICS'::text AND a.value IS NOT NULL)
  