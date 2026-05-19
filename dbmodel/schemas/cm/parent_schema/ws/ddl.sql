/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

WS parent hook for CM: arc/node/connec/link campaign tables are in
schemas/cm/base/; lot views/triggers in parent_schema/utils/ (parent link).
UD-specific gully tables live under parent_schema/ud/. Shared CM core is
schemas/cm/common/ (analogous to network/common for ws/ud).
*/

SET search_path = cm, public, pg_catalog;
