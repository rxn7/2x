extends Node

const FILE_PATH: String = "user://save.dat"

var data: SaveData

func _init():
    load_data()

func save_data() -> void:
    # yes, its saved in plain text, cry about it 
    var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
    file.store_32(data.best_score)
    file.close()

func load_data() -> void:
    data = SaveData.new() 
    if FileAccess.file_exists(FILE_PATH):
        var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.READ)
        data.best_score = file.get_64()