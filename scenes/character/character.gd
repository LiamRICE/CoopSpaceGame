extends CharacterBody2D

class_name Character

# movment constants
const WALK: float = 6000.0
const RUN: float = 24000.0

# movment variables
var speed: float = WALK
var direction: Vector2 = Vector2.ZERO
var sprint: bool = false

