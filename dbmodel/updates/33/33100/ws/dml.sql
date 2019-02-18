/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;



UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_energy';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_pump';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_reactions_gl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_source';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_typevalue_valve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_ampm';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_curve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_mixing';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_noneall';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_headloss';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_hyd';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_qual';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_rtc_coef';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_unbal';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_units';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_opti_valvemode';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_param_energy';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_reactions_el';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_reactions_gl';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status_pipe';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status_pump';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_status_valve';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_times';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_yesno';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_value_yesnofull';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='inp_options';
UPDATE audit_cat_table SET isdeprecated=true WHERE id='config';

