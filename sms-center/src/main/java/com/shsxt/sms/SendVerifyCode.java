package com.shsxt.sms;

import com.alibaba.fastjson.JSON;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by TW on 2017/9/5.
 */
@Component
public class SendVerifyCode {


    @Value("${sms.url}")
    private String smsUrl;
    @Value("${sms.appkey}")
    private String smsAppKey;
    @Value("${sms.secret}")
    private String smsSecret;
    @Value("${sms.type}")
    private String smsType;
    @Value("${sms.free.sign.name}")
    private String smsFreeSignName;
    @Value("${sms.template.code}")
    private String smsTemplateCode;

    private static Logger logger = LoggerFactory.getLogger(SendVerifyCode.class);

    public void send(Map<String, String> params) {
        String phone = params.get("phone");
        String verifyCode = params.get("verifyCode");
        try {
            TaobaoClient client = new DefaultTaobaoClient(smsUrl, smsAppKey, smsSecret);
            AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
            req.setSmsType(smsType);
            req.setSmsFreeSignName(smsFreeSignName);
            Map<String, String> map = new HashMap<>();
            map.put("randomNum", verifyCode);
            req.setSmsParam(JSON.toJSONString(map));
            req.setRecNum(phone);
            req.setSmsTemplateCode(smsTemplateCode);
            AlibabaAliqinFcSmsNumSendResponse response = client.execute(req);
            if (response.isSuccess()) {
                logger.info("发送成功");
            } else {
                // 发送失败处理 存入日志中，然后通过轮询，或者重新存入队列
                logger.info("发送失败：{}", JSON.toJSON(response));
            }
        } catch (Exception e) {
            // 发送失败处理 存入日志中，然后通过轮询，或者重新存入队列
            logger.info("发送失败：{}", e);
        }
    }
}
