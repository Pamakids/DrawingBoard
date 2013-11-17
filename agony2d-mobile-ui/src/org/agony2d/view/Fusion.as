package org.agony2d.view {
	import org.agony2d.core.agony_internal;
	import org.agony2d.debug.Logger;
	import org.agony2d.view.core.AgonySprite;
	import org.agony2d.view.core.Component;
	import org.agony2d.view.core.ComponentProxy;
	import org.agony2d.view.core.FusionComp;
	import org.agony2d.view.core.IComponent;
	import org.agony2d.view.core.PivotSprite;
	import org.agony2d.view.core.SmoothProxy;
	import org.agony2d.view.enum.LayoutType;
	
	use namespace agony_internal;
	
	/** [ Fusion ]
	 *  [◆]
	 * 		1.  numElement
	 *  	2.  position
	 *  	3.  paddingLeft × paddingRight × paddingTop × paddingBottom
	 *  [◆◆]
	 *  	1.  addElement
	 *		2.  addElementAt
	 * 		3.  setElementLayer
	 * 		4.  getElementByLayer
	 * 		5.  removeAllElement
	 *  [★]
	 *  	a.  Fusion应该继承自[ AbstractFusion ]，以区别与[ List ]之间的矛盾关系...!!
												Top
		   ------------------------------------------------------------------↓-------
		   |                                                    paddingTop ← ↓	    |
		   |                                                                 ↓      |
		   |                                 A__B                   (origin) ● ← ← ←|
		   |          --------------------------------                       ↑		|
		   |     A__B | BA                    BA     |                 paddingRight |
		   |          | 　　　                       |                              |
		   |          |                          AB  | B__A                  |      |    
		   |          |        AB    				 |                       |      |
	  Left |          ---↓---------------------------- ← ← ← ← ← ← gapX ← ← ←|		| Right
		   |           → ■    B__A   				 ↑                       |      |
		   |                                         ↑                       |      |
		   |                                         ↑                              | 
		   | paddingLeft                            gapY                			|
		   |    ↓                                  	 ↑               		   		|
		   |→ → → ● (origin)                     ---------                  		|
		   |      ↑                                  ↑                     			|
		   |      ↑ → paddingBottom                  ↑           					|
		   -------↑------------------------------------------------------------------
												Bottom                               
		
		[ add sub element × add other view ]... -> [ layout ]... -> [ set pivot ]...
		A : 要加入的元素
		B : 内部的相对元素
		F : 容器本身
	 */
public class Fusion extends SmoothProxy {
	
	public function Fusion() {
		m_view = FusionComp.getFusionComp(this)
		paddingLeft = paddingRight = paddingTop = paddingBottom = 0
	}
	
	// 元素数目
	public function get numElement() : int { 
		return m_numElement 
	}
	
	// 元素列表
	public function get elementList() : Array {
		return m_elementList
	}
	
	// 上一元素的索引位置，有时加入新元素时会有用
	public function get position() : int {
		return m_bb ? m_elementList.indexOf(m_bb) : null
	}
	
	public function set position( v:int ) : void {
		m_bb = m_elementList[v]
	}
	
	// 内部布局边距
	public var paddingLeft:Number, paddingRight:Number, paddingTop:Number, paddingBottom:Number
	
	/** 加入元素
	 *  @param	c
	 *  @param	gapX
	 *  @param	gapY
	 *  @param	horizLayout
	 *  @param	vertiLayout
	 */
	public function addElement( c:IComponent, gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void {
		var cc:ComponentProxy
		
		cc = c as ComponentProxy
		this.doValidate(cc)
		this.layoutElement(cc, gapX, gapY, horizLayout, vertiLayout)
		this.doRender(cc, -1)
	}
	
	/** 插入元素
	 *  @param	c
	 *  @param	layer
	 *  @param	gapX
	 *  @param	gapY
	 *  @param	horizLayout
	 *  @param	vertiLayout
	 */
	public function addElementAt( c:IComponent, layer:int = -1, gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void {
		var cc:ComponentProxy
		
		cc = c as ComponentProxy
		this.doValidate(cc)
		this.layoutElement(cc, gapX, gapY, horizLayout, vertiLayout)
		this.doRender(cc, layer)
	}
	
	/** 设定元素图层（索引）
	 *  @param	c
	 *  @param	layer
	 */
	public function setElementLayer( c:IComponent, layer:int ) : void {
		m_view.setChildIndex((c as ComponentProxy).shell, layer)
	}
	
	/** 由图层（索引）获取元素
	 *  @param	layer
	 *  @return
	 */
	public function getElementByLayer( layer:int ) : IComponent {
		var obj:AgonySprite
		
		obj = m_view.getChildAt(layer) as AgonySprite
		return (obj is PivotSprite) ? (obj.getChildAt(0) as Component).m_proxy as IComponent : (obj as Component).m_proxy as IComponent
	}
	
	/** 削除全部元素
	 */
	public function removeAllElement() : void {
		var l:int
		
		m_view.removeChildren()
		l = m_numElement
		while (--l > -1) {
			m_elementList[l].dispose()
		}
		m_elementList.length = m_numElement = 0
	}
	
	/** 重新为元素布局
	 *  @param	aa
	 *  @param	gapX
	 *  @param	gapY
	 *  @param	horizLayout
	 *  @param	vertiLayout
	 */
	public function layoutElement( aa:ComponentProxy, gapX:Number = NaN, gapY:Number = NaN, horizLayout:int = 1, vertiLayout:int = 1 ) : void {
		var shellA:AgonySprite
		var AX:Number, AY:Number
		
		if (!isNaN(gapX)) {
			switch(horizLayout) {
				case LayoutType.FA__F:
					AX = paddingLeft + gapX
					break
					
				case LayoutType.F__AF:
					AX = this.spaceWidth - aa.spaceWidth - paddingRight + gapX
					break
					
				case LayoutType.F__A__F_ALIGN:
					AX = paddingLeft + (this.spaceWidth - paddingLeft - paddingRight - aa.spaceWidth) / 2 + gapX
					break
				
				case LayoutType.A_F_F:
					AX = paddingLeft + gapX - aa.spaceWidth
					break
				
				case LayoutType.F_F_A:
					AX = this.spaceWidth - paddingRight + gapX
					break
					
				case LayoutType.A__B:
					if(m_bb) {
						AX = m_bb.x - aa.spaceWidth + gapX
					}
					else {
						AX = this.spaceWidth - aa.spaceWidth - paddingRight + gapX
					}
					break
					
				case LayoutType.AB:
					if(m_bb) {
						AX = m_bb.x + gapX
					}
					else {
						AX = this.spaceWidth - aa.spaceWidth - paddingRight + gapX
					}
					break
					
				case LayoutType.BA:
					if(m_bb) {
						AX = m_bb.x + m_bb.spaceWidth - aa.spaceWidth + gapX
					}
					else {
						AX = paddingLeft + gapX
					}
					break
				
				case LayoutType.B__A:
					if(m_bb) {
						AX = m_bb.x + m_bb.spaceWidth + gapX
					}
					else {
						AX = paddingLeft + gapX
					}
					break
					
				case LayoutType.B__A__B_ALIGN:
					if(m_bb) {
						AX = m_bb.x + (m_bb.spaceWidth - aa.spaceWidth) / 2 + gapX
					}
					else {
						AX = paddingLeft + gapX
					}
					break
					
				default:
					Logger.reportError(this, "layoutElement", "horiz layout error : [ " + horizLayout + " ]...!!")
			}
		}
		else if(paddingLeft != 0){
			AX = aa.x + paddingLeft
		}
		if (!isNaN(gapY)) {
			switch(vertiLayout) {
				case LayoutType.FA__F:
					AY = paddingTop + gapY
					break
					
				case LayoutType.F__AF:
					AY = this.spaceHeight - aa.spaceHeight - paddingBottom + gapY
					break
					
				case LayoutType.F__A__F_ALIGN:
					AY = paddingTop + (this.spaceHeight - paddingTop - paddingBottom - aa.spaceHeight) / 2 + gapY
					break
				
				case LayoutType.A_F_F:
					AY = paddingTop + gapY - aa.spaceHeight
					break
				
				case LayoutType.F_F_A:
					AY = this.spaceHeight - paddingBottom + gapY
					break
				
				case LayoutType.A__B:
					if(m_bb) {
						AY = m_bb.y - aa.spaceHeight + gapY
					}
					else {
						AY = this.spaceHeight - aa.spaceHeight - paddingBottom + gapY
					}
					break
					
				case LayoutType.AB:
					if(m_bb) {
						AY = m_bb.y + gapY
					}
					else {
						AY = this.spaceHeight - aa.spaceHeight - paddingBottom + gapY
					}
					break
					
				case LayoutType.BA:
					if(m_bb) {
						AY = m_bb.y + m_bb.spaceHeight - aa.spaceHeight + gapY
					}
					else {
						AY = paddingTop + gapY
					}
					break
				
				case LayoutType.B__A:
					if(m_bb) {
						AY = m_bb.y + m_bb.spaceHeight + gapY
					}
					else {
						AY = paddingTop + gapY
					}
					break
					
				case LayoutType.B__A__B_ALIGN:
					if(m_bb) {
						AY = m_bb.y + (m_bb.spaceHeight - aa.spaceHeight) / 2 + gapY
					}
					else {
						AY = paddingTop + gapY
					}
					break
					
				default:
					Logger.reportError(this, "layoutElement", "verti layout error : [ " + vertiLayout + " ]...!!")
			}
		}
		else if(paddingTop != 0){
			AY = aa.y + paddingTop
		}
		shellA = aa.shell
		if (!isNaN(AX)) {
			shellA.x = AX * m_pixelRatio
		}
		if (!isNaN(AY)) {
			shellA.y = AY * m_pixelRatio
		}
		m_bb = aa
	}
	
	agony_internal function removeElement( c:IComponent ) : void {
		var index:int
		
		index                 =  m_elementList.indexOf(c)
		m_elementList[index]  =  m_elementList[--m_numElement]
		m_elementList.pop()
	}
	
	override agony_internal function dispose() : void {
		this.removeAllElement()
		super.dispose()
	}
	
	final override agony_internal function get view() : Component { 
		return m_view 
	}
	
	override agony_internal function get shell() : AgonySprite { 
		return m_view
	}
	
	override agony_internal function makeTransform( smoothing:Boolean, external:Boolean ) : void {
		var l:int
		var elementList:Array
		
		if (external) {
			m_externalTransform = smoothing
		}
		else {
			m_internalTransform = smoothing
		}
		l = m_numElement
		if (!m_externalTransform && !m_internalTransform) {
			while (--l > -1) {
				m_elementList[l].makeTransform(false, true)
			}
		}
		else {
			while (--l > -1) {
				m_elementList[l].makeTransform(true, true);
			}
		}
	}
	
	agony_internal function doValidate( cc:ComponentProxy ) : void {
		if (cc == this) {
			Logger.reportError(this, "addElementAt", "a comp cann't insert to self...!!")
		}
		if(cc.m_parent) {
			Logger.reportError(this, "addElementAt", "a comp has added to fusion...!!")
		}
		cc.m_parent = m_view
		m_elementList[m_numElement++] = cc
		if (m_externalTransform || m_internalTransform) {
			cc.makeTransform(true, true)
		}
	}
	
	agony_internal function doRender( cc:ComponentProxy, index:int ) : void {
		if (index == -1) {
			m_view.addChild(cc.shell)
		}
		else {
			m_view.addChildAt(cc.shell, index >= 0 ? index : m_view.numChildren + index + 1)
		}	
	}
	
	agony_internal var m_view:FusionComp
	agony_internal var m_bb:ComponentProxy
	agony_internal var m_elementList:Array = []
	agony_internal var m_numElement:int
}
}