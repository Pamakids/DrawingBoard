package models
{
	import com.pamakids.models.BaseVO;
	import com.pamakids.services.QNService;

	import vo.VO;

	public class PaintVO extends BaseVO
	{
		public function PaintVO()
		{
			super();
		}

		public var author:UserVO //画作者，可以获取到用户昵称和id	
		public var cover:String //封面地址	634*477：显示于作品详情页
//		441*332：显示于画廊列表大图
//		300*226：显示于用户个人中心
//		213*160：显示于画廊列表小图s
//		58*43：显示于消息列表
		public var data:String //绘图数据文件地址	
		public var audio:String //音频文件地址	
		public var views:Number //浏览数	
		public var plays:Number //播放数	
		public var comments:Number //评论数	
		public var favorites:Number //收藏数	
		public var agrees:Number //赞数	
		public var shares:Number //分享数	

		public var local:Boolean;
		public var path:String;

		public var big:Boolean;

		public var theme:String;

		public function get coverUrl():String
		{
			return VO.FILESERVER_HOST + cover;
		}

		public function getCoverUrlBySize(w:Number, h:Number):String
		{
			return QNService.getQNThumbnail(cover, w, h, 1);
		}
		public function get dataUrl():String
		{
			return VO.FILESERVER_HOST + data;
		}
	}
}
