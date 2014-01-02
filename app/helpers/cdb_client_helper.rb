module CdbClientHelper

  def cdb_url(path)
    URI.join(cdb_host, path).to_s
  end

  def cdb_host
    Settings.cdb[:asset_host] ||= Settings.cdb.host
    Settings.cdb[:protocol] ||= 'http'
    "#{Settings.cdb.protocol}://#{Settings.cdb.asset_host}"
  end

end
