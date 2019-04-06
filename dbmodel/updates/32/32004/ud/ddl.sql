/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ud_sample, public, pg_catalog


CREATE TABLE rpt_tstep_node (
id bigserial PRIMARY KEY,
result_id character varying(30) NOT NULL,

flooding float,
depth float,
head float
);



CREATE TABLE rpt_tstep_arc (
id bigserial PRIMARY KEY,
result_id character varying(30) NOT NULL,

flow float,
velocity float,
fullpercent float
);



CREATE TABLE CREATE TABLE rpt_tstep_subcatchment ( 
id bigserial PRIMARY KEY,
result_id character varying(30) NOT NULL,

precip float,
losses float,
runoff float
);

