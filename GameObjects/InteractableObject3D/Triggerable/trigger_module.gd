extends Node3D

#Localize and customize your trigger script
func get_sibling_nodes():
	return get_parent().get_children()
	
enum commands {TOGGLE,ACTIVATE,DEACTIVATE,DELETE}
	
func get_parent_script_func():
	print(get_parent().get_method_list())

func trigger():
	var type = get_parent().get_meta("Type")
	
	var parent:Node3D = get_parent()
	if type == null:
		return
	else:
		match  type:
			"Deletion":
				if is_instance_valid(parent):
					get_parent().queue_free()
			"Activate":
				if parent.has_meta("Enabled"):
					if parent.get_meta("Enabled") == false:
						parent.set_meta("Enabled",true)
						print_debug(str(parent.name) + "Activated")
						
					else:
						parent.set_meta("Enabled",false)
						print_debug(str(parent.name) + "Deactivated")
				else:
					parent.set_meta("Enabled",false)
					
					
					
				
