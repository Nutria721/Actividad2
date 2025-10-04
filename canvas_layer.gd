extends CanvasLayer
@onready var hud := get_node("/root/Main/HUD")
@onready var score_label = $/Main/HUD/ScoreLabel
@onready var victory_label = $VictoryLabel
@onready var gameover_label = $GameOverLabel
@onready var restart_button = $RestartButton

func _ready():
	# Ocultar mensajes y botón al inicio
	victory_label.visible = false
	gameover_label.visible = false
	restart_button.visible = false
	
	# Conectar botón
	restart_button.pressed.connect(_on_restart_pressed)

func update_score(value: int):
	score_label.text = "Score: %d" % value

func show_victory():
	victory_label.visible = true
	restart_button.visible = true

func show_gameover():
	gameover_label.visible = true
	restart_button.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
