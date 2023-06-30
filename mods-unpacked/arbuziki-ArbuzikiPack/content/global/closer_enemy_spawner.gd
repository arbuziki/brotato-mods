class_name CloserEntitySpawner
extends EntitySpawner

func get_spawn_pos_in_area(base_pos:Vector2, area:int, spawn_dist_from_edges:int = 0, spawn_edge_of_map:bool = false)->Vector2:
	
	var center = Vector2((_zone_max_pos.x - _zone_min_pos.x) / 2, (_zone_max_pos.y - _zone_min_pos.y) / 2)
	
	var x = RunData.current_wave * (center.x - MIN_DIST_FROM_PLAYER - Utils.EDGE_MAP_DIST) / 20.0
	var y = RunData.current_wave * (center.y - MIN_DIST_FROM_PLAYER - Utils.EDGE_MAP_DIST) / 20.0
		
	var pos = Vector2(
		rand_range(center.x - MIN_DIST_FROM_PLAYER - x, center.x + MIN_DIST_FROM_PLAYER + x),
		rand_range(center.y - MIN_DIST_FROM_PLAYER - y, center.y + MIN_DIST_FROM_PLAYER + y)
	)
		
	print(pos)
		
	pos = Vector2(
		clamp(pos.x, _zone_min_pos.x + Utils.EDGE_MAP_DIST, _zone_max_pos.x - Utils.EDGE_MAP_DIST),
		clamp(pos.y, _zone_min_pos.y + Utils.EDGE_MAP_DIST, _zone_max_pos.y - Utils.EDGE_MAP_DIST)
	)
		
	return pos
