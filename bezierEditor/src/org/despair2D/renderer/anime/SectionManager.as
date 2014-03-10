/*	
    片段XML使用说明 : 
			
			Section :
					0. type          -  类型
					1. clazz         -  资源类定义
					2. x             -  X轴偏移量    （左上角为起点，实体为中心）
					3. y             -  Y轴偏移量    （左上角为起点，实体为中心）
					4. real          -  碰撞矩形      ＃ 非必要

				Action :
					1. name          -  动作名称
					2. reversed      -  翻转（左右）  ＃ 非必要
					3. frameRate     -  fps           ＃ 非必要
					
			<section type="SWF">
					<clazz>     colonist_32_32               </clazz>
					<x>         -16                              </x>
					<y>         -15.5                            </y>
					<real       x="11" y="2" width="10" height="29"/>

					<action     name="right_stand"                                  >   1      </action>
					<action     name="right_jump"                     frameRate="7" >   2-3    </action>
					<action     name="right_run"                      frameRate="10">   4-9    </action>
					<action     name="left_stand"   reversed="true"                 >   1      </action>
					<action     name="left_jump"    reversed="true"   frameRate="7" >   2-3    </action>
					<action     name="left_run"     reversed="true"   frameRate="10">   4-9    </action>
			</section>
 */
package org.despair2D.renderer.anime 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import org.despair2D.utils.getClassName;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	
public class SectionManager 
{
	
	
	/**
	 * 注册片段数据
	 * @param	sectionXmlConfig
	 */
	ns_despair static function registerSections( sectionXmlConfig:XML ) : void 
	{
		var name:String, type:String, clazz:String, actionName:String, actionData:String;
		var x:Number, y:Number, width:Number, height:Number;
		var reversed:Boolean;
		var section:Section;
		var node:XML;
		var numSection:int, lenA:int, frameRate:Number;
		
		trace('\n------------------------- [ Section ] -------------------------');
		
		numSection = sectionXmlConfig.section.length();
		while (--numSection > -1)
		{
			node   =  sectionXmlConfig.section[numSection];
			type   =  node.@type;
			clazz  =  node.clazz;
			x      =  node.x;
			y      =  node.y;
			
			if (clazz == null || clazz == '')
			{
				Logger.reportError('SectionManager', 'registerSections', "Section don't have a null clazz !!")
			}
			
			switch(type)
			{
				case "IMG":
					//section = new ImageSection(clazz, x, y, node.width, node.height)
					break
					
				case "SWF":
					section = new MovieClipSection()
					break
					
				default:
					Logger.reportError('SectionManager', 'registerSections', '片段类型 (' + type + ') 错误 !!');
			}
			
			section.parseAssets(clazz, x, y)
			lenA = node.action.length();
			while (--lenA > -1)
			{
				actionName  =  node.action[lenA].@name
				actionData  =  node.action[lenA]
				reversed    =  Boolean(node.action[lenA].@reversed == 'true')
				frameRate   =  Number(node.action[lenA].@frameRate)
				
				section.addAction(actionName, actionData, reversed, frameRate)
			}
			
			doAddSection(clazz, section);
		}
	}
	
	
	/**
	 * 由SWF获取片段(没有则生成，对齐中心点)
	 * @param	classRef	类 / 类名称
	 * @return	片段名称
	 */
	ns_despair static function getSectionBySWF( classRef:* ) : Section
	{
		var clazz:String
		var def:Class
		var SWF:MovieClip
		var section:Section
		
		if (classRef is Class)
		{
			clazz = getClassName(classRef)
			if (m_sectionMap[clazz])
			{
				return m_sectionMap[clazz]
			}
			SWF = new classRef()
		}
		
		else if(classRef is String)
		{
			clazz = classRef
			if (m_sectionMap[clazz])
			{
				return m_sectionMap[clazz]
			}
			def = getDefinitionByName(clazz) as Class
			
			if (!def)
			{
				Logger.reportError('SectionManager', 'getSectionBySWF', '不存在的类型: (' + clazz + ').')
			}
			
			try
			{
				SWF = new def()
			}
			
			catch (error:Error)
			{
				Logger.reportError('SectionManager', 'getSectionBySWF', '变量类型错误: (' + clazz + ').')
			}
		}
		
		section = new MovieClipSection()
		section.parseAssets(SWF, 0, 0)
		doAddSection(clazz, section)
		
		return section
	}
	
	
	/**
	 * 获取片段
	 * @param	clazz
	 */
	ns_despair static function getSection( clazz:String ) : Section 
	{
		var section:Section = m_sectionMap[clazz]
		if (!section)
		{
			Logger.reportError('SectionManager', 'getSection', '片段: (' + clazz + ')不存在...')
		}
		
		return section
	}
	
	
	/**
	 * 加入片段到列表
	 * @param	name
	 * @param	section
	 */
	private static function doAddSection( clazz:String, section:Section ) : void
	{
		if(m_sectionMap[clazz])
		{
			Logger.reportWarning('SectionManager', 'doAddSection', '片段: (' + clazz + ') 被同名覆盖 !!')
			return
		}
		
		Logger.reportMessage('SectionManager', '片段: (' + clazz + ') 注册完成.');
		m_sectionMap[clazz] = section;
		m_numSection++;
	}
	
	
	
	ns_despair static var m_sectionMap:Object = new Object();
	
	ns_despair static var m_numSection:int;

}

}