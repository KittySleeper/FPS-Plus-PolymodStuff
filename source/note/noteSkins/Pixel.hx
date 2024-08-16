package note.noteSkins;

class Pixel extends NoteSkinBase
{

    public function new(){
        super();

        info.path = "week6/weeb/pixelUI/arrows-pixels";
        info.frameLoadType = load(19, 19);

        setScrollAnimFrames(left, [4]);
        setGlowAnimFrames(left, [20]);

        sustainInfo(left).pathOverride = "week6/weeb/pixelUI/arrowEnds";
        sustainInfo(left).frameLoadTypeOverride = load(7, 6);
        setHoldAnimFrames(left, [0]);
        setEndAnimFrames(left, [4]);

        setScrollAnimFrames(down, [5]);
        setGlowAnimFrames(down, [21]);
        
        sustainInfo(down).pathOverride = "week6/weeb/pixelUI/arrowEnds";
        sustainInfo(down).frameLoadTypeOverride = load(7, 6);
        setHoldAnimFrames(down, [1]);
        setEndAnimFrames(down, [5]);

        setScrollAnimFrames(up, [6]);
        setGlowAnimFrames(up, [22]);
        
        sustainInfo(up).pathOverride = "week6/weeb/pixelUI/arrowEnds";
        sustainInfo(up).frameLoadTypeOverride = load(7, 6);
        setHoldAnimFrames(up, [2]);
        setEndAnimFrames(up, [6]);

        setScrollAnimFrames(right, [7]);
        setGlowAnimFrames(right, [23]);
        
        sustainInfo(right).pathOverride = "week6/weeb/pixelUI/arrowEnds";
        sustainInfo(right).frameLoadTypeOverride = load(7, 6);
        setHoldAnimFrames(right, [3]);
        setEndAnimFrames(right, [7]);

        info.scale = 6;
        info.holdScaleAdjust = 0.833 * (1.5 / 1.485);
        info.antialiasing = false;
        info.offset.x = 36;
    }

}