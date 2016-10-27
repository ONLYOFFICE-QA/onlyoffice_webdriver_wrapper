require 'spec_helper'

describe 'S3 service tests', :use_private_key do
  let(:s3) { OnlyofficeWebdriverWrapper::AmazonS3Wrapper.new }
  file_name = nil

  before :each do
    file_name = "#{SecureRandom.uuid}.ext"
  end

  it 'get all files' do
    files = s3.get_all_files
    expect(files.size).to be > 1
  end

  it 'get_files_by_prefix' do
    files = s3.get_files_by_prefix('docx')
    expect(files.size).to be > 1
  end

  it 'get_object' do
    object = s3.get_object('docx/Book.docx')
    expect(object.key).to eq('docx/Book.docx')
  end

  it 'download_object' do
    object = s3.get_object('docx/Book.docx')
    s3.download_object(object)
    expect(File.exist?("#{s3.download_folder}/#{object.key.split('/').last}")).to be_truthy
  end

  it 'download_file_by_name' do
    s3.download_file_by_name('docx/Book.docx')
    expect(File.exist?("#{s3.download_folder}/Book.docx")).to be_truthy
  end

  it 'upload_file' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    expect(s3.get_files_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file with slash in the beginning of the path line' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", '/test')
    expect(s3.get_files_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file with slash in the end of the path line' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test/')
    expect(s3.get_files_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'delete_file' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    s3.delete_file("test/#{file_name}")
    expect(s3.get_files_by_prefix('test')).not_to include("test/#{file_name}")
  end

  it 'delete_file with slash in the beginning of the path line' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    s3.delete_file("/test/#{file_name}")
    expect(s3.get_files_by_prefix('test')).not_to include("test/#{file_name}")
  end

  it 'make_public' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    permissions = s3.make_public("test/#{file_name}")
    expect(permissions.is_a?(String)).to be_truthy
  end

  it 'make_public negative' do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    s3.make_public("test/#{file_name}")
    permissions = s3.get_permission_by_link("test/#{file_name}")
    expect(permissions.grants[1].permission.name).to eq(:read)
    expect(permissions.grants[1].grantee.uri.match(%r{ \/\w*\z }).to_s).to eq('/AllUsers')
  end

  describe 'attributes', :use_private_key do
    it { expect(s3).to have_attributes(s3: AWS::S3) }
    it { expect(s3).to have_attributes(bucket: AWS::S3::Bucket) }
    it { expect(s3).to have_attributes(download_folder: '/tmp/amazon') }
    it { expect(s3).to_not have_attributes(access_key_id: nil) }
    it { expect(s3).to_not have_attributes(secret_access_key: nil) }
    it { expect(AmazonS3Wrapper.new('access_key_id', 'secret_access_key')).to have_attributes(access_key_id: 'access_key_id') }
    it { expect(AmazonS3Wrapper.new('access_key_id', 'secret_access_key')).to have_attributes(secret_access_key: 'secret_access_key') }
  end

  after :each do
    FileHelper.delete_directory(s3.download_folder)
  end
end
