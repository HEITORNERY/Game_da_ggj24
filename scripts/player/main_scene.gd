extends Node2D

var dialog = preload('res://scenes/player/dialog_box.tscn')
var inst = null
var dialog_2 = preload('res://scenes/dialog/dialog_box_2.tscn')
var dialog_3 = preload('res://scenes/dialog/dialog_box_3.tscn')
var dialog_4 = preload('res://scenes/dialog/dialog_box_4.tscn')
var dialog_5 = preload('res://scenes/dialog/dialog_box_5.tscn')
var dialog_6 = preload('res://scenes/dialog/dialog_box_6.tscn')
# Guardar a referência ao player usando uma variável onready
onready var player : KinematicBody2D = get_node("Player")

func _ready() -> void:
	$AudioStreamPlayer2D.play()
	var _game_over : bool = player.get_node("Texture").connect("game_over", self, 'on_game_over')
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dialog"):
		inst = dialog.instance()
		$ui_canvas/control.add_child(inst)
		$label.visible = 0
	
	if event.is_action_pressed('dialog_2'):
		inst = dialog_2.instance()
		$ui_canvas/control.add_child(inst)
		$label.visible = 0

	if event.is_action_pressed('dialog_3'):
		inst = dialog_3.instance()
		$ui_canvas/control.add_child(inst)
		$label.visible = 0
		
	if event.is_action_pressed('dialog_4'):
		inst = dialog_4.instance()
		$ui_canvas/control.add_child(inst)
		$label.visible = 0
		
	if event.is_action_pressed('dialog_5'):
		inst = dialog_5.instance()
		$ui_canvas/control.add_child(inst)
		$label.visible = 0
		
	if event.is_action_pressed('dialog_6'):
		inst = dialog_6.instance()
		$ui_canvas/control.add_child(inst)
		$label.visible = 0
	
	if event.is_action_pressed('skip_dialog'):
		$ui_canvas/control.queue_free()
	
	if event.is_action_pressed('skip_tutorial'):
		get_tree().change_scene('res://scenes/management/level.tscn')
		Global.level = 1
		
func on_game_over() -> void:
	var _reload : bool = get_tree().reload_current_scene() # Aqui é a variável para recarregar a cena, assim que morrer

	
