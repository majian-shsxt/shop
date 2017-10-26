package com.shop.service;

import com.github.miemiedev.mybatis.paginator.domain.PageList;
import com.shop.base.BaseDto;
import com.shop.dao.MemberDao;
import com.shop.dao.UserDao;
import com.shop.dto.MemberDto;
import com.shop.model.Member;
import com.shop.model.User;
import com.shop.util.AssertUtil;
import com.shop.util.MD5;
import com.shop.vo.LoginIndentity;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by TW on 2017/8/22.
 */
@Service
public class UserService {

    @Autowired
    private UserDao userDao;
    @Autowired
    private MemberDao memberDao;


    public PageList<User> find(BaseDto baseDto) {

        PageList<User> users = userDao.find(baseDto.buildPageBounds());
        return users;
    }

    /**
     * 注册
     * @param memberDto
     * @param verifyCodeFromSession
     * @param phoneVerifyCodeFromSession
     * @return
     */
    public LoginIndentity add(MemberDto memberDto, String verifyCodeFromSession,
                    String phoneVerifyCodeFromSession) {

        // 基本参数验证 非空验证 + 两次密码校验 + 图片验证码的校验 + 短信验证码校验
        checkRegisterParams(memberDto, verifyCodeFromSession,
                phoneVerifyCodeFromSession);
        // 唯一性验证：userName email phone
        checkResgisterUnique(memberDto);
        // 密码加密
        Member member = new Member();
        BeanUtils.copyProperties(memberDto, member);
        member.setPassword(MD5.toMD5(memberDto.getPassword()));
        // 写入数据库
        memberDao.insert(member);
        // 返回
        LoginIndentity loginIndentity = buildLoginIndentity(member);
        return loginIndentity;
    }

    /**
     * 登录
     * @param userName
     * @param password
     * @param verifyCode
     * @param sessionVerifyCode
     * @return
     */
    public LoginIndentity login(String userName, String password,
                                String verifyCode, String sessionVerifyCode) {

        AssertUtil.notNull(userName, "请输入用户名或邮箱");
        AssertUtil.notNull(password, "请输入密码");
        AssertUtil.notNull(verifyCode, "请输入验证码");
        AssertUtil.isTrue(!verifyCode.equals(sessionVerifyCode), "验证码输入有误，请重新输入");
        // 根据userName(username, email) 去数据库查询 --验证
        Member member = memberDao.findByUserNameOrEmail(userName);
        AssertUtil.isTrue(member == null, "用户名或者密码错误，请重新输入");

        // 验证password --加密验证
        password = MD5.toMD5(password);
        AssertUtil.isTrue(!password.equals(member.getPassword()), "用户名或者密码错误，请重新输入");

        // 构建一个登录信息
        LoginIndentity loginIndentity = buildLoginIndentity(member);
        return loginIndentity;
    }

    /**
     * 注册时基本参数验证
     * @param memberDto
     * @param sessionVerifyCode
     * @param sessionPhoneVerifyCode
     */
    private static void checkRegisterParams(MemberDto memberDto,
                                            String sessionVerifyCode, String sessionPhoneVerifyCode) {
        AssertUtil.isNotEmpty(memberDto.getUsername(), "请输入用户名");
        AssertUtil.isNotEmpty(memberDto.getPassword(), "请输入密码");
        AssertUtil.isTrue(!memberDto.getPassword().equals(memberDto.getRePassword()), "两次密码输入不相同");
        AssertUtil.isNotEmpty(memberDto.getEmail(), "请输入邮箱");
        AssertUtil.isNotEmpty(memberDto.getPhone(), "请输入手机号");
        AssertUtil.isNotEmpty(memberDto.getPhoneVerifyCode(), "请输入手机验证码");
        AssertUtil.isTrue(!memberDto.getPhoneVerifyCode().toLowerCase().equals(sessionPhoneVerifyCode), "手机验证码输入有误，请重新输入");
        AssertUtil.isNotEmpty(memberDto.getVerifyCode(), "请输入验证码");
        AssertUtil.isTrue(!memberDto.getVerifyCode().toLowerCase().equals(sessionVerifyCode), "图片验证码输入有误，请重新输入");
    }

    /**
     * 唯一性验证
     * @param memberDto
     */
    private void checkResgisterUnique (MemberDto memberDto) {
        Member member = memberDao.findByColumn("username", memberDto.getUsername());
        AssertUtil.isTrue(member != null, "该用户名已注册");
        member = memberDao.findByColumn("email", memberDto.getEmail());
        AssertUtil.isTrue(member != null, "该邮箱已注册");
        member = memberDao.findByColumn("phone", memberDto.getPhone());
        AssertUtil.isTrue(member != null, "该手机号已注册");
    }

    /**
     * 构建登录结果
     * @param member
     * @return
     */
    private LoginIndentity buildLoginIndentity(Member member) {
        LoginIndentity loginIndentity = new LoginIndentity();
        loginIndentity.setEmail(member.getEmail());
        loginIndentity.setId(member.getId());
        loginIndentity.setPhone(member.getPhone());
        loginIndentity.setUsername(member.getUsername());
        return loginIndentity;
    }

}
