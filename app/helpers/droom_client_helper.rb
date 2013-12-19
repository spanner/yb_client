module DroomClientHelper

  def cdb_url(path)
    URI.join(cdb_host, path).to_s
  end

  def droom_url(path)
    URI.join(droom_host, path).to_s
  end

  def droom_asset_url(path)
    URI.join(droom_asset_host, Settings.droom.asset_path, path).to_s
  end

  def droom_host
  "#{Settings.droom.protocol}://#{Settings.droom.host}"
  end

  def cdb_host
  "#{Settings.cdb.protocol}://#{Settings.cdb.host}"
  end

  def droom_asset_host
    "http://#{Settings.droom.asset_host}"
  end

end
