require 'aws-sdk-v1'
require 'aws/s3'
module OnlyofficeWebdriverWrapper
  class AmazonS3Wrapper
    attr_accessor :s3, :bucket, :download_folder, :access_key_id, :secret_access_key

    def initialize(access_key_id = nil, secret_access_key = nil, bucket_name: 'nct-data-share')
      if access_key_id.nil? || secret_access_key.nil?
        begin
          @access_key_id = File.read(Dir.home + '/.s3/key').delete("\n")
          @secret_access_key = File.read(Dir.home + '/.s3/private_key').delete("\n")
        rescue Errno::ENOENT
          raise Errno::ENOENT, "No key or private key found in #{Dir.home}/.s3/ directory. Please create files #{Dir.home}/.s3/key and #{Dir.home}/.s3/private_key"
        end
      else
        @access_key_id = access_key_id
        @secret_access_key = secret_access_key
      end
      AWS.config(access_key_id: @access_key_id,
                 secret_access_key: @secret_access_key,
                 region: 'us-west-2')
      @s3 = AWS::S3.new
      @bucket = @s3.buckets[bucket_name]
      @download_folder = Dir.mktmpdir('amazon-s3-downloads')
    end

    def get_all_files
      LoggerHelper.print_to_log("Find all files and folders from #{@bucket.name} bucket")
      files_name = {}
      @bucket.objects.each do |obj|
        files_name.merge!(obj.key => obj)
      end
      files_name
    end

    def get_files_by_prefix(prefix)
      objects_array = @bucket.objects.with_prefix(prefix).collect(&:key)
      objects_array.delete_at(0) # First element - is a /prefix directory
      objects_array
    end

    def get_object(obj_name)
      @bucket.objects[obj_name]
    end

    def download_file_by_name(file_name, download_folder = @download_folder)
      LoggerHelper.print_to_log("Download file with name #{file_name} to folder #{download_folder}")
      LoggerHelper.print_to_log('Try to find file:')
      object = get_object(file_name)
      download_object(object, download_folder)
    end

    def download_object(object, download_folder = @download_folder)
      LoggerHelper.print_to_log("Try to download object with name #{object.key} to folder #{download_folder}")
      File.open("#{download_folder}/#{File.basename(object.key)}", 'wb') do |file|
        object.read do |chunk|
          file.write(chunk)
        end
      end
      LoggerHelper.print_to_log("File with name #{object.key} successfully downloaded to folder #{download_folder}")
    rescue StandardError
      raise("File with name #{object.key} is not found un bucket #{@bucket.name}")
    end

    def upload_file(file_path, upload_folder)
      upload_folder.sub!('/', '') if upload_folder[0] == '/'
      upload_folder.chop! if upload_folder[-1] == '/'
      @bucket.objects["#{upload_folder}/#{File.basename(file_path)}"].write(file: file_path)
    end

    def make_public(file_path)
      @bucket.objects[file_path].acl = :public_read
      @bucket.objects[file_path].public_url.to_s
    end

    def get_permission_by_link(file_path)
      @bucket.objects[file_path].acl
    end

    def upload_file_and_make_public(file_path, upload_folder)
      upload_file(file_path, upload_folder)
      make_public("#{upload_folder}/#{File.basename(file_path)}")
      @bucket.objects["#{upload_folder}/#{File.basename(file_path)}"].public_url
    end

    def delete_file(file_path)
      file_path.sub!('/', '') if file_path[0] == '/'
      get_object(file_path).delete
    end
  end
end
