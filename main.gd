extends Node

@onready var addres = $IU/BoxContainer/VBoxContainer/LineEdit.text

func _on_host_pressed() -> void:
	$ServerManager.CreateServer()
	$IU.hide()
	$Room/Mundo.show()
	
func _on_join_pressed() -> void:
	$ServerManager.CreateClient(addres)
	$IU.hide()
	$Room/Mundo.show()
	
