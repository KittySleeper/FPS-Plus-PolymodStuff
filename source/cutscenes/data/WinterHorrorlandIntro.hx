package cutscenes.data;

import transition.data.InstantTransition;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;

class WinterHorrorlandIntro extends ScriptedCutscene
{

    var blackScreen:FlxSprite;
    var originalZoom:Float;

    override function init():Void{
        originalZoom = playstate.defaultCamZoom;
        playstate.customTransIn = new InstantTransition();

        addEvent(0,   horrorland0);
        addEvent(0.1, horrorland1);
        addEvent(0.9, horrorland2);
        addEvent(3.4, startSong);
    }

    function horrorland0() {
        blackScreen = new FlxSprite(0, 0).makeGraphic(1, 1, 0xFF000000);
        blackScreen.scale.set(FlxG.width * 2, FlxG.height * 2);
        blackScreen.updateHitbox();
		addToForegroundLayer(blackScreen);
		blackScreen.scrollFactor.set();
		playstate.camHUD.visible = false;
    }

    function horrorland1() {
        removeFromForegroundLayer(blackScreen);
		FlxG.sound.play(Paths.sound('week5/Lights_Turn_On'));
		playstate.camFollow.y = -2050;
		playstate.camFollow.x -= 200;
		playstate.camChangeZoom(1.5, 0, null);
    }

    function horrorland2() {
        playstate.camChangeZoom(originalZoom, 2.5, FlxEase.quadInOut);
    }

    function startSong() {
		playstate.startCountdown();
        playstate.camHUD.visible = true;
    }

}