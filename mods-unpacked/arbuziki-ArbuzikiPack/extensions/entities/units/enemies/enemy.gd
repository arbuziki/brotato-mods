extends "res://entities/units/enemies/enemy.gd"

const run_away_behaviors: Dictionary = {
	"res://entities/units/movement_behaviors/follow_player_movement_behavior.gd": 
		"res://mods-unpacked/arbuziki-ArbuzikiPack/content/entities/units/movement_behaviors/run_away_from_player_movement_behaviour.gd",
	"res://entities/units/movement_behaviors/target_rand_pos_movement_behavior.gd": 
		"res://mods-unpacked/arbuziki-ArbuzikiPack/content/entities/units/movement_behaviors/run_away_from_player_movement_behaviour.gd",
	"res://entities/units/enemies/attack_behaviors/charging_attack_behavior.gd":
		"res://mods-unpacked/arbuziki-ArbuzikiPack/content/entities/units/enemies/attack_behaviors/charging_running_away_behavior.gd"
}

var isEscaping:bool = false

func _ready()->void:
	
	if RunData.effects["fleeing_enemies"]:
		checkAndReplaceBehavior(_movement_behavior)
		checkAndReplaceBehavior(_attack_behavior)
	
func _physics_process(delta:float)->void :
	if dead:
		return
	
	#For Chuck:
	if RunData.effects["enemy_escaped_penalty"] > 0:
		checkIfEnemyTriesToEscape()
	
	._physics_process(delta)
			
func checkAndReplaceBehavior(object: Object)->void:
	var script = object.get_script()
	if script and run_away_behaviors.has(script.resource_path):
		var new_behavior = load(run_away_behaviors[script.resource_path])
		object.set_script(new_behavior)
		
		#_ready() is getting called before we change the script, so to fix that we have to call it again manually
		if object.has_method("_ready"):
			object._ready()

func checkIfEnemyTriesToEscape()->void:
	
	#If an enemy touched the wall, it means it tries to escape, start a flashing animation and then player takes damage
	if get_slide_count() > 0 and is_on_wall() and not isEscaping:
		
		isEscaping = true
		
		playEscapingAnimation()
		
		var escaping_timer = Timer.new()
		escaping_timer.wait_time = 2 if RunData.current_wave >= 10 else (68.0/9.0) - RunData.current_wave * (5.0/9.0)
		add_child(escaping_timer)
		escaping_timer.start()
		
		yield (escaping_timer, "timeout")
		
		if not dead:
			var dmg = max_stats.damage + (max_stats.damage * Utils.get_stat("enemy_damage") / 100.0);
			var dmg_wave = dmg + dmg * (RunData.current_wave * 300.0 / 20.0) / 100.0
			player_ref.take_damage(dmg_wave, null, false, false, null, 1.0, true)
			
			can_drop_loot = false
			die()
		
func playEscapingAnimation()->void:
	var flashing_player = AnimationPlayer.new()
	add_child(flashing_player)
	var animation = load("res://mods-unpacked/arbuziki-ArbuzikiPack/extensions/entities/units/enemies/escaping_animation.tres")
	flashing_player.add_animation("escaping", animation)
	flashing_player.play("escaping")
