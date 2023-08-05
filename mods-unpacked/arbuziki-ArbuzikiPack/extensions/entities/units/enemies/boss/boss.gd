extends "res://entities/units/enemies/boss/boss.gd"

func init(zone_min_pos:Vector2, zone_max_pos:Vector2, player_ref:Node2D = null, entity_spawner_ref:EntitySpawner = null)->void :
	.init(zone_min_pos, zone_max_pos, player_ref, entity_spawner_ref)
	
	if RunData.effects["fleeing_enemies"]:
		max_stats.health = round(max_stats.health * 10.0) as int
		current_stats.health = max_stats.health
		
func initFleeingBehaviors()->void:
	pass

func checkIfEnemyTriesToEscape()->void:
	pass
