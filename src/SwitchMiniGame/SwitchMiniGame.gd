extends Control


enum CALL_TYPE {
	PERSONAL = 0,
	WORK,
}

signal finished

onready var slider = $SlideBackground/SliderPickup
onready var slider_anim = $SlideBackground/AnimationPlayer

onready var female_avatar = $Avatars/FemalePortrait
onready var male_avatar = $Avatars/MalePortrait
onready var contact_name = $Avatars/ContactName

export (String, MULTILINE) var PersonalFemales
export (String, MULTILINE) var PersonalMales

export (String, MULTILINE) var WorkFemales
export (String, MULTILINE) var WorkMales

var pickup_has_focus = false
var start_pos := Vector2()
var curr_pos := Vector2()

var current_call_type = CALL_TYPE.PERSONAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func initiate_minigame(value : int) -> void:
	current_call_type = value
	randomize()

	if current_call_type == CALL_TYPE.PERSONAL:
		if randf() > 0.25:
			var items = PersonalFemales.split('\n')
			$Avatars/ContactName.text = items[randi() % items.size()].strip_edges()
			$Avatars/FemalePortrait.visible = true
		else:
			var items = PersonalMales.split('\n')
			$Avatars/ContactName.text = items[randi() % items.size()].strip_edges()
			$Avatars/MalePortrait.visible = true
	else:
		if randf() > 0.5:
			var items = WorkFemales.split('\n')
			$Avatars/ContactName.text = items[randi() % items.size()].strip_edges()
			$Avatars/FemalePortrait.visible = true
		else:
			var items = WorkMales.split('\n')
			$Avatars/ContactName.text = items[randi() % items.size()].strip_edges()
			$Avatars/MalePortrait.visible = true


func _process(delta: float) -> void:
	if slider.rect_position.x == 256:
		slider_anim.play("Fade")

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and pickup_has_focus:
		curr_pos = get_global_mouse_position()
		var diff = curr_pos.x - start_pos.x

		if slider.rect_position.x < 128:
			slider.rect_position.x = max(0, min(256, diff))
		else:
			slider.rect_position.x = 256

func _on_SliderPickup_button_down() -> void:
	pickup_has_focus = true
	curr_pos = get_global_mouse_position()
	start_pos = curr_pos
	#print_debug("Gained Focus")


func _on_SliderPickup_button_up() -> void:
	pickup_has_focus = false

	if slider.rect_position.x < 64:
		slider.rect_position.x = 0
	else:
		slider.rect_position.x = 256
	#print_debug("Lost Focus")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	slider_anim.stop()
	$SlideBackground.visible =false
	slider.rect_position.x = 0
	emit_signal("finished", true)


func _on_ButtonHangUp_pressed() -> void:
	emit_signal("finished", false)
