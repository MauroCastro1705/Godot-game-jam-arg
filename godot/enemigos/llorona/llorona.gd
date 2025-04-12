extends CharacterBody2D

@export var vida: int = 120
@export var speed_normal: float = 40
@export var speed_escondida: float = 90
@export var angulo_vision_jugador: float = 60.0
@export var distancia_escondite: float = 200
@export var tiempo_inmovilidad: float = 1.0

var player
var estado: String = "acechar"
var estado_anterior: String = ""
var siendo_visto: bool = false
var timer_inmovilidad: float = 0.0
var ultima_pos_conocida: Vector2
var mask = 1 << 3
signal enemigo_muere

func _ready():
	player = get_node("../Player")
	ultima_pos_conocida = global_position


func _physics_process(delta):
	# Verificar si el jugador está viendola
	siendo_visto = jugador_esta_mirando()
	
	if estado != estado_anterior:
		print("Cambio de estado a ", estado)
		estado_anterior = estado
	
	match estado:
		"acechar":
			if siendo_visto:
				estado = "inmovilizar"
				timer_inmovilidad = tiempo_inmovilidad
				velocity = Vector2.ZERO
			else:
				# Se mueve rápidamente cuando no la ven
				var direction = global_position.direction_to(player.global_position)
				velocity = direction * speed_escondida
				
		"inmovilizar":
			velocity = Vector2.ZERO
			timer_inmovilidad -= delta
			
			if timer_inmovilidad <= 0:
				if siendo_visto:
					estado = "retroceder"
					ultima_pos_conocida = buscar_punto_escondite()
				else:
					estado = "acechar"
					
		"retroceder":
			if siendo_visto:
				var direction = global_position.direction_to(ultima_pos_conocida)
				velocity = direction * speed_normal
				
				# Si consigue esconderse o ya no la ven
				if global_position.distance_to(ultima_pos_conocida) < 20:
					estado = "inmovilizar"
					timer_inmovilidad = tiempo_inmovilidad
			else:
				estado = "acechar"
	
	move_and_slide()

func jugador_esta_mirando() -> bool:
	# Dirección del player
	var dir_jugador = player.global_transform.basis_xform(Vector2.RIGHT).normalized()
	
	# Dirección desde el player a la llorona
	var dir_hacia_enemigo = global_position - player.global_position
	dir_hacia_enemigo = dir_hacia_enemigo.normalized()
	
	# Ángulo entre dirección player y dirección llorona
	var angulo = rad_to_deg(acos(dir_jugador.dot(dir_hacia_enemigo)))
	
	# Verificar si llorona dentro del cono de visión
	if angulo < angulo_vision_jugador / 2:
		# Se verifica con raycast
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(player.global_position, global_position, mask, [self, player])
		var result = space_state.intersect_ray(query)
		
		return result.is_empty() # Hay línea de visión
	return false
	
func buscar_punto_escondite() -> Vector2:
	var dir_alejamiento = (global_position - player.global_position).normalized() # Calcular dirección opuesta del player
	var pos_escondite = global_position + dir_alejamiento * distancia_escondite
	
	# Verificar validez
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, pos_escondite, mask, [self])
	var result = space_state.intersect_ray(query)
	
	if result.is_empty():
		return pos_escondite
	else:
		return result["position"] - dir_alejamiento * 10 # Usar punto antes de la colisión

func take_damage(dmgDone):
	vida -= dmgDone
	print("Llorana recibió daño: ", dmgDone, " - Vida: ", vida)
	
	if estado != "retroceder": # Cambiar comportamiento al recibir daño
		estado = "retroceder"
		ultima_pos_conocida = buscar_punto_escondite()
	
	if vida <= 0:
		enemigo_muere.emit()
		queue_free()


func _on_enemigo_muere() -> void:
	pass # sumar puntos?
