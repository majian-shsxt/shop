package com.shop.service;

import com.alibaba.fastjson.JSON;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.shop.constant.Constant;
import com.shop.dao.GoodsDao;
import com.shop.dto.GoodsDto;
import com.shop.model.*;
import com.shop.util.AssertUtil;
import com.shop.vo.GoodsVo;
import org.apache.commons.collections.FastHashMap;
import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * Created by TW on 2017/8/25.
 */
@Service
public class GoodsService {

    @Autowired
    private GoodsDao goodsDao;
    @Autowired
    private ProductCategoryService productCategoryService;

    @Autowired
    private ProductService productService;

    /**
     * 获取分类下的热销商品
     * @param productCategoryId
     * @param limit
     * @return
     */
    public List<GoodsVo> findHotProductCategoryGoods(Integer productCategoryId,
                                                     Integer limit) {
        if (limit == null) {
            limit = Constant.TEN;
        }
        List<GoodsVo> goods = null;
        if (productCategoryId != null) {
            goods = goodsDao.findCategoryHotGoods(productCategoryId, limit);
        } else {
            goods = goodsDao.findHotGoods(limit);
        }
        return goods;
    }

    /**
     * 分页查询
     * @param goodsDto
     * @return
     */
    public PageList<GoodsVo> selectForPage(GoodsDto goodsDto) {
        if (StringUtils.isBlank(goodsDto.getSort())) {
            goodsDto.setSort("create_date.desc");
        }
        PageList<GoodsVo> goodsVos = goodsDao.selectForPage(goodsDto,
                goodsDto.buildPageBounds());
        return goodsVos;
    }

    /**
     * 分页查询分类下的商品
     * @param productCategoryId
     * @param goodsDto
     * @return
     */
    public Object[] findList(Integer productCategoryId, GoodsDto goodsDto) {
        AssertUtil.intIsNotEmpty(productCategoryId, "请选择分类进行查询");
        if (StringUtils.isBlank(goodsDto.getSort())) {
            goodsDto.setSort("create_date.desc");
        }
        goodsDto.setProductCategoryId(productCategoryId);
        // 构建treePath 如果不是第一级的话 查询需要构建层级关系
        ProductCategory productCategory = productCategoryService.findById(productCategoryId);
        String treePath = "";
        if (productCategory.getGrade() == 0) { // 根级
            treePath = ","+ productCategory.getId() +","; // ,1,
        } else {
            treePath = productCategory.getTreePath() + productCategoryId + ","; // ,1,7,
        }
        goodsDto.setTreePath(treePath);
        PageList<GoodsVo> goodsVos = goodsDao.findOtherList(goodsDto, goodsDto.buildPageBounds());
        return new Object[]{productCategory, goodsVos};
    }

    /**
     * 根据ID获取详细页的数据
     * @param id
     * @return
     */
    public Map<String,Object> findById(Integer id) {

        // 基本参数验证
        AssertUtil.intIsNotEmpty(id, "请选择商品信息");
        // 获取货品的基本信息
        GoodsVo goods = goodsDao.findById(id);
        // 验证货品是否存在
        AssertUtil.notNull(goods, "该商品不存在，请重新选择");
        // 解析图片、规格项、货品参数字段
        String productImages = goods.getProductImages();
        List<ProductImage> productImageList = null;
        if(StringUtils.isNotBlank(productImages)) {
            productImageList = JSON.parseArray(productImages, ProductImage.class);
        }
        goods.setProductImages("");
        List<SpecificationItem> specificationItemList = null;
        String specificationItems = goods.getSpecificationItems();
        if(StringUtils.isNotBlank(specificationItems)) {
            specificationItemList = JSON.parseArray(specificationItems, SpecificationItem.class);
            for(SpecificationItem specificationItem : specificationItemList) {
                List<SpecificationItemEntry> specificationItemEntries = specificationItem.getEntries();
                List<SpecificationItemEntry> newSpecificationItemEntries = new ArrayList<>();
                for (SpecificationItemEntry specificationItemEntry: specificationItemEntries) {
                    if (specificationItemEntry.getIsSelected()) {
                        newSpecificationItemEntries.add(specificationItemEntry);
                    }
                }
                specificationItem.setEntries(newSpecificationItemEntries);
            }
        }
        goods.setSpecificationItems("");
        String parameterValues = goods.getParameterValues();
        List<ParameterValue> parameterValueList = null;
        if(StringUtils.isNotBlank(parameterValues)) {
            parameterValueList = JSON.parseArray(parameterValues, ParameterValue.class);
        }
        goods.setParameterValues("");
        // 获取默认的商品
        Product defaultProduct = productService.findDefaultProduct(id);

        // 获取所有的商品信息
        List<Product> products = productService.findGoodsProducts(id);

        // 获取分类信息
        ProductCategory productCategory = productCategoryService.findById(goods.getProductCategory());

        // 构建返回结果
        Map<String, Object> result = new HashMap<>();
        result.put("good", goods);
        result.put("specificationValues", specificationItemList);
        result.put("parameterValues", parameterValueList);
        result.put("productImages", productImageList);
        result.put("defaultProduct", defaultProduct);
        result.put("productCategory", productCategory);
        result.put("products", products);

        return result;

    }
}
