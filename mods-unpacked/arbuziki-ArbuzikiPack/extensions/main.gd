extends "res://main.gd"

func _ready()->void:
	if RunData.effects["closer_enemy_spawner"]:
		_entity_spawner.queue_free()
		
		var new_entity_spawner_scene = load("res://mods-unpacked/arbuziki-ArbuzikiPack/content/global/closer_enemy_spawner.tscn")
		_entity_spawner = new_entity_spawner_scene.instance()
		add_child(_entity_spawner)
		
		_entity_spawner.connect("player_spawned", self, "_on_EntitySpawner_player_spawned")
		_entity_spawner.connect("enemy_spawned", self, "_on_EntitySpawner_enemy_spawned")
		_entity_spawner.connect("neutral_spawned", self, "_on_EntitySpawner_neutral_spawned")
		_entity_spawner.connect("structure_spawned", self, "_on_EntitySpawner_structure_spawned")
		_wave_manager.connect("group_spawn_timing_reached", _entity_spawner, "on_group_spawn_timing_reached")
		
		var current_wave_data = ZoneService.get_wave_data(RunData.current_zone, RunData.current_wave)		
		_entity_spawner.init(
			_entities_container, 
			_births_container, 
			ZoneService.current_zone_min_position, 
			ZoneService.current_zone_max_position, 
			current_wave_data, 
			_wave_timer
		)

func _on_EndWaveTimer_timeout()->void:
	
	# When a wave ends: remove all the items if the destroy_items effect is set as 1
	if RunData.effects["destroy_items"]:
		RunData.remove_all_items()  
			
	._on_EndWaveTimer_timeout()
	
	# Replace the default shop with the extended shop that can show up to 12 slots
	if RunData.effects["shop_slot_size"] > 4 and not (_is_run_lost or is_last_wave() or _is_run_won):
		var _error = get_tree().change_scene("res://mods-unpacked/arbuziki-ArbuzikiPack/ui/menus/extended_shop/shop_extended.tscn")

func _on_EntitySpawner_player_spawned(player:Player)->void:
	if is_instance_valid(_player):
		_player.queue_free()
		
	._on_EntitySpawner_player_spawned(player)
