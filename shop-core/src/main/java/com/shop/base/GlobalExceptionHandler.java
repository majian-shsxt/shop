package com.shop.base;

import com.alibaba.fastjson.JSON;
import com.shop.exception.LoginException;
import com.shop.exception.ParamException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Created by TW on 2017/8/31.
 */
@ControllerAdvice
public class GlobalExceptionHandler extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ResponseBody
    @ExceptionHandler(value = ParamException.class)
    public ResultInfo handlerParamException(ParamException exception) {
        // 同步还是异步根据XMLHttpRequest
        return failure(exception.getErrorCode(), exception.getMessage());
    }

    @ExceptionHandler(value = LoginException.class)
    public String handlerLoginException(LoginException loginException, HttpServletRequest request,
                                        HttpServletResponse response, Model model) {

        // 同步还是异步根据XMLHttpRequest
        logger.error("登录异常：{}", loginException);
        String xmlHttpRequest = request.getHeader("X-Requested-With");
        ResultInfo resultInfo = failure(loginException.getErrorCode(),
                loginException.getMessage());
        if ("XMLHttpRequest".equals(xmlHttpRequest)) { // 如果是异步请求返回json
            response.setContentType("application/json;charset=utf-8");
            PrintWriter pw = null;
            try {
                pw = response.getWriter();
                pw.write(JSON.toJSONString(resultInfo));
            } catch (IOException e) {
                logger.error("传出json失败：{}", e);
            } finally {
                if (pw != null) {
                    pw.close();
                }
            }
            return null;
        } else { // 跳转到登录
            model.addAttribute("resultInfo", resultInfo);
            model.addAttribute("ctx", request.getContextPath());
            return "error";
        }

    }

}
