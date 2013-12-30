module CdbClientHelper

  def cdb_url(path)
    URI.join(cdb_host, path).to_s
  end

  def cdb_host
  "#{Settings.cdb.protocol}://#{Settings.cdb.host}"
  end

end
