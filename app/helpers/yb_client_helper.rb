module YbClientHelper

  def yb_url(path)
    URI.join(yb_host, path).to_s
  end

  def yb_host
    Settings.yearbook[:protocol] ||= 'http'
    "#{Settings.yearbook.protocol}://#{Settings.yearbook.api_host}"
  end

end
