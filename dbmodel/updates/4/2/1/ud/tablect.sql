/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

ALTER TABLE inp_frorifice ALTER COLUMN flap DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN cd DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN shape DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN geom1 DROP NOT NULL;
ALTER TABLE inp_frorifice ALTER COLUMN geom2 DROP NOT NULL;