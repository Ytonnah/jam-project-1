extends Node

var WorldStateOverride = []
func append_state(object,properties):
	WorldStateOverride.append([object,properties])
	
	
#example: append_state(<yung object>, yung configs, like name, toggle state,etc)


func reload_state():
	pass
