extends CharacterBody2D

# --- Variables exportadas ---
@export var run_speed := 220.0
@export var jump_force := -500.0
@export var gravity := 1200.0
@export var acceleration := 15.0
@export var friction := 20.0
@export var max_jumps := 2

# --- Variables internas ---
var jumps_left := 0
var coyote_time := 0.15
var coyote_timer := 0.0
var jump_buffer_time := 0.1
var jump_buffer_timer := 0.0

var score := 0
var dead := false
var won := false

# --- Referencias ---
@onready var anim := $AnimatedSprite2D
@onready var hud := get_node("/root/Main/HUD")  # Ajusta la ruta si tu nodo Main tiene otro nombre
@onready var musica = $Musica

func _ready():
	jumps_left = max_jumps
	add_to_group("player")
	print("Score inicial: %d" % score)
	hud.update_score(score)
	musica.play()

func _physics_process(delta):
	if dead or won: 
		return

	# --- Gravedad ---
	if not is_on_floor():
		velocity.y += gravity * delta

	# --- Coyote time ---
	if is_on_floor():
		coyote_timer = coyote_time
		jumps_left = max_jumps
	else:
		coyote_timer -= delta

	# --- Movimiento lateral ---
	var input_dir = Input.get_axis("ui_left", "ui_right")

	if input_dir != 0:
		velocity.x = lerp(velocity.x, input_dir * run_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

	# --- Buffer de salto ---
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and (coyote_timer > 0 or jumps_left > 0):
		velocity.y = jump_force
		jump_buffer_timer = 0
		coyote_timer = 0
		jumps_left -= 1

	# --- Animaciones ---
	if not is_on_floor():
		anim.play("jump")
		if input_dir != 0:
			anim.flip_h = input_dir < 0
	elif abs(velocity.x) > 10:
		anim.play("run")
		anim.flip_h = velocity.x < 0
	else:
		anim.play("idle")

	# --- Movimiento ---
	move_and_slide()

	# --- Verificar colisiones ---
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()

		if other is CharacterBody2D and other.has_method("die"):
			var enemy_hurtbox = other.get_node_or_null("DamagePlayerToEnemy")
			var enemy_hitbox = other.get_node_or_null("DamageEnemyToPlayer")

			if enemy_hurtbox:
				other.die()
				velocity.y = jump_force / 2
				add_score(100)

			elif enemy_hitbox:
				die()

		elif other.has_method("collect"):
			other.collect()
			win_game()


func add_score(amount: int):
	score += amount
	hud.update_score(score)
	print("Score actualizado: %d" % score)

func die():
	if dead: return
	dead = true
	if anim.sprite_frames.has_animation("die"):
		anim.play("die")
	print("Jugador murió! Score final: %d" % score)
	hud.show_gameover()

func win_game():
	if won or dead: return
	won = true
	if anim.sprite_frames.has_animation("win"):
		anim.play("win")
	else:
		anim.play("idle")
	print("¡Victoria! Score final: %d" % score)
	hud.show_victory()
