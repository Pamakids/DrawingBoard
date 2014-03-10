package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.TextArea;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.BezierPlugin;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import assets.Assets;
	
	import org.despair2D.Despair;
	import org.despair2D.control.DelayManager;
	import org.despair2D.control.KeyboardManager;
	import org.despair2D.control.MouseManager;
	import org.despair2D.control.ZMouseEvent;
	import org.despair2D.model.BooleanProperty;
	import org.despair2D.resource.ILoader;
	import org.despair2D.resource.LoaderManager;
	import org.despair2D.resource.URLLoaderManager;

	
	[SWF(width = "1200", height = "650",backgroundColor = "0x333333")]
	public class bezierEditor extends Sprite
	{
		public function bezierEditor()
		{
			Despair.startup(this.stage)
			
			motionObjectRef = Assets.motion
			stage.frameRate = DEFAULT_FRAMERATE
			//NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke)
			//NativeApplication.nativeApplication.setAsDefaultApplication("bezier")
				
			this.addRootShellA()
			this.createStartNode()
			this.initializeUI()
			this.addController()
		}
		
		
		
		private const DEFAULT_FRAMERATE:int = 24
		
		private const DEFAULT_PROBABILITY:Number = 4
			
		private const DEFAULT_MAX_PER_FRAME:Number = 4
			
		private const DEFAULT_DURATION:Number = 8.0
			
		private const DEFAULT_SCALE:Number = 0.8
		
		private const MAX_ROUND_TIME:Number = 30
			
		private const DEFAULT_NEXT_ROUND_DELAY_TIME:Number = 7
			
		private const MAX_NEXT_ROUND_DELAY_TIME:Number = 30
			
		private const NODE_HIDE_ALPHA:Number = 0.08
		
		private const DEFAULT_SCENE_WIDTH:int = 2500
			
		private const DEFAULT_SCENE_HEIGHT:int = 2000
			
		private const DRAG_RECT:Rectangle = new Rectangle(10,10,DEFAULT_SCENE_WIDTH-10, DEFAULT_SCENE_HEIGHT-10)
		
		private const BG_DRAG_RECT:Rectangle = new Rectangle(10,10,DEFAULT_SCENE_WIDTH-10, DEFAULT_SCENE_HEIGHT-10)
			
		private const MAX_MOTION:int = 3000
		
		
		
		private function addRootShellA():void
		{
			// 左侧底层
			mRootShellA = new ScrollPane(this)
			mRootShellA.x = mRootShellA.y = 10
			mRootShellA.cacheAsBitmap = true
			mRootShellA.width = 970
			mRootShellA.height = 630
			mRootShape = new Shape()
			mRootShape.graphics.beginFill(0xdddddd,0.7)
			mRootShape.graphics.drawRect(0,0,DEFAULT_SCENE_WIDTH,DEFAULT_SCENE_HEIGHT)
			mRootShellA.addChild(mRootShape)
			
			// 背景层
			mBackgroundShell = new Sprite()
			mRootShellA.addChild(mBackgroundShell)
				
			// 移动层
			mMotionShell = new Sprite()
			mRootShellA.addChild(mMotionShell)
			
			mMotionShell.mouseEnabled = false
			mMotionShell.mouseChildren = false
				
		}
			
		
		private function initializeUI():void
		{
			var button:PushButton
			var label:Label
			var sprite:BitmapSprite
			var l:int

			mUiShell = new Sprite()
			mUiShell.x = 140
			mUiShell.cacheAsBitmap = true	
			this.addChild(mUiShell)
			
			
			// 当前正在移动数量
			numMotionLabel = new Label(mUiShell, 663, 14, 'motion: 0')
			numMotionLabel.mouseEnabled = numMotionLabel.mouseChildren = false
				
			// 最大移动数量
			var n:Number
			label = new Label(mUiShell, 729, 14, 'maxMotion:')
			maxMotionsInput = new InputText(mUiShell, 787, 14, "0", function(e:Event):void
			{
				if(maxMotionsInput.textField.text == "")
				{
					maxMotionsInput.text = "0"
					maxMotions = 0
				}
				
				else
				{
					n = Number(maxMotionsInput.text)
					n = (n > 3000) ? 3000 : n
					maxMotionsInput.text = String(n)
					maxMotions = n
				}
			})
			maxMotionsInput.textField.restrict = "0-9"
			maxMotionsInput.width = 40
			maxMotionsInput.height = 20
				
			// frameRate
			label = new Label(mUiShell, 729, 606, 'frameRate:')
			frameRateInput = new InputText(mUiShell, 787, 606, String(DEFAULT_FRAMERATE), function(e:Event):void
			{
				trace(frameRateInput.textField.text)
				
				if(frameRateInput.textField.text == "")
				{
					frameRateInput.text = String(DEFAULT_FRAMERATE)
					stage.frameRate = DEFAULT_FRAMERATE
				}
					
				else
				{
					n = Number(frameRateInput.text)
					n = (n > 60) ? 60 : n
					frameRateInput.text = String(n)
					stage.frameRate = n
				}
			})
			frameRateInput.textField.restrict = "0-9"
			frameRateInput.width = 40
			frameRateInput.height = 20
				
			// 当前对象坐标
			/*label = new Label(mUiShell, 767, 14, 'Y -')
			coordinateInput = new InputText(mUiShell, 785, 14, "",function():void
			{
				
			})
			coordinateInput.width = 40
			coordinateInput.height = 20*/
				
			// 提示
			label = new Label(mUiShell, 850, 1, 'add / remove node by right press.')
			label.scaleX = label.scaleY = 1.3
			label.mouseEnabled = label.mouseChildren = false
			label.textField.textColor = 0xffffff
				
			// 移动对象资源
			button = new PushButton(mUiShell, 850, 30, 'Load Motion Image', function(e:MouseEvent):void
			{
				onLoadMotionImage()
			})
			button.width = 90
			button = new PushButton(mUiShell, 960, 30, 'Reset', function(e:MouseEvent):void
			{
				motionObjectRef = Assets.motion
				
				l = numMotions
				while(--l>-1)
				{
					sprite = motionObjects[l]
					sprite.setBitmap(Assets.motion)
				}
			})
			button.width = 50
			
			// 加载背景
			button = new PushButton(mUiShell, 850, 55, 'Load Bg', function(e:MouseEvent):void
			{
				onLoadBackground()
			})
			button.width = 90
				
			// 削除全部背景
			button = new PushButton(mUiShell, 960, 55, 'Remove All Bg', function(e:MouseEvent):void
			{
				l = mBackgroundList.length
				while(--l>-1)
				{
					sprite = mBackgroundList[l]
					sprite.dispose()
				}
				mBackgroundList = []
			})
			button.width = 90
				
			// 开始播放
			button = new PushButton(mUiShell, 850, 80, 'Play (Space)', function(e:MouseEvent):void
			{
				play()
				trace('Play...')
			})
				
			button.width = 90
				
			// 停止
			button = new PushButton(mUiShell, 960, 80, 'Stop (S)', function(e:MouseEvent):void
			{
				stop()
				trace('Stop...')
			})
			button.width = 90
			
			// 透明值
			label = new Label(mUiShell, 850, 100, 'alpha ( min / max ):')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperAlphaMin = new NumericStepper(mUiShell, 850, 120)
			stepperAlphaMin.minimum = 0.1
			stepperAlphaMin.maximum = 1
			stepperAlphaMin.value = 1
			stepperAlphaMin.step = 0.1
			stepperAlphaMin.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperAlphaMin.value > stepperAlphaMax.value)
				{
					stepperAlphaMin.value = stepperAlphaMax.value
				}
			})
			
			stepperAlphaMax = new NumericStepper(mUiShell, 955, 120)
			stepperAlphaMax.minimum = 0.1
			stepperAlphaMax.maximum = 1
			stepperAlphaMax.value = 1
			stepperAlphaMax.step = 0.1
			stepperAlphaMax.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperScaleMin.value > stepperAlphaMax.value)
				{
					stepperAlphaMax.value = stepperScaleMin.value
				}
			})
			
			// 每帧最多产生数量
			label = new Label(mUiShell, 850, 150, 'max per frame:')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperAmount = new NumericStepper(mUiShell, 850, 170)
			stepperAmount.minimum = 1
			stepperAmount.maximum = 30
			stepperAmount.step = 1
			stepperAmount.value = DEFAULT_MAX_PER_FRAME
			
			// 出生概率
			label = new Label(mUiShell, 955, 150, 'probability:')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperProbability = new NumericStepper(mUiShell, 955, 170)
			stepperProbability.minimum = 1
			stepperProbability.maximum = 100
			stepperProbability.step = 1
			stepperProbability.value = DEFAULT_PROBABILITY
				
			button = new PushButton(mUiShell, 1040, 170, "M", function(e:MouseEvent):void
			{
				stepperProbability.value = stepperProbability.maximum
			})
			button.width = 16
			button.height = 16
				
			// 持续时间
			label = new Label(mUiShell, 850, 200, 'duration ( min / max ):')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperDurationMin = new NumericStepper(mUiShell, 850, 220, function(e:Event):void
			{
				if(stepperDurationMin.value > stepperDurationMax.value)
				{
					stepperDurationMin.value = stepperDurationMax.value
				}
			})
			stepperDurationMin.minimum = 0
			stepperDurationMin.maximum = 30
			stepperDurationMin.step = 0.5
			stepperDurationMin.value = DEFAULT_DURATION
				
			stepperDurationMax = new NumericStepper(mUiShell, 955, 220, function(e:Event):void
			{
				if(stepperDurationMin.value > stepperDurationMax.value)
				{
					stepperDurationMax.value = stepperDurationMin.value
				}
			})
			stepperDurationMax.minimum = 0
			stepperDurationMax.maximum = 30
			stepperDurationMax.step = 0.5
			stepperDurationMax.value = DEFAULT_DURATION
				
			// 物件缩放比
			label = new Label(mUiShell, 850, 250, 'scale ( min / max ):')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperScaleMin = new NumericStepper(mUiShell, 850, 270)
			stepperScaleMin.minimum = 0.1
			stepperScaleMin.maximum = 3
			stepperScaleMin.value = DEFAULT_SCALE
			stepperScaleMin.step = 0.2
			stepperScaleMin.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperScaleMin.value > stepperScaleMax.value)
				{
					stepperScaleMin.value = stepperScaleMax.value
				}
			})
				
			stepperScaleMax = new NumericStepper(mUiShell, 955, 270)
			stepperScaleMax.minimum = 0.1
			stepperScaleMax.maximum = 3
			stepperScaleMax.value = DEFAULT_SCALE
			stepperScaleMax.step = 0.2
			stepperScaleMax.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperScaleMin.value > stepperScaleMax.value)
				{
					stepperScaleMax.value = stepperScaleMin.value
				}
			})
				
			// 缓动类型
			easeFuction = Linear.easeNone
			label = new Label(mUiShell, 850, 290, 'ease:')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			comboBox = new ComboBox(mUiShell, 850, 310,"Linear.easeNone", ['Cubic.easeOut',
																		'Cubic.easeIn',
																		'Linear.easeNone',
																		'Linear.easeOut',
																		'Linear.easeIn',
																		'Strong.easeOut',
																		"Strong.easeIn"]) 
			comboBox.addEventListener(Event.SELECT, function(e:Event):void
			{
				switch(comboBox.selectedItem)
				{
					case "Cubic.easeOut":
						easeFuction = Cubic.easeOut
						break;
					
					case "Cubic.easeIn":
						easeFuction = Cubic.easeIn
						break
					
					case "Linear.easeNone":
						easeFuction = Linear.easeNone
						break;
					
					case "Linear.easeOut":
						easeFuction = Linear.easeOut
						break;
					
					case "Linear.easeIn":
						easeFuction = Linear.easeIn
						
					case "Strong.easeOut":
						easeFuction = Strong.easeOut
						break
					
					case "Strong.easeIn":
						easeFuction = Strong.easeIn
						break
					
				}
			})
			
			// 是否移动时隐藏节点
			checkBox = new CheckBox(mUiShell, 960, 315, "hide nodes (H)",function(e:MouseEvent):void
			{
				isHideNodes.value = !isHideNodes.value
			})
			checkBox.scaleX = checkBox.scaleY = 1.2
			checkBox.labelComp.textField.textColor = 0xffffff
			
			// 每一轮持续时间
			label = new Label(mUiShell, 850, 340, 'round duration ( min / max ):')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperRoundMin = new NumericStepper(mUiShell, 850, 360)
			stepperRoundMin.minimum = 0
			stepperRoundMin.maximum = MAX_ROUND_TIME
			stepperRoundMin.value = 0
			stepperRoundMin.step = 2
			stepperRoundMin.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperRoundMin.value > stepperRoundMax.value)
				{
					stepperRoundMin.value = stepperRoundMax.value
				}
			})
			
			stepperRoundMax = new NumericStepper(mUiShell, 955, 360)
			stepperRoundMax.minimum = 0
			stepperRoundMax.maximum = MAX_ROUND_TIME
			stepperRoundMax.value = 0
			stepperRoundMin.step = 2
			stepperRoundMax.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperRoundMin.value > stepperRoundMax.value)
				{
					stepperRoundMax.value = stepperRoundMin.value
				}
			})
				
			// 下一轮开始的延迟时间
			label = new Label(mUiShell, 850, 390, 'delay for next round ( min / max ):')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperNextRoundMin = new NumericStepper(mUiShell, 850, 420)
			stepperNextRoundMin.minimum = 1
			stepperNextRoundMin.maximum = MAX_NEXT_ROUND_DELAY_TIME
			stepperNextRoundMin.value = DEFAULT_NEXT_ROUND_DELAY_TIME
			stepperNextRoundMin.step = 1
			stepperNextRoundMin.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperNextRoundMin.value > stepperNextRoundMax.value)
				{
					stepperNextRoundMin.value = stepperNextRoundMax.value
				}
			})
			
			stepperNextRoundMax = new NumericStepper(mUiShell, 955, 420)
			stepperNextRoundMax.minimum = 4
			stepperNextRoundMax.maximum = MAX_NEXT_ROUND_DELAY_TIME
			stepperNextRoundMax.value = DEFAULT_NEXT_ROUND_DELAY_TIME
			stepperNextRoundMax.step = 1
			stepperNextRoundMax.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperNextRoundMin.value > stepperNextRoundMax.value)
				{
					stepperNextRoundMax.value = stepperNextRoundMin.value
				}
			})
				
			// 开始移动前的延迟时间
			label = new Label(mUiShell, 850, 450, 'delay for motion( min / max ):')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			stepperDelayMin = new NumericStepper(mUiShell, 850, 470)
			stepperDelayMin.minimum = 0
			stepperDelayMin.maximum = 10
			stepperDelayMin.value = 0
			stepperDelayMin.step = 0.2
			stepperDelayMin.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperDelayMin.value > stepperDelayMax.value)
				{
					stepperDelayMin.value = stepperDelayMax.value
				}
			})
			
			stepperDelayMax = new NumericStepper(mUiShell, 955, 470)
			stepperDelayMax.minimum = 0
			stepperDelayMax.maximum = 10
			stepperDelayMax.value = 0
			stepperDelayMax.step = 0.2
			stepperDelayMax.addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(stepperDelayMin.value > stepperDelayMax.value)
				{
					stepperDelayMax.value = stepperDelayMin.value
				}
			})	
				
			// 削除全部节点
			button = new PushButton(mUiShell, 965, 580, 'Remove All Nodes', function(e:MouseEvent):void
			{
				stop()
				resetNodes(1)
				createBezierPointsObject();	
				updatePath();
			})
			button.width = 90
				
			// 输出结果
			label = new Label(mUiShell, 850, 500, 'output:')
			label.scaleX = label.scaleY = 1.2
			label.textField.textColor = 0xffffff
			textArea = new TextArea(mUiShell, 850, 520)
			textArea.width = 110
			textArea.height = 120
			
			// 导入数据
			button = new PushButton(mUiShell, 980, 520, 'Import', function(e:MouseEvent):void
			{
				var F:File = new File()
				F = new File()
				F.addEventListener(Event.SELECT, onImportBezierFile)
				
				F.browseForOpen("请选择 bezier 格式文件.", [new FileFilter('bezier', '*.bezier;*.bez')])
			})
			button.width = 60
				
			// 导出数据
			button = new PushButton(mUiShell, 980, 550, 'Export', function(e:MouseEvent):void
			{
				var BV:BezierVo = new BezierVo()
				
				BV.startX = nodes[0].x
				BV.startY = nodes[0].y
				
				BV.alphaMin = stepperAlphaMin.value
				BV.alphaMax = stepperAlphaMax.value
				
				BV.delayMin = stepperDelayMin.value
				BV.delayMax = stepperAlphaMax.value
				
				BV.durationMin = stepperDurationMin.value
				BV.durationMax = stepperDurationMax.value
				
				BV.scaleMin = stepperScaleMin.value
				BV.scaleMax = stepperScaleMax.value
				
				BV.nextRoundMin = stepperNextRoundMin.value
				BV.nextRoundMax = stepperNextRoundMax.value
				
				BV.roundMin = stepperRoundMin.value
				BV.roundMax = stepperRoundMax.value
				
				BV.probability = stepperProbability.value
				BV.maxMotions = maxMotions
				BV.maxPerFrame = stepperAmount.value
				BV.frameRate = stage.frameRate
				BV.ease = comboBox.selectedItem as String
				
				var list:Array = []
				var max:int = nodes.length;
				for(var i:int = 1; i < max; i++)
				{
					var curPoint:DisplayObject = nodes[i];
					list.push(curPoint.x)
					list.push(curPoint.y)
				}
				
				BV.bezierPoints = list
				
				var FR:FileReference = new FileReference()
				FR.save(BV.toByteArray(), "01.bezier")
			})
			button.width = 60
		}
	
	
		private function onImportBezierFile(e:Event):void
		{
			var file:File;
			var loader:ILoader;
			var request:URLRequest;
			
			file = e.target as File
			file.removeEventListener(Event.SELECT, onImportBezierFile)
			if(!file.exists)
			{
				return
			}
			
			loader = URLLoaderManager.getInstance().getLoader(file.url, URLLoaderDataFormat.BINARY);
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var ba:ByteArray = loader.data as ByteArray
				/*trace(ba.length)
				trace(ba.position)
				var o:Object = ba.readObject() as Object
				var key:*
				for(key in o)
				{
					trace(key + ' | ' + o[key])
				}*/
				
				var BV:BezierVo = new BezierVo()
				BV.fromByteArray(ba)
				
				stop()
				
				nodes[0].x = BV.startX
				nodes[0].y = BV.startY
				
				stepperAlphaMin.value = BV.alphaMin
				stepperAlphaMax.value = BV.alphaMax
				
				stepperDelayMin.value = BV.delayMin
				stepperDelayMax.value = BV.delayMax
				
				stepperDurationMin.value = BV.durationMin
				stepperDurationMax.value = BV.durationMax
				
				stepperScaleMin.value = BV.scaleMin
				stepperScaleMax.value = BV.scaleMax
				
				stepperNextRoundMin.value = BV.nextRoundMin
				stepperNextRoundMax.value = BV.nextRoundMax
				
				stepperRoundMin.value = BV.roundMin
				stepperRoundMax.value = BV.roundMax
				
				stepperProbability.value = BV.probability
				maxMotions = BV.maxMotions
				maxMotionsInput.text = String(maxMotions)
				comboBox.selectedItem = BV.ease
				
				frameRateInput.text = String(BV.frameRate)
				stage.frameRate = BV.frameRate
				
				stepperAmount.value = BV.maxPerFrame
				
				resetNodes(1)
				
				var list:Array = BV.bezierPoints
				var i:int, l:int = list.length / 2
				while(i < l)
				{
					addNode(list[i * 2], list[i * 2 + 1])
					i++
				}
				
				createBezierPointsObject();	
				updatePath()
			})
		}
	
		

		private function createStartNode():void
		{
			mNodeShell = new Sprite()
			mRootShellA.addChild(mNodeShell)
				
			this.addNode(120,40)
			createBezierPointsObject();	
			updatePath();
		}
		
		private function createMotionObject() : void
		{

			removeAllMotionObjects()
		}
		
		
		private function addNode( gx:Number, gy:Number ) : void
		{
			var node:BitmapSprite
			var l:int = nodes.length
			
			if(l > 8)
			{
				node = BitmapSprite.create(Assets.itemIcons[8],5,false)
			}
			
			else
			{
				node = BitmapSprite.create(Assets.itemIcons[l],5,false)
			}
			
			nodes.push(node)
			node.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag)
			node.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRemove)
			mNodeShell.addChild(node)
			//node.scaleX = node.scaleY = 0.6
			node.x = gx
			node.y = gy
		}
		
		private function addController():void
		{
			Despair.addUpdateListener(onUpdateAll)
			stage.addEventListener(Event.RESIZE, onStageResize)
				
			MouseManager.getInstance().rightButtonEnabled = true
			stage.addEventListener(MouseEvent.MOUSE_UP, onRelease)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragging)
			MouseManager.getInstance().rightButton.addEventListener(ZMouseEvent.MOUSE_PRESS, onAddNode)
				
			KeyboardManager.getInstance().initialize()	
			KeyboardManager.getInstance().getState().addPressListener("SPACE", function():void
			{
				play()
			})
			KeyboardManager.getInstance().getState().addPressListener("S", function():void
			{
				stop()
			})
			KeyboardManager.getInstance().getState().addPressListener("S", function():void
			{
				stop()
			})	
			KeyboardManager.getInstance().getState().addPressListener("H", function() : void
			{
				isHideNodes.value = !isHideNodes.value
				checkBox.selected = isHideNodes.value
			})
				
			isHideNodes = new BooleanProperty(false)
			isHideNodes.binding(function():void
			{
				if(playing)
				{
					if(isHideNodes.value)
					{
						mNodeShell.alpha = NODE_HIDE_ALPHA
					}
					
					else
					{
						mNodeShell.alpha = 1
					}
				}
			})
		}
		
		
		/** 加载移动图像 **/
		private function onLoadMotionImage():void
		{
			var file:File
			
			file = new File()
			file.addEventListener(Event.SELECT, onSelectMotionImage)
			file.browseForOpen("Please select an image for the motion object.")
		}
		
		
		private function onSelectMotionImage(e:Event):void
		{
			var file:File;
			var loader:ILoader;
			var request:URLRequest;
			
			file = e.target as File
			file.removeEventListener(Event.SELECT, onSelectMotionImage)
			if(file.exists)
			{
				if(file.extension != 'png' && file.extension != 'jpg')
				{
					return
				}
			}
			
			loader = LoaderManager.getInstance().getLoader(file.url);
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				if(motionObjectRef is BitmapData)
				{
					(motionObjectRef as BitmapData).dispose()
				}
				
				var bmd:BitmapData = motionObjectRef = (loader.data as Bitmap).bitmapData
				
				var l:int = numMotions
				var sprite:BitmapSprite
				
				while(--l>-1)
				{
					sprite = motionObjects[l]
					sprite.bitmapData = bmd.clone()
				}
			})
		}
		
		
		/** 加载背景 **/
		private function onLoadBackground():void
		{
			var file:File
			
			file = new File()
			file.addEventListener(Event.SELECT, onSelectBackgroundImage)
			file.browseForOpen("Please select an image and add it to the background.")
		}
		
		
		private function onSelectBackgroundImage(e:Event):void
		{
			var file:File;
			var loader:ILoader;
			var request:URLRequest;
			
			file = e.target as File
			file.removeEventListener(Event.SELECT, onSelectBackgroundImage)
			if(file.exists)
			{
				if(file.extension != 'png' && file.extension != 'jpg')
				{
					return
				}
			}
			
			loader = LoaderManager.getInstance().getLoader(file.url);
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				addBackgroundObject((loader.data as Bitmap).bitmapData)
			})
		}
		
		
		private function addBackgroundObject( bitmapData:BitmapData ) :void
		{
			var sprite:BitmapSprite = BitmapSprite.create(bitmapData, 7, false)
			mBackgroundShell.addChild(sprite)
			mBackgroundList.push(sprite)
			mBackgroundShell.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragBackground)
		}
		
		
		private function onStartDragBackground(e:MouseEvent):void
		{
			currBackground = e.target as BitmapSprite
			currBackground.startDrag(false, BG_DRAG_RECT)
		}
		

		
		private function play() : void
		{
			if(nodes.length <= 1)
			{
				trace('当前只有一个node..无法开始')
				return
			}
			
			if(playing)
			{
				TweenMax.killAll();
				removeAllMotionObjects()
			}
			playing = true
				
			if(isHideNodes.value)
			{
				mNodeShell.alpha = NODE_HIDE_ALPHA
			}
			
			this.startRound()
		}
		
		private function startRound():void
		{
			isRoundStarted = true
			var r:Number
			
			r = (stepperRoundMin.value == stepperRoundMax.value) ? 
				stepperRoundMin.value : 
				stepperRoundMin.value + Math.random() * (stepperRoundMax.value - stepperRoundMin.value)
			
			if(r > 0)
			{
				roundDelayID = DelayManager.getInstance().delayedCall(r, function():void
				{
					endRound()
				})
			}
		}
		
		private function endRound():void
		{
			isRoundStarted = false
			var r:Number
			
			r = (stepperNextRoundMin.value == stepperNextRoundMax.value) ? 
				stepperNextRoundMin.value : 
				stepperNextRoundMin.value + Math.random() * (stepperNextRoundMax.value - stepperNextRoundMin.value)
			
			roundDelayID = DelayManager.getInstance().delayedCall(r, function():void
			{
				startRound()
			})
		}

		private function stop() : void
		{
			if(roundDelayID > 0)
			{
				DelayManager.getInstance().removeDelayedCall(roundDelayID)
				roundDelayID = 0
			}
			TweenMax.killAll();
			this.playing = false
			removeAllMotionObjects()
		}
		
		
		
		private var TweenStartString:String = "TweenMax.to(mc, 3, {bezierThrough:["
		private var TweenEndString:String = "]});"
		
		
		private function createBezierPointsObject():void
		{
			bezierPoints = [];
			xA = []
			yA = []
			var max:int = nodes.length;
			for(var i:int = 0; i < max; i++){
				var curPoint:DisplayObject = nodes[i];
				if(i!=0){
					bezierPoints[i] = {x:curPoint.x, y:curPoint.y};	
				}
				xA.push(curPoint.x);
				yA.push(curPoint.y);
			}
			
			i = 1
			var list:Array = []
			var l:int = bezierPoints.length
			var t:Object
			var sprite:BitmapSprite
			
			while(i < l)
			{
				t = bezierPoints[i++]
				list.push('{x:'+ t.x + ',y:' + t.y + '}')
			}
			
			if(textArea)
			{
				sprite = nodes[0]
				textArea.text = 'start: ' + sprite.x + ' | ' + sprite.y + '\n\n' + list.join(',\n')
			}
				
		}
		
		private function updatePath():void
		{
			
			mNodeShell.graphics.clear();	
			
			mNodeShell.graphics.lineStyle(1, 0x0000);
			
			mNodeShell.graphics.moveTo(nodes[0].x, nodes[0].y)
			var bezierObj:Object=BezierPlugin.parseBeziers({"x":xA,"y":yA},true);
			
			var pointCount:int=0;
			while(pointCount<bezierObj["x"].length)
			{
				mNodeShell.graphics.curveTo(bezierObj.x[pointCount][1], bezierObj.y[pointCount][1],bezierObj.x[pointCount][2],bezierObj.y[pointCount][2]);
				pointCount++
			}
			
		}
		
		private function resetNodes(total:int):void
		{
			var sprite:BitmapSprite
			var i:int, l:int
			var tList:Array = []
			var point:Point
				
			l = nodes.length
			while(i < l)
			{
				sprite = nodes[i++]
				tList.push(new Point(sprite.x, sprite.y))
				sprite.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag)
				sprite.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRemove)
				sprite.dispose()
			}
			nodes.length = 0
				
			i = 0
			while(i < total)
			{
				point = tList[i++]
				this.addNode(point.x, point.y)
			}
			
			createBezierPointsObject();
			updatePath();
		}
		
		
		private function removeAllMotionObjects():void
		{
			var l:int = numMotions
			var sprite:BitmapSprite
			
			while(--l > -1)
			{
				sprite = motionObjects[l]
				sprite.dispose()
			}
			numMotions = motionObjects.length = 0
			mNodeShell.alpha = 1
		}
		
		
		
		
		
		////////////////////////////////////
		////////////////////////////////////
		////////////////////////////////////
		////////////////////////////////////
		// Member
		////////////////////////////////////
		////////////////////////////////////
		////////////////////////////////////
		////////////////////////////////////
		private var playing:Boolean
		private var isRoundStarted:Boolean
		private var roundDelayID:uint
		private var maxMotions:int
			
		private var motionObjects:Vector.<BitmapSprite> = new Vector.<BitmapSprite>()
		private var numMotions:int
		private var motionObjectRef:*
		private var currNode:BitmapSprite
		private var currBackground:BitmapSprite
		private	var xA:Array=[];
		private var yA:Array=[];
		private var nodes:Array = [];
		private var bezierPoints:Array = []
		private var mBackgroundList:Array = []
		
			
		private var mRootShellA:ScrollPane
		private var mRootShape:Shape
		private var mBackgroundShell:Sprite
		private var mNodeShell:Sprite
		private var mMotionShell:Sprite
		
		
		private var mUiShell:Sprite
		
		private var stepperAlphaMin:NumericStepper, stepperAlphaMax:NumericStepper
		private var stepperAmount:NumericStepper
		private var stepperProbability:NumericStepper
		private var stepperDurationMin:NumericStepper, stepperDurationMax:NumericStepper
		private var stepperScaleMin:NumericStepper, stepperScaleMax:NumericStepper
		private var stepperRoundMin:NumericStepper, stepperRoundMax:NumericStepper
		private var stepperNextRoundMin:NumericStepper, stepperNextRoundMax:NumericStepper
		private var stepperDelayMin:NumericStepper, stepperDelayMax:NumericStepper
		
		private var textArea:TextArea
		private var easeFuction:Function
		private var isHideNodes:BooleanProperty
		private var checkBox:CheckBox
		private var maxMotionsInput:InputText, frameRateInput:InputText
		private var mouseCoordinate:TextField
		private var numMotionLabel:Label
		private var comboBox:ComboBox
		
		
		
		
		/** 更新全部 **/
		private function onUpdateAll():void
		{
			numMotionLabel.text = "motion: " + numMotions
			
			// 是否播放中
			if(!playing || !isRoundStarted)
			{
				return
			}
			
			var l:int = stepperAmount.value
			while(--l>-1)
			{
				if((maxMotions <= 0 || numMotions < maxMotions) && Math.random() < stepperProbability.value / 100)
				{
					this.playTween()
				}
			}
			
			//trace(BitmapSprite.numCached)
		}
		
		private function playTween():void
		{
			var r:Number, d:Number
			var sprite:BitmapSprite
			
			sprite = BitmapSprite.create(motionObjectRef)
			motionObjects[numMotions++] = sprite
			
			sprite.x = nodes[0].x;
			sprite.y = nodes[0].y;
			sprite.alpha = (stepperAlphaMin.value == stepperAlphaMax.value) ? 
							stepperAlphaMin.value : 
							stepperAlphaMin.value + Math.random() * (stepperAlphaMax.value - stepperAlphaMin.value)
			
			r = (stepperScaleMin.value == stepperScaleMax.value) ? 
				stepperScaleMin.value : 
				stepperScaleMin.value + Math.random() * (stepperScaleMax.value - stepperScaleMin.value)
			
			sprite.scaleX = sprite.scaleY = r
			
			r = (stepperDurationMin.value == stepperDurationMax.value) ? 
				stepperDurationMin.value : 
				stepperDurationMin.value + Math.random() * (stepperDurationMax.value - stepperDurationMin.value)
				
			d = (stepperDelayMin.value == stepperDelayMax.value) ? 
				stepperDelayMin.value : 
				stepperDelayMin.value + Math.random() * (stepperDelayMax.value - stepperDelayMin.value)
				
			TweenMax.to(sprite ,r ,{delay:d, bezierThrough:bezierPoints, ease:easeFuction, 
				onStart:function():void
				{
					mMotionShell.addChild(sprite)
				},
				onComplete:function():void
				{
					var index:int = motionObjects.indexOf(sprite)
					motionObjects[index] = motionObjects[--numMotions]
					motionObjects.pop()
					sprite.dispose()
				}})
		}
		
		private function onStageResize(e:Event):void
		{
			var stageWidth:Number = stage.stageWidth
			var stageHeight:Number = stage.stageHeight
			
			mUiShell.x = (stageWidth - 1200) + 140
				
			mRootShellA.width = stageWidth - 230
			mRootShellA.height = stageHeight - 20
		}
		
		private function onAddNode(e:ZMouseEvent):void
		{
			if(playing)
			{
				this.stop()
			}
			this.addNode(mNodeShell.mouseX, mNodeShell.mouseY)
			createBezierPointsObject();
			updatePath();
		}
		
		/** 开始拖拽 **/
		private function onStartDrag(e:MouseEvent):void
		{
			currNode = e.target as BitmapSprite
			if(playing)
			{
				this.stop()
			}
			
			currNode.startDrag(false, DRAG_RECT);
		}
		
		private function onRemove(e:MouseEvent):void
		{
			e.stopImmediatePropagation()
			this.stop()
			
			if(currNode)
			{
				currNode.stopDrag()
				currNode = null
			}
			
			if(nodes.length <= 1)
			{
				return
			}
			
			var sprite:BitmapSprite = e.target as BitmapSprite
			var index:int = nodes.indexOf(sprite)
			nodes.splice(index, 1)
			sprite.addEventListener(MouseEvent.MOUSE_DOWN, onStartDrag)
			sprite.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRemove)
			sprite.dispose()
			
			this.resetNodes(nodes.length)
		}
		
		private function onRelease(e:MouseEvent = null):void
		{
			if(currNode)
			{
				currNode.stopDrag()
				currNode = null
				createBezierPointsObject();
				updatePath();
			}
			
			if(currBackground)
			{
				currBackground.stopDrag()
				currBackground = null
			}
		}	
		
		
		private function onDragging(e:MouseEvent):void
		{
			if(playing)
			{
				return
			}
			
			if(currNode)
			{
				createBezierPointsObject();
				updatePath();
			}
		}
		
/*		private function onInvoke(e:InvokeEvent):void
		{
			if (e.arguments.length)
			{
				var url:String=e.arguments[0];
				trace("URL: " + url);
				var data:Object=FileManager.readFile(url);
				var vo:ContentVO=CloneUtil.convertObject(data, ContentVO);
				var arr:Array=url.split('/');
				arr.splice(arr.length - 2, 2);
				var assetsPath:String=arr.join('/');
				MC.i.assetsPath=assetsPath;
				MC.i.contentVO=vo;
				if (fs && fs.parent)
					removeElement(fs);
			}

		}*/
		
	}
}