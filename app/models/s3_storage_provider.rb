class S3StorageProvider < StorageProvider
  def configure
  end

  def is_ready?
  end

  def initialize_project(project)
  end

  def is_initialized?(project)
  end

  def initialize_chunked_upload(upload)
  end

  def endpoint
  end

  def chunk_max_reached?(chunk)
  end

  def max_chunked_upload_size
  end

  def suggested_minimum_chunk_size(upload)
  end

  def chunk_upload_url(chunk)
  end

  def download_url(upload, filename=nil)
  end

  def purge(object)
  end
end
