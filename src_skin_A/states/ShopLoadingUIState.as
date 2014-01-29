package states
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import assets.game.GameAssets;
	import assets.shop.ShopAssets;
	
	import models.ShopManager;
	import models.ShopPurchaseVo;
	import models.StateManager;
	
	import org.agony2d.Agony;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.RangeEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ProgressBar;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;

	public class ShopLoadingUIState extends UIState
	{
		override public function enter() : void
		{
			var img:ImagePuppet
			var bg:SpritePuppet
			
			mPurchaseVo = this.stateArgs[0];
			// bg_A
			{
				bg=new SpritePuppet
				bg.graphics.beginFill(0x0, 0.4)
				bg.graphics.drawRect(-4, -4, AgonyUI.fusion.spaceWidth + 8, AgonyUI.fusion.spaceHeight + 8)
				//mResetBg.cacheAsBitmap = true
				this.fusion.addElement(bg)
			}
			
			// bg_B.
			{
				img=new ImagePuppet
				img.embed(ShopAssets.shopLoadingBg)
				this.fusion.addElement(img, 0, -20, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
			}
			
			// close btn.
			{
				mCloseBtn=new ImagePuppet
				mCloseBtn.embed(ShopAssets.shopLoadingClose)
				this.fusion.addElement(mCloseBtn, 525, 8, LayoutType.AB, LayoutType.AB)
				mCloseBtn.graphics.beginFill(0xdddd44, 0)
				mCloseBtn.graphics.drawRect(-14, -14, 55, 55)
				mCloseBtn.addEventListener(AEvent.CLICK, onCloseLoading)
			}

			// has net.
			if(this.stateArgs[1]){
				
				// detail.
				{
					// left.
					{
						img=new ImagePuppet
						img.embed(ShopAssets.detailTxt)
						this.fusion.position = 1
						this.fusion.addElement(img, 348, 54, LayoutType.AB, LayoutType.AB)
					}
					
					var rawSprite:SpritePuppet = new SpritePuppet
					this.fusion.position = 1
					this.fusion.addElement(rawSprite, 443, 54, LayoutType.AB, LayoutType.AB)
					var txt:TextField
					var css:TextFormat = new TextFormat("黑体",18, 0xFFFFFF) 
					
					{
						txt = new TextField
						txt.defaultTextFormat = css
						txt.text = String(mPurchaseVo.name);
						rawSprite.addChild(txt)
						
						txt = new TextField
						txt.defaultTextFormat = css
						txt.text = String(mPurchaseVo.numPages);
						txt.y = 32
						rawSprite.addChild(txt)
						
						txt = new TextField
						txt.defaultTextFormat = css
						txt.text = "免费";
						txt.y = 65
						rawSprite.addChild(txt)
					}
				}
				
				// cover.
				{
					img=new ImagePuppet
					img.load(mPurchaseVo.localURL, false);
					this.fusion.position = 1
					this.fusion.addElement(img, 37, 52, LayoutType.AB, LayoutType.AB)
				}
				
				// downloaded.
				if(ShopManager.getInstance().getShopVo(mPurchaseVo.id)){
					img=new ImagePuppet
					img.embed(ShopAssets.downloaded)
					this.fusion.position = 1
					this.fusion.addElement(img, 438, 300, LayoutType.AB, LayoutType.AB)
					
				}
				// can download.
				else{
					mDownloadBtn=new ImagePuppet
					mDownloadBtn.embed(ShopAssets.downloadBtn)
					this.fusion.position = 1
					this.fusion.addElement(mDownloadBtn, 438, 300, LayoutType.AB, LayoutType.AB)
					mDownloadBtn.addEventListener(AEvent.CLICK, onStartToDownload)
				}
			}
			
			// no net.
			else{
				img=new ImagePuppet
				this.fusion.position = 1
				this.fusion.addElement(img, 90, 126, LayoutType.AB, LayoutType.AB)
				img.embed(ShopAssets.noNet_A)
			}
			
			ShopManager.getInstance().addEventListener(RangeEvent.PROGRESS, onDownloading)
			ShopManager.getInstance().addEventListener(AEvent.COMPLETE, onComplete)
			ShopManager.getInstance().addEventListener(AEvent.UNSUCCESS, onUnsuccess)
		}
		
		override public function exit() : void{
			if(mNextFrameReady){
				Agony.process.removeEventListener(AEvent.ENTER_FRAME, onNextFrame)
			}
			
			ShopManager.getInstance().removeEventListener(RangeEvent.PROGRESS, onDownloading)
			ShopManager.getInstance().removeEventListener(AEvent.COMPLETE, onComplete)
			ShopManager.getInstance().removeEventListener(AEvent.UNSUCCESS, onUnsuccess)
		}
			
		
		private var mCloseBtn:ImagePuppet
		private var mPurchaseVo:ShopPurchaseVo
		private var mRawSprite:SpritePuppet
		private var mPb:ProgressBar
		private var mDownloadBtn:ImagePuppet
		private var mCancelBtn:ImagePuppet
		private var mDownloadFail:ImagePuppet
		
		
		
		private function onCloseLoading(e:AEvent):void{
			StateManager.setShopLoading(false)
			Agony.process.dispatchDirectEvent(ShopUIState.EXIT_LOADING)
		}
		
		
		
		private function onStartToDownload(e:AEvent):void{
			downloadProgress
			
			if(mDownloadFail){
				mDownloadFail.kill();
				mDownloadFail = null;
			}
			
			mPb = new ProgressBar(downloadProgress)
			this.fusion.position = 1
			this.fusion.addElement(mPb, 36, 304, LayoutType.AB, LayoutType.AB)
				
			mCloseBtn.interactive = false
			mCloseBtn.alpha = 0.3
				
			mDownloadBtn.visible = false;
				
			if(!mCancelBtn){
				mCancelBtn=new ImagePuppet
				mCancelBtn.embed(ShopAssets.cancelBtn)
				this.fusion.position = 1
				this.fusion.addElement(mCancelBtn, 438, 300, LayoutType.AB, LayoutType.AB)
				mCancelBtn.addEventListener(AEvent.CLICK, onCancelDownload)
			}
			else{
				mCancelBtn.visible = true;
			}
			
			Agony.process.addEventListener(AEvent.ENTER_FRAME, onNextFrame)
			mNextFrameReady = true
		}
		
		private var mNextFrameReady:Boolean
		private function onNextFrame(e:AEvent):void{
			Agony.process.removeEventListener(AEvent.ENTER_FRAME, onNextFrame)
			mPurchaseVo.download();
			mNextFrameReady = false
		}
		
		private function onComplete(e:AEvent):void{
			var img:ImagePuppet
			
			mCloseBtn.interactive = true
			mCloseBtn.alpha = 1
				
			mPb.kill();
			mPb = null
				
			mDownloadBtn.kill();
			if(mCancelBtn){
				mCancelBtn.kill();
			}
			
			img=new ImagePuppet
			img.embed(ShopAssets.downloaded) 
			this.fusion.position = 1
			this.fusion.addElement(img, 438, 300, LayoutType.AB, LayoutType.AB)
		}
		
		private function onDownloading(e:RangeEvent):void{
			mPb.range.ratio = e.currValue / e.totalValue;
			
			trace(e.currValue + " / " + e.totalValue)
		}
		
		private function onUnsuccess(e:AEvent):void{
			mCloseBtn.interactive = true
			mCloseBtn.alpha = 1
				
			mCloseBtn.interactive = true
			mCloseBtn.alpha = 1
			
			mPb.kill();
			mPb = null
				
			mDownloadBtn.visible = true
			mCancelBtn.visible = false
				
			mDownloadFail=new ImagePuppet
			mDownloadFail.embed(ShopAssets.downloadFail) 
			this.fusion.position = 1
			this.fusion.addElement(mDownloadFail, 77, 307, LayoutType.AB, LayoutType.AB)
		}
		
		private function onCancelDownload(e:AEvent):void{
			mDownloadBtn.visible = true
			mCancelBtn.visible = false
				
			mPb.kill();
			mPb = null
				
			mPurchaseVo.cancel();
		}
	}
}