package models
{
	import com.pamakids.utils.CloneUtil;

	public class PaintData
	{
		public function PaintData()
		{
		}

		public var theme:ThemeVo;
		public var drawData:Object;
		public var textureData:Array;

		public var path:String;

		public static function clone(obj:Object):PaintData
		{
			var pd:PaintData=new PaintData();
			pd.theme=CloneUtil.convertObject(obj.theme, ThemeVo);
			pd.drawData=obj.drawData;
			pd.textureData=obj.textureData;
			pd.path=obj.path;

			trace(pd)
			return pd;
		}
	}
}
