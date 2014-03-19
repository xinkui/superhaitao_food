$(document).ready(function () {
    if ($('#search_state_eq') && $('#search_state_eq').val() != '') {
        $('#q_state_eq').find("option[value=" + $('#search_state_eq').val() + "]").attr("selected", true);
    }

    $('#barcode').keypress(function(event) {
        if (event.keyCode == 13) {
            get_sku_ajax();
        } else {
            $('#item_sku_id').val('');
        }
    });

    $('#btn-save-item').click(function() {
        if ($('#item_sku_id').val() == '') {
            alert('请选择正确的SKU信息!');
        } else {
            document.forms[0].submit();
        }
    });
});

function get_sku_ajax() {
    var barcode = $('#barcode').val();
    if (barcode == "") {
        return;
    }
    $.ajax({
        type: "put",
        url: "/shipping/admin/skus/get_sku_ajax",
        data: { barcode: barcode }
    }).done(function (json) {
        if (json == '') {
            $("#div-sku-message").css("display", "block");
            $('#item_sku_id').val('');
            $("#sku-name").html('');
            $("#sku-length").html('');
            $("#sku-width").html('');
            $("#sku-height").html('');
            $("#sku-volume").html('');
            $("#sku-actual_weight").html('');
            $("#sku-remark").html('');
        } else {
            $("#div-sku-message").css("display", "none");
            var sku = json[0];
            $('#item_sku_id').val(sku.id);
            $("#sku-name").html(sku.name);
            $("#sku-length").html(sku.length);
            $("#sku-width").html(sku.width);
            $("#sku-height").html(sku.height);
            $("#sku-volume").html(sku.volume);
            $("#sku-actual_weight").html(sku.actual_weight);
            $("#sku-remark").html(sku.remark);
        }
    });
}