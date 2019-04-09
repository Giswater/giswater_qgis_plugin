
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE inp_pump ADD COLUMN energyparam varchar (30);
ALTER TABLE inp_pump ADD COLUMN energyvalue varchar (30);

ALTER TABLE inp_pump_importinp ADD COLUMN energyparam varchar (30);
ALTER TABLE inp_pump_importinp ADD COLUMN energyvalue varchar (30);

ALTER TABLE inp_pump_additional ADD COLUMN energyparam varchar (30);
ALTER TABLE inp_pump_additional ADD COLUMN energyvalue varchar (30);

ALTER TABLE inp_pipe ADD COLUMN reactionparam varchar (30);
ALTER TABLE inp_pipe ADD COLUMN reactionvalue varchar (30);


CREATE TABLE inp_reactions
( id serial PRIMARY KEY,
  descript text);

CREATE TABLE inp_energy 
(id serial PRIMARY KEY,
  descript text);
