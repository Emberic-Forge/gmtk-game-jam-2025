@tool
extends BoxContainer
# Main View to Preview Inputs
@onready var main_view = $MainView
# Buttons
@onready var clear_composer : Button = $"Control/Main Buttons/Clear Composer"
@onready var load_map : Button = $"Control/Main Buttons/Load Map"
@onready var save_map : Button = $"Control/Main Buttons/Save Map"
