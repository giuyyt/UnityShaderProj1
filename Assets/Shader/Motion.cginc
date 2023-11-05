#ifndef MOTION_INCLUDED
#define MOTION_INCLUDED

fixed2 CircularMotion(fixed2 pos,fixed radius,fixed speed,fixed timeNow,fixed phase)
{
	fixed2 res;
	res.x = pos.x+radius*sin(speed*timeNow+6.28+phase);
	res.y = pos.y+radius*cos(speed*timeNow+6.28+phase);
	return res;
}

fixed2 LinearMotion(fixed2 start,fixed2 end,fixed speed,fixed timeNow,fixed phase)
{
	fixed2 res;
	res.x = lerp(start.x,end.x,0.5*sin(speed*timeNow+6.28+phase)+0.5);
	res.y = lerp(start.y,end.y,0.5*sin(speed*timeNow+6.28+phase)+0.5);
	return res;
}



#endif