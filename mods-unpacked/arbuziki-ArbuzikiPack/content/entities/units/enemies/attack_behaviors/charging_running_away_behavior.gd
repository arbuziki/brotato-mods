class_name ChargingRunningAwayBehavior
extends ChargingAttackBehavior

func start_shoot()->void :
	if target == TargetType.PLAYER:
		_charge_direction = (_parent.global_position - _parent.player_ref.global_position)
	else :
		var target_pos = _parent.player_ref.global_position + Vector2(rand_range( - max_range / 5, max_range / 5), rand_range( - max_range / 5, max_range / 5))
		_charge_direction = (_parent.global_position - target_pos)
	
	_parent._can_move = false


