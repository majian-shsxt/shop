package com.shop.proxy;

import com.shop.annotation.IsLogin;
import com.shop.exception.LoginException;
import com.shop.util.LoginIdentityUtil;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;

/**
 * Created by TW on 2017/9/5.
 */
@Component
@Aspect
public class LoginProxy {

    @Autowired
    private HttpSession session;

    @Pointcut(value = "@annotation(com.shop.annotation.IsLogin)")
    public void pointcut() {

    }

    @Before(value = "pointcut()&&@annotation(isLogin)")
    public void beforeMethod(JoinPoint joinPoint, IsLogin isLogin) {
        Integer userId  = LoginIdentityUtil.getUserIdFromSession(session);
        if (userId == null || userId < 1) {
            throw new LoginException("请登录");
        }
    }

}
