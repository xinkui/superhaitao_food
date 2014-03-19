$(document).ready(function () {
    if ($('#search_state_eq').val() != '') {
        $('#q_state_eq').find("option[value=" + $('#search_state_eq').val() + "]").attr("selected", true);
    }
    if ($('#search_role_eq').val() != '') {
        $('#q_role_eq').find("option[value=" + $('#search_role_eq').val() + "]").attr("selected", true);
    }
});
