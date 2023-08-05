extends "res://visual_effects/floating_text/floating_text_manager.gd"

func _on_unit_escaped(unit:Unit)->void:
	display("Escaped!", unit.global_position, Color.white, null, duration, false)
