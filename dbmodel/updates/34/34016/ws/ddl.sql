/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- parent:
ALTER TABLE arc ADD COLUMN depth numeric (12,3);
ALTER TABLE arc ADD COLUMN adate text;
ALTER TABLE arc ADD COLUMN adescript text;

ALTER TABLE node ADD COLUMN adate text;
ALTER TABLE node ADD COLUMN adescript text;
ALTER TABLE node ADD COLUMN accessibility int2;

ALTER TABLE connec ADD COLUMN adate text;
ALTER TABLE connec ADD COLUMN adescript text;
ALTER TABLE connec ADD COLUMN accessibility int2;



-- node child
ALTER TABLE man_tank ADD COLUMN hmax numeric (12,3);

ALTER TABLE man_hydrant ADD COLUMN geom1 float;
ALTER TABLE man_hydrant ADD COLUMN geom2 float;
ALTER TABLE man_hydrant ADD COLUMN brand text;
ALTER TABLE man_hydrant ADD COLUMN model text;

ALTER TABLE man_pump ADD COLUMN brand text;
ALTER TABLE man_pump ADD COLUMN model text;

ALTER TABLE man_valve ADD COLUMN shutter text;
ALTER TABLE man_valve ADD COLUMN brand text;
ALTER TABLE man_valve ADD COLUMN brand2 text;
ALTER TABLE man_valve ADD COLUMN model text;
ALTER TABLE man_valve ADD COLUMN model2 text;

ALTER TABLE man_meter ADD COLUMN brand text;
ALTER TABLE man_meter ADD COLUMN model text;

ALTER TABLE man_netwjoin ADD COLUMN brand text;
ALTER TABLE man_netwjoin ADD COLUMN model text;

ALTER TABLE man_netelement ADD COLUMN brand text;
ALTER TABLE man_netelement ADD COLUMN model text;

-- connec child
ALTER TABLE man_greentap ADD COLUMN brand text;
ALTER TABLE man_greentap ADD COLUMN model text;

ALTER TABLE man_wjoin ADD COLUMN brand text;
ALTER TABLE man_wjoin ADD COLUMN model text;
