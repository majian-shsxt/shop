package com.shop.dao;

import com.shop.model.Product;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * Created by TW on 2017/8/28.
 */
public interface ProductDao {

    /**
     * 查询默认商品
     * @param goodId
     * @return
     */
    @Select("SELECT id, allocated_stock, cost, exchange_point, " +
            "is_default, market_price, price, reward_point, sn, specification_values, " +
            "stock, goods FROM xx_product where goods = #{goodId} and is_default=1")
    Product findDefaultProduct(@Param(value = "goodId") Integer goodId);

    @Select("SELECT id, allocated_stock, cost, exchange_point, " +
            "is_default, market_price, price, reward_point, sn, specification_values, " +
            "stock, goods FROM xx_product where goods = #{goodId}")
    List<Product> findGoodProducts(@Param(value = "goodId") Integer goodId);

    @Select("SELECT id, allocated_stock, cost, exchange_point, " +
            "is_default, market_price, price, reward_point, sn, specification_values, " +
            "stock, goods FROM xx_product where id = #{id}")
    Product findById(@Param(value = "id") Integer productId);

    @Update("update xx_product set allocated_stock = allocated_stock + #{quantity} " +
            " where id = #{id} and stock - allocated_stock >= #{quantity}")
    int updateAllocatedStock(@Param(value = "id")Integer id, @Param(value = "quantity") Integer quantity);
}
