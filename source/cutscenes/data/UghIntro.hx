package cutscenes.data;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxEase;

class UghIntro extends ScriptedCutscene
{

    var tankman:AtlasSprite;

    var bgm:FlxSound;

    var originalZoom:Float;

    override function init():Void{
        tankman = new AtlasSprite(74, 324, Paths.getTextureAtlas("week7/cutscene/tankmanCutscene"));
        tankman.antialiasing = true;
        tankman.addAnimationByLabel("ugh1", "Ugh 1", 24, false);
        tankman.addAnimationByLabel("ugh2", "Ugh 2", 24, false);
        tankman.addAnimationByLabel("guns", "Guns", 24, false);
        tankman.addAnimationByLabel("stress1", "Stress 1", 24, false);
        tankman.addAnimationByLabel("stress2", "Stress 2", 24, false);

        originalZoom = playstate().defaultCamZoom;

        addEvent(0, ugh1);
        addEvent(3, ugh2);
        addEvent(4.5, bfBeep);
        addEvent(6, ugh3);
        addEvent(12.1, ugh4);
        addEvent(12.1 + (Conductor.crochet / 1000) * 5, swapBackToGameplayTankman);
    }

    function ugh1() {
        addToCharacterLayer(tankman);
        tankman.playAnim("ugh1", true);
        dad().visible = false;
        FlxG.sound.play(Paths.sound("week7/wellWellWell"));
        bgm = FlxG.sound.play(Paths.music("week7/distorto")).fadeIn(5, 0, 0.2);
        playstate().camFocusOpponent();
        playstate().camChangeZoom(originalZoom * 1.2, 0);
        playstate().camHUD.visible = false;
    }

    function ugh2() {
        playstate().camFocusBF();
    }

    function bfBeep() {
        boyfriend().playAnim('singUP');
        FlxG.sound.play(Paths.sound("week7/bfBeep"), function(){
            boyfriend().playAnim('idle');
        });
    }

    function ugh3() {
        tankman.playAnim("ugh2", true);
        FlxG.sound.play(Paths.sound("week7/killYou"));
        playstate().camFocusOpponent();
    }

    function ugh4() {
        bgm.fadeOut((Conductor.crochet / 1000) * 5, 0);
        playstate().camChangeZoom(originalZoom, (Conductor.crochet / 1000) * 5, FlxEase.quadInOut);
        playstate().camHUD.visible = true;
        focusCameraBasedOnFirstSection();
        next();
    }

    function swapBackToGameplayTankman() {
        dad().visible = true;
        tankman.visible = false;
        removeFromCharacterLayer(tankman);
    }

}