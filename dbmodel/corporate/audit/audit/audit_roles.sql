/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/




GRANT ALL ON SCHEMA audit TO role_basic; --probably the restriction might be stronger
GRANT ALL ON SEQUENCE audit.log_id_seq TO role_basic;