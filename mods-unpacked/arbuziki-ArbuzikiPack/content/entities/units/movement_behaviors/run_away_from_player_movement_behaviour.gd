class_name RunAwayFromPlayerMovementBehavior
extends MovementBehavior

var player_ref:Node2D = null


func init(parent:Node)->Node:
	var _init = .init(parent)
	player_ref = (_parent as Unit).player_ref
	return self


func get_movement()->Vector2:
	return _parent.global_position - player_ref.global_position
