package com.shop.service;

import com.shop.dao.ProductDao;
import com.shop.model.Product;
import com.shop.util.AssertUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by TW on 2017/8/28.
 */
@Service
public class ProductService {
    @Autowired
    private ProductDao productDao;

    /**
     * 获取默认商品
     * @param goodsId
     * @return
     */
    public Product findDefaultProduct(Integer goodsId) {
        // 基本参数验证
        AssertUtil.intIsNotEmpty(goodsId, "请选择一个商品");
        // 获取默认的商品
        Product product = productDao.findDefaultProduct(goodsId);
        return product;
    }

    public List<Product> findGoodsProducts(Integer goodsId) {
        AssertUtil.intIsNotEmpty(goodsId, "请选择一个商品");
        // 获取默认的商品
        List<Product> products = productDao.findGoodProducts(goodsId);
        return products;
    }

    /**
     * 根据ID获取商品
     * @param productId
     * @return
     */
    public Product findById(Integer productId) {
        AssertUtil.intIsNotEmpty(productId, "请选择一个商品");
        Product product = productDao.findById(productId);
        AssertUtil.notNull(product, "该商品不存在，请重新选择");
        return product;
    }
}
