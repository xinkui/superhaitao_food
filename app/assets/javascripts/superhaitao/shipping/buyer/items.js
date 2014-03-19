$(document).ready(function () {
    $('#btn-create-order').click(function () {
        if ($('input[name="item_list[]"]:checked').length > 1) {
            if (confirm('您勾选的多个货品将作为一个订单发货, 确定吗?')) {
                document.forms[0].submit();
            }
        } else {
            document.forms[0].submit();
        }
    });
});
