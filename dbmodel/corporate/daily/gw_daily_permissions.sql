/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--db
GRANT ALL ON DATABASE gis TO crone;

--utils
GRANT ALL ON SCHEMA utils TO crone;
GRANT ALL ON ALL TABLES IN SCHEMA utils TO crone;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA utils TO crone;
GRANT ALL ON ALL SEQUENCES IN SCHEMA utils TO crone;


--crm
grant all on schema crm to crone;
grant select on all tables in schema crm to crone;
grant all on all functions in schema crm to crone;
grant all on all sequences in schema crm to crone;
grant all on table crm.crm2gis_traceability to crone;

--ws
grant all on schema ws to crone;
grant all on all functions in schema ws to crone;
grant all on all tables in schema ws to crone;
grant all on all sequences in schema ws to crone;

--ud
grant all on schema ud to crone;
grant all on all functions in schema ud to crone;



