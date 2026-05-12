/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

GRANT ALL ON ALL TABLES IN SCHEMA ud to role_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA ud to role_admin;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ud to role_admin;

GRANT ALL ON ALL TABLES IN SCHEMA ud to role_om;
GRANT ALL ON ALL SEQUENCES IN SCHEMA ud to role_om;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ud to role_om;

GRANT ALL ON ALL TABLES IN SCHEMA ud to qgisserver;
GRANT ALL ON ALL SEQUENCES IN SCHEMA ud to qgisserver;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ud to qgisserver;

GRANT SELECT ON ALL TABLES IN SCHEMA crm to role_basic;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA crm to role_basic;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA crm to role_basic;

ALTER MATERIALIZED VIEW ext_workorder OWNER TO role_basic;