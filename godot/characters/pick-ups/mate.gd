extends Area2D
@onready var mateSound = $MateSound

func _on_body_entered(body: Node2D) -> void:
	mateSound.play()
	if body.has_method("recuperar_vida"):
		body.recuperar_vida(25)
		print("vida recuperada")
		queue_free()
