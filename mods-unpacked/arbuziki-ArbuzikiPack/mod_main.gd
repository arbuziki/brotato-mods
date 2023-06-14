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
	"ui/menus/pages/main_menu.gd"
]

const translations := [
	"arbuzikiPack_text.en.translation",
	"arbuzikiPack_text.ru.translation"
]

func _init(mod_loader = ModLoader)->void:
	ModLoaderUtils.log_info("Init", ARBUZIKI_LOG)

	dir = mod_loader.UNPACKED_DIR + ARBUZIKI_DIR
	ext_dir = dir + "extensions/"
	tr_dir = dir + "translations/"

	_install_script_extensions(script_extensions, mod_loader)
	_install_translations(translations, mod_loader)
	
func _ready()->void:
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	
	var content_dir = dir + "content_data/"
	
	ContentLoader.load_data(content_dir + "arbuzikipack_content.tres", ARBUZIKI_LOG)

func _install_script_extensions(extensions: Array, mod_loader: ModLoader)->void:
	ModLoaderUtils.log_info("Installing extensions...", ARBUZIKI_LOG)
	
	for extension in extensions:
		ModLoaderUtils.log_debug(str("Installing: ", extension), ARBUZIKI_LOG)
		mod_loader.install_script_extension(ext_dir + extension)
		
	ModLoaderUtils.log_info("Installing extensions completed!", ARBUZIKI_LOG)

func _install_translations(translations: Array, mod_loader: ModLoader)->void:
	ModLoaderUtils.log_info("Installing translations...", ARBUZIKI_LOG)
	
	for translation in translations:
		ModLoaderUtils.log_debug(str("Installing translation: ", translation), ARBUZIKI_LOG)
		mod_loader.add_translation_from_resource(tr_dir + translation)
		
	ModLoaderUtils.log_info("Installing translations comleted!", ARBUZIKI_LOG)
