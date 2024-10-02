package characters.data;

import shaders.TextureMixShader;
import shaders.TheShaderThatTurnsEverythingOrange;
import stages.elements.ABot;
import flixel.FlxG;
import flixel.math.FlxPoint;

@charList(false)
@gfList(true)
class NeneDark extends CharacterInfoBase
{

    override public function new(){

        super();

        info.name = "nene";
        info.spritePath = "week2/nene_dark";
        info.frameLoadType = sparrow;
        
        info.iconName = "face";
        info.focusOffset = new FlxPoint();

		addByIndices("danceLeft", offset(0, 0), "Nene Idle", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], "", 24, loop(false, 0), false, false);
        addByIndices("danceRight", offset(0, 0), "Nene Idle", [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], "", 24, loop(false, 0), false, false);
        addByPrefix("idleLoop", offset(0, 0), "Nene Idle", 24, loop(true, 0), false, false);
        addByIndices("sad", offset(0, 0), "laughing nene", [0,1,2,3], "", 24, loop(false, 0), false, false);
        addByPrefix("comboCheer", offset(-120, 53), "combo celebration 1 nene", 24, loop(false, 0), false, false);
        addByIndices("comboCheerHigh", offset(-40, -20), "fawn nene", [0,1,2,3,4,5,6,4,5,6,4,5,6,4,5,6], "", 24, loop(false, 0), false, false);
        addByPrefix("raiseKnife", offset(0, 51), "knife raise", 24, loop(false, 0), false, false);
        addByPrefix("idleKnife", offset(-98, 51), "knife high held", 24, loop(false, 0), false, false);
        addByPrefix("lowerKnife", offset(-38, 51), "knife lower", 24, loop(false, 0), false, false);

        addAnimChain("raiseKnife", "idleKnife");
        addAnimChain("laughCutscene", "idleLoop");

        info.idleSequence = ["danceLeft", "danceRight"];

        info.functions.create = create;
        info.functions.songStart = songStart;
        info.functions.update = update;
        info.functions.beat = beat;
        info.functions.danceOverride = danceOverride;

        addAction("flashOn", flashOn);
        addAction("flashOff", flashOff);
        addAction("flashFade", flashFade);

        addExtraData("reposition", [0, -165]);
    }

    var knifeRaised:Bool = false;
    var blinkTime:Float = 0;

    var flash:Character;

    var abot:ABot;
    var abotLookDir:Bool = false;

    var abotShader:TextureMixShader = new TextureMixShader(Paths.image("week2/abot_dark/abotSystem/spritemap1"));

    final BLINK_MIN:Float = 1;
    final BLINK_MAX:Float = 3;

    function create(character:Character):Void{
        abot = new ABot(-134.5, 311);
		abot.lookLeft();
        abot.system.shader = abotShader.shader;
        addToCharacter(abot);

        flash = new Character(0, 0, "NeneNoSpeaker", characterReference.isPlayer, characterReference.isGirlfriend);
        flash.noLogic = true;
        character.attachCharacter(flash, [withPlayAnim]);
        addToCharacter(flash);
    }

    function update(character:Character, elapsed:Float):Void{
        
        if(character.curAnim == "idleKnife"){
            blinkTime -= elapsed;

            if(blinkTime <= 0){
                character.playAnim("idleKnife", true);
                blinkTime = FlxG.random.float(BLINK_MIN, BLINK_MAX);
            }
        }

        if(!character.debugMode){
            if(playstate.camFocus == "dad" && abotLookDir){
                abotLookDir = !abotLookDir;
                abot.lookLeft();
            }
            else if(playstate.camFocus == "bf" && !abotLookDir){
                abotLookDir = !abotLookDir;
                abot.lookRight();
            }
        }
        
    }

    function beat(character:Character, beat:Int) {
        abot.bop();

        //raise knife on low health
        if(PlayState.SONG.song.toLowerCase() != "blazin"){
            if(PlayState.instance.health < 0.4 && !knifeRaised){
                knifeRaised = true;
                blinkTime = FlxG.random.float(BLINK_MIN, BLINK_MAX);
                character.playAnim("raiseKnife", true);
            } 
            else if(PlayState.instance.health >= 0.4 && knifeRaised && character.curAnim == "idleKnife"){
                knifeRaised = false;
                character.playAnim("lowerKnife", true);
                character.idleSequenceIndex = 1;
                character.danceLockout = true;
            }
        }

    }

    function danceOverride(character:Character):Void{
        if(!knifeRaised){
            character.defaultDanceBehavior();
        }
    }

    function songStart(character:Character):Void{
        abot.setAudioSource(FlxG.sound.music);
		abot.startVisualizer();
    }

    function flashOn(character:Character):Void{
        character.getSprite().alpha = 0;
        abotShader.mix = 0;
    }

    function flashOff(character:Character):Void{
        character.getSprite().alpha = 1;
        abotShader.mix = 1;
    }

    function flashFade(character:Character):Void{
        character.getSprite().alpha = 0;
        playstate.tweenManager.tween(character.getSprite(), {alpha: 1}, 1.5);

        abotShader.mix = 0;
        playstate.tweenManager.tween(abotShader, {mix: 1}, 1.5);
    }
}