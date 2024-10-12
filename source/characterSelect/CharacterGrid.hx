package characterSelect;

import shaders.HueShader;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import characterSelect.CharacterSelectState.CharacterSelectGroup;
import flixel.group.FlxSpriteGroup;

class CharacterGrid extends FlxSpriteGroup
{

    var grid:Array<Array<FlxSprite>> = [[]];
    var gridArea:Int;

    var cursor:FlxSprite;
    var cursorMoveTween:FlxTween;
    var cursorBack:FlxSprite;
    var cursorBackMoveTween:FlxTween;
    var cursorFarBack:FlxSprite;
    var cursorFarBackMoveTween:FlxTween;

    var cursorConfrim:FlxSprite;
    var cursorDeny:FlxSprite;

    public var forceTrackPosition:Array<Int> = null;

    public function new(_x:Float = 0, _y:Float = 0, _size:Int, _characterMap:Map<String, CharacterSelectGroup>){
        super(_x,_y);

        gridArea = _size * _size;

        var iconGrid = [];
        for(i in 0..._size){
            var column = [];
            for(j in 0..._size){
                var found:Bool = false;
                for(key => val in _characterMap){
                    if(val.position[0] == i && val.position[1] == j){
                        column.push(key);
                        found = true;
                        break;
                    }
                }
                if(!found){
                    column.push("");
                }
            }
            iconGrid.push(column);
        }

        cursorFarBack = new FlxSprite().loadGraphic(Paths.image("menu/characterSelect/charSelector"));
        cursorFarBack.antialiasing = true;
        cursorFarBack.color = 0xFF3C74F7;
        cursorFarBack.blend = ADD;
        add(cursorFarBack);
        cursorFarBackMoveTween = FlxTween.tween(this, {}, 0);

        cursorBack = new FlxSprite().loadGraphic(Paths.image("menu/characterSelect/charSelector"));
        cursorBack.antialiasing = true;
        cursorBack.color = 0xFF3EBBFF;
        cursorBack.blend = ADD;
        add(cursorBack);
        cursorBackMoveTween = FlxTween.tween(this, {}, 0);

        cursor = new FlxSprite().loadGraphic(Paths.image("menu/characterSelect/charSelector"));
        cursor.antialiasing = true;
        add(cursor);
        FlxTween.color(cursor, 0.2, 0xFFFFFF00, 0xFFFFCF00, {type: PINGPONG});
        cursorMoveTween = FlxTween.tween(this, {}, 0);

        cursorConfrim = new FlxSprite();
        cursorConfrim.frames = Paths.getSparrowAtlas("menu/characterSelect/charSelectorConfirm");
        cursorConfrim.animation.addByPrefix("shake", "", 24, false);
        cursorConfrim.antialiasing = true;
        cursorConfrim.visible = false;
        add(cursorConfrim);

        cursorDeny = new FlxSprite();
        cursorDeny.frames = Paths.getSparrowAtlas("menu/characterSelect/charSelectorDenied");
        cursorDeny.animation.addByPrefix("shake", "", 24, false);
        cursorDeny.antialiasing = true;
        cursorDeny.visible = false;
        add(cursorDeny);

        var idCount = 0;

        for(gx in 0...iconGrid.length){
            for(gy in 0...iconGrid[gx].length){
                var testGraphic:FlxSprite;
                if(iconGrid[gx][gy] != ""){
                    testGraphic = new FlxSprite(40, 40);
                    testGraphic.frames = Paths.getSparrowAtlas("menu/characterSelect/characters/" + iconGrid[gx][gy] + "/icon");
                    testGraphic.antialiasing = true;
                    testGraphic.animation.addByPrefix("hold", "", 0, false);
                    testGraphic.animation.addByPrefix("play", "", 24, false);
                    testGraphic.animation.play("hold");
                    testGraphic.x -= testGraphic.width/2;
                    testGraphic.y -= testGraphic.height/2;
                    testGraphic.ID = idCount;
                }
                else{
                    testGraphic = new FlxSprite(40, 40).loadGraphic(Paths.image("menu/characterSelect/lock"));
                    testGraphic.antialiasing = true;
                    testGraphic.x -= testGraphic.width/2;
                    testGraphic.y -= testGraphic.height/2;
                    var lockShader = new HueShader((15 * gx) + (30 * gy));
                    testGraphic.shader = lockShader.shader;
                    testGraphic.ID = idCount + gridArea;
                }
                testGraphic.x += 100 * gx;
                testGraphic.y += 100 * gy;

                grid[gx].push(testGraphic);
                add(testGraphic);
                idCount++;
            }
            grid.push([]);
        }
        
    }

    override function update(elapsed:Float):Void{

        if(forceTrackPosition != null){
            select(forceTrackPosition, true);
        }

        super.update(elapsed);
    }

    public function select(pos:Array<Int>, ?instant:Bool = false):Void{
        for(gx in 0...grid.length){
            for(gy in 0...grid[gx].length){
                if(gx == pos[0] && gy == pos[1]){
                    FlxTween.cancelTweensOf(grid[gx][gy].scale);
                    FlxTween.tween(grid[gx][gy].scale, {x: 1, y: 1}, 0.4, {ease: FlxEase.expoOut});

                    cursorMoveTween.cancel();
                    cursorBackMoveTween.cancel();
                    cursorFarBackMoveTween.cancel();
                    
                    if(!instant){
                        cursorMoveTween = FlxTween.tween(cursor, {x: grid[gx][gy].getMidpoint().x - cursor.width/2, y: grid[gx][gy].getMidpoint().y - cursor.height/2}, 0.25, {ease: FlxEase.expoOut});
                        cursorBackMoveTween = FlxTween.tween(cursorBack, {x: grid[gx][gy].getMidpoint().x - cursorBack.width/2, y: grid[gx][gy].getMidpoint().y - cursorBack.height/2}, 0.5, {ease: FlxEase.expoOut});
                        cursorFarBackMoveTween = FlxTween.tween(cursorFarBack, {x: grid[gx][gy].getMidpoint().x - cursor.width/2, y: grid[gx][gy].getMidpoint().y - cursor.height/2}, 0.75, {ease: FlxEase.expoOut});
                    }
                    else{
                        cursor.setPosition(grid[gx][gy].getMidpoint().x - cursor.width/2, grid[gx][gy].getMidpoint().y - cursor.height/2);
                        cursorBack.setPosition(grid[gx][gy].getMidpoint().x - cursorBack.width/2, grid[gx][gy].getMidpoint().y - cursorBack.height/2);
                        cursorFarBack.setPosition(grid[gx][gy].getMidpoint().x - cursorFarBack.width/2, grid[gx][gy].getMidpoint().y - cursorFarBack.height/2);
                    }
                }
                else{
                    FlxTween.cancelTweensOf(grid[gx][gy].scale);
                    FlxTween.tween(grid[gx][gy].scale, {x: 0.83, y: 0.83}, 0.4, {ease: FlxEase.expoOut});
                }
            }
        }
    }

    public function confirm(pos:Array<Int>){
        cursorConfrim.animation.play("shake", true);
        cursorConfrim.visible = true;
        cursorConfrim.setPosition(grid[pos[0]][pos[1]].getMidpoint().x - cursorConfrim.width/2, grid[pos[0]][pos[1]].getMidpoint().y - cursorConfrim.height/2);
        cursor.visible = false;
        cursorBack.visible = false;
        cursorFarBack.visible = false;
        select(pos, true);
        if(grid[pos[0]][pos[1]].ID < gridArea){
            grid[pos[0]][pos[1]].animation.play("play", true);
        }
    }

    public function deny(pos:Array<Int>){
        cursorDeny.animation.play("shake", true);
        cursorDeny.visible = true;
        cursorDeny.setPosition(grid[pos[0]][pos[1]].getMidpoint().x - cursorDeny.width/2, grid[pos[0]][pos[1]].getMidpoint().y - cursorDeny.height/2);
        cursor.visible = false;
        cursorBack.visible = false;
        cursorFarBack.visible = false;
        select(pos, true);
    }

    public function showNormalCursor(){
        cursorConfrim.visible = false;
        cursorDeny.visible = false;
        cursor.visible = true;
        cursorBack.visible = true;
        cursorFarBack.visible = true;
    }

}