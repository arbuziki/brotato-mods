extends "res://ui/menus/pages/main_menu.gd"

func _on_ContinueButton_pressed()->void :
	._on_ContinueButton_pressed()
	
	if RunData.effects["shop_slot_size"] > 4:
		var _error = get_tree().change_scene("res://mods-unpacked/arbuziki-ArbuzikiPack/ui/menus/extended_shop/shop_extended.tscn")
