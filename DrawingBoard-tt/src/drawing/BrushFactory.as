package drawing
{
	import drawing.brushs.BrushBase;
	import drawing.brushs.EraserBrush;
	import drawing.brushs.NormalBrush;
	
	/*
		笔刷工厂，用来设置笔刷的样式
	*/
	
	public class BrushFactory
	{
		
		public var brush:BrushBase;
		
		private static var brushFactory:BrushFactory=null;
		
		public function BrushFactory()
		{
			if(brushFactory){
				throw new Error("this is a singelton class,it can have only one instance");
			}
		}
		public static function getBrushFactory():BrushFactory{
			if(brushFactory==null){
				brushFactory=new BrushFactory;
			}
			return brushFactory;
		}
		
		//设置笔刷
		public function setBrush(_str:String):void{
			Enum.brushType=_str;
			switch(_str){
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