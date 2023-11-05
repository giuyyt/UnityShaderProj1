#ifndef COLOR_INCLUDED
#define COLOR_INCLUDED
#include <HLSLSupport.cginc>//多平台时起作用


// cosine based palette, 4 vec3 params
//https://iquilezles.org/articles/palettes/
fixed3 Palette( fixed t, fixed3 a, fixed3 b, fixed3 c, fixed3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}

#endif