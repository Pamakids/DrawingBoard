package com.pamakids.layout
{
	import flash.events.TimerEvent;
	import flash.geom.Matrix3D;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;

	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;

	import spark.layouts.supportClasses.LayoutBase;

	public class CoverFlowLayoutBest extends LayoutBase
	{
		private var finalMatrixs:Vector.<Matrix3D>;
		private var centerPoint:Point;
		private var transitionTimer:Timer;

		private var _depthDistance:Number=0;
		private var _elementRotation:Number=0;
		private var _focalLength:Number=300;
		private var _horizontalDistance:Number=100;
		private var _perspectiveProjectionX:Number;
		private var _perspectiveProjectionY:Number;
		private var _selectedIndex:int=0;
		private var _selectedItemProximity:Number=0;

		private var _verticalOffset:Number=0;

		public function get verticalOffset():Number
		{
			return _verticalOffset;
		}

		public function set verticalOffset(value:Number):void
		{
			_verticalOffset=value;
			invalidateTarget();
		}

		public function get depthDistance():Number
		{
			return _depthDistance;
		}

		public function set depthDistance(value:Number):void
		{
			_depthDistance=value;
			invalidateTarget();
		}

		public function get elementRotation():Number
		{
			return _elementRotation;
		}

		public function set elementRotation(value:Number):void
		{
			_elementRotation=value;
			invalidateTarget();
		}

		public function get focalLength():Number
		{
			return _focalLength;
		}

		public function set focalLength(value:Number):void
		{
			_focalLength=value;
			invalidateTarget();
		}

		public function get horizontalDistance():Number
		{
			return _horizontalDistance;
		}

		public function set horizontalDistance(value:Number):void
		{
			_horizontalDistance=value;
			invalidateTarget();
		}

		public function get perspectiveProjectionX():Number
		{
			return _perspectiveProjectionX;
		}

		public function set perspectiveProjectionX(value:Number):void
		{
			_perspectiveProjectionX=value;
			invalidateTarget();
		}

		public function get perspectiveProjectionY():Number
		{
			return _perspectiveProjectionY;
		}

		public function set perspectiveProjectionY(value:Number):void
		{
			_perspectiveProjectionY=value;
			invalidateTarget();
		}

		public function get selectedItemProximity():Number
		{
			return _selectedItemProximity;
		}

		public function set selectedItemProximity(value:Number):void
		{
			_selectedItemProximity=value;
			invalidateTarget();
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			_selectedIndex=value;
			invalidateTarget();
		}

		private static const ANIMATION_DURATION:int=700;
		private static const ANIMATION_STEPS:int=24;
		private static const RIGHT_SIDE:int=-1;
		private static const LEFT_SIDE:int=1;

		private function invalidateTarget():void
		{
			if (target)
			{
				target.invalidateDisplayList();
				target.invalidateSize();
			}
		}

		override public function updateDisplayList(width:Number, height:Number):void
		{
			var matrix3D:Matrix3D;
			var index:int;
			var left:int;
			var right:int;
			var elements:int=target.numElements;
			if (!elements)
				return;
			centerPerspectiveProjection(width, height);
			finalMatrixs=new Vector.<Matrix3D>(elements);
			index=_selectedIndex == -1 ? 0 : _selectedIndex;
			var element:IVisualElement;
			element=target.getVirtualElementAt(index);
			element.alpha=1;
			matrix3D=positionCentralElement(element, width, height);
			finalMatrixs[index]=matrix3D;
			left=index - 1;
			var alpha:int=1;
			var interval:int;
			while (left >= 0)
			{
				element=target.getVirtualElementAt(left);
				interval=index - left;
				if (interval > 3)
					element.alpha=alpha - interval / 10;
				else
					element.alpha=1;
				matrix3D=positionLateralElement(element, interval, LEFT_SIDE);
				finalMatrixs[left]=matrix3D;
				left--;
			}
			right=index + 1;
			while (right < elements)
			{
				element=target.getVirtualElementAt(right);
				interval=right - index;
				if (interval > 3)
					element.alpha=alpha - interval / 10;
				else
					element.alpha=1;
				matrix3D=positionLateralElement(element, interval, RIGHT_SIDE);
				finalMatrixs[right]=matrix3D;
				right++;
			}

			playTransition();
		}

		private function playTransition():void
		{
			if (transitionTimer)
			{
				transitionTimer.stop();
				transitionTimer.reset();
			}
			else
			{
				transitionTimer=new Timer(ANIMATION_DURATION / ANIMATION_STEPS, ANIMATION_STEPS);
				transitionTimer.addEventListener(TimerEvent.TIMER, transitionTimer_timerHandler);
				transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animationTimerCompleteHandler);
			}
			transitionTimer.start();
		}

		protected function animationTimerCompleteHandler(event:TimerEvent):void
		{
			transitionTimer_timerHandler(event);
			finalMatrixs=null;
		}

		protected function transitionTimer_timerHandler(event:TimerEvent):void
		{
			var index:int=0;
			var elements:int=target.numElements;
			var element:ILayoutElement;
			var m1:Matrix3D;
			var m2:Matrix3D;
			while (index < elements)
			{
				m1=finalMatrixs[index];
				var e1:Object=target.getElementAt(index);
				var e2:Object=target.getVirtualElementAt(index);
				element=target.getVirtualElementAt(index);
				m2=UIComponent(element).transform.matrix3D;
				if (event.type != TimerEvent.TIMER_COMPLETE)
				{
					if (transitionTimer.currentCount < ANIMATION_STEPS - 4)
						m2.interpolateTo(m1, 0.2);
					else
						m2.interpolateTo(m1, 0.5);
				}
				else
				{
					m2.interpolateTo(m1, 0.8);
				}
				element.setLayoutMatrix3D(m2, false);
				index++;
			}
		}

		private function centerPerspectiveProjection(width:Number, height:Number):void
		{
			_perspectiveProjectionX=width / 2;
			_perspectiveProjectionY=height / 2;
			var pp:PerspectiveProjection=new PerspectiveProjection();
			pp.projectionCenter=new Point(_perspectiveProjectionX, _perspectiveProjectionY);
			pp.focalLength=_focalLength;
			target.transform.perspectiveProjection=pp;
		}

		private function positionLateralElement(element:ILayoutElement, interval:int, direction:int):Matrix3D
		{
			var m:Matrix3D=new Matrix3D();
			var w:Number=element.getLayoutBoundsWidth(false);
			var h:Number=element.getLayoutBoundsHeight(false);
			var zdistance:Number=interval * _depthDistance;
			var tox:Number=centerPoint.x - direction * interval * _horizontalDistance;
			m.appendTranslation(tox, centerPoint.y + _verticalOffset, zdistance);
			var ive:IVisualElement=IVisualElement(element);
			m.appendRotation(direction * _elementRotation, Vector3D.Y_AXIS, new Vector3D(tox + ive.width / 2, ive.height / 2));
			ive.depth=-interval;
			return m;
		}

		private function positionCentralElement(element:ILayoutElement, width:Number, height:Number):Matrix3D
		{
			var m:Matrix3D=new Matrix3D();
			var w:Number=element.getLayoutBoundsWidth(false);
			var h:Number=element.getLayoutBoundsHeight(false);
			centerPoint=new Point((width - w) / 2, (height - h) / 2);
			m.appendTranslation(centerPoint.x, centerPoint.y + _verticalOffset, -_selectedItemProximity);
			IVisualElement(element).depth=10;
			return m;
		}

		public function CoverFlowLayoutBest()
		{
		}
	}
}
