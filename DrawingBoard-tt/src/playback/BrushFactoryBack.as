package playback
{
	import playback.brushs.*;

	/*
		笔刷工厂，用来设置笔刷的样式
	*/

	public class BrushFactoryBack
	{

		public var brush:BrushBase;

		private static var brushFactory:BrushFactoryBack=null;

		public function BrushFactoryBack()
		{
			if (brushFactory)
			{
				throw new Error("this is a singelton class,it can have only one instance");
			}
		}

		public static function getBrushFactory():BrushFactoryBack
		{
			if (brushFactory == null)
			{
				brushFactory=new BrushFactoryBack;
			}
			return brushFactory;
		}

		//生成笔刷
		public function createBrush(_str:String):void
		{
			switch (_str)
			{
				case "pencil":
					brush=new NormalBrush("pencil");
					break;
				case "pink":
					brush=new NormalBrush("pink");
					break;
				case "crayon":
					brush=new NormalBrush("crayon");
					break;
				case "maker":
					brush=new NormalBrush("maker");
					break;
				case "waterColor":
					brush=new NormalBrush("waterColor");
					break;
				case "eraser":
					brush=new EraserBrush;
					break;
				default:
					break;
			}
		}
	}
}
