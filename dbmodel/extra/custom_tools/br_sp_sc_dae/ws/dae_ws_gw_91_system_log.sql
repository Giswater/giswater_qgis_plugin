/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- NEWS

CREATE TABLE gw_saa.daescs_comercial2gis_hydro_log (
    id serial8 PRIMARY KEY,
    new_hydrometer int4,
    real_hydrometer int4,
    old_hydrometer int4,
    tstamp timestamp without time zone DEFAULT now()
    
);
