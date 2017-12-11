# CELL
extends Control

# living or dead
var tile_type
# position on the grid
var x 
var y
# the Animation Playernode
onready var anim = get_node("AnimationPlayer")

func initialize_tile(x, y):
	self.x = x
	self.y = y
	
func set_type(type):
	tile_type = type
	# 0 is living 1 is dead
	if tile_type == 0:
		anim.play("Living")
	else:
		anim.play("Dead")
		
func get_type():
	return tile_type

