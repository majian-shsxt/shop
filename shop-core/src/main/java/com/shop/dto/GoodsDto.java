package com.shop.dto;

import com.shop.base.BaseDto;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.math.BigDecimal;

/**
 * Created by TW on 2017/8/26.
 */
@Getter
@Setter
@ToString
public class GoodsDto extends BaseDto {

    private String keyword;

    private BigDecimal startPrice;

    private BigDecimal endPrice;

    private String treePath;

    private  Integer productCategoryId;

    private String attributeValue0;
    private String attributeValue1;
    private String attributeValue2;
    private String attributeValue3;

    private Integer brandId;


}
