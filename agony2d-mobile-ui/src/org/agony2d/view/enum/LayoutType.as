package org.agony2d.view.enum {

	/** A代表本体... */
public class LayoutType {
	
	public static const FA__F:int          =  0x01 /** 父合体左(上)侧 */
	
	public static const F__A__F_ALIGN:int  =  0x02 /** 父合体水平(垂直)中间 */
	
	public static const F__AF:int          =  0x04 /** 父合体右(下)侧 */
	
	
	public static const A__B:int           =  0x08 /** 处于元素左(上)侧，或父合体右(下)侧 */
	
	public static const BA:int             =  0x10 /** 对齐元素左侧(坐标相等)，或父合体左(上)侧 */
	
	public static const B__A__B_ALIGN:int  =  0x20 /** 处于元素水平(垂直)中间，或父合体左(上)侧 */
	
	public static const AB:int             =  0x40 /** 对齐元素右侧，或父合体右(下)侧 */
	
	public static const B__A:int           =  0x80 /** 处于元素右(下)侧，或父合体左(上)侧 **/
}
}