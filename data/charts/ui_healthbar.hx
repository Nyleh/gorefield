import funkin.game.HealthIcon;
import flixel.ui.FlxBarFillDirection;
import flixel.ui.FlxBar;
import funkin.game.PlayState;
import flixel.math.FlxMath;

var iconOffsets:Array<FlxPoint> = [];

var gorefieldhealthBarBG:FlxSprite;
var gorefieldhealthBar:FlxSprite;

function postCreate() {
    healthBar.visible = healthBarBG.visible = false;
    var gorefieldHealthBarColor = (stage != null && stage.stageXML != null && stage.stageXML.exists("healthBarColor")) ? stage.stageXML.get("healthBarColor") : "orange";

    gorefieldhealthBarBG = new FlxSprite().loadGraphic(Paths.image("game/healthbar/healthbar_" + gorefieldHealthBarColor));
    gorefieldhealthBarBG.cameras = [camHUD];
    add(gorefieldhealthBarBG);
    gorefieldhealthBarBG.scale.set(0.995, 1.05);

    gorefieldhealthBar = new FlxBar(0, 0, FlxBarFillDirection.RIGHT_TO_LEFT, 804, 18, PlayState.instance, "health", 0, maxHealth);
    gorefieldhealthBar.createImageBar(Paths.image("game/healthbar/filler_right"), Paths.image("game/healthbar/filler_left"));

    for (spr in [gorefieldhealthBarBG, gorefieldhealthBar]) {
        spr.scrollFactor.set(); spr.updateHitbox(); spr.cameras = [camHUD]; add(spr); spr.screenCenter(0x01);
    }

    gorefieldhealthBar.x += 1; health -= 0.02; // ZERO WHY DO YOU DO THIS TO ME >:((
    gorefieldhealthBar.y = (gorefieldhealthBarBG.y = FlxG.height * 0.83) + 34;

    //  Icon Offsets / Icon Custom Widths
    for (icon in [iconP1, iconP2]) {
        if (icon == null) continue;

        var iconOffset:FlxPoint = null;
        iconOffsets.push(iconOffset = switch (icon) {
            case iconP1: 
                FlxPoint.get(
                    (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconoffsetx")) ? Std.parseFloat(boyfriend.xml.get("iconoffsetx")) : 0,
                    (boyfriend != null && boyfriend.xml != null && boyfriend.xml.exists("iconoffsety")) ? Std.parseFloat(boyfriend.xml.get("iconoffsety")) : 0
                );
            case iconP2:
                FlxPoint.get(
                    (dad != null && dad.xml != null && dad.xml.exists("iconoffsetx")) ? Std.parseFloat(dad.xml.get("iconoffsetx")) : 0,
                    (dad != null && dad.xml != null && dad.xml.exists("iconoffsety")) ? Std.parseFloat(dad.xml.get("iconoffsety")) : 0
                );
        });

        if (camHUD.downscroll) iconOffset.y *= -1;

        icon.loadGraphic(icon.graphic, true, icon.graphic.width/2, icon.graphic.height);
        icon.flipX = icon == iconP1;

        icon.updateHitbox();
        icon.y = gorefieldhealthBar.y - (icon.height / 2);

        remove(icon); insert(members.indexOf(gorefieldhealthBar) + 1, icon);
    }
}

function postUpdate(elapsed:Float) {
    var iconOffset:Int = 20;

    iconP1.x = gorefieldhealthBar.x + (gorefieldhealthBar.width * (FlxMath.remapToRange(gorefieldhealthBar.percent, 0, 100, 1, 0)) - iconOffset);
    iconP2.x = gorefieldhealthBar.x + (gorefieldhealthBar.width * (FlxMath.remapToRange(gorefieldhealthBar.percent, 0, 100, 1, 0))) - (iconP2.width - iconOffset);

    for (icon in [iconP1, iconP2]) {
        icon.x += iconOffsets[icon == iconP1 ? 0 : 1].x; 
        icon.y = gorefieldhealthBar.y - (icon.height / 2) + iconOffsets[icon == iconP1 ? 0 : 1].y;
    }
}

function destroy() {
    for (point in iconOffsets) point.put();
}