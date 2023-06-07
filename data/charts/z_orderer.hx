// ! THIS FILE IS VERY IMPORTANT PLEASE DO NOT TOUCH (OR EDIT THE FILE NAME)!!!!!!!!!!! -lunar

import haxe.io.Path;

var scriptsOrder:Array<String> = [
    "ui_healthbar",
    "ui_psych",
    "stage_...",
    "debug_...",
    "codename_stage",
    "codename_songscripts",
];

var ui_Scripts:Array<Script> = []; var stage_Scripts:Array<Script> = []; var debug_Scripts:Array<Script> = []; 
var codename_stage_Scripts:Array<Script> = []; var codename_song_Scripts:Array<Script> = []; var codename_other_Scripts:Array<Script> = [];

var oldScripts:Array<Script> = PlayState.instance.scripts.scripts;
PlayState.instance.scripts.scripts = [];

for (script in oldScripts) {
    switch (Path.directory(script.path)) {
        case "data/charts":
            var fileName = Path.withoutExtension(Path.withoutDirectory(script.path));
            var array = switch (fileName.split("_").shift()) {
                case "ui": ui_Scripts;
                case "stage": stage_Scripts;
                case "debug": debug_Scripts;
            };
            if (fileName == "z_orderer") continue;

            if (scriptsOrder.contains(fileName)) {
                if (array.length-1 > scriptsOrder.indexOf(fileName)) array.insert(scriptsOrder.indexOf(fileName), script);
                else array.push(script);
            } else {
                for (scriptZ in scriptsOrder) {
                    if (StringTools.trim(scriptZ.split("_").pop()) != "...") continue;
                    if (fileName.split("_").shift() == scriptZ.split("_").shift())
                        array.push(script);
                }
            }

        case "assets/data/stages": codename_stage_Scripts.push(script);
        default: 
            if (StringTools.startsWith(Path.directory(script.path), "songs/")) 
                codename_song_Scripts.push(script);
            else codename_other_Scripts.push(script);
    }
}
    
var finalScripts:Array<Script> = [];

for (scripts in [ui_Scripts, stage_Scripts, debug_Scripts, codename_stage_Scripts, codename_song_Scripts, codename_other_Scripts])
    for (script in scripts) finalScripts.push(script);

PlayState.instance.scripts.scripts = finalScripts;