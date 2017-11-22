/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


insert into sanejament.temp_om_visit_arc
select
id,
dia,
codi,
  inici,
  final,
  seccio,
  tipsec,  
  mida,
  mida_x,
  material,
  res_nivell,
  res_tipus ,
  est_general,
  est_volta ,
  est_solera ,
  est_tester ,
  equip ,
  observacions
from sanejament.ext_om_visit_lot_arc where lot_id=44;



insert into sanejament.temp_om_visit_node
select
id,
  dia ,
  codi ,
  sorrer ,
  total ,
  tapa_tipus ,
  tapa_estat ,
  pates_poli ,
  pates_ferr ,
  pates_rep ,
  res_nivell ,
  res_tipus ,
  est_general ,
  est_solera ,
  est_parets ,
  equip ,
  observacions
  from sanejament.ext_om_visit_lot_node where lot_id=42;