package org.despair2D.control
{
	import flash.events.KeyboardEvent;
	
	import org.despair2D.core.IFrameListener;
	import org.despair2D.core.ProcessManager;
	import org.despair2D.debug.Logger;
	
	import org.despair2D.core.ns_despair;
	use namespace ns_despair;
	
	/**
	 * @singleton
	 * @usage
	 * 
	 * [method]
	 *			1. ◆initialize (最初使用)
	 * 			2. ◆isKeyPressed
	 * 			3. ◆justPressed
	 * 			4. ◆justReleased
	 * 			5. ◆any
	 * 			6. ◆reset
	 * 
	 * 			7. ◆addState
	 * 			8. ◆getState
	 * 			9. ◆removeState
	 * 		   10. ◆removeAllStates
	 * 
	 * @tips
	 * 		必须最先使用initialize方法进行初期化 !! 
	 */
final public class KeyboardManager implements IFrameListener
{
	
	private const k_justReleaseA:uint  =  0x01;
	
	private const k_justReleaseB:uint  =  0x02;
	
	private const k_press:uint         =  0x10;
	
	private const k_justPressA:uint    =  0x20;
	
	private const k_justPressB:uint    =  0x40;
	
	private const k_dirtyKey:uint      =  0x80;
	
	
	private static var m_instance:KeyboardManager
	public static function getInstance() : KeyboardManager
	{
		return m_instance ||= new KeyboardManager()
	}
	
	
	/**
	 * 初期化
	 * @usage	可不同的情况，选择键侦听范围，合理控制内存占用.（待续...）
	 */
	final public function initialize() : void
	{
		if (!ProcessManager.m_stage)
		{
			Logger.reportError('KeyboardManager', 'constructor', '主引擎(Despair)未启动 !!');
			return
		}
		
		trace('======================= [ Despair2D - keyboard ] ======================');
		Logger.reportMessage('ProcessManager', "★键盘管理器初期化完毕(type: " + 0 + ")...\n");
		
		this._addAllKeys();
		this._initializeEvents()
	}
	
	/**
	 * 是否按下某键
	 * @param	key
	 * @return
	 */
	final public function isKeyPressed( key:String ) : Boolean
	{
		return Boolean(m_keyList[m_lookup[key]].state & k_press);
	}
	
	/**
	 * 是否刚按下某键
	 * @param	key
	 * @return
	 */
	final public function justPressed( key:String ) : Boolean 
	{ 
		return Boolean(m_keyList[m_lookup[key]].state & k_justPressB);
	}
	
	/**
	 * 是否刚弹起某键
	 * @param	key
	 * @return
	 */
	final public function justReleased( key:String ) : Boolean 
	{ 
		return Boolean(m_keyList[m_lookup[key]].state & k_justReleaseB);
	}
	
	/**
	 * 是否按着任何键
	 * @return
	 */
	final public function any() : Boolean
	{
		var i:int = 0;
		
		while (i < m_dirtyLength) 
		{
			if (Boolean(m_dirtyList[i++].state & k_press))
			{
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 重置按键状态
	 */
	final public function reset() : void
	{
		var K:KeyProp, i:int = 0;
		
		while (i < m_keyTotal) 
		{
			K = m_keyList[i++];
			if (!K) 
			{
				continue;
			}
			K.state = 0;
		}
		m_dirtyList.length = m_dirtyLength = 0;
	}
	
	/**
	 * 加入状态
	 */
	final public function addState() : IInputState
	{	
		var inputState:InputState
		
		m_numStates++
		inputState = new InputState();
		inputState.m_next = m_head
		m_head = m_head.m_prev = inputState
		
		return inputState
	}
	
	/**
	 * 获取状态
	 */
	final public function getState() : IInputState
	{
		return m_head
	}
	
	/**
	 * 削除状态
	 */
	final public function removeState() : void
	{
		if (m_head.m_next)
		{
			m_head = m_head.m_next
			m_head.m_prev.dispose()
			m_head.m_prev = null
			
			--m_numStates
		}
		
		else
		{
			Logger.reportWarning(this, 'removeState', '未添加任何状态.')
		}
	}
	
	/**
	 * 削除全部状态
	 */
	final public function removeAllStates() : void
	{
		while (m_head.m_next)
		{
			m_head = m_head.m_next
			m_head.m_prev.dispose()
			m_head.m_prev = null
		}
		
		m_numStates = 0
	}
	
	//final public function toString() : String
	//{
		//var list:Array = [];
		//var i:int;
		//
		//while (i < m_dirtyLength)
		//{
			//list[i] = m_dirtyList[i].name;
			//i++
		//}
		//return '【KeyboardManager × ' + m_dirtyLength + '】 >>>> ' + list.join(',');
	//}
	
	
	final public function update( deltaTime:Number ) : void
	{
		var state:int, index:int, i:int;
		var K:KeyProp;
		
		while (i < m_dirtyLength) 
		{
			K = m_dirtyList[i++];
			state = K.state;
			
			if (Boolean(state & k_justPressA))
			{
				K.state &= ~k_justPressA;
				K.state |= k_justPressB;
				
				// 按下
				m_head.executePress(K.name);
				
				//trace(K.name + ' >>>> press');
			}
			
			else if (Boolean(state & k_justPressB))
			{
				K.state &= ~k_justPressB;
			}
			
			if (Boolean(state & k_justReleaseA))
			{
				K.state &= ~k_justReleaseA;
				K.state |= k_justReleaseB;
				
				// 弹起
				m_head.executeRelease(K.name);
				
				//trace(K.name + ' >>>> release');
			}
			
			else if (Boolean(state & k_justReleaseB))
			{
				K.state &= ~k_justReleaseB;
			}
			
			if (Boolean(K.state & k_press))
			{
				// 连续按下
				m_head.executeStraightPress(K.name);
			}
			
			else if (Boolean(K.state == k_dirtyKey))
			{
				if (m_dirtyLength == 1)
				{
					--m_dirtyLength;
					m_dirtyList.pop();
				}
				
				else
				{
					index = m_dirtyList.indexOf(K);
					m_dirtyList[index] = m_dirtyList[--m_dirtyLength];
					m_dirtyList.pop();
					i--;
				}
				
				K.state = 0;
			}
		}
	}
	
	private function _addAllKeys() : void 
	{
		var i:uint
		
		m_keyList = new Vector.<KeyProp>(m_keyTotal, true);
		
		// A-Z
		i = 65;
		while (i <= 90) 
		{
			_addKey(String.fromCharCode(i),i++);
		}
		
		// Number
		i = 48;
		_addKey("ZERO",i++);
		_addKey("ONE",i++);
		_addKey("TWO",i++);
		_addKey("THREE",i++);
		_addKey("FOUR",i++);
		_addKey("FIVE",i++);
		_addKey("SIX",i++);
		_addKey("SEVEN",i++);
		_addKey("EIGHT",i++);
		_addKey("NINE", i++);
		
		// Number Pad
		i = 96;
		_addKey("NUMPAD_ZERO",i++);
		_addKey("NUMPAD_ONE",i++);
		_addKey("NUMPAD_TWO",i++);
		_addKey("NUMPAD_THREE",i++);
		_addKey("NUMPAD_FOUR",i++);
		_addKey("NUMPAD_FIVE",i++);
		_addKey("NUMPAD_SIX",i++);
		_addKey("NUMPAD_SEVEN",i++);
		_addKey("NUMPAD_EIGHT",i++);
		_addKey("NUMPAD_NINE",i++);
		
		// F1~F12
		i = 1;
		while (i <= 12) 
		{
			_addKey("F"+i,111+(i++));
		}
		
		// others
		_addKey("UP",38);
		_addKey("DOWN",40);
		_addKey("LEFT",37);
		_addKey("RIGHT", 39);
		
		_addKey("ENTER", 13);
		_addKey("SHIFT", 16);
		_addKey("CONTROL",17);
		_addKey("ALT", 18);
		_addKey("BACKSPACE",8);
		_addKey("SPACE", 32);
		_addKey("TAB", 9);
		_addKey("PAGEUP", 33);
		_addKey("PAGEDOWN", 34);
		//_addKey("HOME", 36);
		//_addKey("END", 35);
		//_addKey("INSERT", 45);
		_addKey("DELETE", 46)
		_addKey("ESC",27);
		_addKey("MINUS",189);
		_addKey("PLUS", 187);
		
		//SPECIAL KEYS + PUNCTUATION
		//_addKey("LBRACKET",219);
		//_addKey("RBRACKET",221);
		//_addKey("BACKSLASH",220);
		//_addKey("CAPSLOCK",20);
		//_addKey("SEMICOLON",186);
		//_addKey("QUOTE",222);
		//
		//_addKey("COMMA",188);
		//_addKey("PERIOD",190);
		//_addKey("SLASH",191);
	}
	
	/**
	 * 加入按键
	 * @param	keyName
	 * @param	keyCode
	 */
	private function _addKey( keyName:String, keyCode:uint ) : void
	{
		m_lookup[keyName]   =  keyCode;
		m_keyList[keyCode]  =  new KeyProp(keyName);
	}
	
	private function _initializeEvents() : void
	{
		m_head = new InputState();
		
		ProcessManager.m_stage.addEventListener(KeyboardEvent.KEY_DOWN, ____onKeyDown);
		ProcessManager.m_stage.addEventListener(KeyboardEvent.KEY_UP,   ____onKeyUp);
		
		ProcessManager.addFrameListener(this, ProcessManager.INPUT);
	}
	
	/**
	 * 键下
	 * 
	 * @see     有时，按键会连续产生press或release.
	 */
	private function ____onKeyDown( e:KeyboardEvent ) : void
	{
		var K:KeyProp
		
		if(e.keyCode > 255 || !m_keyList[e.keyCode])
		{
			return
		}
		
		K = m_keyList[e.keyCode]
		
		//trace('当前按键: ' + e.keyCode + ' | ' + K.name)
		
		if (!Boolean(K.state & k_dirtyKey))
		{
			m_dirtyList[m_dirtyLength++] = K;
			K.state |= k_dirtyKey;
		}
		
		// 已按下或刚弹起时，不能再按.
		if (!Boolean(K.state & ( k_press | k_justReleaseA )))
		{
			K.state |= ( k_press | k_justPressA );
		}
	}
	
	private function ____onKeyUp( e:KeyboardEvent ) : void 
	{
		var K:KeyProp
		
		if(e.keyCode > 255 || !m_keyList[e.keyCode])
		{
			return
		}
		
		K = m_keyList[e.keyCode]
		
		if (!Boolean(K.state & k_dirtyKey))
		{
			m_dirtyList[m_dirtyLength++] = K;
			K.state |= k_dirtyKey;
		}
		
		// 只有按下时，才可弹起.
		if (Boolean(K.state & k_press))
		{
			K.state &= ~k_press;
			K.state |= k_justReleaseA;
		}
	}
	
	
	private var m_lookup:Object = { };  // keyName : keyCode
	
	private var m_keyList:Vector.<KeyProp>;
	
	private var m_dirtyList:Array = [];
	
	private var m_dirtyLength:int;

	private var m_head:InputState
	
	private var m_numStates:int
	
	private const m_keyTotal:uint = 256;  // 256
	
	//public var ESC:Boolean, ENTER:Boolean, SHIFT:Boolean, CONTROL:Boolean, ALT:Boolean, SPACE:Boolean, UP:Boolean, DOWN:Boolean, LEFT:Boolean, RIGHT:Boolean;

	//public var ONE:Boolean, TWO:Boolean, THREE:Boolean, FOUR:Boolean, FIVE:Boolean, SIX:Boolean, SEVEN:Boolean, EIGHT:Boolean, NINE:Boolean, ZERO:Boolean;
	//
	//public var F1:Boolean, F2:Boolean, F3:Boolean, F4:Boolean, F5:Boolean, F6:Boolean, F7:Boolean, F8:Boolean, F9:Boolean, F10:Boolean, F11:Boolean, F12:Boolean;
	//
	//public var NUMPADONE:Boolean, NUMPADTWO:Boolean, NUMPADTHREE:Boolean, NUMPADFOUR:Boolean, NUMPADFIVE:Boolean, NUMPADSIX:Boolean, NUMPADSEVEN:Boolean, NUMPADEIGHT:Boolean, NUMPADNINE:Boolean, NUMPADZERO:Boolean;
//
	//public var PAGEUP:Boolean, PAGEDOWN:Boolean, HOME:Boolean, END:Boolean, INSERT:Boolean, MINUS:Boolean, PLUS:Boolean, DELETE:Boolean, BACKSPACE:Boolean, TAB:Boolean, CAPSLOCK:Boolean;
	
	//public var LBRACKET:Boolean;    // [
	//public var RBRACKET:Boolean;    // ]
	//public var BACKSLASH:Boolean;    // "\"
	//public var SEMICOLON:Boolean;    // ;
	//public var QUOTE:Boolean;    // ""
	//public var COMMA:Boolean;    // ,
	//public var PERIOD:Boolean;    // .
	//public var SLASH:Boolean;    // /
}
}
import org.despair2D.notify.Observer;
import org.despair2D.control.IInputState;
import org.despair2D.debug.Logger;

import org.despair2D.core.ns_despair;
use namespace ns_despair;

final class InputState implements IInputState
{
	
	final public function addPressListener( keyName:String,  listener:Function, priority:int = 0 ) : void
	{
		(m_pressListenerMap[ keyName ] ||= Observer.getObserver()).addListener(listener, priority);
	}
	
	final public function removePressListener( keyName:String, listener:Function ) : void
	{
		var lp:Observer = m_pressListenerMap[ keyName ];
		
		if (!lp)
		{
			Logger.reportWarning(this, 'reomvePressListener', '按键(' + keyName + ')未添加任何 [按下] 侦听器.')
		}
			
		else if (!lp.removeListener(listener))
		{
			delete m_pressListenerMap[ keyName ];
		}
	}
	
	final public function removeAllPressListeners( keyName:String ) : void
	{
		var lp:Observer = m_pressListenerMap[ keyName ];
		
		if (!lp)
		{
			Logger.reportWarning(this, 'reomvePressListener', '按键(' + keyName + ')未添加任何 [按下] 侦听器.')
		}
			
		else
		{
			lp.dispose();
			delete m_pressListenerMap[ keyName ];
		}
	}
	
	final public function clearAllPress() : void
	{
		var lp:Observer;
		
		for each(lp in m_pressListenerMap)
		{
			lp.dispose();
		}
		
		m_pressListenerMap = { };
	}
	
	final public function addStraightPressListener( keyName:String,  listener:Function, priority:int = 0 ) : void
	{
		(m_straightPressListener[ keyName ] ||= Observer.getObserver()).addListener(listener, priority);
	}
	
	final public function removeStraightPressListener( keyName:String, listener:Function ) : void
	{
		var lp:Observer = m_straightPressListener[ keyName ];
		
		if (!lp)
		{
			Logger.reportWarning(this, 'reomvePressListener', '按键(' + keyName + ')未添加任何 [按下] 侦听器.')
		}
			
		else if (!lp.removeListener(listener))
		{
			delete m_straightPressListener[ keyName ];
		}
	}
	
	final public function removeAllStraightPressListeners( keyName:String ) : void
	{
		var lp:Observer = m_straightPressListener[ keyName ];
		
		if (!lp)
		{
			Logger.reportWarning(this, 'reomvePressListener', '按键(' + keyName + ')未添加任何 [按下] 侦听器.')
		}
			
		else
		{
			lp.dispose();
			delete m_straightPressListener[ keyName ];
		}
	}
	
	final public function clearAllStraightPress() : void
	{
		var lp:Observer;
		
		for each(lp in m_straightPressListener)
		{
			lp.dispose();
		}
		
		m_straightPressListener = { };
	}
	
	final public function addReleaseListener( keyName:String,  listener:Function, priority:int = 0 ) : void
	{
		(m_releaseListenerMap[ keyName ] ||= Observer.getObserver()).addListener(listener, priority);
	}
	
	final public function removeReleaseListener( keyName:String, listener:Function ) : void
	{
		var lp:Observer = m_releaseListenerMap[ keyName ];
		
		if (!lp)
		{
			Logger.reportWarning(this, 'reomvePressListener', '按键(' + keyName + ')未添加任何 [弹起] 侦听器.')
		}
			
		else if (!lp.removeListener(listener))
		{
			delete m_releaseListenerMap[ keyName ];
		}
	}
	
	final public function removeAllReleaseListeners( keyName:String ) : void
	{
		var lp:Observer = m_releaseListenerMap[ keyName ];
		
		if (!lp)
		{
			Logger.reportWarning(this, 'reomvePressListener', '按键(' + keyName + ')未添加任何 [弹起] 侦听器.')
		}
			
		else
		{
			lp.dispose();
			delete m_releaseListenerMap[ keyName ];
		}
	}
	
	final public function clearAllRelease() : void
	{
		var lp:Observer;
		
		for each(lp in m_releaseListenerMap)
		{
			lp.dispose();
		}
		
		m_releaseListenerMap = { };
	}
	
	
	final internal function executePress( keyName:String ) : void
	{
		var lp:Observer = m_pressListenerMap[ keyName ];
		if (lp)
		{
			lp.execute();
		}
	}
	
	final internal function executeStraightPress( keyName:String ) : void
	{
		var lp:Observer = m_straightPressListener[ keyName ];
		if (lp)
		{
			lp.execute();
		}
	}
	
	final internal function executeRelease( keyName:String ) : void
	{
		var lp:Observer = m_releaseListenerMap[ keyName ];
		if (lp)
		{
			lp.execute();
		}
	}
	
	final internal function dispose() : void
	{
		var lp:Observer;
		
		for each(lp in m_pressListenerMap)
		{
			lp.dispose();
		}
		for each(lp in m_straightPressListener)
		{
			lp.dispose();
		}
		for each(lp in m_releaseListenerMap)
		{
			lp.dispose();
		}
		m_pressListenerMap = m_straightPressListener = m_releaseListenerMap = null
		m_prev = m_next = null
	}
	
	
	internal var m_prev:InputState
	
	internal var m_next:InputState
	
	private var m_pressListenerMap:Object = { };  // keyName : ListenerProp
	
	private var m_straightPressListener:Object = { }
	
	private var m_releaseListenerMap:Object = { };  // keyName : ListenerProp
}

final class KeyProp
{
	
	public function KeyProp( keyName:String )
	{
		this.name = keyName;
	}
	
	
	internal var name:String;
	
	internal var state:int
}