/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE om_visit_lot_x_gully ADD CONSTRAINT om_visit_lot_x_gully_lot_id_fkey FOREIGN KEY (lot_id)
REFERENCES om_visit_lot (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

