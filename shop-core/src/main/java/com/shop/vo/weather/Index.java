package com.shop.vo.weather;

/**
 * Created by TW on 2017/7/17.
 */
public class Index {
//    {
//        "title": "穿衣",
//            "zs": "炎热",
//            "tipt": "穿衣指数",
//            "des": "天气炎热，建议着短衫、短裙、短裤、薄型T恤衫等清凉夏季服装。"
//    }
    private String title;
    private String zs;
    private String tipt;
    private String des;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getZs() {
        return zs;
    }

    public void setZs(String zs) {
        this.zs = zs;
    }

    public String getTipt() {
        return tipt;
    }

    public void setTipt(String tipt) {
        this.tipt = tipt;
    }

    public String getDes() {
        return des;
    }

    public void setDes(String des) {
        this.des = des;
    }
}
