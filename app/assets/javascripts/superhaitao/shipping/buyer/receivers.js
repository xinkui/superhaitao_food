$(document).ready(function() {
//    alert(!window.opener.location);
    if (!window.opener) {
        $('table tr').find('*:eq(0)').hide();
    } else {
        $("a[name='btn_edit']").hide();
        $("a[name='btn_delete']").hide();
        $('#btn-back').hide();
    }
});

/*选择发件人时刷新package页面信息*/
function choose_receiver(receiver_id, receiver_message) {
    var obj = window.opener.$('#order_receiver_id_'+receiver_id);
    var receiver_radio_buttons = window.opener.$("input[name='order[receiver_id]']");
    if(obj.length > 0) {/*package界面已存在选中的receiver的radioButton则直接选中*/
        obj.click();
    } else {/*package界面不存在选择的receiver的radioButton*/
        var new_receiver_label = window.opener.document.getElementById('expandReceiverRadio');
        var new_receiver_input = window.opener.document.getElementById('order_receiver_id_n');
        new_receiver_input.value = receiver_id;
        if( new_receiver_label.style.display == 'none') {/*隐藏的id为expandreceiverRadio还未显示在修改其html属性并添加到radio控件组里面*/
            new_receiver_label.innerHTML += receiver_message;
            var div_controls;
            if(receiver_radio_buttons.length == 1) {/*如果length为1则表示界面上没有收件人信息,1为预置的收件人节点,需要找到收件人下的div节点,添加新的收件人信息*/
                div_controls = new_receiver_label.parentElement.firstElementChild.lastElementChild
            } else {/*如果length不等于1则表示界面上有收件人信息，需要找到他们的父节点，添加新的收件人信息*/
                div_controls = receiver_radio_buttons[0].parentElement.parentElement;
            }
            new_receiver_label.style.display='block';
            div_controls.appendChild(new_receiver_label);
        } else {/*直接修改其html和child属性*/
            new_receiver_label.innerHTML = "";
            new_receiver_label.appendChild(new_receiver_input);
            new_receiver_label.innerHTML += receiver_message;
        }
        new_receiver_label.click();
    }
    window.close();
}