/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- get priority in terms of translate
select count(*), source from i18n.dbdialog group by source order by 1 desc


select count(*), source, lb_enen from i18n.pydialog group by source,lb_enen order by 1 desc

select * from i18n.pydialog

-- translate for catalan language