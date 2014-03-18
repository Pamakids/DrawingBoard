package components
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;

	import spark.components.Image;

	public class ElasticButton extends Image
	{
		private var downPoint:Point;
		private var playingEffect:Boolean;
		private var downCompleted:Boolean;
		private var upCompleted:Boolean;
		private var downAndMoved:Boolean;
		private var stopClickEvent:Boolean;

		public function ElasticButton()
		{
			super();
		}

		override protected function initializationComplete():void
		{
			super.initializationComplete();
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		protected function onMouseDown(event:MouseEvent):void
		{
			if (enabled)
			{
				downPoint=new Point(event.stageX, event.stageY);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

				playingEffect=true;
				var vars:Object={transformAroundCenter: {scaleX: 0.6, scaleY: 0.6}, onComplete: downComplete, ease: Cubic.easeIn}
				TweenMax.to(this, 0.3, vars);
			}
			event.stopImmediatePropagation();
		}

		protected function onMouseUp(event:MouseEvent):void
		{
			var p:Point=new Point(event.stageX, event.stageY);
			var distance:Number=Point.distance(downPoint, p);
			if (distance > 38)
				downAndMoved=true;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			upCompleted=true;
			if (downCompleted)
				doUp();
		}

		private function downComplete():void
		{
			downCompleted=true;
			if (upCompleted)
				doUp();
		}

		private function doUp():void
		{
			var vars:Object={transformAroundCenter: {scaleX: 1, scaleY: 1}, onComplete: upComplete, ease: Elastic.easeOut}
			TweenMax.to(this, 0.5, vars);
		}

		private function upComplete():void
		{
			setTimeout(function():void
			{
				playingEffect=false;
				upCompleted=false;
				downCompleted=false;
			}, 500);

			if (!downAndMoved)
			{
				stopClickEvent=false;
			}
			else
			{
				stopClickEvent=true;
				downAndMoved=false;
			}
		}

	}
}
