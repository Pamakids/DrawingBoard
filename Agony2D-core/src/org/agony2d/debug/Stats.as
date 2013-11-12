package org.agony2d.debug {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
public class Stats extends Sprite {	
	
	public function Stats( x:Number = 0, y:Number = 0 ) : void {
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
		this.x = x
		this.y = y
	}
	
	private function onAddedToStage( e : Event ) : void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		graphics.beginFill(0x33 );
		graphics.drawRect( 0, 0, 65, 40 );
		graphics.endFill();
	
		ver = new Sprite();
		ver.graphics.beginFill( 0x33 );
		ver.graphics.drawRect( 0, 0, 65, 30 );
		ver.graphics.endFill();
		ver.y = 90;
		ver.visible = false;
		addChild(ver);
		
		verText = new TextField();
		fpsText = new TextField();
		msText = new TextField();
		memText = new TextField();
		
		format = new TextFormat( "_sans", 9 );
		
		verText.defaultTextFormat = fpsText.defaultTextFormat = msText.defaultTextFormat = memText.defaultTextFormat = format;
		verText.width = fpsText.width = msText.width = memText.width = 65;
		verText.selectable = fpsText.selectable = msText.selectable = memText.selectable = false;
		
		verText.textColor = 0xFFFFFF;
		verText.text = Capabilities.version.split(" ")[0] + "\n" + Capabilities.version.split(" ")[1];
		ver.addChild(verText);
		
		fpsText.textColor = 0xFFFF00;
		fpsText.text = "FPS: ";
		addChild(fpsText);
		
		msText.y = 10;
		msText.textColor = 0x00FF00;
		msText.text = "MS: ";
		addChild(msText);
		
		memText.y = 20;
		memText.textColor = 0x00FFFF;
		memText.text = "MEM: ";
		addChild(memText);
		
		graph = new BitmapData( 65, 50, false, 0x33 );
		var gBitmap:Bitmap = new Bitmap( graph);
		gBitmap.y = 40;
		addChild(gBitmap);
		
		rectangle = new Rectangle( 0, 0, 1, graph.height );
		
		stage.addEventListener(Event.ENTER_FRAME, update)
	}
	
	private function update( e : Event ) : void {
		timer = getTimer();
		fps++;
		
		if( timer - 1000 > msPrev ) {
			msPrev = timer;
			mem = Number( ( System.totalMemory * 0.000000954 ).toFixed(3) );
			
			var fpsGraph : int = Math.min( 50, 50 / stage.frameRate * fps );
			var memGraph:Number =  Math.min( 50, Math.sqrt( Math.sqrt( mem * 5000 ) ) ) - 2;
			
			graph.scroll( 1, 0 );
			
			graph.fillRect( rectangle , 0x33 );
			graph.setPixel32( 0, graph.height - fpsGraph, 0xFFFF00);
			graph.setPixel32( 0, graph.height - ( ( timer - ms ) >> 1 ), 0x00FF00 );
			graph.setPixel32( 0, graph.height - memGraph, 0x00FFFF);
			
			fpsText.text = "FPS: " + fps + " / " + stage.frameRate;
			memText.text = "MEM: " + mem;
			
			fps = 0;
		}
		
		msText.text = "MS: " + (timer - ms);
		ms = timer;
	}
	
	private var graph : BitmapData;
	private var ver : Sprite;
	
	private var fpsText : TextField, msText : TextField, memText : TextField, verText : TextField, format : TextFormat;
	
	private var fps :int, timer : int, ms : int, msPrev	: int
	private var mem : Number = 0;
	
	private var rectangle : Rectangle;
}
}