extends CharacterBody2D
@export var vida = Global.enemigo_1_vida
@onready var vidaActual = vida
@export var speed = Global.enemigo_1_speed
@onready var dmg = Global.enemyDmg
@onready var deathSound = $SoundDeath
@onready var sprite = $AnimatedSprite2D
@onready var col_shape = $CollisionShape2D

var player_ref: Node = null

var player
signal enemigo_muere

func _ready():
	player = get_node("../Player")


func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	var angle = direction.angle() # Calcular ángulo
	sprite.rotation = angle  + deg_to_rad(90)
	col_shape.rotation = angle
	velocity = direction * speed
	move_and_slide()

func take_damage(dmgDone):
	vidaActual -= dmgDone
	print("recibio daño")
	if vidaActual <= 0:
		enemigo_muere.emit()
		Global.efecto_muerte(self)
		deathSound.play()

func _on_enemigo_muere() -> void:
	Global.puntaje += 1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage_player"):
		body.take_damage_player(dmg)
		print("daño a player")



		
