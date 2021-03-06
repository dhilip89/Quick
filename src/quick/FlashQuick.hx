// OpenFL / NME version scales seem different in OpenFL and nme Jsprime but probably down to setup
package quick;
import flash.Lib;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.display.Graphics;
import flash.Vector;
import quick.QuickTriangle;
typedef Triangle = QuickTriangle;
@:enum
abstract GameColors( Int ) to Int from Int {
    var Violet      = 0xFF9400D3;
    var Indigo      = 0xFF4b0082;
    var Blue        = 0xFF0000FF;
    var Green       = 0xFF00ff00;
    var Yellow      = 0xFFFFFF00;
    var Orange      = 0xFFFF7F00;
    var Red         = 0xFFFF0000;
    var Black       = 0xFF000000;
    var LightGrey   = 0xFF444444;
    var MidGrey     = 0xFF333333;
    var DarkGrey    = 0xFF0c0c0c;
    var NearlyBlack = 0xFF111111;
    var White       = 0xFFFFFFFF;
    var BlueAlpha   = 0x660000FF;
    var GreenAlpha  = 0x3300FF00;
    var RedAlpha    = 0x66FF0000;
}
  
class FlashQuick extends Sprite{ 
    var gameColors:         Array<GameColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                                , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                                , BlueAlpha, GreenAlpha, RedAlpha ]; 
    var g:                  Graphics;
    var triangles:          Array<Triangle>;
    var viewSprite:         Sprite;
    var scale:              Float;
    var leftDown:           Bool = false;
    var rightDown:          Bool = false;
    var downDown:           Bool = false;
    var upDown:             Bool = false;
    public static function main(): Void { Lib.current.addChild( new FlashQuick() ); }
    public function new(){
        super();
        var current = Lib.current;
        var stage = current.stage;
        viewSprite = new Sprite();
        g = viewSprite.graphics;
        addChild( viewSprite );
        scale = 1.;
        triangles = [ { ax: -.5, ay: .5, bx: .5, by: .5, cx: -.0, cy: -0.36602540378443864676372317075294, colorID: 1, depth: 0. } ];
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
        stage.addEventListener( KeyboardEvent.KEY_DOWN, keyUp );
        stage.addEventListener( Event.ENTER_FRAME, enterFrame );
        #if nme 
            stage.addEventListener( Event.RESIZE, resize );
            current.graphics.beginFill(0xFFFFFF, 1. );
            current.graphics.drawRect( 0., 0., 70., 40. );
            current.graphics.endFill();
            current.addChild( new nme.display.FPS() );
            resize( null );
            enterFrame( null );
            resize( null );
        #end
        
    }
    inline
    function enterFrame( evt: Event ) {
        renderTriangles();
    }
    inline
    function keyDown( event: KeyboardEvent ): Void {
        var keyCode = event.keyCode;
        if (keyCode == 27) { // ESC
            #if flash
                flash.system.System.exit(1);
            #elseif sys
                Sys.exit(1);
            #end
        }
        switch( keyCode ){
            case Keyboard.LEFT:
                leftDown    = true;
            case Keyboard.RIGHT:
                rightDown   = true;
            case Keyboard.UP:
                upDown      = true;
            case Keyboard.DOWN:
                downDown    = true;
            default: 
        }
        update(); // not sure if this ideal?
    }
    inline
    function keyUp( event: KeyboardEvent ): Void {
        var keyCode = event.keyCode;
        switch(keyCode){
            case Keyboard.LEFT:
                leftDown    = false;
            case Keyboard.RIGHT:
                rightDown   = false;
            case Keyboard.UP:
                upDown      = false;
            case Keyboard.DOWN:
                downDown    = false;
            default: 
        }
    }
    inline
    function update(): Void {
        if( upDown ){
            // rotate( 1 );
        } else if( downDown ){
            // move(  0, 1 );
        }
        if( leftDown ) {
            // move( -1, 0 );
        } else if( rightDown ) {
            // move(  1, 0 );
        }
        leftDown    = false;
        rightDown   = false;
        downDown    = false;
        upDown      = false;
    }
    #if nme
    // requires build from http://nmehost.com/nme/
    inline 
    function renderTriangles() { // switch to drawTriangles as per Hugh suggestion and to use resize funcion
        var n         = triangles.length;
        g.clear();
        if( n == 0 ) return;
        var verts = new Array<Float>();
        var cols = new Array<Int>();
        verts[ 6 * n - 1 ] = 0.0;
        cols[ n * 3 - 1 ]  = 0;
        var i = 0;
        var c = 0;
        var col: Int;
        for( tri in triangles ){ 
           verts[ i++ ] = tri.ax;
           verts[ i++ ] = tri.ay;
           verts[ i++ ] = tri.bx;
           verts[ i++ ] = tri.by;
           verts[ i++ ] = tri.cx;
           verts[ i++ ] = tri.cy;
           col = gameColors[ tri.colorID ];
           cols[ c++ ] = col;
           cols[ c++ ] = col;
           cols[ c++ ] = col;
        } 
        g.drawTriangles( verts, null, null, null, cols );  // <- don't think you can use this like this in openfl ?
    }
    #else
    inline 
    function renderTriangles(){
        var tri: Triangle;
        var s = 500;
        var ox = 500;
        var oy = 250;
        g.clear();
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            #if openfl 
            g.lineStyle( 0, 0xFF0000, 0 );
            #end
            g.moveTo( ox + tri.ax * s, oy + tri.ay * s );
            g.beginFill( gameColors[ tri.colorID ] );
            g.lineTo( ox + tri.ax * s, oy + tri.ay * s );
            g.lineTo( ox + tri.bx * s, oy + tri.by * s );
            g.lineTo( ox + tri.cx * s, oy + tri.cy * s );
            g.endFill();
        }
    }
    #end
    inline
    function resize( e: Event ){
        var s = Lib.current.stage;
        var scale =  Math.min( s.stageWidth, s.stageHeight )/1.5;
        var view = viewSprite;
        view.scaleX = view.scaleY = scale;
        view.x = s.stageWidth/2 - view.width/2;
        view.y = s.stageHeight/2;
    }
}