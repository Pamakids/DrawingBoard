package demos 
{
	import org.agony2d.utils.LangUtil;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	
public class LangDemo extends Sprite 
{
	
	public function LangDemo() 
	{
		LangUtil.initialize(dataXML);
		LangUtil.toString()
		
		var lang:file = new file();
		trace(lang.downRoomResource)
		trace(lang.connectingServer)
		trace(lang.loginRoom)
		trace(lang.getResoures)
	}
	
	
	private var dataXML:XML = 
	<data>
	
		<accessor name = "downRoomResource" value = "正在下载资源，请稍等片刻，稍后更精彩，当前进度："/>
		<accessor name = "connectingServer" value = "正在连接服务器"/>
		<accessor name = "loginRoom" value = "正在登陆到房间"/>
		<accessor name = "getResoures" value = "正在获取资源列表"/>
		
		
		<method name = "startLogin">
			<parameter>登陆1</parameter>
			<parameter>登陆2</parameter>
			<parameter>登陆3</parameter>
		</method>
		
		<method name = "startExit">
			<parameter>退出1</parameter>
			<parameter>退出2</parameter>
			<parameter>退出3</parameter>
		</method>
		
		
		<repeated name = "getHand">
			<element>同花顺</element>
			<element>三条</element>
			<element>铁支</element>
			<element>高牌</element>
		</repeated>
		
		<repeated name = "getJob">
			<element>剑士</element>
			<element>弓箭手</element>
			<element>法师</element>
		</repeated>
		
	</data>
	
}

}


import org.agony2d.utils.LangUtil;



class file
{
	
	public function get downRoomResource():String 		{ return  LangUtil.getAccessorTxt('downRoomResource'); }
	public function get connectingServer():String		{ return  LangUtil.getAccessorTxt('connectingServer'); }
	public function get loginRoom():String				{ return LangUtil.getAccessorTxt('loginRoom'); }
	public function get getResoures():String			{ return LangUtil.getAccessorTxt('getResoures'); }
	
	
}