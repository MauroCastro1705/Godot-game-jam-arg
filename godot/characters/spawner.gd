extends Node2D
@onready var path_follow = $Path2D/PathFollow2D
@export var enemigo1: PackedScene
@export var lobizon: PackedScene
@export var luzMala: PackedScene
@export var chancho: PackedScene
@onready var timer = %enemigo_timer

func spawn_enemy_basico():
	# Choose a random location along the path (from 0 to 1)
	path_follow.progress_ratio = randf()
	var enemy = enemigo1.instantiate()
	enemy.global_position = path_follow.global_position    
	get_tree().current_scene.add_child(enemy)

func spawn_enemy_luz_mala():
	# Choose a random location along the path (from 0 to 1)
	path_follow.progress_ratio = randf()
	var enemy = luzMala.instantiate()
	enemy.global_position = path_follow.global_position    
	get_tree().current_scene.add_child(enemy)

func spawn_enemy_lobizon():
	# Choose a random location along the path (from 0 to 1)
	path_follow.progress_ratio = randf()
	var enemy = lobizon.instantiate()
	enemy.global_position = path_follow.global_position    
	get_tree().current_scene.add_child(enemy)
	
func spawn_enemy_chancho():
	# Choose a random location along the path (from 0 to 1)
	path_follow.progress_ratio = randf()
	var enemy = chancho.instantiate()
	enemy.global_position = path_follow.global_position    
	get_tree().current_scene.add_child(enemy)

func _on_enemigo_timer_timeout() -> void:
	spawn_enemy_basico()
	print("enemigo creado")
	if Global.puntaje >= 10 :
		spawn_enemy_chancho()
		print("enemigo chancho creado")
	else:
		if Global.puntaje >= 20:
			spawn_enemy_luz_mala()
			print("enemigo luz mala creado")
		else:
			if Global.puntaje >= 30:
				spawn_enemy_lobizon()
				print("enemigo lobizon creado")
	$enemigo_timer.start()
