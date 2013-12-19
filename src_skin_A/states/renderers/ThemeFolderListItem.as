package states.renderers
{
	import flash.text.TextFormat;

	import assets.ImgAssets;
	import assets.homepage.HomepageAssets;

	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;

	import org.agony2d.notify.AEvent;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.ListItem;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.LabelPuppet;

	public class ThemeFolderListItem extends ListItem
	{


		override public function init():void
		{
			var img:ImagePuppet
			var label:LabelPuppet
			var css:TextFormat

			css=new TextFormat("weiruanyahei", 25, 0xFFFFFFF, true)
			if (this.id == 0)
			{
				// everyday bg
				{
					img=new ImagePuppet(5)
					img.embed(HomepageAssets.everydayBg)
					this.addElement(img)
				}

				mEverydayThemeFold=ThemeManager.getInstance().getRandomThemeFolder()
				mEverydayTheme=mEverydayThemeFold.getRandomTheme()

				// thumb
				{
					img=new ImagePuppet(5)
					this.addElement(img, -6.5, -7)
//					img.scaleX = img.scaleY = 1.2
					img.load(mEverydayTheme.everydayUrl, false)
				}

				// halo.
				{
					img=new ImagePuppet(5)
					img.embed(HomepageAssets.everydayHalo)
					this.addElement(img, -6.5, 124)
				}

				// txt.
				{
					label=new LabelPuppet("每日一画")
					this.addElement(label, 123, 145)
					label.textField.embedFonts=true
					label.textField.setTextFormat(css)
				}

				this.addEventListener(AEvent.CLICK, onEveryDay)

			}
			else
			{
				// common bg
				{
					img=new ImagePuppet(5)
					img.embed(HomepageAssets.themeBg)
					this.addElement(img)
				}

				// thumb
				{
					img=new ImagePuppet(5)
					this.addElement(img, 0, -9)
					var vo:ThemeFolderVo=this.itemArgs["data"]
					img.load(vo.thumbnail, false)
					this.userData=vo
				}

				// txt.
				{
					img=new ImagePuppet
					img.embed(vo.getThemeTxt())
					this.addElement(img, 135, 82)
				}

				// halo
//				{
//					img = new ImagePuppet(5)
//					img.embed(HomepageAssets.themeHalo)
//					this.addElement(img, 0, 129)	
//				}

//				label = new LabelPuppet(vo.getTitleName())
//				this.addElement(label, 185, 145)
//				label.textField.embedFonts = true
//				label.textField.setTextFormat(css)

				this.addEventListener(AEvent.CLICK, onClick)
			}



		}

		override public function resetData():void
		{

		}

		override public function handleChange(selected:Boolean):void
		{

		}


		private function onClick(e:AEvent):void
		{
//			StateManager.setTheme(false)
//			StateManager.setGameScene(true, this.userData as ThemeVo)
			var vo:ThemeFolderVo=ThemeManager.getInstance().prevThemeFolder=this.userData as ThemeFolderVo
//			trace("Theme Folder : " + vo.type)

			StateManager.setHomepage(false)
			StateManager.setTheme(true, vo.type);
			UserBehaviorAnalysis.trackEvent('A', '002', vo.type);
		}

		private var mEverydayThemeFold:ThemeFolderVo
		private var mEverydayTheme:ThemeVo

		private function onEveryDay(e:AEvent):void
		{


			ThemeManager.getInstance().prevThemeFolder=mEverydayThemeFold

			StateManager.setHomepage(false)
			StateManager.setGameScene(true, mEverydayTheme)

			UserBehaviorAnalysis.trackEvent('A', '001', mEverydayTheme.thumbnail.replace('assets/theme/img/thumbnail/', ''));
//			trace("[Every Day] Theme Folder : ")
		}
	}
}
