package com.shop.dao;

import com.shop.model.Cart;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Service;

/**
 * Created by TW on 2017/9/5.
 */
public interface CartDao {

    @Select("select id, expire, cart_key, member from xx_cart " +
            " where member = #{userId} and version = 0")
    Cart findUserCart(@Param(value = "userId") Integer userId);

    @Insert("insert into xx_cart (member, cart_key, expire, create_date, modify_date, version) " +
            " values (#{member}, #{cartKey}, #{expire}, #{createDate}, #{modifyDate}, #{version})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insert(Cart cart);
}
