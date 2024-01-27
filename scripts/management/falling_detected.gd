extends Area2D

var on_player_entered : bool = false

var player_body : KinematicBody2D = null 

func _process(_delta: float) -> void:
	if on_player_entered:
		var _reload : bool = get_tree().reload_current_scene()

func _on_FallingDetected_body_entered(body: Player) -> void:
	on_player_entered = true 
	player_body = body 
	
