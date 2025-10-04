extends Area2D
func _on_Hurtbox_body_entered(body):
	if body.is_in_group("enemy"):
		die()

func die():
	get_tree().reload_current_scene()
