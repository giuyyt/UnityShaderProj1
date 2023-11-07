#ifndef LINEDRAW_INCLUDED
#define LINEDRAW_INCLUDED
#include <HLSLSupport.cginc>

//https://blog.csdn.net/qw8704149/article/details/118587052
float DrawLine(fixed2 st,float k,float b,float line_width) {
    float y = k*st.x+b;
    return step(y,st.y) - step(y+line_width,st.y);
}

//https://blog.csdn.net/qw8704149/article/details/118587052
float lineSegmentWithTwoPoint (fixed2 st,fixed2 start,fixed2 end,float line_width){
    fixed2 line_vector_from_end = normalize(fixed2(start.x,start.y) - fixed2(end.x,end.y));//结束点指向起始点的向量
    fixed2 line_vector_from_start = -line_vector_from_end;//起始点指向结束点的向量
    fixed2 st_vector_from_end = st - fixed2(end.x,end.y); //结束点指向画布中任意点的向量
    fixed2 st_vector_from_start = st - fixed2(start.x,start.y);//起始点指向画布中任意点的向量

    float proj1 = dot(line_vector_from_end,st_vector_from_end);
    float proj2 = dot(line_vector_from_start,st_vector_from_start);

    if(proj1>0.0&&proj2>0.0){//通过点乘结果>0判断是否同相，过滤掉线段两头超出部分

        //求结束点指向画布中任意点的向量与结束点指向起始点的向量的夹角
        float angle = acos(dot(line_vector_from_end,st_vector_from_end)/(length(st_vector_from_end)*length(line_vector_from_end)));
        //屏幕上任意点到直线的垂直距离
        float dist = sin(angle)*length(st_vector_from_end);

        return pow(1.0-smoothstep(0.0,line_width/2.0,dist),1.0);
    } else {
        return 0.0;
    }
}






//https://blog.csdn.net/qw8704149/article/details/118587052
float DrawLineSmooth(fixed2 st,float k,float b,float line_width) {
    float y = k*st.x+b;
    return pow(smoothstep(y-line_width,y,st.y) - smoothstep(y,y+line_width,st.y),25.0);
}

//求pointIn向y=kx+b的垂线的交点
fixed2 GetLinePerpendicularPoint(fixed2 pointIn,float k,float b)
{
    fixed x0 = pointIn.x;
    fixed y0 = pointIn.y;
    
    fixed x1 = (k*y0+x0-k*b)/(1+k*k);
    fixed y1 = k*x1+b;

    return fixed2(x1,y1);
}

//求pointIn向y=kx+b的垂线的长度
fixed GetLinePerpendicularDistance(fixed2 pointIn,float k,float b)
{
    fixed2 perPoint = GetLinePerpendicularPoint(pointIn,k,b);
    return length(perPoint-pointIn);
}









#endif