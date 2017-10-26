[@promotion_list productCategoryId = productCategory.id count = 3]
[#if promotions?has_content]
    <div class="hotPromotion">
        <dl>
            <dt>热销促销</dt>

            [#list promotions as promotion]
                <dd>
                    <a href="${ctx}/promotion/${promotion.id}" title="${promotion.title}">
                        <img src="${promotion.image}" alt="${promotion.title}" />
                    </a>
                </dd>
            [/#list]


        </dl>
    </div>
[/#if]
[/@promotion_list]