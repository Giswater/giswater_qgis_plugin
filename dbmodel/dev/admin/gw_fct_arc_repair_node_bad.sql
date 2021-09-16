-- set environtment
set search_path = 'ws', public;
DELETE FROM selector_state WHERE cur_user=current_user;
INSERT INTO selector_state VALUES (1, current_user);
INSERT INTO selector_expl SELECT expl_id, current_user FROM exploitation ON CONFLICT (expl_id, cur_user) DO NOTHING;

-- check
SELECT a.arc_id, node_1, node_id, 'node_1' as node FROM arc a, node n WHERE st_dwithin(st_startpoint(a.the_geom), n.the_geom, 0.05) AND a.node_1 != n.node_id AND n.state = 1 AND a.state = 1
UNION
SELECT a.arc_id, node_2, node_id, 'node_2' as node FROM arc a, node n WHERE st_dwithin(st_endpoint(a.the_geom), n.the_geom, 0.05) AND a.node_2 != n.node_id  AND n.state = 1 AND a.state = 1
ORDER BY 

-- update
UPDATE arc SET the_geom = the_geom
FROM (
SELECT a.arc_id, node_1, node_id, 'node_1' as node FROM arc a, node n WHERE st_dwithin(st_startpoint(a.the_geom), n.the_geom, 0.05) AND a.node_1 != n.node_id AND n.state = 1 AND a.state = 1
UNION
SELECT a.arc_id, node_2, node_id, 'node_2' as node FROM arc a, node n WHERE st_dwithin(st_endpoint(a.the_geom), n.the_geom, 0.05) AND a.node_2 != n.node_id  AND n.state = 1 AND a.state = 1
ORDER BY 1)a
WHERE a.arc_id = arc.arc_id
