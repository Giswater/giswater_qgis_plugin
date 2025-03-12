/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_om_visit_lotmanage ON om_visit_x_gully;
CREATE TRIGGER gw_trg_om_visit_lotmanage AFTER INSERT ON om_visit_x_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_om_visit_lotmanage('gully');