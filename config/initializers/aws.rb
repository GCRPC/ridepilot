Aws.config.update(
  credentials: Aws::Credentials.new(
    ENV['AWS_KEY_ID'],
    ENV['AWS_ACCESS_KEY'])
)

S3_BUCKET =  Aws::S3::Resource.new.bucket(ENV['AWS_BUCKET'])