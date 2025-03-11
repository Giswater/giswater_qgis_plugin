/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- get priority in terms of translate
select count(*), source, tt_es_es from i18n.dbdialog group by source, tt_es_es order by 1 desc

select * from i18n.dbdialog

-- translate for catalan language