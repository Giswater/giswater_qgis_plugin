/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

INSERT INTO minsector (minsector_id) VALUES(0) ON CONFLICT (minsector_id) DO NOTHING;