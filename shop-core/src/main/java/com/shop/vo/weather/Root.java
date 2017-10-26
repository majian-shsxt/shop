package com.shop.vo.weather;

import java.util.List;

/**
 * Created by TW on 2017/7/17.
 */
public class Root {
//    "error": 0,
//            "status": "success",
//            "date": "2017-07-17",
//            "results": [
//    {
//        "currentCity": "上海",
//            "pm25": "45",
//            "index": [],
//        "weather_data": []
//    }
//]

    private int error;
    private String status;
    private String date;
    private List<Results> results;

    public int getError() {
        return error;
    }

    public void setError(int error) {
        this.error = error;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public List<Results> getResults() {
        return results;
    }

    public void setResults(List<Results> results) {
        this.results = results;
    }
}
