/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE ext_hydrometer ADD CONSTRAINT ext_hydrometer_ext_cat_hydrometer_state_fk FOREIGN KEY (state_id) REFERENCES ext_cat_hydrometer_state(id);
ALTER TABLE ext_hydrometer ADD CONSTRAINT ext_hydrometer_ext_cat_hydrometer_priority_fk FOREIGN KEY (priority_id) REFERENCES ext_cat_hydrometer_priority(id);
