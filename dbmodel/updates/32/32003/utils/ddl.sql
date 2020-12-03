/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/03/29
ALTER TABLE anl_node ADD COLUMN descript text;
ALTER TABLE anl_node ADD COLUMN result_id character varying(16);

ALTER TABLE anl_arc ADD COLUMN descript text;
ALTER TABLE anl_arc ADD COLUMN result_id character varying(16);

ALTER TABLE anl_arc_x_node ADD COLUMN descript text;
ALTER TABLE anl_arc_x_node ADD COLUMN result_id character varying(16);

ALTER TABLE anl_connec ADD COLUMN descript text;
ALTER TABLE anl_connec ADD COLUMN result_id character varying(16);


ALTER TABLE sys_feature_type ADD COLUMN parentlayer varchar(30);


ALTER TABLE dma RENAME COLUMN pattern_id to _pattern_id;
ALTER TABLE dma ADD COLUMN pattern_id character varying(16);
ALTER TABLE dma ADD COLUMN link text;


CREATE TABLE anl_polygon (
  id serial PRIMARY KEY,
  pol_id character varying(16) NOT NULL,
  pol_type character varying(30),
  state integer,
  expl_id integer,
  fprocesscat_id integer NOT NULL,
  cur_user character varying(30) NOT NULL DEFAULT "current_user"(),
  the_geom geometry(Polygon,SRID_VALUE),
  result_id character varying(16),
  descript text);

CREATE INDEX anl_polygon_index
  ON anl_polygon
  USING gist
  (the_geom);

-- 2019/04/03
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_cat_param_user", "column":"isdeprecated", "dataType":"boolean"}}$$);
