package com.shop.dao;

import com.github.miemiedev.mybatis.paginator.domain.PageBounds;
import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.shop.dto.GoodsDto;
import com.shop.model.Goods;
import com.shop.vo.GoodsVo;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * Created by TW on 2017/8/25.
 */
public interface GoodsDao {

    @Select("SELECT g.id, g.NAME, g.caption, g.image, g.price FROM xx_goods g LEFT JOIN " +
            " xx_product_category p on g.product_category = p.id LEFT JOIN xx_goods_tag t on g.id=t.goods " +
            " where p.tree_path LIKE ',${categoryId},%' AND t.tags = 3 and g.is_marketable=1 " +
            " order by g.id LIMIT #{limit}")
    List<GoodsVo> findCategoryHotGoods(@Param(value = "categoryId") Integer categoryId,
                                     @Param(value = "limit")Integer limit);

    @Select("SELECT g.id, g.NAME, g.caption, g.image, g.price FROM xx_goods g LEFT JOIN " +
            " xx_goods_tag t on g.id=t.goods " +
            " where t.tags = 3 and g.is_marketable = 1 " +
            " order by g.id LIMIT #{limit}")
    List<GoodsVo> findHotGoods(@Param(value = "limit")Integer limit);
    
    PageList<GoodsVo> selectForPage(GoodsDto goodsDto, PageBounds pageBounds);

    PageList<GoodsVo> findOtherList(GoodsDto goodsDto, PageBounds pageBounds);

    @Select("SELECT " +
            " t.id, " +
            " t.`name`, " +
            " t.caption, " +
            " t.sn, " +
            " t.price, " +
            " t.market_price, " +
            " t.unit, " +
            " t.type," +
            " t.product_images, " +
            " t.specification_items, " +
            " t.parameter_values, " +
            " t.introduction, " +
            " t.product_category, " +
            " t.image " +
            "FROM " +
            " xx_goods t " +
            "WHERE " +
            " id = #{id} and is_marketable = 1")
    GoodsVo findById(@Param(value = "id") Integer id);
}
