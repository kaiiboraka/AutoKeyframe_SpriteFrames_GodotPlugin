@tool
@icon("res://addons/AutoKey_SpriteFrames/icon.svg")
extends EditorPlugin

var inspector_plugin : EditorInspectorPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	# Add the custom inspector plugin.
	inspector_plugin = preload("res://addons/AutoKey_SpriteFrames/inspector_plugin.gd").new()
	inspector_plugin._editor_interface = get_editor_interface()
	add_inspector_plugin(inspector_plugin)
	
	print("AnimatedSprite Animator Plugin Enabled")

func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the custom inspector plugin.
	if inspector_plugin:
		remove_inspector_plugin(inspector_plugin)
		inspector_plugin.free()
		inspector_plugin = null
	print("AnimatedSprite Animator Plugin Disabled")
