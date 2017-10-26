package com.shop.service;

import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.shop.base.BaseDto;
import com.shop.dao.CartDao;
import com.shop.dao.CartItemDao;
import com.shop.model.Cart;
import com.shop.model.CartItem;
import com.shop.model.Product;
import com.shop.util.AssertUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.UUID;

/**
 * Created by TW on 2017/9/5.
 */
@Service
public class CartService {

    @Autowired
    private ProductService productService;
    @Autowired
    private CartDao cartDao;
    @Autowired
    private CartItemDao cartItemDao;

    /**
     * 添加购物车
     * @param productId
     * @param quantity
     * @param userId
     */
    public void addToCart(Integer productId,
                          Integer quantity, Integer userId, Integer goodId) {

        // 基本参数验证
        AssertUtil.isTrue((productId == null || productId < 1)
                && (goodId == null || goodId < 1), "请选择商品");
        AssertUtil.intIsNotEmpty(quantity, "请选择商品数量");
        AssertUtil.intIsNotEmpty(userId, "请登录");
        Product product = null;
        if (goodId != null && goodId > 0 && (productId == null || productId < 1)) { // 传入的是goodId不是productId
            // 根据goodID查询默认商品ID
            product = productService.findDefaultProduct(goodId);
            productId = product.getId();
        } else {
            // 验证商品库存是否足够
            product = productService.findById(productId);
        }
        AssertUtil.notNull(product, "请选择商品");

        Integer availableStock = product.getAvailableStock();
        AssertUtil.isTrue(availableStock == null || availableStock < quantity,
                "该商品库存不够");

        // 验证购物车中是否包含有此商品
        // 获取购物车
        Cart cart = cartDao.findUserCart(userId);
        if (cart == null) { // 此用户没有购物车就生成一个购物车
            cart = new Cart();
            cart.setVersion(0);
            cart.setModifyDate(new Date());
            cart.setCreateDate(new Date());
            cart.setMember(userId);
            cart.setExpire(new Date(Cart.TIMEOUT + new Date().getTime()));
            cart.setCartKey(UUID.randomUUID().toString());
            cartDao.insert(cart);

            // 添加购物车明细
            CartItem cartItem = new CartItem();
            cartItem.setVersion(0);
            cartItem.setModifyDate(new Date());
            cartItem.setCreateDate(new Date());
            cartItem.setQuantity(quantity);
            cartItem.setProduct(productId);
            cartItem.setCart(cart.getId());
            cartItemDao.insert(cartItem);
            return;
        }
        CartItem cartItem = cartItemDao.findByProudctId(productId, cart.getId());
        if (cartItem != null) { // 说明购物车中包含有此商品就更新数量
            cartItemDao.updateQuantity(cartItem.getId(), quantity);
        } else { // 添加购物车
            // 添加购物车明细
            cartItem = new CartItem();
            cartItem.setVersion(0);
            cartItem.setModifyDate(new Date());
            cartItem.setCreateDate(new Date());
            cartItem.setQuantity(quantity);
            cartItem.setProduct(productId);
            cartItem.setCart(cart.getId());
            cartItemDao.insert(cartItem);
        }
    }

    /**
     * 统计用户的购物车商品数量
     * @param userId
     * @return
     */
    public Integer countUserQuantity(Integer userId) {
        AssertUtil.intIsNotEmpty(userId, "请登录");
        // 调用dao方法
        Integer amount = cartItemDao.count(userId);
        if (amount == null) {
            return 0;
        }
        return amount;
    }

    public PageList<CartItem> selectForPage(BaseDto baseDto, Integer userId) {
        AssertUtil.intIsNotEmpty(userId, "请登录");
        // 获取当前用户购物车
        Cart cart = cartDao.findUserCart(userId);
        if (cart == null) {
            return new PageList<>();
        }
        PageList<CartItem> cartItems = cartItemDao.selectForPage(baseDto.buildPageBounds(), cart.getId());

        return cartItems;
    }

    /**
     * 更新购物车商品数量
     * @param loginUserId
     * @param id
     * @param quantity
     */
    public void updateQuantity(Integer loginUserId, Integer id, Integer quantity) {
        // 基本参数验证
        AssertUtil.isTrue(loginUserId == null || loginUserId < 1, "请登录");
        AssertUtil.isTrue(id == null || id < 1, "请选择购物车明细");
        AssertUtil.isTrue(quantity == null || quantity < 1, "请输入数量");

        // 验证购物车明细
        Cart cart = cartDao.findUserCart(loginUserId);
        AssertUtil.isTrue(cart == null, "请往购物车中添加商品");
        CartItem cartItem = cartItemDao.findById(id, cart.getId());
        AssertUtil.isTrue(cartItem == null, "该明细不存在，请重试");
        // 商品库存判断
        Product product = productService.findById(cartItem.getProduct());
        AssertUtil.isTrue(product == null || product.getAvailableStock() < quantity,
                "该商品库存不够");
        // 更新商品数量
        cartItemDao.editQuantity(id, quantity);
    }

    /**
     * 删除明细
     * @param loginUserId
     * @param id
     */
    public void delete(Integer loginUserId, Integer id) {
        // 基本参数验证
        AssertUtil.isTrue(loginUserId == null || loginUserId < 1, "请登录");
        AssertUtil.isTrue(id == null || id < 1, "请选择购物车明细");

        // 验证购物车明细
        Cart cart = cartDao.findUserCart(loginUserId);
        AssertUtil.isTrue(cart == null, "请往购物车中添加商品");
        CartItem cartItem = cartItemDao.findById(id, cart.getId());
        AssertUtil.isTrue(cartItem == null, "该明细不存在，请重试");

        // 删除
        cartItemDao.delete(id);
    }

    /**
     * 清空购物车
     * @param loginUserId
     */
    public void deleteAll(Integer loginUserId) {
        // 把购物车删除 （update xx_cart set version = -1 where member = #{loginUserId}）
        // 清空商品
        Cart cart = cartDao.findUserCart(loginUserId);
        AssertUtil.isTrue(cart == null, "请往购物车中添加商品");

        cartItemDao.deleteCartProduct(cart.getId());
    }

}
