
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>苹果 iPhone 5s</title>
    <meta name="author" content="  苹果 iPhone 5s" />
    <meta name="copyright" content="  苹果 iPhone 5s" />
    <meta name="keywords" content="  苹果 iPhone 5s" />
    <meta name="description" content="  苹果 iPhone 5s" />
    <link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/goods.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="/js/jquery.js"></script>
    <script type="text/javascript" src="/js/jquery.tools.js"></script>
    <script type="text/javascript" src="/js/jquery.jqzoom.js"></script>
    <script type="text/javascript" src="/js/jquery.validate.js"></script>
    <script type="text/javascript" src="/js/common.js"></script>
    <script type="text/javascript">
        $().ready(function() {
            var $headerCart = $("#headerCart");
            var $historyGoods = $("#historyGoods");
            var $clearHistoryGoods = $("#historyGoods a.clear");
            var $zoom = $("#zoom");
            var $thumbnailScrollable = $("#thumbnailScrollable");
            var $thumbnail = $("#thumbnailScrollable a");
            var $dialogOverlay = $("#dialogOverlay");
            var $preview = $("#preview");
            var $previewClose = $("#preview a.close");
            var $previewScrollable = $("#previewScrollable");
            var $price = $("#price");
            var $marketPrice = $("#marketPrice");
            var $rewardPoint = $("#rewardPoint");
            var $exchangePoint = $("#exchangePoint");
            var $specificationTips = $("#specification div");
            var $specificationValue = $("#specification a");
            var $productNotifyForm = $("#productNotifyForm");
            var $productNotify = $("#productNotify");
            var $productNotifyEmail = $("#productNotify input");
            var $addProductNotify = $("#addProductNotify");
            var $quantity = $("#quantity");
            var $increase = $("#increase");
            var $decrease = $("#decrease");
            var $addCart = $("#addCart");
            var $exchange = $("#exchange");
            var $addFavorite = $("#addFavorite");
            var $window = $(window);
            var $bar = $("#bar ul");
            var $introductionTab = $("#introductionTab");
            var $parameterTab = $("#parameterTab");
            var $reviewTab = $("#reviewTab");
            var $consultationTab = $("#consultationTab");
            var $introduction = $("#introduction");
            var $parameter = $("#parameter");
            var $review = $("#review");
            var $addReview = $("#addReview");
            var $consultation = $("#consultation");
            var $addConsultation = $("#addConsultation");
            var barTop = $bar.offset().top;
            var barWidth = $bar.width();
            var productId = 1;
            var productData = {};
            productData["3,7"] = {
                id: 1,
                price: 4200,
                marketPrice: 5040,
                rewardPoint: 4200,
                exchangePoint: 0,
                availableStock: 97
            }
            productData["3,8"] = {
                id: 2,
                price: 4800,
                marketPrice: 5760,
                rewardPoint: 4800,
                exchangePoint: 0,
                availableStock: 79
            }
            productData["3,9"] = {
                id: 3,
                price: 5200,
                marketPrice: 6240,
                rewardPoint: 5200,
                exchangePoint: 0,
                availableStock: 100
            }
            productData["4,7"] = {
                id: 4,
                price: 4200,
                marketPrice: 5040,
                rewardPoint: 4200,
                exchangePoint: 0,
                availableStock: 98
            }
            productData["4,8"] = {
                id: 5,
                price: 4800,
                marketPrice: 5760,
                rewardPoint: 4800,
                exchangePoint: 0,
                availableStock: 100
            }
            productData["4,9"] = {
                id: 6,
                price: 5200,
                marketPrice: 6240,
                rewardPoint: 5200,
                exchangePoint: 0,
                availableStock: 34
            }
            productData["6,7"] = {
                id: 7,
                price: 4300,
                marketPrice: 5160,
                rewardPoint: 4300,
                exchangePoint: 0,
                availableStock: 99
            }
            productData["6,8"] = {
                id: 8,
                price: 4900,
                marketPrice: 5880,
                rewardPoint: 4900,
                exchangePoint: 0,
                availableStock: 0
            }

            // 锁定规格值
            lockSpecificationValue();

            $zoom.jqzoom({
                zoomWidth: 368,
                zoomHeight: 368,
                title: false,
                preloadText: null,
                preloadImages: false
            });

            // 商品缩略图滚动
            $thumbnailScrollable.scrollable();

            $thumbnail.hover(function() {
                var $this = $(this);
                if ($this.hasClass("current")) {
                    return false;
                }
                $thumbnail.removeClass("current");
                $this.addClass("current").click();
            });

            var previewScrollable = $previewScrollable.scrollable({
                keyboard: true
            });

            // 商品图片预览
            $zoom.click(function() {
                $preview.show().find("img[data-original]").each(function() {
                    var $this = $(this);
                    $this.attr("src", $this.attr("data-original")).removeAttr("data-original");
                });
                previewScrollable.data("scrollable").seekTo($thumbnail.filter(".current").index(), 0);
                $dialogOverlay.show(); // 调用弹窗
                return false;
            });

            $previewClose.click(function() {
                $preview.hide();
                $dialogOverlay.hide();
            });

            // 规格值选择
            $specificationValue.click(function() {
                var $this = $(this);
                if ($this.hasClass("locked")) {
                    return false;
                }
//                if ($this.hasClass("selected")) {
//                    $this.removeClass("selected");
//                } else {
//                    $this.addClass("selected");
//                }
                $this.toggleClass("selected").parent().siblings().children("a").removeClass("selected"); //
                lockSpecificationValue();
                return false;
            });

            // 锁定规格值
            function lockSpecificationValue() {
//                var currentSpecificationValueIds = $specification.map(function() {
//                    $selected = $(this).find("a.selected");
//                    return $selected.size() > 0 ? $selected.attr("val") : [null];
//                }).get();
                var currentSpecificationValueIds = [];
                $("#specification dl").each(function () {
                    var selectedA = $(this).find("a.selected");
                    var id = selectedA.attr("val"); // 获取选择规格项的ID
                    currentSpecificationValueIds.push(id);
                });
//                $specification.each(function () {
//                    var val = $(this).find("a.selected").attr('val');
//                    currentSpecificationValueIds.push(val);
//                });

                console.log("currentSpecificationValueIds: "+ currentSpecificationValueIds); // 6,7

                $("#specification dl").each(function(i) { // i=1
                    $(this).find("a").each(function(j) { // 银色 -- 灰色 -- 金色
                        var $this = $(this); // 获取到a标签
                        var specificationValueIds = currentSpecificationValueIds.slice(0); // ==substring
                        specificationValueIds[i] = $this.attr("val"); // 3,7 / 4,7/ 6,7; 6,7/6,8/6,9
                        if (isValid(specificationValueIds)) {
                            $this.removeClass("locked");
                        } else {
                            $this.addClass("locked");
                        }
                    });
                });
                var product = productData[currentSpecificationValueIds.join(",")];
                if (product != null) {
                    productId = product.id;
                    $price.text(currency(product.price, true));
                    $marketPrice.text(currency(product.marketPrice, true));
                    $rewardPoint.text(product.rewardPoint);
                    $exchangePoint.text(product.exchangePoint);
                    if (product.availableStock  < 1) {
                        if ($addProductNotify.val() == "确定登记") {
                            $productNotify.show();
                        }
                        $addProductNotify.show();
                        $quantity.closest("dl").hide();
                        $addCart.hide();
                        $exchange.hide();
                    } else {
                        $productNotify.hide();
                        $addProductNotify.hide();
                        $quantity.closest("dl").show();
                        $addCart.show();
                        $exchange.show();
                    }
                } else {
                    productId = null;
                }
            }

            // 判断规格值ID是否有效
            function isValid(specificationValueIds) {
                for(var key in productData) { // key是3,7;3,8;3,9
                    var ids = key.split(","); // 变成数组
                    if (match(specificationValueIds, ids)) {
                        return true;
                    }
                }
                return false;
            }

            // 判断数组是否配比
            function match(array1, array2) {
                if (array1.length != array2.length) {
                    return false;
                }
                for(var i = 0; i < array1.length; i ++) {
                    if (array1[i] != null && array2[i] != null && array1[i] != array2[i]) {
                        return false;
                    }
                }
                return true;
            }

            // 到货通知
            $addProductNotify.click(function() {
                if (productId == null) {
                    $specificationTips.fadeIn(150).fadeOut(150).fadeIn(150);
                    return false;
                }
                if ($addProductNotify.val() == "到货通知我") {
                    $addProductNotify.val("确定登记");
                    $productNotify.show();
                    $productNotifyEmail.focus();
                    if ($.trim($productNotifyEmail.val()) == "") {
                        $.ajax({
                            url: "/product_notify/email",
                            type: "GET",
                            dataType: "json",
                            cache: false,
                            success: function(data) {
                                $productNotifyEmail.val(data.email);
                            }
                        });
                    }
                } else {
                    $productNotifyForm.submit();
                }
                return false;
            });

            // 到货通知表单验证
            $productNotifyForm.validate({
                rules: {
                    email: {
                        required: true,
                        email: true
                    }
                },
                submitHandler: function(form) {
                    $.ajax({
                        url: "/shopxx/product_notify/save.jhtml",
                        type: "POST",
                        data: {productId: productId, email: $productNotifyEmail.val()},
                        dataType: "json",
                        cache: false,
                        beforeSend: function() {
                            $addProductNotify.prop("disabled", true);
                        },
                        success: function(data) {
                            if (data.message.type == "success") {
                                $addProductNotify.val("到货通知我");
                                $productNotify.hide();
                            }
                            $.message(data.message);
                        },
                        complete: function() {
                            $addProductNotify.prop("disabled", false);
                        }
                    });
                }
            });

            // 购买数量
            $quantity.keypress(function(event) {
                return (event.which >= 48 && event.which <= 57) || event.which == 8;
            });

            // 增加购买数量
            $increase.click(function() {
                var quantity = $quantity.val();
                if (/^\d*[1-9]\d*$/.test(quantity)) {
                    $quantity.val(parseInt(quantity) + 1);
                } else {
                    $quantity.val(1);
                }
            });

            // 减少购买数量
            $decrease.click(function() {
                var quantity = $quantity.val();
                if (/^\d*[1-9]\d*$/.test(quantity) && parseInt(quantity) > 1) {
                    $quantity.val(parseInt(quantity) - 1);
                } else {
                    $quantity.val(1);
                }
            });

            // 加入购物车
            $addCart.click(function() {
                if (productId == null) {
                    $specificationTips.fadeIn(150).fadeOut(150).fadeIn(150);
                    return false;
                }
                var quantity = $quantity.val();
                if (!/^\d*[1-9]\d*$/.test(quantity)) {
                    $.message("warn", "购买数量必须为正整数");
                    return false;
                }

                $.ajax({
                    url: "/cart/add",
                    type: "POST",
                    data: {productId: productId, quantity: quantity},
                    dataType: "json",
                    cache: false,
                    success: function(message) {
                        if(message.resultCode == 0) { // 失败
                            $.message("warn", message.resultMessage);
                            return false;
                        }
                        if(message.resultCode == -1) { // 未登录
                            $.message("warn", message.resultMessage);
                            setTimeout(function() {
                                toRegisterLogin("login");
                            }, 1000);
                            return false;
                        }
                        // 动画效果
                        var $image = $zoom.find("img");
                        var cartOffset = $headerCart.offset();
                        var imageOffset = $image.offset();
                        $image.clone().css({
                            width: 300,
                            height: 300,
                            position: "absolute",
                            "z-index": 20,
                            top: imageOffset.top,
                            left: imageOffset.left,
                            opacity: 0.8,
                            border: "1px solid #dddddd",
                            "background-color": "#eeeeee"
                        }).appendTo("body").animate({
                            width: 30,
                            height: 30,
                            top: cartOffset.top,
                            left: cartOffset.left,
                            opacity: 0.2
                        }, 1000, function() {
                            $(this).remove();
                        });
                        var $totalQuanityEm = $("#headerCart").find('em');
                        var totalQuanity = parseInt($totalQuanityEm.html()); // 获取显示的数字
                        $totalQuanityEm.html(totalQuanity + parseInt(quantity)); // 重新赋值
                        $.message('success', message.result);
                    }
                });
            });

            // 添加商品收藏
            $addFavorite.click(function() {
                $.ajax({
                    url: "/favorite/add",
                    type: "POST",
                    data: {goodsId: 1},
                    dataType: "json",
                    cache: false,
                    success: function(message) {
                        $.message(message);
                    }
                });
                return false;
            });

            $bar.width(barWidth);

            $window.scroll(function() {
                var scrollTop = $(this).scrollTop();
                if (scrollTop > barTop) {
                    $bar.addClass("fixed");
                    var introductionTop = $introduction.size() > 0 ? $introduction.offset().top - 36 : null;
                    var parameterTop = $parameter.size() > 0 ? $parameter.offset().top - 36 : null;
                    var reviewTop = $review.size() > 0 ? $review.offset().top - 36 : null;
                    var consultationTop = $consultation.size() > 0 ? $consultation.offset().top - 36 : null;
                    if (consultationTop != null && scrollTop >= consultationTop) {
                        $bar.find("li").removeClass("current");
                        $consultationTab.addClass("current");
                    } else if (reviewTop != null && scrollTop >= reviewTop) {
                        $bar.find("li").removeClass("current");
                        $reviewTab.addClass("current");
                    } else if (parameterTop != null && scrollTop >= parameterTop) {
                        $bar.find("li").removeClass("current");
                        $parameterTab.addClass("current");
                    } else if (introductionTop != null && scrollTop >= introductionTop) {
                        $bar.find("li").removeClass("current");
                        $introductionTab.addClass("current");
                    }
                } else {
                    $bar.removeClass("fixed").find("li").removeClass("current");
                }
            });

            // 发表商品评论
            $addReview.click(function() {
                if ($.checkLogin()) {
                    return true;
                } else {
                    $.redirectLogin("/review/add/1", "必须登录后才能发表商品评论");
                    return false;
                }
            });

            // 发表商品咨询
            $addConsultation.click(function() {
                if ($.checkLogin()) {
                    return true;
                } else {
                    $.redirectLogin("/consultation/add/1", "必须登录后才能发表商品咨询");
                    return false;
                }
            });

            // 浏览记录
            var historyGoods = getCookie("historyGoods");
            var historyGoodsIds = historyGoods != null ? historyGoods.split(",") : [];
            for (var i = 0; i < historyGoodsIds.length; i ++) {
                if (historyGoodsIds[i] == 2) {
                    historyGoodsIds.splice(i, 1);
                    break;
                }
            }
            historyGoodsIds.unshift(2);
            if (historyGoodsIds.length > 6) {
                historyGoodsIds.pop();
            }
            addCookie("historyGoods", historyGoodsIds.join(","));
            $.ajax({
                url: "/shopxx/goods/history.jhtml",
                type: "GET",
                data: {goodsIds: historyGoodsIds},
                dataType: "json",
                cache: true,
                success: function(data) {
                    $.each(data, function (i, item) {
                        var thumbnail = item.thumbnail != null ? item.thumbnail : "/shopxx/upload/image/default_thumbnail.jpg";
                        $historyGoods.find("dt").after(
                                '<dd> <img src="' + escapeHtml(thumbnail) + '" \/> <a href="' + escapeHtml(item.url) + '" title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 30)) + '<\/a> <strong>' + currency(item.price, true) + '<\/strong> <\/dd>'				);
                    });
                }
            });

            // 清空浏览记录
            $clearHistoryGoods.click(function() {
                $historyGoods.remove();
                removeCookie("historyGoods");
            });

            // 点击数
            $.ajax({
                url: "/goods/hits/",
                type: "GET",
                cache: true
            });

        });
    </script>
</head>
<body>
<div id="dialogOverlay" class="dialogOverlay"></div>

<div class="header">
    <div class="top">
        <div class="topNav">
            <ul class="left">
                <li>
                    <span>您好，欢迎来到商HAI购</span>
                </li>
                <li id="headerLogin" class="headerLogin" style="display:block;">
                    <a href="javascript:toRegisterLogin('login')">登录</a>|
                </li>
                <li id="headerRegister" class="headerRegister" style="display:block;">
                    <a href="javascript:toRegisterLogin('register')">注册</a>
                </li>

            </ul>
            <ul class="right">
                <li>
                    <a href="/member/index.jhtml"  >
                        会员中心
                    </a>|
                </li>
                <li>
                    <a href="/article/list/3"  >
                        帮助中心
                    </a>|
                </li>
                <li id="headerCart" class="headerCart">
                    <a href="/cart/list">购物车</a>
                    (<em>0</em>)
                </li>
            </ul>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="span3">
                <a href="/index">
                    <img src="/upload/image/logo.gif" alt="尚HAI购" />
                </a>
            </div>
            <div class="span6">
                <div class="search">
                    <form id="goodsSearchForm" action="/goods/search" method="get">
                        <input name="keyword" class="keyword" placeholder="商品搜索" value="" autocomplete="off" x-webkit-speech="x-webkit-speech" x-webkit-grammar="builtin:search" maxlength="30" />
                        <button type="submit">&nbsp;</button>
                    </form>
                </div>
                <div class="hotSearch">
                    热门搜索:
                    <a href="/goods/search?keyword=苹果">苹果</a>
                    <a href="/goods/search?keyword=三星">三星</a>
                    <a href="/goods/search?keyword=索尼">索尼</a>
                    <a href="/goods/search?keyword=华为">华为</a>
                    <a href="/goods/search?keyword=魅族">魅族</a>
                    <a href="/goods/search?keyword=佳能">佳能</a>
                    <a href="/goods/search?keyword=华硕">华硕</a>
                    <a href="/goods/search?keyword=美的">美的</a>
                    <a href="/goods/search?keyword=格力">格力</a>
                    <a href="/goods/search?keyword=小米">小米</a>

                </div>
            </div>
            <div class="span3">
                <div class="phone">
                    <em>服务电话</em>
                    800-8888888
                </div>
            </div>
        </div>
        <div class="row">
            <div class="span12">
                <dl class="mainNav">
                    <dt>
                        <a href="/product_category">所有商品分类</a>
                    </dt>
                    <dd>
                        <a href="/" >
                            首页
                        </a>
                    </dd>
                    <dd>
                        <a href="/goods/list/1" >
                            手机数码
                        </a>
                    </dd>
                    <dd>
                        <a href="/goods/list/2.jhtml" >
                            电脑办公
                        </a>
                    </dd>
                    <dd>
                        <a href="/goods/list/3.jhtml" >
                            家用电器
                        </a>
                    </dd>
                    <dd>
                        <a href="/goods/list/4.jhtml" >
                            服装鞋靴
                        </a>
                    </dd>
                    <dd>
                        <a href="/goods/list/5.jhtml" >
                            化妆护理
                        </a>
                    </dd>
                    <dd>
                        <a href="/goods/list/241.jhtml" >
                            积分商城
                        </a>
                    </dd>
                </dl>
            </div>
        </div>
    </div>
</div>
<script>
    // 跳转登录
    function toRegisterLogin(url) {
        var redirectUrl = window.location.href;
        console.log(redirectUrl);
        window.location.href = "${ctx}"+ url +"?redirectUrl=" + encodeURIComponent(redirectUrl); //&
        <#--if (redirectUrl.indexOf("/login") > -1 || redirectUrl.indexOf("/register") > -1) {-->
            <#--window.location.href = "${ctx}"+ url;-->
        <#--} else {-->
            <#--window.location.href = "${ctx}"+ url +"?redirectUrl=" + encodeURIComponent(redirectUrl);-->
        <#--}-->
    }

    /**
     * 退出
     */
    function logout() {
        $.post("/logout",{}, function() {
            window.location.reload();
        })
    }

</script>
<div class="container goodsContent">
    <div class="row">
        <div class="span2">
            <div class="hotProductCategory">
                <dl class="odd clearfix">
                    <dt>
                        <a href="/goods/list/1">手机数码</a>
                    </dt>
                    <dd>
                        <a href="/goods/list/7">手机通讯</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/8">手机配件</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/9">摄影摄像</a>
                    </dd>
                </dl>
                <dl class="odd clearfix">
                    <dt>
                        <a href="/goods/list/2">电脑办公</a>
                    </dt>
                    <dd>
                        <a href="/goods/list/14">电脑整机</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/15">电脑配件</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/16">电脑外设</a>
                    </dd>
                </dl>
                <dl class="odd clearfix">
                    <dt>
                        <a href="/goods/list/3">家用电器</a>
                    </dt>
                    <dd>
                        <a href="/goods/list/21">生活电器</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/22">厨卫电器</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/23">个护健康</a>
                    </dd>
                </dl>
                <dl class="odd clearfix">
                    <dt>
                        <a href="/goods/list/4">服装鞋靴</a>
                    </dt>
                    <dd>
                        <a href="/goods/list/26">品质男装</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/27">时尚女装</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/28">精品内衣</a>
                    </dd>
                </dl>
                <dl class="odd clearfix">
                    <dt>
                        <a href="/goods/list/5">化妆护理</a>
                    </dt>
                    <dd>
                        <a href="/goods/list/31">面部护肤</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/32">身体护肤</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/33">口腔护理</a>
                    </dd>
                </dl>
                <dl class="odd clearfix">
                    <dt>
                        <a href="/goods/list/6">家居家装</a>
                    </dt>
                    <dd>
                        <a href="/goods/list/36">家纺布艺</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/37">家居照明</a>
                    </dd>
                    <dd>
                        <a href="/goods/list/38">家装建材</a>
                    </dd>
                </dl>
            </div>        </div>
        <div class="span10">
            <div class="breadcrumb">
                <ul>
                    <li>
                        <a href="/index">首页</a>
                    </li>
                    <li><a href="/goods/list/1">手机数码</a></li>
                    <li><a href="/goods/list/7">手机通讯</a></li>
                    <li>手机</li>
                </ul>
            </div>

            <div class="productImage">

                <a href="http://image.demo.shopxx.net/4.0/201501/e39f89ce-e08a-4546-8aee-67d4427e86e2-large.jpg" id="zoom" rel="gallery">
                    <img class="medium" src="http://image.demo.shopxx.net/4.0/201501/e39f89ce-e08a-4546-8aee-67d4427e86e2-medium.jpg"  />
                </a>
                <a href="javascript:;" class="prev">&nbsp;</a>
                <div id="thumbnailScrollable" class="scrollable">
                    <div class="items">
                        <a class="current" href="javascript:;" rel="{gallery: 'gallery', smallimage: 'http://image.demo.shopxx.net/4.0/201501/e39f89ce-e08a-4546-8aee-67d4427e86e2-thumbnail.jpg', largeimage: 'http://image.demo.shopxx.net/4.0/201501/e39f89ce-e08a-4546-8aee-67d4427e86e2-large.jpg'}">
                            <img src="http://image.demo.shopxx.net/4.0/201501/e39f89ce-e08a-4546-8aee-67d4427e86e2-thumbnail.jpg" title="" />
                        </a>
                        <a  href="javascript:;" rel="{gallery: 'gallery', smallimage: 'http://image.demo.shopxx.net/4.0/201501/00705b09-2f7c-438b-b0a2-cbe236c1407d-thumbnail.jpg', largeimage: 'http://image.demo.shopxx.net/4.0/201501/00705b09-2f7c-438b-b0a2-cbe236c1407d-large.jpg'}">
                            <img src="http://image.demo.shopxx.net/4.0/201501/00705b09-2f7c-438b-b0a2-cbe236c1407d-thumbnail.jpg" title="" />
                        </a>
                    </div>
                </div>
                <a href="javascript:;" class="next">&nbsp;</a>
            </div>

            <div id="preview" class="preview">
                <a href="javascript:;" class="close">&nbsp;</a>
                <a href="javascript:;" class="prev">&nbsp;</a>
                <div id="previewScrollable" class="scrollable">
                    <div class="items">
                        <img src="/upload/image/blank.gif" data-original="http://image.demo.shopxx.net/4.0/201501/e39f89ce-e08a-4546-8aee-67d4427e86e2-large.jpg" title="" />
                        <img src="/upload/image/blank.gif" data-original="http://image.demo.shopxx.net/4.0/201501/00705b09-2f7c-438b-b0a2-cbe236c1407d-large.jpg" title="" />
                    </div>
                </div>
                <a href="javascript:;" class="next">&nbsp;</a>
            </div>
            <div class="info">
                <h1>
                    苹果 iPhone 5s
                    <em>铝金属外壳，64位智能手机，畅享3G/4G网络</em>
                </h1>
                <dl>
                    <dt>编号:</dt>
                    <dd>
                        20150101101
                    </dd>
                </dl>

                <dl>
                    <dt>销售价:</dt>
                    <dd>
                        <strong id="price">￥4200</strong>
                    </dd>
                    <dd>
                            <span>
                                (<em>市场价:</em>
                                <del id="marketPrice">￥5040</del>)
                            </span>
                    </dd>
                </dl>

                <dl>
                    <dt>赠送积分:</dt>
                    <dd id="rewardPoint">
                        4200
                    </dd>
                </dl>
            </div>
            <div class="action">
                <div id="specification" class="specification clearfix">
                    <div class="title">请选择商品规格</div>
                    <dl>
                        <dt>
                            <span title="颜色">颜色:</span>
                        </dt>
                        <dd>
                            <a href="javascript:;" val="3"  class="selected" >
                                银色<span title="点击取消选择">&nbsp;</span>
                            </a>
                        </dd>
                        <dd>
                            <a href="javascript:;" val="4"  >
                                灰色<span title="点击取消选择">&nbsp;</span>
                            </a>
                        </dd>
                        <dd>
                            <a href="javascript:;" val="6"  >
                                金色<span title="点击取消选择">&nbsp;</span>
                            </a>
                        </dd>
                    </dl>
                    <dl>
                        <dt>
                            <span title="内存容量">内存容量:</span>
                        </dt>
                        <dd>
                            <a href="javascript:;" val="7"  class="selected" >
                                16GB<span title="点击取消选择">&nbsp;</span>
                            </a>
                        </dd>
                        <dd>
                            <a href="javascript:;" val="8"  >
                                32GB<span title="点击取消选择">&nbsp;</span>
                            </a>
                        </dd>
                        <dd>
                            <a href="javascript:;" val="9"  >
                                64GB<span title="点击取消选择">&nbsp;</span>
                            </a>
                        </dd>
                    </dl>
                </div>

                <form id="productNotifyForm" action="/product_notify/save" method="post">
                    <dl id="productNotify" class="productNotify hidden">
                        <dt>您的E-mail:</dt>
                        <dd>
                            <input type="text" name="email" maxlength="200" />
                        </dd>
                    </dl>
                </form>
                <dl class="quantity">
                    <dt>数量:</dt>
                    <dd>
                        <input type="text" id="quantity" name="quantity" value="1" maxlength="4" onpaste="return false;" />
                        <div>
                            <span id="increase" class="increase">&nbsp;</span>
                            <span id="decrease" class="decrease">&nbsp;</span>
                        </div>
                    </dd>
                    <dd>
                        台
                    </dd>
                </dl>
                <div class="buy">
                    <input type="button" id="addProductNotify" class="addProductNotify hidden" value="到货通知我" />
                    <input type="button" id="addCart" class="addCart" value="加入购物车" />
                    <a href="javascript:;" id="addFavorite">收藏</a>
                </div>
            </div>
            <div class="share">
                <div id="bdshare" class="bdshare_t bds_tools get-codes-bdshare">
                    <a class="bds_qzone"></a>
                    <a class="bds_tsina"></a>
                    <a class="bds_tqq"></a>
                    <a class="bds_renren"></a>
                    <a class="bds_t163"></a>
                    <span class="bds_more"></span>
                    <a class="shareCount"></a>
                </div>
            </div>
            <div id="bar" class="bar">
                <ul>
                    <li id="introductionTab">
                        <a href="#introduction">商品介绍</a>
                    </li>
                    <li id="parameterTab">
                        <a href="#parameter">商品参数</a>
                    </li>
                    <li id="reviewTab">
                        <a href="#review">商品评论</a>
                    </li>
                    <li id="consultationTab">
                        <a href="#consultation">商品咨询</a>
                    </li>
                </ul>
            </div>
            <div id="introduction" name="introduction" class="introduction">
                <div class="title">
                    <strong>商品介绍</strong>
                </div>
                <div>
                    <p><img src="http://image.demo.shopxx.net/4.0/201501/65feeba6-e840-486d-a617-7ebe77d1b244.png"/></p>
                </div>
            </div>
            <div id="parameter" name="parameter" class="parameter">
                <div class="title">
                    <strong>商品参数</strong>
                </div>
                <table>
                    <tr>
                        <th class="group" colspan="2">基本参数</th>
                    </tr>
                    <tr>
                        <th>操作系统</th>
                        <td>iOS</td>
                    </tr>
                    <tr>
                        <th>CPU频率</th>
                        <td>1.3GHz</td>
                    </tr>
                    <tr>
                        <th>核心数</th>
                        <td>双核</td>
                    </tr>
                    <tr>
                        <th>电池类型</th>
                        <td>锂电池</td>
                    </tr>
                    <tr>
                        <th class="group" colspan="2">显示</th>
                    </tr>
                    <tr>
                        <th>屏幕尺寸</th>
                        <td>4.0英寸</td>
                    </tr>
                    <tr>
                        <th>触摸屏类型</th>
                        <td>电容屏、多点触控</td>
                    </tr>
                    <tr>
                        <th>分辨率</th>
                        <td>1136 x 640</td>
                    </tr>
                    <tr>
                        <th class="group" colspan="2">存储</th>
                    </tr>
                    <tr>
                        <th>运行内存</th>
                        <td>1GB</td>
                    </tr>
                    <tr>
                        <th>机身内存</th>
                        <td>16GB</td>
                    </tr>

                </table>
            </div>
            <div id="review" name="review" class="review">
                <div class="title">商品评论</div>
                <div class="content clearfix">
                    <p>
                        暂无商品评论信息 <a href="/review/add/1" id="addReview">[发表商品评论]</a>
                    </p>
                </div>
            </div>
            <div id="consultation" name="consultation" class="consultation">
                <div class="title">商品咨询</div>
                <div class="content">
                    <p>
                        暂无商品咨询信息 <a href="/consultation/add/1" id="addConsultation">[发表商品咨询]</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <div class="service clearfix">
        <dl>
            <dt class="icon1">新手指南</dt>
            <dd>
                <a href="#">购物流程</a>
            </dd>
            <dd>
                <a href="#">会员注册</a>
            </dd>
            <dd>
                <a href="#">购买宝贝</a>
            </dd>
            <dd>
                <a href="#">支付货款</a>
            </dd>
            <dd>
                <a href="#">用户协议</a>
            </dd>
        </dl>
        <dl>
            <dt class="icon2">特色服务</dt>
            <dd>
                <a href="#">购物流程</a>
            </dd>
            <dd>
                <a href="#">会员注册</a>
            </dd>
            <dd>
                <a href="#">购买宝贝</a>
            </dd>
            <dd>
                <a href="#">支付货款</a>
            </dd>
            <dd>
                <a href="#">用户协议</a>
            </dd>
        </dl>
        <dl>
            <dt class="icon3">支付方式</dt>
            <dd>
                <a href="#">购物流程</a>
            </dd>
            <dd>
                <a href="#">会员注册</a>
            </dd>
            <dd>
                <a href="#">购买宝贝</a>
            </dd>
            <dd>
                <a href="#">支付货款</a>
            </dd>
            <dd>
                <a href="#">用户协议</a>
            </dd>
        </dl>
        <dl>
            <dt class="icon4">配送方式</dt>
            <dd>
                <a href="#">购物流程</a>
            </dd>
            <dd>
                <a href="#">会员注册</a>
            </dd>
            <dd>
                <a href="#">购买宝贝</a>
            </dd>
            <dd>
                <a href="#">支付货款</a>
            </dd>
            <dd>
                <a href="#">用户协议</a>
            </dd>
        </dl>
        <div class="qrCode">
            <img src="/images/qr_code.gif" alt="官方微信" />
            官方微信
        </div>
    </div>
    <div class="bottom">
        <div class="bottom">
            <div class="bottomNav">
                <ul>

                    <li>
                        <a href="#"  >
                            关于我们
                        </a>|
                    </li>
                    <li>
                        <a href="#"  >
                            联系我们
                        </a>|
                    </li>
                    <li>
                        <a href="#"  >
                            诚聘英才
                        </a>|
                    </li>
                    <li>
                        <a href="#"  >
                            隐私政策
                        </a>|
                    </li>
                    <li>
                        <a href="#"  >
                            法律声明
                        </a>|
                    </li>
                    <li>
                        <a href="#"  >
                            客户服务
                        </a>|
                    </li>
                    <li>
                        <a href="/friend_link.jhtml"  >
                            友情链接
                        </a>
                    </li>
                </ul>
            </div>
            <div class="info">
                <p>湘ICP备10000000号</p>
                <p>Copyright © 2005-2017尚HAI购商城 版权所有</p>
                <ul>
                    <li>
                        <a href="http://www.shopxx.net" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/1c675feb-e488-4fd5-a186-b28bb6de445a.gif" alt="SHOP++">
                        </a>
                    </li>
                    <li>
                        <a href="http://www.alipay.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/ae13eddc-25ac-427a-875d-d1799d751076.gif" alt="支付宝">
                        </a>
                    </li>
                    <li>
                        <a href="http://www.tenpay.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/adaa9ac5-9994-4aa3-a336-b65613c85d50.gif" alt="财付通">
                        </a>
                    </li>
                    <li>
                        <a href="https://www.95516.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/41c18c8d-f69a-49fe-ace3-f16c2eb07983.gif" alt="中国银联">
                        </a>
                    </li>
                    <li>
                        <a href="http://www.kuaidi100.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/ea46ca0a-e8f0-4e2c-938a-5cb19a07cb9a.gif" alt="快递100">
                        </a>
                    </li>
                    <li>
                        <a href="http://www.cnzz.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/e12f226b-07f9-4895-bcc2-78dbe551964b.gif" alt="站长统计">
                        </a>
                    </li>
                    <li>
                        <a href="http://down.admin5.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/fd9d6268-e4e2-41f6-856d-4cb8a49eadd1.gif" alt="A5下载">
                        </a>
                    </li>
                    <li>
                        <a href="http://www.ccb.com" target="_blank">
                            <img src="http://image.demo.shopxx.net/4.0/201501/6c57f398-0498-4044-80d8-20f6c40d5cef.gif" alt="中国建设银行">
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div><script type="text/javascript" id="bdshare_js" data="type=tools&amp;uid=0"></script>
<script type="text/javascript" id="bdshell_js"></script>
<script type="text/javascript">
    document.getElementById("bdshell_js").src = "http://bdimg.share.baidu.com/static/js/shell_v2.js?cdnversion=" + Math.ceil(new Date() / 3600000)
</script>
</body>
</html>