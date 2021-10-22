/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/21

DROP VIEW IF EXISTS vi_losses;
CREATE OR REPLACE VIEW vi_losses AS 
 SELECT arc_id,
 CASE WHEN kentry IS NOT NULL THEN kentry ELSE 0 END AS kentry,
 CASE WHEN kexit IS NOT NULL THEN kexit ELSE 0 END AS kexit,
 CASE WHEN kavg IS NOT NULL THEN kavg ELSE 0 END AS kavg,
 CASE WHEN flap IS NOT NULL THEN flap ELSE 'NO' END AS flap,
    seepage
   FROM temp_arc
  WHERE kentry > 0::numeric OR kexit > 0::numeric OR kavg > 0::numeric 
  OR flap::text = 'YES'::text OR seepage is not null;