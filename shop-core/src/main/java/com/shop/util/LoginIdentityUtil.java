package com.shop.util;

import com.shop.constant.Constant;
import com.shop.exception.LoginException;
import com.shop.vo.LoginIndentity;

import javax.servlet.http.HttpSession;

/**
 * Created by TW on 2017/9/5.
 */
public class LoginIdentityUtil {

    /**
     * 获取登录用户的ID
     * @param session
     * @return
     */
    public static Integer getUserIdFromSession(HttpSession session) {

        // 获取登录用户的ID
        LoginIndentity loginIndentity = (LoginIndentity)session.getAttribute(Constant.LOGIN_USER_KEY);
        if (loginIndentity == null) {
            return null;
        }
        Integer userId = loginIndentity.getId();
        return userId;
    }
}
