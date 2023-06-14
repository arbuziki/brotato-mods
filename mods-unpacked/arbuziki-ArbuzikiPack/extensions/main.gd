extends "res://main.gd"


func _on_EndWaveTimer_timeout()->void:
	
	# When a wave ends: remove all the items if the destroy_items effect is set as 1
	if RunData.effects["destroy_items"]:
		RunData.remove_all_items()  
			
	._on_EndWaveTimer_timeout()
	
	# Replace the default shop with the extended shop that can show up to 12 slots
	if RunData.effects["shop_slot_size"] > 4 and not (_is_run_lost or is_last_wave() or _is_run_won):
		var _error = get_tree().change_scene("res://mods-unpacked/arbuziki-ArbuzikiPack/ui/menus/extended_shop/shop_extended.tscn")
