package states
{
	import com.google.analytics.debug.Layout;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import assets.ImgAssets;
	import assets.SoundAssets;
	import assets.gallery.GalleryAssets;
	import assets.homepage.HomepageAssets;
	import assets.theme.ThemeAssets;
	
	import models.Config;
	import models.StateManager;
	import models.ThemeFolderVo;
	import models.ThemeManager;
	import models.ThemeVo;
	
	import org.agony2d.Agony;
	import org.agony2d.air.AgonyAir;
	import org.agony2d.air.file.FolderType;
	import org.agony2d.air.file.IFile;
	import org.agony2d.air.file.IFolder;
	import org.agony2d.input.TouchManager;
	import org.agony2d.media.SfxManager;
	import org.agony2d.notify.AEvent;
	import org.agony2d.notify.DataEvent;
	import org.agony2d.timer.DelayManager;
	import org.agony2d.view.AgonyUI;
	import org.agony2d.view.Fusion;
	import org.agony2d.view.GridScrollFusionA;
	import org.agony2d.view.ImageButton;
	import org.agony2d.view.PivotFusion;
	import org.agony2d.view.RadioList;
	import org.agony2d.view.UIState;
	import org.agony2d.view.enum.ImageButtonType;
	import org.agony2d.view.enum.LayoutType;
	import org.agony2d.view.layouts.HorizLayout;
	import org.agony2d.view.layouts.ILayout;
	import org.agony2d.view.layouts.VertiLayout;
	import org.agony2d.view.puppet.ImagePuppet;
	import org.agony2d.view.puppet.SpritePuppet;
	
	import states.renderers.GalleryItem;
	import states.renderers.ThemeListItem;

	public class GalleryUIState extends UIState
	{


		public static const ITEM_REMOVED:String="itemRemoved"



		private const LIST_X:int=-20
		private const LIST_Y:int=142

		private const LIST_WIDTH:int=1024
		private const LIST_HEIGHT:int=768 - LIST_Y


		override public function enter():void
		{
			super.enter();
			var i:int, l:int
			var layout:ILayout
			var arr:Array
			var dir:ThemeFolderVo
			var sp:SpritePuppet
			var vo:ThemeVo
			var img:ImagePuppet
			var imgBtn:ImageButton
			var folder:IFolder

//			AgonyUI.addImageButtonData(ImgAssets.btn_menu, "btn_menu", ImageButtonType.BUTTON_RELEASE_PRESS)

			if (Agony.isMoblieDevice)
			{
				folder=AgonyAir.createFolder(Config.DB_FOLDER, FolderType.APP_STORAGE)
			}
			else
			{
				folder=AgonyAir.createFolder(Config.DB_FOLDER, FolderType.DOCUMENT)
			}
			mFiles=folder.getAllFiles()
//			trace(files)


			// bg
			img=new ImagePuppet
			this.fusion.addElement(img)
			img.embed(GalleryAssets.galleryBg)

			// list
			layout=new HorizLayout(330, 250, 3, 50, 5, 0, 20)
			mRadioList=new RadioList(layout, LIST_WIDTH, LIST_HEIGHT, 370, 320)
			mScroll=mRadioList.scroll
			mContent=mScroll.content
			mRadioList.scroll.vertiReboundFactor=0.5
			mRadioList.scroll.horizReboundFactor=1
//			dir = ThemeManager.getInstance().getThemeDirByType("animal")
//			arr = dir.themeList
//			l = arr.length
			l=mFiles.length
			while (i < l)
			{
//				vo = arr[i]
//				list.addItem({data:vo}, ThemeListItem)
				mItemList[mNumItems++]=mRadioList.addItem({"file": mFiles[i]}, GalleryItem)
				i++
			}

			// no file
			if (l == 0)
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.noFile, false)
				this.fusion.addElement(img, 0, 300, LayoutType.F__A__F_ALIGN)
			}

			this.fusion.addElement(mRadioList, LIST_X, LIST_Y)
			mScroll.addEventListener(AEvent.BEGINNING, onScrollStart)
			mScroll.addEventListener(AEvent.COMPLETE, onScrollComplete)
			mScroll.addEventListener(AEvent.UNSUCCESS, onScrollUnsuccess)


			// top bg
//			img = new ImagePuppet
//			this.fusion.addElement(img)
//			img.embed(ImgAssets.img_top_bg)

			// title
			{
				img=new ImagePuppet
				img.embed(GalleryAssets.galleryTitle)
				this.fusion.addElement(img, 0, 42, LayoutType.F__A__F_ALIGN)
				img.interactive=false
			}

			// back...
			{
				img=new ImagePuppet
				this.fusion.addElement(img, 42, 21)
				img.embed(GalleryAssets.galleryBack)
				img.addEventListener(AEvent.CLICK, onBackToHomepage)
			}

			// remove
			{
				mRemoveImg=new ImagePuppet(5)
				this.fusion.addElement(mRemoveImg, -108, 70, LayoutType.F__AF, 1)
				mRemoveImg.embed(GalleryAssets.gallery_trash)
				mRemoveImg.addEventListener(AEvent.CLICK, onToggleRemoveState)
				if (l == 0)
				{
					mRemoveImg.alpha=0.5
					mRemoveImg.interactive=false
				}
			}

			TouchManager.getInstance().velocityEnabled=true
//			TouchManager.getInstance().setVelocityLimit(4)


			Agony.process.addEventListener(GalleryItem.READY_TO_REMOVE_ITEM, onReadyToRemoveItem)

			UserBehaviorAnalysis.trackView('我的作品');
		}

		override public function exit():void
		{
			if (!isBack)
			{
				super.exit();
				UserBehaviorAnalysis.trackTime('E', exsitTime, '进入');
			}
			Agony.process.removeEventListener(GalleryItem.READY_TO_REMOVE_ITEM, onReadyToRemoveItem)

//			TouchManager.getInstance().velocityEnabled = false
			TweenLite.killTweensOf(mContent)
			var l:int=mFiles.length
			while (--l > -1)
			{
				mFiles[l].kill()
			}
		}



		private var mScroll:GridScrollFusionA
		private var mContent:PivotFusion
		private var mItemList:Array=[]
		private var mNumItems:int
		private var mRemoveImg:ImagePuppet
		private var mIsRemoveState:Boolean
		private var mFiles:Array
		private var mRadioList:RadioList


		private function onScrollStart(e:AEvent):void
		{
			trace("onScrollBeginning")

			TweenLite.killTweensOf(mContent)
		}

		private function onScrollUnsuccess(e:AEvent):void
		{
			var correctionX:Number

			correctionX=mScroll.correctionX
			if (correctionX != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.8, {x: mContent.x + correctionX,
					//y:mContent.y + correctionY,
						ease: Cubic.easeOut, onComplete: onTweenBack})
			}
			else
			{
				onTweenBack()
			}
		}

		private function onScrollComplete(e:AEvent):void
		{
			var correctionY:Number, velocityY:Number

			correctionY=mScroll.correctionY
			velocityY=AgonyUI.currTouch.velocityY
			if (correctionY != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.5, {y: mContent.y + correctionY,
					//y:mContent.y + correctionY,
						ease: Cubic.easeOut, onComplete: onTweenBack})
			}
			else if (velocityY != 0)
			{
				//				mContent.interactive = false
				TweenLite.to(mContent, 0.65, {y: mContent.y + velocityY * 20, ease: Cubic.easeOut, onUpdate: function():void
				{
					correctionY=mScroll.correctionY
					if (correctionY != 0)
					{
						mContent.y=mContent.y + correctionY
						TweenLite.killTweensOf(mContent, true)
					}
				}, onComplete: onTweenBack})
			}
			else
			{
				onTweenBack()
			}
		}

		private function onTweenBack():void
		{
			//			mContent.interactive = true
			mScroll.stopScroll()
		}


		private var isBack:Boolean;

		private function onBackToHomepage(e:AEvent):void
		{
			isBack=true;
			UserBehaviorAnalysis.trackEvent('E', '112', '', getTimer() - exsitTime);
			UserBehaviorAnalysis.trackTime('E', getTimer() - exsitTime, '返回');
			StateManager.setHomepage(true)
			StateManager.setGallery(false)
		}


		private function onToggleRemoveState(e:AEvent):void
		{
			var i:int
			var item:Fusion
			while (i < mNumItems)
			{
				item=mItemList[i++]
				item.dispatchDirectEvent(GalleryItem.Remove_STATE)
			}
			mIsRemoveState=!mIsRemoveState
			if (!mIsRemoveState && mRemoveItemFusion)
			{
				mRemoveItemFusion.kill()
				mRemoveItemFusion=null
				mScroll.visible=true
			}
			mRemoveImg.embed(mIsRemoveState ? GalleryAssets.gallery_cancel : GalleryAssets.gallery_trash)
		}





		///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////


		private var mRemoveItemFusion:Fusion
		private var mImg:ImagePuppet
		private var mRemovedFile:IFile
		private var mRemovedBytes:ByteArray

		private function onReadyToRemoveItem(e:DataEvent):void
		{
			var image:ImagePuppet
			mRemovedFile=e.data as IFile
			mRemovedBytes=mRemovedFile.bytes
			var thumbnail:String

			mScroll.visible=false

			{
				mRemoveItemFusion=new Fusion

				{
					image=new ImagePuppet
					image.embed(GalleryAssets.galleryItemBg)
					mRemoveItemFusion.addElement(image)
				}

				{
					image=new ImagePuppet
					image.embed(GalleryAssets.gallery_confirm)
					mRemoveItemFusion.addElement(image, 0, 350, LayoutType.B__A__B_ALIGN)
					image.addEventListener(AEvent.CLICK, onConfirmRemoveItem)
				}

				{
					mImg=new ImagePuppet
//					mImg.scaleX = 0.96
//					mImg.scaleY = 0.77
					mRemoveItemFusion.addElement(mImg, 7, 6)
					mRemovedBytes.position=4
					mRemovedBytes.readUTF()
					thumbnail=mRemovedBytes.readUTF()
					mImg.load(thumbnail, false)

				}
				
				{
					image=new ImagePuppet
					mRemoveItemFusion.position=0
					image.embed(GalleryAssets.galleryHalo)
					mRemoveItemFusion.addElement(image, 1, -1, 1, LayoutType.BA)
				}
				
				this.fusion.addElement(mRemoveItemFusion, 0, 200, LayoutType.F__A__F_ALIGN)
			}
		}

		private function onConfirmRemoveItem(e:AEvent):void
		{
			var folder:IFolder
			var i:int, l:int
			var img:ImagePuppet
			var thumbnail:String, finalUrl:String, bgUrl:String
			var rawFile:File

			SfxManager.getInstance().loadAndPlay(SoundAssets.url_del)

//			trace("Confirm Remove Item")
			mIsRemoveState=false
			mRemoveItemFusion.kill()
			mRemoveItemFusion=null
			mRemoveImg.embed(GalleryAssets.gallery_trash)
			mScroll.visible=true
			mRadioList.removeAllItems()

			l=mFiles.length
			while (--l > -1)
			{
				mFiles[l].kill()
			}


			if (Agony.isMoblieDevice)
			{
				folder=AgonyAir.createFolder(Config.DB_FOLDER, FolderType.APP_STORAGE)
			}
			else
			{
				folder=AgonyAir.createFolder(Config.DB_FOLDER, FolderType.DOCUMENT)
			}

			// 削除文件
			mRemovedBytes.position=4
			mRemovedBytes.readUTF()
			thumbnail=mRemovedBytes.readUTF()

//			AgonyAir.createFolder(

			rawFile=new File(thumbnail)
			if (rawFile.exists)
			{
				rawFile.deleteFile()
			}
			finalUrl=mRemovedBytes.readUTF()
			rawFile=new File(finalUrl)
			if (rawFile.exists)
			{
				rawFile.deleteFile()
			}
			bgUrl=mRemovedBytes.readUTF()
			rawFile=new File(bgUrl)
			if (rawFile.exists)
			{
				rawFile.deleteFile()
			}
			mRemovedFile.destroy()
			mRemovedFile=null

			mFiles=folder.getAllFiles()

			mItemList.length=mNumItems=0
			l=mFiles.length
			while (i < l)
			{
				//				vo = arr[i]
				//				list.addItem({data:vo}, ThemeListItem)
				mItemList[mNumItems++]=mRadioList.addItem({"file": mFiles[i]}, GalleryItem)
				i++
			}

			// no file
			if (l == 0)
			{
				img=new ImagePuppet
				img.embed(HomepageAssets.noFile, false)
				this.fusion.addElement(img, 0, 300, LayoutType.F__A__F_ALIGN)
				mRemoveImg.alpha=0.5
				mRemoveImg.interactive=false
			}
		}
	}
}
