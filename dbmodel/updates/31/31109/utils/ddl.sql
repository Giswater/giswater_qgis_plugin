/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/03/11
ALTER TABLE om_visit ALTER COLUMN enddate drop DEFAULT;
ALTER TABLE dimensions ADD COLUMN observ text;


ALTER TABLE ext_rtc_scada_dma_period ADD COLUMN pattern_id character varying(16);


ALTER TABLE anl_node ALTER COLUMN node_id SET DEFAULT nextval('SCHEMA_NAME.urn_id_seq'::regclass);


ALTER TABLE rpt_cat_result ADD COLUMN user_name text;
ALTER TABLE rpt_cat_result ALTER COLUMN user_name SET DEFAULT current_user;

ALTER TABLE dma ADD COLUMN effc double precision;
ALTER TABLE dma ADD COLUMN pattern_id double precision;


-- 2019/03/15
ALTER TABLE anl_arc RENAME COLUMN arc_type TO arccat_id;
ALTER TABLE anl_arc_x_node RENAME COLUMN arc_type TO arccat_id;