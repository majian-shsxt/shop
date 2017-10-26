<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>购物车</title>
    <link href="${ctx}/css/common.css" rel="stylesheet" type="text/css" />
    <link href="${ctx}/css/cart.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${ctx}/js/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/js/common.js"></script>

    <style>
        #cartTable th {
            text-align:center;
        }
        #cartTable tr td {
            text-align:center;
        }
    </style>

    <script type="text/javascript">
        $().ready(function() {

            var $quantity = $("#cartTable input[name='quantity']");
            var $checkbox = $("#cartTable input[name='id']");
            var $increase = $("#cartTable span.increase");
            var $decrease = $("#cartTable span.decrease");
            var $delete = $("#cartTable a.delete");
            var $selectAll = $("#selectAll")
            var $effectiveRewardPoint = $("#effectiveRewardPoint");
            var $effectivePrice = $("#effectivePrice");
            var $clear = $("#clear");
            var $submit = $("#submit");

            // 全选
            $selectAll.click(function () {
                if ($(this).attr('checked')) {
                    $checkbox.attr('checked', $(this).attr('checked'));
                    var totalPrice = 0;
                    $checkbox.each(function() {
                        var id = $(this).val();
                        var subTotal = parseInt($("#subtotal_" + id).val());
                        totalPrice += subTotal;
                    });
                    $("#effectivePrice").html(currency(totalPrice, true, true));
                } else {
                    $checkbox.attr('checked', false);
                    $("#effectivePrice").html(currency(0, true, true));
                }
            });

            $checkbox.click(function () {

                var totalPrice = $("#effectivePrice").html();
                totalPrice = totalPrice.substring(0, totalPrice.indexOf("."));
                totalPrice = parseInt(totalPrice.replace(/[^0-9]/ig,""));
                var id = $(this).val();
                var subTotal = parseInt($("#subtotal_" + id).val());
                if($(this).attr('checked')) {
                    totalPrice += subTotal;
                } else {
                    totalPrice -= subTotal;
                }
                $("#effectivePrice").html(currency(totalPrice, true, true));
            });

            // 数量
            $quantity.keypress(function(event) {
                return (event.which >= 48 && event.which <= 57) || event.which == 8;
            });

            // 增加数量
            $increase.click(function() {
                var $quantity = $(this).parent().siblings("input");
                var quantity = $quantity.val();
                if (/^\d*[1-9]\d*$/.test(quantity)) {
                    $quantity.val(parseInt(quantity) + 1);
                } else {
                    $quantity.val(1);
                }
                // 更新总数量
                edit($quantity);
            });

            // 减少数量
            $decrease.click(function() {
                var $quantity = $(this).parent().siblings("input");
                var quantity = $quantity.val();
                if (/^\d*[1-9]\d*$/.test(quantity) && parseInt(quantity) > 1) {
                    $quantity.val(parseInt(quantity) - 1);
                } else {
                    $quantity.val(1);
                }
                edit($quantity);
            });

            // 编辑数量
            $quantity.on("input propertychange change", function(event) {
                var quantity = $(this).val();
                var oldValue = parseInt($(this).attr('oldValue'));
                if (isNaN(quantity) || quantity < 1) {
                    $.message('warn', '请输入正确的数量');
                    $(this).val(oldValue);
                    return;
                }
                if (event.type != "propertychange" || event.originalEvent.propertyName == "value") {
                    // 更新总数量
                    updateCartAmount(quantity - oldValue);
                    edit($(this));
                }
            });

            // 编辑数量
            function edit($quantity) {
                var quantity = $quantity.val();
                if (!/^\d*[1-9]\d*$/.test(quantity)) {
                    $.message('error', "商品数量必须是整数");
                    return false;
                }
                if (parseInt(quantity) < 1) {
                    $.message('error', "商品数量必须大于0");
                    return false;
                }
                // 获取主键
                var id = $quantity.attr('itemId');
                $.ajax({
                    url: "update",
                    type: "POST",
                    data: {id: id, quantity: quantity},
                    dataType: "json",
                    cache: false,
                    success: function(data) {
                        if (data.resultCode == 0) {
                            $.message('error', data.resultMessage);
                            setTimeout(function() {
                                location.reload(true);
                            }, 3000);
                        } else {
                            location.reload(true);
                        }

                    }
                });
            }

            // 删除
            $delete.click(function() {
                if (confirm("您确定要删除吗？")) {
                    var $this = $(this);
                    var $tr = $this.closest("tr"); // 获取最近的tr的dom
                    var id = $tr.find("input[name='id']").val();
                    $.ajax({
                        url: "delete",
                        type: "POST",
                        data: {id: id},
                        dataType: "json",
                        cache: false,
                        success: function(data) {
                            if (data.resultCode == 0) {
                                $.message('error', data.resultMessage);
                            } else {
                                $.message('success', "删除成功");
                            }
                            setTimeout(function() {
                                location.reload(true);
                            }, 1000);
                            return;
                        }
                    });
                }
                return false;
            });

            // 清空
            $clear.click(function() {
                if (confirm("您确定要清空吗？")) {
                    $.ajax({
                        url: "clear",
                        type: "POST",
                        dataType: "json",
                        cache: false,
                        data: {},
                        success: function(data) {
                            location.reload(true);
                        }
                    });
                }
                return false;
            });

            // 提交
            $submit.click(function() {
                var cartItemIds = [];
                $("#cartTable input[name='id']:checked").each(function() { // 获取选中的checkbox
                    cartItemIds.push($(this).val());
                });
                if (cartItemIds.length < 1) {
                    $.message('warn', "请选择商品进行提交");
                }
                var url = "/order/checkout?cartItemIds=" + cartItemIds.join(",");
                window.location.href = url;
            });

            // 右上角数量中数量的更新
            function updateCartAmount(amount) {
                var $headerEm = $("#headerCart em");
                var totalAmount = parseInt($headerEm.html());
                if (isNaN(totalAmount)) {
                    totalAmount = 0;
                }
                $headerEm.html(totalAmount + amount);
            }

            $.pageSkip = function(pageNumber) {
                var $pageNumber = $("#pageNumber");
                $pageNumber.val(pageNumber);
                $("#paginatorForm").submit();
                return false;
            }
        });
    </script>
</head>
<body>
<script type="text/javascript">
    $().ready(function() {

        var $headerName = $("#headerName");
        var $headerLogin = $("#headerLogin");
        var $headerRegister = $("#headerRegister");
        var $headerLogout = $("#headerLogout");
        var $goodsSearchForm = $("#goodsSearchForm");
        var $keyword = $("#goodsSearchForm input");
        var defaultKeyword = "商品搜索";

        var username = getCookie("username");
        var nickname = getCookie("nickname");
        if ($.trim(nickname) != "") {
            $headerName.text(nickname).show();
            $headerLogout.show();
        } else if ($.trim(username) != "") {
            $headerName.text(username).show();
            $headerLogout.show();
        } else {
            $headerLogin.show();
            $headerRegister.show();
        }

        $keyword.focus(function() {
            if ($.trim($keyword.val()) == defaultKeyword) {
                $keyword.val("");
            }
        });

        $keyword.blur(function() {
            if ($.trim($keyword.val()) == "") {
                $keyword.val(defaultKeyword);
            }
        });

        $goodsSearchForm.submit(function() {
            if ($.trim($keyword.val()) == "" || $keyword.val() == defaultKeyword) {
                return false;
            }
        });

    });
</script>
    [#include "include/header.ftl"]

    <div class="container cart">
        <div class="row">
            <div class="span12">
                <div class="step">
                    <ul>
                        <li class="current">查看购物车</li>
                        <li>订单结算</li>
                        <li>订单完成</li>
                    </ul>
                </div>
                <table id="cartTable" class="cartTable">
                    <tr>
                        <th>全选&nbsp;&nbsp;<input id="selectAll" type="checkbox" /></th>
                        <th>图片</th>
                        <th>商品</th>
                        <th>价格</th>
                        <th>数量</th>
                        <th>小计</th>
                        <th>操作</th>
                    </tr>
                    [#if cartItems?has_content]
                        [#list cartItems as cartItem]
                            <tr>
                                <td width="60">
                                    <input type="hidden" name="availableStock" value="#{cartItem.productInfo.availableStock}" />
                                    <input type="hidden" name="productId" value="${cartItem.product}" />
                                    <input type="checkbox" name="id" value="${cartItem.id}" />
                                </td>
                                <td width="60">
                                    <img src="${cartItem.productInfo.thumbnail}" alt="${cartItem.productInfo.name}" />
                                </td>
                                <td  style="text-align:left">
                                    <a href="${ctx}/goods/content/${cartItem.productInfo.goods}" title="${cartItem.productInfo.name}" target="_blank">${cartItem.productInfo.name}</a>
                                    [#if cartItem.productInfo.getSpecifications()?size > 0]
                                        <span class="silver">[${cartItem.productInfo.getSpecifications()?join(',')}]</span>
                                    [/#if]
                                </td>
                                <td>
                                    <input type="hidden" id="price_1" value=6800 />
                                    ￥${cartItem.productInfo.price}
                                </td>
                                <td class="quantity" width="60">
                                    <input type="text" itemId="${cartItem.id}" id="quantity_1" oldValue="1" name="quantity" value="${cartItem.quantity}" maxlength="4" onpaste="return false;" />
                                    <div>
                                        <span class="increase">&nbsp;</span>
                                        <span class="decrease">&nbsp;</span>
                                    </div>
                                </td>
                                <td width="140">
                                    <input type="hidden" id="subtotal_27" value=6800 />
                                    <span class="subtotal">￥${cartItem.productInfo.price * cartItem.quantity}</span>
                                </td>
                                <td>
                                    <a href="javascript:;" class="delete">删除</a>
                                </td>
                            </tr>
                        [/#list]
                    [#else ]
                        <div>
                            <p>
                                <a href="${ctx}/index">您的购物车是空的，立即去商城逛逛</a>
                            </p>
                        <div>
                    [/#if]


                </table>
                [#if paginator.totalPages > 1]
                    <form action="${ctx}/cart/list" id="paginatorForm" >
                        <div class="pagination">
                            <input type="hidden" name="page" id="pageNumber" value="${paginator.page}" />
                            <input type="hidden" name="pageSize" value="${paginator.limit}" />
                            [#if paginator.isFirstPage()]
                                <span class="firstPage" >&nbsp;</span>
                            [#else]
                                <a href="javascript: $.pageSkip(1);" class="firstPage">&nbsp;</a>
                            [/#if]

                            [#if paginator.isHasPrePage()]
                                <a href="javascript: $.pageSkip(${paginator.prePage});" class="previousPage">&nbsp;</a>
                            [#else]
                                <span class="previousPage">&nbsp;</span>
                            [/#if]

                            [#list paginator.getSlider() as slider ]
                                [#if slider == paginator.page ]
                                    <span class="currentPage">${slider}</span>
                                [#else]
                                    <a href="javascript: $.pageSkip(${slider});">${slider}</a>
                                [/#if]
                            [/#list]

                            [#if paginator.hasNextPage]
                                <a href="javascript: $.pageSkip(${paginator.nextPage});" class="nextPage">&nbsp;</a>
                            [#else]
                                <span class="nextPage">&nbsp;</span>
                            [/#if]

                            [#if paginator.lastPage]
                                <span class="lastPage" >&nbsp;</span>
                            [#else]
                                <a href="javascript: $.pageSkip(${paginator.totalPages});" class="lastPage">&nbsp;</a>
                            [/#if]
                        </div>
                    </form>
                [/#if]

            </div>
        </div>
        [#if paginator.totalCount > 0]
            <div class="row">
                <div class="span6">
                    <dl id="gift" class="gift clearfix hidden">
                    </dl>
                </div>
                <div class="span6">
                    <div class="total">
                        <em id="promotion"></em>
                        <!--<em>登录后确认是否享有优惠</em>-->
                        赠送积分: <em id="effectiveRewardPoint">0</em>
                        商品金额: <strong id="effectivePrice">￥0.00元</strong>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="span12">
                    <div class="bottom">
                        <a href="javascript:;" id="clear" class="clear">清空购物车</a>
                        <a href="javascript:void(0)" id="submit" class="submit">提交订单</a>
                    </div>
                </div>
            </div>
        [/#if ]
    </div>

    [#include "include/footer.ftl"]

</body>
</html>