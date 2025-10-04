extends CanvasLayer

@onready var score_label = $UI_HUD/HUDContainer/VBoxContainer/ScoreLabel

@onready var game_over_screen = $GameOverScreen
@onready var game_over_label = $GameOverScreen/Panel/VBoxContainer/GameOverLabel
@onready var game_over_final_score = $GameOverScreen/Panel/VBoxContainer/FinalScoreLabel
@onready var game_over_restart_button = $GameOverScreen/Panel/VBoxContainer/RestartButton
@onready var game_over_menu_button = $GameOverScreen/Panel/VBoxContainer/MenuButton
@onready var game_over_anim = $GameOverScreen/Panel/VBoxContainer/AnimationPlayer

@onready var victory_screen = $VictoryScreen
@onready var victory_label = $VictoryScreen/Panel/VBoxContainer/VictoryLabel
@onready var victory_final_score = $VictoryScreen/Panel/VBoxContainer/FinalScoreLabel
@onready var victory_restart_button = $VictoryScreen/Panel/VBoxContainer/RestartButton
@onready var victory_menu_button = $VictoryScreen/Panel/VBoxContainer/MenuButton
@onready var victory_anim = $VictoryScreen/Panel/VBoxContainer/AnimationPlayer


func _ready():
	# Inicializar HUD
	update_score(0)
	game_over_screen.visible = false
	victory_screen.visible = false

	# Conectar botones
	game_over_restart_button.pressed.connect(_on_restart_pressed)
	game_over_menu_button.pressed.connect(_on_menu_pressed)
	victory_restart_button.pressed.connect(_on_restart_pressed)
	victory_menu_button.pressed.connect(_on_menu_pressed)


# --- Actualizar Puntuación ---
func update_score(value: int):
	score_label.text = "Score: %d" % value


# --- Mostrar Pantalla de Game Over ---
func show_game_over(final_score: int):
	game_over_screen.visible = true
	game_over_final_score.text = "Final Score: %d" % final_score
	if game_over_anim.has_animation("show"):
		game_over_anim.play("show")


# --- Mostrar Pantalla de Victoria ---
func show_victory(final_score: int):
	victory_screen.visible = true
	victory_final_score.text = "Final Score: %d" % final_score
	if victory_anim.has_animation("show"):
		victory_anim.play("show")


# --- Botones ---
func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_menu_pressed():
	# Aquí cargas tu escena de menú principal
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
