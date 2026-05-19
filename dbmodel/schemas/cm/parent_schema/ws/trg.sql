/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

WS parent triggers for CM (arc/node/connec/link, lot edit views) are in
parent_schema/utils/trg.sql. Gully-specific triggers are in parent_schema/ud/.
Shared CM functions live under schemas/cm/common/.
*/

SET search_path = cm, public, pg_catalog;
