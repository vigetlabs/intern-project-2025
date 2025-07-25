class SoundSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :tag_ids

   attribute :audio_file_url do |object|
    if object.audio_file.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.audio_file, only_path: true)
    end
  end
end
