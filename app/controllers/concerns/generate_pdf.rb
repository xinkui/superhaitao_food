require 'rubygems'
require 'chinese_pinyin'
class GeneratePdf < Prawn::Document

  def generate_receiver_pdf(order)
    font "#{Rails.root}/app/assets/fonts/simfang.ttf"
    font_size(30) { text_box order.get_items_weight.to_s + 'KG' }
    svg order.barcode_data(xdim: 1, height: 60), at: [100, 730]
    font_size(15) { text_box order.get_barcode, at: [120, 740] }
    text ' '
    font_size(15) { text '姓名: ' + order.receiver.name + '(' +
                             Pinyin.t(order.receiver.name, camelcase: true) + ')   ' +
                             '电话: ' + order.receiver.phone }
    text ' '
    font_size(15) { text '地址: ' + order.receiver.get_receiver_address }
    text ' '
    font_size(15) { text '邮编: ' + order.receiver.zip_code }
    text ' '
    font_size(15) { text 'SENDER ADDRESS:' }
    font_size(15) { text 'YUNJI CHEN' }
    font_size(15) { text 'Siemensstr.14, D-41469, Neuss, Germany' }
    font_size(15) { text 'Mobile: 0049-1796390366' }
    render
  end

end