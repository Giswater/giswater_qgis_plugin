/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


  CREATE TABLE om_visit_lot_x_gully( 
  lot_id integer,
  gully_id varchar (16),
  code varchar(30),
  status integer,
  observ text,
  constraint om_visit_lot_x_gully_pkey PRIMARY KEY (lot_id, gully_id));

