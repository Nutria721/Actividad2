@onready var bgm = $AudioStreamPlayer

func _ready():
	bgm.play()  # Reproducir la música al iniciar
