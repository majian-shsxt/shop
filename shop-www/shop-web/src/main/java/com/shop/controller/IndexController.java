package com.shop.controller;

import com.shop.base.BaseController;
import com.shop.base.ResultInfo;
import com.shop.constant.Constant;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.Date;
import java.util.List;

/**
 * Created by TW on 2017/8/22.
 */
@Controller
public class IndexController extends BaseController {

    @Autowired
    private FreeMarkerConfigurer freeMarkerConfigurer;

    @RequestMapping("test")
    public String test(Model model) {

        model.addAttribute("realName", null);
        model.addAttribute("userId", 1000000);
        model.addAttribute("isMan", true);
        model.addAttribute("createDate", new Date());

        return "test";
    }

    @RequestMapping("hello")
    public String hello(Model model) {
        return "hello";
    }


    @RequestMapping("index")
    public String index(Model model) {
        return "index";
    }


    @RequestMapping("index.html")
    public String indexHtml(HttpServletRequest request) throws Exception {

        // 找个一个静态页面
        String path = request.getServletContext().getRealPath("/html");
        String indexName = "index.html";
        File file = new File(path + "/" + indexName);
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        if (file.exists()) {
            return "forward:html/" + indexName;
        }
        file.createNewFile();

        OutputStreamWriter out = new OutputStreamWriter(
                new FileOutputStream(file), "utf-8");

        Configuration cfg = freeMarkerConfigurer.getConfiguration();
        Template template = cfg.getTemplate("index.ftl", "UTF-8");
        // 输出到静态页
        template.process(null, out);

        return "forward:html/" + indexName;
    }

    @RequestMapping("register")
    public String register(String redirectUrl, Model model) {
        model.addAttribute("redirectUrl", redirectUrl);
        return "user/register";
    }

    @RequestMapping("logout")
    @ResponseBody
    public ResultInfo logout(HttpSession session) {
        session.removeAttribute(Constant.LOGIN_USER_KEY);
        return success("退出成功");
    }

    @RequestMapping("login")
    public String login(String redirectUrl, Model model) {
        model.addAttribute("redirectUrl", redirectUrl);
        return "user/login";
    }

}
