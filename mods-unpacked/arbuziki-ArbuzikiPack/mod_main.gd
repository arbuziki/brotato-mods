extends Node

const ARBUZIKI_DIR = "arbuziki-ArbuzikiPack/"
const ARBUZIKI_LOG = "arbuziki-ArbuzikiPack"

var dir = ""
var ext_dir = ""
var tr_dir = ""

const script_extensions := [
	"main.gd",
	"singletons/run_data.gd",
	"singletons/item_service.gd",
	"ui/menus/pages/main_menu.gd",
	"entities/units/enemies/enemy.gd",
	"entities/units/enemies/boss/boss.gd",
	"visual_effects/floating_text/floating_text_manager.gd"
]

const translations := [
	"arbuzikiPack_text.en.translation",
	"arbuzikiPack_text.ru.translation"
]

func _init(mod_loader = ModLoader)->void:
	ModLoaderLog.info("Init", ARBUZIKI_LOG)

	dir = ModLoaderMod.get_unpacked_dir() + ARBUZIKI_DIR
	ext_dir = dir + "extensions/"
	tr_dir = dir + "translations/"

	_install_script_extensions(script_extensions)
	_install_translations(translations)
	
func _ready()->void:
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	
	var content_dir = dir + "content_data/"
	
	ContentLoader.load_data(content_dir + "arbuzikipack_content.tres", ARBUZIKI_LOG)

func _install_script_extensions(extensions: Array)->void:
	ModLoaderLog.info("Installing extensions...", ARBUZIKI_LOG)
	
	for extension in extensions:
		ModLoaderLog.debug(str("Installing: ", extension), ARBUZIKI_LOG)
		ModLoaderMod.install_script_extension(ext_dir + extension)
		
	ModLoaderLog.info("Installing extensions completed!", ARBUZIKI_LOG)

func _install_translations(translations: Array)->void:
	ModLoaderLog.info("Installing translations...", ARBUZIKI_LOG)
	
	for translation in translations:
		ModLoaderLog.debug(str("Installing translation: ", translation), ARBUZIKI_LOG)
		ModLoaderMod.add_translation(tr_dir + translation)
		
	ModLoaderLog.info("Installing translations comleted!", ARBUZIKI_LOG)
