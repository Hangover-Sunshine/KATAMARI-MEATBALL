extends Node

# System Loading ###################################################
signal load_scene(next_scene:String)
signal scene_loaded(new_scene:String)
signal scene_transition_started
signal scene_transition_done
# System Loading ###################################################

signal request_new_flee_point(civy:Civilian)
signal request_escort_point(civy:Civilian, adventurer)

signal convert_citizen_to_cultist(civy:Civilian)
