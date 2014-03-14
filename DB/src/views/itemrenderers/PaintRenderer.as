package views.itemrenderers
{
	import com.pamakids.components.controls.Image;
	
	import spark.components.LabelItemRenderer;
	
	
	/**
	 * 
	 * ASDoc comments for this item renderer class
	 * 
	 */
	public class PaintRenderer extends LabelItemRenderer
	{
		public function PaintRenderer()
		{
			width = 473;
			height = 358;
		}
		
		/**
		 * @private
		 *
		 * Override this setter to respond to data changes
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			// the data has changed.  push these changes down in to the 
			// subcomponents here    		
			trace('data');
			if(data.big){
				big.source = data.url;
				big.visible = true;
				if(smalls[0].visible)
				{
					for each(var si:Image in smalls){
						si.visible = false;
					}
				}
			}else{
				for(var i:int; i<4; i++)
				{
					smalls[i].source = data.urls[i];
					smalls[i].visible = true;
				}
				big.visible = false;
			}
		} 
		
		private var big:Image;
		private var smalls:Vector.<Image>;
		
		/**
		 * @private
		 * 
		 * Override this method to create children for your item renderer 
		 */	
		override protected function createChildren():void
		{
//			super.createChildren();
			// create any additional children for your item renderer here
			trace('cc');
			big = new Image();
			big.x = 16;
			big.y = 16;
			addChild(big);
			big.visible = false;
			smalls = new Vector.<Image>();
			for(var j:int; j<4; j++)
			{
				var i:Image = new Image();
				var row:int = j < 2 ? 0 : 1;
				var column:int = j%2;
				i.x = 9+column*(213+11);
				i.y = 9+row*(160+6);
				smalls.push(i);
				i.visible = false;
				addChild(i);
			}
		}
		
		/**
		 * @private
		 * 
		 * Override this method to change how the item renderer 
		 * sizes itself. For performance reasons, do not call 
		 * super.measure() unless you need to.
		 */ 
		override protected function measure():void
		{
//			super.measure();
			// measure all the subcomponents here and set measuredWidth, measuredHeight, 
			// measuredMinWidth, and measuredMinHeight      		
		}
		
		/**
		 * @private
		 * 
		 * Override this method to change how the background is drawn for 
		 * item renderer.  For performance reasons, do not call 
		 * super.drawBackground() if you do not need to.
		 */
		override protected function drawBackground(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
			trace('db');
			graphics.beginFill(0xffffff);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
//			super.drawBackground(unscaledWidth, unscaledHeight);
			// do any drawing for the background of the item renderer here      		
		}
		
		/**
		 * @private
		 *  
		 * Override this method to change how the background is drawn for this 
		 * item renderer. For performance reasons, do not call 
		 * super.layoutContents() if you do not need to.
		 */
		override protected function layoutContents(unscaledWidth:Number, 
												   unscaledHeight:Number):void
		{
//			super.layoutContents(unscaledWidth, unscaledHeight);
			// layout all the subcomponents here      		
		}
		
	}
}