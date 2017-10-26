package com.shop.constant;

/**
 * Created by TW on 2017/8/26.
 */
public enum GoodsSortType {

    is_top("is_top.desc", "置顶降序"),
    priceasc("price.asc", "价格升序"),
    pricedesc("price.desc", "价格降序"),
    sales("sales.desc", "销量降序"),
    score("score.desc", "评分降序"),
    create_date("create_date.desc", "日期降序");

    GoodsSortType(String sortType, String showType) {
        this.sortType = sortType;
        this.showType = showType;
    }

    private String sortType;
    private String showType;

    public String getSortType() {
        return sortType;
    }

    public void setSortType(String sortType) {
        this.sortType = sortType;
    }

    public String getShowType() {
        return showType;
    }

    public void setShowType(String showType) {
        this.showType = showType;
    }

    public static String findShowType(String sortType) {
        for (GoodsSortType goodsSortType: GoodsSortType.values()) {
            if (goodsSortType.getSortType().equals(sortType)) {
                return goodsSortType.getShowType();
            }
        }
        return  "";
    }
}
