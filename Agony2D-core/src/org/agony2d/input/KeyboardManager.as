package org.agony2d.input
{
	import flash.events.KeyboardEvent;
	import org.agony2d.notify.Notifier;
	
	import org.agony2d.core.IProcess;
	import org.agony2d.core.ProcessManager;
	import org.agony2d.debug.Logger;
	
	import org.agony2d.core.agony_internal;
	use namespace agony_internal;
	
	/** 键盘管理器 @singleton
	 *  [◆◆]
	 *		1. initialize(必须最先使用，进行初期化 !! )
	 * 		2. isKeyPressed
	 * 		3. justPressed
	 * 		4. justReleased
	 * 		5. any
	 * 		6. reset
	 * 
	 * 		7. getState
	 * 		8. addState
	 * 		9. removeState
	 *     10. removeAllStates
	 */
final public class KeyboardManager implements IProcess
{
	
	private static var m_instance:KeyboardManager
	public static function getInstance() : KeyboardManager
	{
		return m_instance ||= new KeyboardManager()
	}
	
	/** ◆◆初期化
	 *  @param	notAllKeys
	 */
	final public function initialize( notAllKeys:Boolean = true ) : void
	{
		if (!ProcessManager.m_stage)
		{
			Logger.reportError('KeyboardManager', 'constructor', '主引擎(Agony)未启动 !!');
			return
		}
		
		//trace('======================= [ Agony2D - keyboard ] ======================');
		Logger.reportMessage(this, "初期化完毕(notAllKeys: " + notAllKeys + ")...", 1);
		
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
		_addKey("ESC",27);
		_addKey("MINUS",189);
		_addKey("PLUS", 187);
		_addKey("PAGEUP", 33);
		_addKey("PAGEDOWN", 34);
		_addKey("HOME", 36);
		_addKey("END", 35);
		_addKey("INSERT", 45);
		_addKey("DELETE", 46)
			
		//SPECIAL KEYS + PUNCTUATION(标点)
		if (!notAllKeys)
		{
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
			
			_addKey("LBRACKET",219);
			_addKey("RBRACKET",221);
			_addKey("BACKSLASH",220);
			_addKey("CAPSLOCK",20);
			_addKey("SEMICOLON",186);
			_addKey("QUOTE",222);
			
			_addKey("COMMA",188);
			_addKey("PERIOD",190);
			_addKey("SLASH", 191);
		}
		this._initializeEvents()
	}
	
	/** ◆◆是否按下某键
	 *  @param	key
	 *  @return
	 */
	final public function isKeyPressed( key:String ) : Boolean
	{
		return Boolean(m_keyList[m_lookup[key]].state & k_press);
	}
	
	/** ◆◆是否刚按下某键
	 *  @param	key
	 *  @return
	 */
	final public function justPressed( key:String ) : Boolean 
	{ 
		return Boolean(m_keyList[m_lookup[key]].state & k_justPressB);
	}
	
	/** ◆◆是否刚弹起某键
	 *  @param	key
	 *  @return
	 */
	final public function justReleased( key:String ) : Boolean 
	{ 
		return Boolean(m_keyList[m_lookup[key]].state & k_justReleaseB);
	}
	
	/** ◆◆是否按着任何键
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
	
	/** ◆◆重置按键状态
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
	
	/** ◆◆获取状态
	 */
	final public function getState() : IKeyboardState
	{
		return m_head
	}
	
	/** ◆◆加入状态
	 */
	final public function addState() : IKeyboardState
	{	
		var KS:KeyboardState
		
		m_numStates++
		KS = new KeyboardState();
		KS.m_next = m_head
		m_head = m_head.m_prev = KS
		return KS
	}
	
	/** ◆◆削除状态
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
			Logger.reportWarning(this, 'removeState', '未加入其他状态.')
		}
	}
	
	/** ◆◆削除全部状态
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
		var K:KeyProp
		
		while (i < m_dirtyLength) 
		{
			K = m_dirtyList[i++];
			state = K.state;
			
			if (Boolean(state & k_justPressA))
			{
				K.state &= ~k_justPressA;
				K.state |= k_justPressB;
				
				if (m_head.m_pressNotifier)
				{
					m_head.m_pressNotifier.dispatchDirectEvent(K.name);
				}
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
				
				if (m_head.m_releaseNotifier)
				{
					m_head.m_releaseNotifier.dispatchDirectEvent(K.name);
				}
				//trace(K.name + ' >>>> release');
			}
			
			else if (Boolean(state & k_justReleaseB))
			{
				K.state &= ~k_justReleaseB;
			}
			
			if (Boolean(K.state & k_press))
			{
				if (m_head.m_straightNotifier)
				{
					m_head.m_straightNotifier.dispatchDirectEvent(K.name);
				}
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
	
	private function _addKey( keyName:String, keyCode:uint ) : void
	{
		m_lookup[keyName]   =  keyCode;
		m_keyList[keyCode]  =  new KeyProp(keyName);
	}
	
	private function _initializeEvents() : void
	{
		m_head = new KeyboardState();
		ProcessManager.m_stage.addEventListener(KeyboardEvent.KEY_DOWN, ____onKeyDown);
		ProcessManager.m_stage.addEventListener(KeyboardEvent.KEY_UP,   ____onKeyUp);
		ProcessManager.addFrameProcess(this, ProcessManager.KEYBOARD);
	}
	
	// 一些特殊情况下，某些键可能会连续产生press或release.
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
	
	private const k_justReleaseA:uint  =  0x01;
	private const k_justReleaseB:uint  =  0x02;
	private const k_press:uint         =  0x10;
	private const k_justPressA:uint    =  0x20;
	private const k_justPressB:uint    =  0x40;
	private const k_dirtyKey:uint      =  0x80;
	
	private var m_lookup:Object = { };  // keyName : keyCode
	private var m_keyList:Vector.<KeyProp>;
	private var m_dirtyList:Array = [];
	private var m_dirtyLength:int
	private var m_head:KeyboardState
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
import org.agony2d.notify.INotifier;
import org.agony2d.notify.Notifier;
import org.agony2d.input.IKeyboardState;
import org.agony2d.debug.Logger;

import org.agony2d.core.agony_internal;
use namespace agony_internal;

final class KeyboardState implements IKeyboardState
{
	
	final public function get press() : INotifier { return m_pressNotifier ||= new Notifier }
	final public function get straight() : INotifier { return m_straightNotifier ||= new Notifier }
	final public function get release() : INotifier { return m_releaseNotifier ||= new Notifier }
	
	final internal function dispose() : void
	{
		if (m_pressNotifier)
		{
			m_pressNotifier.dispose()
		}
		if (m_straightNotifier)
		{
			m_straightNotifier.dispose()
		}
		if (m_releaseNotifier)
		{
			m_releaseNotifier.dispose()
		}
	}
	
	internal var m_pressNotifier:Notifier
	internal var m_straightNotifier:Notifier
	internal var m_releaseNotifier:Notifier
	internal var m_prev:KeyboardState
	internal var m_next:KeyboardState
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