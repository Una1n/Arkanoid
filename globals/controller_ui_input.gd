extends Node

#Simple script that listens for joystick movements from device 0 and interprets them as UI movements

#use some variables to keep track of if a certain joystick direction has been pressed this tick already
#this allows us to use _input(event) to check for new joystick inputs, rather than doing constant polling in _process
var joystickLeftThisTick = false
var joystickRightThisTick = false
var joystickUpThisTick = false
var joystickDownThisTick = false

func _process(_delta: float) -> void:
	#Check any joystick directions that were held, and if they are no longer
	#held, reset them (including the input events)
	if joystickLeftThisTick && !Input.is_action_pressed("ui_left_joystick"):
		joystickLeftThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_left"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)

	if joystickRightThisTick && !Input.is_action_pressed("ui_right_joystick"):
		joystickRightThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_right"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)

	if joystickUpThisTick && !Input.is_action_pressed("ui_up_joystick"):
		joystickUpThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_up"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)

	if joystickDownThisTick && !Input.is_action_pressed("ui_down_joystick"):
		joystickDownThisTick = false
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_down"
		uiEvent.pressed = false
		Input.parse_input_event(uiEvent)

#Use the Input's action_just_pressed to avoid duplicate calls
func _input(_event: InputEvent) -> void:
	if !joystickLeftThisTick && Input.is_action_just_pressed("ui_left_joystick"):
		joystickLeftThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_left"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)

	if !joystickRightThisTick && Input.is_action_just_pressed("ui_right_joystick"):
		joystickRightThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_right"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)

	if !joystickUpThisTick && Input.is_action_just_pressed("ui_up_joystick"):
		joystickUpThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_up"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)

	if !joystickDownThisTick && Input.is_action_just_pressed("ui_down_joystick"):
		joystickDownThisTick = true
		var uiEvent = InputEventAction.new()
		uiEvent.action = "ui_down"
		uiEvent.pressed = true
		Input.parse_input_event(uiEvent)
