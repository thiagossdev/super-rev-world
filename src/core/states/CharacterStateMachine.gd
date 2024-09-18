extends BaseStateMachine
class_name CharacterStateMachine

var actor: Actor2D
var animation_tree: AnimationTree


func init(target):
	actor = target
	animation_tree = target.get_node("AnimationTree")
	super(target)


func init_child(child):
	child.actor = actor
	child.playback = animation_tree
	child.on_change_state.connect(change_state)
