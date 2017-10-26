package com.shop.service;

import com.shop.constant.Constant;
import com.shop.dao.ProductCategoryDao;
import com.shop.model.ProductCategory;
import com.shop.util.AssertUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by TW on 2017/8/24.
 */
@Service
public class ProductCategoryService {

    @Autowired
    private ProductCategoryDao productCategoryDao;

    /**
     * 获取根级分类
     * @return
     * @param limit
     */
    public List<ProductCategory> findRootList(Integer limit) {
        if (limit == null) {
            limit = Constant.SIX;
        }
        List<ProductCategory> productCategories = productCategoryDao.findRootList(limit);
        return productCategories;
    }

    /**
     * 根据父级id查询子级
     * @param parentId
     * @return
     */
    public List<ProductCategory> findChilrenList(Integer parentId, Integer limit) {
        AssertUtil.intIsNotEmpty(parentId);
        if (limit == null) {
            limit = Constant.THREE;
        }
        List<ProductCategory> productCategories = productCategoryDao.findChildrenList(parentId, limit);
        return productCategories;
    }

    public ProductCategory findById(Integer productCategoryId) {
        AssertUtil.intIsNotEmpty(productCategoryId, "请选择分类进行查询");
        ProductCategory productCategory = productCategoryDao.findById(productCategoryId);
        AssertUtil.notNull(productCategory, "该分类不存在");
        return productCategory;
    }

    /**
     * 查询父级分类
     * @param productCategoryId
     * @return
     */
    public List<ProductCategory> findParentList(Integer productCategoryId) {
        ProductCategory productCategory = findById(productCategoryId);
        if (productCategory.getGrade() == 0) { // 根级分类
            return Collections.emptyList();
        }
        if (productCategory.getGrade() == 1) { // 第一级分类
            ProductCategory parent = findById(productCategory.getParent());
            List<ProductCategory> productCategories = new ArrayList<>();
            productCategories.add(parent);
            return productCategories;
        }
        String treePath = productCategory.getTreePath();
        // select * from xx_product_category where id in (1,2)
        treePath = treePath.substring(treePath.indexOf(",") + 1, treePath.lastIndexOf(","));
        List<ProductCategory> parentProductCategories = productCategoryDao.findByIds(treePath);
        return parentProductCategories;
    }
}
