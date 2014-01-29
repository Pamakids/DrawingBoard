package states
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import assets.game.GameAssets;
	import assets.homepage.HomepageAssets;
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

	public class RemoveThemeUIState extends UIState
	{
		override public function enter() : void
		{
			var img:ImagePuppet
			var bg:SpritePuppet
			
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
				img.embed(HomepageAssets.removeThemeBg)
				this.fusion.addElement(img, 0, -20, LayoutType.F__A__F_ALIGN, LayoutType.F__A__F_ALIGN)
			}

			{
				img=new ImagePuppet
				img.embed(HomepageAssets.removeThemeOk)
				this.fusion.addElement(img, 59, 143, LayoutType.AB, LayoutType.AB)
				img.addEventListener(AEvent.CLICK, onOk)
			}
			
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.removeThemeCancel)
				this.fusion.position = 1
				this.fusion.addElement(img, 183, 143, LayoutType.AB, LayoutType.AB)
				img.addEventListener(AEvent.CLICK, onCancel)
			}
		}
		
		override public function exit() : void{

		}
		
		private function onOk(e:AEvent):void{
			StateManager.setRemoveTheme(false)
			ShopManager.getInstance().removeTheme(this.stateArgs[0]);
			StateManager.setHomepage(true)
		}
		
		private function onCancel(e:AEvent):void{
			Agony.process.dispatchDirectEvent(GestureUIState.GESTRUE_CLOSE)
			StateManager.setRemoveTheme(false)
		}
			
	}
}