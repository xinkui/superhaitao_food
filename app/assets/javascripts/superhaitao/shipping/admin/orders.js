$(document).ready(function(){
    if ($('#search_state_eq') && $('#search_state_eq').val() != '') {
        $('#q_state_eq').find("option[value=" + $('#search_state_eq').val() + "]").attr("selected", true);
    }

    $('#btn_checked').click(function() {
        if (confirm('确认审核吗?')) {
            document.forms[0].submit();
        }
    });
    $('#ship_order_form').submit(function() {
        return confirm('确认发货吗?');
    });
});