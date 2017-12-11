# GAME OF LIFE

extends Node2D

var grid = {} # dictionary to hold all the cells

export var width = 10	# total cells wide
export var height = 10	#total cells tall
export var cell_size = 32 # width/height of the graphic in pixels
export var spawn_rate = 50	# percentage to start living 
var spacer = 5 				# distance between cells

var start_position	# position to start the grid
var step_timer	#
var reset_button

var cell = preload("res://scenes/cell.tscn")

func _ready():
	randomize()
	start_position = get_node("StartPosition")
	step_timer = get_node("StepTimer")
	step_timer.connect("timeout", self, "_on_step_timer_timeout")
	reset_button = get_node("ResetButton")
	reset_button.connect("pressed", self, "_on_reset_button_pressed")
	initialize_grid()
	randomize_grid()

func _on_reset_button_pressed():
	randomize_grid()

func _on_step_timer_timeout():
	step()

func initialize_grid():
	for y in height:
		for x in width:
			var new_cell = cell.instance()
			new_cell.initialize_tile(x,y)
			# this line does the heaving lifing, adding the start position node to the cell position and includig a spacer
			new_cell.rect_position = (Vector2(start_position.position.x + x*(cell_size+spacer), start_position.position.y + y*(cell_size+spacer)))
			add_child(new_cell)
			grid[Vector2(x,y)] = new_cell
	
func randomize_grid():
	for y in height:
		for x in width:
			var cell = grid[Vector2(x,y)]
			if rand_range(1,101) <= spawn_rate:
				cell.set_type(0)
			else:
				cell.set_type(1)

func get_living_neighbors(cell):
	var living_neighbors = 0
	for i in range(-1,2):
		for j in range(-1,2):
			var x = cell.x+i
			var y = cell.y+j
			# looking at ourselves
			if i == 0 and j == 0:
				pass
			# if we're not off the map, get the number of living neighbors
			elif x >= 0 and x <=width-1 and y >=0 and y <=height-1:
				if grid[Vector2(x,y)].get_type() == 0:
					living_neighbors += 1
					
	return living_neighbors

func step():
# 	step over each cell in the grid, check if its living or dead
# 	and then apply the rules to the game of life according to the cell's status
#
#	Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
#	Any live cell with two or three live neighbours lives on to the next generation.
#	Any live cell with more than three live neighbours dies, as if by overpopulation.
#	Any dead cell with exactly three live neighbours becomes a live cell, as if by reproductio
	var types = []
	for y in height:
		for x in width:
			cell = grid[Vector2(x,y)]
			var living_neighbors = get_living_neighbors(cell)
			# living
			if cell.get_type() == 0:
				if living_neighbors < 2 or living_neighbors > 3:
					types.append(1)
				elif living_neighbors == 2 or living_neighbors == 3:
					types.append(0)
			# dead
			elif living_neighbors == 3:
				types.append(0)
			else:
				types.append(1)
				
	var index = 0
	for y in height:
		for x in width:
			grid[Vector2(x,y)].set_type(types[index])
			index+=1