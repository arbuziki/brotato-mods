class_name ShopExtendedItemsContainer
extends Container

signal focus_lost
signal shop_item_bought(shop_item)
signal mouse_hovered_category(shop_item)
signal mouse_exited_category(shop_item)
signal shop_item_focused(shop_item)
signal shop_item_unfocused(shop_item)

export (PackedScene) var _shop_item_prefab: PackedScene

export (int) var spacing = 0
export (int) var max_children_in_row = 6

var _shop_items:Array
var _buy_delay_timer = Timer.new()
var _is_delay_active = false

func _ready()->void :
	
	_buy_delay_timer.wait_time = 0.05
	_buy_delay_timer.one_shot = true
	
	var _delay = _buy_delay_timer.connect("timeout", self, "_on_BuyDelayTimer_timeout")
	add_child(_buy_delay_timer)
	
	for i in RunData.effects["shop_slot_size"]:
		var shop_item = _shop_item_prefab.instance()
		add_child(shop_item)
		_shop_items.push_back(shop_item)
	
	connect_shop_items()


func connect_shop_items()->void :
	for shop_item in _shop_items:
		var _error_buy = shop_item.connect("buy_button_pressed", self, "on_shop_item_buy_button_pressed")
		var _error_deactivate = shop_item.connect("shop_item_deactivated", self, "on_shop_item_deactivated")
		var _error_focused = shop_item.connect("shop_item_focused", self, "on_shop_item_focused")
		var _error_unfocused = shop_item.connect("shop_item_unfocused", self, "on_shop_item_unfocused")
		var _error_category_hovered = shop_item.connect("mouse_hovered_category", self, "on_mouse_hovered_category")
		var _error_category_exited = shop_item.connect("mouse_exited_category", self, "on_mouse_exited_category")


func on_shop_item_buy_button_pressed(shop_item:ShopItem)->void :
	
	if RunData.get_currency() < shop_item.value or _is_delay_active:
		return 
	
	var player_has_weapon = false
	
	for weapon in RunData.weapons:
		if weapon.my_id == shop_item.item_data.my_id:
			player_has_weapon = true
			break
	
	if (shop_item.item_data.get_category() == Category.WEAPON
		 and not RunData.has_weapon_slot_available(shop_item.item_data.type)
		 and (
			 not player_has_weapon
			 or shop_item.item_data.upgrades_into == null
			 or (RunData.effects["max_weapon_tier"] < shop_item.item_data.upgrades_into.tier)
			)
		):
		return 
	
	if (shop_item.item_data.get_category() == Category.WEAPON
		 and (
			(shop_item.item_data.type == WeaponType.MELEE and RunData.effects["no_melee_weapons"])
			 or 
			(shop_item.item_data.type == WeaponType.RANGED and RunData.effects["no_ranged_weapons"])
			 or 
			(RunData.effects["min_weapon_tier"] > shop_item.item_data.tier)
			 or 
			(RunData.effects["max_weapon_tier"] < shop_item.item_data.tier)
		)):
			return 
	
	emit_signal("shop_item_bought", shop_item)
	shop_item.deactivate()
	
	update_buttons_color()
	
	_is_delay_active = true
	_buy_delay_timer.start()


func update_buttons_color()->void :
	for item in _shop_items:
		item.update_color()


func on_shop_item_deactivated(_deactivated_shop_item:ShopItem)->void :
	var _focus = focus()


func on_shop_item_focused(shop_item:ShopItem)->void :
	enable_shop_lock_buttons_focus()
	emit_signal("shop_item_focused", shop_item)


func on_shop_item_unfocused(shop_item:ShopItem)->void :
	emit_signal("shop_item_unfocused", shop_item)


func focus()->Node:
	if _shop_items[1].active and _shop_items[1].value <= RunData.gold:
		_shop_items[1].focus()
		return _shop_items[1]
	else :
		for shop_item in _shop_items:
			if shop_item.active and shop_item.value <= RunData.gold:
				shop_item.focus()
				return shop_item
	
	emit_signal("focus_lost")
	return null


func reload_shop_items_descriptions()->void :
	for i in _shop_items.size():
		if _shop_items[i].active:
			_shop_items[i].set_shop_item(_shop_items[i].item_data, _shop_items[i].wave_value)


func set_shop_items(items_data:Array)->void :
	for i in _shop_items.size():
		if i < items_data.size():
			_shop_items[i].set_shop_item(items_data[i][0], items_data[i][1])
		else :
			_shop_items[i].deactivate()


func disable_shop_buttons_focus()->void :
	for shop_item in _shop_items:
		shop_item.disable_focus()


func enable_shop_buttons_focus()->void :
	for shop_item in _shop_items:
		shop_item.enable_focus()


func disable_shop_lock_buttons_focus()->void :
	for shop_item in _shop_items:
		shop_item.disable_lock_focus()


func enable_shop_lock_buttons_focus()->void :
	for shop_item in _shop_items:
		shop_item.enable_lock_focus()


func unlock_all_shop_items_visually()->void :
	for shop_item in _shop_items:
		shop_item.unlock_visually()


func lock_shop_item_visually(index:int = 0)->void :
	if index < _shop_items.size():
		_shop_items[index].lock_visually()


func on_mouse_hovered_category(shop_item:ShopItem)->void :
	emit_signal("mouse_hovered_category", shop_item)


func on_mouse_exited_category(shop_item:ShopItem)->void :
	emit_signal("mouse_exited_category", shop_item)


func _on_BuyDelayTimer_timeout()->void :
	if _is_delay_active:
		_is_delay_active = false
		
		
func _get_minimum_size()->Vector2:
	var result_height := 0
	
	var visual_child_count = 0
	
	for c in get_children():
		if c is Control:
			visual_child_count = visual_child_count + 1
			
	if visual_child_count == 0:
		return Vector2(get_rect().size.x, 0)
		
	var children_in_row = min(visual_child_count, max_children_in_row)
		
	var total_available_width = get_rect().size.x - (children_in_row - 1) * spacing
	
	var available_item_width  = total_available_width / children_in_row
	
	var x := 0
	var y := 0
	
	var max_item_height := 0
	
	for i in get_child_count():
		
		var c = get_child(i) as Control
		
		if (!c or !c.is_visible()):
			continue
			
		var item_minimum_size = c.get_combined_minimum_size()
		var scale = min(available_item_width / item_minimum_size.x, 1)
		
		max_item_height = max(max_item_height, item_minimum_size.y * scale)
		
		if x == max_children_in_row - 1:
			x = 0
			y += 1
			result_height += max_item_height
			max_item_height = 0
		else:
			x += 1
			
	if (x > 0):
		result_height += max_item_height
	
	return Vector2(get_rect().size.x, result_height)
	
func _resort():
	var visual_child_count = 0
	
	for c in get_children():
		if c is Control:
			visual_child_count = visual_child_count + 1
			
	if visual_child_count == 0:
		return
		
	var children_in_row = min(visual_child_count, max_children_in_row)
		
	var total_available_width = get_rect().size.x - (children_in_row - 1) * spacing
	
	var available_item_width  = total_available_width / children_in_row
	
	var x := 0
	var y := 0
	
	var max_item_height := 0
	
	for i in get_child_count():
		
		var c = get_child(i) as Control
		
		if (!c or !c.is_visible()):
			continue
			
		var item_minimum_size = c.get_combined_minimum_size()
		var scale = min(available_item_width / item_minimum_size.x, 1)
		
		max_item_height = max(max_item_height, item_minimum_size.y * scale)
			
		fit_child_in_rect(c, Rect2(
			x * (available_item_width + spacing),
			y * (max_item_height + spacing),
			available_item_width,
			item_minimum_size.y * scale))
			
		c.rect_scale = Vector2(scale, scale)
		
		if x == max_children_in_row - 1:
			x = 0
			y += 1
			max_item_height = 0
		else:
			x += 1

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_resort()
