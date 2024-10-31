extends Node

signal on_create_bullet(pos: Vector2, direction: Vector2, speed: float, lifespan: float, type: Constants.ObjectType)
signal on_create_object(pos: Vector2, type: Constants.ObjectType)
signal on_pickup_hit(points: int)
signal on_game_over
signal on_player_hit(heart: int)
