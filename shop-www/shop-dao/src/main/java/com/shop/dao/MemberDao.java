package com.shop.dao;

import com.shop.model.Member;
import org.apache.ibatis.annotations.*;

/**
 * Created by TW on 2017/8/29.
 */
public interface MemberDao {

    /**
     * 根据某个字段进行查询
     * @param column
     * @param value
     * @return
     */
    @Select("select id, username from xx_member where ${column} = #{value}")
    Member findByColumn(@Param(value ="column" ) String column, @Param(value = "value") String value);

    @Insert("INSERT INTO xx_member (username, password, email, phone, gender, name, mobile, create_date, modify_date, version, "
            + " amount,balance, is_enabled, is_locked, lock_key, login_failure_count, point, register_ip, member_rank) "
            + " VALUES (#{username}, #{password}, #{email}, #{phone}, #{gender}, #{name}, #{mobile}, now(), now(), 0, 0, 0, 1, 0, '', 0, 0, '',1)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Member member);

    @Select("select id, username, password, phone, email from xx_member " +
            "where username = #{userName} or email = #{userName}")
    Member findByUserNameOrEmail(@Param(value = "userName") String userName);

    @Update("update xx_member set point = IFNULL(point, 0) + #{rewardPoint} where id = #{userId}")
    void updatePoints(@Param(value = "userId") Integer userId,
                      @Param(value = "rewardPoint") Long rewardPoint);
}
