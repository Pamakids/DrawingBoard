package models
{
	import views.draw.TextureItem;

	public class TextureVO
	{
		public function TextureVO(t:TextureItem)
		{
			this.index=t.index;
			this.mrotaion=t.rotation;
			this.mx=t.x;
			this.my=t.y;
			this.mscale=t.scaleX;
		}

		public var index:int;
		public var mx:Number;
		public var my:Number;
		public var mrotaion:Number;
		public var mscale:Number;
	}
}
