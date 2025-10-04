extends Area2D

# Referencias a nodos
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var collect_sound = $CollectSound  # AudioStreamPlayer2D para el sonido de la moneda

func _ready():
	# Conectar señal de colisión
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Verifica que el cuerpo que colisiona sea el jugador
	if body.is_in_group("player"):
		collect(body)

func collect(player):
	# Desactivar colisión y ocultar sprite
	collision_shape.set_deferred("disabled", true)
	sprite.visible = false

	# Reproducir sonido de recogida
	if collect_sound:
		collect_sound.play()

	# Espera un poco antes de eliminar la moneda
	await get_tree().create_timer(0.2).timeout
	queue_free()

	# Llamar a la función de victoria en el Player si existe
	if player.has_method("win_game"):
		player.win_game()
