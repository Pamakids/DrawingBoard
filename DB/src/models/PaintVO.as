package models
{

	public class PaintVO
	{
		public function PaintVO()
		{
		}

		public static function copy(o:Object):PaintVO
		{
			var po:PaintVO=new PaintVO();

			po.author=UserVO(o.author);

			po.cover=o.cover;
			po.data=o.data;
			po.audio=o.audio;
			po.views=o.views;
			po.plays=o.plays;
			po.comments=o.comments;
			po.favorites=o.favorites;
			po.agrees=o.agrees;
			po.shares=o.shares;
			po.created_at=o.created_at;

			return po;
		}

		public var author:UserVO //画作者，可以获取到用户昵称和id	
		public var cover:String //封面地址	634*477：显示于作品详情页
//		441*332：显示于画廊列表大图
//		300*226：显示于用户个人中心
//		213*160：显示于画廊列表小图
//		58*43：显示于消息列表
		public var data:String //绘图数据文件地址	
		public var audio:String //音频文件地址	
		public var views:Number //浏览数	
		public var plays:Number //播放数	
		public var comments:Number //评论数	
		public var favorites:Number //收藏数	
		public var agrees:Number //赞数	
		public var shares:Number //分享数	
		public var created_at:Date //创建日期
	}
}
