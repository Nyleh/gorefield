//
import funkin.game.HealthIcon;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import funkin.game.PlayState;
import flixel.math.FlxMath;

var iconOffsets:Array<FlxPoint> = [];

var gorefieldhealthBarBG:FlxSprite;
var gorefieldhealthBar:FlxSprite;

var gorefieldiconP1:FlxSprite;
var gorefieldiconP2:FlxSprite;

function postCreate() {
    healthBar.visible = healthBarBG.visible = iconP1.visible = iconP2.visible = false;
}

function create() {
    gorefieldhealthBarBG = new FlxSprite().loadGraphic(Paths.image("game/healthbar/healthbar_" + ((stage != null && stage.stageXML != null && stage.stageXML.exists("healthBarColor")) ? stage.stageXML.get("healthBarColor") : "orange")));
    gorefieldhealthBarBG.cameras = [camHUD];
    add(gorefieldhealthBarBG);
    gorefieldhealthBarBG.scale.set(0.995, 1.05);

    gorefieldhealthBar = new FlxBar(0, 0, FlxBarFillDirection.RIGHT_TO_LEFT, 804, 18, PlayState.instance, "health", 0, maxHealth);
    gorefieldhealthBar.createImageBar(Paths.image("game/healthbar/filler_right"), Paths.image("game/healthbar/filler_left"));

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar]) {
        spr.scrollFactor.set(); spr.updateHitbox(); spr.cameras = [camHUD]; add(spr); spr.screenCenter(0x01);
    }

    health -= 0.02; // ZERO WHY DO YOU DO THIS TO ME >:((
    gorefieldhealthBar.y = (gorefieldhealthBarBG.y = FlxG.height * 0.83) + 34;

    for (newIcon in 0...2) {
        var icon = new FlxSprite();

        var path = 'icons/' + switch (newIcon) {
            case 1: (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("icon")) ? boyfriend.xml.get("icon") : "face";
            case 0: (dad != null && dad.xml != null && dad.xml.exists("icon")) ? dad.xml.get("icon") : "face";
        };
		if (!Assets.exists(Paths.image(path))) path = 'icons/face';

        if (switch (newIcon) {
                case 1: (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("animatedIcon")) ? (boyfriend.xml.get("animatedIcon") == "true") : false;
                case 0: (dad != null && dad.xml != null && dad.xml.exists("animatedIcon")) ? (dad.xml.get("animatedIcon") == "true") : false;
        }) {
            icon.frames = Paths.getSparrowAtlas(path);
            icon.animation.addByPrefix("losing", "losing", 24, true);
            icon.animation.addByPrefix("idle", "idle", 24, true);
            icon.animation.play("idle");
        } else {
            icon.loadGraphic(Paths.image(path)); // load once to get the width and stuff
            icon.loadGraphic(icon.graphic, true, icon.graphic.width/2, icon.graphic.height);
            icon.animation.add("non-animated", [0,1], 0, false);
            icon.animation.play("non-animated");
        }

        icon.flipX = newIcon == 1; 
        icon.updateHitbox();
        icon.cameras = [camHUD]; icon.scrollFactor.set();

        add(switch (newIcon) {
            case 1: gorefieldiconP1 = icon;
            case 0: gorefieldiconP2 = icon;
        });

        var iconOffset:FlxPoint = null;
        iconOffsets.push(iconOffset = switch (newIcon) {
            case 1: 
                FlxPoint.get(
                    (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconoffsetx")) ? Std.parseFloat(boyfriend.xml.get("iconoffsetx")) : 0,
                    (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconoffsety")) ? Std.parseFloat(boyfriend.xml.get("iconoffsety")) : 0
                );
            case 0:
                FlxPoint.get(
                    (dad != null && dad.xml != null && dad.xml.exists("iconoffsetx")) ? Std.parseFloat(dad.xml.get("iconoffsetx")) : 0,
                    (dad != null && dad.xml != null && dad.xml.exists("iconoffsety")) ? Std.parseFloat(dad.xml.get("iconoffsety")) : 0
                );
        });

        if (camHUD.downscroll) iconOffset.y *= -1;
    }
    updateIcons();
}

function update(elapsed:Float)
    updateIcons();

function updateIcons() {
    // Positions 
    gorefieldiconP1.x = gorefieldhealthBar.x + (gorefieldhealthBar.width * (FlxMath.remapToRange(gorefieldhealthBar.percent, 0, 100, 1, 0)) - 20);
    gorefieldiconP2.x = gorefieldhealthBar.x + (gorefieldhealthBar.width * (FlxMath.remapToRange(gorefieldhealthBar.percent, 0, 100, 1, 0))) - (gorefieldiconP2.width - 20);

    // Offsets
    for (icon in [gorefieldiconP1, gorefieldiconP2]) {
        icon.x += iconOffsets[icon == gorefieldiconP1 ? 1 : 0].x; 
        icon.y = gorefieldhealthBar.y - (icon.height / 2) + iconOffsets[icon == gorefieldiconP1 ? 1 : 0].y;

        // Animations
        var losing:Bool = switch (icon) {
            case gorefieldiconP1: (gorefieldhealthBar.percent < 20);
            case gorefieldiconP2: (gorefieldhealthBar.percent > 80);
        };

        if (icon.animation.name == "non-animated") icon.animation.curAnim.curFrame = losing ? 1 : 0;
        else icon.animation.play(losing ? "losing" : "idle");
    }   
}

function destroy() {
    for (point in iconOffsets) point.put();
}