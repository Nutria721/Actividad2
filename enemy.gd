extends CharacterBody2D

@export var speed := 100.0
@export var patrol_distance := 150.0
@export var gravity := 400.0
@export var jump_force := -250.0
@export var jump_interval := 2.0 # cada 2 segundos intenta saltar


var direction := 1
var start_x := 0.0
var dead := false


@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = Timer.new()
@onready var hitbox: CollisionShape2D = $DamageEnemyToPlayer   # mata al jugador
@onready var hurtbox: CollisionShape2D = $DamagePlayerToEnemy  # vulnerable

func _ready():
	start_x = position.x
	anim_sprite.play("run")

	# Configurar el timer para saltar
	jump_timer.wait_time = jump_interval
	jump_timer.autostart = true
	jump_timer.one_shot = false
	add_child(jump_timer)
	jump_timer.timeout.connect(_on_jump_timer_timeout)

func _physics_process(delta):
	if dead:
		return

	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movimiento horizontal
	velocity.x = direction * speed
	move_and_slide()

	# Animación
	if velocity.x != 0:
		if not anim_sprite.is_playing():
			anim_sprite.play("run")
		anim_sprite.flip_h = velocity.x > 0
	else:
		anim_sprite.stop()

	# Cambiar dirección al llegar al límite
	if abs(position.x - start_x) >= patrol_distance:
		direction *= -1

func _on_jump_timer_timeout():
	if is_on_floor():
		velocity.y = jump_force

func die():
	if dead: return
	dead = true
	if anim_sprite.sprite_frames.has_animation("die"):
		anim_sprite.play("die")
	await get_tree().create_timer(0.3).timeout # pequeña pausa antes de borrarse
	queue_free()
