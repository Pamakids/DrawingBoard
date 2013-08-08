package org.agony2d.utils 
{
	
    public function getNextPowerOfTwo( v:int ) : int
    {
        if (v > 0 && (v & (v - 1)) == 0)
        {
			return v
		}
        else
        {
            var result:int = 1;
            while (result < v) result <<= 1;
            return result;
        }
    }
}