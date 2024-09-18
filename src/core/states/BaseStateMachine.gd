class_name BaseStateMachine
extends Node

@export var current_state: BaseState

var states: Dictionary = {}
var _target: Node2D


func init(target: Node2D):
	_target = target
	for child in get_children():
		if child is BaseState and child.state_name.length() > 0:
			states[child.state_name] = child
			init_child(child)
		else:
			push_warning("Child[" + child.name + "] is not a State for StateMachine")

	print(states)


func init_child(child):
	child.target = _target
	child.on_change_state.connect(change_state)


func change_state(state_name: String) -> void:
	var state = states.get(state_name)

	if not state:
		push_warning("State[" + state_name + "] is not found")
		return

	if current_state != null:
		current_state.exit()

	current_state = state
	current_state.enter()


func physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)


func input(event: InputEvent) -> void:
	if current_state:
		current_state.input(event)


func process(delta: float) -> void:
	if current_state:
		current_state.process(delta)
