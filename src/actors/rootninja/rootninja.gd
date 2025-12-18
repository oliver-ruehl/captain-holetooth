extends Node

@export var select_dialogbox: NodePath #Select the node path
@onready var dialogbox = get_node(select_dialogbox)

signal met_rootninja
