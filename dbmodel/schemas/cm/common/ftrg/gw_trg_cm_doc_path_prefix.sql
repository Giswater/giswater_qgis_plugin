/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cm, public, pg_catalog;

CREATE OR REPLACE FUNCTION doc_path_prefix()
RETURNS trigger
AS $$
BEGIN
    IF NEW.name IS NOT NULL THEN
        UPDATE doc
        SET path = NEW.path || NEW.name
        WHERE id = NEW.id;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

