@tool
extends EditorPlugin


func _enter_tree() -> void:

	add_custom_type("NinePatchMesh", "ArrayMesh", preload("uid://3qc414feoonh"), preload("uid://dpv60tlbs6wif"))
	add_custom_type("TwentySevenPatchMesh", "ArrayMesh", preload("uid://cq4x3sxs5rk2"), preload("uid://dpv60tlbs6wif"))


func _exit_tree() -> void:

	remove_custom_type("NinePatchMesh")
	remove_custom_type("TwentySevenPatchMesh")
