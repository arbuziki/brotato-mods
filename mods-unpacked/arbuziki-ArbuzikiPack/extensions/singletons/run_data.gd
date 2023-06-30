extends "res://singletons/run_data.gd"

const new_effects: Dictionary = {
	#Commando:
	"destroy_items":0,
	"shop_slot_size":4,
	"reroll_price": 100,
	
	#Chuck:
	"fleeing_enemies":0,
	"enemy_escaped_penalty":0,
	"closer_enemy_spawner":0
}

# Adding the new effects:
func init_effects()->Dictionary:
	var effects = .init_effects()
	effects.merge(new_effects)
	return effects

# Removing all the items and undoing thier effects:
func remove_all_items()->void :
	for item in [] + items:
		if item is CharacterData:
			continue
		remove_item(item)
