$(document).ready(function(){

    /*禁止页面回退*/
    window.history.forward(1);

    total_price = $('#total_price');
    user_point = $('#user_point');
    chk_point = $('#chk_point');
    trade_point = $('#trade_point');
    btn_submit = $('#btn_submit');
    trade_point_format_error = $('#trade_point_format_error');
    div_trade_point = $('#div_trade_point');
    txt_balloon = $('#txt_balloon');
    btn_submit_order = $('#btn_submit_order');
    balloon_format_error = $('#balloon_format_error');
    div_balloon = $('#div_balloon');
    trade_point_larger_then_user_point_error = $('#trade_point_larger_then_user_point_error');
    trade_point_larger_then_total_price_error = $('#trade_point_larger_then_total_price_error');
    init_open_payment_page();
    chk_point_bind_checked();
    trade_point_bind_property_change();

    $('#chk_firm_package').click(function() {
        cal_order_total_price();
    });

    txt_balloon.bind('propertychange input', function() {
        if (txt_balloon.val() == '' || /^\d+(?=\{0,1}\d+$|$)/.test(txt_balloon.val())) {
            balloon_format_error.hide();
            btn_submit_order.removeAttr('disabled');
            div_balloon.removeClass('has-error');
            cal_order_total_price();
        } else {
            balloon_format_error.show();
            trade_point_larger_then_user_point_error.hide();
            btn_submit_order.attr('disabled', 'disabled');
            div_balloon.addClass('has-error');
        }
    });

});

var trade_point_bind_property_change = function() {
    trade_point.bind('propertychange input', function() {
        if (trade_point.val() == '' || /^\d+(?=\.{0,1}\d+$|$)/.test(trade_point.val())) {
            trade_point_format_error.hide();
            btn_submit.removeAttr('disabled');
            div_trade_point.removeClass('has-error');
        } else {
            trade_point_format_error.show();
            trade_point_larger_then_user_point_error.hide();
            btn_submit.attr('disabled', 'disabled');
            div_trade_point.addClass('has-error');
            return;
        }

        if (Number(trade_point.val()) > Number($.trim(total_price.text()))) {
            trade_point_larger_then_total_price_error.show();
            btn_submit.attr('disabled', 'disabled');
            div_trade_point.addClass('has-error');
            return;
        }

        if (Number(trade_point.val()) > Number($.trim(user_point.text()))) {
            trade_point_larger_then_user_point_error.show();
            btn_submit.attr('disabled', 'disabled');
            div_trade_point.addClass('has-error');
        } else {
            trade_point_larger_then_total_price_error.hide();
            trade_point_larger_then_user_point_error.hide();
            btn_submit.removeAttr('disabled');
            div_trade_point.removeClass('has-error');
            cal_alipay_price();
        }
    });
};

var total_price;
var user_point;
var chk_point;
var trade_point;
var btn_submit;
var trade_point_format_error;
var div_trade_point;
var trade_point_larger_then_user_point_error;
var trade_point_larger_then_total_price_error;
var txt_balloon;
var btn_submit_order;
var balloon_format_error;
var div_balloon;

var cal_order_total_price = function() {
    var is_firm_package = null;
    if($('#chk_firm_package').attr('checked')) {
        is_firm_package = true;
    }
    var balloon = txt_balloon.val();
    var order_id = $('#order_id').val();
    $.ajax({
        type: "put",
        url: "/shipping/buyer/orders/cal_order_total_price_ajax",
        data: { is_firm_package: is_firm_package, balloon_num: balloon, id: order_id }
    }).done(function(total_price) {
        $('#lbl_total_price').text(total_price);
    });
};


var init_open_payment_page = function() {
    if (Number(user_point.text()) != 0) {
        trade_point.attr('disabled', 'disabled');
    } else {
        chk_point.attr('disabled', 'disabled');
        trade_point.attr('disabled', 'disabled');
    }
};

var chk_point_bind_checked = function() {
    chk_point.click(function() {
        if (chk_point.attr('checked')) {
            trade_point.removeAttr('disabled');
        } else {
            trade_point.val('');
            trade_point.attr('disabled', 'disabled');
            btn_submit.removeAttr('disabled');
            div_trade_point.removeClass('has-error');
            trade_point_format_error.hide();
            trade_point_larger_then_user_point_error.hide();
            trade_point_larger_then_total_price_error.hide();
            cal_alipay_price();
        }
        if (Number(trade_point.val()) <= Number($.trim(user_point.text()))) {
            cal_alipay_price();
        }
    });
};

var cal_alipay_price = function() {
    var price = 0.0;
    var alipay_price = $('#alipay_price');
    if (chk_point.attr('checked')) {
        price = floatSub($.trim(total_price.text()), trade_point.val());
        alipay_price.text(price <= 0 ? 0.0 : price);
    } else {
        alipay_price.text($.trim(total_price.text()));
    }
};

/**
 * 浮点数加法运算
 * @return {string}
 */
var floatAdd = function(arg1, arg2) {
    var r1, r2, m;
    try {
        r1 = arg1.toString().split(".")[1].length
    } catch (e) {
        r1 = 0
    }
    try {
        r2 = arg2.toString().split(".")[1].length
    } catch (e) {
        r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    var result = (arg1 * m + arg2 * m) / m + "";
    var reg = /^(-|\+)?\d+\.\d*$/;

    if (reg.test(result)) {
        return result;
    } else {
        return parseFloat(result).toFixed(1);
    }

};

/**
 * 浮点数减法运算
 * @return {float}
 */
var floatSub = function(arg1, arg2) {
    var r1, r2, m, n;
    try {
        r1 = arg1.toString().split(".")[1].length
    } catch (e) {
        r1 = 0
    }
    try {
        r2 = arg2.toString().split(".")[1].length
    } catch (e) {
        r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //动态控制精度长度
    n = (r1 >= r2) ? r1 : r2;
    return ((arg1 * m - arg2 * m) / m).toFixed(n);
};