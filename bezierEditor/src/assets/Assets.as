package assets
{
	public class Assets
	{
		
		[Embed(source="data/01.png")]private static var item01:Class
		[Embed(source="data/02.png")]private static var item02:Class
		[Embed(source="data/03.png")]private static var item03:Class
		[Embed(source="data/04.png")]private static var item04:Class
		[Embed(source="data/05.png")]private static var item05:Class
		[Embed(source="data/06.png")]private static var item06:Class
		[Embed(source="data/07.png")]private static var item07:Class
		[Embed(source="data/08.png")]private static var item08:Class
		[Embed(source="data/09.png")]private static var item09:Class
		
		
		[Embed(source="data/motion.png")]
		public static var motion:Class
		
		public static var itemIcons:Array
		
		
		// 初期化
		{
			itemIcons = [item01,item02,item03,item04,item05,item06,item07,item08,item09]
		}
		
	}
}