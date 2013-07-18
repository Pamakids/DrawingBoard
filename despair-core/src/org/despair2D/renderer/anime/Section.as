package org.despair2D.renderer.anime 
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;

public class Section
{
	
	ns_despair function parseAssets( assetRef:*, tx:Number, ty:Number ) : void
	{	
	}

	
	
	/**
	 * @inheritDoc
	 * 检查指针是否为空
	 * @param	pointer
	 */
	ns_despair function doesPointerNull( pointer:int ) : Boolean
	{
		return false;
	}
	
	
	/**
	 * @inheritDoc
	 * 预绘
	 * @param pointer
	 */
	protected function preDraw( pointer:int ) : void 
	{	
	}
	
	
	/**
	 * 由指针获取位图信息
	 * @param	pointer
	 */
	final ns_despair function getBitmapInfoByPointer( pointer:int ) : BitmapInfo 
	{
		var pt:int = (pointer < 0) ? ( this.m_maxLength + pointer ) : pointer;
		
		if (!m_bitmapInfoList[pt]) 
		{
			this.preDraw(pointer);
		}
		
		return m_bitmapInfoList[pt];
	}
	

	
	/**
	 * 加入动作
	 * @param	actionName
	 * @param	data
	 * @param	reversed
	 * @param	frameRate
	 */
	final internal function addAction( actionName:String, data:String, reversed:Boolean, frameRate:Number ) : void 
	{	
		if (!m_actionMap) 
		{
			m_actionMap = new Object();
		}
		
		var parsedData:Array;
		var action:Action;
		var l:int, i:int;
		var group:Vector.<int>;
		
		// 解析
		parsedData  =  this.parseActionData(data);
		l           =  parsedData.length;
		
		// 水平反相
		if (reversed)
		{
			for (i = 0; i < l; i++)
			{
				parsedData[i] = ~parsedData[i] + 1;
			}
		}
		
		// 动作组
		group = new Vector.<int>(l, true);
		while (--l > -1)
		{
			group[l] = parsedData[l];
		}
		
		action                   =  new Action(actionName, group, frameRate);
		m_actionMap[actionName]  =  action;
	}
	
	
	/**
	 * 据名字获取动作
	 * @param	actionName
	 */
	final ns_despair function getActionByName( actionName:String ) : Action
	{
		return m_actionMap[actionName];
	}
	
	
	
	/**
	 * 解析XML数据
	 * @param	data
	 */
	private function parseActionData( data:String ) : Array 
	{
		var group:Array, tmpArr:Array, list:Array;
		var len:int, i:int, tmpPointer:int;
		
		group = [];
		
		if (data.indexOf(",") != -1) 
		{
			list  =  data.split(",");
			len   =  list.length;
			
			for (i = 0; i < len; i++)
			{
				data = list[i];
				group.push.apply(group, parseActionData(data));
			}
		}
		
		else 
		{
			if (data.indexOf('-') != -1)
			{
				tmpArr     =  data.split("-");
				tmpArr[0]  =  int(tmpArr[0]);
				tmpArr[1]  =  int(tmpArr[1]);
				// 正向
				if (tmpArr[0] < tmpArr[1])
				{
					while (tmpArr[0] <= tmpArr[1]) 
					{
						group.push(tmpArr[0]);
						tmpArr[0]++;
					}
				}
				// 反向
				else
				{
					while (tmpArr[0] >= tmpArr[1]) 
					{
						group.push(tmpArr[0]);
						tmpArr[0]--;
					}
				}
			}
			
			else if (data.indexOf('*') != -1)
			{
				tmpArr      =  data.split("*");
				tmpPointer  =  tmpArr[0];
				
				for (i = 0; i < int(tmpArr[1]); i++)
				{
					group.push(tmpPointer);
				}
			}
			
			else
			{
				group.push(int(data));
			}
		}
		
		return group;
	}
	
	
	/**
	 * 获取缓存画像
	 * @param	size
	 */
	final protected function getCacheImage( size:Number ) : BitmapData
	{
		var bmd:BitmapData;
		var index:int = int(size / cachedBmdSize);
		
		if (!cachedBmdList[index])
		{
			bmd = new BitmapData((index + 1) * cachedBmdSize, (index + 1) * cachedBmdSize, true, 0x0);
			cachedBmdList[index] = bmd;
		}
		else
		{
			bmd = cachedBmdList[index];
			bmd.fillRect(bmd.rect, 0x0);
		}
		
		return bmd;
	}


	
	
	ns_despair static var cachedBmdSize:int = 30;	// 绘制缓存画像梯度尺寸
	
	ns_despair static var cachedBmdList:Array = [];
	
	ns_despair static var cachedMatrix:Matrix = new Matrix();

	ns_despair static var cachedPointZero:Point = new Point();
	
	
	ns_despair var m_bitmapInfoList:Vector.<BitmapInfo>;
	
	ns_despair var m_actionMap:Object;

	ns_despair var m_maxLength:int;   // 最大位图数(swf总帧数 * 2 + 初始空白帧 * 1)
	
	ns_despair var m_name:String;
	
	ns_despair var m_x:Number, m_y:Number, m_width:Number, m_height:Number
}
}