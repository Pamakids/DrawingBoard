package demos 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;
	import org.agony2d.renderer.bitmap.BitmapUtil;

	[SWF(width="1350", height = "600")]
public class BitmapUtilDemo extends Sprite 
{
	[Embed(source = "../assets/data/role.png")]
	private var asset_role:Class
	
	public function BitmapUtilDemo() 
	{
		this.x = 20
		
		var bp:Bitmap
		
		// 水彩
		bp = new (asset_role)()
		addChild(bp)
		bp.bitmapData = BitmapUtil.waterColorFilter(bp.bitmapData, 4, 4)
		
		// 扩散（毛玻璃）
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width + 20
		bp.bitmapData = BitmapUtil.diffuseFilter(bp.bitmapData, 6, 6)
		
		// 球面（鱼眼）
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width * 2 + 40
		bp.bitmapData = BitmapUtil.spherizeFilter(bp.bitmapData, 140, 140)
		
		// 挤压
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width * 3 + 60
		bp.bitmapData = BitmapUtil.pinchFilter(bp.bitmapData, 40, 40)
		
		// 高光
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width * 4 + 80
		bp.bitmapData = BitmapUtil.lightingFilter(bp.bitmapData, 60, 60, 60)
		
		// 杂点
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*5 + 100
		bp.bitmapData = BitmapUtil.noiseFilter(bp.bitmapData, 44)
		
		// 浮雕
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*6 + 120
		bp.filters = [new ConvolutionFilter(4, 4, BitmapUtil.getEmbossMatrix(33), 1)]
		
		//---------------------------------------------------------------------
		
		// 阈值
		bp = new (asset_role)()
		addChild(bp)
		bp.y = bp.height + 20
		bp.bitmapData = BitmapUtil.thresholdFilter(bp.bitmapData)
		
		// 油画效果
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width + 20
		bp.y = bp.height + 20
		bp.bitmapData = BitmapUtil.oilPaintingFilter(bp.bitmapData, 1, 4)
		
		// 旧照片
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*2 + 40
		bp.y = bp.height + 20
		bp.bitmapData = BitmapUtil.oldPictureFilter(bp.bitmapData)
		
		// 素描
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*3 + 60
		bp.y = bp.height + 20
		bp.bitmapData = BitmapUtil.sketchFilter(bp.bitmapData, 5)
		
		// 黑白
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*4 + 80
		bp.y = bp.height + 20
		bp.filters = [new ColorMatrixFilter(BitmapUtil.GRAY_SCALE_MATRIX)]
		
		// 反色
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*5 + 100
		bp.y = bp.height + 20
		bp.filters = [new ColorMatrixFilter(BitmapUtil.DIGITAL_NEGATIVE_MATRIX)]
		
		// 锐化
		bp = new (asset_role)()
		addChild(bp)
		bp.x = bp.width*6 + 120
		bp.y = bp.height + 20
		bp.filters = [new ConvolutionFilter(5,5, BitmapUtil.SHARPEN_MATRIX, 1)]
	}
	
}

}