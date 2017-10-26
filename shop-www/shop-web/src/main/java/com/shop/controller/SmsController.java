package com.shop.controller;
import com.alibaba.fastjson.JSON;
import com.google.code.kaptcha.Constants;
import com.google.code.kaptcha.Producer;
import com.shop.base.BaseController;
import com.shop.base.ResultInfo;
import com.shop.constant.Constant;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("sms")
@Slf4j
public class SmsController extends BaseController {

//    @Value("${sms.url}")
//    private String smsUrl;
//    @Value("${sms.appkey}")
//    private String smsAppKey;
//    @Value("${sms.secret}")
//    private String smsSecret;
//    @Value("${sms.type}")
//    private String smsType;
//    @Value("${sms.free.sign.name}")
//    private String smsFreeSignName;
//    @Value("${sms.template.code}")
//    private String smsTemplateCode;

    @Autowired
    private RabbitTemplate rabbitTemplate;

    @RequestMapping("send")
    @ResponseBody
    public ResultInfo sendVerifyCode(String phone, HttpSession session) {
        if (StringUtils.isBlank(phone)) {
            return failure(Constant.ERROR_CODE, "请输入手机号");
        }
        // 发送消息 生成六位随机数
        String verifyCode = (String)session.getAttribute(Constant.VERIFY_CODE_KEY + "_" + phone);
        if (StringUtils.isNotBlank(verifyCode)) {
            return success("发送成功");
        }
        verifyCode = RandomUtils.nextInt(100000, 999999) + "";
        log.info("手机号：{}，短信验证码为：{}", phone, verifyCode);
        Map<String, String> params = new HashMap<>();
        params.put("phone", phone.trim());
        // 丢到队列中
        rabbitTemplate.convertAndSend("smsVerifyCodeExchange", "sms.send.verifycode", params);
        session.setAttribute(Constant.VERIFY_CODE_KEY + "_" + phone, verifyCode);
        session.setMaxInactiveInterval(300); // 5分钟有效

//        // 短信发送
//        boolean isSuccess = sendByDayu(phone, verifyCode);
//        if (isSuccess) {
//            session.setAttribute(Constant.VERIFY_CODE_KEY + "_" + phone, verifyCode);
//            session.setMaxInactiveInterval(300); // 5分钟有效
//            return success("发送成功");
//        }
        return success("发送成功");
    }

    /**
     * 短信发送
     * @param phone
     * @param verifyCode
     * @return
     */
//    public boolean sendByDayu(String phone, String verifyCode) {
//        try {
//            TaobaoClient client = new DefaultTaobaoClient(smsUrl, smsAppKey, smsSecret);
//            AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
//            req.setSmsType(smsType);
//            req.setSmsFreeSignName(smsFreeSignName);
//            Map<String, String> map = new HashMap<>();
//            map.put("randomNum", verifyCode);
//            req.setSmsParam(JSON.toJSONString(map));
//            req.setRecNum(phone);
//            req.setSmsTemplateCode(smsTemplateCode);
//            AlibabaAliqinFcSmsNumSendResponse response = client.execute(req);
//            if (response.isSuccess()) {
//                log.info("发送成功");
//            } else {
//                log.info("发送失败：{}", JSON.toJSON(response));
//            }
//            return response.isSuccess();
//        } catch (Exception e) {
//            log.info("发送失败：{}", e);
//            return false;
//        }
//    }

}

