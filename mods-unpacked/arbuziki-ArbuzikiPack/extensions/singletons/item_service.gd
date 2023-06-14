extends "res://singletons/item_service.gd"

# We can adjust the reroll price at the shop and on the upgrade screen by using the reroll_price effect
func get_reroll_price(wave:int, last_reroll_value:int)->int:	
	var increment = max(1.0, wave * RunData.effects["reroll_price"] / 100.0)	
			
	return max(1.0, (last_reroll_value + max(1.0, (0.5 * increment * (1.0 + RunData.get_endless_factor()))))) as int
