package note.types;

import flixel.tweens.FlxEase;
import flixel.FlxG;

class AnimSetNotes extends NoteType
{

    override function defineTypes():Void{
        addNoteType("alt", altHit, null);
        addNoteType("censor", censorHit, null);

        addSustainType("alt", altHit, null);
        addSustainType("censor", censorHit, null);
    }

    function altHit(note:Note, character:Character){
        var prevAnimSet = character.animSet;
        character.animSet = "alt";
        playstate.defaultNoteHit(note, character);
        character.animSet = prevAnimSet;
    }

    function censorHit(note:Note, character:Character){
        var prevAnimSet = character.animSet;
        character.animSet = "censor";
        playstate.defaultNoteHit(note, character);
        character.animSet = prevAnimSet;
    }

}