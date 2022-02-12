/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/31
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_timeseries", "column":"sector_id", "newName":"expl_id"}}$$);


CREATE TABLE inp_dscenario_lid_usage
(
  dscenario_id integer NOT NULL,
  hydrology_id integer NOT NULL,
  subc_id character varying(16) NOT NULL,
  lidco_id character varying(16) NOT NULL,
  numelem smallint,
  area numeric(16,6),
  width numeric(12,4),
  initsat numeric(12,4),
  fromimp numeric(12,4),
  toperv smallint,
  rptfile character varying(10),
  descript text,
  CONSTRAINT inp_dscenario_lid_usage_pkey 
  PRIMARY KEY (dscenario_id, hydrology_id, subc_id, lidco_id));

SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"inp_lid_usage", "column":"number", "newName":"numelem"}}$$);



CREATE TABLE temp_lid_usage
(
  subc_id character varying(16) NOT NULL,
  lidco_id character varying(16) NOT NULL,
  numelem smallint,
  area numeric(16,6),
  width numeric(12,4),
  initsat numeric(12,4),
  fromimp numeric(12,4),
  toperv smallint,
  rptfile character varying(10),
  CONSTRAINT temp_lid_usage_pkey 
  PRIMARY KEY (subc_id, lidco_id));


CREATE OR REPLACE VIEW vi_lid_usage AS 
 SELECT temp_lid_usage.subc_id,
    temp_lid_usage.lidco_id,
    temp_lid_usage.numelem::integer AS number,
    temp_lid_usage.area,
    temp_lid_usage.width,
    temp_lid_usage.initsat,
    temp_lid_usage.fromimp,
    temp_lid_usage.toperv::integer AS toperv,
    temp_lid_usage.rptfile
   FROM v_edit_inp_subcatchment
     JOIN temp_lid_usage ON temp_lid_usage.subc_id::text = v_edit_inp_subcatchment.subc_id::text;
