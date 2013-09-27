package org.agony2d.view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import org.agony2d.Agony;
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.notify.AEvent;
	//import org.agony2d.renderer.anime.Animator;
	import org.agony2d.utils.gc;
	import org.agony2d.view.puppet.SpritePuppet;
	import org.agony2d.core.agony_internal;
	
	use namespace agony_internal;
	
public class StatsMobileUI extends Fusion {
	
	public function StatsMobileUI() {
		var sprite:SpritePuppet
		
		this.stage = Agony.stage
		
		sprite = new SpritePuppet
		sprite.graphics.beginFill(0x33);
		sprite.graphics.drawRect(0, 0, 65, 75);
		this.addElement(sprite)
		
		ver = new SpritePuppet
		ver.graphics.beginFill(0x33);
		ver.graphics.drawRect(0, 0, 65, 30);
		ver.visible = false;
		this.addElement(ver, 90, 0)

		verText = new TextField();
		fpsText = new TextField();
		msText = new TextField();
		memText = new TextField();
		numAnimatorsText = new TextField();
		
		format = new TextFormat("_sans", 9);

		verText.defaultTextFormat = fpsText.defaultTextFormat = msText.defaultTextFormat = memText.defaultTextFormat = numAnimatorsText.defaultTextFormat = format;
		verText.width = fpsText.width = msText.width = memText.width = numAnimatorsText.width = 65;
		verText.selectable = fpsText.selectable = msText.selectable = memText.selectable = numAnimatorsText.selectable = false
		verText.autoSize = fpsText.autoSize = msText.autoSize = memText.autoSize = numAnimatorsText.autoSize = 'left'
		verText.textColor = 0xFFFFFF;
		verText.text = Capabilities.version.split(" ")[0] + "\n" + Capabilities.version.split(" ")[1];
		ver.addChild(verText);

		fpsText.textColor = 0xFFFF00;
		fpsText.text = "FPS: ";
		sprite.addChild(fpsText);

		msText.y = 10;
		msText.textColor = 0x00FF00;
		msText.text = "MS: ";
		sprite.addChild(msText);

		memText.y = 20;
		memText.textColor = 0x00FFFF;
		memText.text = "MEM: ";
		sprite.addChild(memText);
		
		numAnimatorsText.y = 30;
		numAnimatorsText.textColor = 0xFFFFFF;
		numAnimatorsText.text = "MR: ";
		sprite.addChild(numAnimatorsText);
		
		graph = new BitmapData(65, 50, false, 0x33);
		var gBitmap:Bitmap = new Bitmap(graph);
		gBitmap.y = 55;
		sprite.addChild(gBitmap);
		
		rectangle = new Rectangle(0, 0, 1, graph.height);
		
		this.addEventListener(AEvent.CLICK, function(e:AEvent):void {
			gc()
		})
		this.addEventListener(AEvent.KILL, function(e:AEvent):void {
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, updateAll)
		})
		Agony.process.addEventListener(AEvent.ENTER_FRAME, updateAll)
	}
	
	
	private var fps:int, timer:int, ms:int, msPrev:int = 0
	private var fpsText:TextField, msText:TextField, memText:TextField, verText:TextField, format:TextFormat, numAnimatorsText:TextField
	private var graph:BitmapData;
	private var mem:Number = 0
	private var rectangle:Rectangle;
	private var ver:SpritePuppet;
	private var stage:Stage
	
	
	public function updateAll(e:AEvent):void {
		timer = getTimer();
		fps++;

		if (timer - 250 > msPrev) {
			msPrev = timer;
			mem = Number((System.totalMemory * 0.000000954).toFixed(3));
			
			var fpsGraph:int;
			if (stage)
				fpsGraph = Math.min(50, 50 / stage.frameRate * fps);
			var memGraph:Number = Math.min(50, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
			
			graph.scroll(1, 0);
			graph.fillRect(rectangle, 0x33);

			// Do a vertical line if the time was over 100ms
			if (timer - ms > 100) {
				for (var i:int = 0; i < graph.height; i++) {
					graph.setPixel32(0, graph.height - i, 0xFF0000);
				}
			}
			graph.setPixel32(0, graph.height - fpsGraph, 0xFFFF00);
			graph.setPixel32(0, graph.height - ((timer - ms) >> 1), 0x00FF00);
			graph.setPixel32(0, graph.height - memGraph, 0x00FFFF);
			if (stage) {
				fpsText.text = "FPS: " + (fps * 4) + " / " + stage.frameRate;
			}
			memText.text = "MEM: " + mem;
			fps = 0;
		}
		msText.text = "MS: " + (timer - ms);
		//numAnimatorsText.text = "Animator: " + (Animator.m_manager ? Animator.m_manager.numAnimators : 0)
		ms = timer;
	}
}
}