/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



CREATE OR REPLACE VIEW SCHEMA_NAME.ext_district AS 
 SELECT 
 	district.district_id,
    district.name,
    district.muni_id,
    district.observ,
    district.the_geom
   FROM utils.district;
