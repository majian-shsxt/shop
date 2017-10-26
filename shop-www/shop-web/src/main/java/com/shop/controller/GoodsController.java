package com.shop.controller;

import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.shop.base.BaseController;
import com.shop.base.ResultInfo;
import com.shop.constant.GoodsSortType;
import com.shop.dto.GoodsDto;
import com.shop.model.Product;
import com.shop.model.ProductCategory;
import com.shop.service.GoodsService;
import com.shop.vo.GoodsVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import javax.xml.transform.Result;
import java.util.List;
import java.util.Map;

/**
 * Created by TW on 2017/8/24.
 */
@RequestMapping("goods")
@Controller
@Slf4j
public class GoodsController extends BaseController {

    @Autowired
    private GoodsService goodsService;

    @RequestMapping("search")
    public String search(GoodsDto goodsDto, Model model) {
        log.info("Search Params:{}", goodsDto.toString());
        PageList<GoodsVo> goodsVos = goodsService.selectForPage(goodsDto);

        // 存入model
        setModel(model, goodsVos, goodsDto);

        return "goods/search";
    }

    @RequestMapping("list/{id}")
    public String list(@PathVariable Integer id, GoodsDto goodsDto,  Model model) {
        Object[] result = goodsService.findList(id, goodsDto);
        ProductCategory productCategory = (ProductCategory)result[0];
        model.addAttribute("productCategory", productCategory);

        // 存入model
        PageList<GoodsVo> goodsVos = (PageList<GoodsVo>)result[1];
        setModel(model, goodsVos, goodsDto);

        return "goods/list";
    }

    @RequestMapping("content/{id}.json")
    @ResponseBody
    public Map<String, Object> findByIdJSON(@PathVariable Integer id, Model model) {
        Map<String, Object> result = goodsService.findById(id);
        return result;
    }

    @RequestMapping("content/{id}")
    public String findById(@PathVariable Integer id, Model model) {
        Map<String, Object> result = goodsService.findById(id);
        model.addAllAttributes(result);
        return "goods/detail";
    }


    /**
     * 封装到model对象中
     * @param model
     * @param goodsVos
     * @param goodsDto
     */
    private void setModel(Model model, PageList<GoodsVo> goodsVos, GoodsDto goodsDto) {
        model.addAttribute("resultList", goodsVos);
        model.addAttribute("paginator", goodsVos.getPaginator());
        model.addAttribute("goodsDto", goodsDto);
        model.addAttribute("keyword", goodsDto.getKeyword());
        // 获取排序字段
        String showSortType = GoodsSortType.findShowType(goodsDto.getSort());
        model.addAttribute("selectedSort", showSortType);
        model.addAttribute("sorts", GoodsSortType.values());
    }
}
