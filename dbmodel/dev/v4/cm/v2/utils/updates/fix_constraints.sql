/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

ALTER TABLE ud.om_visit_lot_x_arc DROP CONSTRAINT om_visit_lot_x_arc_unit_id_fk;
ALTER TABLE ud.om_visit_lot_x_node DROP CONSTRAINT om_visit_lot_x_node_unit_id_fk;
ALTER TABLE ud.om_visit_lot_x_gully DROP CONSTRAINT om_visit_lot_x_gully_unit_id_fk;

ALTER TABLE ud.om_visit_lot_x_unit DROP CONSTRAINT om_visit_lot_x_unit_pkey;
ALTER TABLE ud.om_visit_lot_x_unit DROP CONSTRAINT om_visit_lot_x_unit_un;
ALTER TABLE ud.om_visit_lot_x_unit ADD CONSTRAINT om_visit_lot_x_unit_pkey PRIMARY KEY (lot_id, unit_id);


-- Posar a NULL per poder aplicar les noves FK's (lot_id, unit_id)

-- 468 registres
update om_visit_lot_x_arc
set unit_id = NULL
where (lot_id, unit_id) not in (select lot_id, unit_id from om_visit_lot_x_unit)
and unit_id is not null;

-- 131 registres
update om_visit_lot_x_node
set unit_id = NULL
where (lot_id, unit_id) not in (select lot_id, unit_id from om_visit_lot_x_unit)
and unit_id is not null;

-- 94 registres
update om_visit_lot_x_gully
set unit_id = NULL
where (lot_id, unit_id) not in (select lot_id, unit_id from om_visit_lot_x_unit)
and unit_id is not null;

ALTER TABLE ud.om_visit_lot_x_arc ADD CONSTRAINT om_visit_lot_x_arc_unit_id_fk FOREIGN KEY (lot_id, unit_id)
REFERENCES ud.om_visit_lot_x_unit(lot_id, unit_id) ON UPDATE CASCADE;

ALTER TABLE ud.om_visit_lot_x_node ADD CONSTRAINT om_visit_lot_x_node_unit_id_fk FOREIGN KEY (lot_id, unit_id)
REFERENCES ud.om_visit_lot_x_unit(lot_id, unit_id) ON UPDATE CASCADE;

ALTER TABLE ud.om_visit_lot_x_gully ADD CONSTRAINT om_visit_lot_x_gully_unit_id_fk FOREIGN KEY (lot_id, unit_id)
REFERENCES ud.om_visit_lot_x_unit(lot_id, unit_id) ON UPDATE CASCADE;
