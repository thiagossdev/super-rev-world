class_name BaseState
extends Node

@export var state_name: String:
	get:
		return state_name if state_name.length() > 0 else str(name)
	set(value):
		state_name = value.strip_edges()

var next_state

signal on_change_state(state: BaseState)


func enter() -> void:
	pass


func exit() -> void:
	pass


func change_state(state_name: String) -> void:
	on_change_state.emit(state_name)


func input(_event: InputEvent) -> BaseState:
	return null


func process(_delta: float) -> BaseState:
	return null


func physics_process(_delta: float) -> BaseState:
	return null
