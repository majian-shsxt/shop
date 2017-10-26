package com.shop.controller;

import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.google.code.kaptcha.Constants;
import com.shop.base.BaseController;
import com.shop.base.BaseDto;
import com.shop.base.ResultInfo;
import com.shop.constant.Constant;
import com.shop.dto.MemberDto;
import com.shop.model.User;
import com.shop.service.UserService;
import com.shop.vo.LoginIndentity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * Created by TW on 2017/8/22.
 */
@Controller
@RequestMapping("user")
public class UserController extends BaseController {

    @Autowired
    private UserService userService;

    @RequestMapping("find")
    @ResponseBody
    public ResultInfo find(BaseDto baseDto) {
        PageList<User> result = userService.find(baseDto);
        return success(result);
    }

    @RequestMapping("register")
    @ResponseBody
    public ResultInfo register(MemberDto memberDto, HttpSession session) {
        String verifyCode = (String)session.getAttribute(Constants.KAPTCHA_SESSION_KEY);
        String phoneVerifyCode = (String)session.getAttribute(Constant.VERIFY_CODE_KEY + "_" + memberDto.getPhone());
        LoginIndentity loginIndentity = userService.add(memberDto, verifyCode, phoneVerifyCode);
        session.setAttribute(Constant.LOGIN_USER_KEY, loginIndentity);
        return success("注册成功");
    }

    @RequestMapping("login")
    @ResponseBody
    public ResultInfo login(String userName, String password, String verifyCode, HttpServletRequest request) {
        // 获取图片验证码内容 短信验证码内容
        HttpSession session = request.getSession();
        String sessionVerifyCode = (String)session.getAttribute(Constants.KAPTCHA_SESSION_KEY); // 从session中获取图片验证码
        LoginIndentity loginIndentity = userService.login(userName, password, verifyCode, sessionVerifyCode);
        session.setAttribute(Constant.LOGIN_USER_KEY, loginIndentity);
        return success("恭喜登录成功");
    }

}
