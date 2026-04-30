require 'rqrcode'

helpers do
  def qr_code_svg(url)
    qrcode = RQRCode::QRCode.new(url)
    qrcode.as_svg(module_size: 3)
  end
end
