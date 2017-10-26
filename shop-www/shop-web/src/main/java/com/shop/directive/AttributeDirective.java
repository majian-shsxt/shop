package com.shop.directive;

import com.shop.model.Ad;
import com.shop.model.Attribute;
import com.shop.service.AdService;
import com.shop.service.AttributeService;
import freemarker.core.Environment;
import freemarker.template.TemplateDirectiveBody;
import freemarker.template.TemplateException;
import freemarker.template.TemplateModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Created by TW on 2017/8/25.
 */
@Component
public class AttributeDirective extends BaseDirective {

    @Autowired
    private AttributeService attributeService;

    @Override
    public void execute(Environment env, Map params, TemplateModel[] loopVars,
                        TemplateDirectiveBody body)
            throws TemplateException, IOException {
        // 获取参数
        Integer productCategoryId = getParamter(params, "productCategoryId", Integer.class);
        // 获取数据
        List<Attribute> attributes = attributeService.findAttributes(productCategoryId);
        // 输出
        setVariable(env, body, "attributes", attributes);
    }
}
