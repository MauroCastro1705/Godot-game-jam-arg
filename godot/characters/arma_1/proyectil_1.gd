extends Node2D
@export var speed = Global.balaSpeed1
@export var dmg = Global.balaDmg1
var direction: Vector2 = Vector2.ZERO

func set_direction(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()  # Solo se rota una vez al disparar

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigos"):
		print("enemigo hit")
		queue_free()
		if body.has_method("take_damage"):
			body.take_damage(dmg)#daño del arma
		
