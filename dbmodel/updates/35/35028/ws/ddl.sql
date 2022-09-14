/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/14
ALTER TABLE ext_rtc_scada_x_data RENAME TO _ext_rtc_scada_x_data_ ;
ALTER TABLE _ext_rtc_scada_x_data_ DROP CONSTRAINT ext_rtc_scada_x_data_pkey;

CREATE TABLE ext_rtc_scada_x_data(
  node_id character varying(16) NOT NULL,
  value_date timestamp without time zone,
  value double precision,
  value_type integer,
  value_status integer,
  data_type text,
  CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY (node_id, value_date));
  
  
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"startdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_waterbalance", "column":"enddate", "dataType":"date", "isUtils":"False"}}$$);
