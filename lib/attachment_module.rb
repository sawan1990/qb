module AttachableBase

  module ClassMethods
    def can_have_attachments options={}
      has_many	:attachments, :as => :attachable, :dependent => :destroy

      include AttachableModule::InstanceMethods
      extend AttachableModule::ClassMethods

      validate :validation
      options[:max].nil? ? set_max_attachments_allowed : set_max_attachments_allowed(options[:max])
    end
  end
end

module AttachableModule
  module ClassMethods
    def self.extended(base)
      @@max_attachments_allowed = 0
    end

    def max_attachments_allowed
      @@max_attachments_allowed
    end

    def set_max_attachments_allowed(max=2)
      @@max_attachments_allowed = max
    end
  end

  module InstanceMethods
    def validation
      attachments_errors.each{ |att_err| errors.add(:attachment,att_err) }
    end

    def attachments_errors
      @attachments_errors ||=[]
    end

    def save_attachments(attachments)
      return true if attachments.blank?
      @attachments_errors = []
      attachments.first(self.class.max_attachments_allowed).each do |attachment|
        next if attachment.blank?
        new_attachment = self.attachments.build({:upload=>attachment})
        unless new_attachment.valid?
          attachments_errors << "Attachment - #{new_attachment.upload_file_name}: File type is not allowed. Allowed file types are images, pdf, msword, text files." unless new_attachment.errors[:upload_content_type].empty?
          attachments_errors << "Attachment - #{new_attachment.upload_file_name}: Invalid file size, allowed upto 5 MB." unless new_attachment.errors[:upload_file_size].empty?
        end
      end
    end

    def image_attachments
      attachments.select { |attachment| attachment.image? }
    end

    def non_image_attachments
      attachments.select { |attachment| !attachment.image? }
    end

    def first_image_attachment
      image_attachments.first
    end
  end
end