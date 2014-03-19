require 'rubygems'
require 'chinese_pinyin'
class GenerateWaybillJob

  def generate_waybill
    file_path_root = "#{Rails.root}/app/assets/csv"
    unless File.exist?(file_path_root)
      Dir.mkdir(file_path_root)
    end
    orders = Order.includes(:receiver).where('is_generate_waybill = false')
    if orders.length > 0
      time = DateTime.now
      has_bpost = false
      content_dhl = ''
      content_bpost = ''
      return_dhl = ''
      return_bpost = ''
      create_file_path(file_path_root, time)
      content_bpost_head = create_bpost_file_head

      orders.each do |order|
        if order.international_waybill_company == 'DHL'
          content_dhl += return_dhl
          content_dhl += create_dhl_file(order)
          return_dhl = "\n"
        else
          has_bpost = true
          content_bpost += return_bpost
          content_bpost += create_bpost_file(order)
          return_bpost = "\n"
        end
        order.is_generate_waybill = true
        order.save
      end

      File.open("#{file_path_root}/dhl/#{time.strftime('%Y%m%d%H%M%S').to_s}" + '/dhl.txt', 'wb') do |f|
        f.write(content_dhl)
        f.close
      end

      if has_bpost
        File.open("#{file_path_root}/bpost/#{time.strftime('%Y%m%d%H%M%S').to_s}" + '/bpost.txt', 'wb:ASCII') do |f|
          f.write(content_bpost_head + content_bpost)
          f.close
        end
      end
      Shipping::Admin::CsvMailer.send_csv_mail(has_bpost, time, file_path_root).deliver
    end
  end

  private
  def create_file_path(file_path_root, time)
    file_path_dhl = "#{file_path_root}/dhl/#{time.strftime('%Y%m%d%H%M%S').to_s}"
    unless File.exist?(file_path_dhl)
      Dir.mkdir(file_path_dhl)
    end
    file_path_bpost = "#{file_path_root}/bpost/#{time.strftime('%Y%m%d%H%M%S').to_s}"
    unless File.exist?(file_path_bpost)
      Dir.mkdir(file_path_bpost)
    end
  end

  def create_dhl_file(order)
    address1 = ''
    address_temp = ''
    address2 = ''
    address3 = ''
    receiver = order.receiver
    if receiver.get_receiver_address.length > 40
      address1 = receiver.get_receiver_address[0..40]
      address_temp = receiver.get_receiver_address[0..40]
      if address_temp.length > 40
        address2 = address_temp[0..40]
        address3 = address_temp[40..address_temp.length]
      end
    else
      address1 = receiver.get_receiver_address
    end
    content = order.get_barcode # Ref.No,用我们包裹号
    content += '|'
    content += Pinyin.t(receiver.name, camelcase: true) # 收件人1栏
    content += '|'
    content += Pinyin.t(address2, camelcase: true) # 收件人2栏
    content += '|'
    content += Pinyin.t(address3, camelcase: true) # 收件人3栏
    content += '|'
    content += receiver.zip_code # 邮编
    content += '|'
    content += receiver.city.pinyin # 城市
    content += '|'
    content += Pinyin.t(address1, camelcase: true) # 地址
    content += '|'
    content += '' #门牌
    content += '|'
    content += receiver.phone # 手机
    content += '|'
    content += order.user.email # 邮件地址
    content += '|'
    content += order.get_items_weight.to_s # 重量
    content += '|'
    content += Pinyin.t(receiver.get_receiver_address, camelcase: true) +
        Pinyin.t(receiver.name, camelcase: true) + ' ' + receiver.zip_code + ' ' + receiver.phone # 备注
    content += '|'

    items = get_item_by_order_id(order.id)
    i = 0
    comm = ''
    items.each do |item|
      i += 1
      if i <= 3
        content += comm
        content += item['sku_name'] + ' * ' + item['num'].to_s # 品名
        content += ';'
        content += 'Germany' # 原产地
        content += ';'
        content += '' # 海关编码
        content += ';'
        content += (item['weight'] * item['num']).to_s # 重量
        content += ';'
        content += (item['purchase_price'] * item['num']).to_s # 价值
        comm = ';'
      end
    end

    content += '|'
  end

  def create_bpost_file_head
    content = ''
    time = Time.now
    content += 'BPI/2013/7775' # 合同号
    content += '|'
    content += time.strftime('%d/%m/%Y').to_s # 日期
    content += '|'
    if time.strftime('%H').to_i < 12
      content += 'AM'
    else
      content += 'PM'
    end
    content += '|'
    content += 'C&X GmbH' # 公司名
    content += '|'
    content += '31SL02' # 产品号（国际包裹）
    content += "\n"
  end

  def create_bpost_file(order)
    receiver = order.receiver
    content = 'YUNJI CHEN' # 寄件人
    content += '|'
    content += '|'
    content += '|'
    content += 'Siemensstr.' # 寄件人街道
    content += '|'
    content += '14' # 门牌
    content += '|'
    content += '|'
    content += '41469' # 邮编
    content += '|'
    content += 'Neuss' # 城市
    content += '|'
    content += '|'
    content += 'DE' # 国家
    content += '|'
    content += '|'
    content += '|'
    content += '|'
    content += Pinyin.t(receiver.name, camelcase: true) # 收件人
    content += '|'
    content += '' # 部门
    content += '|'
    content += Pinyin.t(receiver.name, camelcase: true) # 联系人
    content += '|'
    content += receiver.get_receiver_address.length > 40 ?
        Pinyin.t(receiver.get_receiver_address[0..40], camelcase: true) :
        Pinyin.t(receiver.get_receiver_address, camelcase: true) # 地址
    content += '|'
    content += '*' # 门牌
    content += '|'
    content += '|'
    content += receiver.zip_code # 邮编
    content += '|'
    content += receiver.city.pinyin # 城市
    content += '|'
    content += receiver.province.pinyin # 省/州
    content += '|'
    content += 'CN' # 国家 目前只有中国
    content += '|'
    content += receiver.phone # 电话
    content += '|'
    content += order.user.email # 邮箱
    content += '|'
    content += receiver.phone # 手机
    content += '|'
    content += order.get_items_weight.to_s # 重量
    content += '|'
    items = get_item_by_order_id(order.id)
    item = items[0]
    content += item['sku_name'] + ' * ' + item['num'].to_s # 物品明细
    content += '|'
    content += item['category_name'] # 类别
    content += '|'
    content += 'RTA'
    content += '|'
    content += (item['purchase_price'] * item['num']).to_s # 价值
    content += '|'
    content += 'RMB' # 货币
    content += '|'
    content += 'N'
    content += '|'
    content += order.get_barcode # 参考号：可用我们的包裹号
    content += "\n"
  end

  def get_item_by_order_id(order_id)
    Item.unscoped
      .joins(:order, :sku, 'INNER JOIN CATEGORIES AS CATEGORY ON SKUS.CATEGORY_ID = CATEGORY.ID')
      .select('items.id, items.weight, count(skus.barcode) as num,
              skus.name_en as sku_name, category.name_en as category_name, skus.purchase_price')
      .where('orders.id = ?', order_id).group('skus.barcode')
      .order('skus.purchase_price desc')
  end
end
