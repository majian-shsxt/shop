package com.shop.httpclient;

import com.alibaba.fastjson.JSON;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.shop.model.SpecificationItem;
import com.shop.vo.weather.Results;
import com.shop.vo.weather.Root;
import org.junit.Test;
import org.springframework.web.client.RestTemplate;

import javax.sound.midi.Soundbank;
import javax.xml.transform.Result;
import java.util.List;

public class TestFastJson {

	@Test
	public void test1() {
		String specialValues = "[{\"name\":\"颜色\",\"entries\":[{\"id\":0,\"value\":\"黑色\",\"isSelected\":false},{\"id\":1,\"value\":\"白色\",\"isSelected\":false},{\"id\":2,\"value\":\"银色\",\"isSelected\":true},{\"id\":3,\"value\":\"灰色\",\"isSelected\":true},{\"id\":4,\"value\":\"红色\",\"isSelected\":false},{\"id\":5,\"value\":\"金色\",\"isSelected\":true}]},{\"name\":\"内存容量\",\"entries\":[{\"id\":6,\"value\":\"16GB\",\"isSelected\":true},{\"id\":7,\"value\":\"32GB\",\"isSelected\":false},{\"id\":8,\"value\":\"64GB\",\"isSelected\":true},{\"id\":9,\"value\":\"128GB\",\"isSelected\":true}]}]";
		List<SpecificationItem> specificationItemList = JSON.parseArray(specialValues, SpecificationItem.class);
		System.out.println(specificationItemList.size());
	}

	@Test
	public void test2() {
		Gson gson = new Gson();
		String specialValues = "[{\"name\":\"颜色\",\"entries\":[{\"id\":0,\"value\":\"黑色\",\"isSelected\":false},{\"id\":1,\"value\":\"白色\",\"isSelected\":false},{\"id\":2,\"value\":\"银色\",\"isSelected\":true},{\"id\":3,\"value\":\"灰色\",\"isSelected\":true},{\"id\":4,\"value\":\"红色\",\"isSelected\":false},{\"id\":5,\"value\":\"金色\",\"isSelected\":true}]},{\"name\":\"内存容量\",\"entries\":[{\"id\":6,\"value\":\"16GB\",\"isSelected\":true},{\"id\":7,\"value\":\"32GB\",\"isSelected\":false},{\"id\":8,\"value\":\"64GB\",\"isSelected\":true},{\"id\":9,\"value\":\"128GB\",\"isSelected\":true}]}]";
		List<SpecificationItem> specificationItemList = (List<SpecificationItem>)gson.fromJson(specialValues, List.class);
		List<SpecificationItem> specificationItemList1 = gson.fromJson(specialValues,
				new TypeToken<List<SpecificationItem>>(){}.getType());
		System.out.println(specificationItemList1.size());
	}

	@Test
	public void test3() {
		Gson gson = new Gson();
		String specialValues = "{\"result\":{\"abc\":\"sdfsdf\",\"specificationValues\":[{\"id\":0,\"value\":\"jello0\"},{\"id\":1,\"value\":\"jello1\"},{\"id\":2,\"value\":\"jello2\"},{\"id\":3,\"value\":\"jello3\"},{\"id\":4,\"value\":\"jello4\"},{\"id\":5,\"value\":\"jello5\"},{\"id\":6,\"value\":\"jello6\"},{\"id\":7,\"value\":\"jello7\"},{\"id\":8,\"value\":\"jello8\"},{\"id\":9,\"value\":\"jello9\"}],\"bcd\":\"sdfsdf\"},\"resultCode\":1,\"resultMessage\":\"hello\"}";
		String abc = JSON.parseObject(specialValues).getJSONObject("result").getString("abc");
		System.out.println(abc);
		Integer value = JSON.parseObject(specialValues).getJSONObject("result")
					.getJSONArray("specificationValues").getJSONObject(0).getInteger("id");
		System.out.println(value);
	}

	@Test
	public void test4() {
		// 请求数据
		RestTemplate restTemplate = new RestTemplate();
		String url = "http://api.map.baidu.com/telematics/v3/weather?location=上海&output=json&ak=A4c071813db2bfabad3593e97f46c6a4";
		String resultStr = restTemplate.getForObject(url, String.class);
		Root root = JSON.parseObject(resultStr, Root.class);
//		Root root = restTemplate.getForObject(url, Root.class);
		List<Results> results = root.getResults();
		for (Results results1: results) {
			System.out.println(results1.getWeather_data());
		}
	}

}