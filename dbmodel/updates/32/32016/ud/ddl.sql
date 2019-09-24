/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_controls_x_node", "column":"active", "dataType":"boolean"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_timser_id", "column":"idval", "dataType":"varchar(50)"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_junction", "column":"outfallparam", "dataType":"json"}}$$);

--2019/09/02

ALTER TABLE inp_typevalue_divider RENAME TO _inp_typevalue_divider_;
ALTER TABLE inp_typevalue_evap RENAME TO _inp_typevalue_evap_;
ALTER TABLE inp_typevalue_orifice RENAME TO _inp_typevalue_orifice_;
ALTER TABLE inp_typevalue_outfall RENAME TO _inp_typevalue_outfall_;
ALTER TABLE inp_typevalue_outlet RENAME TO _inp_typevalue_outlet_;
ALTER TABLE inp_typevalue_pattern RENAME TO _inp_typevalue_pattern_;
ALTER TABLE inp_typevalue_raingage RENAME TO _inp_typevalue_raingage_;
ALTER TABLE inp_typevalue_storage RENAME TO _inp_typevalue_storage_;
ALTER TABLE inp_typevalue_temp RENAME TO _inp_typevalue_temp_;
ALTER TABLE inp_typevalue_timeseries RENAME TO _inp_typevalue_timeseries_;
ALTER TABLE inp_typevalue_windsp RENAME TO _inp_typevalue_windsp_;
ALTER TABLE inp_value_allnone RENAME TO _inp_value_allnone_;
ALTER TABLE inp_value_buildup RENAME TO _inp_value_buildup_;
ALTER TABLE inp_value_catarc RENAME TO _inp_value_catarc_;
ALTER TABLE inp_value_curve RENAME TO _inp_value_curve_;
ALTER TABLE inp_value_files_actio RENAME TO _inp_value_files_actio_;
ALTER TABLE inp_value_files_type RENAME TO _inp_value_files_type_;
ALTER TABLE inp_value_inflows RENAME TO _inp_value_inflows_;
ALTER TABLE inp_value_lidcontrol RENAME TO _inp_value_lidcontrol_;
ALTER TABLE inp_value_mapunits RENAME TO _inp_value_mapunits_;
ALTER TABLE inp_value_options_fme RENAME TO _inp_value_options_fme_;
ALTER TABLE inp_value_options_fr RENAME TO _inp_value_options_fr_;
ALTER TABLE inp_value_options_fu RENAME TO _inp_value_options_fu_;
ALTER TABLE inp_value_options_id RENAME TO _inp_value_options_id_;
ALTER TABLE inp_value_options_in RENAME TO _inp_value_options_in_;
ALTER TABLE inp_value_options_lo RENAME TO _inp_value_options_lo_;
ALTER TABLE inp_value_options_nfl RENAME TO _inp_value_options_nfl_;
ALTER TABLE inp_value_orifice RENAME TO _inp_value_orifice_;
ALTER TABLE inp_value_pollutants RENAME TO _inp_value_pollutants_;
ALTER TABLE inp_value_raingage RENAME TO _inp_value_raingage_;
ALTER TABLE inp_value_routeto RENAME TO _inp_value_routeto_;
ALTER TABLE inp_value_status RENAME TO _inp_value_status_;
ALTER TABLE inp_value_timserid RENAME TO _inp_value_timserid_;
ALTER TABLE inp_value_treatment RENAME TO _inp_value_treatment_;
ALTER TABLE inp_value_washoff RENAME TO _inp_value_washoff_;
ALTER TABLE inp_value_weirs RENAME TO _inp_value_weirs_;
ALTER TABLE inp_value_yesno RENAME TO _inp_value_yesno_;
ALTER TABLE inp_windspeed  RENAME TO _inp_windspeed_;

CREATE TABLE cat_mat_grate(
  id character varying(30) PRIMARY KEY,
  descript character varying(512),
  link character varying(512));


