package com.shop.service;

import com.alibaba.fastjson.JSON;
import com.shop.dao.AttributeDao;
import com.shop.model.Attribute;
import com.shop.util.AssertUtil;
import org.apache.commons.lang3.ArrayUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by TW on 2017/8/28.
 */
@Service
public class AttributeService {

    @Autowired
    private AttributeDao attributeDao;

    /**
     * 查询分类下的商品列表
     * @param productCategoryId
     * @return
     */
    public List<Attribute> findAttributes(Integer productCategoryId) {
        AssertUtil.intIsNotEmpty(productCategoryId, "请选择分类");
        List<Attribute> attributes = attributeDao.findCategoryAttributes(productCategoryId);

        if (attributes == null) {
            return Collections.emptyList();
        }

        for(Attribute attribute: attributes) {
            if (attribute == null) {
                continue;
            }
            // ["1匹","大1匹","1.5匹","大1.5匹","2匹","大2匹","3匹","5匹"]
            String options = attribute.getOptions();
            List<String> optionsList = JSON.parseArray(options, String.class);
            attribute.setOptionsList(optionsList.toArray(new String[]{}));
        }
        return attributes;
    }

}
