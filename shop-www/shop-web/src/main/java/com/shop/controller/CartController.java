package com.shop.controller;

import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.shop.annotation.IsLogin;
import com.shop.base.BaseController;
import com.shop.base.BaseDto;
import com.shop.base.ResultInfo;
import com.shop.constant.Constant;
import com.shop.exception.LoginException;
import com.shop.exception.ParamException;
import com.shop.model.CartItem;
import com.shop.service.CartService;
import com.shop.util.LoginIdentityUtil;
import com.shop.vo.LoginIndentity;
import org.apache.ibatis.annotations.Select;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * Created by TW on 2017/9/5.
 */
@Controller
@RequestMapping("cart")
public class CartController extends BaseController {
//    Login/**/Indentity
    @Autowired
    private CartService cartService;

    @RequestMapping("add")
    @ResponseBody
    @IsLogin
    public ResultInfo addToCart(Integer goodId, Integer productId, Integer quantity, HttpSession session) {
//
//        // 获取登录用户的ID
//        LoginIndentity loginIndentity = (LoginIndentity)session.getAttribute(Constant.LOGIN_USER_KEY);
//        if (loginIndentity == null) {
//            throw new LoginException("请登录");
//        }
//        Integer userId = loginIndentity.getId();
//        if (userId == null) {
//            throw new LoginException("请登录");
//        }
        Integer userId = LoginIdentityUtil.getUserIdFromSession(session);

        cartService.addToCart(productId, quantity, userId, goodId);

        return success("添加成功");
    }

    @RequestMapping("count")
    @ResponseBody
    @IsLogin
    public ResultInfo count(HttpSession session) {

        // 获取登录用户的ID
        Integer userId = LoginIdentityUtil.getUserIdFromSession(session);

        Integer count = cartService.countUserQuantity(userId);

        return success(count);
    }

    @RequestMapping("list")
    @IsLogin
    public String selectForPage(BaseDto baseDto, HttpSession session, Model model) {

        // 获取登录用户的ID
        Integer userId = LoginIdentityUtil.getUserIdFromSession(session);

        PageList<CartItem> cartItems = cartService.selectForPage(baseDto, userId);
        model.addAttribute("cartItems", cartItems);
        model.addAttribute("paginator", cartItems.getPaginator());
        return "cart/list";
    }

    @IsLogin
    @RequestMapping("update")
    @ResponseBody
    public ResultInfo updateQuantity(Integer id, Integer quantity, HttpSession session) {

        Integer loginUserId = LoginIdentityUtil.getUserIdFromSession(session);

        cartService.updateQuantity(loginUserId, id, quantity);

        return success("更新成功");
    }

    @IsLogin
    @RequestMapping("delete")
    @ResponseBody
    public ResultInfo delete(Integer id, HttpSession session) {
        Integer loginUserId = LoginIdentityUtil.getUserIdFromSession(session);
        cartService.delete(loginUserId, id);
        return success("删除成功");
    }

    @IsLogin
    @RequestMapping("clear")
    @ResponseBody
    public ResultInfo clear(HttpSession session) {
        Integer loginUserId = LoginIdentityUtil.getUserIdFromSession(session);
        cartService.deleteAll(loginUserId);
        return success("清空成功");
    }


}
