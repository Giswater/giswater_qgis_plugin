/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE TABLE SCHEMA_NAME.om_visit_lot
(
  id serial NOT NULL primary key,
  idval character varying(30),
  startdate date DEFAULT now(),
  enddate date,
  visitclass_id integer,
  visitcat_id integer,
  descript text,
  active boolean DEFAULT true,
  extusercat_id integer,
  duration text,
  feature_type text);
  

CREATE TABLE SCHEMA_NAME.om_visit_lot_x_arc( 
  lot_id integer,
  arc_id varchar (16),
  status integer,
  constraint om_visit_lot_x_arc_pkey PRIMARY KEY (lot_id, arc_id));

  CREATE TABLE SCHEMA_NAME.om_visit_lot_x_node( 
  lot_id integer,
  node_id varchar (16),
  status integer,
  constraint om_visit_lot_x_node_pkey PRIMARY KEY (lot_id, node_id));

  CREATE TABLE SCHEMA_NAME.om_visit_lot_x_connec( 
  lot_id integer,
  connec_id varchar (16),
  status integer,
  constraint om_visit_lot_x_connec_pkey PRIMARY KEY (lot_id, connec_id));




  