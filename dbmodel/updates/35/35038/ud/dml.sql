/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- remove missing references to exit_type VNODE on obsolete and planified links
UPDATE link SET exit_id = arc_id, exit_type = 'ARC', state=c.state FROM connec c WHERE feature_id = connec_id and c.state=0 and exit_type = 'VNODE';
UPDATE link SET exit_id = arc_id, exit_type = 'ARC', state=c.state FROM connec c WHERE feature_id = connec_id and c.state=2 and exit_type = 'VNODE';

UPDATE link SET exit_id = arc_id, exit_type = 'ARC', state=g.state FROM gully g WHERE feature_id = gully_id and g.state=0 and exit_type = 'VNODE';
UPDATE link SET exit_id = arc_id, exit_type = 'ARC', state=g.state FROM gully g WHERE feature_id = gully_id and g.state=2 and exit_type = 'VNODE';

-- delete links without connec relation
UPDATE link SET exit_type=NULL where link_id in (select link_id from link l 
left join connec c on connec_id=feature_id 
where exit_type='VNODE' and l.feature_type = 'CONNEC' and connec_id is null);

UPDATE link SET exit_type=NULL where link_id in (select link_id from link l 
left join gully g on gully_id=feature_id 
where exit_type='VNODE' and l.feature_type = 'GULLY' and gully_id is null);

UPDATE link SET exit_type=NULL where exit_type='VNODE'; 
UPDATE link SET feature_type=NULL where feature_type='VNODE';

DELETE FROM sys_feature_type WHERE id='VNODE';
