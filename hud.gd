extends CanvasLayer

# Referencias a los nodos dentro del VBoxContainer
@onready var score_label = $ScoreLabel
@onready var victory_label = $VictoryLabel
@onready var gameover_label = $GameOverLabel
@onready var restart_button = $RestartButton

func _ready():
	# Ocultar mensajes y botón al inicio
	victory_label.visible = false
	gameover_label.visible = false
	restart_button.visible = false
	
	# Conectar botón de reinicio
	restart_button.pressed.connect(_on_restart_pressed)

func update_score(value: int):
	if score_label:
		score_label.text = "Score: %d" % value

func show_victory():
	if victory_label:
		victory_label.visible = true
	if restart_button:
		restart_button.visible = true

func show_gameover():
	if gameover_label:
		gameover_label.visible = true
	if restart_button:
		restart_button.visible = true

func _on_restart_pressed():
	get_tree().reload_current_scene()
