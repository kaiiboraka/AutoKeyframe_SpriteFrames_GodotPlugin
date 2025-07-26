@tool
@icon("res://addons/AutoKey_SpriteFrames/icon.svg")
extends EditorInspectorPlugin

var _editor_interface: EditorInterface

func _can_handle(object: Object) -> bool:
	return object is AnimatedSprite2D

func _parse_begin(object: Object):
	if not (object is AnimatedSprite2D):
		return

	var button := Button.new()
	button.text = "Auto-Key SpriteFrames Animation"
	button.icon = preload("res://addons/AutoKey_SpriteFrames/icon.svg")
	button.pressed.connect(_on_auto_keyframe_button_pressed.bind(object))
	add_custom_control(button)

func _on_auto_keyframe_button_pressed(animated_sprite: AnimatedSprite2D):
	# --- 1. Get all necessary objects and data ---
	if not is_instance_valid(animated_sprite):
		push_error("AnimatedSprite2D instance is not valid.")
		return

	var sprite_frames: SpriteFrames = animated_sprite.sprite_frames
	if not sprite_frames:
		_show_warning_dialog("No SpriteFrames resource assigned.")
		return

	var anim_name: StringName = animated_sprite.animation
	if anim_name.is_empty() or not sprite_frames.has_animation(anim_name):
		_show_warning_dialog("No animation selected in AnimatedSprite2D.")
		return

	var anim_player: AnimationPlayer = animated_sprite.get_parent().find_child("AnimationPlayer", true, false)
	if not anim_player:
		anim_player = _editor_interface.get_edited_scene_root().find_child("AnimationPlayer", true, false)
	if not anim_player:
		_show_warning_dialog("No AnimationPlayer node found.")
		return

	var frame_count: int = sprite_frames.get_frame_count(anim_name)

	# --- 2. Get or create the Animation resource ---
	var library: AnimationLibrary = anim_player.get_animation_library("") # Get default library
	if not library:
		library = AnimationLibrary.new()
		anim_player.add_animation_library("", library)

	var animation: Animation
	if library.has_animation(anim_name):
		animation = library.get_animation(anim_name)
	else:
		animation = Animation.new()
		library.add_animation(anim_name, animation)

	# --- 3. Use the Animation's own step/FPS value ---
	var time_step = animation.step
	if time_step <= 0:
		time_step = 1.0 / 12.0 # Default to 12 FPS if not set

	# --- 4. Define the track paths ---
	var node_path_to_sprite = NodePath(animated_sprite.name)
	var anim_track_path = "%s:animation" % node_path_to_sprite
	var frame_track_path = "%s:frame" % node_path_to_sprite

	# --- 5. Find or create tracks and CLEAR them directly ---
	var anim_track_idx = animation.find_track(anim_track_path, Animation.TYPE_VALUE)
	if anim_track_idx == -1:
		anim_track_idx = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(anim_track_idx, anim_track_path)
	else:
		# Correct way to clear: loop backwards and remove each key
		for i in range(animation.track_get_key_count(anim_track_idx) - 1, -1, -1):
			animation.track_remove_key(anim_track_idx, i)
	
	var frame_track_idx = animation.find_track(frame_track_path, Animation.TYPE_VALUE)
	if frame_track_idx == -1:
		frame_track_idx = animation.add_track(Animation.TYPE_VALUE)
		animation.track_set_path(frame_track_idx, frame_track_path)
	else:
		# Correct way to clear: loop backwards and remove each key
		for i in range(animation.track_get_key_count(frame_track_idx) - 1, -1, -1):
			animation.track_remove_key(frame_track_idx, i)

	# --- 6. Set up UndoRedo for the CREATION of new keys ---
	var undo_redo: EditorUndoRedoManager = _editor_interface.get_editor_undo_redo()
	undo_redo.create_action("Auto Keyframe SpriteFrames")

	# --- 7. Queue all modifications for the transaction ---
	undo_redo.add_do_method(animation, "track_set_interpolation_type", anim_track_idx, Animation.INTERPOLATION_NEAREST)
	undo_redo.add_do_method(animation, "track_set_interpolation_type", frame_track_idx, Animation.INTERPOLATION_NEAREST)

	undo_redo.add_do_method(animation, "track_insert_key", anim_track_idx, 0.0, anim_name)

	for i in range(frame_count):
		var time: float = i * time_step
		undo_redo.add_do_method(animation, "track_insert_key", frame_track_idx, time, i)

	var total_length: float = frame_count * time_step
	undo_redo.add_do_method(animation, "set_length", total_length)
	undo_redo.add_do_method(animation, "set_step", time_step)

	# --- 8. Commit the action and notify user ---
	undo_redo.commit_action()
	_show_warning_dialog("Keyframes generated for '%s'." % anim_name, "Success")

func _show_warning_dialog(text: String, title: String = "Warning"):
	var dialog := AcceptDialog.new()
	dialog.title = title
	dialog.dialog_text = text
	_editor_interface.get_editor_main_screen().add_child(dialog)
	dialog.popup_centered()
	dialog.confirmed.connect(dialog.queue_free)
