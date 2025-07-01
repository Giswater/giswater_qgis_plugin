/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE om_visit_lot_x_gully
(
  lot_id integer NOT NULL,
  gully_id character varying(16) NOT NULL,
  code character varying(30),
  status integer,
  observ text,
  CONSTRAINT om_visit_lot_x_gully_pkey PRIMARY KEY (lot_id, gully_id)
);


