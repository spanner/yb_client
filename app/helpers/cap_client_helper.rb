module CapClientHelper

  def cap_url(path)
    URI.join(cap_host, path).to_s
  end

  def cap_host
    Settings.cap[:protocol] ||= 'http'
    "#{Settings.cap.protocol}://#{Settings.cap.host}"
  end

end
