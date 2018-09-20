/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

  
SET search_path = "SCHEMA_NAME", public, pg_catalog;


  
   
-------------
--01/06/2018
-------------
ALTER TABLE cat_grate ADD COLUMN label varchar(255);


-------------
--28/06/2018
-------------
/*
DROP TABLE IF EXISTS om_reh_cat_location;
CREATE TABLE om_reh_cat_location(
  id serial NOT NULL,
  from_value integer,
  to_value integer,
  location_id text,
  percent double precision,
  CONSTRAINT om_reh_cat_location_pkey PRIMARY KEY (id)
);


DROP TABLE om_reh_result_arc cascade;
CREATE TABLE om_reh_result_arc(
  id serial NOT NULL,
  result_id integer NOT NULL,
  arc_id character varying(16) NOT NULL,
  node_1 character varying(16),
  node_2 character varying(16),
  arc_type character varying(18) NOT NULL,
  arccat_id character varying(30) NOT NULL,
  sector_id integer NOT NULL,
  state smallint NOT NULL,
  expl_id integer,
  parameter_id character varying(30),
  work_id character varying(30),
  pcompost_id character varying(16),
  geom1 double precision,
  geom2 double precision,
  geom3 double precision,
  position_value double precision,
  value1 double precision,
  value2 double precision,
  measurement double precision,
  pcompost_price double precision,
  total_cost double precision,
  the_geom geometry(LineString,25831),
  CONSTRAINT om_reh_result_arc_pkey PRIMARY KEY (id),
  CONSTRAINT om_reh_result_arc_result_id_fkey FOREIGN KEY (result_id)
      REFERENCES vpat.om_result_cat (result_id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE om_reh_parameter_x_works;
CREATE TABLE om_reh_parameter_x_works(
  id serial NOT NULL,
  parameter_id character varying(50),
  arcclass_id integer,
  location_id character varying(30),
  work_id character varying(30),
  CONSTRAINT om_reh_parameter_x_works_pkey PRIMARY KEY (id)
);

*/

--------------------
--20/09/2018
--------------------

UPDATE audit_cat_param_user SET description = 'Default value for cat_arc parameter' WHERE id='arccat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for builtdate parameter' WHERE id='builtdate_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, when you finish element insertion, QGIS edition will keep opened. If false, QGIS edition will be closed automatically' WHERE id='cf_keep_opened_edition';
UPDATE audit_cat_param_user SET description = 'Default value for cat_connec parameter' WHERE id='connecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for dma parameter' WHERE id='dma_vdefault';
UPDATE audit_cat_param_user SET description = 'If true, arcs won''t be divided when new node where situated over him' WHERE id='edit_arc_division_dsbl';
UPDATE audit_cat_param_user SET description = 'If true, when inserting new connec, link will be automatically generated' WHERE id='edit_connect_force_automatic_connect2network';
UPDATE audit_cat_param_user SET description = 'Default value for cat_element parameter' WHERE id='elementcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for enddate parameter' WHERE id='enddate_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA conduit q0 parameter' WHERE id='epa_conduit_q0_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA junction y0 parameter' WHERE id='epa_junction_y0_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA outfall type parameter' WHERE id='epa_outfall_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for EPA raingage scf parameter' WHERE id='epa_rgage_scf_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for exploitation parameter' WHERE id='exploitation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_gully parameter' WHERE id='gullycat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_grate parameter' WHERE id='gratecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for municipality parameter' WHERE id='municipality_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for cat_node parameter' WHERE id='nodecat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for parameter type of OM' WHERE id='om_param_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for owner parameter' WHERE id='ownercat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for pavement parameter' WHERE id='pavement_vdefault';
UPDATE audit_cat_param_user SET description = 'If false, when you insert a planified node over an arc, this will be divided with two planified new arcs. This parameter is related to edit_arc_division_dsbl' WHERE id='plan_arc_vdivision_dsbl';
UPDATE audit_cat_param_user SET description = 'Default value for psector general expenses parameter' WHERE id='psector_gexpenses_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector other parameter' WHERE id='psector_other_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector rotation parameter' WHERE id='psector_rotation_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector scale parameter' WHERE id='psector_scale_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector type parameter' WHERE id='psector_type_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector vat parameter' WHERE id='psector_vat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector parameter' WHERE id='psector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for sector parameter' WHERE id='sector_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for soilcat parameter' WHERE id='soilcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state parameter' WHERE id='state_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type end parameter' WHERE id='statetype_end_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for psector state type parameter' WHERE id='statetype_plan_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for state type parameter' WHERE id='statetype_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for verified parameter' WHERE id='verified_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for visit parameter' WHERE id='visitcat_vdefault';
UPDATE audit_cat_param_user SET description = 'Default value for workcat parameter' WHERE id='workcat_vdefault';







