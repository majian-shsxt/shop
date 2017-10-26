<!DOCTYPE html >
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>商品列表</title>
    <link href="${ctx}/css/common.css" rel="stylesheet" type="text/css" />
    <link href="${ctx}/css/goods.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src="${ctx}/js/jquery.js"></script>
    <script type="text/javascript" src="${ctx}/js/jquery.lazyload.js"></script>
    <script type="text/javascript" src="${ctx}/js/common.js"></script>
    <script type="text/javascript">
        $().ready(function() {

            var $headerCart = $("#headerCart");
            var $goodsForm = $("#goodsForm");
            var $orderType = $("#orderType");
            var $pageNumber = $("#pageNumber");
            var $pageSize = $("#pageSize");
            var $gridType = $("#gridType");
            var $listType = $("#listType");
            var $size = $("#layout a.size"); // #id 标签 class
            $size.click(function() {
                var pageSize = $(this).attr('pagesize');
                $pageSize.val(pageSize);
                // form提交
                $goodsForm.submit();
            });
            var $previousPage = $("#previousPage");
            var $nextPage = $("#nextPage");
            var $sort = $("#sort a, #sort li");
            var $orderMenu = $("#orderMenu");
            var $startPrice = $("#startPrice");
            var $endPrice = $("#endPrice");
            var $result = $("#result");
            var $productImage = $("#result img");
            var $addCart = $("#result a.addCart");

            var layoutType = getCookie("layoutType");
            if (layoutType == "listType") {
                $listType.addClass("currentList");
                $result.removeClass("grid").addClass("list");
            } else {
                $gridType.addClass("currentGrid");
                $result.removeClass("list").addClass("grid");
            }

            $gridType.click(function() {
                var $this = $(this);
                if (!$this.hasClass("currentGrid")) {
                    $this.addClass("currentGrid");
                    $listType.removeClass("currentList");
                    $result.removeClass("list").addClass("grid");
                    addCookie("layoutType", "gridType");
                }
                return false;
            });

            $listType.click(function() {
                var $this = $(this);
                if (!$this.hasClass("currentList")) {
                    $this.addClass("currentList");
                    $gridType.removeClass("currentGrid");
                    $result.removeClass("grid").addClass("list");
                    addCookie("layoutType", "listType");
                }
                return false;
            });
            $previousPage.click(function() {
                $pageNumber.val(${paginator.prePage});
                $goodsForm.submit();
                return false;
            });

            $nextPage.click(function() {
                $pageNumber.val(${paginator.nextPage});
                $goodsForm.submit();
                return false;
            });

            $orderMenu.hover(
                    function() {
                        $(this).children("ul").show();
                    }, function() {
                        $(this).children("ul").hide();
                    }
            );

            $sort.click(function() {
               var sort = '';
               if (!$(this).hasClass('current')) {
                   sort = $(this).attr("ordertype");
               }
               $("#orderType").val(sort);
               // 提交
                $("#pageNumber").val(1);
                $goodsForm.submit();
            });

            $startPrice.add($endPrice).focus(function() {
                $(this).siblings("button").show();
            });

            $startPrice.add($endPrice).keypress(function(event) {
                return (event.which >= 48 && event.which <= 57) || (event.which == 46 && $(this).val().indexOf(".") < 0) || event.which == 8 || event.which == 13;
            });

            $goodsForm.submit(function() {
                if ($orderType.val() == "" || $orderType.val() == "topDesc") {
                    $orderType.prop("disabled", true);
                }
                if ($pageNumber.val() == "" || $pageNumber.val() == "1") {
                    $pageNumber.prop("disabled", true);
                }
                if ($startPrice.val() == "" || !/^\d+(\.\d+)?$/.test($startPrice.val())) {
                    $startPrice.prop("disabled", true);
                }
                if ($endPrice.val() == "" || !/^\d+(\.\d+)?$/.test($endPrice.val())) {
                    $endPrice.prop("disabled", true);
                }
                if ($goodsForm.serializeArray().length < 1) {
                    location.href = location.pathname;
                    return false;
                }
            });

            $productImage.lazyload({
                threshold: 100,
                effect: "fadeIn"
            });

            // 加入购物车
            $addCart.click(function() {
                var $this = $(this);
                var goodId = $this.attr("goodId");
                $.ajax({
                    url: "${ctx}/cart/add",
                    type: "POST",
                    data: {goodId: goodId, quantity: 1},
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
                        var $image = $this.closest("li").find("img");
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
                        var $totalQuantityEm = $("#headerCart").find('em');
                        var totalQuantity = parseInt($totalQuantityEm.html()); // 获取显示的数字
                        $totalQuantityEm.html(totalQuantity + 1); // 重新赋值
                        //$.message('success', message.result);
                    }
                });
                return false;
            });

            $.pageSkip = function(pageNumber) {
                $pageNumber.val(pageNumber);
                $goodsForm.submit();
                return false;
            }

            // 点击属性进行查询
            $(".attribute").click(function() {
                var propertyIndex = $(this).attr('id');
                var attr = '';
                if (!$(this).hasClass('current')) {
                    attr = $(this).html();
                }
                $("#attributeValue" + propertyIndex).val(attr);
                $("#pageNumber").val(1);
                $("#goodsForm").submit();
            });
            
            // 点击品牌名称进行搜素
            $(".brand").click(function () {
                var brandId = $(this).attr("brandid");
                $("#brandId").val(brandId);
                $("#pageNumber").val(1);
                $("#goodsForm").submit();
            });
        });
    </script>
</head>
<body>

[#include "include/header.ftl"]

<div class="container goodsList">
    <div class="row">
        <div class="span2">
            <div class="hotProductCategory">
                [#--根级分类展示--]
                [@product_category_root_list]
                    [#list productCategories as productCategory]
                        <dl class="odd clearfix">
                            <dt>
                                <a href="${ctx}/goods/list/${productCategory.id}">${productCategory.name}</a>
                            </dt>

                            [@product_category_children_list parentId = productCategory.id ]
                                [#list productCategories as productCategory]
                                    <dd>
                                        <a href="${ctx}/goods/list/${productCategory.id}">${productCategory.name}</a>
                                    </dd>
                                [/#list]
                            [/@product_category_children_list]
                        </dl>
                    [/#list]
                [/@product_category_root_list]
            </div>

            <div class="hotBrand clearfix">
                <dl>
                    <dt>热门品牌</dt>
                    [@brand_list count=6 productCategoryId=productCategory.id ]
                        [#list brands as brand]
                            <dd [#if (brand_index + 1) % 2 ==0 ]class="even"[/#if] >
                                <a href="${ctx}/brand/${brand.id}" title="${brand.name}">
                                    <img src="${brand.logo}" alt="${brand.name}" />
                                    <span>${brand.name}</span>
                                </a>
                            </dd>
                        [/#list]
                    [/@brand_list]
                </dl>
            </div>

            <div class="hotGoods">
                <dl>
                    <dt>热销商品</dt>
                    [@goods_list count=3 productCategoryId=productCategory.id]
                        [#list goods as good ]
                            <dd>
                                <a href="${ctx}/goods/detail/${good.id}" title="${good.name}">
                                    <img src="${good.image}" alt="${good.name}" />
                                    <span title="${good.name}">${good.name}</span>
                                </a>
                                <strong>
                                    ￥${good.price}
                                    <del>￥${good.marketPrice}</del>
                                </strong>
                            </dd>
                        [/#list]
                    [/@goods_list]
                </dl>
            </div>

            <div class="hotPromotion">
                <dl>
                    <dt>热销促销</dt>
                    [@promotion_list count=3 productCategoryId=productCategory.id]
                        [#if promotions?has_content]
                            [#list promotions as promotion ]
                                <dd>
                                    <a href="${ctx}/promotion/${promotion.id}" title="${promotion.name}">
                                        <img src="${promotion.image}" alt="${promotion.name}" />
                                    </a>
                                </dd>
                            [/#list]
                        [/#if]
                    [/@promotion_list]

                </dl>
            </div>
        </div>
        <div class="span10">
            <div class="breadcrumb">
                <ul>
                    <li>
                        <a href="${ctx}/index">首页</a>
                    </li>
                    [@product_category_parent_list productCategoryId=productCategory.id]
                        [#list productCategories as productCategory]
                            <li>
                                <a href="${ctx}/goods/list/${productCategory.id}">${productCategory.name}</a>
                            </li>
                        [/#list]
                    [/@product_category_parent_list]
                    <li>${productCategory.name}</li>
                </ul>
            </div>
            <form id="goodsForm" action="${ctx}/goods/list/${productCategory.id}" method="get">
                <input type="hidden" id="keyword" name="keyword" value="${goodsDto.keyword}" />
                <input type="hidden" id="orderType" name="sort" value="${goodsDto.sort}" />
                <input type="hidden" id="pageNumber" name="page" value="${goodsDto.page}" />
                <input type="hidden" id="pageSize" name="pageSize" value="${goodsDto.pageSize}" />
                <input type="hidden" id="brandId" name="brandId" value="${goodsDto.brandId}" />
                [#--筛选--]
                <div id="filter" class="filter">
                    <div class="title">筛选商品</div>
                    <div class="content">
                        [@product_category_children_list parentId = productCategory.id]
                            [#if productCategories?has_content]
                                <dl class="clearfix">
                                    <dt>分类:</dt>
                                    [#list productCategories as productCategory]
                                        <dd>
                                            <a href="${ctx}/goods/list/${productCategory.id}">${productCategory.name}</a>
                                        </dd>
                                    [/#list]
                                </dl>
                            [/#if]
                        [/@product_category_children_list]
                        [@brand_list productCategoryId = productCategory.id count=10]
                            [#if brands?has_content]
                                <dl class="clearfix">
                                    <dt>品牌:</dt>
                                    [#list brands as brand]
                                        <dd>
                                            <a href="javascript:;" class="brand[#if goodsDto.brandId==brand.id] current[/#if]" brandid="${brand.id}">${brand.name}</a>
                                        </dd>
                                    [/#list]
                                    [#--<dd class="moreOption" title="更多">&nbsp;</dd>--]
                                </dl>
                            [/#if]
                        [/@brand_list]
                    </div>

                    [#--分类属性--]
                    [@attribute_list productCategoryId = productCategory.id]
                        [#if attributes?has_content]
                            <div class="content">
                                [#list attributes as attribute]
                                    <dl class="clearfix">
                                        <dt>
                                            <input type="hidden" name="attributeValue${attribute.propertyIndex}" id="attributeValue${attribute.propertyIndex}">
                                            <span title="${attribute.name}">${attribute.name}:</span>
                                        </dt>
                                        [#list attribute.optionsList as option ]
                                            <dd>
                                                <a href="javascript:;" class="attribute[#if option == goodsDto.attributeValue0
                                                                                    || option == goodsDto.attributeValue1 || option == goodsDto.attributeValue2
                                                                                    || option == goodsDto.attributeValue3] current[/#if]" id="${attribute.propertyIndex}">${option}</a>
                                            </dd>
                                        [/#list]
                                        <dd class="moreOption" title="更多">&nbsp;</dd>
                                    </dl>
                                [/#list]
                            </div>
                        [/#if]
                    [/@attribute_list]

                    <div id="moreFilter" class="moreFilter">
                        &nbsp;
                    </div>
                </div>


                <div class="bar">
                    <div id="layout" class="layout">
                        <label>布局:</label>
                        <a href="javascript:;" id="gridType" class="gridType">
                            <span>&nbsp;</span>
                        </a>
                        <a href="javascript:;" id="listType" class="listType">
                            <span>&nbsp;</span>
                        </a>
                        <label>数量:</label>
                        <a href="javascript:;" class="size[#if paginator.limit == 20] current[/#if]" pageSize="20">
                            <span>20</span>
                        </a>
                        <a href="javascript:;" class="size[#if paginator.limit == 40] current[/#if]" pageSize="40">
                            <span>40</span>
                        </a>
                        <a href="javascript:;" class="size[#if paginator.limit == 80] current[/#if]" pageSize="80">
                            <span>80</span>
                        </a>
                        <span class="page">
                            [#if paginator.totalCount > 0]
                                <label>共${paginator.totalCount}个商品 ${paginator.page}/${paginator.totalPages}</label>
                                [#if paginator.hasPrePage]
                                    <a href="javascript:;" id="previousPage" class="previousPage">
                                        <span>上一页</span>
                                    </a>
                                [/#if]
                                [#if paginator.hasNextPage]
                                    <a href="javascript:;" id="nextPage" class="nextPage">
                                        <span>下一页</span>
                                    </a>
                                [/#if]
                            [/#if]
                        </span>
                    </div>
                    <div id="sort" class="sort">
                        <div id="orderMenu" class="orderMenu">
                            <span>${selectedSort}</span>
                            <ul>
                                <li orderType="">请选择</li>
                                [#list sorts as orderType]
                                    <li orderType="${orderType.sortType}">${orderType.showType}</li>
                                [/#list]
                                [#--<li orderType="is_top.desc">置顶降序</li>--]
                                [#--<li orderType="price.asc">价格升序</li>--]
                                [#--<li orderType="price.desc">价格降序</li>--]
                                [#--<li orderType="sales.desc">销量降序</li>--]
                                [#--<li orderType="score.desc">评分降序</li>--]
                                [#--<li orderType="create_date.desc">日期降序</li>--]
                            </ul>
                        </div>
                        <a href="javascript:;" class="asc[#if goodsDto.sort == 'price.asc'] current[/#if]" orderType="price.asc">价格</a>
                        <a href="javascript:;" class="desc[#if goodsDto.sort == 'sales.desc'] current[/#if]" orderType="sales.desc">销量</a>
                        <a href="javascript:;" class="desc[#if goodsDto.sort == 'score.desc'] current[/#if]" orderType="score.desc">评分</a>
                        <input type="text" id="startPrice" name="startPrice" class="startPrice" maxlength="16" title="价格过滤最低价格" onpaste="return false" />
                        <label>-</label>
                        <input type="text" id="endPrice" name="endPrice" class="endPrice" maxlength="16" title="价格过滤最高价格" onpaste="return false" />
                        <button type="submit">确 定</button>
                    </div>
                </div>
                <div id="result" class="result grid clearfix">
                    [#if resultList?has_content]
                        <ul>
                            [#list resultList as good]
                                <li>
                                    <a href="${ctx}/goods/content/${good.id}">
                                        <img src="${ctx}/upload/image/blank.gif" data-original="${good.image}" />
                                        <div>
                                            <span title="${good.name}">${good.name}</span>
                                            <em title="${good.caption}">${good.caption}</em>
                                        </div>
                                    </a>
                                    <strong>
                                        ￥${good.price}
                                        <del>￥${good.marketPrice}</del>
                                    </strong>
                                    <div class="action">
                                        <a href="javascript:;" class="addCart" goodId="${good.id}">加入购物车</a>
                                    </div>
                                </li>
                            [/#list]
                        </ul>
                    [#else]
                        <dl>
                            <dt>对不起，没有找到符合您检索条件的商品</dt>
                            <dd>1、请确认设置的检索条件是否正确</dd>
                            <dd>2、可尝试修改检索条件，以获得更多的搜索结果</dd>
                        </dl>
                    [/#if]

                </div>
                [#if paginator.totalPages > 1 ]
                    <div class="pagination">
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
                [/#if]
            </form>
        </div>
    </div>
</div>

[#include "include/footer.ftl"]
</body>
</html>