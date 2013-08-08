package org.agony2d.renderer.anime 
{

final public class Action 
{
	
	public function Action( name:String, group:Vector.<int>, frameRate:Number = 0 )
	{
		this.name   =  name
		this.group  =  group
		
		// 多帧
		if (this.group.length > 1 ) 
		{
			if (frameRate <= 0)
			{
				throw new Error('Action［'+this.name+'］ - 非单帧动作，frameRate不可小于0');
			}
			
			delay = 1000.0 / frameRate;
		}
		
		// 单帧
		else
		{
			delay = 0;
		}
	}
	
	
    public var group:Vector.<int>;
	
    public var name:String;

    public var delay:Number;
}
}