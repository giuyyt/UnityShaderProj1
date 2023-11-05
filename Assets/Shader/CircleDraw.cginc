#ifndef CIRCLEDRAW_INCLUDED
#define CIRCLEDRAW_INCLUDED

#include "ColorConvertion.cginc"

fixed DrawCircle(float2 screenUV,float2 pos,float radius)
{   
    screenUV-=pos;

    return step(length(screenUV),radius);
}

fixed CircleRadius(float2 screenUV,float2 pos)
{
    return length(screenUV-pos);
}

fixed DrawRing(float2 screenUV,float2 pos,float radiusInner,float radiusOuter)
{
    fixed res=0;
    fixed dis = CircleRadius(screenUV,pos);
    if(dis<radiusOuter&&dis>radiusInner)
    {
        res = 1;
    }

    return res;
}



fixed CircleAngle(float2 screenUV,float2 pos)
{
    screenUV-=pos;
    return degrees(atan2(screenUV.y,screenUV.x))+180;
}


fixed3 CircleAngle2HSV(fixed circleAngle,fixed radiusTemp,fixed radius,fixed angleThreshold,fixed HueIn)
{
    //fixed h = HueIn;
    fixed h = HueIn;
    //fixed s = circleAngle<angleThreshold?0.8:0;
    fixed s = circleAngle<angleThreshold?lerp(1,0.4,pow(abs(circleAngle-angleThreshold/2)/(angleThreshold/2),1.2)):0;
    fixed v = circleAngle<angleThreshold?lerp(1,1,abs(circleAngle-angleThreshold/2)/(angleThreshold/2)):0;


    //lerp(0.8,1,0.5*sin(snoise(_Time.y*circleAngle*0.01))+1)
    //v = v*(radiusTemp/radius);

    return fixed3(h,s,v);

}

//RGB
fixed4 DrawHSVCircle(float2 screenUV,float2 pos,float radius,
float speed,float phase,
float period,float thickness,
float bending)
{
    float timeAngle = fmod(_Time.y*speed+phase,360.0);

    fixed radiusTemp = length(screenUV-pos);

    fixed hueTemp = fmod(CircleAngle(screenUV,pos)+timeAngle+360.0+radiusTemp*bending,360.0)/period;
    fixed hueFloor = floor(hueTemp);
    fixed hueTempDis = (hueTemp - hueFloor);

    fixed4 rgbNow = fixed4(HSV2RGB(fixed3(hueFloor*period,0.5,0.4)),1);

    if(hueTempDis*radiusTemp<thickness)
    {
        rgbNow = fixed4(0,0,0,1);
    }

    return fixed4(DrawCircle(screenUV,pos,radius)*rgbNow);
}

//RGB
fixed4 DrawHalfConstantHueCircle(float2 screenUV,float2 pos,float radius,
float speed,float phase,
float period,float thickness,
float bending,float hueIn,float angleThresholdIn)
{
    float timeAngle = fmod(_Time.y*speed+phase,360.0);

    fixed radiusTemp = length(screenUV-pos);

    fixed circleAngleTemp = fmod(CircleAngle(screenUV,pos)+timeAngle+360.0+radiusTemp*bending,360.0);
    fixed circleAngleFloor = floor(circleAngleTemp);
    fixed circleAngleTempDis = (circleAngleTemp - circleAngleFloor);

    fixed3 hsvNow = CircleAngle2HSV(circleAngleTemp,radiusTemp,radius,angleThresholdIn,hueIn);

    //bool f = abs(snoise(screenUV.xyxy*phase))<0.05;
    //if(f)
    //{
    //    hsvNow.z =  hsvNow.z*0.5;
    //}

    fixed4 rgbNow = fixed4(HSV2RGB(hsvNow),1);

    //if(circleAngleTempDis*radiusTemp<thickness)
    //{
    //    rgbNow = fixed4(0,0,0,1);
    //}

                

    return fixed4(DrawCircle(screenUV,pos,radius)*rgbNow);
}

//渐变圆
fixed DrawGradientCircle(float2 screenUV,float2 pos,float radiusInner,float radiusOuter,float power)
{   
    screenUV-=pos;

    fixed radiusNow = length(screenUV);
    fixed res;
    if(radiusNow<radiusInner)
    {
        res = 1;
    }
    else if(radiusNow>=radiusInner&&radiusNow<radiusOuter)
    {
        res = pow(lerp(0,1,(radiusOuter - radiusNow)/(radiusOuter-radiusInner)),power);
    }
    else
    {
        res = 0;
    }

    return res;
}


fixed DrawGlowCircle(float2 screenUV,float2 pos,float radiusInner,float radiusOuter,float radiusNone,float powerInner,float powerOuter)
{   
    screenUV-=pos;

    fixed radiusNow = length(screenUV);
    fixed res;
    if(radiusNow<radiusInner)
    {
        res = 0;
    }
    else if(radiusNow>=radiusInner&&radiusNow<radiusOuter)
    {
        res = pow(lerp(0,1,(radiusNow - radiusInner)/(radiusOuter-radiusInner)),powerInner);
    }
    else if(radiusNow>=radiusOuter&&radiusNow<radiusNone)
    {
        res = pow(lerp(1,0,(radiusNow - radiusOuter)/(radiusNone-radiusOuter)),powerOuter);
    }
    else
    {
        res = 0;
    }

    return res;
}




#endif