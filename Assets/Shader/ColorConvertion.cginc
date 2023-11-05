#ifndef COLORCONVERTION_INCLUDED
#define COLORCONVERTION_INCLUDED


//https://zhuanlan.zhihu.com/p/116426192
fixed3 HSV2RGB(fixed3 hsvIn)
{

    fixed H = hsvIn.x;
    fixed S = hsvIn.y;
    fixed V = hsvIn.z;

    fixed C = S;
    fixed H_ = H / 60;
    fixed X = C * (1 - abs(fmod(H_, 2) - 1));

    fixed R = V - C;
    fixed G = V - C;
    fixed B = V - C;

    if (H_ >= 0 && H_ < 1)
    {
        R += C;
        G += X;
    }
    else if (H_ >= 1 && H_ < 2)
    {
        R += X;
        G += C;
    }
    else if (H_ >= 2 && H_ < 3)
    {
        G += C;
        B += X;
    }
    else if (H_ >= 3 && H_ < 4)
    {
        G += X;
        B += C;
    }
    else if (H_ >= 4 && H_ < 5)
    {
        R += X;
        B += C;
    }
    else if (H_ >= 5 && H_ < 6)
    {
        R += C;
        B += X;
    }

    return fixed3(R,G,B);


}


float4 CMYKtoRGB(float4 cmyk) 
{
    float4 rgb;
    rgb.r = 1.0 - min(1.0, cmyk.r + cmyk.w);
    rgb.g = 1.0 - min(1.0, cmyk.g + cmyk.w);
    rgb.b = 1.0 - min(1.0, cmyk.b + cmyk.w);
    rgb.a = 1.0; // 设置透明度为1（不透明）
    return rgb;
}

#endif