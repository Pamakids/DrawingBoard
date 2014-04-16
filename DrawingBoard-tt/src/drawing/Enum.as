package drawing
{
	import flash.utils.ByteArray;
	
	/*
		数据存储的静态类
	*/
	
	public class Enum
	{
		public static var width:Number=1024;//适配舞台的宽
		public static var height:Number=768;
		
		public static var pointArray:Array=[];//储存组成每条线点的数组，用于回放功能
		public static var recordPointArray:Array=[];//储存每个线条的数组
		//public static var bitmapArray:Array=[];//储存每次画完一条线时转化的bitmap，用于撤销和恢复
		public static var brushTypeArray:Array=[];//储存每次画完一条线时所使用的笔刷
		public static var colorArray:Array=[];//储存每一次线条颜色的值
		
		public static var brushType:String="";//笔刷类型
		
		public static var isEraser:Boolean=false;//是否调用橡皮擦
		//public static var isOperata:Boolean=false;//是否能执行撤销、恢复操作
		public static var isPlayBack:Boolean=false;//是否执行回放功能
		public static var isDelete:Boolean=true;//是否执行画布清理
		
		public static var recordByte:ByteArray;//储存保存图片的二进制数据
	}
}