package com.qiu.shu.busline.Util;

/**
 * 计算两个经纬度之间的距离
 * @author
 *
 */
public class CalulateTwoLanLon
{
    private static final double EARTH_RADIUS = 6378.137;//地球半径,单位千米
    private static double rad(double d)
    {
        return d * Math.PI / 180.0;
    }

    /**
     *
     * lat1 第一个纬度
     * lng1第一个经度
     * lat2第二个纬度
     * lng2第二个经度
     * return 两个经纬度的距离
     */
    public static double getDistance(double lat1,double lng1,double lat2,double lng2)
    {
        double radLat1 = rad(lat1);
        double radLat2 = rad(lat2);
        double a = radLat1 - radLat2;
        double b = rad(lng1) - rad(lng2);

        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
                Math.cos(radLat1)*Math.cos(radLat2)*Math.pow(Math.sin(b/2),2)));
        s = s * EARTH_RADIUS;
        //s = Math.round(s * 10000) / 10000;
        s = Math.round(s *1000);
        return s;

    }

    public static void main(String[] args)
    {
        System.out.println(CalulateTwoLanLon.getDistance(31.279685,121.287189 , 31.279648, 121.290493));
    }


}
