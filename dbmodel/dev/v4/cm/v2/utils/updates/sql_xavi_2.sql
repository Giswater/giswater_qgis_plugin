/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

ALTER TABLE om_visit_lot_x_unit DROP CONSTRAINT om_visit_lot_x_unit_macrounit_id_fk;
ALTER TABLE om_visit_lot_x_macrounit DROP CONSTRAINT om_visit_lot_x_macrounit_pkey;
ALTER TABLE om_visit_lot_x_macrounit ADD CONSTRAINT om_visit_lot_macrounit_pkey PRIMARY KEY(macrounit_id, lot_id);
ALTER TABLE om_visit_lot_x_unit ADD CONSTRAINT om_visit_lot_macrounit_pkey FOREIGN KEY(macrounit_id, lot_id)
REFERENCES om_visit_lot_x_macrounit (macrounit_id, lot_id)  ON UPDATE CASCADE ON DELETE CASCADE;

HE CANVIAT LA CONFIGURACIÓ DE CERCA. ES BUSCA PER arc_id i node_id I PUNTO!!!!
Que collons es això de buscar per code¿?¿?¿?¿? 

-- aquesta view reemplaça v_anl_grafanalytics_mapzones, per tant cal borrar-la dels SQL
CREATE OR REPLACE VIEW v_anl_grafanalytics_upstream AS 
 SELECT temp_anlgraf.arc_id,
    temp_anlgraf.node_1,
    temp_anlgraf.node_2,
    temp_anlgraf.flag,
    a2.flag AS flagi,
    a2.value,
    a2.trace
   FROM temp_anlgraf
     JOIN ( SELECT temp_anlgraf_1.arc_id,
            temp_anlgraf_1.node_1,
            temp_anlgraf_1.node_2,
            temp_anlgraf_1.water,
            temp_anlgraf_1.flag,
            temp_anlgraf_1.checkf,
            temp_anlgraf_1.value,
            temp_anlgraf_1.trace
           FROM temp_anlgraf temp_anlgraf_1
          WHERE temp_anlgraf_1.water = 1) a2 ON temp_anlgraf.node_2::text = a2.node_1::text
  WHERE temp_anlgraf.flag < 2 AND temp_anlgraf.water = 0 AND a2.flag = 0;
